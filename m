Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab3FRMEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:04:45 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:38983 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200Ab3FRMEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 08:04:43 -0400
Date: Tue, 18 Jun 2013 14:04:38 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Anish Singh <anish198519851985@gmail.com>, eranian@google.com
Subject: Re: [PATCH 4/6] watchdog: Boot-disable by default on full dynticks
Message-ID: <20130618120436.GA17619@somewhere.redhat.com>
References: <1371045758-5296-1-git-send-email-fweisbec@gmail.com>
 <1371045758-5296-5-git-send-email-fweisbec@gmail.com>
 <20130612170316.GO133453@redhat.com>
 <20130613131057.GA15997@somewhere>
 <20130613140207.GW133453@redhat.com>
 <20130618103632.GO3204@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130618103632.GO3204@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 12:36:32PM +0200, Peter Zijlstra wrote:
> On Thu, Jun 13, 2013 at 10:02:07AM -0400, Don Zickus wrote:
> > On Thu, Jun 13, 2013 at 03:10:59PM +0200, Frederic Weisbecker wrote:
> > > On Wed, Jun 12, 2013 at 01:03:16PM -0400, Don Zickus wrote:
> > > > On Wed, Jun 12, 2013 at 04:02:36PM +0200, Frederic Weisbecker wrote:
> > > > > When the watchdog runs, it prevents the full dynticks
> > > > > CPUs from stopping their tick because the hard lockup
> > > > > detector uses perf events internally, which in turn
> > > > > rely on the periodic tick.
> > > > > 
> > > > > Since this is a rather confusing behaviour that is not
> > > > > easy to track down and identify for those who want to
> > > > > test CONFIG_NO_HZ_FULL, let's default disable the
> > > > > watchdog on boot time when full dynticks is enabled.
> > > > > 
> > > > > The user can still enable it later on runtime using
> > > > > proc or sysctl.
> > > > 
> > > > I thought we had a conversation awhile ago, where we agreed this was going
> > > > to be fixed for 3.11?  Didn't Peter find the patch and apply it to his
> > > > tree?  I am confused why this is still needed?
> > > 
> > > We agreed on the patch but it hasn't been applied yet. I'm trying to get
> > > a sane series of nohz patches before sending to Ingo.
> > 
> > Peter,
> > 
> > Where is this patch?
> > 
> 
> 9e6302056f8029f438e853432a856b9f13de26a6
> 62b8563979273424d6ebe9201e34d1acc133ad4f
> 
> made it in, it does need a little additional work; something like the
> below might be a start:
> 
> Aside from doing the NOHZ thing there's also a partial fix for event migration
> since I now noticed we have per-cpu counters for various event types.
> 
> Very much needs more work but shows what would be needed

I see. So what do you think, should I push my patch that deactivates
the watchdog to Ingo until this below patch gets ready? It would be nice to
have a solution for 3.11.

If you prefer I can work on getting your below proposal into shape. I'm on
vacancies next week but I can try to get it ready until the next merge window
closes.

Thanks.

> 
> ---
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -139,8 +139,11 @@ enum event_type_t {
>   * perf_cgroup_events: >0 per-cpu cgroup events exist on this cpu
>   */
>  struct static_key_deferred perf_sched_events __read_mostly;
> +
> +/* do we really need the atomic thing? */
>  static DEFINE_PER_CPU(atomic_t, perf_cgroup_events);
>  static DEFINE_PER_CPU(atomic_t, perf_branch_stack_events);
> +static DEFINE_PER_CPU(atomic_t, perf_freq_events);
>  
>  static atomic_t nr_mmap_events __read_mostly;
>  static atomic_t nr_comm_events __read_mostly;
> @@ -2791,6 +2794,17 @@ bool perf_event_can_stop_tick(void)
>  }
>  #endif
>  
> +void perf_kick_nohz_cpu(void)
> +{
> +	/* magic to drop out of NOHZ mode */
> +}
> +
> +bool perf_event_needs_cpu(void)
> +{
> +	return atomic_read(&__get_cpu_var(perf_freq_events)) || 
> +	       __this_cpu_read(perf_throttled_count);
> +}
> +
>  void perf_event_task_tick(void)
>  {
>  	struct list_head *head = &__get_cpu_var(rotation_list);
> @@ -3101,6 +3115,28 @@ static void free_event_rcu(struct rcu_he
>  static void ring_buffer_put(struct ring_buffer *rb);
>  static void ring_buffer_detach(struct perf_event *event, struct ring_buffer *rb);
>  
> +static void __account_event(struct perf_event *event)
> +{
> +	if (is_cgroup_event(event))
> +		atomic_inc(&per_cpu(perf_cgroup_events, event->cpu));
> +	if (has_branch_stack(event) && !(event->attach_state & PERF_ATTACH_TASK))
> +		atomic_inc(&per_cpu(perf_branch_stack_events, event->cpu));
> +	if (event->attr.freq) {
> +		atomic_inc(&per_cpu(perf_freq_events, event->cpu));
> +		perf_kick_nohz_cpu();
> +	}
> +}
> +
> +static void __unaccount_event(struct perf_event *event)
> +{
> +	if (is_cgroup_event(event))
> +		atomic_dec(&per_cpu(perf_cgroup_events, event->cpu));
> +	if (has_branch_stack(event) && !(event->attach_state & PERF_ATTACH_TASK))
> +		atomic_dec(&per_cpu(perf_branch_stack_events, event->cpu));
> +	if (event->attr.freq)
> +		atomic_dec(&per_cpu(perf_freq_events, event->cpu));
> +}
> +
>  static void free_event(struct perf_event *event)
>  {
>  	irq_work_sync(&event->pending);
> @@ -3116,19 +3152,12 @@ static void free_event(struct perf_event
>  			atomic_dec(&nr_task_events);
>  		if (event->attr.sample_type & PERF_SAMPLE_CALLCHAIN)
>  			put_callchain_buffers();
> -		if (is_cgroup_event(event)) {
> -			atomic_dec(&per_cpu(perf_cgroup_events, event->cpu));
> +		if (is_cgroup_event(event))
>  			static_key_slow_dec_deferred(&perf_sched_events);
> -		}
> -
> -		if (has_branch_stack(event)) {
> +		if (has_branch_stack(event))
>  			static_key_slow_dec_deferred(&perf_sched_events);
> -			/* is system-wide event */
> -			if (!(event->attach_state & PERF_ATTACH_TASK)) {
> -				atomic_dec(&per_cpu(perf_branch_stack_events,
> -						    event->cpu));
> -			}
> -		}
> +
> +		__unaccount_event(event);
>  	}
>  
>  	if (event->rb) {
> @@ -5149,6 +5178,7 @@ static int __perf_event_overflow(struct
>  		if (unlikely(throttle
>  			     && hwc->interrupts >= max_samples_per_tick)) {
>  			__this_cpu_inc(perf_throttled_count);
> +			perf_kick_nohz_cpu(); /* XXX we're in NMI context */
>  			hwc->interrupts = MAX_INTERRUPTS;
>  			perf_log_throttle(event, 0);
>  			ret = 1;
> @@ -6544,6 +6574,7 @@ perf_event_alloc(struct perf_event_attr
>  			atomic_inc(&nr_task_events);
>  		if (event->attr.sample_type & PERF_SAMPLE_CALLCHAIN) {
>  			err = get_callchain_buffers();
> +			/* XXX this error patch leaks the above counts */
>  			if (err) {
>  				free_event(event);
>  				return ERR_PTR(err);
> @@ -6845,11 +6876,20 @@ SYSCALL_DEFINE5(perf_event_open,
>  		 * one more event:
>  		 * - that has cgroup constraint on event->cpu
>  		 * - that may need work on context switch
> +		 *
> +		 * assumes inherited counters don't have flags set.
>  		 */
> -		atomic_inc(&per_cpu(perf_cgroup_events, event->cpu));
>  		static_key_slow_inc(&perf_sched_events.key);
>  	}
>  
> +	if (!event->parent) {
> +		/* 
> +		 * XXX the above err_alloc will dec below zero for
> +		 * perf_branch_stack_events.
> +		 */ 
> +		__account_event(event);
> +	}
> +
>  	/*
>  	 * Special case software events and allow them to be part of
>  	 * any hardware group.
> @@ -7083,6 +7123,7 @@ void perf_pmu_migrate_context(struct pmu
>  		perf_remove_from_context(event);
>  		put_ctx(src_ctx);
>  		list_add(&event->event_entry, &events);
> +		__unaccount_event(event);
>  	}
>  	mutex_unlock(&src_ctx->mutex);
>  
> @@ -7091,6 +7132,8 @@ void perf_pmu_migrate_context(struct pmu
>  	mutex_lock(&dst_ctx->mutex);
>  	list_for_each_entry_safe(event, tmp, &events, event_entry) {
>  		list_del(&event->event_entry);
> +		event->cpu = dst_cpu; /* XXX perf_install_in_context already does this; do we really need __account_event() _before_ that? */
> +		__account_event(event);
>  		if (event->state >= PERF_EVENT_STATE_OFF)
>  			event->state = PERF_EVENT_STATE_INACTIVE;
>  		perf_install_in_context(dst_ctx, event, dst_cpu);
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab3IYWgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 18:36:46 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:44562 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab3IYWgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 18:36:44 -0400
Date: Wed, 25 Sep 2013 15:36:29 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 05/21] perf: Add event toggle sys_perf_event_open
 interface
Message-ID: <20130925223629.GA13425@us.ibm.com>
References: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
 <1380113447-17144-6-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380113447-17144-6-git-send-email-jolsa@redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092522-9332-0000-0000-0000018B6A1E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa [jolsa@redhat.com] wrote:
| Adding perf interface that allows to create 'toggle' events,
| which can enable or disable another event. Whenever the toggle
| event is triggered (has overflow), it toggles another event
| state and either starts or stops it.

Nice idea. It would be very useful.

Will try out the patchset, but couple of small comments below.

| 
| The goal is to be able to create toggling tracepoint events
| to enable and disable HW counters, but the interface is generic
| enough to be used for any kind of event.
| 
| The interface to create a toggle event is similar as the one
| for defining event group. Use perf syscall with:
| 
|   flags    - PERF_FLAG_TOGGLE_ON or PERF_FLAG_TOGGLE_OFF
|   group_fd - event (or group) fd to be toggled
| 
| Created event will toggle ON(start) or OFF(stop) the event
| specified via group_fd.
| 
| Obviously this way it's not possible for toggle event to
| be part of group other than group leader. This will be
| possible via ioctl coming in next patch.
| 
| Original-patch-by: Frederic Weisbecker <fweisbec@gmail.com>
| Signed-off-by: Jiri Olsa <jolsa@redhat.com>
| Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
| Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
| Cc: Frederic Weisbecker <fweisbec@gmail.com>
| Cc: Ingo Molnar <mingo@elte.hu>
| Cc: Paul Mackerras <paulus@samba.org>
| Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
| Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
| ---
|  include/linux/perf_event.h      |   9 +++
|  include/uapi/linux/perf_event.h |   3 +
|  kernel/events/core.c            | 158 ++++++++++++++++++++++++++++++++++++++--
|  3 files changed, 164 insertions(+), 6 deletions(-)
| 
| diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
| index 866e85c..6ede25c 100644
| --- a/include/linux/perf_event.h
| +++ b/include/linux/perf_event.h
| @@ -289,6 +289,12 @@ struct swevent_hlist {
|  struct perf_cgroup;
|  struct ring_buffer;
| 
| +enum perf_event_toggle_flag {
| +	PERF_TOGGLE_NONE	= 0,
| +	PERF_TOGGLE_ON		= 1,
| +	PERF_TOGGLE_OFF		= 2,
| +};

Can we call this 'perf_event_toggle_state' ? it can be confusing with
PERF_FLAG_TOGGLE* macros below which apply to a different field.

| +
|  /**
|   * struct perf_event - performance event kernel representation:
|   */
| @@ -414,6 +420,9 @@ struct perf_event {
|  	int				cgrp_defer_enabled;
|  #endif
| 
| +	struct perf_event		*toggled_event;
| +	enum perf_event_toggle_flag	toggle_flag;

s/toggle_flag/toggle_state/ ?

| +	int				paused;

There is an 'event->state' field with OFF, INACTIVE, ACTIVE states.
Can we add a 'PAUSED' state to that instead ?


|  #endif /* CONFIG_PERF_EVENTS */
|  };
| 
| diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
| index ca1d90b..ecb0474 100644
| --- a/include/uapi/linux/perf_event.h
| +++ b/include/uapi/linux/perf_event.h
| @@ -694,6 +694,9 @@ enum perf_callchain_context {
|  #define PERF_FLAG_FD_NO_GROUP		(1U << 0)
|  #define PERF_FLAG_FD_OUTPUT		(1U << 1)
|  #define PERF_FLAG_PID_CGROUP		(1U << 2) /* pid=cgroup id, per-cpu mode only */
| +#define PERF_FLAG_TOGGLE_ON		(1U << 3)
| +#define PERF_FLAG_TOGGLE_OFF		(1U << 4)
| +
| 
|  union perf_mem_data_src {
|  	__u64 val;
| diff --git a/kernel/events/core.c b/kernel/events/core.c
| index e8674e4..40c792d 100644
| --- a/kernel/events/core.c
| +++ b/kernel/events/core.c
| @@ -44,6 +44,8 @@
| 
|  #include <asm/irq_regs.h>
| 
| +#define PERF_FLAG_TOGGLE (PERF_FLAG_TOGGLE_ON | PERF_FLAG_TOGGLE_OFF)
| +
|  struct remote_function_call {
|  	struct task_struct	*p;
|  	int			(*func)(void *info);
| @@ -119,7 +121,9 @@ static int cpu_function_call(int cpu, int (*func) (void *info), void *info)
| 
|  #define PERF_FLAG_ALL (PERF_FLAG_FD_NO_GROUP |\
|  		       PERF_FLAG_FD_OUTPUT  |\
| -		       PERF_FLAG_PID_CGROUP)
| +		       PERF_FLAG_PID_CGROUP |\
| +		       PERF_FLAG_TOGGLE_ON  |\
| +		       PERF_FLAG_TOGGLE_OFF)
| 
|  /*
|   * branch priv levels that need permission checks
| @@ -1358,6 +1362,25 @@ out:
|  		perf_event__header_size(tmp);
|  }
| 
| +static void put_event(struct perf_event *event);
| +
| +static void __perf_event_toggle_detach(struct perf_event *event)
| +{
| +	struct perf_event *toggled_event = event->toggled_event;
| +
| +	event->toggle_flag      = PERF_TOGGLE_NONE;
| +	event->overflow_handler = NULL;
| +	event->toggled_event    = NULL;
| +
| +	put_event(toggled_event);
| +}
| +
| +static void perf_event_toggle_detach(struct perf_event *event)
| +{
| +	if (event->toggle_flag > PERF_TOGGLE_NONE)
| +		__perf_event_toggle_detach(event);
| +}
| +
|  static inline int
|  event_filter_match(struct perf_event *event)
|  {
| @@ -1646,6 +1669,7 @@ event_sched_in(struct perf_event *event,
|  		 struct perf_event_context *ctx)
|  {
|  	u64 tstamp = perf_event_time(event);
| +	int add_flags = PERF_EF_START;
| 
|  	if (event->state <= PERF_EVENT_STATE_OFF)
|  		return 0;
| @@ -1665,7 +1689,10 @@ event_sched_in(struct perf_event *event,
|  	 */
|  	smp_wmb();
| 
| -	if (event->pmu->add(event, PERF_EF_START)) {
| +	if (event->paused)
| +		add_flags = 0;
| +
| +	if (event->pmu->add(event, add_flags)) {
|  		event->state = PERF_EVENT_STATE_INACTIVE;
|  		event->oncpu = -1;
|  		return -EAGAIN;
| @@ -2723,7 +2750,7 @@ static void perf_adjust_freq_unthr_context(struct perf_event_context *ctx,
|  			event->pmu->start(event, 0);
|  		}
| 
| -		if (!event->attr.freq || !event->attr.sample_freq)
| +		if (!event->attr.freq || !event->attr.sample_freq || event->paused)
|  			continue;
| 
|  		/*
| @@ -3240,7 +3267,7 @@ int perf_event_release_kernel(struct perf_event *event)
|  	raw_spin_unlock_irq(&ctx->lock);
|  	perf_remove_from_context(event);
|  	mutex_unlock(&ctx->mutex);
| -
| +	perf_event_toggle_detach(event);
|  	free_event(event);
| 
|  	return 0;
| @@ -5231,6 +5258,72 @@ static void perf_log_throttle(struct perf_event *event, int enable)
|  }
| 
|  /*
| + * TODO:
| + * - fix race when interrupting event_sched_in/event_sched_out
| + * - fix race against other toggler
| + * - fix race against other callers of ->stop/start (adjust period/freq)
| + */
| +static void perf_event_toggle(struct perf_event *event,
| +			      enum perf_event_toggle_flag flag)
| +{
| +	unsigned long flags;
| +	bool active;
| +
| +	/*
| +	 * Prevent from races against event->add/del through
| +	 * preempt_schedule_irq() or enable/disable IPIs
| +	 */
| +	local_irq_save(flags);
| +
| +	/* Could be out of HW counter. */
| +	active = event->state == PERF_EVENT_STATE_ACTIVE;
| +
| +	switch (flag) {
| +	case PERF_TOGGLE_ON:
| +		if (!event->paused)
| +			break;
| +		if (active)
| +			event->pmu->start(event, PERF_EF_RELOAD);
| +		event->paused = false;
| +		break;
| +	case PERF_TOGGLE_OFF:
| +		if (event->paused)
| +			break;
| +		if (active)
| +			event->pmu->stop(event, PERF_EF_UPDATE);
| +		event->paused = true;
| +		break;
| +	case PERF_TOGGLE_NONE:
| +		break;
| +	}
| +
| +	local_irq_restore(flags);
| +}
| +
| +static void
| +perf_event_toggle_overflow(struct perf_event *event,
| +			   struct perf_sample_data *data,
| +			   struct pt_regs *regs)
| +{
| +	struct perf_event *toggled_event;
| +
| +	if (!event->toggle_flag)
| +		return;
| +
| +	toggled_event = event->toggled_event;
| +
| +	if (WARN_ON_ONCE(!toggled_event))
| +		return;
| +
| +	perf_pmu_disable(toggled_event->pmu);
| +
| +	perf_event_toggle(toggled_event, event->toggle_flag);
| +	perf_event_output(event, data, regs);
| +
| +	perf_pmu_enable(toggled_event->pmu);
| +}
| +
| +/*
|   * Generic event overflow handling, sampling.
|   */
| 
| @@ -6887,6 +6980,43 @@ out:
|  	return ret;
|  }
| 
| +static enum perf_event_toggle_flag get_toggle_flag(unsigned long flags)
| +{
| +	if ((flags & PERF_FLAG_TOGGLE) == PERF_FLAG_TOGGLE_ON)
| +		return PERF_TOGGLE_ON;
| +	else if ((flags & PERF_FLAG_TOGGLE) == PERF_FLAG_TOGGLE_OFF)
| +		return PERF_TOGGLE_OFF;
| +
| +	return PERF_TOGGLE_NONE;
| +}
| +
| +static int
| +perf_event_set_toggle(struct perf_event *event,
| +		      struct perf_event *toggled_event,
| +		      struct perf_event_context *ctx,
| +		      unsigned long flags)
| +{
| +	if (WARN_ON_ONCE(!(flags & PERF_FLAG_TOGGLE)))
| +		return -EINVAL;
| +
| +	/* It's either ON or OFF. */
| +	if ((flags & PERF_FLAG_TOGGLE) == PERF_FLAG_TOGGLE)
| +		return -EINVAL;
| +
| +	/* Allow only same cpu, */
| +	if (toggled_event->cpu != event->cpu)
| +		return -EINVAL;
| +
| +	/* or same task. */

nit: s/or/and/

| +	if (toggled_event->ctx->task != ctx->task)
| +		return -EINVAL;
| +
| +	event->overflow_handler = perf_event_toggle_overflow;
| +	event->toggle_flag      = get_toggle_flag(flags);
| +	event->toggled_event    = toggled_event;
| +	return 0;
| +}
| +
|  /**
|   * sys_perf_event_open - open a performance event, associate it to a task/cpu
|   *
| @@ -6900,6 +7030,7 @@ SYSCALL_DEFINE5(perf_event_open,
|  		pid_t, pid, int, cpu, int, group_fd, unsigned long, flags)
|  {
|  	struct perf_event *group_leader = NULL, *output_event = NULL;
| +	struct perf_event *toggled_event = NULL;
|  	struct perf_event *event, *sibling;
|  	struct perf_event_attr attr;
|  	struct perf_event_context *ctx;
| @@ -6949,7 +7080,9 @@ SYSCALL_DEFINE5(perf_event_open,
|  		group_leader = group.file->private_data;
|  		if (flags & PERF_FLAG_FD_OUTPUT)
|  			output_event = group_leader;
| -		if (flags & PERF_FLAG_FD_NO_GROUP)
| +		if (flags & PERF_FLAG_TOGGLE)
| +			toggled_event = group_leader;
| +		if (flags & (PERF_FLAG_FD_NO_GROUP|PERF_FLAG_TOGGLE))
|  			group_leader = NULL;
|  	}
| 
| @@ -7060,10 +7193,20 @@ SYSCALL_DEFINE5(perf_event_open,
|  			goto err_context;
|  	}
| 
| +	if (toggled_event) {
| +		err = -EINVAL;
| +		if (!atomic_long_inc_not_zero(&toggled_event->refcount))
| +			goto err_context;
| +
| +		err = perf_event_set_toggle(event, toggled_event, ctx, flags);
| +		if (err)
| +			goto err_toggle;
| +	}
| +
|  	event_file = anon_inode_getfile("[perf_event]", &perf_fops, event, O_RDWR);
|  	if (IS_ERR(event_file)) {
|  		err = PTR_ERR(event_file);
| -		goto err_context;
| +		goto err_toggle;
|  	}
| 
|  	if (move_group) {
| @@ -7131,6 +7274,9 @@ SYSCALL_DEFINE5(perf_event_open,
|  	fd_install(event_fd, event_file);
|  	return event_fd;
| 
| +err_toggle:
| +	if (toggled_event)
| +		put_event(toggled_event);
|  err_context:
|  	perf_unpin_context(ctx);
|  	put_ctx(ctx);
| -- 
| 1.7.11.7
| 
| --
| To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
| the body of a message to majordomo@vger.kernel.org
| More majordomo info at  http://vger.kernel.org/majordomo-info.html
| Please read the FAQ at  http://www.tux.org/lkml/


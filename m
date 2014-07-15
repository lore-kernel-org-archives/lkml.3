Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240AbaGOR1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:27:55 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:55448 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759178AbaGOR1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:27:48 -0400
From: bsegall@google.com
To: Yuyang Du <yuyang.du@intel.com>
Cc: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
        pjt@google.com, arjan.van.de.ven@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        fengguang.wu@intel.com
Subject: Re: [PATCH 2/2 v2] sched: Rewrite per entity runnable load average tracking
References: <1405293352-9305-1-git-send-email-yuyang.du@intel.com>
	<1405293352-9305-3-git-send-email-yuyang.du@intel.com>
	<xm26vbqzwx9a.fsf@sword-of-the-dawn.mtv.corp.google.com>
	<20140715015105.GA2532@intel.com>
Date: Tue, 15 Jul 2014 10:27:45 -0700
In-Reply-To: <20140715015105.GA2532@intel.com> (Yuyang Du's message of "Tue,
	15 Jul 2014 09:51:05 +0800")
Message-ID: <xm26pph6wmzy.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yuyang Du <yuyang.du@intel.com> writes:
>> > @@ -667,18 +662,17 @@ static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
>> >  #ifdef CONFIG_SMP
>> >  static unsigned long task_h_load(struct task_struct *p);
>> >  
>> > -static inline void __update_task_entity_contrib(struct sched_entity *se);
>> > -
>> >  /* Give new task start runnable values to heavy its load in infant time */
>> >  void init_task_runnable_average(struct task_struct *p)
>> >  {
>> >  	u32 slice;
>> > +	struct sched_avg *sa = &p->se.avg;
>> >  
>> > -	p->se.avg.decay_count = 0;
>> > +	sa->last_update_time = 0;
>> > +	sa->period_contrib = 0;
>> 
>> sa->period_contrib = slice;
>
> period_contrib should be strictly < 1024. I suppose sched_slice does not guarantee that.
> So here I will give it 1023 to heavy the load.

Oh right, ignore that then.

>  
>> > +static __always_inline u64 decay_load64(u64 val, u64 n)
>> > +{
>> > +	if (likely(val <= UINT_MAX))
>> > +		val = decay_load(val, n);
>> > +	else {
>> > +		/*
>> > +		 * LOAD_AVG_MAX can last ~500ms (=log_2(LOAD_AVG_MAX)*32ms).
>> > +		 * Since we have so big runnable load_avg, it is impossible
>> > +		 * load_avg has not been updated for such a long time. So
>> > +		 * LOAD_AVG_MAX is enough here.
>> > +		 */
>> 
>> I mean, LOAD_AVG_MAX is irrelevant - the constant could just as well be
>> 1<<20, or whatever, yes? In fact, if you're going to then turn it into a
>> fraction of 1<<10, just do (with whatever temporaries you find most tasteful):
>> 
>> val *= (u32) decay_load(1 << 10, n);
>> val >>= 10;
>> 
>
> LOAD_AVG_MAX is selected on purpose. The val arriving here specifies that it is really
> big. So the decay_load may not decay it to 0 even period n is not small. If we use 1<<10
> here, n=10*32 will decay it to 0, but val (larger than 1<<32) can
> survive.

But when you do *1024 / LOAD_AVG_MAX it will go back to zero. In general
the code you have now is exactly equivalent to factor = decay_load(1<<10,n)
ignoring possible differences in rounding.

>> > +/* Update task and its cfs_rq load average */
>> > +static inline void update_load_avg(struct sched_entity *se, int update_tg)
>> >  {
>> > +	struct cfs_rq *cfs_rq = cfs_rq_of(se);
>> > +	u64 now = cfs_rq_clock_task(cfs_rq);
>> > +
>> >  	/*
>> > +	 * Track task load average for carrying it to new CPU after migrated
>> >  	 */
>> > +	if (entity_is_task(se))
>> > +		__update_load_avg(now, &se->avg, se->on_rq * se->load.weight);
>> >  
>> > +	update_cfs_rq_load_avg(now, cfs_rq);
>> >  
>> > +	if (update_tg)
>> > +		update_tg_load_avg(cfs_rq);
>> >  }
>> 
>> I personally find this very confusing, in that update_load_avg is doing
>> more to se->cfs_rq, and in fact on anything other than a task, it isn't
>> touching the se at all (instead, it touches _se->parent_ even).
>  
> What is confusing? The naming?

The fact that it sounds like it is operating on three things (se,
cfs_rq_of(se) and se->parent) but looks like it is only operating on se.
In particular, half/most of the time it isn't even operating on se at all.

>
> About the overflow problem, maybe I can just fall back to do load_avg / 47742
> for every update, then everything would be in nature the same range with the
> current code.

Hmm, that might work.

It would still be good to see pipe_test numbers at various cgroup depths.

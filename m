Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373AbaG1Q6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 12:58:25 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:54588 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbaG1Q6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 12:58:22 -0400
From: bsegall@google.com
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yuyang Du <yuyang.du@intel.com>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, pjt@google.com,
        arjan.van.de.ven@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        fengguang.wu@intel.com
Subject: Re: [PATCH 2/2 v4] sched: Rewrite per entity runnable load average tracking
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
	<1405639567-21445-3-git-send-email-yuyang.du@intel.com>
	<20140728135122.GT6758@twins.programming.kicks-ass.net>
Date: Mon, 28 Jul 2014 09:58:19 -0700
In-Reply-To: <20140728135122.GT6758@twins.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Mon, 28 Jul 2014 15:51:22 +0200")
Message-ID: <xm26lhrdv2s4.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

>> @@ -4551,18 +4382,34 @@ migrate_task_rq_fair(struct task_struct *p, int next_cpu)
>>  {
>>  	struct sched_entity *se = &p->se;
>>  	struct cfs_rq *cfs_rq = cfs_rq_of(se);
>> +	u64 last_update_time;
>>  
>>  	/*
>> +	 * Task on old CPU catches up with its old cfs_rq, and subtract itself from
>> +	 * the cfs_rq (task must be off the queue now).
>>  	 */
>> +#ifndef CONFIG_64BIT
>> +	u64 last_update_time_copy;
>> +
>> +	do {
>> +		last_update_time_copy = cfs_rq->load_last_update_time_copy;
>> +		smp_rmb();
>> +		last_update_time = cfs_rq->avg.last_update_time;
>> +	} while (last_update_time != last_update_time_copy);
>> +#else
>> +	last_update_time = cfs_rq->avg.last_update_time;
>> +#endif
>> +	__update_load_avg(last_update_time, &se->avg, 0);
>> +	atomic_long_add(se->avg.load_avg, &cfs_rq->removed_load_avg);
>> +
>> +	/*
>> +	 * We are supposed to update the task to "current" time, then its up to date
>> +	 * and ready to go to new CPU/cfs_rq. But we have difficulty in getting
>> +	 * what current time is, so simply throw away the out-of-date time. This
>> +	 * will result in the wakee task is less decayed, but giving the wakee more
>> +	 * load sounds not bad.
>> +	 */
>> +	se->avg.last_update_time = 0;
>>  
>>  	/* We have migrated, no longer consider this task hot */
>>  	se->exec_start = 0;
>
>
> And here we try and make good on that assumption. The thing I worry
> about is what happens if the machine is entirely idle...
>
> What guarantees an semi up-to-date cfs_rq->avg.last_update_time.

update_blocked_averages I think should do just as good a job as the old
code, which isn't perfect but is about as good as you can get worst case.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab3DKKvb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 06:51:31 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:58099 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab3DKKv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 06:51:29 -0400
Message-ID: <51669510.2040200@linux.vnet.ibm.com>
Date: Thu, 11 Apr 2013 16:18:48 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Dave Hansen <dave@sr71.net>, Borislav Petkov <bp@alien8.de>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        dhillf@gmail.com, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] kthread: Prevent unpark race which puts threads on the
 wrong cpu
References: <515F457E.5050505@sr71.net> <515FCAC6.8090806@linux.vnet.ibm.com> <alpine.LFD.2.02.1304061019000.21884@ionos> <alpine.LFD.2.02.1304071119100.21884@ionos> <20130407095025.GA31307@pd.tnic> <alpine.LFD.2.02.1304081122040.21884@ionos> <20130408115553.GA4395@pd.tnic> <alpine.LFD.2.02.1304081415570.21884@ionos> <alpine.LFD.2.02.1304091635430.21884@ionos> <516439DF.3050901@sr71.net> <alpine.LFD.2.02.1304092036431.21884@ionos> <alpine.LFD.2.02.1304092126150.21884@ionos> <51647C30.3050109@sr71.net> <alpine.LFD.2.02.1304101024010.21884@ionos> <alpine.LFD.2.02.1304101250320.21884@ionos> <5165C087.4060404@sr71.net> <alpine.LFD.2.02.1304111020520.21884@ionos>
In-Reply-To: <alpine.LFD.2.02.1304111020520.21884@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041110-5816-0000-0000-00000782E57E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2013 03:49 PM, Thomas Gleixner wrote:
> Dave,
> 
> On Wed, 10 Apr 2013, Dave Hansen wrote:
> 
>> I think I got a full trace this time:
>>
>> 	http://sr71.net/~dave/linux/bigbox-trace.1365621899.txt.gz
>>
>> The last timestamp is pretty close to the timestamp on the console:
>>
>> [ 2071.033434] smpboot_thread_fn():
>> [ 2071.033455] smpboot_thread_fn() cpu: 22 159
>> [ 2071.033470] td->cpu: 22
>> [ 2071.033475] smp_processor_id(): 21
>> [ 2071.033486] comm: migration/%u
> 
> Yes, that's helpful. Though it makes my mind boggle:
> 
>     migration/22-4335  [021] d.h.  2071.020530: sched_wakeup: comm=migration/21 pid=4323 prio=0 success=1 target_cpu=021^M
>     migration/22-4335  [021] d...  2071.020541: sched_switch: prev_comm=migration/22 prev_pid=4335 prev_prio=0 prev_state=0x200 ==> next_comm=migration/21 next_pid=4323 next_prio=0^M
>     migration/21-4323  [021] d...  2071.026110: sched_switch: prev_comm=migration/21 prev_pid=4323 prev_prio=0 prev_state=S ==> next_comm=migration/22 next_pid=4335 next_prio=0^M
>     migration/22-4335  [021] ....  2071.033422: smpboot_thread_fn <-kthread^M
> 
> So the migration thread schedules out with state TASK_PARKED and gets
> scheduled back in right away without a wakeup. Srivatsa was about
> right, that this might be related to the sched_set_stop_task() call,
> but the changelog led completely down the wrong road.
> 
> So the issue is:
> 
> CPU14				CPU21
> create_thread(for CPU22)
>  park_thread()	
>    wait_for_completion()	park_me()
> 				 complete()
>    sched_set_stop_task()
> 				 schedule(TASK_PARKED)
> 
> The sched_set_stop_task() call is issued while the task is on the
> runqueue of CPU21 and that confuses the hell out of the stop_task
> class on that cpu. So as we have to synchronize the state for the
> bind call (the issue observed by Borislav) we need to do the same
> before issuing sched_set_stop_task(). Delta patch below.
> 

In that case, why not just apply this 2 line patch on mainline?
The patch I sent yesterday was more elaborate because I wrongly assumed
that kthread_bind() can cause a wakeup. But now, I feel the patch shown
below should work just fine too. Yeah, it binds the task during creation
as well as during unpark, but that should be ok (see below).

Somehow, I believe we can handle this issue without introducing that
whole TASK_PARKED thing..


diff --git a/kernel/kthread.c b/kernel/kthread.c
index 691dc2e..74af4a8 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -308,6 +308,9 @@ struct task_struct *kthread_create_on_cpu(int (*threadfn)(void *data),
 	to_kthread(p)->cpu = cpu;
 	/* Park the thread to get it out of TASK_UNINTERRUPTIBLE state */
 	kthread_park(p);
+
+	wait_task_inactive(p, TASK_INTERRUPTIBLE);
+	__kthread_bind(p, cpu);
 	return p;
 }
 

The reason why we can't get rid of the bind in the unpark code is because,
the threads are parked during CPU offline *after* calling CPU_DOWN_PREPARE.
And during CPU_DOWN_PREPARE, the scheduler removes the CPU from the cpu_active_mask.
So on any subsequent wakeup of these threads before they are parked, the scheduler
will force migrate them to some other CPU (but alas it wont print this event
because of the p->mm != NULL check in select_fallback_rq()). So during unpark
during the next online operation we need to bind it again. But that's fine, IMHO.

Regards,
Srivatsa S. Bhat


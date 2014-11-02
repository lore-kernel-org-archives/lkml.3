Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaKBMCD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 07:02:03 -0500
Received: from numascale.com ([213.162.240.84]:46365 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbaKBMCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 07:02:00 -0500
Message-ID: <54561D2F.9000100@numascale.com>
Date: Sun, 02 Nov 2014 20:01:51 +0800
From: Daniel J Blueman <daniel@numascale.com>
Organization: Numascale AS
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        Subbaraman Narayanamurthy <subbaram@codeaurora.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] kthread: Fix the race condition when kthread is parked
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel21.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Get-Message-Sender-Via: cpanel21.proisp.no: authenticated_id: daniel@numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 26, 2014 8:50:01 AM UTC+8, Thomas Gleixner wrote:
 > On Wed, 25 Jun 2014, Subbaraman Narayanamurthy wrote:
 > > While stressing the CPU hotplug path, sometimes we hit a problem
 > > as shown below.
 > >
 > > [57056.416774] ------------[ cut here ]------------
 > > [57056.489232] ksoftirqd/1 (14): undefined instruction: pc=c01931e8
 > > [57056.489245] Code: e594a000 eb085236 e15a0000 0a000000 (e7f001f2)
 > > [57056.489259] ------------[ cut here ]------------
 > > [57056.492840] kernel BUG at kernel/kernel/smpboot.c:134!
 > > [57056.513236] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP ARM
 > > [57056.519055] Modules linked in: wlan(O) mhi(O)
 > > [57056.523394] CPU: 0 PID: 14 Comm: ksoftirqd/1 Tainted: G        W O
 > > 3.10.0-g3677c61-00008-g180c060 #1
 > > [57056.532595] task: f0c8b000 ti: f0e78000 task.ti: f0e78000
 > > [57056.537991] PC is at smpboot_thread_fn+0x124/0x218
 > > [57056.542750] LR is at smpboot_thread_fn+0x11c/0x218
 > > [57056.547528] pc : [<c01931e8>]    lr : [<c01931e0>] psr: 200f0013
 > > [57056.547528] sp : f0e79f30  ip : 00000000  fp : 00000000
 > > [57056.558983] r10: 00000001  r9 : 00000000  r8 : f0e78000
 > > [57056.564192] r7 : 00000001  r6 : c1195758  r5 : f0e78000  r4 : 
f0e5fd00
 > > [57056.570701] r3 : 00000001  r2 : f0e79f20  r1 : 00000000  r0 : 
00000000
 > >
 > > This issue was always seen in the context of "ksoftirqd". It seems to
 > > be happening because of a potential race condition in __kthread_parkme
 > > where just after completing the parked completion, before the
 > > ksoftirqd task has been scheduled again, it can go into running state.
 >
 > This explanation does not make any sense. You completely fail to
 > explain the details of the race. And your patch does not make any
 > sense either, because the real issue is this:
 >
 > Task   CPU 0				CPU 1
 >
 > T1     unplug cpu1
 >        kthread_park(T2)
 >        set_bit(KTHREAD_SHOULD_PARK);
 > 	  wait_for_completion()
 > T2					parkme(X)
 > 				   	  __set_current_state(TASK_PARKED);
 > 				   	  while (test_bit(KTHREAD_SHOULD_PARK)) {
 > 				     	    if (!test_and_set_bit(KTHREAD_IS_PARKED))
 > 				              complete();
 > 			             	    schedule();
 > T1   plug cpu1
 >
 > --> premature wakeup of T2, i.e. before unpark, so T2 gets scheduled on
 >     CPU 0
 >
 > T2    __set_current_state(TASK_PARKED);
 >
 > --> Preemption by the plug thread
 >
 > T1     thread_unpark(T2)
 >          clear_bit(KTHREAD_SHOULD_PARK);
 >
 > --> Preemption by the softirq thread which breaks out of the
 >     while(test_bit(KTHREAD_SHOULD_PARK)) loop because
 >     KTHREAD_SHOULD_PARK is not longer set.
 >
 > T2   }
 >     clear_bit(KTHREAD_IS_PARKED);
 >
 > --> Now T2 happily continues to run on CPU0 which rightfully casues
 >     the BUG to trigger.
 >
 > T1
 > 	__kthread_bind(T2)
 >
 > --> Too late ....
 >
 > So the real issue is that the park/unpark code is not able to handle
 > the premature wakeup of T2 and that needs to be fixed.
 >
 > Your changelog says:
 >
 > > It seems to be happening because of a potential race condition in
 >
 > Potential is wrong to begin with. A race condition is either real and
 > explainable or it does not exist.
 >
 > > __kthread_parkme where just after completing the parked completion,
 > > before the ksoftirqd task has been scheduled again, it can go into
 > > running state.
 >
 > What exactly has this to do with state RUNNING or PARKED?
 >
 >   Nothing, the task state is completely irrelevant as the real issue
 >   is the task->*PARK flags state.
 >
 > So what is your patch solving here ?
 >
 >   You put a wait for task->state == TASK_PARKED after the
 >   wait_for_completion. What does it solve? Actually nothing. It just
 >   changes the propability of that issue. Go and apply it between any
 >   step of the above and figure out what it solves. Nothing, really.
 >
 >   Now just as an extra thought experiment assume that you have only
 >   two cpus and T1 is a SCHED_FIFO task and T2 is SCHED_OTHER ....
 >
 > Please do not misunderstand me, but "fixing" races without proper
 > understanding them is plain wrong. Providing a vague changelog which
 > does neither explain what the issue is and why the fix works is even
 > more wrong.
 >
 > The next time you hit something like this, please take the time and
 > sit down, get out the old fashioned piece of paper and a pencil and
 > draw the picture so you can actually understand what the root cause of
 > the observed issue is before sending out halfarsed duct tape fixes
 > which just paper over the root cause. If you cannot figure it out,
 > send a proper bug report.
 >
 > Thanks,
 >
 > 	tglx
 > ------------------>
 >
 > Subject: kthread: Plug park/ unplug race
 > From: Thomas Gleixner <tglx@linutronix.de>
 > Date: Thu, 26 Jun 2014 01:24:36 +0200
 >
 > The kthread park/unpark logic has the following issue:
 >
 > Task   CPU 0				CPU 1
 >
 > T1     unplug cpu1
 >        kthread_park(T2)
 >        set_bit(KTHREAD_SHOULD_PARK);
 > 	  wait_for_completion()
 > T2					parkme(X)
 > 				   	  __set_current_state(TASK_PARKED);
 > 				   	  while (test_bit(KTHREAD_SHOULD_PARK)) {
 > 				     	    if (!test_and_set_bit(KTHREAD_IS_PARKED))
 > 				              complete();
 > 			             	    schedule();
 > T1   plug cpu1
 >
 > --> premature wakeup of T2, i.e. before unpark, so T2 gets scheduled on
 >     CPU 0
 >
 > T2    __set_current_state(TASK_PARKED);
 >
 > --> Preemption by the plug thread
 >
 > T1     thread_unpark(T2)
 >          clear_bit(KTHREAD_SHOULD_PARK);
 >
 > --> Preemption by the softirq thread which breaks out of the
 >     while(test_bit(KTHREAD_SHOULD_PARK)) loop because
 >     KTHREAD_SHOULD_PARK is not longer set.
 >
 > T2   }
 >     clear_bit(KTHREAD_IS_PARKED);
 >
 > --> Now T2 happily continues to run on CPU0 which rightfully causes
 >     the BUG_ON(T2->cpu != smp_processor_id()) to trigger.
 >
 > T1
 > 	__kthread_bind(T2)
 >
 > --> Too late ....
 >
 > Reorder the logic so that the unplug code binds the thread to the
 > target cpu before clearing the KTHREAD_SHOULD_PARK bit.
 >
 > Reported-by: Subbaraman Narayanamurthy <subbaram@codeaurora.org>
 > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
 > Cc: stable@vger.kernel.org
 >
 > ---
 >  kernel/kthread.c |   14 ++++++++++----
 >  1 file changed, 10 insertions(+), 4 deletions(-)
 >
 > Index: linux/kernel/kthread.c
 > ===================================================================
 > --- linux.orig/kernel/kthread.c
 > +++ linux/kernel/kthread.c
 > @@ -382,6 +382,15 @@ struct task_struct *kthread_create_on_cp
 >
 >  static void __kthread_unpark(struct task_struct *k, struct kthread 
*kthread)
 >  {
 > +	/*
 > +	 * Rebind the thread to the target cpu first if it is a per
 > +	 * cpu thread unconditionally because it must be bound to the
 > +	 * target cpu before it can observe the KTHREAD_SHOULD_PARK
 > +	 * bit cleared.
 > +	 */
 > +	if (test_bit(KTHREAD_IS_PER_CPU, &kthread->flags))
 > +		__kthread_bind(k, kthread->cpu, TASK_PARKED);
 > +
 >  	clear_bit(KTHREAD_SHOULD_PARK, &kthread->flags);
 >  	/*
 >  	 * We clear the IS_PARKED bit here as we don't wait
 > @@ -389,11 +398,8 @@ static void __kthread_unpark(struct task
 >  	 * park before that happens we'd see the IS_PARKED bit
 >  	 * which might be about to be cleared.
 >  	 */
 > -	if (test_and_clear_bit(KTHREAD_IS_PARKED, &kthread->flags)) {
 > -		if (test_bit(KTHREAD_IS_PER_CPU, &kthread->flags))
 > -			__kthread_bind(k, kthread->cpu, TASK_PARKED);
 > +	if (test_and_clear_bit(KTHREAD_IS_PARKED, &kthread->flags))
 >  		wake_up_state(k, TASK_PARKED);
 > -	}
 >  }
 >
 >  /**

I just got a window to test this, and it reliably addresses the 
boot-time core onlining race that we've seen occasionally on a 2000-core 
customer system. Splendid work, Thomas.

Tested-by: Daniel J Blueman <daniel@numascale.com>

Many thanks,
   Daniel
-- 
Daniel J Blueman
Principal Software Engineer, Numascale

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933036Ab3DKKUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 06:20:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:40494 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab3DKKT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 06:19:58 -0400
Date: Thu, 11 Apr 2013 12:19:48 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Hansen <dave@sr71.net>
cc: Borislav Petkov <bp@alien8.de>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        dhillf@gmail.com, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] kthread: Prevent unpark race which puts threads on the
 wrong cpu
In-Reply-To: <5165C087.4060404@sr71.net>
Message-ID: <alpine.LFD.2.02.1304111020520.21884@ionos>
References: <515F457E.5050505@sr71.net> <515FCAC6.8090806@linux.vnet.ibm.com> <alpine.LFD.2.02.1304061019000.21884@ionos> <alpine.LFD.2.02.1304071119100.21884@ionos> <20130407095025.GA31307@pd.tnic> <alpine.LFD.2.02.1304081122040.21884@ionos>
 <20130408115553.GA4395@pd.tnic> <alpine.LFD.2.02.1304081415570.21884@ionos> <alpine.LFD.2.02.1304091635430.21884@ionos> <516439DF.3050901@sr71.net> <alpine.LFD.2.02.1304092036431.21884@ionos> <alpine.LFD.2.02.1304092126150.21884@ionos> <51647C30.3050109@sr71.net>
 <alpine.LFD.2.02.1304101024010.21884@ionos> <alpine.LFD.2.02.1304101250320.21884@ionos> <5165C087.4060404@sr71.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

On Wed, 10 Apr 2013, Dave Hansen wrote:

> I think I got a full trace this time:
> 
> 	http://sr71.net/~dave/linux/bigbox-trace.1365621899.txt.gz
> 
> The last timestamp is pretty close to the timestamp on the console:
> 
> [ 2071.033434] smpboot_thread_fn():
> [ 2071.033455] smpboot_thread_fn() cpu: 22 159
> [ 2071.033470] td->cpu: 22
> [ 2071.033475] smp_processor_id(): 21
> [ 2071.033486] comm: migration/%u

Yes, that's helpful. Though it makes my mind boggle:

    migration/22-4335  [021] d.h.  2071.020530: sched_wakeup: comm=migration/21 pid=4323 prio=0 success=1 target_cpu=021^M
    migration/22-4335  [021] d...  2071.020541: sched_switch: prev_comm=migration/22 prev_pid=4335 prev_prio=0 prev_state=0x200 ==> next_comm=migration/21 next_pid=4323 next_prio=0^M
    migration/21-4323  [021] d...  2071.026110: sched_switch: prev_comm=migration/21 prev_pid=4323 prev_prio=0 prev_state=S ==> next_comm=migration/22 next_pid=4335 next_prio=0^M
    migration/22-4335  [021] ....  2071.033422: smpboot_thread_fn <-kthread^M

So the migration thread schedules out with state TASK_PARKED and gets
scheduled back in right away without a wakeup. Srivatsa was about
right, that this might be related to the sched_set_stop_task() call,
but the changelog led completely down the wrong road.

So the issue is:

CPU14				CPU21
create_thread(for CPU22)
 park_thread()	
   wait_for_completion()	park_me()
				 complete()
   sched_set_stop_task()
				 schedule(TASK_PARKED)

The sched_set_stop_task() call is issued while the task is on the
runqueue of CPU21 and that confuses the hell out of the stop_task
class on that cpu. So as we have to synchronize the state for the
bind call (the issue observed by Borislav) we need to do the same
before issuing sched_set_stop_task(). Delta patch below.

Thanks,

	tglx
---
Index: linux-2.6/include/trace/events/sched.h
===================================================================
--- linux-2.6.orig/include/trace/events/sched.h
+++ linux-2.6/include/trace/events/sched.h
@@ -147,7 +147,7 @@ TRACE_EVENT(sched_switch,
 		  __print_flags(__entry->prev_state & (TASK_STATE_MAX-1), "|",
 				{ 1, "S"} , { 2, "D" }, { 4, "T" }, { 8, "t" },
 				{ 16, "Z" }, { 32, "X" }, { 64, "x" },
-				{ 128, "W" }) : "R",
+				{ 128, "K" }, { 256, "W" }, { 512, "P" }) : "R",
 		__entry->prev_state & TASK_STATE_MAX ? "+" : "",
 		__entry->next_comm, __entry->next_pid, __entry->next_prio)
 );
Index: linux-2.6/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/kernel/smpboot.c
+++ linux-2.6/kernel/smpboot.c
@@ -185,8 +185,18 @@ __smpboot_create_thread(struct smp_hotpl
 	}
 	get_task_struct(tsk);
 	*per_cpu_ptr(ht->store, cpu) = tsk;
-	if (ht->create)
-		ht->create(cpu);
+	if (ht->create) {
+		/*
+		 * Make sure that the task has actually scheduled out
+		 * into park position, before calling the create
+		 * callback. At least the migration thread callback
+		 * requires that the task is off the runqueue.
+		 */
+		if (!wait_task_inactive(tsk, TASK_PARKED))
+			WARN_ON(1);
+		else
+			ht->create(cpu);
+	}
 	return 0;
 }
 



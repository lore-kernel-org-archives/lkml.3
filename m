Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab3DKTTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 15:19:20 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:32792 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab3DKTTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 15:19:19 -0400
Message-ID: <51670C17.8070608@linux.vnet.ibm.com>
Date: Fri, 12 Apr 2013 00:46:39 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave@sr71.net>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        dhillf@gmail.com, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] kthread: Prevent unpark race which puts threads on the
 wrong cpu
References: <515F457E.5050505@sr71.net> <515FCAC6.8090806@linux.vnet.ibm.com> <alpine.LFD.2.02.1304061019000.21884@ionos> <alpine.LFD.2.02.1304071119100.21884@ionos> <20130407095025.GA31307@pd.tnic> <alpine.LFD.2.02.1304081122040.21884@ionos> <20130408115553.GA4395@pd.tnic> <alpine.LFD.2.02.1304081415570.21884@ionos> <alpine.LFD.2.02.1304091635430.21884@ionos>
In-Reply-To: <alpine.LFD.2.02.1304091635430.21884@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041119-5816-0000-0000-000007846245
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 08:08 PM, Thomas Gleixner wrote:
> The smpboot threads rely on the park/unpark mechanism which binds per
> cpu threads on a particular core. Though the functionality is racy:
> 
> CPU0	       	 	CPU1  	     	    CPU2
> unpark(T)				    wake_up_process(T)
>   clear(SHOULD_PARK)	T runs
> 			leave parkme() due to !SHOULD_PARK  
>   bind_to(CPU2)		BUG_ON(wrong CPU)						    
>

OK, I must admit that I had missed noticing that the task was ksoftirqd
and not the migration thread in Boris' trace. And yes, this unexpected
wakeup is a problem for ksoftirqd.
 
> We cannot let the tasks move themself to the target CPU as one of
> those tasks is actually the migration thread itself, which requires
> that it starts running on the target cpu right away.
> 

Of course, we can't use set_cpus_allowed_ptr(), but we can still achieve
the desired bind effect without any race, see below.

> The only rock solid solution to this problem is to prevent wakeups in
> park state which are not from unpark(). That way we can guarantee that
> the association of the task to the target cpu is working correctly.
> 
> Add a new task state (TASK_PARKED) which prevents other wakeups and
> use this state explicitely for the unpark wakeup.
>

Again, I think this is unnecessary. We are good as long as no one other
than the unpark code can kick the kthreads out of the loop in the park
code. Now that I understand the race you explained above, why not just
fix that race itself by reversing the ordering of clear(SHOULD_PARK)
and bind_to(CPU2)? That way, even if someone else wakes up the per-cpu
kthread, it will just remain confined to the park code, as intended.

A patch like below should do it IMHO. I guess I'm being a little too
persistent, sorry!


diff --git a/kernel/kthread.c b/kernel/kthread.c
index 691dc2e..9512fc5 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -308,6 +308,15 @@ struct task_struct *kthread_create_on_cpu(int (*threadfn)(void *data),
 	to_kthread(p)->cpu = cpu;
 	/* Park the thread to get it out of TASK_UNINTERRUPTIBLE state */
 	kthread_park(p);
+
+	/*
+	 * Wait for p->on_rq to be reset to 0, to ensure that the per-cpu
+	 * migration thread (which belongs to the stop_task sched class)
+	 * doesn't run until the cpu is actually onlined and the thread is
+	 * unparked.
+	 */
+	if (!wait_task_inactive(p, TASK_INTERRUPTIBLE))
+		WARN_ON(1);
 	return p;
 }
 
@@ -324,6 +333,17 @@ static struct kthread *task_get_live_kthread(struct task_struct *k)
 	return NULL;
 }
 
+static void __kthread_park(struct task_struct *k, struct kthread *kthread)
+{
+	if (!test_bit(KTHREAD_IS_PARKED, &kthread->flags)) {
+		set_bit(KTHREAD_SHOULD_PARK, &kthread->flags);
+		if (k != current) {
+			wake_up_process(k);
+			wait_for_completion(&kthread->parked);
+		}
+	}
+}
+
 /**
  * kthread_unpark - unpark a thread created by kthread_create().
  * @k:		thread created by kthread_create().
@@ -337,18 +357,29 @@ void kthread_unpark(struct task_struct *k)
 	struct kthread *kthread = task_get_live_kthread(k);
 
 	if (kthread) {
+		/*
+		 * Per-cpu kthreads such as ksoftirqd can get woken up by
+		 * other events. So after binding the thread, ensure that
+		 * it goes off the CPU atleast once, by parking it again.
+		 * This way, we can ensure that it will run on the correct
+		 * CPU on subsequent wakeup.
+		 */
+		if (test_bit(KTHREAD_IS_PER_CPU, &kthread->flags)) {
+			__kthread_bind(k, kthread->cpu);
+			clear_bit(KTHREAD_IS_PARKED, &kthread->flags);
+			__kthread_park(k, kthread);
+		}
+
 		clear_bit(KTHREAD_SHOULD_PARK, &kthread->flags);
+
 		/*
 		 * We clear the IS_PARKED bit here as we don't wait
 		 * until the task has left the park code. So if we'd
 		 * park before that happens we'd see the IS_PARKED bit
 		 * which might be about to be cleared.
 		 */
-		if (test_and_clear_bit(KTHREAD_IS_PARKED, &kthread->flags)) {
-			if (test_bit(KTHREAD_IS_PER_CPU, &kthread->flags))
-				__kthread_bind(k, kthread->cpu);
+		if (test_and_clear_bit(KTHREAD_IS_PARKED, &kthread->flags))
 			wake_up_process(k);
-		}
 	}
 	put_task_struct(k);
 }
@@ -371,13 +402,7 @@ int kthread_park(struct task_struct *k)
 	int ret = -ENOSYS;
 
 	if (kthread) {
-		if (!test_bit(KTHREAD_IS_PARKED, &kthread->flags)) {
-			set_bit(KTHREAD_SHOULD_PARK, &kthread->flags);
-			if (k != current) {
-				wake_up_process(k);
-				wait_for_completion(&kthread->parked);
-			}
-		}
+		__kthread_park(k, kthread);
 		ret = 0;
 	}
 	put_task_struct(k);


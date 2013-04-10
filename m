Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964859Ab3DJOGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 10:06:25 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:58423 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759722Ab3DJOGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 10:06:22 -0400
Message-ID: <5165713D.7030503@linux.vnet.ibm.com>
Date: Wed, 10 Apr 2013 19:33:41 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>
CC: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        dhillf@gmail.com, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH] CPU hotplug, smpboot: Fix crash in smpboot_thread_fn()
References: <515F457E.5050505@sr71.net> <515FCAC6.8090806@linux.vnet.ibm.com> <alpine.LFD.2.02.1304061019000.21884@ionos> <alpine.LFD.2.02.1304071119100.21884@ionos> <20130407095025.GA31307@pd.tnic> <alpine.LFD.2.02.1304081122040.21884@ionos> <20130408115553.GA4395@pd.tnic> <alpine.LFD.2.02.1304081415570.21884@ionos> <alpine.LFD.2.02.1304091635430.21884@ionos> <516439DF.3050901@sr71.net>
In-Reply-To: <516439DF.3050901@sr71.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041014-9574-0000-0000-00000768F34F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On 04/09/2013 09:25 PM, Dave Hansen wrote:
> Hey Thomas,
> 
> I don't think the patch helped my case.  Looks like the same BUG_ON().
> 
> I accidentally booted with possible_cpus=10 instead of 160.  I wasn't
> able to trigger this in that case, even repeatedly on/offlining them.
> But, once I booted with possible_cpus=160, it triggered in a jiffy.
> 
> Two oopses below (bottom one has cpu numbers):
>

So here is a little bit of a hunch + guess work ;) Could you kindly test
this patch on top of mainline and let me know if it helps?

Regards,
Srivatsa S. Bhat

-------------------------------------------------------------------------->

From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] CPU hotplug, smpboot: Fix crash in smpboot_thread_fn()

Dave Hansen and Borislav Petkov reported the following crash, which
corresponds the following BUG_ON in smpboot_thread_fn():

BUG_ON(td->cpu != smp_processor_id());

[  790.223270] ------------[ cut here ]------------
[  790.223966] kernel BUG at kernel/smpboot.c:134!
[  790.224739] invalid opcode: 0000 [#1] SMP
[  790.225671] Modules linked in:
[  790.226428] CPU 81
[  790.226909] Pid: 3909, comm: migration/135 Tainted: G        W    3.9.0-rc5-00184-gb6a9b7f-dirty #118 FUJITSU-SV PRIMEQUEST 1800E2/SB
[  790.228775] RIP: 0010:[<ffffffff8110bee8>]  [<ffffffff8110bee8>] smpboot_thread_fn+0x258/0x280
[  790.230205] RSP: 0018:ffff88bfef9c1e08  EFLAGS: 00010202
[  790.231090] RAX: 0000000000000051 RBX: ffff88bfefb82000 RCX: 000000000000b888
[  790.231653] RDX: ffff88bfef9c1fd8 RSI: ffff881fff000000 RDI: 0000000000000087
[  790.232085] RBP: ffff88bfef9c1e38 R08: 0000000000000001 R09: 0000000000000000
[  790.232850] R10: 0000000000000018 R11: 0000000000000000 R12: ffff88bfec9e22e0
[  790.233561] R13: ffffffff81e587a0 R14: ffff88bfec9e22e0 R15: 0000000000000000
[  790.234004] FS:  0000000000000000(0000) GS:ffff881fff000000(0000) knlGS:0000000000000000
[  790.234918] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  790.235602] CR2: 00007fa89a333c62 CR3: 0000000001e0b000 CR4: 00000000000007e0
[  790.236110] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  790.236584] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  790.237329] Process migration/135 (pid: 3909, threadinfo ffff88bfef9c0000, task ffff88bfec9e22e0)
[  790.238321] Stack:
[  790.238882]  ffff88bfef9c1e38 0000000000000000 ffff88ffef421cc0 ffff88bfef9c1ec0
[  790.245415]  ffff88bfefb82000 ffffffff8110bc90 ffff88bfef9c1f48 ffffffff810ff1df
[  790.250755]  0000000000000001 0000000000000087 ffff88bfefb82000 0000000000000000
[  790.253365] Call Trace:
[  790.254121]  [<ffffffff8110bc90>] ? __smpboot_create_thread+0x180/0x180
[  790.255428]  [<ffffffff810ff1df>] kthread+0xef/0x100
[  790.256071]  [<ffffffff819cb1a4>] ? wait_for_completion+0x124/0x180
[  790.256697]  [<ffffffff810ff0f0>] ? __init_kthread_worker+0x80/0x80
[  790.257325]  [<ffffffff819dba9c>] ret_from_fork+0x7c/0xb0
[  790.258233]  [<ffffffff810ff0f0>] ? __init_kthread_worker+0x80/0x80
[  790.258942] Code: ef 3d 01 01 48 89 df e8 87 b0 16 00 48 83 05 67 ef 3d 01 01 48 83 c4 10 31 c0 5b 41 5c 41 5d 41 5e 5d c3 48 83 05 90 ef 3d 01 01 <0f> 0b 48 83 05 96 ef 3d 01 01 48 83 05 56 ef 3d 01 01 0f 0b 48
[  790.276178] RIP  [<ffffffff8110bee8>] smpboot_thread_fn+0x258/0x280
[  790.276735]  RSP <ffff88bfef9c1e08>
[  790.278348] ---[ end trace 84baa2bee1434240 ]---


Interestingly, in every single stack trace, the crashing task is the migration
thread. Now, migration thread belongs to the highest priority stop_task sched
class, and this particular sched class is very unique in the way it implements
its internal sched class functions, and I suspect this has a lot of bearing
on how functions like kthread_bind(), wake_up_process() etc react with it
(by looking at how it implements its functions such as select_task_rq(),
enqueue_task(), dequeue_task() etc).

Previous to commit 14e568e (stop_machine: Use smpboot threads), the migration
threads were set to stop_task sched class *after* binding them to the
appropriate cpus. But that commit reversed that sequence inadvertently.
So revert back to the old sequence to fix this issue.

But note that __kthread_bind() can wake up the task if the task is an RT
task. So it can be called only when the CPU (to which we want to bind the task)
is already online. So add a new function called kthread_unpark_prepare() and
call it in smpboot_unpark_thread(), to bind the kthread to the appropriate CPU.
And in stop-machine, move the sched class initialization to ->pre_unpark().
This way, it can be ensured that for stop-task class tasks (such as migration
thread), the sched class is set *after* binding the task to the CPU (and
also, the kthreads belonging to other sched classes will continue to function
properly). Also, teach sched_set_stop_task() to ignore repeated invocations
with the same task as argument.

Reported-by: Dave Jones <davej@redhat.com>
Reported-by: Dave Hansen <dave@sr71.net>
Reported-by: Borislav Petkov <bp@alien8.de>
Cc: stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/kthread.h |    1 +
 kernel/kthread.c        |   24 ++++++++++++++++++++----
 kernel/sched/core.c     |    3 +++
 kernel/smpboot.c        |    2 ++
 kernel/stop_machine.c   |    7 +------
 5 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index 8d81664..7552eb0 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -44,6 +44,7 @@ bool kthread_should_park(void);
 bool kthread_freezable_should_stop(bool *was_frozen);
 void *kthread_data(struct task_struct *k);
 int kthread_park(struct task_struct *k);
+void kthread_unpark_prepare(struct task_struct *k);
 void kthread_unpark(struct task_struct *k);
 void kthread_parkme(void);
 
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 691dc2e..e3325cc 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -325,6 +325,25 @@ static struct kthread *task_get_live_kthread(struct task_struct *k)
 }
 
 /**
+ * kthread_unpark_prepare - prepare to unpark a thread created by
+ * kthread_create().
+ * @k:		thread created by kthread_create().
+ *
+ * If the thread is marked per-cpu, it is bound to the cpu, in
+ * preparation for waking it up in the near future.
+ */
+void kthread_unpark_prepare(struct task_struct *k)
+{
+	struct kthread *kthread = task_get_live_kthread(k);
+
+	if (kthread) {
+		if (test_bit(KTHREAD_IS_PER_CPU, &kthread->flags))
+			__kthread_bind(k, kthread->cpu);
+	}
+	put_task_struct(k);
+}
+
+/**
  * kthread_unpark - unpark a thread created by kthread_create().
  * @k:		thread created by kthread_create().
  *
@@ -344,11 +363,8 @@ void kthread_unpark(struct task_struct *k)
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
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7f12624..7370fad 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -814,6 +814,9 @@ void sched_set_stop_task(int cpu, struct task_struct *stop)
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO - 1 };
 	struct task_struct *old_stop = cpu_rq(cpu)->stop;
 
+	if (stop == old_stop)
+		return;
+
 	if (stop) {
 		/*
 		 * Make it appear like a SCHED_FIFO task, its something
diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index 8eaed9a..bd1a9175 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -209,6 +209,8 @@ static void smpboot_unpark_thread(struct smp_hotplug_thread *ht, unsigned int cp
 {
 	struct task_struct *tsk = *per_cpu_ptr(ht->store, cpu);
 
+	kthread_unpark_prepare(tsk);
+
 	if (ht->pre_unpark)
 		ht->pre_unpark(cpu);
 	kthread_unpark(tsk);
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index c09f295..db32f3a 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -300,11 +300,6 @@ repeat:
 
 extern void sched_set_stop_task(int cpu, struct task_struct *stop);
 
-static void cpu_stop_create(unsigned int cpu)
-{
-	sched_set_stop_task(cpu, per_cpu(cpu_stopper_task, cpu));
-}
-
 static void cpu_stop_park(unsigned int cpu)
 {
 	struct cpu_stopper *stopper = &per_cpu(cpu_stopper, cpu);
@@ -323,6 +318,7 @@ static void cpu_stop_unpark(unsigned int cpu)
 {
 	struct cpu_stopper *stopper = &per_cpu(cpu_stopper, cpu);
 
+	sched_set_stop_task(cpu, per_cpu(cpu_stopper_task, cpu));
 	spin_lock_irq(&stopper->lock);
 	stopper->enabled = true;
 	spin_unlock_irq(&stopper->lock);
@@ -333,7 +329,6 @@ static struct smp_hotplug_thread cpu_stop_threads = {
 	.thread_should_run	= cpu_stop_should_run,
 	.thread_fn		= cpu_stopper_thread,
 	.thread_comm		= "migration/%u",
-	.create			= cpu_stop_create,
 	.setup			= cpu_stop_unpark,
 	.park			= cpu_stop_park,
 	.pre_unpark		= cpu_stop_unpark,



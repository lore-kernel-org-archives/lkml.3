Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbaLHD1G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 22:27:06 -0500
Received: from ozlabs.org ([103.22.144.67]:58707 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbaLHD1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 22:27:05 -0500
From: Anton Blanchard <anton@samba.org>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, tj@kernel.org, fengguang.wu@intel.com,
        rafael.j.wysocki@intel.com, yuyang.du@intel.com, lkp@01.org,
        yuanhan.liu@linux.intel.com, pjt@google.com, bsegall@google.com,
        daniel@numascale.com, subbaram@codeaurora.org,
        computersforpeace@gmail.com, sp@datera.io
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] kthread: kthread_bind fails to enforce CPU affinity (fixes kernel BUG at kernel/smpboot.c:134!)
Date: Mon,  8 Dec 2014 14:27:01 +1100
Message-Id: <1418009221-12719-1-git-send-email-anton@samba.org>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a busy ppc64le KVM box where guests sometimes hit the infamous
"kernel BUG at kernel/smpboot.c:134!" issue during boot:

BUG_ON(td->cpu != smp_processor_id());

Basically a per CPU hotplug thread scheduled on the wrong CPU. The oops
output confirms it:

CPU: 0
Comm: watchdog/130

The issue is in kthread_bind where we set the cpus_allowed mask, but do
not touch task_thread_info(p)->cpu. The scheduler assumes the previously
scheduled CPU is in the cpus_allowed mask, but in this case we are
moving a thread to another CPU so it is not.

We used to call set_task_cpu which sets task_thread_info(p)->cpu (in fact
kthread_bind still has a comment suggesting this). That was removed in
e2912009fb7b ("sched: Ensure set_task_cpu() is never called on blocked
tasks").

Since we cannot call set_task_cpu (the task is in a sleeping state),
just do an explicit set of task_thread_info(p)->cpu.

Fixes: e2912009fb7b ("sched: Ensure set_task_cpu() is never called on blocked tasks")
Cc: stable@vger.kernel.org
Signed-off-by: Anton Blanchard <anton@samba.org>
---
 kernel/kthread.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 10e489c..e40ab1d 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -327,13 +327,14 @@ EXPORT_SYMBOL(kthread_create_on_node);
 
 static void __kthread_bind(struct task_struct *p, unsigned int cpu, long state)
 {
-	/* Must have done schedule() in kthread() before we set_task_cpu */
+	/* Must have done schedule() in kthread() before we change affinity */
 	if (!wait_task_inactive(p, state)) {
 		WARN_ON(1);
 		return;
 	}
 	/* It's safe because the task is inactive. */
 	do_set_cpus_allowed(p, cpumask_of(cpu));
+	task_thread_info(p)->cpu = cpu;
 	p->flags |= PF_NO_SETAFFINITY;
 }
 
-- 
2.1.0


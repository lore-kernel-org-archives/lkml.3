Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbaIZLdI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 07:33:08 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:63091 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbaIZLdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 07:33:07 -0400
Date: Fri, 26 Sep 2014 13:32:58 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20140926113258.GA14371@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-urgent-for-linus

   # HEAD: 03bd4e1f7265548832a76e7919a81f3137c44fd1 sched: Fix unreleased llc_shared_mask bit during CPU hotplug

A CONFIG_STACK_GROWSUP=y fix, and a hotplug llc CPU mask fix.

 Thanks,

	Ingo

------------------>
Chuck Ebbert (1):
      sched: Fix end_of_stack() and location of stack canary for architectures using CONFIG_STACK_GROWSUP

Wanpeng Li (1):
      sched: Fix unreleased llc_shared_mask bit during CPU hotplug


 arch/x86/kernel/smpboot.c |  3 +++
 include/linux/sched.h     | 13 +++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 2d872e08fab9..42a2dca984b3 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1284,6 +1284,9 @@ static void remove_siblinginfo(int cpu)
 
 	for_each_cpu(sibling, cpu_sibling_mask(cpu))
 		cpumask_clear_cpu(cpu, cpu_sibling_mask(sibling));
+	for_each_cpu(sibling, cpu_llc_shared_mask(cpu))
+		cpumask_clear_cpu(cpu, cpu_llc_shared_mask(sibling));
+	cpumask_clear(cpu_llc_shared_mask(cpu));
 	cpumask_clear(cpu_sibling_mask(cpu));
 	cpumask_clear(cpu_core_mask(cpu));
 	c->phys_proc_id = 0;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5c2c885ee52b..1f07040d28e3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2608,9 +2608,22 @@ static inline void setup_thread_stack(struct task_struct *p, struct task_struct
 	task_thread_info(p)->task = p;
 }
 
+/*
+ * Return the address of the last usable long on the stack.
+ *
+ * When the stack grows down, this is just above the thread
+ * info struct. Going any lower will corrupt the threadinfo.
+ *
+ * When the stack grows up, this is the highest address.
+ * Beyond that position, we corrupt data on the next page.
+ */
 static inline unsigned long *end_of_stack(struct task_struct *p)
 {
+#ifdef CONFIG_STACK_GROWSUP
+	return (unsigned long *)((unsigned long)task_thread_info(p) + THREAD_SIZE) - 1;
+#else
 	return (unsigned long *)(task_thread_info(p) + 1);
+#endif
 }
 
 #endif

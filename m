Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbaDVPR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:17:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933042AbaDVPRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:17:48 -0400
From: Don Zickus <dzickus@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: akpm@linux-foundation.org, x86@kernel.org, davem@davemloft.net,
        sparclinux@vger.kernel.org, mguzik@redhat.com,
        Aaron Tomlin <atomlin@redhat.com>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 3/4 v3] sparc64, nmi: Add more flexible NMI back trace support
Date: Tue, 22 Apr 2014 11:17:27 -0400
Message-Id: <1398179848-197479-4-git-send-email-dzickus@redhat.com>
In-Reply-To: <1398179848-197479-1-git-send-email-dzickus@redhat.com>
References: <1398179848-197479-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaron Tomlin <atomlin@redhat.com>

This patch introduces the sparc specific implementation
changes to the arch_trigger_all_cpu_backtrace() routine.
Now users have the ability to choose whether or not to
issue an NMI back trace which includes current.

Update sysrq_handle_globreg() to use the new interface

[squash two sparc patches, update changelog - dcz]

Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/sparc/include/asm/irq_64.h |    2 +-
 arch/sparc/kernel/process_64.c  |   14 +++++++++-----
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/sparc/include/asm/irq_64.h b/arch/sparc/include/asm/irq_64.h
index abf6afe..4f072b9 100644
--- a/arch/sparc/include/asm/irq_64.h
+++ b/arch/sparc/include/asm/irq_64.h
@@ -89,7 +89,7 @@ static inline unsigned long get_softint(void)
 	return retval;
 }
 
-void arch_trigger_all_cpu_backtrace(void);
+void arch_trigger_all_cpu_backtrace(bool);
 #define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
 
 extern void *hardirq_stack[NR_CPUS];
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index 32a280e..3d61b98 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -237,7 +237,7 @@ static void __global_reg_poll(struct global_reg_snapshot *gp)
 	}
 }
 
-void arch_trigger_all_cpu_backtrace(void)
+void arch_trigger_all_cpu_backtrace(bool include_self)
 {
 	struct thread_info *tp = current_thread_info();
 	struct pt_regs *regs = get_irq_regs();
@@ -249,15 +249,19 @@ void arch_trigger_all_cpu_backtrace(void)
 
 	spin_lock_irqsave(&global_cpu_snapshot_lock, flags);
 
-	memset(global_cpu_snapshot, 0, sizeof(global_cpu_snapshot));
-
 	this_cpu = raw_smp_processor_id();
 
-	__global_reg_self(tp, regs, this_cpu);
+	memset(global_cpu_snapshot, 0, sizeof(global_cpu_snapshot));
+
+	if (include_self)
+		__global_reg_self(tp, regs, this_cpu);
 
 	smp_fetch_global_regs();
 
 	for_each_online_cpu(cpu) {
+		if (!include_self && cpu == this_cpu)
+			continue;
+
 		struct global_reg_snapshot *gp = &global_cpu_snapshot[cpu].reg;
 
 		__global_reg_poll(gp);
@@ -290,7 +294,7 @@ void arch_trigger_all_cpu_backtrace(void)
 
 static void sysrq_handle_globreg(int key)
 {
-	arch_trigger_all_cpu_backtrace();
+	arch_trigger_all_cpu_backtrace(true);
 }
 
 static struct sysrq_key_op sparc_globalreg_op = {
-- 
1.7.1


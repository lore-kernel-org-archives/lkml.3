Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422769AbaJaB0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 21:26:08 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35953 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422714AbaJaB0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 21:26:06 -0400
From: Chen Yucong <slaoub@gmail.com>
To: bp@alien8.de
Cc: tony.luck@intel.com, ak@linux.intel.com, gong.chen@linux.intel.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chen Yucong <slaoub@gmail.com>
Subject: [PATCH 2/2] x86, mce, amd: extend mce-inject for support threshold interrupt event injection on AMD platform
Date: Fri, 31 Oct 2014 09:24:07 +0800
Message-Id: <1414718648-7766-3-git-send-email-slaoub@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1414718648-7766-1-git-send-email-slaoub@gmail.com>
References: <1414718648-7766-1-git-send-email-slaoub@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are three ways that have been used to report machine check event.
And they are MCE, CMCI/Threshold Interrupt, and POLL. On the Intel
platform, CMCI/Threshold Interrupt and POLL share the same event handler
- machine_check_poll(). However, on the AMD platform, they have a
separate event handler. amd_threshold_interrupt() is used for handling
Threshold Interrupt event. And machine_check_poll() has been used for
polling other events.

This patch introduces a new flag MCJ_INTERRUPT that will be used to
separate CMCI/Threshold Interrupt and POLL handler in mce-inject.

Signed-off-by: Chen Yucong <slaoub@gmail.com>
---
 arch/x86/include/asm/mce.h              |    5 +++--
 arch/x86/kernel/cpu/mcheck/mce-inject.c |   16 ++++++++++++++++
 arch/x86/kernel/cpu/mcheck/threshold.c  |    1 +
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 3a430ad..cf25839 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -70,8 +70,9 @@
 #define MCJ_CTX_PROCESS		0x1  /* inject context: process */
 #define MCJ_CTX_IRQ		0x2  /* inject context: IRQ */
 #define MCJ_NMI_BROADCAST	0x4  /* do NMI broadcasting */
-#define MCJ_EXCEPTION		0x8  /* raise as exception */
-#define MCJ_IRQ_BROADCAST	0x10 /* do IRQ broadcasting */
+#define MCJ_IRQ_BROADCAST	0x8  /* do IRQ broadcasting */
+#define MCJ_EXCEPTION		0x10  /* raise as exception */
+#define MCJ_INTERRUPT		0x20  /* raise as interruption */
 
 #define MCE_OVERFLOW 0		/* bit 0 in flags means overflow */
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index 4cfba43..8428746 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -59,6 +59,16 @@ static void raise_poll(struct mce *m)
 	m->finished = 0;
 }
 
+static void raise_interrupt(struct mce *m)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	mce_threshold_vector();
+	local_irq_restore(flags);
+	m->finished = 0;
+}
+
 static void raise_exception(struct mce *m, struct pt_regs *pregs)
 {
 	struct pt_regs regs;
@@ -89,6 +99,8 @@ static int mce_raise_notify(unsigned int cmd, struct pt_regs *regs)
 	cpumask_clear_cpu(cpu, mce_inject_cpumask);
 	if (m->inject_flags & MCJ_EXCEPTION)
 		raise_exception(m, regs);
+	else if (m->inject_flags & MCJ_INTERRUPT)
+		raise_interrupt(m);
 	else if (m->status)
 		raise_poll(m);
 	return NMI_HANDLED;
@@ -132,6 +144,10 @@ static int raise_local(void)
 			ret = -EINVAL;
 		}
 		printk(KERN_INFO "MCE exception done on CPU %d\n", cpu);
+	} else if (m->inject_flags & MCJ_INTERRUPT) {
+		printk(KERN_INFO "Raising threshold interrupt on CPU %d\n", cpu);
+		raise_interrupt(m);
+		printk(KERN_INFO "Threshold interrupt done on CPU %d\n", cpu);
 	} else if (m->status) {
 		printk(KERN_INFO "Starting machine check poll CPU %d\n", cpu);
 		raise_poll(m);
diff --git a/arch/x86/kernel/cpu/mcheck/threshold.c b/arch/x86/kernel/cpu/mcheck/threshold.c
index 7245980..e324bf9 100644
--- a/arch/x86/kernel/cpu/mcheck/threshold.c
+++ b/arch/x86/kernel/cpu/mcheck/threshold.c
@@ -17,6 +17,7 @@ static void default_threshold_interrupt(void)
 }
 
 void (*mce_threshold_vector)(void) = default_threshold_interrupt;
+EXPORT_SYMBOL_GPL(mce_threshold_vector);
 
 static inline void __smp_threshold_interrupt(void)
 {
-- 
1.7.10.4


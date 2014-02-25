Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981AbaBYA2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 19:28:25 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:53323 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbaBYA1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 19:27:50 -0500
From: Sebastian Capella <sebastian.capella@linaro.org>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org
Cc: Russ Dill <Russ.Dill@ti.com>,
        Sebastian Capella <sebastian.capella@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>, Robin Holt <robin.m.holt@gmail.com>
Subject: [PATCH v2 1/3] ARM: Add irq disabled version of soft_restart.
Date: Mon, 24 Feb 2014 16:27:37 -0800
Message-Id: <1393288059-18174-2-git-send-email-sebastian.capella@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393288059-18174-1-git-send-email-sebastian.capella@linaro.org>
References: <1393288059-18174-1-git-send-email-sebastian.capella@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russ Dill <Russ.Dill@ti.com>

This adds the ability to run soft_restart with local_irq/fiq_disable
already called. This is helpful for the hibernation code paths.

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
Signed-off-by: Sebastian Capella <sebastian.capella@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Robin Holt <robin.m.holt@gmail.com>
---
 arch/arm/include/asm/system_misc.h |    1 +
 arch/arm/kernel/process.c          |   15 ++++++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/system_misc.h b/arch/arm/include/asm/system_misc.h
index a3d61ad..eca8dd4 100644
--- a/arch/arm/include/asm/system_misc.h
+++ b/arch/arm/include/asm/system_misc.h
@@ -10,6 +10,7 @@
 
 extern void cpu_init(void);
 
+void soft_restart_noirq(unsigned long);
 void soft_restart(unsigned long);
 extern void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd);
 extern void (*arm_pm_idle)(void);
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 92f7b15..685bc4a 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -95,14 +95,10 @@ static void __soft_restart(void *addr)
 	BUG();
 }
 
-void soft_restart(unsigned long addr)
+void soft_restart_noirq(unsigned long addr)
 {
 	u64 *stack = soft_restart_stack + ARRAY_SIZE(soft_restart_stack);
 
-	/* Disable interrupts first */
-	local_irq_disable();
-	local_fiq_disable();
-
 	/* Disable the L2 if we're the last man standing. */
 	if (num_online_cpus() == 1)
 		outer_disable();
@@ -114,6 +110,15 @@ void soft_restart(unsigned long addr)
 	BUG();
 }
 
+void soft_restart(unsigned long addr)
+{
+	/* Disable interrupts first */
+	local_irq_disable();
+	local_fiq_disable();
+
+	soft_restart_noirq(addr);
+}
+
 static void null_restart(enum reboot_mode reboot_mode, const char *cmd)
 {
 }
-- 
1.7.9.5


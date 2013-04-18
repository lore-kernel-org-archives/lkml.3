Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936543Ab3DRTac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 15:30:32 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:63036 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935794Ab3DRTaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 15:30:21 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arm@kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH 2/2] clocksource: arm_arch_timer: add boot and suspend sched_clock offset
Date: Thu, 18 Apr 2013 14:30:10 -0500
Message-Id: <1366313410-16692-2-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366313410-16692-1-git-send-email-robherring2@gmail.com>
References: <1366313410-16692-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Commit 023796b (ARM: arch_timer: use full 64-bit counter for sched_clock)
fails to ensure sched_clock always starts at time 0 and counting is
suspended during suspend. arm64 sched_clock support also has the same
issues. This fixes all architected timer users by maintaining an initial
offset which is updated on resume.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/kernel/arch_timer.c         |    1 +
 drivers/clocksource/arm_arch_timer.c |   26 +++++++++++++++++++++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kernel/arch_timer.c b/arch/arm/kernel/arch_timer.c
index df6825e..9a517fe 100644
--- a/arch/arm/kernel/arch_timer.c
+++ b/arch/arm/kernel/arch_timer.c
@@ -42,5 +42,6 @@ int __init arch_timer_arch_init(void)
 	arch_timer_delay_timer_register();
 
 	sched_clock_func = arch_timer_sched_clock;
+
 	return 0;
 }
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 17ed8e4..cc0bd67 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -17,6 +17,7 @@
 #include <linux/interrupt.h>
 #include <linux/of_irq.h>
 #include <linux/io.h>
+#include <linux/syscore_ops.h>
 
 #include <asm/arch_timer.h>
 #include <asm/virt.h>
@@ -267,14 +268,34 @@ static struct notifier_block arch_timer_cpu_nb __cpuinitdata = {
 };
 
 static u64 sched_clock_mult __read_mostly;
+static u64 arch_timer_suspend_cyc;
+static u64 arch_timer_sched_clock_offset;
 
 unsigned long long notrace arch_timer_sched_clock(void)
 {
-	return arch_timer_read_counter() * sched_clock_mult;
+	u64 cyc = arch_timer_read_counter() - arch_timer_sched_clock_offset;
+	return cyc * sched_clock_mult;
 }
 unsigned long long sched_clock(void) \
 	__attribute__((weak, alias("arch_timer_sched_clock")));
 
+static int arch_timer_suspend(void)
+{
+	arch_timer_suspend_cyc = arch_timer_read_counter();
+	return 0;
+}
+
+static void arch_timer_resume(void)
+{
+	arch_timer_sched_clock_offset +=
+		arch_timer_read_counter() - arch_timer_suspend_cyc;
+}
+
+static struct syscore_ops arch_timer_ops = {
+	.suspend = arch_timer_suspend,
+	.resume = arch_timer_resume,
+};
+
 static int __init arch_timer_register(void)
 {
 	int err;
@@ -332,6 +353,9 @@ static int __init arch_timer_register(void)
 	pr_info("sched_clock: ARM arch timer >56 bits at %ukHz, resolution %lluns\n",
 		arch_timer_rate / 1000, sched_clock_mult);
 
+	arch_timer_sched_clock_offset = arch_timer_read_counter();
+	register_syscore_ops(&arch_timer_ops);
+
 	return 0;
 
 out_free_irq:
-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967851Ab3DSQTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 12:19:52 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13957 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221Ab3DSQTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 12:19:49 -0400
X-IronPort-AV: E=Sophos;i="4.87,510,1363158000"; 
   d="scan'208";a="39954133"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mark Rutland <mark.rutland@arm.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCHv5 02/11] clocksource: add generic dummy timer driver
Date: Fri, 19 Apr 2013 09:19:36 -0700
Message-Id: <1366388385-30722-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1.392.g85e7e81
In-Reply-To: <1366388385-30722-1-git-send-email-sboyd@codeaurora.org>
References: <1366388385-30722-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

Several architectures have a dummy timer driver tightly coupled with
their broadcast code to support machines without cpu-local timers (or
where there is a lack of driver support).

Since 12ad100046: "clockevents: Add generic timer broadcast function"
it's been possible to write broadcast-capable timer drivers decoupled
from the broadcast mechanism. We can use this functionality to implement
a generic dummy timer driver that can be shared by all architectures
with generic tick broadcast (ARCH_HAS_TICK_BROADCAST).

This patch implements a generic dummy timer using this facility.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: John Stultz <john.stultz@linaro.org>
[sboyd: Make percpu data static, use __this_cpu_ptr(), move to
        early_initcall to properly register on each CPU, only
	register if more than one CPU possible]
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clocksource/Makefile      |  1 +
 drivers/clocksource/dummy_timer.c | 69 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+)
 create mode 100644 drivers/clocksource/dummy_timer.c

diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index b0400ff..2437363 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -28,3 +28,4 @@ obj-$(CONFIG_CLKSRC_EXYNOS_MCT)	+= exynos_mct.o
 
 obj-$(CONFIG_ARM_ARCH_TIMER)		+= arm_arch_timer.o
 obj-$(CONFIG_CLKSRC_METAG_GENERIC)	+= metag_generic.o
+obj-$(CONFIG_ARCH_HAS_TICK_BROADCAST)	+= dummy_timer.o
diff --git a/drivers/clocksource/dummy_timer.c b/drivers/clocksource/dummy_timer.c
new file mode 100644
index 0000000..1f55f96
--- /dev/null
+++ b/drivers/clocksource/dummy_timer.c
@@ -0,0 +1,69 @@
+/*
+ *  linux/drivers/clocksource/dummy_timer.c
+ *
+ *  Copyright (C) 2013 ARM Ltd.
+ *  All Rights Reserved
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/clockchips.h>
+#include <linux/cpu.h>
+#include <linux/init.h>
+#include <linux/percpu.h>
+#include <linux/cpumask.h>
+
+static DEFINE_PER_CPU(struct clock_event_device, dummy_timer_evt);
+
+static void dummy_timer_set_mode(enum clock_event_mode mode,
+			   struct clock_event_device *evt)
+{
+	/*
+	 * Core clockevents code will call this when exchanging timer devices.
+	 * We don't need to do anything here.
+	 */
+}
+
+static void __cpuinit dummy_timer_setup(void)
+{
+	int cpu = smp_processor_id();
+	struct clock_event_device *evt = __this_cpu_ptr(&dummy_timer_evt);
+
+	evt->name	= "dummy_timer";
+	evt->features	= CLOCK_EVT_FEAT_PERIODIC |
+			  CLOCK_EVT_FEAT_ONESHOT |
+			  CLOCK_EVT_FEAT_DUMMY;
+	evt->rating	= 100;
+	evt->set_mode	= dummy_timer_set_mode;
+	evt->cpumask	= cpumask_of(cpu);
+
+	clockevents_register_device(evt);
+}
+
+static int __cpuinit dummy_timer_cpu_notify(struct notifier_block *self,
+				      unsigned long action, void *hcpu)
+{
+	if ((action & ~CPU_TASKS_FROZEN) == CPU_STARTING)
+		dummy_timer_setup();
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block dummy_timer_cpu_nb __cpuinitdata = {
+	.notifier_call = dummy_timer_cpu_notify,
+};
+
+static int __init dummy_timer_register(void)
+{
+	int err = register_cpu_notifier(&dummy_timer_cpu_nb);
+	if (err)
+		return err;
+
+	/* We won't get a call on the boot CPU, so register immediately */
+	if (num_possible_cpus() > 1)
+		dummy_timer_setup();
+
+	return 0;
+}
+early_initcall(dummy_timer_register);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


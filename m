Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068Ab3CGAEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 19:04:13 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36435 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076Ab3CGAEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 19:04:09 -0500
X-IronPort-AV: E=Sophos;i="4.84,798,1355126400"; 
   d="scan'208";a="27738007"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Mark Rutland <mark.rutland@arm.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 01/10] clocksource: add generic dummy timer driver
Date: Wed,  6 Mar 2013 16:03:57 -0800
Message-Id: <1362614646-24113-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.rc2.4.g7799588
In-Reply-To: <1362614646-24113-1-git-send-email-sboyd@codeaurora.org>
References: <1362614646-24113-1-git-send-email-sboyd@codeaurora.org>
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
Cc: Thomas Gleixner <tglx@linutronix.de>
[sboyd: Make percpu data static, use __this_cpu_ptr(), s/dummy/dummy_timer/]
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clocksource/Makefile      |  1 +
 drivers/clocksource/dummy_timer.c | 67 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)
 create mode 100644 drivers/clocksource/dummy_timer.c

diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 4d8283a..655d718 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -22,3 +22,4 @@ obj-$(CONFIG_VT8500_TIMER)	+= vt8500_timer.o
 
 obj-$(CONFIG_ARM_ARCH_TIMER)		+= arm_arch_timer.o
 obj-$(CONFIG_CLKSRC_METAG_GENERIC)	+= metag_generic.o
+obj-$(CONFIG_ARCH_HAS_TICK_BROADCAST)	+= dummy_timer.o
diff --git a/drivers/clocksource/dummy_timer.c b/drivers/clocksource/dummy_timer.c
new file mode 100644
index 0000000..7e1ce45
--- /dev/null
+++ b/drivers/clocksource/dummy_timer.c
@@ -0,0 +1,67 @@
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
+	dummy_timer_setup();
+
+	return 0;
+}
+device_initcall(dummy_timer_register);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


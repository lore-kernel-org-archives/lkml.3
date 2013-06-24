Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408Ab3FXUbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 16:31:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32937 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab3FXUbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 16:31:07 -0400
Date: Mon, 24 Jun 2013 13:30:51 -0700
From: tip-bot for Mark Rutland <tipbot@zytor.com>
Message-ID: <tip-064706514ec3fea740c2656e03c4f01f6a551ac4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        mark.rutland@arm.com, sboyd@codeaurora.org, john.stultz@linaro.org,
        tglx@linutronix.de, daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, sboyd@codeaurora.org, john.stultz@linaro.org,
        tglx@linutronix.de, daniel.lezcano@linaro.org
In-Reply-To: <1370291642-13259-3-git-send-email-sboyd@codeaurora.org>
References: <1370291642-13259-3-git-send-email-sboyd@codeaurora.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clocksource: Add generic dummy timer driver
Git-Commit-ID: 064706514ec3fea740c2656e03c4f01f6a551ac4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 24 Jun 2013 13:30:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  064706514ec3fea740c2656e03c4f01f6a551ac4
Gitweb:     http://git.kernel.org/tip/064706514ec3fea740c2656e03c4f01f6a551ac4
Author:     Mark Rutland <mark.rutland@arm.com>
AuthorDate: Mon, 3 Jun 2013 13:33:53 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 24 Jun 2013 22:27:37 +0200

clocksource: Add generic dummy timer driver

Several architectures have a dummy timer driver tightly coupled with
their broadcast code to support machines without cpu-local timers (or
where there is a lack of driver support).

Since 12ad100046: "clockevents: Add generic timer broadcast function"
it's been possible to write broadcast-capable timer drivers decoupled
from the broadcast mechanism. We can use this functionality to implement
a generic dummy timer driver that can be shared by all architectures
with generic tick broadcast (ARCH_HAS_TICK_BROADCAST).

This patch implements a generic dummy timer using this facility.

[sboyd: Make percpu data static, use __this_cpu_ptr(), move to
        early_initcall to properly register on each CPU, only
	register if more than one CPU possible]

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>,
Cc: John Stultz <john.stultz@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Link: http://lkml.kernel.org/r/1370291642-13259-3-git-send-email-sboyd@codeaurora.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/clocksource/Makefile      |  1 +
 drivers/clocksource/dummy_timer.c | 69 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+)

diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 4853ea0..9ba8b4d 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -31,3 +31,4 @@ obj-$(CONFIG_VF_PIT_TIMER)	+= vf_pit_timer.o
 
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

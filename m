Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420Ab3BYNlG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 08:41:06 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42170 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756452Ab3BYNlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 08:41:04 -0500
Date: Mon, 25 Feb 2013 13:40:41 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/8] ARM: smp: Remove local timer API
Message-ID: <20130225134041.GA22785@e106331-lin.cambridge.arm.com>
References: <1361518039-16663-1-git-send-email-sboyd@codeaurora.org>
 <1361518039-16663-9-git-send-email-sboyd@codeaurora.org>
 <20130222111545.GA15020@e106331-lin.cambridge.arm.com>
 <20130222162458.GA19670@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130222162458.GA19670@linux-sh.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 04:25:00PM +0000, Paul Mundt wrote:
> On Fri, Feb 22, 2013 at 11:15:45AM +0000, Mark Rutland wrote:
> > One thing that struck me when I was fiddling with the broadcast mechanism was
> > that it should be possible to have a generic dummy timer implementation. As
> > long as the architecture calls notifiers at the appropriate times, it should
> > look like any other timer driver (apart from not touching any hardware). It just
> > needs to depend on ARCH_HAS_TICK_BROADCAST.
> > 
> > I believe it shouldn't be too difficult to implement, though I may be blind to
> > some problems.
> > 
> It would be nice to have a generic dummy timer driver, quite a few
> architectures could use it directly already. If no one beats me to it,
> I'll give it a go as I convert the SH stuff over to using
> ARCH_HAS_TICK_BROADCAST and killing off the local timer API there.
> 

I've had a quick go at writing a generic timer driver. I've not had a chance to
test it, and there are a couple of things that are up for discussion (e.g. what
should the rating be) but I think we want something very close to this.

Thanks,
Mark.

---->8----

>From 1ca7fdf68fbb9b026237803db8c55a34b4f2cfa2 Mon Sep 17 00:00:00 2001
From: Mark Rutland <mark.rutland@arm.com>
Date: Sun, 24 Feb 2013 22:31:24 +0000
Subject: [PATCH] clocksource: add generic dummy timer driver

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
---
 drivers/clocksource/Makefile      |  1 +
 drivers/clocksource/dummy_timer.c | 67 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)
 create mode 100644 drivers/clocksource/dummy_timer.c

diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 7d671b8..8f2b13f 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -21,3 +21,4 @@ obj-$(CONFIG_ARCH_TEGRA)	+= tegra20_timer.o
 obj-$(CONFIG_VT8500_TIMER)	+= vt8500_timer.o
 
 obj-$(CONFIG_ARM_ARCH_TIMER)		+= arm_arch_timer.o
+obj-$(CONFIG_ARCH_HAS_TICK_BROADCAST)	+= dummy_timer.o
diff --git a/drivers/clocksource/dummy_timer.c b/drivers/clocksource/dummy_timer.c
new file mode 100644
index 0000000..bdaba34
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
+DEFINE_PER_CPU(struct clock_event_device, dummy_evt);
+
+static void dummy_set_mode(enum clock_event_mode mode,
+			   struct clock_event_device *evt)
+{
+	/*
+	 * Core clockevents code will call this when exchanging timer devices.
+	 * We don't need to do anything here.
+	 */
+}
+
+static void __cpuinit dummy_setup(void)
+{
+	int cpu = smp_processor_id();
+	struct clock_event_device *evt = &per_cpu(dummy_evt, cpu);
+
+	evt->name	= "dummy timer";
+	evt->features	= CLOCK_EVT_FEAT_PERIODIC |
+			  CLOCK_EVT_FEAT_ONESHOT |
+			  CLOCK_EVT_FEAT_DUMMY;
+	evt->rating	= 100;
+	evt->set_mode	= dummy_set_mode;
+	evt->cpumask	= cpumask_of(cpu);
+
+	clockevents_register_device(evt);
+}
+
+static int __cpuinit dummy_cpu_notify(struct notifier_block *self,
+				      unsigned long action, void *hcpu)
+{
+	if ((action & ~CPU_TASKS_FROZEN) == CPU_STARTING)
+		dummy_setup();
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block dummy_cpu_nb __cpuinitdata = {
+	.notifier_call = dummy_cpu_notify,
+};
+
+static int __init dummy_register(void)
+{
+	int err = register_cpu_notifier(&dummy_cpu_nb);
+	if (err)
+		return err;
+
+	/* We won't get a call on the boot CPU, so register immediately */
+	dummy_setup();
+
+	return 0;
+}
+device_initcall(dummy_register);
-- 
1.8.1.1


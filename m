Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400Ab3DYUbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 16:31:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:46033 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759313Ab3DYUbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 16:31:51 -0400
Message-Id: <20130425143436.371634778@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 25 Apr 2013 20:31:49 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 13/15] clockevents: Provide sysfs interface
References: <20130425142452.908423538@linutronix.de>
Content-Disposition: inline; filename=clockevents-provide-sysfs-interface.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a simple sysfs interface for the clockevent devices. Show the
current active clockevent device.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/clockevents.c |   86 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

Index: tip/kernel/time/clockevents.c
===================================================================
--- tip.orig/kernel/time/clockevents.c
+++ tip/kernel/time/clockevents.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/smp.h>
+#include <linux/device.h>
 
 #include "tick-internal.h"
 
@@ -460,4 +461,89 @@ void clockevents_notify(unsigned long re
 	raw_spin_unlock_irqrestore(&clockevents_lock, flags);
 }
 EXPORT_SYMBOL_GPL(clockevents_notify);
+
+#ifdef CONFIG_SYSFS
+struct bus_type clockevents_subsys = {
+	.name		= "clockevents",
+	.dev_name       = "clockevent",
+};
+
+static DEFINE_PER_CPU(struct device, tick_percpu_dev);
+static struct tick_device *tick_get_tick_dev(struct device *dev);
+
+static ssize_t sysfs_show_current_tick_dev(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	struct tick_device *td;
+	ssize_t count = 0;
+
+	raw_spin_lock_irq(&clockevents_lock);
+	td = tick_get_tick_dev(dev);
+	if (td && td->evtdev)
+		count = snprintf(buf, PAGE_SIZE, "%s\n", td->evtdev->name);
+	raw_spin_unlock_irq(&clockevents_lock);
+	return count;
+}
+static DEVICE_ATTR(current_device, 0444, sysfs_show_current_tick_dev, NULL);
+
+#ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
+static struct device tick_bc_dev = {
+	.init_name	= "broadcast",
+	.id		= 0,
+	.bus		= &clockevents_subsys,
+};
+
+static struct tick_device *tick_get_tick_dev(struct device *dev)
+{
+	return dev == &tick_bc_dev ? tick_get_broadcast_device() :
+		&per_cpu(tick_cpu_device, dev->id);
+}
+
+static int tick_broadcast_init_sysfs(void)
+{
+	int err = device_register(&tick_bc_dev);
+
+	if (!err)
+		err = device_create_file(&tick_bc_dev, &dev_attr_current_device);
+	return err;
+}
+#else
+static struct tick_device *tick_get_tick_dev(struct device *dev)
+{
+	return &per_cpu(tick_cpu_device, dev->id);
+}
+static inline int tick_broadcast_init_sysfs(void) { return 0; }
 #endif
+
+int __init tick_init_sysfs(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		struct device *dev = &per_cpu(tick_percpu_dev, cpu);
+		int err;
+
+		dev->id = cpu;
+		dev->bus = &clockevents_subsys;
+		err = device_register(dev);
+		if (!err)
+			err = device_create_file(dev, &dev_attr_current_device);
+		if (err)
+			return err;
+	}
+	return tick_broadcast_init_sysfs();
+}
+
+static int __init clockevents_init_sysfs(void)
+{
+	int err = subsys_system_register(&clockevents_subsys, NULL);
+
+	if (!err)
+		err = tick_init_sysfs();
+	return err;
+}
+device_initcall(clockevents_init_sysfs);
+#endif /* SYSFS */
+
+#endif /* GENERIC_CLOCK_EVENTS */



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab3E0J4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 05:56:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35587 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010Ab3E0J4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 05:56:49 -0400
Date: Mon, 27 May 2013 02:56:33 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-501f867064e95f9a6f540e60705be0937280e7ec@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        magnus.damm@gmail.com
In-Reply-To: <20130425143436.371634778@linutronix.de>
References: <20130425143436.371634778@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clockevents: Provide sysfs interface
Git-Commit-ID: 501f867064e95f9a6f540e60705be0937280e7ec
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  501f867064e95f9a6f540e60705be0937280e7ec
Gitweb:     http://git.kernel.org/tip/501f867064e95f9a6f540e60705be0937280e7ec
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 25 Apr 2013 20:31:49 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 16 May 2013 11:09:17 +0200

clockevents: Provide sysfs interface

Provide a simple sysfs interface for the clockevent devices. Show the
current active clockevent device.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Magnus Damm <magnus.damm@gmail.com>
Link: http://lkml.kernel.org/r/20130425143436.371634778@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/clockevents.c | 86 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 89e394c..0a23f4f 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/smp.h>
+#include <linux/device.h>
 
 #include "tick-internal.h"
 
@@ -460,4 +461,89 @@ void clockevents_notify(unsigned long reason, void *arg)
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
+static __init int tick_broadcast_init_sysfs(void)
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
+static int __init tick_init_sysfs(void)
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

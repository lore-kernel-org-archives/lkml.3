Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbaCLTrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 15:47:09 -0400
Received: from mail-ie0-f202.google.com ([209.85.223.202]:63626 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaCLTrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 15:47:06 -0400
From: Ruchi Kandoi <kandoiruchi@google.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: rjw@rjwysocki.net, ghackmann@google.com, john.stultz@linaro.org,
        toddpoynor@google.com, Ruchi Kandoi <kandoiruchi@google.com>
Subject: [PATCH v3] power: add an API to log wakeup reasons
Date: Wed, 12 Mar 2014 12:46:38 -0700
Message-Id: <1394653598-17143-1-git-send-email-kandoiruchi@google.com>
X-Mailer: git-send-email 1.9.0.279.gdc9e3eb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For power management diagnostic purposes, it is often useful to know
what interrupts are frequently waking the system from low power
suspend mode, especially on battery-powered consumer electronics
devices that are expected to spend much of their time in low-power
suspend while not in active use.  For example, reduced battery life on
a mobile phone may be caused in part by frequent wakeups by broadcast
traffic on a busy wireless LAN even while the screen is off and the
phone not in active use.

Add API log_wakeup_reason() exposes it to userspace via the sysfs path
/sys/kernel/wakeup_reasons/last_resume_reason. This API would be called
from the paltform specific, or from the driver for the interrupt controller,
when the system resumes because of an IRQ. It logs the reasons which caused
the system to wakeup from the low-power mode.

This information can be collected by userspace as part of the accounting
kept on power consumption.

Signed-off-by: Ruchi Kandoi <kandoiruchi@google.com>
Signed-off-by: Greg Hackmann <ghackmann@google.com>
---
commit message changed for clarity
---
 include/linux/wakeup_reason.h |  23 +++++++
 kernel/power/Makefile         |   2 +-
 kernel/power/wakeup_reason.c  | 141 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 165 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/wakeup_reason.h
 create mode 100644 kernel/power/wakeup_reason.c

diff --git a/include/linux/wakeup_reason.h b/include/linux/wakeup_reason.h
new file mode 100644
index 0000000..7ce50f0
--- /dev/null
+++ b/include/linux/wakeup_reason.h
@@ -0,0 +1,23 @@
+/*
+ * include/linux/wakeup_reason.h
+ *
+ * Logs the reason which caused the kernel to resume
+ * from the suspend mode.
+ *
+ * Copyright (C) 2014 Google, Inc.
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _LINUX_WAKEUP_REASON_H
+#define _LINUX_WAKEUP_REASON_H
+
+void log_wakeup_reason(int irq);
+
+#endif /* _LINUX_WAKEUP_REASON_H */
diff --git a/kernel/power/Makefile b/kernel/power/Makefile
index 29472bf..f98f021 100644
--- a/kernel/power/Makefile
+++ b/kernel/power/Makefile
@@ -5,7 +5,7 @@ obj-y				+= qos.o
 obj-$(CONFIG_PM)		+= main.o
 obj-$(CONFIG_VT_CONSOLE_SLEEP)	+= console.o
 obj-$(CONFIG_FREEZER)		+= process.o
-obj-$(CONFIG_SUSPEND)		+= suspend.o
+obj-$(CONFIG_SUSPEND)		+= suspend.o wakeup_reason.o
 obj-$(CONFIG_PM_TEST_SUSPEND)	+= suspend_test.o
 obj-$(CONFIG_HIBERNATION)	+= hibernate.o snapshot.o swap.o user.o \
 				   block_io.o
diff --git a/kernel/power/wakeup_reason.c b/kernel/power/wakeup_reason.c
new file mode 100644
index 0000000..a21c592
--- /dev/null
+++ b/kernel/power/wakeup_reason.c
@@ -0,0 +1,141 @@
+/*
+ * kernel/power/wakeup_reason.c
+ *
+ * Logs the reasons which caused the kernel to resume from
+ * the suspend mode.
+ *
+ * Copyright (C) 2014 Google, Inc.
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#define pr_fmt(fmt) "wakeup_reason:" fmt
+
+#include <linux/wakeup_reason.h>
+#include <linux/kernel.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
+#include <linux/init.h>
+#include <linux/spinlock.h>
+#include <linux/notifier.h>
+#include <linux/suspend.h>
+
+
+#define MAX_WAKEUP_REASON_IRQS 32
+static int irq_list[MAX_WAKEUP_REASON_IRQS];
+static int irqcount;
+static struct kobject *wakeup_reason;
+static spinlock_t resume_reason_lock;
+
+static ssize_t reason_show(struct kobject *kobj, struct kobj_attribute *attr,
+		char *buf)
+{
+	int irq_no, buf_offset = 0;
+	struct irq_desc *desc;
+	spin_lock(&resume_reason_lock);
+	for (irq_no = 0; irq_no < irqcount; irq_no++) {
+		desc = irq_to_desc(irq_list[irq_no]);
+		if (desc && desc->action && desc->action->name)
+			buf_offset += sprintf(buf + buf_offset, "%d %s\n",
+					irq_list[irq_no], desc->action->name);
+		else
+			buf_offset += sprintf(buf + buf_offset, "%d\n",
+					irq_list[irq_no]);
+	}
+	spin_unlock(&resume_reason_lock);
+	return buf_offset;
+}
+
+static struct kobj_attribute resume_reason = __ATTR(last_resume_reason, 0666,
+		reason_show, NULL);
+
+static struct attribute *attrs[] = {
+	&resume_reason.attr,
+	NULL,
+};
+static struct attribute_group attr_group = {
+	.attrs = attrs,
+};
+
+/*
+ * logs all the wake up reasons to the kernel
+ * stores the irqs to expose them to the userspace via sysfs
+ */
+void log_wakeup_reason(int irq)
+{
+	struct irq_desc *desc;
+	desc = irq_to_desc(irq);
+	if (desc && desc->action && desc->action->name)
+		pr_info("Resume caused by IRQ %d, %s\n", irq,
+				desc->action->name);
+	else
+		pr_info("Resume caused by IRQ %d\n", irq);
+
+	spin_lock(&resume_reason_lock);
+	if (irqcount >= MAX_WAKEUP_REASON_IRQS) {
+		spin_unlock(&resume_reason_lock);
+		pr_warn("Resume caused by more than %d IRQs\n",
+				MAX_WAKEUP_REASON_IRQS);
+		return;
+	}
+
+	irq_list[irqcount++] = irq;
+	spin_unlock(&resume_reason_lock);
+}
+
+/* Detects a suspend and clears all the previous wake up reasons*/
+static int wakeup_reason_pm_event(struct notifier_block *notifier,
+		unsigned long pm_event, void *unused)
+{
+	switch (pm_event) {
+	case PM_SUSPEND_PREPARE:
+		spin_lock(&resume_reason_lock);
+		irqcount = 0;
+		spin_unlock(&resume_reason_lock);
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block wakeup_reason_pm_notifier_block = {
+	.notifier_call = wakeup_reason_pm_event,
+};
+
+/* Initializes the sysfs parameter
+ * registers the pm_event notifier
+ */
+int __init wakeup_reason_init(void)
+{
+	int retval;
+	spin_lock_init(&resume_reason_lock);
+	retval = register_pm_notifier(&wakeup_reason_pm_notifier_block);
+	if (retval)
+		pr_warn("%s: failed to register PM notifier %d\n",
+				__func__, retval);
+
+	wakeup_reason = kobject_create_and_add("wakeup_reasons", kernel_kobj);
+	if (!wakeup_reason) {
+		pr_warn("%s: failed to create a sysfs kobject\n",
+				__func__);
+		return 1;
+	}
+	retval = sysfs_create_group(wakeup_reason, &attr_group);
+	if (retval) {
+		kobject_put(wakeup_reason);
+		pr_warn("%s: failed to create a sysfs group %d\n",
+				__func__, retval);
+	}
+	return 0;
+}
+
+late_initcall(wakeup_reason_init);
-- 
1.9.0.279.gdc9e3eb


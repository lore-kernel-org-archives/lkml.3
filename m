Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbaBYMgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 07:36:43 -0500
Received: from asav4.altibox.net ([81.167.36.153]:49790 "EHLO
	asav4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbaBYMgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 07:36:39 -0500
From: Henrik Austad <henrik@austad.us>
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linuxtronix.de>
Cc: Henrik Austad <henrik@austad.us>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Henrik Austad <haustad@cisco.com>
Subject: [PATCH 2/6] Add sysfs RO interface to tick_do_timer_cpu
Date: Tue, 25 Feb 2014 13:33:57 +0100
Message-Id: <1393331641-14016-3-git-send-email-henrik@austad.us>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1393331641-14016-1-git-send-email-henrik@austad.us>
References: <1393331641-14016-1-git-send-email-henrik@austad.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of this is 'extras' needed in order to get sysfs working.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: John Stultz <john.stultz@linaro.org>

Signed-off-by: Henrik Austad <haustad@cisco.com>
---
 kernel/time/timekeeping.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 0aa4ce8..f7c6b1f 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -22,11 +22,54 @@
 #include <linux/tick.h>
 #include <linux/stop_machine.h>
 #include <linux/pvclock_gtod.h>
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
 
 #include "tick-internal.h"
 #include "ntp_internal.h"
 #include "timekeeping_internal.h"
 
+/*
+ * sysfs interface to timer-cpu
+ */
+static ssize_t current_cpu_show(struct kobject *kobj,
+				struct kobj_attribute *attr,
+				char *buf)
+{
+	return sprintf(buf, "%d\n", tick_expose_cpu());
+}
+
+static struct kobj_attribute current_cpu_attribute =
+	__ATTR_RO(current_cpu);
+
+static struct attribute *timekeeping_attrs[] = {
+	&current_cpu_attribute.attr,
+	NULL,
+};
+static struct attribute_group timekeeping_ag = {
+	.attrs = timekeeping_attrs,
+};
+static struct kobject *timekeeping_kobj;
+
+static __init int timekeeping_sysfs_init(void)
+{
+	int ret = 0;
+
+	timekeeping_kobj = kobject_create_and_add("timekeeping", kernel_kobj);
+	if (!timekeeping_kobj)
+		return -ENOMEM;
+
+	ret = sysfs_create_group(timekeeping_kobj, &timekeeping_ag);
+	if (ret) {
+		pr_err("timekeeping: could not create attribute-group %d\n", ret);
+		kobject_put(timekeeping_kobj);
+	}
+	return ret;
+}
+
+/* need to make sure that kobj and sysfs is initialized before running this */
+late_initcall(timekeeping_sysfs_init);
+
 #define TK_CLEAR_NTP		(1 << 0)
 #define TK_MIRROR		(1 << 1)
 #define TK_CLOCK_WAS_SET	(1 << 2)
-- 
1.7.9.5


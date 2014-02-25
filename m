Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbaBYMhj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 07:37:39 -0500
Received: from asav4.altibox.net ([81.167.36.153]:49841 "EHLO
	asav4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbaBYMgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 07:36:41 -0500
From: Henrik Austad <henrik@austad.us>
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linuxtronix.de>
Cc: Henrik Austad <haustad@cisco.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 6/6] Expose tick_set_forced_cpu() via sysfs
Date: Tue, 25 Feb 2014 13:34:01 +0100
Message-Id: <1393331641-14016-7-git-send-email-henrik@austad.us>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1393331641-14016-1-git-send-email-henrik@austad.us>
References: <1393331641-14016-1-git-send-email-henrik@austad.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Henrik Austad <haustad@cisco.com>

This allows userspace to set the forced CPU via sysfs in
/sys/kernel/timekeeping/forced_cpu.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: John Stultz <john.stultz@linaro.org>
CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Henrik Austad <haustad@cisco.com>
---
 kernel/time/timekeeping.c |   36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 4bdfa11..b148062 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -44,23 +44,47 @@ int expose_tick_forced_timer_cpu = -1;
 /*
  * sysfs interface to timer-cpu
  */
-static ssize_t current_cpu_show(struct kobject *kobj,
-				struct kobj_attribute *attr,
-				char *buf)
-{
-	return sprintf(buf, "%d\n", tick_expose_cpu());
+static ssize_t cpu_show(struct kobject *kobj,
+			struct kobj_attribute *attr,
+			char *buf)
+{
+	int var = -EINVAL;
+	if (strcmp(attr->attr.name, "current_cpu") == 0)
+		var = sprintf(buf, "%d\n", tick_expose_cpu());
+	else if (strcmp(attr->attr.name, "forced_cpu") == 0)
+		var = sprintf(buf, "%d\n", tick_get_forced_cpu());
+	return var;
+}
+
+static ssize_t cpu_store(struct kobject *kobj,
+			struct kobj_attribute *attr,
+			const char * buf,
+			size_t count)
+{
+	int var = 0;
+	if (strcmp(attr->attr.name, "forced_cpu") == 0) {
+		sscanf(buf, "%du", &var);
+		if ((var = tick_set_forced_cpu(var)) != 0) {
+			pr_err("trouble setting forced CPU (%d)\n", var);
+		}
+	}
+	return count;
 }
 
 static struct kobj_attribute current_cpu_attribute =
-	__ATTR_RO(current_cpu);
+	__ATTR(current_cpu, 0444, cpu_show, NULL);
+static struct kobj_attribute forced_cpu_attribute =
+	__ATTR(forced_cpu, 0644, cpu_show, cpu_store);
 
 static struct attribute *timekeeping_attrs[] = {
 	&current_cpu_attribute.attr,
+	&forced_cpu_attribute.attr,
 	NULL,
 };
 static struct attribute_group timekeeping_ag = {
 	.attrs = timekeeping_attrs,
 };
+
 static struct kobject *timekeeping_kobj;
 
 static __init int timekeeping_sysfs_init(void)
-- 
1.7.9.5


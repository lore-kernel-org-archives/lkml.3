Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaHSPQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:16:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:60398 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760AbaHSPQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:16:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,894,1400050800"; 
   d="scan'208";a="560606575"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, rusty@rustcorp.com.au
Subject: [PATCH 1/2] params: Add a per cpu module param type
Date: Tue, 19 Aug 2014 08:16:28 -0700
Message-Id: <1408461389-24163-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This is mainly useful for simple statistic counters.
Essentially read-only, writing only clears.

Cc: rusty@rustcorp.com.au
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/moduleparam.h |  4 ++++
 kernel/params.c             | 28 ++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 494f99e..d019ad2 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -408,6 +408,10 @@ extern int param_set_bint(const char *val, const struct kernel_param *kp);
 #define param_get_bint param_get_int
 #define param_check_bint param_check_int
 
+/* A per cpu read-only unsigned integer. Useful for counters. */
+extern struct kernel_param_ops param_ops_percpu_uint;
+#define param_check_percpu_uint(name, p) param_check_uint
+
 /**
  * module_param_array - a parameter which is an array of some type
  * @name: the name of the array variable
diff --git a/kernel/params.c b/kernel/params.c
index 34f5270..700badd 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -499,6 +499,34 @@ struct kernel_param_ops param_ops_string = {
 };
 EXPORT_SYMBOL(param_ops_string);
 
+/* Per CPU read only module param. */
+
+static int param_percpu_uint_set(const char *val, const struct kernel_param *kp)
+{
+	int cpu;
+
+	/* just clear on any write */
+	for_each_possible_cpu(cpu)
+		*per_cpu_ptr((unsigned * __percpu)(kp->arg), cpu) = 0;
+	return 0;
+}
+
+static int param_percpu_uint_get(char *buffer, const struct kernel_param *kp)
+{
+	int cpu;
+	unsigned count = 0;
+
+	for_each_possible_cpu(cpu)
+		count += *per_cpu_ptr((unsigned * __percpu)(kp->arg), cpu);
+	return sprintf(buffer, "%u", count);
+}
+
+struct kernel_param_ops param_ops_percpu_uint = {
+	.set = param_percpu_uint_set,
+	.get = param_percpu_uint_get,
+};
+EXPORT_SYMBOL(param_ops_percpu_uint);
+
 /* sysfs output in /sys/modules/XYZ/parameters/ */
 #define to_module_attr(n) container_of(n, struct module_attribute, attr)
 #define to_module_kobject(n) container_of(n, struct module_kobject, kobj)
-- 
1.9.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423148Ab3CWB2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 21:28:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:62847 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422971Ab3CWBZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 21:25:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,896,1355126400"; 
   d="scan'208";a="283455609"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>, rusty@rustcorp.co.au
Subject: [PATCH 13/29] params: Add a per cpu module param type
Date: Fri, 22 Mar 2013 18:25:07 -0700
Message-Id: <1364001923-10796-14-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This is mainly useful for simple statistic counters.
Essentially read-only, writing only clears.

Cc: rusty@rustcorp.co.au
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/moduleparam.h |    4 ++++
 kernel/params.c             |   28 ++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 137b419..e3c41af 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -394,6 +394,10 @@ extern int param_set_bint(const char *val, const struct kernel_param *kp);
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
index ed35345..1a8a1ca 100644
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
1.7.7.6


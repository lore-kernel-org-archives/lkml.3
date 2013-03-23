Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423236Ab3CWBbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 21:31:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:44419 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422840Ab3CWBZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 21:25:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,896,1355126400"; 
   d="scan'208";a="306338476"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>, rusty@rustcorp.co.au
Subject: [PATCH 14/29] params: Add static key module param
Date: Fri, 22 Mar 2013 18:25:08 -0700
Message-Id: <1364001923-10796-15-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a module param type for uint static keys. Useful for
time critical flags.

Cc: rusty@rustcorp.co.au
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/moduleparam.h |    6 ++++++
 kernel/params.c             |   35 +++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index e3c41af..ac815d2 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -398,6 +398,12 @@ extern int param_set_bint(const char *val, const struct kernel_param *kp);
 extern struct kernel_param_ops param_ops_percpu_uint;
 #define param_check_percpu_uint(name, p) param_check_uint
 
+/* Static key module params. Useful for time critical flags. */
+struct static_key;
+extern struct kernel_param_ops param_ops_static_key;
+#define param_check_static_key(name, p) \
+	__param_check(name, p, struct static_key)
+
 /**
  * module_param_array - a parameter which is an array of some type
  * @name: the name of the array variable
diff --git a/kernel/params.c b/kernel/params.c
index 1a8a1ca..68f9482 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -23,6 +23,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/ctype.h>
+#include <linux/jump_label.h>
 
 /* Protects all parameters, and incidentally kmalloced_param list. */
 static DEFINE_MUTEX(param_lock);
@@ -527,6 +528,40 @@ struct kernel_param_ops param_ops_percpu_uint = {
 };
 EXPORT_SYMBOL(param_ops_percpu_uint);
 
+/* Static key module params. Like a bool, but allows patching the jumps. */
+
+/* Noone else should change */
+static int param_static_key_set(const char *val, const struct kernel_param *kp)
+{
+	static DEFINE_SPINLOCK(lock);
+	bool l;
+	struct static_key *key = (struct static_key *)(kp->arg);
+	int ret = strtobool(val, &l);
+
+	if (ret < 0)
+		return ret;
+	/* Work around racy static key interface */
+	spin_lock(&lock);
+	if (l && !atomic_read(&key->enabled))
+		static_key_slow_inc(key);
+	if (!l && atomic_read(&key->enabled))
+		static_key_slow_dec(key);
+	spin_unlock(&lock);
+	return ret;
+}
+
+static int param_static_key_get(char *buffer, const struct kernel_param *kp)
+{
+	struct static_key *key = kp->arg;
+	return sprintf(buffer, "%u", atomic_read(&key->enabled) > 0);
+}
+
+struct kernel_param_ops param_ops_static_key = {
+	.set = param_static_key_set,
+	.get = param_static_key_get,
+};
+EXPORT_SYMBOL(param_ops_static_key);
+
 /* sysfs output in /sys/modules/XYZ/parameters/ */
 #define to_module_attr(n) container_of(n, struct module_attribute, attr)
 #define to_module_kobject(n) container_of(n, struct module_kobject, kobj)
-- 
1.7.7.6


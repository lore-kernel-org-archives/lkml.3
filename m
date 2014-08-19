Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbaHSPR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:17:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:13565 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583AbaHSPRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:17:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,894,1400050800"; 
   d="scan'208";a="586944649"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, rusty@rustcorp.com.au
Subject: [PATCH 2/2] params: Add static key module param
Date: Tue, 19 Aug 2014 08:16:29 -0700
Message-Id: <1408461389-24163-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408461389-24163-1-git-send-email-andi@firstfloor.org>
References: <1408461389-24163-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a module param type for static keys. Useful for
time critical flags.

The basic jump_label interface is racy for boolean settings,
because checking and changing is not atomic, so we use an
additional lock

Open: should use deferred keys? But as it's only root changeable
changes should be very rare. Would need some changes to jump
labels.

Cc: rusty@rustcorp.com.au
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/moduleparam.h |  6 ++++++
 kernel/params.c             | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index d019ad2..30cdad8 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -412,6 +412,12 @@ extern int param_set_bint(const char *val, const struct kernel_param *kp);
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
index 700badd..d176ae8 100644
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
1.9.3


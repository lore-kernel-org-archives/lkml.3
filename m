Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbaHKNyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:54:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:62232 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722AbaHKNyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:54:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,841,1400050800"; 
   d="scan'208";a="586460633"
From: Jani Nikula <jani.nikula@intel.com>
To: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Jean Delvare <khali@linux-fr.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Jon Mason <jon.mason@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, jani.nikula@intel.com
Subject: [PATCH 2/4] module: make it possible to have unsafe, tainting module params
Date: Mon, 11 Aug 2014 16:52:20 +0300
Message-Id: <37d51289add759683fd3c70b664a0601432abeed.1407764272.git.jani.nikula@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1407764272.git.jani.nikula@intel.com>
References: <cover.1407764272.git.jani.nikula@intel.com>
In-Reply-To: <cover.1407764272.git.jani.nikula@intel.com>
References: <cover.1407764272.git.jani.nikula@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add flags field to struct kernel_params, and add the first flag: unsafe
parameter. Modifying a kernel parameter with the unsafe flag set, either
via the kernel command line or sysfs, will issue a warning and taint the
kernel.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Jon Mason <jon.mason@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
---
 drivers/tty/serial/8250/8250_core.c |  2 +-
 include/linux/moduleparam.h         | 44 +++++++++++++++++++++++++++++--------
 kernel/params.c                     | 11 ++++++++++
 3 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 1d42dba6121d..bd672948f2f1 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -3587,7 +3587,7 @@ static void __used s8250_options(void)
 #ifdef CONFIG_SERIAL_8250_RSA
 	__module_param_call(MODULE_PARAM_PREFIX, probe_rsa,
 		&param_array_ops, .arr = &__param_arr_probe_rsa,
-		0444, -1);
+		0444, -1, 0);
 #endif
 }
 #else
diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 16fdddab856a..1e3ffb839daa 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -56,11 +56,21 @@ struct kernel_param_ops {
 	void (*free)(void *arg);
 };
 
+/*
+ * Flags available for kernel_param
+ *
+ * UNSAFE - the parameter is dangerous and setting it will taint the kernel
+ */
+enum {
+	KERNEL_PARAM_FL_UNSAFE = (1 << 0)
+};
+
 struct kernel_param {
 	const char *name;
 	const struct kernel_param_ops *ops;
 	u16 perm;
-	s16 level;
+	s8 level;
+	u8 flags;
 	union {
 		void *arg;
 		const struct kparam_string *str;
@@ -137,7 +147,7 @@ struct kparam_array
  * The ops can have NULL set or get functions.
  */
 #define module_param_cb(name, ops, arg, perm)				      \
-	__module_param_call(MODULE_PARAM_PREFIX, name, ops, arg, perm, -1)
+	__module_param_call(MODULE_PARAM_PREFIX, name, ops, arg, perm, -1, 0)
 
 /**
  * <level>_param_cb - general callback for a module/cmdline parameter
@@ -149,7 +159,7 @@ struct kparam_array
  * The ops can have NULL set or get functions.
  */
 #define __level_param_cb(name, ops, arg, perm, level)			\
-	__module_param_call(MODULE_PARAM_PREFIX, name, ops, arg, perm, level)
+	__module_param_call(MODULE_PARAM_PREFIX, name, ops, arg, perm, level, 0)
 
 #define core_param_cb(name, ops, arg, perm)		\
 	__level_param_cb(name, ops, arg, perm, 1)
@@ -184,14 +194,14 @@ struct kparam_array
 
 /* This is the fundamental function for registering boot/module
    parameters. */
-#define __module_param_call(prefix, name, ops, arg, perm, level)	\
+#define __module_param_call(prefix, name, ops, arg, perm, level, flags)	\
 	/* Default value instead of permissions? */			\
 	static const char __param_str_##name[] = prefix #name; \
 	static struct kernel_param __moduleparam_const __param_##name	\
 	__used								\
     __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *)))) \
 	= { __param_str_##name, ops, VERIFY_OCTAL_PERMISSIONS(perm),	\
-	    level, { arg } }
+	    level, flags, { arg } }
 
 /* Obsolete - use module_param_cb() */
 #define module_param_call(name, set, get, arg, perm)			\
@@ -199,7 +209,7 @@ struct kparam_array
 		{ 0, (void *)set, (void *)get };			\
 	__module_param_call(MODULE_PARAM_PREFIX,			\
 			    name, &__param_ops_##name, arg,		\
-			    (perm) + sizeof(__check_old_set_param(set))*0, -1)
+			    (perm) + sizeof(__check_old_set_param(set))*0, -1, 0)
 
 /* We don't get oldget: it's often a new-style param_get_uint, etc. */
 static inline int
@@ -279,7 +289,7 @@ static inline void __kernel_param_unlock(void)
  */
 #define core_param(name, var, type, perm)				\
 	param_check_##type(name, &(var));				\
-	__module_param_call("", name, &param_ops_##type, &var, perm, -1)
+	__module_param_call("", name, &param_ops_##type, &var, perm, -1, 0)
 #endif /* !MODULE */
 
 /**
@@ -297,7 +307,7 @@ static inline void __kernel_param_unlock(void)
 		= { len, string };					\
 	__module_param_call(MODULE_PARAM_PREFIX, name,			\
 			    &param_ops_string,				\
-			    .str = &__param_string_##name, perm, -1);	\
+			    .str = &__param_string_##name, perm, -1, 0);\
 	__MODULE_PARM_TYPE(name, "string")
 
 /**
@@ -346,6 +356,22 @@ static inline void destroy_params(const struct kernel_param *params,
 #define __param_check(name, p, type) \
 	static inline type __always_unused *__check_##name(void) { return(p); }
 
+/**
+ * param_check_unsafe - Warn and taint the kernel if setting dangerous options.
+ *
+ * This gets called from all the standard param setters, but can be used from
+ * custom setters as well.
+ */
+static inline void
+param_check_unsafe(const struct kernel_param *kp)
+{
+	if (kp->flags & KERNEL_PARAM_FL_UNSAFE) {
+		pr_warn("Setting dangerous option %s - tainting kernel\n",
+			kp->name);
+		add_taint(TAINT_USER, LOCKDEP_STILL_OK);
+	}
+}
+
 extern struct kernel_param_ops param_ops_byte;
 extern int param_set_byte(const char *val, const struct kernel_param *kp);
 extern int param_get_byte(char *buffer, const struct kernel_param *kp);
@@ -444,7 +470,7 @@ extern int param_set_bint(const char *val, const struct kernel_param *kp);
 	__module_param_call(MODULE_PARAM_PREFIX, name,			\
 			    &param_array_ops,				\
 			    .arr = &__param_arr_##name,			\
-			    perm, -1);					\
+			    perm, -1, 0);				\
 	__MODULE_PARM_TYPE(name, "array of " #type)
 
 extern struct kernel_param_ops param_array_ops;
diff --git a/kernel/params.c b/kernel/params.c
index 8a484fc8bde8..ad8d04563c3a 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -233,6 +233,7 @@ char *parse_args(const char *doing,
 #define STANDARD_PARAM_DEF(name, type, format, strtolfn)      		\
 	int param_set_##name(const char *val, const struct kernel_param *kp) \
 	{								\
+		param_check_unsafe(kp);					\
 		return strtolfn(val, 0, (type *)kp->arg);		\
 	}								\
 	int param_get_##name(char *buffer, const struct kernel_param *kp) \
@@ -265,6 +266,8 @@ int param_set_charp(const char *val, const struct kernel_param *kp)
 		return -ENOSPC;
 	}
 
+	param_check_unsafe(kp);
+
 	maybe_kfree_parameter(*(char **)kp->arg);
 
 	/* This is a hack.  We can't kmalloc in early boot, and we
@@ -302,6 +305,8 @@ EXPORT_SYMBOL(param_ops_charp);
 /* Actually could be a bool or an int, for historical reasons. */
 int param_set_bool(const char *val, const struct kernel_param *kp)
 {
+	param_check_unsafe(kp);
+
 	/* No equals means "set"... */
 	if (!val) val = "1";
 
@@ -331,6 +336,8 @@ int param_set_invbool(const char *val, const struct kernel_param *kp)
 	bool boolval;
 	struct kernel_param dummy;
 
+	param_check_unsafe(kp);
+
 	dummy.arg = &boolval;
 	ret = param_set_bool(val, &dummy);
 	if (ret == 0)
@@ -357,6 +364,8 @@ int param_set_bint(const char *val, const struct kernel_param *kp)
 	bool v;
 	int ret;
 
+	param_check_unsafe(kp);
+
 	/* Match bool exactly, by re-using it. */
 	boolkp = *kp;
 	boolkp.arg = &v;
@@ -476,6 +485,8 @@ int param_set_copystring(const char *val, const struct kernel_param *kp)
 {
 	const struct kparam_string *kps = kp->str;
 
+	param_check_unsafe(kp);
+
 	if (strlen(val)+1 > kps->maxlen) {
 		pr_err("%s: string doesn't fit in %u chars.\n",
 		       kp->name, kps->maxlen-1);
-- 
1.9.1


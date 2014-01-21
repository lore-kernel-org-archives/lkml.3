Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbaAUVmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:42:47 -0500
Received: from mail.windriver.com ([147.11.1.11]:56308 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446AbaAUVYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:24:51 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 31/73] module: relocate module_init from init.h to module.h
Date: Tue, 21 Jan 2014 16:22:34 -0500
Message-ID: <1390339396-3479-32-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modular users will always be users of init functionality, but
users of init functionality are not necessarily always modules.

Hence any functionality like module_init and module_exit would
be more at home in the module.h file.  And module.h should
explicitly include init.h to make the dependency clear.

We've already done all the legwork needed to ensure that this
move does not cause any build regressions due to implicit
header file include assumptions about where module_init lives.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/init.h   | 66 ---------------------------------------------
 include/linux/module.h | 72 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+), 66 deletions(-)

diff --git a/include/linux/init.h b/include/linux/init.h
index f693cc3..630beb3 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -244,56 +244,8 @@ void __init parse_early_param(void);
 void __init parse_early_options(char *cmdline);
 #endif /* __ASSEMBLY__ */
 
-/**
- * module_init() - driver initialization entry point
- * @x: function to be run at kernel boot time or module insertion
- * 
- * module_init() will either be called during do_initcalls() (if
- * builtin) or at module insertion time (if a module).  There can only
- * be one per module.
- */
-#define module_init(x)	__initcall(x);
-
-/**
- * module_exit() - driver exit entry point
- * @x: function to be run when driver is removed
- * 
- * module_exit() will wrap the driver clean-up code
- * with cleanup_module() when used with rmmod when
- * the driver is a module.  If the driver is statically
- * compiled into the kernel, module_exit() has no effect.
- * There can only be one per module.
- */
-#define module_exit(x)	__exitcall(x);
-
 #else /* MODULE */
 
-/* Don't use these in loadable modules, but some people do... */
-#define early_initcall(fn)		module_init(fn)
-#define core_initcall(fn)		module_init(fn)
-#define postcore_initcall(fn)		module_init(fn)
-#define arch_initcall(fn)		module_init(fn)
-#define subsys_initcall(fn)		module_init(fn)
-#define fs_initcall(fn)			module_init(fn)
-#define rootfs_initcall(fn)		module_init(fn)
-#define device_initcall(fn)		module_init(fn)
-#define late_initcall(fn)		module_init(fn)
-
-#define console_initcall(fn)		module_init(fn)
-#define security_initcall(fn)		module_init(fn)
-
-/* Each module must use one module_init(). */
-#define module_init(initfn)					\
-	static inline initcall_t __inittest(void)		\
-	{ return initfn; }					\
-	int init_module(void) __attribute__((alias(#initfn)));
-
-/* This is only required if you want to be unloadable. */
-#define module_exit(exitfn)					\
-	static inline exitcall_t __exittest(void)		\
-	{ return exitfn; }					\
-	void cleanup_module(void) __attribute__((alias(#exitfn)));
-
 #define __setup_param(str, unique_id, fn)	/* nothing */
 #define __setup(str, func) 			/* nothing */
 #endif
@@ -301,24 +253,6 @@ void __init parse_early_options(char *cmdline);
 /* Data marked not to be saved by software suspend */
 #define __nosavedata __section(.data..nosave)
 
-/* This means "can be init if no module support, otherwise module load
-   may call it." */
-#ifdef CONFIG_MODULES
-#define __init_or_module
-#define __initdata_or_module
-#define __initconst_or_module
-#define __INIT_OR_MODULE	.text
-#define __INITDATA_OR_MODULE	.data
-#define __INITRODATA_OR_MODULE	.section ".rodata","a",%progbits
-#else
-#define __init_or_module __init
-#define __initdata_or_module __initdata
-#define __initconst_or_module __initconst
-#define __INIT_OR_MODULE __INIT
-#define __INITDATA_OR_MODULE __INITDATA
-#define __INITRODATA_OR_MODULE __INITRODATA
-#endif /*CONFIG_MODULES*/
-
 #ifdef MODULE
 #define __exit_p(x) x
 #else
diff --git a/include/linux/module.h b/include/linux/module.h
index eaf60ff..b1d96e7 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -11,6 +11,7 @@
 #include <linux/compiler.h>
 #include <linux/cache.h>
 #include <linux/kmod.h>
+#include <linux/init.h>
 #include <linux/elf.h>
 #include <linux/stringify.h>
 #include <linux/kobject.h>
@@ -91,6 +92,77 @@ extern const struct gtype##_id __mod_##gtype##_table		\
 #define MODULE_GENERIC_TABLE(gtype, name)
 #endif
 
+#ifndef MODULE
+/**
+ * module_init() - driver initialization entry point
+ * @x: function to be run at kernel boot time or module insertion
+ *
+ * module_init() will either be called during do_initcalls() (if
+ * builtin) or at module insertion time (if a module).  There can only
+ * be one per module.
+ */
+#define module_init(x)	__initcall(x);
+
+/**
+ * module_exit() - driver exit entry point
+ * @x: function to be run when driver is removed
+ *
+ * module_exit() will wrap the driver clean-up code
+ * with cleanup_module() when used with rmmod when
+ * the driver is a module.  If the driver is statically
+ * compiled into the kernel, module_exit() has no effect.
+ * There can only be one per module.
+ */
+#define module_exit(x)	__exitcall(x);
+
+#else /* MODULE */
+
+/* Don't use these in loadable modules, but some people do... */
+#define early_initcall(fn)		module_init(fn)
+#define core_initcall(fn)		module_init(fn)
+#define postcore_initcall(fn)		module_init(fn)
+#define arch_initcall(fn)		module_init(fn)
+#define subsys_initcall(fn)		module_init(fn)
+#define fs_initcall(fn)			module_init(fn)
+#define rootfs_initcall(fn)		module_init(fn)
+#define device_initcall(fn)		module_init(fn)
+#define late_initcall(fn)		module_init(fn)
+
+#define console_initcall(fn)		module_init(fn)
+#define security_initcall(fn)		module_init(fn)
+
+/* Each module must use one module_init(). */
+#define module_init(initfn)					\
+	static inline initcall_t __inittest(void)		\
+	{ return initfn; }					\
+	int init_module(void) __attribute__((alias(#initfn)));
+
+/* This is only required if you want to be unloadable. */
+#define module_exit(exitfn)					\
+	static inline exitcall_t __exittest(void)		\
+	{ return exitfn; }					\
+	void cleanup_module(void) __attribute__((alias(#exitfn)));
+
+#endif
+
+/* This means "can be init if no module support, otherwise module load
+   may call it." */
+#ifdef CONFIG_MODULES
+#define __init_or_module
+#define __initdata_or_module
+#define __initconst_or_module
+#define __INIT_OR_MODULE	.text
+#define __INITDATA_OR_MODULE	.data
+#define __INITRODATA_OR_MODULE	.section ".rodata","a",%progbits
+#else
+#define __init_or_module __init
+#define __initdata_or_module __initdata
+#define __initconst_or_module __initconst
+#define __INIT_OR_MODULE __INIT
+#define __INITDATA_OR_MODULE __INITDATA
+#define __INITRODATA_OR_MODULE __INITRODATA
+#endif /*CONFIG_MODULES*/
+
 /* Generic info of form tag = "info" */
 #define MODULE_INFO(tag, info) __MODULE_INFO(tag, tag, info)
 
-- 
1.8.4.1


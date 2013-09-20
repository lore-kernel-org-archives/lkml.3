Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab3ITUgG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:36:06 -0400
Received: from smtp.outflux.net ([198.145.64.163]:43429 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208Ab3ITUgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:36:04 -0400
Date: Fri, 20 Sep 2013 13:35:56 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: James Morris <james.l.morris@oracle.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        linux-security-module@vger.kernel.org
Subject: [PATCH] LSM: ModPin LSM for module loading restrictions
Message-ID: <20130920203556.GA8726@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This LSM enforces that modules must all come from the same filesystem,
with the expectation that such a filesystem is backed by a read-only
device such as dm-verity or CDROM. This allows systems that have a
verified or unchanging filesystem to enforce module loading restrictions
without needing to sign the modules individually.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 security/Kconfig         |    6 ++
 security/Makefile        |    2 +
 security/modpin/Kconfig  |    9 +++
 security/modpin/Makefile |    1 +
 security/modpin/modpin.c |  197 ++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 215 insertions(+)
 create mode 100644 security/modpin/Kconfig
 create mode 100644 security/modpin/Makefile
 create mode 100644 security/modpin/modpin.c

diff --git a/security/Kconfig b/security/Kconfig
index e9c6ac7..80172fd 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -121,6 +121,7 @@ source security/selinux/Kconfig
 source security/smack/Kconfig
 source security/tomoyo/Kconfig
 source security/apparmor/Kconfig
+source security/modpin/Kconfig
 source security/yama/Kconfig
 
 source security/integrity/Kconfig
@@ -131,6 +132,7 @@ choice
 	default DEFAULT_SECURITY_SMACK if SECURITY_SMACK
 	default DEFAULT_SECURITY_TOMOYO if SECURITY_TOMOYO
 	default DEFAULT_SECURITY_APPARMOR if SECURITY_APPARMOR
+	default DEFAULT_SECURITY_MODPIN if SECURITY_MODPIN
 	default DEFAULT_SECURITY_YAMA if SECURITY_YAMA
 	default DEFAULT_SECURITY_DAC
 
@@ -150,6 +152,9 @@ choice
 	config DEFAULT_SECURITY_APPARMOR
 		bool "AppArmor" if SECURITY_APPARMOR=y
 
+	config DEFAULT_SECURITY_MODPIN
+		bool "ModPin" if SECURITY_MODPIN=y
+
 	config DEFAULT_SECURITY_YAMA
 		bool "Yama" if SECURITY_YAMA=y
 
@@ -164,6 +169,7 @@ config DEFAULT_SECURITY
 	default "smack" if DEFAULT_SECURITY_SMACK
 	default "tomoyo" if DEFAULT_SECURITY_TOMOYO
 	default "apparmor" if DEFAULT_SECURITY_APPARMOR
+	default "modpin" if DEFAULT_SECURITY_MODPIN
 	default "yama" if DEFAULT_SECURITY_YAMA
 	default "" if DEFAULT_SECURITY_DAC
 
diff --git a/security/Makefile b/security/Makefile
index c26c81e..73d0a05 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -7,6 +7,7 @@ subdir-$(CONFIG_SECURITY_SELINUX)	+= selinux
 subdir-$(CONFIG_SECURITY_SMACK)		+= smack
 subdir-$(CONFIG_SECURITY_TOMOYO)        += tomoyo
 subdir-$(CONFIG_SECURITY_APPARMOR)	+= apparmor
+subdir-$(CONFIG_SECURITY_MODPIN)	+= modpin
 subdir-$(CONFIG_SECURITY_YAMA)		+= yama
 
 # always enable default capabilities
@@ -22,6 +23,7 @@ obj-$(CONFIG_SECURITY_SMACK)		+= smack/built-in.o
 obj-$(CONFIG_AUDIT)			+= lsm_audit.o
 obj-$(CONFIG_SECURITY_TOMOYO)		+= tomoyo/built-in.o
 obj-$(CONFIG_SECURITY_APPARMOR)		+= apparmor/built-in.o
+obj-$(CONFIG_SECURITY_MODPIN)		+= modpin/built-in.o
 obj-$(CONFIG_SECURITY_YAMA)		+= yama/built-in.o
 obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
 
diff --git a/security/modpin/Kconfig b/security/modpin/Kconfig
new file mode 100644
index 0000000..5be9dd5
--- /dev/null
+++ b/security/modpin/Kconfig
@@ -0,0 +1,9 @@
+config SECURITY_MODPIN
+	bool "Module filesystem origin pinning"
+	depends on SECURITY
+	help
+	  Module loading will be pinned to the first filesystem used for
+	  loading. Any modules that come from other filesystems will be
+	  rejected. This is best used on systems without an initrd that
+	  have a root filesystem backed by a read-only device such as
+	  dm-verity or a CDROM.
diff --git a/security/modpin/Makefile b/security/modpin/Makefile
new file mode 100644
index 0000000..9080b29
--- /dev/null
+++ b/security/modpin/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_SECURITY_MODPIN) += modpin.o
diff --git a/security/modpin/modpin.c b/security/modpin/modpin.c
new file mode 100644
index 0000000..107b4d8
--- /dev/null
+++ b/security/modpin/modpin.c
@@ -0,0 +1,197 @@
+/*
+ * Module Pinning Security Module
+ *
+ * Copyright 2011-2013 Google Inc.
+ *
+ * Authors:
+ *      Kees Cook       <keescook@chromium.org>
+ *
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
+#define pr_fmt(fmt) "ModPin LSM: " fmt
+
+#include <linux/module.h>
+#include <linux/security.h>
+#include <linux/sched.h>
+#include <linux/fs.h>
+#include <linux/fs_struct.h>
+#include <linux/mount.h>
+#include <linux/path.h>
+#include <linux/root_dev.h>
+
+static void report_load_module(struct path *path, char *operation)
+{
+	char *alloced = NULL;
+	char *pathname; /* Pointer to either static string or "alloced". */
+
+	if (!path)
+		pathname = "<unknown>";
+	else {
+		/* We will allow 11 spaces for ' (deleted)' to be appended */
+		alloced = pathname = kmalloc(PATH_MAX+11, GFP_KERNEL);
+		if (!pathname)
+			pathname = "<no_memory>";
+		else {
+			pathname = d_path(path, pathname, PATH_MAX+11);
+			if (IS_ERR(pathname))
+				pathname = "<too_long>";
+		}
+	}
+
+	pr_notice("init_module %s module=%s pid=%d\n",
+		  operation, pathname, task_pid_nr(current));
+
+	kfree(alloced);
+}
+
+static int modpin_enforced = 1;
+static struct dentry *pinned_root;
+static DEFINE_SPINLOCK(pinned_root_spinlock);
+
+#ifdef CONFIG_SYSCTL
+static int zero;
+static int one = 1;
+
+static struct ctl_path modpin_sysctl_path[] = {
+	{ .procname = "kernel", },
+	{ .procname = "modpin", },
+	{ }
+};
+
+static struct ctl_table modpin_sysctl_table[] = {
+	{
+		.procname       = "enforced",
+		.data           = &modpin_enforced,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec_minmax,
+		.extra1         = &zero,
+		.extra2         = &one,
+	},
+	{ }
+};
+
+/*
+ * Check if the root device is read-only (e.g. dm-verity is enabled).
+ * This must be called after early kernel init, since only then is the
+ * rootdev available.
+ */
+static bool rootdev_readonly(void)
+{
+	bool rc;
+	struct block_device *bdev;
+	const fmode_t mode = FMODE_WRITE;
+
+	bdev = blkdev_get_by_dev(ROOT_DEV, mode, NULL);
+	if (IS_ERR(bdev)) {
+		/* In this weird case, assume it is read-only. */
+		pr_info("dev(%u,%u): FMODE_WRITE disallowed?!\n",
+			MAJOR(ROOT_DEV), MINOR(ROOT_DEV));
+		return true;
+	}
+
+	rc = bdev_read_only(bdev);
+	blkdev_put(bdev, mode);
+
+	pr_info("dev(%u,%u): %s\n", MAJOR(ROOT_DEV), MINOR(ROOT_DEV),
+		rc ? "read-only" : "writable");
+
+	return rc;
+}
+
+static void check_pinning_enforcement(void)
+{
+	/*
+	 * If module pinning is not being enforced, allow sysctl to change
+	 * modes for testing.
+	 */
+	if (!rootdev_readonly()) {
+		if (!register_sysctl_paths(modpin_sysctl_path,
+					   modpin_sysctl_table))
+			pr_notice("sysctl registration failed!\n");
+		else
+			pr_info("module pinning can be disabled.\n");
+	} else
+		pr_info("module pinning engaged.\n");
+}
+#else
+static void check_pinning_enforcement(void) { }
+#endif
+
+
+static int modpin_load_module(struct file *file)
+{
+	struct dentry *module_root;
+
+	if (!file) {
+		if (!modpin_enforced) {
+			report_load_module(NULL, "old-api-pinning-ignored");
+			return 0;
+		}
+
+		report_load_module(NULL, "old-api-denied");
+		return -EPERM;
+	}
+
+	module_root = file->f_path.mnt->mnt_root;
+
+	/* First loaded module defines the root for all others. */
+	spin_lock(&pinned_root_spinlock);
+	if (!pinned_root) {
+		pinned_root = dget(module_root);
+		/*
+		 * Unlock now since it's only pinned_root we care about.
+		 * In the worst case, we will (correctly) report pinning
+		 * failures before we have announced that pinning is
+		 * enabled. This would be purely cosmetic.
+		 */
+		spin_unlock(&pinned_root_spinlock);
+		check_pinning_enforcement();
+		report_load_module(&file->f_path, "pinned");
+		return 0;
+	}
+	spin_unlock(&pinned_root_spinlock);
+
+	if (module_root != pinned_root) {
+		if (unlikely(!modpin_enforced)) {
+			report_load_module(&file->f_path, "pinning-ignored");
+			return 0;
+		}
+
+		report_load_module(&file->f_path, "denied");
+		return -EPERM;
+	}
+
+	return 0;
+}
+
+static struct security_operations modpin_ops = {
+	.name	= "modpin",
+	.kernel_module_from_file = modpin_load_module,
+};
+
+static int __init modpin_init(void)
+{
+	int error;
+
+	error = register_security(&modpin_ops);
+
+	if (error)
+		panic("Could not register ModPin security module");
+
+	pr_info("ready to pin.\n");
+
+	return error;
+}
+security_initcall(modpin_init);
+
+module_param(modpin_enforced, int, S_IRUSR);
+MODULE_PARM_DESC(modpin_enforced, "Module pinning enforced (default: true)");
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security

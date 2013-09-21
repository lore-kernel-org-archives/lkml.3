Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab3IUXAW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 19:00:22 -0400
Received: from smtp.outflux.net ([198.145.64.163]:38506 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862Ab3IUXAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 19:00:20 -0400
Date: Sat, 21 Sep 2013 15:59:59 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: James Morris <james.l.morris@oracle.com>, Vivek Goyal <vgoyal@redhat.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        linux-security-module@vger.kernel.org
Subject: [PATCH] LSM: MntRestrict blocks mounts on symlink targets
Message-ID: <20130921225959.GA20388@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On systems where certain filesystem contents cannot be entirely trusted,
it is beneficial to block mounts on symlinks. This makes sure that
malicious filesystem contents cannot trigger the over-mounting of trusted
filesystems. (For example, a bind-mounted subdirectory of /var cannot be
redirected to mount on /etc via a symlink: a daemon cannot elevate privs
to uid-0.)

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 security/Kconfig                   |    6 ++++
 security/Makefile                  |    2 ++
 security/mntrestrict/Kconfig       |   13 ++++++++
 security/mntrestrict/Makefile      |    1 +
 security/mntrestrict/mntrestrict.c |   63 ++++++++++++++++++++++++++++++++++++
 5 files changed, 85 insertions(+)
 create mode 100644 security/mntrestrict/Kconfig
 create mode 100644 security/mntrestrict/Makefile
 create mode 100644 security/mntrestrict/mntrestrict.c

diff --git a/security/Kconfig b/security/Kconfig
index e9c6ac7..84d41f4 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -121,6 +121,7 @@ source security/selinux/Kconfig
 source security/smack/Kconfig
 source security/tomoyo/Kconfig
 source security/apparmor/Kconfig
+source security/mntrestrict/Kconfig
 source security/yama/Kconfig
 
 source security/integrity/Kconfig
@@ -131,6 +132,7 @@ choice
 	default DEFAULT_SECURITY_SMACK if SECURITY_SMACK
 	default DEFAULT_SECURITY_TOMOYO if SECURITY_TOMOYO
 	default DEFAULT_SECURITY_APPARMOR if SECURITY_APPARMOR
+	default DEFAULT_SECURITY_MNTRESTRICT if SECURITY_MNTRESTRICT
 	default DEFAULT_SECURITY_YAMA if SECURITY_YAMA
 	default DEFAULT_SECURITY_DAC
 
@@ -150,6 +152,9 @@ choice
 	config DEFAULT_SECURITY_APPARMOR
 		bool "AppArmor" if SECURITY_APPARMOR=y
 
+	config DEFAULT_SECURITY_MNTRESTRICT
+		bool "MntRestrict" if SECURITY_MNTRESTRICT=y
+
 	config DEFAULT_SECURITY_YAMA
 		bool "Yama" if SECURITY_YAMA=y
 
@@ -164,6 +169,7 @@ config DEFAULT_SECURITY
 	default "smack" if DEFAULT_SECURITY_SMACK
 	default "tomoyo" if DEFAULT_SECURITY_TOMOYO
 	default "apparmor" if DEFAULT_SECURITY_APPARMOR
+	default "mntrestrict" if DEFAULT_SECURITY_MNTRESTRICT
 	default "yama" if DEFAULT_SECURITY_YAMA
 	default "" if DEFAULT_SECURITY_DAC
 
diff --git a/security/Makefile b/security/Makefile
index c26c81e..33f38b1 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -7,6 +7,7 @@ subdir-$(CONFIG_SECURITY_SELINUX)	+= selinux
 subdir-$(CONFIG_SECURITY_SMACK)		+= smack
 subdir-$(CONFIG_SECURITY_TOMOYO)        += tomoyo
 subdir-$(CONFIG_SECURITY_APPARMOR)	+= apparmor
+subdir-$(CONFIG_SECURITY_MNTRESTRICT)	+= mntrestrict
 subdir-$(CONFIG_SECURITY_YAMA)		+= yama
 
 # always enable default capabilities
@@ -22,6 +23,7 @@ obj-$(CONFIG_SECURITY_SMACK)		+= smack/built-in.o
 obj-$(CONFIG_AUDIT)			+= lsm_audit.o
 obj-$(CONFIG_SECURITY_TOMOYO)		+= tomoyo/built-in.o
 obj-$(CONFIG_SECURITY_APPARMOR)		+= apparmor/built-in.o
+obj-$(CONFIG_SECURITY_MNTRESTRICT)	+= mntrestrict/built-in.o
 obj-$(CONFIG_SECURITY_YAMA)		+= yama/built-in.o
 obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
 
diff --git a/security/mntrestrict/Kconfig b/security/mntrestrict/Kconfig
new file mode 100644
index 0000000..9a7310d
--- /dev/null
+++ b/security/mntrestrict/Kconfig
@@ -0,0 +1,13 @@
+config SECURITY_MNTRESTRICT
+	bool "Restrict mounts on symlinks system-wide"
+	depends on SECURITY
+	help
+	  Enforces that rule that symlinks cannot be used as mount
+	  destinations across the entire system. This is to make sure
+	  it is never possible to redirect locations using symlinks
+	  when the process doing the mount may not be able to strictly
+	  trust the contents of the filesystem where it is happening. For
+	  example, making sure a bind mounted subdirectory in /var is not
+	  redirected into /etc: stops a daemon without full privileges
+	  from elevating to uid-0 by tricking the system init filesystem
+	  mounting infrastructure.
diff --git a/security/mntrestrict/Makefile b/security/mntrestrict/Makefile
new file mode 100644
index 0000000..340be1f
--- /dev/null
+++ b/security/mntrestrict/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_SECURITY_MNTRESTRICT) += mntrestrict.o
diff --git a/security/mntrestrict/mntrestrict.c b/security/mntrestrict/mntrestrict.c
new file mode 100644
index 0000000..257ae69
--- /dev/null
+++ b/security/mntrestrict/mntrestrict.c
@@ -0,0 +1,63 @@
+/*
+ * Mount Restriction Security Module
+ *
+ * Copyright 2011-2013 Google Inc.
+ *
+ * Authors:
+ *      Stephan Uphoff  <ups@google.com>
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
+#define pr_fmt(fmt) "MntRestrict LSM: " fmt
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
+static int mntrestrict_sb_mount(const char *dev_name, struct path *path,
+				const char *type, unsigned long flags,
+				void *data)
+{
+	int error = current->total_link_count ? -ELOOP : 0;
+
+	if (error) {
+		pr_notice("Mount path with symlinks prohibited - pid=%d\n",
+			task_pid_nr(current));
+	}
+
+	return error;
+}
+
+static struct security_operations mntrestrict_ops = {
+	.name	= "mntrestrict",
+	.sb_mount = mntrestrict_sb_mount,
+};
+
+static int __init mntrestrict_init(void)
+{
+	int error;
+
+	error = register_security(&mntrestrict_ops);
+
+	if (error)
+		panic("Could not register MntRestrict security module");
+
+	pr_info("symlink destinations will be blocked.\n");
+
+	return error;
+}
+security_initcall(mntrestrict_init);
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security

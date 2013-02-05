Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab3BEMfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 07:35:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:45612 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755102Ab3BEMfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 07:35:00 -0500
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC 2/2] initramfs with digital signature protection
Date: Tue,  5 Feb 2013 14:34:50 +0200
Message-Id: <cc87f1242960fad1a9fb44bcec331915e14c832b.1360067333.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1360067333.git.dmitry.kasatkin@intel.com>
References: <cover.1360067333.git.dmitry.kasatkin@intel.com>
In-Reply-To: <cover.1360067333.git.dmitry.kasatkin@intel.com>
References: <cover.1360067333.git.dmitry.kasatkin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Often initramfs is (re)fabricated on the machine on which it runs.
In such cases it is impossible to sign initramfs image, because
private key is not supposed to be available.

This patch adds support for additional digitaly signed initramfs images.
Digitaly signed initramfs image can be loaded from conventional initramfs
image or from rootfs and '/pre-init' is executed prior 'init' from initramfs
or root file system. If 'pre-init' fails, kernel panics. Signed initramfs
image must be located in '/initramfs-sig.img'.

Digitally signed initramfs can be used to provide protected user-space
environment for initialization purpose. For example, LSM, IMA/EVM can be
securely initialized using such approach.

Signing is done using scripts/sign-file from kernel source code and uses module
signature format and module verification API. Important to note again that
signing of such images should be done on the build machine.

Bellow is an example, how to sign compressed initrd (cpio) image:

scripts/sign-file -v signing_key.priv signing_key.x509 initrd.gz initramfs-sig.img

When using initramfs-tools, initramfs-sig.img can be easily included into the
conventional initramfs using initramfs-tools hooks, for example, by creating
/etc/initramfs-tools/hooks/initramfs_sig.sh, and adding following lines there:

  #!/bin/sh
  . /usr/share/initramfs-tools/hook-functions
  copy_exec /initramfs-sig.img

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
---
 init/Kconfig         |    7 +++
 init/Makefile        |    1 +
 init/do_mounts.h     |   10 +++
 init/initramfs_sig.c |  171 ++++++++++++++++++++++++++++++++++++++++++++++++++
 init/main.c          |    4 ++
 5 files changed, 193 insertions(+)
 create mode 100644 init/initramfs_sig.c

diff --git a/init/Kconfig b/init/Kconfig
index 7d30240..fca6f47 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1738,4 +1738,11 @@ config ASN1
 	  inform it as to what tags are to be expected in a stream and what
 	  functions to call on what tags.
 
+config INITRAMFS_SIG
+	bool "initramfs with digital signature protection"
+	depends on INTEGRITY_ASYMMETRIC_KEYS
+	default n
+	help
+	  This option enables initramfs with digital signature protection.
+
 source "kernel/Kconfig.locks"
diff --git a/init/Makefile b/init/Makefile
index 7bc47ee..0099169 100644
--- a/init/Makefile
+++ b/init/Makefile
@@ -7,6 +7,7 @@ ifneq ($(CONFIG_BLK_DEV_INITRD),y)
 obj-y                          += noinitramfs.o
 else
 obj-$(CONFIG_BLK_DEV_INITRD)   += initramfs.o
+obj-$(CONFIG_INITRAMFS_SIG)   += initramfs_sig.o
 endif
 obj-$(CONFIG_GENERIC_CALIBRATE_DELAY) += calibrate.o
 
diff --git a/init/do_mounts.h b/init/do_mounts.h
index 11829eb..113207f 100644
--- a/init/do_mounts.h
+++ b/init/do_mounts.h
@@ -76,3 +76,13 @@ static inline void md_run_setup(void) {}
 #endif
 
 char * __init unpack_to_rootfs(char *buf, unsigned len);
+
+#ifdef CONFIG_INITRAMFS_SIG
+
+int __init initramfs_sig_load(void);
+
+#else
+
+static inline int initramfs_sig_load(void) { return 0; }
+
+#endif
diff --git a/init/initramfs_sig.c b/init/initramfs_sig.c
new file mode 100644
index 0000000..b65f97e
--- /dev/null
+++ b/init/initramfs_sig.c
@@ -0,0 +1,171 @@
+/*
+ * Copyright (C) 2013 Intel Corporation
+ *
+ * Author:
+ * Dmitry Kasatkin <dmitry.kasatkin@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ *
+ */
+
+#define pr_fmt(fmt) "initramfs_sig: " fmt
+
+/*
+ * Many of the syscalls used in this file expect some of the arguments
+ * to be __user pointers not __kernel pointers.  To limit the sparse
+ * noise, turn off sparse checking for this file.
+ */
+
+#ifdef __CHECKER__
+#undef __CHECKER__
+#warning "Sparse checking disabled for this file"
+#endif
+
+#include <linux/unistd.h>
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/sched.h>
+#include <linux/freezer.h>
+#include <linux/kmod.h>
+#include <linux/module.h>
+
+#include "../kernel/module-internal.h"
+#include "do_mounts.h"
+
+#define BUF_SIZE	BLOCK_SIZE
+
+static const char *secmnt = "/root";
+static const char *initramfs_img = "/initramfs-sig.img";
+
+static int __init load_image(const char *from)
+{
+	int err = -EINVAL, fd;
+	char *buf = NULL, *msg;
+	off_t len, offset;
+	int size = BLOCK_SIZE;
+	const unsigned long markerlen = sizeof(MODULE_SIG_STRING) - 1;
+
+	fd = sys_open(from, O_RDONLY, 0);
+	if (fd < 0) {
+		pr_err("cannot open %s: %d\n", from, fd);
+		return fd;
+	}
+
+	len = sys_lseek(fd, 0, SEEK_END);
+	pr_info("%s image size: %lu\n", from, len);
+	if (len < 0)
+		goto out;
+
+	buf = vmalloc(len);
+	if (!buf) {
+		pr_err("unable to allocate large block of memory\n");
+		err = -ENOMEM;
+		goto out_close;
+	}
+
+	sys_lseek(fd, 0, SEEK_SET);
+
+	for (offset = 0; len; offset += size, len -= size) {
+		if (len < size)
+			size = len;
+		if (sys_read(fd, buf + offset, size) != size)
+			goto out;
+	}
+
+	pr_info("image offset: %lu\n", offset);
+
+	offset -= markerlen;
+
+	if (offset < 0 || memcmp(buf + offset, MODULE_SIG_STRING, markerlen)) {
+		pr_err("image has no marker\n");
+		goto out;
+	}
+
+	err = mod_verify_sig(buf, &offset);
+	pr_info("mod_verify_sig() = %d, len: %lu\n", err, offset);
+	if (err)
+		goto out;
+
+	err = sys_mount("tpmfs", (char *)secmnt, "tmpfs", MS_SILENT, NULL);
+	if (err) {
+		pr_err("sys_mount() = %d\n", err);
+		goto out;
+	}
+
+	sys_unshare(CLONE_FS | CLONE_FILES);
+	sys_chdir(secmnt);
+	sys_chroot(".");
+	sys_setsid();
+
+	pr_info("unpack start\n");
+	msg = unpack_to_rootfs(buf, offset);
+	if (msg) {
+		pr_err("unable to unpack rootfs\n");
+		err = -EINVAL;
+		goto out;
+	}
+	pr_info("unpack end\n");
+
+	err = 0;
+
+out:
+	vfree(buf);
+out_close:
+	sys_close(fd);
+
+	return err;
+}
+
+static int __init init_init(struct subprocess_info *info, struct cred *new)
+{
+	return load_image(initramfs_img);
+}
+
+static void init_cleanup(struct subprocess_info *info)
+{
+	int err;
+
+	pr_info("cleanup\n");
+
+	err = sys_umount((char *)secmnt, MNT_DETACH);
+	if (err)
+		pr_err("unable to umount secmnt: %d\n", err);
+}
+
+static int __init load_initramfs(void)
+{
+	static char *argv[] = { "pre-init", NULL, };
+	extern char *envp_init[];
+	int err;
+
+	/*
+	 * In case that a resume from disk is carried out by linuxrc or one of
+	 * its children, we need to tell the freezer not to wait for us.
+	 */
+	current->flags |= PF_FREEZER_SKIP;
+
+	err = call_usermodehelper_fns("/pre-init", argv, envp_init,
+				      UMH_WAIT_PROC, init_init, init_cleanup,
+				      NULL);
+
+	current->flags &= ~PF_FREEZER_SKIP;
+
+	pr_info("initramfs_sig /pre-init completed: %d\n", err);
+
+	return err;
+}
+
+int __init initramfs_sig_load(void)
+{
+	if (sys_access(initramfs_img, 0))
+		panic("signed initramfs image not found (INITRAMFS_SIG is anabled)\n");
+
+	if (load_initramfs())
+		panic("initramfs_sig failed! (INITRAMFS_SIG is anabled)\n");
+
+	pr_info("initramfs_sig finished\n");
+
+	return 0;
+}
diff --git a/init/main.c b/init/main.c
index 85d69df..43ef145 100644
--- a/init/main.c
+++ b/init/main.c
@@ -81,6 +81,8 @@
 #include <asm/smp.h>
 #endif
 
+#include "do_mounts.h"
+
 static int kernel_init(void *);
 
 extern void init_IRQ(void);
@@ -895,6 +897,8 @@ static void __init kernel_init_freeable(void)
 		prepare_namespace();
 	}
 
+	initramfs_sig_load();
+
 	/*
 	 * Ok, we have completed the initial bootup, and
 	 * we're essentially up and running. Get rid of the
-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbaCOFs2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 01:48:28 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:53703 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756313AbaCOFsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 01:48:23 -0400
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: viro@zeniv.linux.org.uk, eparis@redhat.com, rgb@redhat.com
Cc: catalin.marinas@arm.com, will.deacon@arm.com, dsaxena@linaro.org,
        arndb@arndb.de, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com, patches@linaro.org,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH_v5] audit: Add generic compat syscall support
Date: Sat, 15 Mar 2014 14:48:00 +0900
Message-Id: <1394862480-29019-2-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394862480-29019-1-git-send-email-takahiro.akashi@linaro.org>
References: <1391410528-4844-1-git-send-email-takahiro.akashi@linaro.org>
 <1394862480-29019-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lib/audit.c provides a generic function for auditing system calls.
This patch extends it for compat syscall support on bi-architectures
(32/64-bit) by adding lib/compat_audit.c.
What is required to support this feature are:
 * add asm/unistd32.h for compat system call names
 * select CONFIG_AUDIT_ARCH_COMPAT_GENERIC

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 include/linux/audit.h      |  8 ++++++++
 include/uapi/linux/audit.h |  6 ++++++
 lib/Kconfig                |  9 +++++++++
 lib/Makefile               |  1 +
 lib/audit.c                | 15 +++++++++++++-
 lib/compat_audit.c         | 50 ++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 88 insertions(+), 1 deletion(-)
 create mode 100644 lib/compat_audit.c

diff --git a/include/linux/audit.h b/include/linux/audit.h
index aa865a9..85f0503 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -78,6 +78,14 @@ extern int is_audit_feature_set(int which);
 extern int __init audit_register_class(int class, unsigned *list);
 extern int audit_classify_syscall(int abi, unsigned syscall);
 extern int audit_classify_arch(int arch);
+/* only for compat system calls */
+extern unsigned compat_write_class[];
+extern unsigned compat_read_class[];
+extern unsigned compat_dir_class[];
+extern unsigned compat_chattr_class[];
+extern unsigned compat_signal_class[];
+
+extern int __weak audit_classify_compat_syscall(int abi, unsigned syscall);
 
 /* audit_names->type values */
 #define	AUDIT_TYPE_UNKNOWN	0	/* we don't know yet */
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 2d48fe1..624df43 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -361,6 +361,12 @@ enum {
 #define AUDIT_ARCH_SPARC64	(EM_SPARCV9|__AUDIT_ARCH_64BIT)
 #define AUDIT_ARCH_X86_64	(EM_X86_64|__AUDIT_ARCH_64BIT|__AUDIT_ARCH_LE)
 
+#ifdef CONFIG_COMPAT
+#define audit_is_compat(arch)	(!((arch) & __AUDIT_ARCH_64BIT))
+#else
+#define audit_is_compat(arch)	false
+#endif
+
 #define AUDIT_PERM_EXEC		1
 #define AUDIT_PERM_WRITE	2
 #define AUDIT_PERM_READ		4
diff --git a/lib/Kconfig b/lib/Kconfig
index 991c98b..1e80cb3 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -182,6 +182,15 @@ config AUDIT_GENERIC
 	depends on AUDIT && !AUDIT_ARCH
 	default y
 
+config AUDIT_ARCH_COMPAT_GENERIC
+	bool
+	default n
+
+config AUDIT_COMPAT_GENERIC
+	bool
+	depends on AUDIT_GENERIC && AUDIT_ARCH_COMPAT_GENERIC && COMPAT
+	default y
+
 config RANDOM32_SELFTEST
 	bool "PRNG perform self test on init"
 	default n
diff --git a/lib/Makefile b/lib/Makefile
index 48140e3..0cd7b68 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -96,6 +96,7 @@ obj-$(CONFIG_TEXTSEARCH_BM) += ts_bm.o
 obj-$(CONFIG_TEXTSEARCH_FSM) += ts_fsm.o
 obj-$(CONFIG_SMP) += percpu_counter.o
 obj-$(CONFIG_AUDIT_GENERIC) += audit.o
+obj-$(CONFIG_AUDIT_COMPAT_GENERIC) += compat_audit.o
 
 obj-$(CONFIG_SWIOTLB) += swiotlb.o
 obj-$(CONFIG_IOMMU_HELPER) += iommu-helper.o
diff --git a/lib/audit.c b/lib/audit.c
index 76bbed4..1d726a2 100644
--- a/lib/audit.c
+++ b/lib/audit.c
@@ -30,11 +30,17 @@ static unsigned signal_class[] = {
 
 int audit_classify_arch(int arch)
 {
-	return 0;
+	if (audit_is_compat(arch))
+		return 1;
+	else
+		return 0;
 }
 
 int audit_classify_syscall(int abi, unsigned syscall)
 {
+	if (audit_is_compat(abi))
+		return audit_classify_compat_syscall(abi, syscall);
+
 	switch(syscall) {
 #ifdef __NR_open
 	case __NR_open:
@@ -57,6 +63,13 @@ int audit_classify_syscall(int abi, unsigned syscall)
 
 static int __init audit_classes_init(void)
 {
+#ifdef CONFIG_AUDIT_COMPAT_GENERIC
+	audit_register_class(AUDIT_CLASS_WRITE_32, compat_write_class);
+	audit_register_class(AUDIT_CLASS_READ_32, compat_read_class);
+	audit_register_class(AUDIT_CLASS_DIR_WRITE_32, compat_dir_class);
+	audit_register_class(AUDIT_CLASS_CHATTR_32, compat_chattr_class);
+	audit_register_class(AUDIT_CLASS_SIGNAL_32, compat_signal_class);
+#endif
 	audit_register_class(AUDIT_CLASS_WRITE, write_class);
 	audit_register_class(AUDIT_CLASS_READ, read_class);
 	audit_register_class(AUDIT_CLASS_DIR_WRITE, dir_class);
diff --git a/lib/compat_audit.c b/lib/compat_audit.c
new file mode 100644
index 0000000..873f75b
--- /dev/null
+++ b/lib/compat_audit.c
@@ -0,0 +1,50 @@
+#include <linux/init.h>
+#include <linux/types.h>
+#include <asm/unistd32.h>
+
+unsigned compat_dir_class[] = {
+#include <asm-generic/audit_dir_write.h>
+~0U
+};
+
+unsigned compat_read_class[] = {
+#include <asm-generic/audit_read.h>
+~0U
+};
+
+unsigned compat_write_class[] = {
+#include <asm-generic/audit_write.h>
+~0U
+};
+
+unsigned compat_chattr_class[] = {
+#include <asm-generic/audit_change_attr.h>
+~0U
+};
+
+unsigned compat_signal_class[] = {
+#include <asm-generic/audit_signal.h>
+~0U
+};
+
+int audit_classify_compat_syscall(int abi, unsigned syscall)
+{
+	switch (syscall) {
+#ifdef __NR_open
+	case __NR_open:
+		return 2;
+#endif
+#ifdef __NR_openat
+	case __NR_openat:
+		return 3;
+#endif
+#ifdef __NR_socketcall
+	case __NR_socketcall:
+		return 4;
+#endif
+	case __NR_execve:
+		return 5;
+	default:
+		return 1;
+	}
+}
-- 
1.8.3.2


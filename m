Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbaAQILv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 03:11:51 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49975 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaAQILp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 03:11:45 -0500
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v3] audit: Add generic compat syscall support
Date: Fri, 17 Jan 2014 17:11:24 +0900
Message-Id: <1389946284-4428-2-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389946284-4428-1-git-send-email-takahiro.akashi@linaro.org>
References: <1389946284-4428-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lib/audit.c provides a generic definition for auditing system calls.
This patch extends it for compat syscall support on bi-architectures
(32/64-bit) by adding lib/compat_audit.c when CONFIG_COMPAT enabled.

Each architecture that wants to use this must define audit_is_compat()
in asm/audit.h.

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 include/linux/audit.h |    9 +++++++++
 lib/Makefile          |    3 +++
 lib/audit.c           |   17 +++++++++++++++++
 lib/compat_audit.c    |   51 +++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 80 insertions(+)
 create mode 100644 lib/compat_audit.c

diff --git a/include/linux/audit.h b/include/linux/audit.h
index bf1ef22..3d71949 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -78,6 +78,15 @@ extern int is_audit_feature_set(int which);
 extern int __init audit_register_class(int class, unsigned *list);
 extern int audit_classify_syscall(int abi, unsigned syscall);
 extern int audit_classify_arch(int arch);
+#if defined(CONFIG_AUDIT_GENERIC) && defined(CONFIG_COMPAT)
+extern unsigned compat_write_class[];
+extern unsigned compat_read_class[];
+extern unsigned compat_dir_class[];
+extern unsigned compat_chattr_class[];
+extern unsigned compat_signal_class[];
+
+extern int audit_classify_compat_syscall(int abi, unsigned syscall);
+#endif
 
 /* audit_names->type values */
 #define	AUDIT_TYPE_UNKNOWN	0	/* we don't know yet */
diff --git a/lib/Makefile b/lib/Makefile
index a459c31..73ea908 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -93,6 +93,9 @@ obj-$(CONFIG_TEXTSEARCH_BM) += ts_bm.o
 obj-$(CONFIG_TEXTSEARCH_FSM) += ts_fsm.o
 obj-$(CONFIG_SMP) += percpu_counter.o
 obj-$(CONFIG_AUDIT_GENERIC) += audit.o
+ifeq ($(CONFIG_COMPAT),y)
+obj-$(CONFIG_AUDIT_GENERIC) += compat_audit.o
+endif
 
 obj-$(CONFIG_SWIOTLB) += swiotlb.o
 obj-$(CONFIG_IOMMU_HELPER) += iommu-helper.o
diff --git a/lib/audit.c b/lib/audit.c
index 76bbed4..e29ba82 100644
--- a/lib/audit.c
+++ b/lib/audit.c
@@ -1,6 +1,7 @@
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/audit.h>
+#include <asm/audit.h>
 #include <asm/unistd.h>
 
 static unsigned dir_class[] = {
@@ -30,11 +31,20 @@ static unsigned signal_class[] = {
 
 int audit_classify_arch(int arch)
 {
+#ifdef CONFIG_COMPAT
+	if (audit_is_compat(arch))
+		return 1;
+#endif
 	return 0;
 }
 
 int audit_classify_syscall(int abi, unsigned syscall)
 {
+#ifdef CONFIG_COMPAT
+	if (audit_is_compat(abi))
+		return audit_classify_compat_syscall(abi, syscall);
+#endif
+
 	switch(syscall) {
 #ifdef __NR_open
 	case __NR_open:
@@ -57,6 +67,13 @@ int audit_classify_syscall(int abi, unsigned syscall)
 
 static int __init audit_classes_init(void)
 {
+#ifdef CONFIG_COMPAT
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
index 0000000..94f6480
--- /dev/null
+++ b/lib/compat_audit.c
@@ -0,0 +1,51 @@
+#include <linux/init.h>
+#include <linux/types.h>
+/* FIXME: this might be architecture dependent */
+#include <asm/unistd_32.h>
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
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965516Ab3FTPOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 11:14:51 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:38592 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965153Ab3FTPOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 11:14:49 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com
Subject: [PATCH 2/3] integrity: move integrity_audit_msg()
Date: Thu, 20 Jun 2013 11:13:20 -0400
Message-Id: <1371741201-15242-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062015-5806-0000-0000-000021CD0DC9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the integrity_audit_msg() function and defintion to
security/integrity/, the parent directory, renames the 'ima_audit'
boot command line option to 'integrity_audit', and fixes the Kconfig
help text to reflect the actual code.

Changelog:
- Fixed ifdef inclusion of integrity_audit_msg() (Fengguang Wu)

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 Documentation/kernel-parameters.txt  | 10 +++---
 security/integrity/Kconfig           | 15 +++++++++
 security/integrity/Makefile          |  1 +
 security/integrity/ima/Kconfig       | 12 -------
 security/integrity/ima/Makefile      |  1 -
 security/integrity/ima/ima.h         | 14 --------
 security/integrity/ima/ima_audit.c   | 64 ------------------------------------
 security/integrity/integrity.h       | 14 ++++++++
 security/integrity/integrity_audit.c | 64 ++++++++++++++++++++++++++++++++++++
 9 files changed, 99 insertions(+), 96 deletions(-)
 delete mode 100644 security/integrity/ima/ima_audit.c
 create mode 100644 security/integrity/integrity_audit.c

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c3bfacb..cb5daa1 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1129,11 +1129,6 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			The builtin appraise policy appraises all files
 			owned by uid=0.
 
-	ima_audit=	[IMA]
-			Format: { "0" | "1" }
-			0 -- integrity auditing messages. (Default)
-			1 -- enable informational integrity auditing messages.
-
 	ima_hash=	[IMA]
 			Format: { "sha1" | "md5" }
 			default: "sha1"
@@ -1158,6 +1153,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	inport.irq=	[HW] Inport (ATI XL and Microsoft) busmouse driver
 			Format: <irq>
 
+	integrity_audit=[IMA]
+			Format: { "0" | "1" }
+			0 -- basic integrity auditing messages. (Default)
+			1 -- additional integrity auditing messages.
+
 	intel_iommu=	[DMAR] Intel IOMMU driver (DMAR) option
 		on
 			Enable intel iommu driver.
diff --git a/security/integrity/Kconfig b/security/integrity/Kconfig
index 4bb3a77..245c6d9 100644
--- a/security/integrity/Kconfig
+++ b/security/integrity/Kconfig
@@ -17,6 +17,21 @@ config INTEGRITY_SIGNATURE
 	  This is useful for evm and module keyrings, when keys are
 	  usually only added from initramfs.
 
+config INTEGRITY_AUDIT
+	bool "Enables integrity auditing support "
+	depends on INTEGRITY && AUDIT
+	default y
+	help
+	  In addition to enabling integrity auditing support, this
+	  option adds a kernel parameter 'integrity_audit', which
+	  controls the level of integrity auditing messages.
+	  0 - basic integrity auditing messages (default)
+	  1 - additional integrity auditing messages
+
+	  Additional informational integrity auditing messages would
+	  be enabled by specifying 'integrity_audit=1' on the kernel
+	  command line.
+
 config INTEGRITY_ASYMMETRIC_KEYS
 	boolean "Enable asymmetric keys support"
 	depends on INTEGRITY_SIGNATURE
diff --git a/security/integrity/Makefile b/security/integrity/Makefile
index ebb6409..0f9cffb 100644
--- a/security/integrity/Makefile
+++ b/security/integrity/Makefile
@@ -3,6 +3,7 @@
 #
 
 obj-$(CONFIG_INTEGRITY) += integrity.o
+obj-$(CONFIG_INTEGRITY_AUDIT) += integrity_audit.o
 obj-$(CONFIG_INTEGRITY_SIGNATURE) += digsig.o
 obj-$(CONFIG_INTEGRITY_ASYMMETRIC_KEYS) += digsig_asymmetric.o
 
diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index d232c73..39196ab 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -38,18 +38,6 @@ config IMA_MEASURE_PCR_IDX
 	  that IMA uses to maintain the integrity aggregate of the
 	  measurement list.  If unsure, use the default 10.
 
-config IMA_AUDIT
-	bool "Enables auditing support"
-	depends on IMA
-	depends on AUDIT
-	default y
-	help
-	  This option adds a kernel parameter 'ima_audit', which
-	  allows informational auditing messages to be enabled
-	  at boot.  If this option is selected, informational integrity
-	  auditing messages can be enabled with 'ima_audit=1' on
-	  the kernel command line.
-
 config IMA_LSM_RULES
 	bool
 	depends on IMA && AUDIT && (SECURITY_SELINUX || SECURITY_SMACK)
diff --git a/security/integrity/ima/Makefile b/security/integrity/ima/Makefile
index 3f2ca6b..56dfee7 100644
--- a/security/integrity/ima/Makefile
+++ b/security/integrity/ima/Makefile
@@ -7,5 +7,4 @@ obj-$(CONFIG_IMA) += ima.o
 
 ima-y := ima_fs.o ima_queue.o ima_init.o ima_main.o ima_crypto.o ima_api.o \
 	 ima_policy.o
-ima-$(CONFIG_IMA_AUDIT) += ima_audit.o
 ima-$(CONFIG_IMA_APPRAISE) += ima_appraise.o
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index a41c9c1..b3dd616 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -62,20 +62,6 @@ struct ima_queue_entry {
 };
 extern struct list_head ima_measurements;	/* list of all measurements */
 
-#ifdef CONFIG_IMA_AUDIT
-/* declarations */
-void integrity_audit_msg(int audit_msgno, struct inode *inode,
-			 const unsigned char *fname, const char *op,
-			 const char *cause, int result, int info);
-#else
-static inline void integrity_audit_msg(int audit_msgno, struct inode *inode,
-				       const unsigned char *fname,
-				       const char *op, const char *cause,
-				       int result, int info)
-{
-}
-#endif
-
 /* Internal IMA function definitions */
 int ima_init(void);
 void ima_cleanup(void);
diff --git a/security/integrity/ima/ima_audit.c b/security/integrity/ima/ima_audit.c
deleted file mode 100644
index c586faa..0000000
--- a/security/integrity/ima/ima_audit.c
+++ /dev/null
@@ -1,64 +0,0 @@
-/*
- * Copyright (C) 2008 IBM Corporation
- * Author: Mimi Zohar <zohar@us.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation, version 2 of the License.
- *
- * File: integrity_audit.c
- * 	Audit calls for the integrity subsystem
- */
-
-#include <linux/fs.h>
-#include <linux/gfp.h>
-#include <linux/audit.h>
-#include "ima.h"
-
-static int ima_audit;
-
-/* ima_audit_setup - enable informational auditing messages */
-static int __init ima_audit_setup(char *str)
-{
-	unsigned long audit;
-
-	if (!strict_strtoul(str, 0, &audit))
-		ima_audit = audit ? 1 : 0;
-	return 1;
-}
-__setup("ima_audit=", ima_audit_setup);
-
-void integrity_audit_msg(int audit_msgno, struct inode *inode,
-			 const unsigned char *fname, const char *op,
-			 const char *cause, int result, int audit_info)
-{
-	struct audit_buffer *ab;
-
-	if (!ima_audit && audit_info == 1) /* Skip informational messages */
-		return;
-
-	ab = audit_log_start(current->audit_context, GFP_KERNEL, audit_msgno);
-	audit_log_format(ab, "pid=%d uid=%u auid=%u ses=%u",
-			 current->pid,
-			 from_kuid(&init_user_ns, current_cred()->uid),
-			 from_kuid(&init_user_ns, audit_get_loginuid(current)),
-			 audit_get_sessionid(current));
-	audit_log_task_context(ab);
-	audit_log_format(ab, " op=");
-	audit_log_string(ab, op);
-	audit_log_format(ab, " cause=");
-	audit_log_string(ab, cause);
-	audit_log_format(ab, " comm=");
-	audit_log_untrustedstring(ab, current->comm);
-	if (fname) {
-		audit_log_format(ab, " name=");
-		audit_log_untrustedstring(ab, fname);
-	}
-	if (inode) {
-		audit_log_format(ab, " dev=");
-		audit_log_untrustedstring(ab, inode->i_sb->s_id);
-		audit_log_format(ab, " ino=%lu", inode->i_ino);
-	}
-	audit_log_format(ab, " res=%d", !result);
-	audit_log_end(ab);
-}
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 84c37c4..c42fb7a 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -113,5 +113,19 @@ static inline int asymmetric_verify(struct key *keyring, const char *sig,
 }
 #endif
 
+#ifdef CONFIG_INTEGRITY_AUDIT
+/* declarations */
+void integrity_audit_msg(int audit_msgno, struct inode *inode,
+			 const unsigned char *fname, const char *op,
+			 const char *cause, int result, int info);
+#else
+static inline void integrity_audit_msg(int audit_msgno, struct inode *inode,
+				       const unsigned char *fname,
+				       const char *op, const char *cause,
+				       int result, int info)
+{
+}
+#endif
+
 /* set during initialization */
 extern int iint_initialized;
diff --git a/security/integrity/integrity_audit.c b/security/integrity/integrity_audit.c
new file mode 100644
index 0000000..d7efb30
--- /dev/null
+++ b/security/integrity/integrity_audit.c
@@ -0,0 +1,64 @@
+/*
+ * Copyright (C) 2008 IBM Corporation
+ * Author: Mimi Zohar <zohar@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ *
+ * File: integrity_audit.c
+ * 	Audit calls for the integrity subsystem
+ */
+
+#include <linux/fs.h>
+#include <linux/gfp.h>
+#include <linux/audit.h>
+#include "integrity.h"
+
+static int integrity_audit_info;
+
+/* ima_audit_setup - enable informational auditing messages */
+static int __init integrity_audit_setup(char *str)
+{
+	unsigned long audit;
+
+	if (!strict_strtoul(str, 0, &audit))
+		integrity_audit_info = audit ? 1 : 0;
+	return 1;
+}
+__setup("integrity_audit=", integrity_audit_setup);
+
+void integrity_audit_msg(int audit_msgno, struct inode *inode,
+			 const unsigned char *fname, const char *op,
+			 const char *cause, int result, int audit_info)
+{
+	struct audit_buffer *ab;
+
+	if (!integrity_audit_info && audit_info == 1)	/* Skip info messages */
+		return;
+
+	ab = audit_log_start(current->audit_context, GFP_KERNEL, audit_msgno);
+	audit_log_format(ab, "pid=%d uid=%u auid=%u ses=%u",
+			 current->pid,
+			 from_kuid(&init_user_ns, current_cred()->uid),
+			 from_kuid(&init_user_ns, audit_get_loginuid(current)),
+			 audit_get_sessionid(current));
+	audit_log_task_context(ab);
+	audit_log_format(ab, " op=");
+	audit_log_string(ab, op);
+	audit_log_format(ab, " cause=");
+	audit_log_string(ab, cause);
+	audit_log_format(ab, " comm=");
+	audit_log_untrustedstring(ab, current->comm);
+	if (fname) {
+		audit_log_format(ab, " name=");
+		audit_log_untrustedstring(ab, fname);
+	}
+	if (inode) {
+		audit_log_format(ab, " dev=");
+		audit_log_untrustedstring(ab, inode->i_sb->s_id);
+		audit_log_format(ab, " ino=%lu", inode->i_ino);
+	}
+	audit_log_format(ab, " res=%d", !result);
+	audit_log_end(ab);
+}
-- 
1.8.1.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbaGVAuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 20:50:23 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:57720 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbaGVAuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 20:50:18 -0400
Message-ID: <1405990214.5310.1.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: [PATCH] ima: add support for measuring and appraising firmware
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Date: Mon, 21 Jul 2014 20:50:14 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072200-3532-0000-0000-0000034FFBB2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "security: introduce kernel_fw_from_file hook" patch defined a
new security hook to evaluate any loaded firmware that wasn't built
into the kernel.

This patch defines ima_fw_from_file(), which is called from the new
security hook, to measure and/or appraise the loaded firmware's
integrity.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 Documentation/ABI/testing/ima_policy  |  4 +++-
 include/linux/ima.h                   |  6 ++++++
 security/integrity/ima/ima.h          |  3 ++-
 security/integrity/ima/ima_appraise.c |  8 ++++++++
 security/integrity/ima/ima_main.c     | 10 ++++++++++
 security/integrity/ima/ima_policy.c   |  7 +++++++
 security/integrity/integrity.h        |  9 +++++++--
 security/security.c                   |  7 ++++++-
 8 files changed, 49 insertions(+), 5 deletions(-)

diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
index 4c3efe4..d0d0c57 100644
--- a/Documentation/ABI/testing/ima_policy
+++ b/Documentation/ABI/testing/ima_policy
@@ -26,6 +26,7 @@ Description:
 			option:	[[appraise_type=]] [permit_directio]
 
 		base: 	func:= [BPRM_CHECK][MMAP_CHECK][FILE_CHECK][MODULE_CHECK]
+				[FIRMWARE_CHECK]
 			mask:= [MAY_READ] [MAY_WRITE] [MAY_APPEND] [MAY_EXEC]
 			fsmagic:= hex value
 			fsuuid:= file system UUID (e.g 8bcbe394-4f13-4144-be8e-5aa9ea2ce2f6)
@@ -57,7 +58,8 @@ Description:
 			measure func=BPRM_CHECK
 			measure func=FILE_MMAP mask=MAY_EXEC
 			measure func=FILE_CHECK mask=MAY_READ uid=0
-			measure func=MODULE_CHECK uid=0
+			measure func=MODULE_CHECK
+			measure func=FIRMWARE_CHECK
 			appraise fowner=0
 
 		The default policy measures all executables in bprm_check,
diff --git a/include/linux/ima.h b/include/linux/ima.h
index 1b7f268..7cf5e9b 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -19,6 +19,7 @@ extern int ima_file_check(struct file *file, int mask);
 extern void ima_file_free(struct file *file);
 extern int ima_file_mmap(struct file *file, unsigned long prot);
 extern int ima_module_check(struct file *file);
+extern int ima_fw_from_file(struct file *file, char *buf, size_t size);
 
 #else
 static inline int ima_bprm_check(struct linux_binprm *bprm)
@@ -46,6 +47,11 @@ static inline int ima_module_check(struct file *file)
 	return 0;
 }
 
+static inline int ima_fw_from_file(struct file *file, char *buf, size_t size)
+{
+	return 0;
+}
+
 #endif /* CONFIG_IMA */
 
 #ifdef CONFIG_IMA_APPRAISE
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index c42056e..57da4bd 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -158,7 +158,7 @@ struct integrity_iint_cache *integrity_iint_insert(struct inode *inode);
 struct integrity_iint_cache *integrity_iint_find(struct inode *inode);
 
 /* IMA policy related functions */
-enum ima_hooks { FILE_CHECK = 1, MMAP_CHECK, BPRM_CHECK, MODULE_CHECK, POST_SETATTR };
+enum ima_hooks { FILE_CHECK = 1, MMAP_CHECK, BPRM_CHECK, MODULE_CHECK, FIRMWARE_CHECK, POST_SETATTR };
 
 int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask,
 		     int flags);
@@ -171,6 +171,7 @@ void ima_delete_rules(void);
 #define IMA_APPRAISE_ENFORCE	0x01
 #define IMA_APPRAISE_FIX	0x02
 #define IMA_APPRAISE_MODULES	0x04
+#define IMA_APPRAISE_FIRMWARE	0x08
 
 #ifdef CONFIG_IMA_APPRAISE
 int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 59ac902..86bfd5c 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -75,6 +75,8 @@ enum integrity_status ima_get_cache_status(struct integrity_iint_cache *iint,
 		return iint->ima_bprm_status;
 	case MODULE_CHECK:
 		return iint->ima_module_status;
+	case FIRMWARE_CHECK:
+		return iint->ima_firmware_status;
 	case FILE_CHECK:
 	default:
 		return iint->ima_file_status;
@@ -94,6 +96,9 @@ static void ima_set_cache_status(struct integrity_iint_cache *iint,
 	case MODULE_CHECK:
 		iint->ima_module_status = status;
 		break;
+	case FIRMWARE_CHECK:
+		iint->ima_firmware_status = status;
+		break;
 	case FILE_CHECK:
 	default:
 		iint->ima_file_status = status;
@@ -113,6 +118,9 @@ static void ima_cache_flags(struct integrity_iint_cache *iint, int func)
 	case MODULE_CHECK:
 		iint->flags |= (IMA_MODULE_APPRAISED | IMA_APPRAISED);
 		break;
+	case FIRMWARE_CHECK:
+		iint->flags |= (IMA_FIRMWARE_APPRAISED | IMA_APPRAISED);
+		break;
 	case FILE_CHECK:
 	default:
 		iint->flags |= (IMA_FILE_APPRAISED | IMA_APPRAISED);
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 0d69643..60886d8 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -319,6 +319,16 @@ int ima_module_check(struct file *file)
 	return process_measurement(file, NULL, MAY_EXEC, MODULE_CHECK);
 }
 
+int ima_fw_from_file(struct file *file, char *buf, size_t size)
+{
+	if (!file) {
+		if ((ima_appraise & IMA_APPRAISE_FIRMWARE) &&
+		    (ima_appraise & IMA_APPRAISE_ENFORCE))
+			return -EACCES;	/* INTEGRITY_UNKNOWN */
+	}
+	return process_measurement(file, NULL, MAY_EXEC, FIRMWARE_CHECK);
+}
+
 static int __init init_ima(void)
 {
 	int error;
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index cea84d8..07099a8 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -84,6 +84,7 @@ static struct ima_rule_entry default_rules[] = {
 	{.action = MEASURE, .func = FILE_CHECK, .mask = MAY_READ, .uid = GLOBAL_ROOT_UID,
 	 .flags = IMA_FUNC | IMA_MASK | IMA_UID},
 	{.action = MEASURE, .func = MODULE_CHECK, .flags = IMA_FUNC},
+	{.action = MEASURE, .func = FIRMWARE_CHECK, .flags = IMA_FUNC},
 };
 
 static struct ima_rule_entry default_appraise_rules[] = {
@@ -241,6 +242,8 @@ static int get_subaction(struct ima_rule_entry *rule, int func)
 		return IMA_BPRM_APPRAISE;
 	case MODULE_CHECK:
 		return IMA_MODULE_APPRAISE;
+	case FIRMWARE_CHECK:
+		return IMA_FIRMWARE_APPRAISE;
 	case FILE_CHECK:
 	default:
 		return IMA_FILE_APPRAISE;
@@ -486,6 +489,8 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 				entry->func = FILE_CHECK;
 			else if (strcmp(args[0].from, "MODULE_CHECK") == 0)
 				entry->func = MODULE_CHECK;
+			else if (strcmp(args[0].from, "FIRMWARE_CHECK") == 0)
+				entry->func = FIRMWARE_CHECK;
 			else if ((strcmp(args[0].from, "FILE_MMAP") == 0)
 				|| (strcmp(args[0].from, "MMAP_CHECK") == 0))
 				entry->func = MMAP_CHECK;
@@ -636,6 +641,8 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 		result = -EINVAL;
 	else if (entry->func == MODULE_CHECK)
 		ima_appraise |= IMA_APPRAISE_MODULES;
+	else if (entry->func == FIRMWARE_CHECK)
+		ima_appraise |= IMA_APPRAISE_FIRMWARE;
 	audit_log_format(ab, "res=%d", !result);
 	audit_log_end(ab);
 	return result;
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 09c440d..19b8e31 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -46,10 +46,14 @@
 #define IMA_BPRM_APPRAISED	0x00002000
 #define IMA_MODULE_APPRAISE	0x00004000
 #define IMA_MODULE_APPRAISED	0x00008000
+#define IMA_FIRMWARE_APPRAISE	0x00010000
+#define IMA_FIRMWARE_APPRAISED	0x00020000
 #define IMA_APPRAISE_SUBMASK	(IMA_FILE_APPRAISE | IMA_MMAP_APPRAISE | \
-				 IMA_BPRM_APPRAISE | IMA_MODULE_APPRAISE)
+				 IMA_BPRM_APPRAISE | IMA_MODULE_APPRAISE | \
+				 IMA_FIRMWARE_APPRAISE)
 #define IMA_APPRAISED_SUBMASK	(IMA_FILE_APPRAISED | IMA_MMAP_APPRAISED | \
-				 IMA_BPRM_APPRAISED | IMA_MODULE_APPRAISED)
+				 IMA_BPRM_APPRAISED | IMA_MODULE_APPRAISED | \
+				 IMA_FIRMWARE_APPRAISED)
 
 enum evm_ima_xattr_type {
 	IMA_XATTR_DIGEST = 0x01,
@@ -104,6 +108,7 @@ struct integrity_iint_cache {
 	enum integrity_status ima_mmap_status:4;
 	enum integrity_status ima_bprm_status:4;
 	enum integrity_status ima_module_status:4;
+	enum integrity_status ima_firmware_status:4;
 	enum integrity_status evm_status:4;
 	struct ima_digest_data *ima_hash;
 };
diff --git a/security/security.c b/security/security.c
index 35d37d0..e41b1a8 100644
--- a/security/security.c
+++ b/security/security.c
@@ -847,7 +847,12 @@ int security_kernel_create_files_as(struct cred *new, struct inode *inode)
 
 int security_kernel_fw_from_file(struct file *file, char *buf, size_t size)
 {
-	return security_ops->kernel_fw_from_file(file, buf, size);
+	int ret;
+
+	ret = security_ops->kernel_fw_from_file(file, buf, size);
+	if (ret)
+		return ret;
+	return ima_fw_from_file(file, buf, size);
 }
 EXPORT_SYMBOL_GPL(security_kernel_fw_from_file);
 
-- 
1.8.1.4




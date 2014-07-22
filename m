Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbaGVSba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 14:31:30 -0400
Received: from smtp.outflux.net ([198.145.64.163]:50310 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbaGVSb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 14:31:29 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Ming Lei <ming.lei@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, James Morris <james.l.morris@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-security-module@vger.kernel.org
Subject: [PATCH v3 1/2] security: introduce kernel_fw_from_file hook
Date: Tue, 22 Jul 2014 11:29:00 -0700
Message-Id: <1406053741-22795-2-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406053741-22795-1-git-send-email-keescook@chromium.org>
References: <1406053741-22795-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to validate the contents of firmware being loaded, there must be
a hook to evaluate any loaded firmware that wasn't built into the kernel
itself. Without this, there is a risk that a root user could load malicious
firmware designed to mount an attack against kernel memory (e.g. via DMA).

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/security.h |   17 +++++++++++++++++
 security/capability.c    |    6 ++++++
 security/security.c      |    6 ++++++
 3 files changed, 29 insertions(+)

diff --git a/include/linux/security.h b/include/linux/security.h
index 9c6b9722ff48..623f90e5f38d 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -702,6 +702,15 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	@inode points to the inode to use as a reference.
  *	The current task must be the one that nominated @inode.
  *	Return 0 if successful.
+ * @kernel_fw_from_file:
+ *	Load firmware from userspace (not called for built-in firmware).
+ *	@file contains the file structure pointing to the file containing
+ *	the firmware to load. This argument will be NULL if the firmware
+ *	was loaded via the uevent-triggered blob-based interface exposed
+ *	by CONFIG_FW_LOADER_USER_HELPER.
+ *	@buf pointer to buffer containing firmware contents.
+ *	@size length of the firmware contents.
+ *	Return 0 if permission is granted.
  * @kernel_module_request:
  *	Ability to trigger the kernel to automatically upcall to userspace for
  *	userspace to load a kernel module with the given name.
@@ -1565,6 +1574,7 @@ struct security_operations {
 	void (*cred_transfer)(struct cred *new, const struct cred *old);
 	int (*kernel_act_as)(struct cred *new, u32 secid);
 	int (*kernel_create_files_as)(struct cred *new, struct inode *inode);
+	int (*kernel_fw_from_file)(struct file *file, char *buf, size_t size);
 	int (*kernel_module_request)(char *kmod_name);
 	int (*kernel_module_from_file)(struct file *file);
 	int (*task_fix_setuid) (struct cred *new, const struct cred *old,
@@ -1837,6 +1847,7 @@ int security_prepare_creds(struct cred *new, const struct cred *old, gfp_t gfp);
 void security_transfer_creds(struct cred *new, const struct cred *old);
 int security_kernel_act_as(struct cred *new, u32 secid);
 int security_kernel_create_files_as(struct cred *new, struct inode *inode);
+int security_kernel_fw_from_file(struct file *file, char *buf, size_t size);
 int security_kernel_module_request(char *kmod_name);
 int security_kernel_module_from_file(struct file *file);
 int security_task_fix_setuid(struct cred *new, const struct cred *old,
@@ -2363,6 +2374,12 @@ static inline int security_kernel_create_files_as(struct cred *cred,
 	return 0;
 }
 
+static inline int security_kernel_fw_from_file(struct file *file,
+					       char *buf, size_t size)
+{
+	return 0;
+}
+
 static inline int security_kernel_module_request(char *kmod_name)
 {
 	return 0;
diff --git a/security/capability.c b/security/capability.c
index e76373de3129..a74fde6a7468 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -401,6 +401,11 @@ static int cap_kernel_create_files_as(struct cred *new, struct inode *inode)
 	return 0;
 }
 
+static int cap_kernel_fw_from_file(struct file *file, char *buf, size_t size)
+{
+	return 0;
+}
+
 static int cap_kernel_module_request(char *kmod_name)
 {
 	return 0;
@@ -1015,6 +1020,7 @@ void __init security_fixup_ops(struct security_operations *ops)
 	set_to_cap_if_null(ops, cred_transfer);
 	set_to_cap_if_null(ops, kernel_act_as);
 	set_to_cap_if_null(ops, kernel_create_files_as);
+	set_to_cap_if_null(ops, kernel_fw_from_file);
 	set_to_cap_if_null(ops, kernel_module_request);
 	set_to_cap_if_null(ops, kernel_module_from_file);
 	set_to_cap_if_null(ops, task_fix_setuid);
diff --git a/security/security.c b/security/security.c
index 31614e9e96e5..35d37d0f0d49 100644
--- a/security/security.c
+++ b/security/security.c
@@ -845,6 +845,12 @@ int security_kernel_create_files_as(struct cred *new, struct inode *inode)
 	return security_ops->kernel_create_files_as(new, inode);
 }
 
+int security_kernel_fw_from_file(struct file *file, char *buf, size_t size)
+{
+	return security_ops->kernel_fw_from_file(file, buf, size);
+}
+EXPORT_SYMBOL_GPL(security_kernel_fw_from_file);
+
 int security_kernel_module_request(char *kmod_name)
 {
 	return security_ops->kernel_module_request(kmod_name);
-- 
1.7.9.5


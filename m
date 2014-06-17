Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965893AbaFQVrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:47:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53834 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965872AbaFQVrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:47:00 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 066/212] ima: audit log files opened with O_DIRECT flag
Date: Tue, 17 Jun 2014 14:42:40 -0700
Message-Id: <1403041506-13646-67-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mimi Zohar <zohar@linux.vnet.ibm.com>

commit f9b2a735bdddf836214b5dca74f6ca7712e5a08c upstream.

Files are measured or appraised based on the IMA policy.  When a
file, in policy, is opened with the O_DIRECT flag, a deadlock
occurs.

The first attempt at resolving this lockdep temporarily removed the
O_DIRECT flag and restored it, after calculating the hash.  The
second attempt introduced the O_DIRECT_HAVELOCK flag. Based on this
flag, do_blockdev_direct_IO() would skip taking the i_mutex a second
time.  The third attempt, by Dmitry Kasatkin, resolves the i_mutex
locking issue, by re-introducing the IMA mutex, but uncovered
another problem.  Reading a file with O_DIRECT flag set, writes
directly to userspace pages.  A second patch allocates a user-space
like memory.  This works for all IMA hooks, except ima_file_free(),
which is called on __fput() to recalculate the file hash.

Until this last issue is addressed, do not 'collect' the
measurement for measuring, appraising, or auditing files opened
with the O_DIRECT flag set.  Based on policy, permit or deny file
access.  This patch defines a new IMA policy rule option named
'permit_directio'.  Policy rules could be defined, based on LSM
or other criteria, to permit specific applications to open files
with the O_DIRECT flag set.

Changelog v1:
- permit or deny file access based IMA policy rules

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Acked-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 Documentation/ABI/testing/ima_policy |  2 +-
 security/integrity/ima/ima_api.c     | 10 +++++++++-
 security/integrity/ima/ima_main.c    |  5 ++++-
 security/integrity/ima/ima_policy.c  |  6 +++++-
 security/integrity/integrity.h       |  1 +
 5 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
index f1c5cc9..4c3efe4 100644
--- a/Documentation/ABI/testing/ima_policy
+++ b/Documentation/ABI/testing/ima_policy
@@ -23,7 +23,7 @@ Description:
 				 [fowner]]
 			lsm:	[[subj_user=] [subj_role=] [subj_type=]
 				 [obj_user=] [obj_role=] [obj_type=]]
-			option:	[[appraise_type=]]
+			option:	[[appraise_type=]] [permit_directio]
 
 		base: 	func:= [BPRM_CHECK][MMAP_CHECK][FILE_CHECK][MODULE_CHECK]
 			mask:= [MAY_READ] [MAY_WRITE] [MAY_APPEND] [MAY_EXEC]
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index c38bbce..025824a 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -199,6 +199,7 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 			    struct evm_ima_xattr_data **xattr_value,
 			    int *xattr_len)
 {
+	const char *audit_cause = "failed";
 	struct inode *inode = file_inode(file);
 	const char *filename = file->f_dentry->d_name.name;
 	int result = 0;
@@ -213,6 +214,12 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 	if (!(iint->flags & IMA_COLLECTED)) {
 		u64 i_version = file_inode(file)->i_version;
 
+		if (file->f_flags & O_DIRECT) {
+			audit_cause = "failed(directio)";
+			result = -EACCES;
+			goto out;
+		}
+
 		/* use default hash algorithm */
 		hash.hdr.algo = ima_hash_algo;
 
@@ -233,9 +240,10 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 				result = -ENOMEM;
 		}
 	}
+out:
 	if (result)
 		integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode,
-				    filename, "collect_data", "failed",
+				    filename, "collect_data", audit_cause,
 				    result, 0);
 	return result;
 }
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 149ee11..76d8aad 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -217,8 +217,11 @@ static int process_measurement(struct file *file, const char *filename,
 		xattr_ptr = &xattr_value;
 
 	rc = ima_collect_measurement(iint, file, xattr_ptr, &xattr_len);
-	if (rc != 0)
+	if (rc != 0) {
+		if (file->f_flags & O_DIRECT)
+			rc = (iint->flags & IMA_PERMIT_DIRECTIO) ? 0 : -EACCES;
 		goto out_digsig;
+	}
 
 	pathname = !filename ? ima_d_path(&file->f_path, &pathbuf) : filename;
 	if (!pathname)
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index a9c3d3c..085c496 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -351,7 +351,7 @@ enum {
 	Opt_obj_user, Opt_obj_role, Opt_obj_type,
 	Opt_subj_user, Opt_subj_role, Opt_subj_type,
 	Opt_func, Opt_mask, Opt_fsmagic, Opt_uid, Opt_fowner,
-	Opt_appraise_type, Opt_fsuuid
+	Opt_appraise_type, Opt_fsuuid, Opt_permit_directio
 };
 
 static match_table_t policy_tokens = {
@@ -373,6 +373,7 @@ static match_table_t policy_tokens = {
 	{Opt_uid, "uid=%s"},
 	{Opt_fowner, "fowner=%s"},
 	{Opt_appraise_type, "appraise_type=%s"},
+	{Opt_permit_directio, "permit_directio"},
 	{Opt_err, NULL}
 };
 
@@ -621,6 +622,9 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 			else
 				result = -EINVAL;
 			break;
+		case Opt_permit_directio:
+			entry->flags |= IMA_PERMIT_DIRECTIO;
+			break;
 		case Opt_err:
 			ima_log_string(ab, "UNKNOWN", p);
 			result = -EINVAL;
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 2fb5e53..33c0a70 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -30,6 +30,7 @@
 #define IMA_ACTION_FLAGS	0xff000000
 #define IMA_DIGSIG		0x01000000
 #define IMA_DIGSIG_REQUIRED	0x02000000
+#define IMA_PERMIT_DIRECTIO	0x04000000
 
 #define IMA_DO_MASK		(IMA_MEASURE | IMA_APPRAISE | IMA_AUDIT | \
 				 IMA_APPRAISE_SUBMASK)
-- 
1.9.1


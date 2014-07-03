Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729AbaGCJW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:22:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51922 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758501AbaGCJWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:22:53 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 088/198] ima: audit log files opened with O_DIRECT flag
Date: Thu,  3 Jul 2014 10:18:51 +0100
Message-Id: <1404379241-8590-89-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.11: used Mimi's backport for 3.12 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 Documentation/ABI/testing/ima_policy | 2 +-
 security/integrity/ima/ima_api.c     | 9 ++++++++-
 security/integrity/ima/ima_main.c    | 5 ++++-
 security/integrity/ima/ima_policy.c  | 6 +++++-
 security/integrity/integrity.h       | 1 +
 5 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
index f1c5cc9d17a8..4c3efe434806 100644
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
index 1c03e8f1e0e1..4e1529e3a53d 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -140,6 +140,7 @@ int ima_must_measure(struct inode *inode, int mask, int function)
 int ima_collect_measurement(struct integrity_iint_cache *iint,
 			    struct file *file)
 {
+	const char *audit_cause = "failed";
 	struct inode *inode = file_inode(file);
 	const char *filename = file->f_dentry->d_name.name;
 	int result = 0;
@@ -147,6 +148,11 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 	if (!(iint->flags & IMA_COLLECTED)) {
 		u64 i_version = file_inode(file)->i_version;
 
+		if (file->f_flags & O_DIRECT) {
+			audit_cause = "failed(directio)";
+			result = -EACCES;
+			goto out;
+		}
 		iint->ima_xattr.type = IMA_XATTR_DIGEST;
 		result = ima_calc_file_hash(file, iint->ima_xattr.digest);
 		if (!result) {
@@ -154,9 +160,10 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 			iint->flags |= IMA_COLLECTED;
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
index e9508d5bbfcf..03fb126d215a 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -186,8 +186,11 @@ static int process_measurement(struct file *file, const char *filename,
 	}
 
 	rc = ima_collect_measurement(iint, file);
-	if (rc != 0)
+	if (rc != 0) {
+		if (file->f_flags & O_DIRECT)
+			rc = (iint->flags & IMA_PERMIT_DIRECTIO) ? 0 : -EACCES;
 		goto out_digsig;
+	}
 
 	pathname = !filename ? ima_d_path(&file->f_path, &pathbuf) : filename;
 	if (!pathname)
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index a9c3d3cd1990..085c4964be99 100644
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
index c42fb7a70dee..ecbb6f20f46a 100644
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab3AVWH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 17:07:57 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40927 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab3AVWHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 17:07:50 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        James Morris <jmorris@namei.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH v2 1/4] ima: added policy support for 'security.ima' type
Date: Tue, 22 Jan 2013 17:07:31 -0500
Message-Id: <1358892454-25045-2-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.rc3
In-Reply-To: <1358892454-25045-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1358892454-25045-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012222-5806-0000-0000-00001E9CD050
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>

The 'security.ima' extended attribute may contain either the file data's
hash or a digital signature.  This patch adds support for requiring a
specific extended attribute type.  It extends the IMA policy with a new
keyword 'appraise_type=imasig'.  (Default is hash.)

Changelog v2:
- Fixed Documentation/ABI/testing/ima_policy option syntax
Changelog v1:
- Differentiate between 'required' vs. 'actual' extended attribute

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 Documentation/ABI/testing/ima_policy  |  4 +++-
 security/integrity/ima/ima_appraise.c |  5 +++++
 security/integrity/ima/ima_main.c     |  1 +
 security/integrity/ima/ima_policy.c   | 18 +++++++++++++++++-
 security/integrity/integrity.h        |  2 ++
 5 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
index 6a0fc80..de16de3 100644
--- a/Documentation/ABI/testing/ima_policy
+++ b/Documentation/ABI/testing/ima_policy
@@ -18,10 +18,11 @@ Description:
 		rule format: action [condition ...]
 
 		action: measure | dont_measure | appraise | dont_appraise | audit
-		condition:= base | lsm
+		condition:= base | lsm  [option]
 			base:	[[func=] [mask=] [fsmagic=] [uid=] [fowner]]
 			lsm:	[[subj_user=] [subj_role=] [subj_type=]
 				 [obj_user=] [obj_role=] [obj_type=]]
+			option:	[[appraise_type=]]
 
 		base: 	func:= [BPRM_CHECK][MMAP_CHECK][FILE_CHECK][MODULE_CHECK]
 			mask:= [MAY_READ] [MAY_WRITE] [MAY_APPEND] [MAY_EXEC]
@@ -29,6 +30,7 @@ Description:
 			uid:= decimal value
 			fowner:=decimal value
 		lsm:  	are LSM specific
+		option:	appraise_type:= [imasig]
 
 		default policy:
 			# PROC_SUPER_MAGIC
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index fa675c9..8004332 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -102,6 +102,11 @@ int ima_appraise_measurement(struct integrity_iint_cache *iint,
 
 	switch (xattr_value->type) {
 	case IMA_XATTR_DIGEST:
+		if (iint->flags & IMA_DIGSIG_REQUIRED) {
+			cause = "IMA signature required";
+			status = INTEGRITY_FAIL;
+			break;
+		}
 		rc = memcmp(xattr_value->digest, iint->ima_xattr.digest,
 			    IMA_DIGEST_SIZE);
 		if (rc) {
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index cd00ba3..3cdd787 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -169,6 +169,7 @@ static int process_measurement(struct file *file, const char *filename,
 	 * (IMA_MEASURE, IMA_MEASURED, IMA_APPRAISE, IMA_APPRAISED,
 	 *  IMA_AUDIT, IMA_AUDITED) */
 	iint->flags |= action;
+	action &= IMA_DO_MASK;
 	action &= ~((iint->flags & IMA_DONE_MASK) >> 1);
 
 	/* Nothing to do, just return existing appraised status */
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 9519453..1a2543a 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -245,6 +245,8 @@ int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask,
 		if (!ima_match_rules(entry, inode, func, mask))
 			continue;
 
+		action |= entry->flags & IMA_ACTION_FLAGS;
+
 		action |= entry->action & IMA_DO_MASK;
 		if (entry->action & IMA_DO_MASK)
 			actmask &= ~(entry->action | entry->action << 1);
@@ -318,7 +320,8 @@ enum {
 	Opt_audit,
 	Opt_obj_user, Opt_obj_role, Opt_obj_type,
 	Opt_subj_user, Opt_subj_role, Opt_subj_type,
-	Opt_func, Opt_mask, Opt_fsmagic, Opt_uid, Opt_fowner
+	Opt_func, Opt_mask, Opt_fsmagic, Opt_uid, Opt_fowner,
+	Opt_appraise_type
 };
 
 static match_table_t policy_tokens = {
@@ -338,6 +341,7 @@ static match_table_t policy_tokens = {
 	{Opt_fsmagic, "fsmagic=%s"},
 	{Opt_uid, "uid=%s"},
 	{Opt_fowner, "fowner=%s"},
+	{Opt_appraise_type, "appraise_type=%s"},
 	{Opt_err, NULL}
 };
 
@@ -560,6 +564,18 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 						   LSM_SUBJ_TYPE,
 						   AUDIT_SUBJ_TYPE);
 			break;
+		case Opt_appraise_type:
+			if (entry->action != APPRAISE) {
+				result = -EINVAL;
+				break;
+			}
+
+			ima_log_string(ab, "appraise_type", args[0].from);
+			if ((strcmp(args[0].from, "imasig")) == 0)
+				entry->flags |= IMA_DIGSIG_REQUIRED;
+			else
+				result = -EINVAL;
+			break;
 		case Opt_err:
 			ima_log_string(ab, "UNKNOWN", p);
 			result = -EINVAL;
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 0a298de..9334691b 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -26,7 +26,9 @@
 #define IMA_AUDITED		0x0080
 
 /* iint cache flags */
+#define IMA_ACTION_FLAGS	0xff00
 #define IMA_DIGSIG		0x0100
+#define IMA_DIGSIG_REQUIRED	0x0200
 
 #define IMA_DO_MASK		(IMA_MEASURE | IMA_APPRAISE | IMA_AUDIT)
 #define IMA_DONE_MASK		(IMA_MEASURED | IMA_APPRAISED | IMA_AUDITED \
-- 
1.8.1.rc3


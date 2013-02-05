Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab3BEN2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 08:28:42 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:35874 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914Ab3BEN2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 08:28:38 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH 2/2] ima: add policy support for file system uuid
Date: Tue,  5 Feb 2013 08:28:15 -0500
Message-Id: <1360070895-29895-2-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.rc3
In-Reply-To: <1360070895-29895-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1360070895-29895-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020513-7182-0000-0000-000004F1A790
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>

The IMA policy permits specifying rules to enable or disable
measurement/appraisal/audit based on the file system magic number.
If, for example, the policy contains an ext4 measurement rule,
the rule is enabled for all ext4 partitions.

Sometimes it might be necessary to enable measurement/appraisal/audit
only for one partition and disable it for another partition of the
same type.  With the existing IMA policy syntax, this can not be done.

This patch provides support for IMA policy rules to specify the file
system by its UUID (eg. fsuuid=397449cd-687d-4145-8698-7fed4a3e0363).

For partitions not being appraised, it might be a good idea to mount
file systems with the 'noexec' option to prevent executing non-verified
binaries.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 Documentation/ABI/testing/ima_policy |  4 +++-
 security/integrity/ima/ima_policy.c  | 22 +++++++++++++++++++++-
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
index de16de3..f1c5cc9 100644
--- a/Documentation/ABI/testing/ima_policy
+++ b/Documentation/ABI/testing/ima_policy
@@ -19,7 +19,8 @@ Description:
 
 		action: measure | dont_measure | appraise | dont_appraise | audit
 		condition:= base | lsm  [option]
-			base:	[[func=] [mask=] [fsmagic=] [uid=] [fowner]]
+			base:	[[func=] [mask=] [fsmagic=] [fsuuid=] [uid=]
+				 [fowner]]
 			lsm:	[[subj_user=] [subj_role=] [subj_type=]
 				 [obj_user=] [obj_role=] [obj_type=]]
 			option:	[[appraise_type=]]
@@ -27,6 +28,7 @@ Description:
 		base: 	func:= [BPRM_CHECK][MMAP_CHECK][FILE_CHECK][MODULE_CHECK]
 			mask:= [MAY_READ] [MAY_WRITE] [MAY_APPEND] [MAY_EXEC]
 			fsmagic:= hex value
+			fsuuid:= file system UUID (e.g 8bcbe394-4f13-4144-be8e-5aa9ea2ce2f6)
 			uid:= decimal value
 			fowner:=decimal value
 		lsm:  	are LSM specific
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 4adcd0f..23f49e3 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -16,6 +16,7 @@
 #include <linux/magic.h>
 #include <linux/parser.h>
 #include <linux/slab.h>
+#include <linux/genhd.h>
 
 #include "ima.h"
 
@@ -25,6 +26,7 @@
 #define IMA_FSMAGIC	0x0004
 #define IMA_UID		0x0008
 #define IMA_FOWNER	0x0010
+#define IMA_FSUUID	0x0020
 
 #define UNKNOWN		0
 #define MEASURE		0x0001	/* same as IMA_MEASURE */
@@ -45,6 +47,7 @@ struct ima_rule_entry {
 	enum ima_hooks func;
 	int mask;
 	unsigned long fsmagic;
+	u8 fsuuid[16];
 	kuid_t uid;
 	kuid_t fowner;
 	struct {
@@ -172,6 +175,9 @@ static bool ima_match_rules(struct ima_rule_entry *rule,
 	if ((rule->flags & IMA_FSMAGIC)
 	    && rule->fsmagic != inode->i_sb->s_magic)
 		return false;
+	if ((rule->flags & IMA_FSUUID) &&
+		memcmp(rule->fsuuid, inode->i_sb->s_uuid, sizeof(rule->fsuuid)))
+		return false;
 	if ((rule->flags & IMA_UID) && !uid_eq(rule->uid, cred->uid))
 		return false;
 	if ((rule->flags & IMA_FOWNER) && !uid_eq(rule->fowner, inode->i_uid))
@@ -346,7 +352,7 @@ enum {
 	Opt_obj_user, Opt_obj_role, Opt_obj_type,
 	Opt_subj_user, Opt_subj_role, Opt_subj_type,
 	Opt_func, Opt_mask, Opt_fsmagic, Opt_uid, Opt_fowner,
-	Opt_appraise_type
+	Opt_appraise_type, Opt_fsuuid
 };
 
 static match_table_t policy_tokens = {
@@ -364,6 +370,7 @@ static match_table_t policy_tokens = {
 	{Opt_func, "func=%s"},
 	{Opt_mask, "mask=%s"},
 	{Opt_fsmagic, "fsmagic=%s"},
+	{Opt_fsuuid, "fsuuid=%s"},
 	{Opt_uid, "uid=%s"},
 	{Opt_fowner, "fowner=%s"},
 	{Opt_appraise_type, "appraise_type=%s"},
@@ -519,6 +526,19 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 			if (!result)
 				entry->flags |= IMA_FSMAGIC;
 			break;
+		case Opt_fsuuid:
+			ima_log_string(ab, "fsuuid", args[0].from);
+
+			if (memchr_inv(entry->fsuuid, 0x00,
+			    sizeof(entry->fsuuid))) {
+				result = -EINVAL;
+				break;
+			}
+
+			part_pack_uuid(args[0].from, entry->fsuuid);
+			entry->flags |= IMA_FSUUID;
+			result = 0;
+			break;
 		case Opt_uid:
 			ima_log_string(ab, "uid", args[0].from);
 
-- 
1.8.1.rc3


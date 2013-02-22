Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab3BVTrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 14:47:21 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:48488 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759Ab3BVTrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 14:47:18 -0500
Message-ID: <1361562413.2908.22.camel@falcor1.watson.ibm.com>
Subject: [PATCH] ima: fix part_pack_uuid() build error
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Randy Dunlap <rdunlap@infradead.org>, David Rientjes <rientjes@google.com>
Cc: James Morris <jmorris@namei.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Date: Fri, 22 Feb 2013 14:46:53 -0500
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022219-9360-0000-0000-000010FE16BF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a build error when CONFIG_BLOCK is not enabled by defining
a wrapper called ima_part_pack_uuid().  The wrapper returns
-EINVAL, when CONFIG_BLOCK is not defined.

security/integrity/ima/ima_policy.c:538:4: error: implicit declaration
of function 'part_pack_uuid' [-Werror=implicit-function-declaration]

Changelog v0:
- fix UUID scripts/Lindent msgs

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: David Rientjes <rientjes@google.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/ima/ima.h        | 13 +++++++++++++
 security/integrity/ima/ima_policy.c | 11 ++++++-----
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index a41c9c1..902c356 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -21,6 +21,7 @@
 #include <linux/crypto.h>
 #include <linux/security.h>
 #include <linux/hash.h>
+#include <linux/genhd.h>
 #include <linux/tpm.h>
 #include <linux/audit.h>
 
@@ -199,4 +200,16 @@ static inline int security_filter_rule_match(u32 secid, u32 field, u32 op,
 	return -EINVAL;
 }
 #endif /* CONFIG_IMA_LSM_RULES */
+
+/* UUID policy option requires CONFIG_BLOCK */
+#ifdef CONFIG_BLOCK
+static inline int ima_part_pack_uuid(const u8 *uuid_str, u8 *to) {
+	part_pack_uuid(uuid_str, to);
+	return 0;
+}
+#else
+static inline int ima_part_pack_uuid(const u8 *uuid_str, u8 *to) {
+	return -EINVAL;
+}
+#endif
 #endif
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index b27535a..41b7f48 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -176,7 +176,7 @@ static bool ima_match_rules(struct ima_rule_entry *rule,
 	    && rule->fsmagic != inode->i_sb->s_magic)
 		return false;
 	if ((rule->flags & IMA_FSUUID) &&
-		memcmp(rule->fsuuid, inode->i_sb->s_uuid, sizeof(rule->fsuuid)))
+	    memcmp(rule->fsuuid, inode->i_sb->s_uuid, sizeof(rule->fsuuid)))
 		return false;
 	if ((rule->flags & IMA_UID) && !uid_eq(rule->uid, cred->uid))
 		return false;
@@ -530,14 +530,15 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 			ima_log_string(ab, "fsuuid", args[0].from);
 
 			if (memchr_inv(entry->fsuuid, 0x00,
-			    sizeof(entry->fsuuid))) {
+				       sizeof(entry->fsuuid))) {
 				result = -EINVAL;
 				break;
 			}
 
-			part_pack_uuid(args[0].from, entry->fsuuid);
-			entry->flags |= IMA_FSUUID;
-			result = 0;
+			result = ima_part_pack_uuid(args[0].from,
+						    entry->fsuuid);
+			if (!result)
+				entry->flags |= IMA_FSUUID;
 			break;
 		case Opt_uid:
 			ima_log_string(ab, "uid", args[0].from);
-- 
1.8.1.rc3




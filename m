Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345Ab3K1RRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 12:17:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:9529 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757452Ab3K1RRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 12:17:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,792,1378882800"; 
   d="scan'208";a="443778635"
From: jarkko.sakkinen@linux.intel.com
To: casey@schaufler-ca.com
Cc: james.l.morris@oracle.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] smack: fix: allow either entry be missing on access/access2 check (v2)
Date: Thu, 28 Nov 2013 19:16:46 +0200
Message-Id: <1385659006-5016-1-git-send-email-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

This is a regression caused by f7112e6c. When either subject or
object is not found the answer for access should be no. This
patch fixes the situation. '0' is written back instead of failing
with -EINVAL.

v2: cosmetic style fixes

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 security/smack/smackfs.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 80f4b4a..e97fac7 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -297,7 +297,8 @@ static int smk_perm_from_str(const char *string)
  * @import: if non-zero, import labels
  * @len: label length limit
  *
- * Returns 0 on success, -1 on failure
+ * Returns 0 on success, -EINVAL on failure and -ENOENT when either subject
+ * or object is missing.
  */
 static int smk_fill_rule(const char *subject, const char *object,
 				const char *access1, const char *access2,
@@ -310,28 +311,28 @@ static int smk_fill_rule(const char *subject, const char *object,
 	if (import) {
 		rule->smk_subject = smk_import_entry(subject, len);
 		if (rule->smk_subject == NULL)
-			return -1;
+			return -EINVAL;
 
 		rule->smk_object = smk_import(object, len);
 		if (rule->smk_object == NULL)
-			return -1;
+			return -EINVAL;
 	} else {
 		cp = smk_parse_smack(subject, len);
 		if (cp == NULL)
-			return -1;
+			return -EINVAL;
 		skp = smk_find_entry(cp);
 		kfree(cp);
 		if (skp == NULL)
-			return -1;
+			return -ENOENT;
 		rule->smk_subject = skp;
 
 		cp = smk_parse_smack(object, len);
 		if (cp == NULL)
-			return -1;
+			return -EINVAL;
 		skp = smk_find_entry(cp);
 		kfree(cp);
 		if (skp == NULL)
-			return -1;
+			return -ENOENT;
 		rule->smk_object = skp->smk_known;
 	}
 
@@ -377,6 +378,7 @@ static ssize_t smk_parse_long_rule(char *data, struct smack_parsed_rule *rule,
 {
 	ssize_t cnt = 0;
 	char *tok[4];
+	int rc;
 	int i;
 
 	/*
@@ -401,10 +403,8 @@ static ssize_t smk_parse_long_rule(char *data, struct smack_parsed_rule *rule,
 	while (i < 4)
 		tok[i++] = NULL;
 
-	if (smk_fill_rule(tok[0], tok[1], tok[2], tok[3], rule, import, 0))
-		return -1;
-
-	return cnt;
+	rc = smk_fill_rule(tok[0], tok[1], tok[2], tok[3], rule, import, 0);
+	return rc == 0 ? cnt : rc;
 }
 
 #define SMK_FIXED24_FMT	0	/* Fixed 24byte label format */
@@ -1850,11 +1850,12 @@ static ssize_t smk_user_access(struct file *file, const char __user *buf,
 		res = smk_parse_long_rule(data, &rule, 0, 3);
 	}
 
-	if (res < 0)
+	if (res >= 0)
+		res = smk_access(rule.smk_subject, rule.smk_object,
+				 rule.smk_access1, NULL);
+	else if (res != -ENOENT)
 		return -EINVAL;
 
-	res = smk_access(rule.smk_subject, rule.smk_object,
-				rule.smk_access1, NULL);
 	data[0] = res == 0 ? '1' : '0';
 	data[1] = '\0';
 
-- 
1.7.9.5


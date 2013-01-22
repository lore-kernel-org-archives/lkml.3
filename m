Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab3AVWI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 17:08:58 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53561 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621Ab3AVWIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 17:08:53 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, James Morris <jmorris@namei.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Subject: [PATCH v2 4/4] ima: differentiate appraise status only for hook specific rules
Date: Tue, 22 Jan 2013 17:07:34 -0500
Message-Id: <1358892454-25045-5-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.rc3
In-Reply-To: <1358892454-25045-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1358892454-25045-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012222-7182-0000-0000-000004A1D5F3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Different hooks can require different methods for appraising a
file's integrity.  As a result, an integrity appraisal status is
cached on a per hook basis.

Only a hook specific rule, requires the inode to be re-appraised.
This patch eliminates unnecessary appraisals.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
---
 security/integrity/ima/ima_main.c   | 9 ++++++---
 security/integrity/ima/ima_policy.c | 9 ++++++---
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 66b7f40..3e751a9 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -146,7 +146,7 @@ static int process_measurement(struct file *file, const char *filename,
 	struct integrity_iint_cache *iint;
 	char *pathbuf = NULL;
 	const char *pathname = NULL;
-	int rc = -ENOMEM, action, must_appraise;
+	int rc = -ENOMEM, action, must_appraise, _func;
 
 	if (!ima_initialized || !S_ISREG(inode->i_mode))
 		return 0;
@@ -161,6 +161,9 @@ static int process_measurement(struct file *file, const char *filename,
 
 	must_appraise = action & IMA_APPRAISE;
 
+	/*  Is the appraise rule hook specific?  */
+	_func = (action & IMA_FILE_APPRAISE) ? FILE_CHECK : function;
+
 	mutex_lock(&inode->i_mutex);
 
 	iint = integrity_inode_get(inode);
@@ -178,7 +181,7 @@ static int process_measurement(struct file *file, const char *filename,
 	/* Nothing to do, just return existing appraised status */
 	if (!action) {
 		if (must_appraise)
-			rc = ima_get_cache_status(iint, function);
+			rc = ima_get_cache_status(iint, _func);
 		goto out_digsig;
 	}
 
@@ -195,7 +198,7 @@ static int process_measurement(struct file *file, const char *filename,
 	if (action & IMA_MEASURE)
 		ima_store_measurement(iint, file, pathname);
 	if (action & IMA_APPRAISE_SUBMASK)
-		rc = ima_appraise_measurement(function, iint, file, pathname);
+		rc = ima_appraise_measurement(_func, iint, file, pathname);
 	if (action & IMA_AUDIT)
 		ima_audit_measurement(iint, pathname);
 	kfree(pathbuf);
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 4d7c0ae..4adcd0f 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -220,10 +220,13 @@ retry:
 
 /*
  * In addition to knowing that we need to appraise the file in general,
- * we need to differentiate between calling hooks.
+ * we need to differentiate between calling hooks, for hook specific rules.
  */
-static int get_subaction(int func)
+static int get_subaction(struct ima_rule_entry *rule, int func)
 {
+	if (!(rule->flags & IMA_FUNC))
+		return IMA_FILE_APPRAISE;
+
 	switch(func) {
 	case MMAP_CHECK:
 		return IMA_MMAP_APPRAISE;
@@ -268,7 +271,7 @@ int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask,
 
 		action |= entry->action & IMA_DO_MASK;
 		if (entry->action & IMA_APPRAISE)
-			action |= get_subaction(func);
+			action |= get_subaction(entry, func);
 
 		if (entry->action & IMA_DO_MASK)
 			actmask &= ~(entry->action | entry->action << 1);
-- 
1.8.1.rc3


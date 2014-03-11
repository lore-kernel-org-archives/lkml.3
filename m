Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbaCKQHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 12:07:47 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34278 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbaCKQHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 12:07:45 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-29-531f34ce56e7
From: Lukasz Pawelczyk <l.pawelczyk@partner.samsung.com>
To: Casey Schaufler <casey@schaufler-ca.com>,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: r.krypa@samsung.com, t.swierczek@samsung.com,
        Lukasz Pawelczyk <l.pawelczyk@partner.samsung.com>
Subject: [PATCH 1/3] Smack: fix the subject/object order in
 smack_ptrace_traceme()
Date: Tue, 11 Mar 2014 17:07:04 +0100
Message-id: <1394554026-23924-2-git-send-email-l.pawelczyk@partner.samsung.com>
X-Mailer: git-send-email 1.8.5.3
In-reply-to: <1394554026-23924-1-git-send-email-l.pawelczyk@partner.samsung.com>
References: <1394554026-23924-1-git-send-email-l.pawelczyk@partner.samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCJMWRmVeSWpSXmKPExsVy+t/xK7rnTOSDDVYeVrK4t+0Xm0Xf4yCL
	WQfXslpc3jWHzeJDzyM2i7eTVjBb/Lo9hdWB3ePj01ssHgff7WHy6NuyitHj6P5FbB6fN8kF
	sEZx2aSk5mSWpRbp2yVwZexv8C64o1Cx/vEUlgbGs1JdjJwcEgImEtd/rGGEsMUkLtxbz9bF
	yMUhJLCUUaJlxm0mCKeXSWLtw3dsIFVsAhYS+6bdYAVJiAjMZ5SY/2MxkMPBwSyQJnHzgz1I
	jbBAiMTPBVdYQGwWAVWJrWu2sYLYvAL+En8/H2SH2KYg0bJsF5jNKRAgcbxrFVi9EFDNtG2L
	2Ccw8i5gZFjFKJpamlxQnJSea6hXnJhbXJqXrpecn7uJERJSX3YwLj5mdYhRgINRiYd3hpJ8
	sBBrYllxZe4hRgkOZiUR3o+aQCHelMTKqtSi/Pii0pzU4kOMTBycUg2Ms584WEyPTnvuH3yk
	hWlXvIYP14z100Mm8Dt9WXjywkJFT+fDV2uF1C+u8Im7fvdj8iI71tkpjSEl4be2Rkvb/umP
	X9N8sf75hSvP9cWEr09dtp/3toqP8O6tz2eaRDxbfnzntPQFEkXx+fyVzuFbnUvPnuj/sP1b
	1Yqq21NSdQx1HxzWmTo3S4mlOCPRUIu5qDgRAJf3oSgHAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The order of subject/object is currently reversed in
smack_ptrace_traceme(). It is currently checked if the tracee has a
capability to trace tracer and according to this rule a decision is made
whether the tracer will be allowed to trace tracee.

Signed-off-by: Lukasz Pawelczyk <l.pawelczyk@partner.samsung.com>
Signed-off-by: Rafal Krypa <r.krypa@samsung.com>
---
 security/smack/smack.h        |  1 +
 security/smack/smack_access.c | 33 ++++++++++++++++++++++++++-------
 security/smack/smack_lsm.c    |  4 ++--
 3 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/security/smack/smack.h b/security/smack/smack.h
index d072fd3..b9dfc4e 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -225,6 +225,7 @@ struct inode_smack *new_inode_smack(char *);
  */
 int smk_access_entry(char *, char *, struct list_head *);
 int smk_access(struct smack_known *, char *, int, struct smk_audit_info *);
+int smk_tskacc(struct task_smack *, char *, u32, struct smk_audit_info *);
 int smk_curacc(char *, u32, struct smk_audit_info *);
 struct smack_known *smack_from_secid(const u32);
 char *smk_parse_smack(const char *string, int len);
diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index 14293cd..f161deb 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -192,20 +192,21 @@ out_audit:
 }
 
 /**
- * smk_curacc - determine if current has a specific access to an object
+ * smk_tskacc - determine if a task has a specific access to an object
+ * @tsp: a pointer to the subject task
  * @obj_label: a pointer to the object's Smack label
  * @mode: the access requested, in "MAY" format
  * @a : common audit data
  *
- * This function checks the current subject label/object label pair
+ * This function checks the subject task's label/object label pair
  * in the access rule list and returns 0 if the access is permitted,
- * non zero otherwise. It allows that current may have the capability
+ * non zero otherwise. It allows that the task may have the capability
  * to override the rules.
  */
-int smk_curacc(char *obj_label, u32 mode, struct smk_audit_info *a)
+int smk_tskacc(struct task_smack *subject, char *obj_label,
+	       u32 mode, struct smk_audit_info *a)
 {
-	struct task_smack *tsp = current_security();
-	struct smack_known *skp = smk_of_task(tsp);
+	struct smack_known *skp = smk_of_task(subject);
 	int may;
 	int rc;
 
@@ -219,7 +220,7 @@ int smk_curacc(char *obj_label, u32 mode, struct smk_audit_info *a)
 		 * it can further restrict access.
 		 */
 		may = smk_access_entry(skp->smk_known, obj_label,
-					&tsp->smk_rules);
+					&subject->smk_rules);
 		if (may < 0)
 			goto out_audit;
 		if ((mode & may) == mode)
@@ -241,6 +242,24 @@ out_audit:
 	return rc;
 }
 
+/**
+ * smk_curacc - determine if current has a specific access to an object
+ * @obj_label: a pointer to the object's Smack label
+ * @mode: the access requested, in "MAY" format
+ * @a : common audit data
+ *
+ * This function checks the current subject label/object label pair
+ * in the access rule list and returns 0 if the access is permitted,
+ * non zero otherwise. It allows that current may have the capability
+ * to override the rules.
+ */
+int smk_curacc(char *obj_label, u32 mode, struct smk_audit_info *a)
+{
+	struct task_smack *tsp = current_security();
+
+	return smk_tskacc(tsp, obj_label, mode, a);
+}
+
 #ifdef CONFIG_AUDIT
 /**
  * smack_str_from_perm : helper to transalate an int to a
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index d814e35..48d61f6 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -207,11 +207,11 @@ static int smack_ptrace_traceme(struct task_struct *ptp)
 	if (rc != 0)
 		return rc;
 
-	skp = smk_of_task(task_security(ptp));
+	skp = smk_of_task(current_security());
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
 	smk_ad_setfield_u_tsk(&ad, ptp);
 
-	rc = smk_curacc(skp->smk_known, MAY_READWRITE, &ad);
+	rc = smk_tskacc(ptp, skp->smk_known, MAY_READWRITE, &ad);
 	return rc;
 }
 
-- 
1.8.5.3


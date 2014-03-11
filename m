Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbaCKQIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 12:08:24 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:29346 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbaCKQHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 12:07:46 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-36-531f34d12dad
From: Lukasz Pawelczyk <l.pawelczyk@partner.samsung.com>
To: Casey Schaufler <casey@schaufler-ca.com>,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: r.krypa@samsung.com, t.swierczek@samsung.com,
        Lukasz Pawelczyk <l.pawelczyk@partner.samsung.com>
Subject: [PATCH 2/3] Smack: unify all ptrace accesses in the smack
Date: Tue, 11 Mar 2014 17:07:05 +0100
Message-id: <1394554026-23924-3-git-send-email-l.pawelczyk@partner.samsung.com>
X-Mailer: git-send-email 1.8.5.3
In-reply-to: <1394554026-23924-1-git-send-email-l.pawelczyk@partner.samsung.com>
References: <1394554026-23924-1-git-send-email-l.pawelczyk@partner.samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCJMWRmVeSWpSXmKPExsVy+t/xK7oXTeSDDQ6c4LG4t+0Xm0Xf4yCL
	WQfXslpc3jWHzeJDzyM2i7eTVjBb/Lo9hdWB3ePj01ssHgff7WHy6NuyitHj6P5FbB6fN8kF
	sEZx2aSk5mSWpRbp2yVwZSy+3Mhe8F6nonPeeqYGxqkqXYycHBICJhL3981igrDFJC7cW88G
	YgsJLGWUeN6o1MXIBWT3Mkk0vn3DCpJgE7CQ2DftBitIQkRgPqPE/B+LgRwODmaBNImbH+xB
	aoQFnCTenNvFDGKzCKhK3Hu4BWwor4C/xJT9s9gglilItCzbxQ5icwoESBzvWsUCsdhfYtq2
	RewTGHkXMDKsYhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAgJqS87GBcfszrEKMDBqMTDO0NJ
	PliINbGsuDL3EKMEB7OSCO9HTaAQb0piZVVqUX58UWlOavEhRiYOTqkGxtUNgpmTFEv0Dv79
	33JF4fn5G8U+k5bcU1bZ3cg492aYD7u34o369e++bdRcUK+yeEJJ103H6X4TT8VuKF/+/6Xb
	Qt2XNnESAn84dPQf1WrfjmS42nSgpPhGk3CaxBKtiP64NXNVLu8+fXBN8/scix3FZ/wq5886
	7XJNpIv906zS1/9T3vGdVVViKc5INNRiLipOBAAyr3DcBwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The decision whether we can trace a process is made in the following
functions:
	smack_ptrace_traceme()
	smack_ptrace_access_check()
	smack_bprm_set_creds() (in case the proces is traced)

This patch unifies all those decisions by introducing one function that
checks whether ptrace is allowed: smk_ptrace_rule_check().

This makes possible to actually trace with TRACEME where first the
TRACEME itself must be allowed and then exec() on a traced process.

Additional bugs fixed:
- The decision is made according to the mode parameter that is now correctly
  translated from PTRACE_MODE_* to MAY_* instead of being treated 1:1.
  PTRACE_MODE_READ requires MAY_READ.
  PTRACE_MODE_ATTACH requires MAY_READWRITE.
- Add a smack audit log in case of exec() refused by bprm_set_creds().
- Honor the PTRACE_MODE_NOAUDIT flag and don't put smack audit info
  in case this flag is set.

Signed-off-by: Lukasz Pawelczyk <l.pawelczyk@partner.samsung.com>
Signed-off-by: Rafal Krypa <r.krypa@samsung.com>
---
 security/smack/smack_lsm.c | 84 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 71 insertions(+), 13 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 48d61f6..3da13fd 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -157,6 +157,54 @@ static int smk_copy_rules(struct list_head *nhead, struct list_head *ohead,
 	return rc;
 }
 
+/**
+ * smk_ptrace_mode - helper function for converting PTRACE_MODE_* into MAY_*
+ * @mode - input mode in form of PTRACE_MODE_*
+ *
+ * Returns a converted MAY_* mode usable by smack rules
+ */
+static inline unsigned int smk_ptrace_mode(unsigned int mode)
+{
+	switch (mode) {
+	case PTRACE_MODE_READ:
+		return MAY_READ;
+	case PTRACE_MODE_ATTACH:
+		return MAY_READWRITE;
+	}
+
+	return 0;
+}
+
+/**
+ * smk_ptrace_rule_check - helper for ptrace access
+ * @tracer: tracer process
+ * @tracee_label: label of the process that's about to be traced
+ * @mode: ptrace attachment mode (PTRACE_MODE_*)
+ * @func: name of the function that called us, used for audit
+ *
+ * Returns 0 on access granted, -error on error
+ */
+static int smk_ptrace_rule_check(struct task_struct *tracer, char *tracee_label,
+				 unsigned int mode, const char *func)
+{
+	int rc;
+	struct smk_audit_info ad, *saip = NULL;
+	struct task_smack *tsp;
+	struct smack_known *skp;
+
+	if ((mode & PTRACE_MODE_NOAUDIT) == 0) {
+		smk_ad_init(&ad, func, LSM_AUDIT_DATA_TASK);
+		smk_ad_setfield_u_tsk(&ad, tracer);
+		saip = &ad;
+	}
+
+	tsp = task_security(tracer);
+	skp = smk_of_task(tsp);
+
+	rc = smk_tskacc(tsp, tracee_label, smk_ptrace_mode(mode), saip);
+	return rc;
+}
+
 /*
  * LSM hooks.
  * We he, that is fun!
@@ -165,16 +213,15 @@ static int smk_copy_rules(struct list_head *nhead, struct list_head *ohead,
 /**
  * smack_ptrace_access_check - Smack approval on PTRACE_ATTACH
  * @ctp: child task pointer
- * @mode: ptrace attachment mode
+ * @mode: ptrace attachment mode (PTRACE_MODE_*)
  *
  * Returns 0 if access is OK, an error code otherwise
  *
- * Do the capability checks, and require read and write.
+ * Do the capability checks.
  */
 static int smack_ptrace_access_check(struct task_struct *ctp, unsigned int mode)
 {
 	int rc;
-	struct smk_audit_info ad;
 	struct smack_known *skp;
 
 	rc = cap_ptrace_access_check(ctp, mode);
@@ -182,10 +229,8 @@ static int smack_ptrace_access_check(struct task_struct *ctp, unsigned int mode)
 		return rc;
 
 	skp = smk_of_task(task_security(ctp));
-	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
-	smk_ad_setfield_u_tsk(&ad, ctp);
 
-	rc = smk_curacc(skp->smk_known, mode, &ad);
+	rc = smk_ptrace_rule_check(current, skp->smk_known, mode, __func__);
 	return rc;
 }
 
@@ -195,12 +240,11 @@ static int smack_ptrace_access_check(struct task_struct *ctp, unsigned int mode)
  *
  * Returns 0 if access is OK, an error code otherwise
  *
- * Do the capability checks, and require read and write.
+ * Do the capability checks, and require PTRACE_MODE_ATTACH.
  */
 static int smack_ptrace_traceme(struct task_struct *ptp)
 {
 	int rc;
-	struct smk_audit_info ad;
 	struct smack_known *skp;
 
 	rc = cap_ptrace_traceme(ptp);
@@ -208,10 +252,9 @@ static int smack_ptrace_traceme(struct task_struct *ptp)
 		return rc;
 
 	skp = smk_of_task(current_security());
-	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
-	smk_ad_setfield_u_tsk(&ad, ptp);
 
-	rc = smk_tskacc(ptp, skp->smk_known, MAY_READWRITE, &ad);
+	rc = smk_ptrace_rule_check(ptp, skp->smk_known,
+				   PTRACE_MODE_ATTACH, __func__);
 	return rc;
 }
 
@@ -453,7 +496,7 @@ static int smack_sb_statfs(struct dentry *dentry)
  * smack_bprm_set_creds - set creds for exec
  * @bprm: the exec information
  *
- * Returns 0 if it gets a blob, -ENOMEM otherwise
+ * Returns 0 if it gets a blob, -EPERM if exec forbidden and -ENOMEM otherwise
  */
 static int smack_bprm_set_creds(struct linux_binprm *bprm)
 {
@@ -473,7 +516,22 @@ static int smack_bprm_set_creds(struct linux_binprm *bprm)
 	if (isp->smk_task == NULL || isp->smk_task == bsp->smk_task)
 		return 0;
 
-	if (bprm->unsafe)
+	if (bprm->unsafe & (LSM_UNSAFE_PTRACE | LSM_UNSAFE_PTRACE_CAP)) {
+		struct task_struct *tracer;
+		rc = 0;
+
+		rcu_read_lock();
+		tracer = ptrace_parent(current);
+		if (likely(tracer != NULL))
+			rc = smk_ptrace_rule_check(tracer,
+						   isp->smk_task->smk_known,
+						   PTRACE_MODE_ATTACH,
+						   __func__);
+		rcu_read_unlock();
+
+		if (rc != 0)
+			return rc;
+	} else if (bprm->unsafe)
 		return -EPERM;
 
 	bsp->smk_task = isp->smk_task;
-- 
1.8.5.3


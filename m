Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbaH2PDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 11:03:39 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:29806 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbaH2PDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 11:03:08 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-e6-54009629d666
From: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
To: r.krypa@samsung.com, havner@gmail.com, m.lis@samsung.com,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        James Morris <james.l.morris@oracle.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Cc: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
Subject: [PATCH 3/3] Make Smack operate on smack_known struct where it still
 used char*
Date: Fri, 29 Aug 2014 17:02:55 +0200
Message-id: <1409324575-12057-3-git-send-email-l.pawelczyk@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1409324575-12057-1-git-send-email-l.pawelczyk@samsung.com>
References: <1409324575-12057-1-git-send-email-l.pawelczyk@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphluLIzCtJLcpLzFFi42I5/e/4NV3NaQwhBp+2iFnc2/aLzeL/ax2L
	vsdBFmcmLWSyuLxrDpvFh55HbBZ3D75lsXg7aQWzxfkL59gdOD12zrrL7nFtd6THx6e3WDz6
	tqxi9Di6fxGbx+dNcgFsUVw2Kak5mWWpRfp2CVwZ5zu/MRX8+85U8erBH6YGxlurmLoYOTkk
	BEwkmu5dgLLFJC7cW88GYgsJLGWUmP8ssouRC8juZZKYO2cDC0iCTcBA4vuFvcwgCRGBZiaJ
	GdtWgHUzC+hJTFqyG6xIWCBS4va9u2CTWARUJe42dTKD2LwC7hLHdqxmhdgmJ9G77Q1YnFPA
	Q+LCzS+sEJvdJT4tWsY6gZF3ASPDKkbR1NLkguKk9FwjveLE3OLSvHS95PzcTYyQkPu6g3Hp
	MatDjAIcjEo8vC8yGEKEWBPLiitzDzFKcDArifCumwAU4k1JrKxKLcqPLyrNSS0+xMjEwSnV
	wMi8ZNW6DqbiqRHy58VWnL92+FhMmhhT0Pa9v2d43WRXNflbv6zjgm7AfB5ehcOJtsVtV5r4
	9q6eEnbfbVrAwZ3q9+Nzzs3fJbdtHX/LltyWFw8MbQzKOj/MvucnJlAoMH33pNRWhRWf3777
	krEu5+ued/LTGVK3Xr53w7LUoEElYav64fjFr+cosRRnJBpqMRcVJwIANra95BcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Smack used to use a mix of smack_known struct and char* throughout its
APIs and implementation. This patch unifies the behaviour and makes it
store and operate exclusively on smack_known struct pointers when managing
labels.

Signed-off-by: Lukasz Pawelczyk <l.pawelczyk@samsung.com>

Conflicts:
	security/smack/smack_access.c
	security/smack/smack_lsm.c
---
 security/smack/smack.h        |  34 ++---
 security/smack/smack_access.c |  94 +++++--------
 security/smack/smack_lsm.c    | 299 +++++++++++++++++++++---------------------
 security/smack/smackfs.c      |  61 +++++----
 4 files changed, 233 insertions(+), 255 deletions(-)

diff --git a/security/smack/smack.h b/security/smack/smack.h
index 2d13d5f..b828a37 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -71,11 +71,11 @@ struct smack_known {
 #define SMK_CIPSOLEN	24
 
 struct superblock_smack {
-	char		*smk_root;
-	char		*smk_floor;
-	char		*smk_hat;
-	char		*smk_default;
-	int		smk_initialized;
+	struct smack_known	*smk_root;
+	struct smack_known	*smk_floor;
+	struct smack_known	*smk_hat;
+	struct smack_known	*smk_default;
+	int			smk_initialized;
 };
 
 struct socket_smack {
@@ -88,7 +88,7 @@ struct socket_smack {
  * Inode smack data
  */
 struct inode_smack {
-	char			*smk_inode;	/* label of the fso */
+	struct smack_known	*smk_inode;	/* label of the fso */
 	struct smack_known	*smk_task;	/* label of the task */
 	struct smack_known	*smk_mmap;	/* label of the mmap domain */
 	struct mutex		smk_lock;	/* initialization lock */
@@ -112,7 +112,7 @@ struct task_smack {
 struct smack_rule {
 	struct list_head	list;
 	struct smack_known	*smk_subject;
-	char			*smk_object;
+	struct smack_known	*smk_object;
 	int			smk_access;
 };
 
@@ -123,7 +123,7 @@ struct smk_netlbladdr {
 	struct list_head	list;
 	struct sockaddr_in	smk_host;	/* network address */
 	struct in_addr		smk_mask;	/* network mask */
-	char			*smk_label;	/* label */
+	struct smack_known	*smk_label;	/* label */
 };
 
 /*
@@ -227,23 +227,23 @@ struct smk_audit_info {
 /*
  * These functions are in smack_lsm.c
  */
-struct inode_smack *new_inode_smack(char *);
+struct inode_smack *new_inode_smack(struct smack_known *);
 
 /*
  * These functions are in smack_access.c
  */
 int smk_access_entry(char *, char *, struct list_head *);
-int smk_access(struct smack_known *, char *, int, struct smk_audit_info *);
-int smk_tskacc(struct task_smack *, char *, u32, struct smk_audit_info *);
-int smk_curacc(char *, u32, struct smk_audit_info *);
+int smk_access(struct smack_known *, struct smack_known *,
+	       int, struct smk_audit_info *);
+int smk_tskacc(struct task_smack *, struct smack_known *,
+	       u32, struct smk_audit_info *);
+int smk_curacc(struct smack_known *, u32, struct smk_audit_info *);
 struct smack_known *smack_from_secid(const u32);
 char *smk_parse_smack(const char *string, int len);
 int smk_netlbl_mls(int, char *, struct netlbl_lsm_secattr *, int);
-char *smk_import(const char *, int);
 struct smack_known *smk_import_entry(const char *, int);
 void smk_insert_entry(struct smack_known *skp);
 struct smack_known *smk_find_entry(const char *);
-u32 smack_to_secid(const char *);
 
 /*
  * Shared data.
@@ -253,7 +253,7 @@ extern int smack_cipso_mapped;
 extern struct smack_known *smack_net_ambient;
 extern struct smack_known *smack_onlycap;
 extern struct smack_known *smack_syslog_label;
-extern const char *smack_cipso_option;
+extern struct smack_known smack_cipso_option;
 extern int smack_ptrace_rule;
 
 extern struct smack_known smack_known_floor;
@@ -282,9 +282,9 @@ static inline int smk_inode_transmutable(const struct inode *isp)
 }
 
 /*
- * Present a pointer to the smack label in an inode blob.
+ * Present a pointer to the smack label entry in an inode blob.
  */
-static inline char *smk_of_inode(const struct inode *isp)
+static inline struct smack_known *smk_of_inode(const struct inode *isp)
 {
 	struct inode_smack *sip = isp->i_security;
 	return sip->smk_inode;
diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index 9f02cb0..5b970ff 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -94,7 +94,7 @@ int smk_access_entry(char *subject_label, char *object_label,
 	struct smack_rule *srp;
 
 	list_for_each_entry_rcu(srp, rule_list, list) {
-		if (srp->smk_object == object_label &&
+		if (srp->smk_object->smk_known == object_label &&
 		    srp->smk_subject->smk_known == subject_label) {
 			may = srp->smk_access;
 			break;
@@ -111,8 +111,8 @@ int smk_access_entry(char *subject_label, char *object_label,
 
 /**
  * smk_access - determine if a subject has a specific access to an object
- * @subject_known: a pointer to the subject's Smack label entry
- * @object_label: a pointer to the object's Smack label
+ * @subject: a pointer to the subject's Smack label entry
+ * @object: a pointer to the object's Smack label entry
  * @request: the access requested, in "MAY" format
  * @a : a pointer to the audit data
  *
@@ -122,8 +122,8 @@ int smk_access_entry(char *subject_label, char *object_label,
  *
  * Smack labels are shared on smack_list
  */
-int smk_access(struct smack_known *subject_known, char *object_label,
-		int request, struct smk_audit_info *a)
+int smk_access(struct smack_known *subject, struct smack_known *object,
+	       int request, struct smk_audit_info *a)
 {
 	int may = MAY_NOT;
 	int rc = 0;
@@ -133,7 +133,7 @@ int smk_access(struct smack_known *subject_known, char *object_label,
 	 *
 	 * A star subject can't access any object.
 	 */
-	if (subject_known == &smack_known_star) {
+	if (subject == &smack_known_star) {
 		rc = -EACCES;
 		goto out_audit;
 	}
@@ -142,28 +142,28 @@ int smk_access(struct smack_known *subject_known, char *object_label,
 	 * Tasks cannot be assigned the internet label.
 	 * An internet subject can access any object.
 	 */
-	if (object_label == smack_known_web.smk_known ||
-	    subject_known == &smack_known_web)
+	if (object == &smack_known_web ||
+	    subject == &smack_known_web)
 		goto out_audit;
 	/*
 	 * A star object can be accessed by any subject.
 	 */
-	if (object_label == smack_known_star.smk_known)
+	if (object == &smack_known_star)
 		goto out_audit;
 	/*
 	 * An object can be accessed in any way by a subject
 	 * with the same label.
 	 */
-	if (subject_known->smk_known == object_label)
+	if (subject->smk_known == object->smk_known)
 		goto out_audit;
 	/*
 	 * A hat subject can read any object.
 	 * A floor object can be read by any subject.
 	 */
 	if ((request & MAY_ANYREAD) == request) {
-		if (object_label == smack_known_floor.smk_known)
+		if (object == &smack_known_floor)
 			goto out_audit;
-		if (subject_known == &smack_known_hat)
+		if (subject == &smack_known_hat)
 			goto out_audit;
 	}
 	/*
@@ -174,8 +174,8 @@ int smk_access(struct smack_known *subject_known, char *object_label,
 	 * indicates there is no entry for this pair.
 	 */
 	rcu_read_lock();
-	may = smk_access_entry(subject_known->smk_known, object_label,
-				&subject_known->smk_rules);
+	may = smk_access_entry(subject->smk_known, object->smk_known,
+			       &subject->smk_rules);
 	rcu_read_unlock();
 
 	if (may <= 0 || (request & may) != request) {
@@ -195,8 +195,8 @@ int smk_access(struct smack_known *subject_known, char *object_label,
 out_audit:
 #ifdef CONFIG_AUDIT
 	if (a)
-		smack_log(subject_known->smk_known, object_label, request,
-				rc, a);
+		smack_log(subject->smk_known, object->smk_known,
+			  request, rc, a);
 #endif
 
 	return rc;
@@ -204,8 +204,8 @@ out_audit:
 
 /**
  * smk_tskacc - determine if a task has a specific access to an object
- * @tsp: a pointer to the subject task
- * @obj_label: a pointer to the object's Smack label
+ * @tsp: a pointer to the subject's task
+ * @obj_known: a pointer to the object's label entry
  * @mode: the access requested, in "MAY" format
  * @a : common audit data
  *
@@ -214,24 +214,25 @@ out_audit:
  * non zero otherwise. It allows that the task may have the capability
  * to override the rules.
  */
-int smk_tskacc(struct task_smack *subject, char *obj_label,
+int smk_tskacc(struct task_smack *tsp, struct smack_known *obj_known,
 	       u32 mode, struct smk_audit_info *a)
 {
-	struct smack_known *skp = smk_of_task(subject);
+	struct smack_known *sbj_known = smk_of_task(tsp);
 	int may;
 	int rc;
 
 	/*
 	 * Check the global rule list
 	 */
-	rc = smk_access(skp, obj_label, mode, NULL);
+	rc = smk_access(sbj_known, obj_known, mode, NULL);
 	if (rc >= 0) {
 		/*
 		 * If there is an entry in the task's rule list
 		 * it can further restrict access.
 		 */
-		may = smk_access_entry(skp->smk_known, obj_label,
-					&subject->smk_rules);
+		may = smk_access_entry(sbj_known->smk_known,
+				       obj_known->smk_known,
+				       &tsp->smk_rules);
 		if (may < 0)
 			goto out_audit;
 		if ((mode & may) == mode)
@@ -248,14 +249,15 @@ int smk_tskacc(struct task_smack *subject, char *obj_label,
 out_audit:
 #ifdef CONFIG_AUDIT
 	if (a)
-		smack_log(skp->smk_known, obj_label, mode, rc, a);
+		smack_log(sbj_known->smk_known, obj_known->smk_known,
+			  mode, rc, a);
 #endif
 	return rc;
 }
 
 /**
  * smk_curacc - determine if current has a specific access to an object
- * @obj_label: a pointer to the object's Smack label
+ * @obj_known: a pointer to the object's Smack label entry
  * @mode: the access requested, in "MAY" format
  * @a : common audit data
  *
@@ -264,11 +266,12 @@ out_audit:
  * non zero otherwise. It allows that current may have the capability
  * to override the rules.
  */
-int smk_curacc(char *obj_label, u32 mode, struct smk_audit_info *a)
+int smk_curacc(struct smack_known *obj_known,
+	       u32 mode, struct smk_audit_info *a)
 {
 	struct task_smack *tsp = current_security();
 
-	return smk_tskacc(tsp, obj_label, mode, a);
+	return smk_tskacc(tsp, obj_known, mode, a);
 }
 
 #ifdef CONFIG_AUDIT
@@ -562,27 +565,6 @@ unlockout:
 }
 
 /**
- * smk_import - import a smack label
- * @string: a text string that might be a Smack label
- * @len: the maximum size, or zero if it is NULL terminated.
- *
- * Returns a pointer to the label in the label list that
- * matches the passed string, adding it if necessary.
- */
-char *smk_import(const char *string, int len)
-{
-	struct smack_known *skp;
-
-	/* labels cannot begin with a '-' */
-	if (string[0] == '-')
-		return NULL;
-	skp = smk_import_entry(string, len);
-	if (skp == NULL)
-		return NULL;
-	return skp->smk_known;
-}
-
-/**
  * smack_from_secid - find the Smack label associated with a secid
  * @secid: an integer that might be associated with a Smack label
  *
@@ -608,19 +590,3 @@ struct smack_known *smack_from_secid(const u32 secid)
 	rcu_read_unlock();
 	return &smack_known_invalid;
 }
-
-/**
- * smack_to_secid - find the secid associated with a Smack label
- * @smack: the Smack label
- *
- * Returns the appropriate secid if there is one,
- * otherwise 0
- */
-u32 smack_to_secid(const char *smack)
-{
-	struct smack_known *skp = smk_find_entry(smack);
-
-	if (skp == NULL)
-		return 0;
-	return skp->smk_secid;
-}
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 00443a9..93dc876 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -78,8 +78,8 @@ static void smk_bu_mode(int mode, char *s)
 #endif
 
 #ifdef CONFIG_SECURITY_SMACK_BRINGUP
-static int smk_bu_note(char *note, struct smack_known *sskp, char *osp,
-			int mode, int rc)
+static int smk_bu_note(char *note, struct smack_known *sskp,
+		       struct smack_known *oskp, int mode, int rc)
 {
 	char acc[SMK_NUM_ACCESS_TYPE + 1];
 
@@ -88,15 +88,16 @@ static int smk_bu_note(char *note, struct smack_known *sskp, char *osp,
 
 	smk_bu_mode(mode, acc);
 	pr_info("Smack Bringup: (%s %s %s) %s\n",
-		sskp->smk_known, osp, acc, note);
+		sskp->smk_known, oskp->smk_known, acc, note);
 	return 0;
 }
 #else
-#define smk_bu_note(note, sskp, osp, mode, RC) (RC)
+#define smk_bu_note(note, sskp, oskp, mode, RC) (RC)
 #endif
 
 #ifdef CONFIG_SECURITY_SMACK_BRINGUP
-static int smk_bu_current(char *note, char *osp, int mode, int rc)
+static int smk_bu_current(char *note, struct smack_known *oskp,
+			  int mode, int rc)
 {
 	struct task_smack *tsp = current_security();
 	char acc[SMK_NUM_ACCESS_TYPE + 1];
@@ -106,11 +107,12 @@ static int smk_bu_current(char *note, char *osp, int mode, int rc)
 
 	smk_bu_mode(mode, acc);
 	pr_info("Smack Bringup: (%s %s %s) %s %s\n",
-		tsp->smk_task->smk_known, osp, acc, current->comm, note);
+		tsp->smk_task->smk_known, oskp->smk_known,
+		acc, current->comm, note);
 	return 0;
 }
 #else
-#define smk_bu_current(note, osp, mode, RC) (RC)
+#define smk_bu_current(note, oskp, mode, RC) (RC)
 #endif
 
 #ifdef CONFIG_SECURITY_SMACK_BRINGUP
@@ -144,7 +146,7 @@ static int smk_bu_inode(struct inode *inode, int mode, int rc)
 
 	smk_bu_mode(mode, acc);
 	pr_info("Smack Bringup: (%s %s %s) inode=(%s %ld) %s\n",
-		tsp->smk_task->smk_known, smk_of_inode(inode), acc,
+		tsp->smk_task->smk_known, smk_of_inode(inode)->smk_known, acc,
 		inode->i_sb->s_id, inode->i_ino, current->comm);
 	return 0;
 }
@@ -188,7 +190,7 @@ static int smk_bu_credfile(const struct cred *cred, struct file *file,
 
 	smk_bu_mode(mode, acc);
 	pr_info("Smack Bringup: (%s %s %s) file=(%s %ld %s) %s\n",
-		sskp->smk_known, smk_of_inode(inode), acc,
+		sskp->smk_known, smk_of_inode(inode)->smk_known, acc,
 		inode->i_sb->s_id, inode->i_ino, file->f_dentry->d_name.name,
 		current->comm);
 	return 0;
@@ -230,11 +232,11 @@ static struct smack_known *smk_fetch(const char *name, struct inode *ip,
 
 /**
  * new_inode_smack - allocate an inode security blob
- * @smack: a pointer to the Smack label to use in the blob
+ * @skp: a pointer to the Smack label entry to use in the blob
  *
  * Returns the new blob or NULL if there's no memory available
  */
-struct inode_smack *new_inode_smack(char *smack)
+struct inode_smack *new_inode_smack(struct smack_known *skp)
 {
 	struct inode_smack *isp;
 
@@ -242,7 +244,7 @@ struct inode_smack *new_inode_smack(char *smack)
 	if (isp == NULL)
 		return NULL;
 
-	isp->smk_inode = smack;
+	isp->smk_inode = skp;
 	isp->smk_flags = 0;
 	mutex_init(&isp->smk_lock);
 
@@ -321,20 +323,20 @@ static inline unsigned int smk_ptrace_mode(unsigned int mode)
 /**
  * smk_ptrace_rule_check - helper for ptrace access
  * @tracer: tracer process
- * @tracee_label: label of the process that's about to be traced,
- *                the pointer must originate from smack structures
+ * @tracee_known: label entry of the process that's about to be traced
  * @mode: ptrace attachment mode (PTRACE_MODE_*)
  * @func: name of the function that called us, used for audit
  *
  * Returns 0 on access granted, -error on error
  */
-static int smk_ptrace_rule_check(struct task_struct *tracer, char *tracee_label,
+static int smk_ptrace_rule_check(struct task_struct *tracer,
+				 struct smack_known *tracee_known,
 				 unsigned int mode, const char *func)
 {
 	int rc;
 	struct smk_audit_info ad, *saip = NULL;
 	struct task_smack *tsp;
-	struct smack_known *skp;
+	struct smack_known *tracer_known;
 
 	if ((mode & PTRACE_MODE_NOAUDIT) == 0) {
 		smk_ad_init(&ad, func, LSM_AUDIT_DATA_TASK);
@@ -343,12 +345,12 @@ static int smk_ptrace_rule_check(struct task_struct *tracer, char *tracee_label,
 	}
 
 	tsp = task_security(tracer);
-	skp = smk_of_task(tsp);
+	tracer_known = smk_of_task(tsp);
 
 	if ((mode & PTRACE_MODE_ATTACH) &&
 	    (smack_ptrace_rule == SMACK_PTRACE_EXACT ||
 	     smack_ptrace_rule == SMACK_PTRACE_DRACONIAN)) {
-		if (skp->smk_known == tracee_label)
+		if (tracer_known->smk_known == tracee_known->smk_known)
 			rc = 0;
 		else if (smack_ptrace_rule == SMACK_PTRACE_DRACONIAN)
 			rc = -EACCES;
@@ -358,13 +360,15 @@ static int smk_ptrace_rule_check(struct task_struct *tracer, char *tracee_label,
 			rc = -EACCES;
 
 		if (saip)
-			smack_log(skp->smk_known, tracee_label, 0, rc, saip);
+			smack_log(tracer_known->smk_known,
+				  tracee_known->smk_known,
+				  0, rc, saip);
 
 		return rc;
 	}
 
 	/* In case of rule==SMACK_PTRACE_DEFAULT or mode==PTRACE_MODE_READ */
-	rc = smk_tskacc(tsp, tracee_label, smk_ptrace_mode(mode), saip);
+	rc = smk_tskacc(tsp, tracee_known, smk_ptrace_mode(mode), saip);
 	return rc;
 }
 
@@ -393,7 +397,7 @@ static int smack_ptrace_access_check(struct task_struct *ctp, unsigned int mode)
 
 	skp = smk_of_task(task_security(ctp));
 
-	rc = smk_ptrace_rule_check(current, skp->smk_known, mode, __func__);
+	rc = smk_ptrace_rule_check(current, skp, mode, __func__);
 	return rc;
 }
 
@@ -416,8 +420,7 @@ static int smack_ptrace_traceme(struct task_struct *ptp)
 
 	skp = smk_of_task(current_security());
 
-	rc = smk_ptrace_rule_check(ptp, skp->smk_known,
-				   PTRACE_MODE_ATTACH, __func__);
+	rc = smk_ptrace_rule_check(ptp, skp, PTRACE_MODE_ATTACH, __func__);
 	return rc;
 }
 
@@ -461,10 +464,10 @@ static int smack_sb_alloc_security(struct super_block *sb)
 	if (sbsp == NULL)
 		return -ENOMEM;
 
-	sbsp->smk_root = smack_known_floor.smk_known;
-	sbsp->smk_default = smack_known_floor.smk_known;
-	sbsp->smk_floor = smack_known_floor.smk_known;
-	sbsp->smk_hat = smack_known_hat.smk_known;
+	sbsp->smk_root = &smack_known_floor;
+	sbsp->smk_default = &smack_known_floor;
+	sbsp->smk_floor = &smack_known_floor;
+	sbsp->smk_hat = &smack_known_hat;
 	/*
 	 * smk_initialized will be zero from kzalloc.
 	 */
@@ -548,7 +551,6 @@ static int smack_sb_kern_mount(struct super_block *sb, int flags, void *data)
 	struct smack_known *skp;
 	char *op;
 	char *commap;
-	char *nsp;
 	int transmute = 0;
 	int specified = 0;
 
@@ -564,38 +566,38 @@ static int smack_sb_kern_mount(struct super_block *sb, int flags, void *data)
 
 		if (strncmp(op, SMK_FSHAT, strlen(SMK_FSHAT)) == 0) {
 			op += strlen(SMK_FSHAT);
-			nsp = smk_import(op, 0);
-			if (nsp != NULL) {
-				sp->smk_hat = nsp;
+			skp = smk_import_entry(op, 0);
+			if (skp != NULL) {
+				sp->smk_hat = skp;
 				specified = 1;
 			}
 		} else if (strncmp(op, SMK_FSFLOOR, strlen(SMK_FSFLOOR)) == 0) {
 			op += strlen(SMK_FSFLOOR);
-			nsp = smk_import(op, 0);
-			if (nsp != NULL) {
-				sp->smk_floor = nsp;
+			skp = smk_import_entry(op, 0);
+			if (skp != NULL) {
+				sp->smk_floor = skp;
 				specified = 1;
 			}
 		} else if (strncmp(op, SMK_FSDEFAULT,
 				   strlen(SMK_FSDEFAULT)) == 0) {
 			op += strlen(SMK_FSDEFAULT);
-			nsp = smk_import(op, 0);
-			if (nsp != NULL) {
-				sp->smk_default = nsp;
+			skp = smk_import_entry(op, 0);
+			if (skp != NULL) {
+				sp->smk_default = skp;
 				specified = 1;
 			}
 		} else if (strncmp(op, SMK_FSROOT, strlen(SMK_FSROOT)) == 0) {
 			op += strlen(SMK_FSROOT);
-			nsp = smk_import(op, 0);
-			if (nsp != NULL) {
-				sp->smk_root = nsp;
+			skp = smk_import_entry(op, 0);
+			if (skp != NULL) {
+				sp->smk_root = skp;
 				specified = 1;
 			}
 		} else if (strncmp(op, SMK_FSTRANS, strlen(SMK_FSTRANS)) == 0) {
 			op += strlen(SMK_FSTRANS);
-			nsp = smk_import(op, 0);
-			if (nsp != NULL) {
-				sp->smk_root = nsp;
+			skp = smk_import_entry(op, 0);
+			if (skp != NULL) {
+				sp->smk_root = skp;
 				transmute = 1;
 				specified = 1;
 			}
@@ -612,8 +614,8 @@ static int smack_sb_kern_mount(struct super_block *sb, int flags, void *data)
 		 * Unprivileged mounts get root and default from the caller.
 		 */
 		skp = smk_of_current();
-		sp->smk_root = skp->smk_known;
-		sp->smk_default = skp->smk_known;
+		sp->smk_root = skp;
+		sp->smk_default = skp;
 	}
 	/*
 	 * Initialize the root inode.
@@ -690,7 +692,7 @@ static int smack_bprm_set_creds(struct linux_binprm *bprm)
 		tracer = ptrace_parent(current);
 		if (likely(tracer != NULL))
 			rc = smk_ptrace_rule_check(tracer,
-						   isp->smk_task->smk_known,
+						   isp->smk_task,
 						   PTRACE_MODE_ATTACH,
 						   __func__);
 		rcu_read_unlock();
@@ -751,7 +753,7 @@ static int smack_inode_alloc_security(struct inode *inode)
 {
 	struct smack_known *skp = smk_of_current();
 
-	inode->i_security = new_inode_smack(skp->smk_known);
+	inode->i_security = new_inode_smack(skp);
 	if (inode->i_security == NULL)
 		return -ENOMEM;
 	return 0;
@@ -786,8 +788,8 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 {
 	struct inode_smack *issp = inode->i_security;
 	struct smack_known *skp = smk_of_current();
-	char *isp = smk_of_inode(inode);
-	char *dsp = smk_of_inode(dir);
+	struct smack_known *isp = smk_of_inode(inode);
+	struct smack_known *dsp = smk_of_inode(dir);
 	int may;
 
 	if (name)
@@ -795,7 +797,8 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 
 	if (value) {
 		rcu_read_lock();
-		may = smk_access_entry(skp->smk_known, dsp, &skp->smk_rules);
+		may = smk_access_entry(skp->smk_known, dsp->smk_known,
+				       &skp->smk_rules);
 		rcu_read_unlock();
 
 		/*
@@ -810,13 +813,13 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 			issp->smk_flags |= SMK_INODE_CHANGED;
 		}
 
-		*value = kstrdup(isp, GFP_NOFS);
+		*value = kstrdup(isp->smk_known, GFP_NOFS);
 		if (*value == NULL)
 			return -ENOMEM;
 	}
 
 	if (len)
-		*len = strlen(isp);
+		*len = strlen(isp->smk_known);
 
 	return 0;
 }
@@ -832,7 +835,7 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 static int smack_inode_link(struct dentry *old_dentry, struct inode *dir,
 			    struct dentry *new_dentry)
 {
-	char *isp;
+	struct smack_known *isp;
 	struct smk_audit_info ad;
 	int rc;
 
@@ -939,7 +942,7 @@ static int smack_inode_rename(struct inode *old_inode,
 			      struct dentry *new_dentry)
 {
 	int rc;
-	char *isp;
+	struct smack_known *isp;
 	struct smk_audit_info ad;
 
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_DENTRY);
@@ -1127,9 +1130,9 @@ static void smack_inode_post_setxattr(struct dentry *dentry, const char *name,
 	if (strcmp(name, XATTR_NAME_SMACK) == 0) {
 		skp = smk_import_entry(value, size);
 		if (skp != NULL)
-			isp->smk_inode = skp->smk_known;
+			isp->smk_inode = skp;
 		else
-			isp->smk_inode = smack_known_invalid.smk_known;
+			isp->smk_inode = &smack_known_invalid;
 	} else if (strcmp(name, XATTR_NAME_SMACKEXEC) == 0) {
 		skp = smk_import_entry(value, size);
 		if (skp != NULL)
@@ -1238,14 +1241,14 @@ static int smack_inode_getsecurity(const struct inode *inode,
 	struct socket *sock;
 	struct super_block *sbp;
 	struct inode *ip = (struct inode *)inode;
-	char *isp;
+	struct smack_known *isp;
 	int ilen;
 	int rc = 0;
 
 	if (strcmp(name, XATTR_SMACK_SUFFIX) == 0) {
 		isp = smk_of_inode(inode);
-		ilen = strlen(isp);
-		*buffer = isp;
+		ilen = strlen(isp->smk_known);
+		*buffer = isp->smk_known;
 		return ilen;
 	}
 
@@ -1263,15 +1266,15 @@ static int smack_inode_getsecurity(const struct inode *inode,
 	ssp = sock->sk->sk_security;
 
 	if (strcmp(name, XATTR_SMACK_IPIN) == 0)
-		isp = ssp->smk_in->smk_known;
+		isp = ssp->smk_in;
 	else if (strcmp(name, XATTR_SMACK_IPOUT) == 0)
-		isp = ssp->smk_out->smk_known;
+		isp = ssp->smk_out;
 	else
 		return -EOPNOTSUPP;
 
-	ilen = strlen(isp);
+	ilen = strlen(isp->smk_known);
 	if (rc == 0) {
-		*buffer = isp;
+		*buffer = isp->smk_known;
 		rc = ilen;
 	}
 
@@ -1307,7 +1310,7 @@ static void smack_inode_getsecid(const struct inode *inode, u32 *secid)
 {
 	struct inode_smack *isp = inode->i_security;
 
-	*secid = smack_to_secid(isp->smk_inode);
+	*secid = isp->smk_inode->smk_secid;
 }
 
 /*
@@ -1346,7 +1349,7 @@ static int smack_file_alloc_security(struct file *file)
 {
 	struct smack_known *skp = smk_of_current();
 
-	file->f_security = skp->smk_known;
+	file->f_security = skp;
 	return 0;
 }
 
@@ -1474,7 +1477,7 @@ static int smack_mmap_file(struct file *file,
 	struct smack_known *mkp;
 	struct smack_rule *srp;
 	struct task_smack *tsp;
-	char *osmack;
+	struct smack_known *okp;
 	struct inode_smack *isp;
 	int may;
 	int mmay;
@@ -1500,18 +1503,19 @@ static int smack_mmap_file(struct file *file,
 	 * to that rule's object label.
 	 */
 	list_for_each_entry_rcu(srp, &skp->smk_rules, list) {
-		osmack = srp->smk_object;
+		okp = srp->smk_object;
 		/*
 		 * Matching labels always allows access.
 		 */
-		if (mkp->smk_known == osmack)
+		if (mkp->smk_known == okp->smk_known)
 			continue;
 		/*
 		 * If there is a matching local rule take
 		 * that into account as well.
 		 */
-		may = smk_access_entry(srp->smk_subject->smk_known, osmack,
-					&tsp->smk_rules);
+		may = smk_access_entry(srp->smk_subject->smk_known,
+				       okp->smk_known,
+				       &tsp->smk_rules);
 		if (may == -ENOENT)
 			may = srp->smk_access;
 		else
@@ -1528,8 +1532,8 @@ static int smack_mmap_file(struct file *file,
 		 * If there isn't one a SMACK64MMAP subject
 		 * can't have as much access as current.
 		 */
-		mmay = smk_access_entry(mkp->smk_known, osmack,
-						&mkp->smk_rules);
+		mmay = smk_access_entry(mkp->smk_known, okp->smk_known,
+					&mkp->smk_rules);
 		if (mmay == -ENOENT) {
 			rc = -EACCES;
 			break;
@@ -1538,8 +1542,8 @@ static int smack_mmap_file(struct file *file,
 		 * If there is a local entry it modifies the
 		 * potential access, too.
 		 */
-		tmay = smk_access_entry(mkp->smk_known, osmack,
-						&tsp->smk_rules);
+		tmay = smk_access_entry(mkp->smk_known, okp->smk_known,
+					&tsp->smk_rules);
 		if (tmay != -ENOENT)
 			mmay &= tmay;
 
@@ -1570,7 +1574,7 @@ static int smack_file_set_fowner(struct file *file)
 {
 	struct smack_known *skp = smk_of_current();
 
-	file->f_security = skp->smk_known;
+	file->f_security = skp;
 	return 0;
 }
 
@@ -1600,15 +1604,15 @@ static int smack_file_send_sigiotask(struct task_struct *tsk,
 	file = container_of(fown, struct file, f_owner);
 
 	/* we don't log here as rc can be overriden */
-	skp = smk_find_entry(file->f_security);
-	rc = smk_access(skp, tkp->smk_known, MAY_WRITE, NULL);
-	rc = smk_bu_note("sigiotask", skp, tkp->smk_known, MAY_WRITE, rc);
+	skp = file->f_security;
+	rc = smk_access(skp, tkp, MAY_WRITE, NULL);
+	rc = smk_bu_note("sigiotask", skp, tkp, MAY_WRITE, rc);
 	if (rc != 0 && has_capability(tsk, CAP_MAC_OVERRIDE))
 		rc = 0;
 
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
 	smk_ad_setfield_u_tsk(&ad, tsk);
-	smack_log(file->f_security, tkp->smk_known, MAY_WRITE, rc, &ad);
+	smack_log(skp->smk_known, tkp->smk_known, MAY_WRITE, rc, &ad);
 	return rc;
 }
 
@@ -1805,7 +1809,7 @@ static int smack_kernel_create_files_as(struct cred *new,
 	struct inode_smack *isp = inode->i_security;
 	struct task_smack *tsp = new->security;
 
-	tsp->smk_forked = smk_find_entry(isp->smk_inode);
+	tsp->smk_forked = isp->smk_inode;
 	tsp->smk_task = tsp->smk_forked;
 	return 0;
 }
@@ -1827,7 +1831,7 @@ static int smk_curacc_on_task(struct task_struct *p, int access,
 
 	smk_ad_init(&ad, caller, LSM_AUDIT_DATA_TASK);
 	smk_ad_setfield_u_tsk(&ad, p);
-	rc = smk_curacc(skp->smk_known, access, &ad);
+	rc = smk_curacc(skp, access, &ad);
 	rc = smk_bu_task(p, access, rc);
 	return rc;
 }
@@ -1992,7 +1996,7 @@ static int smack_task_kill(struct task_struct *p, struct siginfo *info,
 	 * can write the receiver.
 	 */
 	if (secid == 0) {
-		rc = smk_curacc(tkp->smk_known, MAY_WRITE, &ad);
+		rc = smk_curacc(tkp, MAY_WRITE, &ad);
 		rc = smk_bu_task(p, MAY_WRITE, rc);
 		return rc;
 	}
@@ -2002,8 +2006,8 @@ static int smack_task_kill(struct task_struct *p, struct siginfo *info,
 	 * we can't take privilege into account.
 	 */
 	skp = smack_from_secid(secid);
-	rc = smk_access(skp, tkp->smk_known, MAY_WRITE, &ad);
-	rc = smk_bu_note("USB signal", skp, tkp->smk_known, MAY_WRITE, rc);
+	rc = smk_access(skp, tkp, MAY_WRITE, &ad);
+	rc = smk_bu_note("USB signal", skp, tkp, MAY_WRITE, rc);
 	return rc;
 }
 
@@ -2038,7 +2042,7 @@ static void smack_task_to_inode(struct task_struct *p, struct inode *inode)
 	struct inode_smack *isp = inode->i_security;
 	struct smack_known *skp = smk_of_task(task_security(p));
 
-	isp->smk_inode = skp->smk_known;
+	isp->smk_inode = skp;
 }
 
 /*
@@ -2096,7 +2100,7 @@ static void smack_sk_free_security(struct sock *sk)
 *
 * Returns the label of the far end or NULL if it's not special.
 */
-static char *smack_host_label(struct sockaddr_in *sip)
+static struct smack_known *smack_host_label(struct sockaddr_in *sip)
 {
 	struct smk_netlbladdr *snp;
 	struct in_addr *siap = &sip->sin_addr;
@@ -2113,7 +2117,7 @@ static char *smack_host_label(struct sockaddr_in *sip)
 		if ((&snp->smk_host.sin_addr)->s_addr ==
 		    (siap->s_addr & (&snp->smk_mask)->s_addr)) {
 			/* we have found the special CIPSO option */
-			if (snp->smk_label == smack_cipso_option)
+			if (snp->smk_label == &smack_cipso_option)
 				return NULL;
 			return snp->smk_label;
 		}
@@ -2178,13 +2182,13 @@ static int smack_netlabel_send(struct sock *sk, struct sockaddr_in *sap)
 	struct smack_known *skp;
 	int rc;
 	int sk_lbl;
-	char *hostsp;
+	struct smack_known *hkp;
 	struct socket_smack *ssp = sk->sk_security;
 	struct smk_audit_info ad;
 
 	rcu_read_lock();
-	hostsp = smack_host_label(sap);
-	if (hostsp != NULL) {
+	hkp = smack_host_label(sap);
+	if (hkp != NULL) {
 #ifdef CONFIG_AUDIT
 		struct lsm_network_audit net;
 
@@ -2195,8 +2199,8 @@ static int smack_netlabel_send(struct sock *sk, struct sockaddr_in *sap)
 #endif
 		sk_lbl = SMACK_UNLABELED_SOCKET;
 		skp = ssp->smk_out;
-		rc = smk_access(skp, hostsp, MAY_WRITE, &ad);
-		rc = smk_bu_note("IPv4 host check", skp, hostsp, MAY_WRITE, rc);
+		rc = smk_access(skp, hkp, MAY_WRITE, &ad);
+		rc = smk_bu_note("IPv4 host check", skp, hkp, MAY_WRITE, rc);
 	} else {
 		sk_lbl = SMACK_CIPSO_SOCKET;
 		rc = 0;
@@ -2297,7 +2301,7 @@ static int smk_ipv6_port_check(struct sock *sk, struct sockaddr_in6 *address,
 	struct socket_smack *ssp = sk->sk_security;
 	struct smack_known *skp;
 	unsigned short port = 0;
-	char *object;
+	struct smack_known *object;
 	struct smk_audit_info ad;
 	int rc;
 #ifdef CONFIG_AUDIT
@@ -2306,10 +2310,10 @@ static int smk_ipv6_port_check(struct sock *sk, struct sockaddr_in6 *address,
 
 	if (act == SMK_RECEIVING) {
 		skp = smack_net_ambient;
-		object = ssp->smk_in->smk_known;
+		object = ssp->smk_in;
 	} else {
 		skp = ssp->smk_out;
-		object = smack_net_ambient->smk_known;
+		object = smack_net_ambient;
 	}
 
 	/*
@@ -2336,7 +2340,7 @@ static int smk_ipv6_port_check(struct sock *sk, struct sockaddr_in6 *address,
 	list_for_each_entry(spp, &smk_ipv6_port_list, list) {
 		if (spp->smk_port != port)
 			continue;
-		object = spp->smk_in->smk_known;
+		object = spp->smk_in;
 		if (act == SMK_CONNECTING)
 			ssp->smk_packet = spp->smk_out;
 		break;
@@ -2387,7 +2391,7 @@ static int smack_inode_setsecurity(struct inode *inode, const char *name,
 		return -EINVAL;
 
 	if (strcmp(name, XATTR_SMACK_SUFFIX) == 0) {
-		nsp->smk_inode = skp->smk_known;
+		nsp->smk_inode = skp;
 		nsp->smk_flags |= SMK_INODE_INSTANT;
 		return 0;
 	}
@@ -2529,7 +2533,7 @@ static int smack_msg_msg_alloc_security(struct msg_msg *msg)
 {
 	struct smack_known *skp = smk_of_current();
 
-	msg->security = skp->smk_known;
+	msg->security = skp;
 	return 0;
 }
 
@@ -2550,9 +2554,9 @@ static void smack_msg_msg_free_security(struct msg_msg *msg)
  *
  * Returns a pointer to the smack value
  */
-static char *smack_of_shm(struct shmid_kernel *shp)
+static struct smack_known *smack_of_shm(struct shmid_kernel *shp)
 {
-	return (char *)shp->shm_perm.security;
+	return (struct smack_known *)shp->shm_perm.security;
 }
 
 /**
@@ -2566,7 +2570,7 @@ static int smack_shm_alloc_security(struct shmid_kernel *shp)
 	struct kern_ipc_perm *isp = &shp->shm_perm;
 	struct smack_known *skp = smk_of_current();
 
-	isp->security = skp->smk_known;
+	isp->security = skp;
 	return 0;
 }
 
@@ -2592,7 +2596,7 @@ static void smack_shm_free_security(struct shmid_kernel *shp)
  */
 static int smk_curacc_shm(struct shmid_kernel *shp, int access)
 {
-	char *ssp = smack_of_shm(shp);
+	struct smack_known *ssp = smack_of_shm(shp);
 	struct smk_audit_info ad;
 	int rc;
 
@@ -2677,9 +2681,9 @@ static int smack_shm_shmat(struct shmid_kernel *shp, char __user *shmaddr,
  *
  * Returns a pointer to the smack value
  */
-static char *smack_of_sem(struct sem_array *sma)
+static struct smack_known *smack_of_sem(struct sem_array *sma)
 {
-	return (char *)sma->sem_perm.security;
+	return (struct smack_known *)sma->sem_perm.security;
 }
 
 /**
@@ -2693,7 +2697,7 @@ static int smack_sem_alloc_security(struct sem_array *sma)
 	struct kern_ipc_perm *isp = &sma->sem_perm;
 	struct smack_known *skp = smk_of_current();
 
-	isp->security = skp->smk_known;
+	isp->security = skp;
 	return 0;
 }
 
@@ -2719,7 +2723,7 @@ static void smack_sem_free_security(struct sem_array *sma)
  */
 static int smk_curacc_sem(struct sem_array *sma, int access)
 {
-	char *ssp = smack_of_sem(sma);
+	struct smack_known *ssp = smack_of_sem(sma);
 	struct smk_audit_info ad;
 	int rc;
 
@@ -2815,7 +2819,7 @@ static int smack_msg_queue_alloc_security(struct msg_queue *msq)
 	struct kern_ipc_perm *kisp = &msq->q_perm;
 	struct smack_known *skp = smk_of_current();
 
-	kisp->security = skp->smk_known;
+	kisp->security = skp;
 	return 0;
 }
 
@@ -2836,11 +2840,11 @@ static void smack_msg_queue_free_security(struct msg_queue *msq)
  * smack_of_msq - the smack pointer for the msq
  * @msq: the object
  *
- * Returns a pointer to the smack value
+ * Returns a pointer to the smack label entry
  */
-static char *smack_of_msq(struct msg_queue *msq)
+static struct smack_known *smack_of_msq(struct msg_queue *msq)
 {
-	return (char *)msq->q_perm.security;
+	return (struct smack_known *)msq->q_perm.security;
 }
 
 /**
@@ -2852,7 +2856,7 @@ static char *smack_of_msq(struct msg_queue *msq)
  */
 static int smk_curacc_msq(struct msg_queue *msq, int access)
 {
-	char *msp = smack_of_msq(msq);
+	struct smack_known *msp = smack_of_msq(msq);
 	struct smk_audit_info ad;
 	int rc;
 
@@ -2955,7 +2959,7 @@ static int smack_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg,
  */
 static int smack_ipc_permission(struct kern_ipc_perm *ipp, short flag)
 {
-	char *isp = ipp->security;
+	struct smack_known *iskp = ipp->security;
 	int may = smack_flags_to_may(flag);
 	struct smk_audit_info ad;
 	int rc;
@@ -2964,8 +2968,8 @@ static int smack_ipc_permission(struct kern_ipc_perm *ipp, short flag)
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_IPC);
 	ad.a.u.ipc_id = ipp->id;
 #endif
-	rc = smk_curacc(isp, may, &ad);
-	rc = smk_bu_current("svipc", isp, may, rc);
+	rc = smk_curacc(iskp, may, &ad);
+	rc = smk_bu_current("svipc", iskp, may, rc);
 	return rc;
 }
 
@@ -2976,9 +2980,9 @@ static int smack_ipc_permission(struct kern_ipc_perm *ipp, short flag)
  */
 static void smack_ipc_getsecid(struct kern_ipc_perm *ipp, u32 *secid)
 {
-	char *smack = ipp->security;
+	struct smack_known *iskp = ipp->security;
 
-	*secid = smack_to_secid(smack);
+	*secid = iskp->smk_secid;
 }
 
 /**
@@ -2995,7 +2999,7 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
 	struct inode_smack *isp;
 	struct smack_known *skp;
 	struct smack_known *ckp = smk_of_current();
-	char *final;
+	struct smack_known *final;
 	char trattr[TRANS_TRUE_SIZE];
 	int transflag = 0;
 	int rc;
@@ -3035,8 +3039,8 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
 			 * so there's no opportunity to set the mount
 			 * options.
 			 */
-			sbsp->smk_root = smack_known_star.smk_known;
-			sbsp->smk_default = smack_known_star.smk_known;
+			sbsp->smk_root = &smack_known_star;
+			sbsp->smk_default = &smack_known_star;
 		}
 		isp->smk_inode = sbsp->smk_root;
 		isp->smk_flags |= SMK_INODE_INSTANT;
@@ -3066,7 +3070,7 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
 		 *
 		 * Cgroupfs is special
 		 */
-		final = smack_known_star.smk_known;
+		final = &smack_known_star;
 		break;
 	case DEVPTS_SUPER_MAGIC:
 		/*
@@ -3074,7 +3078,7 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
 		 * Programs that change smack have to treat the
 		 * pty with respect.
 		 */
-		final = ckp->smk_known;
+		final = ckp;
 		break;
 	case PROC_SUPER_MAGIC:
 		/*
@@ -3088,7 +3092,7 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
 		 * but watch out, because they're volitile,
 		 * getting recreated on every reboot.
 		 */
-		final = smack_known_star.smk_known;
+		final = &smack_known_star;
 		/*
 		 * No break.
 		 *
@@ -3107,7 +3111,7 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
 		 * UNIX domain sockets use lower level socket data.
 		 */
 		if (S_ISSOCK(inode->i_mode)) {
-			final = smack_known_star.smk_known;
+			final = &smack_known_star;
 			break;
 		}
 		/*
@@ -3124,7 +3128,7 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
 		dp = dget(opt_dentry);
 		skp = smk_fetch(XATTR_NAME_SMACK, inode, dp);
 		if (skp != NULL)
-			final = skp->smk_known;
+			final = skp;
 
 		/*
 		 * Transmuting directory
@@ -3173,7 +3177,7 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
 	}
 
 	if (final == NULL)
-		isp->smk_inode = ckp->smk_known;
+		isp->smk_inode = ckp;
 	else
 		isp->smk_inode = final;
 
@@ -3298,12 +3302,11 @@ static int smack_unix_stream_connect(struct sock *sock,
 		smk_ad_init_net(&ad, __func__, LSM_AUDIT_DATA_NET, &net);
 		smk_ad_setfield_u_net_sk(&ad, other);
 #endif
-		rc = smk_access(skp, okp->smk_known, MAY_WRITE, &ad);
-		rc = smk_bu_note("UDS connect", skp, okp->smk_known,
-					MAY_WRITE, rc);
+		rc = smk_access(skp, okp, MAY_WRITE, &ad);
+		rc = smk_bu_note("UDS connect", skp, okp, MAY_WRITE, rc);
 		if (rc == 0) {
-			rc = smk_access(okp, skp->smk_known, MAY_WRITE, NULL);
-			rc = smk_bu_note("UDS connect", okp, skp->smk_known,
+			rc = smk_access(okp, skp, MAY_WRITE, NULL);
+			rc = smk_bu_note("UDS connect", okp, skp,
 						MAY_WRITE, rc);
 		}
 	}
@@ -3331,7 +3334,6 @@ static int smack_unix_may_send(struct socket *sock, struct socket *other)
 {
 	struct socket_smack *ssp = sock->sk->sk_security;
 	struct socket_smack *osp = other->sk->sk_security;
-	struct smack_known *skp;
 	struct smk_audit_info ad;
 	int rc;
 
@@ -3345,10 +3347,8 @@ static int smack_unix_may_send(struct socket *sock, struct socket *other)
 	if (smack_privileged(CAP_MAC_OVERRIDE))
 		return 0;
 
-	skp = ssp->smk_out;
-	rc = smk_access(skp, osp->smk_in->smk_known, MAY_WRITE, &ad);
-	rc = smk_bu_note("UDS send", skp, osp->smk_in->smk_known,
-				MAY_WRITE, rc);
+	rc = smk_access(ssp->smk_out, osp->smk_in, MAY_WRITE, &ad);
+	rc = smk_bu_note("UDS send", ssp->smk_out, osp->smk_in, MAY_WRITE, rc);
 	return rc;
 }
 
@@ -3563,8 +3563,8 @@ static int smack_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 		 * This is the simplist possible security model
 		 * for networking.
 		 */
-		rc = smk_access(skp, ssp->smk_in->smk_known, MAY_WRITE, &ad);
-		rc = smk_bu_note("IPv4 delivery", skp, ssp->smk_in->smk_known,
+		rc = smk_access(skp, ssp->smk_in, MAY_WRITE, &ad);
+		rc = smk_bu_note("IPv4 delivery", skp, ssp->smk_in,
 					MAY_WRITE, rc);
 		if (rc != 0)
 			netlbl_skbuff_err(skb, rc, 0);
@@ -3708,7 +3708,7 @@ static int smack_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 	struct netlbl_lsm_secattr secattr;
 	struct sockaddr_in addr;
 	struct iphdr *hdr;
-	char *hsp;
+	struct smack_known *hskp;
 	int rc;
 	struct smk_audit_info ad;
 #ifdef CONFIG_AUDIT
@@ -3745,9 +3745,8 @@ static int smack_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 	 * Receiving a packet requires that the other end be able to write
 	 * here. Read access is not required.
 	 */
-	rc = smk_access(skp, ssp->smk_in->smk_known, MAY_WRITE, &ad);
-	rc = smk_bu_note("IPv4 connect", skp, ssp->smk_in->smk_known,
-				MAY_WRITE, rc);
+	rc = smk_access(skp, ssp->smk_in, MAY_WRITE, &ad);
+	rc = smk_bu_note("IPv4 connect", skp, ssp->smk_in, MAY_WRITE, rc);
 	if (rc != 0)
 		return rc;
 
@@ -3765,10 +3764,10 @@ static int smack_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 	hdr = ip_hdr(skb);
 	addr.sin_addr.s_addr = hdr->saddr;
 	rcu_read_lock();
-	hsp = smack_host_label(&addr);
+	hskp = smack_host_label(&addr);
 	rcu_read_unlock();
 
-	if (hsp == NULL)
+	if (hskp == NULL)
 		rc = netlbl_req_setattr(req, &skp->smk_netlabel);
 	else
 		netlbl_req_delattr(req);
@@ -3820,7 +3819,7 @@ static int smack_key_alloc(struct key *key, const struct cred *cred,
 {
 	struct smack_known *skp = smk_of_task(cred->security);
 
-	key->security = skp->smk_known;
+	key->security = skp;
 	return 0;
 }
 
@@ -3909,6 +3908,7 @@ static int smack_key_permission(key_ref_t key_ref,
  */
 static int smack_audit_rule_init(u32 field, u32 op, char *rulestr, void **vrule)
 {
+	struct smack_known *skp;
 	char **rule = (char **)vrule;
 	*rule = NULL;
 
@@ -3918,7 +3918,9 @@ static int smack_audit_rule_init(u32 field, u32 op, char *rulestr, void **vrule)
 	if (op != Audit_equal && op != Audit_not_equal)
 		return -EINVAL;
 
-	*rule = smk_import(rulestr, 0);
+	skp = smk_import_entry(rulestr, 0);
+	if (skp)
+		*rule = skp->smk_known;
 
 	return 0;
 }
@@ -4037,7 +4039,12 @@ static int smack_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
  */
 static int smack_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid)
 {
-	*secid = smack_to_secid(secdata);
+	struct smack_known *skp = smk_find_entry(secdata);
+
+	if (skp)
+		*secid = skp->smk_secid;
+	else
+		*secid = 0;
 	return 0;
 }
 
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 49a2248..bce4e8f 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -131,14 +131,17 @@ LIST_HEAD(smack_rule_list);
 
 struct smack_parsed_rule {
 	struct smack_known	*smk_subject;
-	char			*smk_object;
+	struct smack_known	*smk_object;
 	int			smk_access1;
 	int			smk_access2;
 };
 
 static int smk_cipso_doi_value = SMACK_CIPSO_DOI_DEFAULT;
 
-const char *smack_cipso_option = SMACK_CIPSO_OPTION;
+struct smack_known smack_cipso_option = {
+	.smk_known	= SMACK_CIPSO_OPTION,
+	.smk_secid	= 0,
+};
 
 /*
  * Values for parsing cipso rules
@@ -339,7 +342,7 @@ static int smk_fill_rule(const char *subject, const char *object,
 		if (rule->smk_subject == NULL)
 			return -EINVAL;
 
-		rule->smk_object = smk_import(object, len);
+		rule->smk_object = smk_import_entry(object, len);
 		if (rule->smk_object == NULL)
 			return -EINVAL;
 	} else {
@@ -359,7 +362,7 @@ static int smk_fill_rule(const char *subject, const char *object,
 		kfree(cp);
 		if (skp == NULL)
 			return -ENOENT;
-		rule->smk_object = skp->smk_known;
+		rule->smk_object = skp;
 	}
 
 	rule->smk_access1 = smk_perm_from_str(access1);
@@ -598,13 +601,15 @@ static void smk_rule_show(struct seq_file *s, struct smack_rule *srp, int max)
 	 * anything you read back.
 	 */
 	if (strlen(srp->smk_subject->smk_known) >= max ||
-	    strlen(srp->smk_object) >= max)
+	    strlen(srp->smk_object->smk_known) >= max)
 		return;
 
 	if (srp->smk_access == 0)
 		return;
 
-	seq_printf(s, "%s %s", srp->smk_subject->smk_known, srp->smk_object);
+	seq_printf(s, "%s %s",
+		   srp->smk_subject->smk_known,
+		   srp->smk_object->smk_known);
 
 	seq_putc(s, ' ');
 
@@ -1073,7 +1078,7 @@ static int netlbladdr_seq_show(struct seq_file *s, void *v)
 	for (maskn = 0; temp_mask; temp_mask <<= 1, maskn++);
 
 	seq_printf(s, "%u.%u.%u.%u/%d %s\n",
-		hp[0], hp[1], hp[2], hp[3], maskn, skp->smk_label);
+		hp[0], hp[1], hp[2], hp[3], maskn, skp->smk_label->smk_known);
 
 	return 0;
 }
@@ -1153,10 +1158,10 @@ static void smk_netlbladdr_insert(struct smk_netlbladdr *new)
 static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
-	struct smk_netlbladdr *skp;
+	struct smk_netlbladdr *snp;
 	struct sockaddr_in newname;
 	char *smack;
-	char *sp;
+	struct smack_known *skp;
 	char *data;
 	char *host = (char *)&newname.sin_addr.s_addr;
 	int rc;
@@ -1219,15 +1224,15 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
 	 * If smack begins with '-', it is an option, don't import it
 	 */
 	if (smack[0] != '-') {
-		sp = smk_import(smack, 0);
-		if (sp == NULL) {
+		skp = smk_import_entry(smack, 0);
+		if (skp == NULL) {
 			rc = -EINVAL;
 			goto free_out;
 		}
 	} else {
 		/* check known options */
-		if (strcmp(smack, smack_cipso_option) == 0)
-			sp = (char *)smack_cipso_option;
+		if (strcmp(smack, smack_cipso_option.smk_known) == 0)
+			skp = &smack_cipso_option;
 		else {
 			rc = -EINVAL;
 			goto free_out;
@@ -1250,9 +1255,9 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
 	nsa = newname.sin_addr.s_addr;
 	/* try to find if the prefix is already in the list */
 	found = 0;
-	list_for_each_entry_rcu(skp, &smk_netlbladdr_list, list) {
-		if (skp->smk_host.sin_addr.s_addr == nsa &&
-		    skp->smk_mask.s_addr == mask.s_addr) {
+	list_for_each_entry_rcu(snp, &smk_netlbladdr_list, list) {
+		if (snp->smk_host.sin_addr.s_addr == nsa &&
+		    snp->smk_mask.s_addr == mask.s_addr) {
 			found = 1;
 			break;
 		}
@@ -1260,26 +1265,26 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
 	smk_netlabel_audit_set(&audit_info);
 
 	if (found == 0) {
-		skp = kzalloc(sizeof(*skp), GFP_KERNEL);
-		if (skp == NULL)
+		snp = kzalloc(sizeof(*snp), GFP_KERNEL);
+		if (snp == NULL)
 			rc = -ENOMEM;
 		else {
 			rc = 0;
-			skp->smk_host.sin_addr.s_addr = newname.sin_addr.s_addr;
-			skp->smk_mask.s_addr = mask.s_addr;
-			skp->smk_label = sp;
-			smk_netlbladdr_insert(skp);
+			snp->smk_host.sin_addr.s_addr = newname.sin_addr.s_addr;
+			snp->smk_mask.s_addr = mask.s_addr;
+			snp->smk_label = skp;
+			smk_netlbladdr_insert(snp);
 		}
 	} else {
 		/* we delete the unlabeled entry, only if the previous label
 		 * wasn't the special CIPSO option */
-		if (skp->smk_label != smack_cipso_option)
+		if (snp->smk_label != &smack_cipso_option)
 			rc = netlbl_cfg_unlbl_static_del(&init_net, NULL,
-					&skp->smk_host.sin_addr, &skp->smk_mask,
+					&snp->smk_host.sin_addr, &snp->smk_mask,
 					PF_INET, &audit_info);
 		else
 			rc = 0;
-		skp->smk_label = sp;
+		snp->smk_label = skp;
 	}
 
 	/*
@@ -1287,10 +1292,10 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
 	 * this host so that incoming packets get labeled.
 	 * but only if we didn't get the special CIPSO option
 	 */
-	if (rc == 0 && sp != smack_cipso_option)
+	if (rc == 0 && skp != &smack_cipso_option)
 		rc = netlbl_cfg_unlbl_static_add(&init_net, NULL,
-			&skp->smk_host.sin_addr, &skp->smk_mask, PF_INET,
-			smack_to_secid(skp->smk_label), &audit_info);
+			&snp->smk_host.sin_addr, &snp->smk_mask, PF_INET,
+			snp->smk_label->smk_secid, &audit_info);
 
 	if (rc == 0)
 		rc = count;
-- 
1.9.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117Ab3DWQER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:04:17 -0400
Received: from nm29.access.bullet.mail.sp2.yahoo.com ([98.139.44.156]:37337
	"EHLO nm29.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756972Ab3DWQEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:04:13 -0400
X-Yahoo-Newman-Id: 695607.62066.bm@smtp105.biz.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: B80Nq7AVM1kL2ooFeNIDtMX5HFFcm75n0Q6BiTRHDROrGEf
 ZO_jPnCuNQLxbaxxNFVMBsxh_z8lPXzy3QyRPK5nb7Nj5Q_g90PYOSA.JGIJ
 gFOMuM0_.e1o_rUohabvLn4hgoAZ.zqG3yDl98.zKKRed1WyPFFzWycQIcAg
 eCD9T.5RRgXRQ8XjIqcDdJPUQ9ZfUyTg7WB6niK_D3E1rcfuYDDwmXC5mKj4
 32mY7XG8CY5FB2jjEjH1GXaC8npNhE3Uy_0BXTIO.VOneQigiqPDxtw76uNc
 klwXHDH.YULwOfblLpsqZ4m369PzHI9Y.k1SibFDY67k_AafMyIxkGswgdwC
 zH97ohiKsjqtA1JTzwY1gDx9iYL7wqvXGXoHHfKnjglzoJbUqr07.sKgbf2u
 7.whWj5SdmuVpXeo3A40YFLvIDuTw9vuFsa08M0kInlLGuqUBqfQukwzyf3U
 oog--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with plain)
        by smtp105.biz.mail.ne1.yahoo.com with SMTP; 23 Apr 2013 09:04:10 -0700 PDT
Message-ID: <5176B0FB.6080708@schaufler-ca.com>
Date: Tue, 23 Apr 2013 09:04:11 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>
CC: John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH v13 1/9] LSM: Security blob abstraction
References: <5176ABB7.5080300@schaufler-ca.com>
In-Reply-To: <5176ABB7.5080300@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH v13 1/9] LSM: Security blob abstraction

Change the way that Linux security modules access security
blobs in support of multiple concurrent LSMs. Replace uses
of the task security field, the inode i_security field and
similar blob pointers with calls to trivial functions that
provide the pointers. In patch 8 of 9 these functions change
to provide the pointer for a specific LSM.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---
 include/linux/lsm.h                 |  150 ++++++++++++++++
 security/apparmor/context.c         |   10 +-
 security/apparmor/domain.c          |    8 +-
 security/apparmor/include/context.h |   13 +-
 security/apparmor/lsm.c             |   36 ++--
 security/selinux/hooks.c            |  332 ++++++++++++++++++++---------------
 security/selinux/include/objsec.h   |    2 +
 security/selinux/include/xfrm.h     |    2 +-
 security/selinux/netlabel.c         |   13 +-
 security/selinux/selinuxfs.c        |    6 +-
 security/selinux/xfrm.c             |    9 +-
 security/smack/smack.h              |   15 +-
 security/smack/smack_access.c       |    2 +-
 security/smack/smack_lsm.c          |  322 ++++++++++++++++-----------------
 security/smack/smackfs.c            |   20 +--
 security/tomoyo/common.h            |    6 +-
 security/tomoyo/domain.c            |    2 +-
 security/tomoyo/securityfs_if.c     |    9 +-
 security/tomoyo/tomoyo.c            |   41 +++--
 19 files changed, 618 insertions(+), 380 deletions(-)

diff --git a/include/linux/lsm.h b/include/linux/lsm.h
new file mode 100644
index 0000000..7c93865
--- /dev/null
+++ b/include/linux/lsm.h
@@ -0,0 +1,150 @@
+/*
+ *
+ * Copyright (C) 2012 Casey Schaufler <casey@schaufler-ca.com>
+ * Copyright (C) 2012 Intel Corporation
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License as published by
+ *	the Free Software Foundation, version 2.
+ *
+ * Author:
+ *	Casey Schaufler <casey@schaufler-ca.com>
+ *
+ * Abstraction layer for LSM security blobs.
+ * This is pointless by itself, but necessary for multiple concurrent
+ * modules support. Multiple concurrent module support is also refered
+ * to as module stacking.
+ *
+ */
+#ifndef _LINUX_LSM_H
+#define _LINUX_LSM_H
+
+#include <linux/cred.h>
+#include <linux/fs.h>
+#include <linux/msg.h>
+#include <linux/key.h>
+#include <net/sock.h>
+#include <linux/security.h>
+
+/*
+ * Trivial implementation for the one-LSM-at-a-time case
+ */
+static inline void *lsm_get_blob(const void *bp, const int lsm)
+{
+	return (void *)bp;
+}
+
+/*
+ * Trivial implementation for the one-LSM-at-a-time case
+ */
+static inline void lsm_set_blob(void **vpp, void *value, const int lsm)
+{
+	*vpp = value;
+}
+
+static inline void *lsm_get_cred(const struct cred *cred,
+					const struct security_operations *sop)
+{
+	return lsm_get_blob(cred->security, 0);
+}
+
+static inline void lsm_set_cred(struct cred *cred, void *value,
+					const struct security_operations *sop)
+{
+	lsm_set_blob(&cred->security, value, 0);
+}
+
+static inline int lsm_set_init_cred(struct cred *cred, void *value,
+					const struct security_operations *sop)
+{
+	cred->security = value;
+	return 0;
+}
+
+static inline void *lsm_get_file(const struct file *file,
+					const struct security_operations *sop)
+{
+	return lsm_get_blob(file->f_security, 0);
+}
+
+static inline void lsm_set_file(struct file *file, void *value,
+					const struct security_operations *sop)
+{
+	lsm_set_blob(&file->f_security, value, 0);
+}
+
+static inline void *lsm_get_inode(const struct inode *inode,
+					const struct security_operations *sop)
+{
+	return lsm_get_blob(inode->i_security, 0);
+}
+
+static inline void lsm_set_inode(struct inode *inode, void *value,
+					const struct security_operations *sop)
+{
+	lsm_set_blob(&inode->i_security, value, 0);
+}
+
+static inline void *lsm_get_super(const struct super_block *super,
+					const struct security_operations *sop)
+{
+	return lsm_get_blob(super->s_security, 0);
+}
+
+static inline void lsm_set_super(struct super_block *super, void *value,
+					const struct security_operations *sop)
+{
+	lsm_set_blob(&super->s_security, value, 0);
+}
+
+static inline void *lsm_get_ipc(const struct kern_ipc_perm *ipc,
+					const struct security_operations *sop)
+{
+	return lsm_get_blob(ipc->security, 0);
+}
+
+static inline void lsm_set_ipc(struct kern_ipc_perm *ipc, void *value,
+					const struct security_operations *sop)
+{
+	lsm_set_blob(&ipc->security, value, 0);
+}
+
+static inline void *lsm_get_msg(const struct msg_msg *msg,
+					const struct security_operations *sop)
+{
+	return lsm_get_blob(msg->security, 0);
+}
+
+static inline void lsm_set_msg(struct msg_msg *msg, void *value,
+					const struct security_operations *sop)
+{
+	lsm_set_blob(&msg->security, value, 0);
+}
+
+#ifdef CONFIG_KEYS
+static inline void *lsm_get_key(const struct key *key,
+					const struct security_operations *sop)
+{
+	return lsm_get_blob(key->security, 0);
+}
+
+static inline void lsm_set_key(struct key *key, void *value,
+					const struct security_operations *sop)
+{
+	lsm_set_blob(&key->security, value, 0);
+}
+#endif
+
+static inline void *lsm_get_sock(const struct sock *sock,
+					const struct security_operations *sop)
+{
+	return lsm_get_blob(sock->sk_security, 0);
+}
+
+static inline void lsm_set_sock(struct sock *sock, void *value,
+					const struct security_operations *sop)
+{
+	lsm_set_blob(&sock->sk_security, value, 0);
+}
+
+#endif /* ! _LINUX_LSM_H */
diff --git a/security/apparmor/context.c b/security/apparmor/context.c
index 8a9b502..3d9e460 100644
--- a/security/apparmor/context.c
+++ b/security/apparmor/context.c
@@ -76,7 +76,7 @@ void aa_dup_task_context(struct aa_task_cxt *new, const struct aa_task_cxt *old)
  */
 int aa_replace_current_profile(struct aa_profile *profile)
 {
-	struct aa_task_cxt *cxt = current_cred()->security;
+	struct aa_task_cxt *cxt = lsm_get_cred(current_cred(), &apparmor_ops);
 	struct cred *new;
 	BUG_ON(!profile);
 
@@ -87,7 +87,7 @@ int aa_replace_current_profile(struct aa_profile *profile)
 	if (!new)
 		return -ENOMEM;
 
-	cxt = new->security;
+	cxt = lsm_get_cred(new, &apparmor_ops);
 	if (unconfined(profile) || (cxt->profile->ns != profile->ns)) {
 		/* if switching to unconfined or a different profile namespace
 		 * clear out context state
@@ -123,7 +123,7 @@ int aa_set_current_onexec(struct aa_profile *profile)
 	if (!new)
 		return -ENOMEM;
 
-	cxt = new->security;
+	cxt = lsm_get_cred(new, &apparmor_ops);
 	aa_get_profile(profile);
 	aa_put_profile(cxt->onexec);
 	cxt->onexec = profile;
@@ -150,7 +150,7 @@ int aa_set_current_hat(struct aa_profile *profile, u64 token)
 		return -ENOMEM;
 	BUG_ON(!profile);
 
-	cxt = new->security;
+	cxt = lsm_get_cred(new, &apparmor_ops);
 	if (!cxt->previous) {
 		/* transfer refcount */
 		cxt->previous = cxt->profile;
@@ -187,7 +187,7 @@ int aa_restore_previous_profile(u64 token)
 	if (!new)
 		return -ENOMEM;
 
-	cxt = new->security;
+	cxt = lsm_get_cred(new, &apparmor_ops);
 	if (cxt->token != token) {
 		abort_creds(new);
 		return -EACCES;
diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index 859abda..1614111 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -360,7 +360,7 @@ int apparmor_bprm_set_creds(struct linux_binprm *bprm)
 	if (bprm->cred_prepared)
 		return 0;
 
-	cxt = bprm->cred->security;
+	cxt = lsm_get_cred(bprm->cred, &apparmor_ops);
 	BUG_ON(!cxt);
 
 	profile = aa_get_profile(aa_newest_version(cxt->profile));
@@ -557,7 +557,7 @@ int apparmor_bprm_secureexec(struct linux_binprm *bprm)
 void apparmor_bprm_committing_creds(struct linux_binprm *bprm)
 {
 	struct aa_profile *profile = __aa_current_profile();
-	struct aa_task_cxt *new_cxt = bprm->cred->security;
+	struct aa_task_cxt *new_cxt = lsm_get_cred(bprm->cred, &apparmor_ops);
 
 	/* bail out if unconfined or not changing profile */
 	if ((new_cxt->profile == profile) ||
@@ -634,7 +634,7 @@ int aa_change_hat(const char *hats[], int count, u64 token, bool permtest)
 
 	/* released below */
 	cred = get_current_cred();
-	cxt = cred->security;
+	cxt = lsm_get_cred(cred, &apparmor_ops);
 	profile = aa_cred_profile(cred);
 	previous_profile = cxt->previous;
 
@@ -770,7 +770,7 @@ int aa_change_profile(const char *ns_name, const char *hname, bool onexec,
 	}
 
 	cred = get_current_cred();
-	cxt = cred->security;
+	cxt = lsm_get_cred(cred, &apparmor_ops);
 	profile = aa_cred_profile(cred);
 
 	/*
diff --git a/security/apparmor/include/context.h b/security/apparmor/include/context.h
index a9cbee4..8484e55 100644
--- a/security/apparmor/include/context.h
+++ b/security/apparmor/include/context.h
@@ -18,6 +18,7 @@
 #include <linux/cred.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/lsm.h>
 
 #include "policy.h"
 
@@ -81,6 +82,8 @@ int aa_set_current_onexec(struct aa_profile *profile);
 int aa_set_current_hat(struct aa_profile *profile, u64 token);
 int aa_restore_previous_profile(u64 cookie);
 
+extern struct security_operations apparmor_ops;
+
 /**
  * __aa_task_is_confined - determine if @task has any confinement
  * @task: task to check confinement of  (NOT NULL)
@@ -89,7 +92,9 @@ int aa_restore_previous_profile(u64 cookie);
  */
 static inline bool __aa_task_is_confined(struct task_struct *task)
 {
-	struct aa_task_cxt *cxt = __task_cred(task)->security;
+	struct aa_task_cxt *cxt;
+
+	cxt = lsm_get_cred(__task_cred(task), &apparmor_ops);
 
 	BUG_ON(!cxt || !cxt->profile);
 	if (unconfined(aa_newest_version(cxt->profile)))
@@ -108,7 +113,7 @@ static inline bool __aa_task_is_confined(struct task_struct *task)
  */
 static inline struct aa_profile *aa_cred_profile(const struct cred *cred)
 {
-	struct aa_task_cxt *cxt = cred->security;
+	struct aa_task_cxt *cxt = lsm_get_cred(cred, &apparmor_ops);
 	BUG_ON(!cxt || !cxt->profile);
 	return aa_newest_version(cxt->profile);
 }
@@ -136,8 +141,10 @@ static inline struct aa_profile *__aa_current_profile(void)
  */
 static inline struct aa_profile *aa_current_profile(void)
 {
-	const struct aa_task_cxt *cxt = current_cred()->security;
+	const struct aa_task_cxt *cxt;
 	struct aa_profile *profile;
+
+	cxt = lsm_get_cred(current_cred(), &apparmor_ops);
 	BUG_ON(!cxt || !cxt->profile);
 
 	profile = aa_newest_version(cxt->profile);
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index b21830e..8784681 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -48,8 +48,8 @@ int apparmor_initialized __initdata;
  */
 static void apparmor_cred_free(struct cred *cred)
 {
-	aa_free_task_context(cred->security);
-	cred->security = NULL;
+	aa_free_task_context(lsm_get_cred(cred, &apparmor_ops));
+	lsm_set_cred(cred, NULL, &apparmor_ops);
 }
 
 /*
@@ -62,7 +62,7 @@ static int apparmor_cred_alloc_blank(struct cred *cred, gfp_t gfp)
 	if (!cxt)
 		return -ENOMEM;
 
-	cred->security = cxt;
+	lsm_set_cred(cred, cxt, &apparmor_ops);
 	return 0;
 }
 
@@ -77,8 +77,8 @@ static int apparmor_cred_prepare(struct cred *new, const struct cred *old,
 	if (!cxt)
 		return -ENOMEM;
 
-	aa_dup_task_context(cxt, old->security);
-	new->security = cxt;
+	aa_dup_task_context(cxt, lsm_get_cred(old, &apparmor_ops));
+	lsm_set_cred(new, cxt, &apparmor_ops);
 	return 0;
 }
 
@@ -87,8 +87,8 @@ static int apparmor_cred_prepare(struct cred *new, const struct cred *old,
  */
 static void apparmor_cred_transfer(struct cred *new, const struct cred *old)
 {
-	const struct aa_task_cxt *old_cxt = old->security;
-	struct aa_task_cxt *new_cxt = new->security;
+	const struct aa_task_cxt *old_cxt = lsm_get_cred(old, &apparmor_ops);
+	struct aa_task_cxt *new_cxt = lsm_get_cred(new, &apparmor_ops);
 
 	aa_dup_task_context(new_cxt, old_cxt);
 }
@@ -375,7 +375,7 @@ static int apparmor_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
 
 static int apparmor_file_open(struct file *file, const struct cred *cred)
 {
-	struct aa_file_cxt *fcxt = file->f_security;
+	struct aa_file_cxt *fcxt = lsm_get_file(file, &apparmor_ops);
 	struct aa_profile *profile;
 	int error = 0;
 
@@ -409,8 +409,8 @@ static int apparmor_file_open(struct file *file, const struct cred *cred)
 static int apparmor_file_alloc_security(struct file *file)
 {
 	/* freed by apparmor_file_free_security */
-	file->f_security = aa_alloc_file_context(GFP_KERNEL);
-	if (!file->f_security)
+	lsm_set_file(file, aa_alloc_file_context(GFP_KERNEL), &apparmor_ops);
+	if (!lsm_get_file(file, &apparmor_ops))
 		return -ENOMEM;
 	return 0;
 
@@ -418,14 +418,15 @@ static int apparmor_file_alloc_security(struct file *file)
 
 static void apparmor_file_free_security(struct file *file)
 {
-	struct aa_file_cxt *cxt = file->f_security;
+	struct aa_file_cxt *cxt = lsm_get_file(file, &apparmor_ops);
 
+	lsm_set_file(file, NULL, &apparmor_ops);
 	aa_free_file_context(cxt);
 }
 
 static int common_file_perm(int op, struct file *file, u32 mask)
 {
-	struct aa_file_cxt *fcxt = file->f_security;
+	struct aa_file_cxt *fcxt = lsm_get_file(file, &apparmor_ops);
 	struct aa_profile *profile, *fprofile = aa_cred_profile(file->f_cred);
 	int error = 0;
 
@@ -472,7 +473,7 @@ static int common_mmap(int op, struct file *file, unsigned long prot,
 	struct dentry *dentry;
 	int mask = 0;
 
-	if (!file || !file->f_security)
+	if (!file || !lsm_get_file(file, &apparmor_ops))
 		return 0;
 
 	if (prot & PROT_READ)
@@ -510,7 +511,7 @@ static int apparmor_getprocattr(struct task_struct *task, char *name,
 	struct aa_profile *profile;
 	/* released below */
 	const struct cred *cred = get_task_cred(task);
-	struct aa_task_cxt *cxt = cred->security;
+	struct aa_task_cxt *cxt = lsm_get_cred(cred, &apparmor_ops);
 	profile = aa_cred_profile(cred);
 
 	if (strcmp(name, "current") == 0)
@@ -614,7 +615,7 @@ static int apparmor_task_setrlimit(struct task_struct *task,
 	return error;
 }
 
-static struct security_operations apparmor_ops = {
+struct security_operations apparmor_ops = {
 	.name =				"apparmor",
 
 	.ptrace_access_check =		apparmor_ptrace_access_check,
@@ -878,6 +879,7 @@ static int param_set_mode(const char *val, struct kernel_param *kp)
  */
 static int __init set_init_cxt(void)
 {
+	int rc;
 	struct cred *cred = (struct cred *)current->real_cred;
 	struct aa_task_cxt *cxt;
 
@@ -886,9 +888,9 @@ static int __init set_init_cxt(void)
 		return -ENOMEM;
 
 	cxt->profile = aa_get_profile(root_ns->unconfined);
-	cred->security = cxt;
+	rc = lsm_set_init_cred(cred, cxt, &apparmor_ops);
 
-	return 0;
+	return rc;
 }
 
 static int __init apparmor_init(void)
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 7171a95..ddaec58 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -151,6 +151,7 @@ static int selinux_secmark_enabled(void)
  */
 static void cred_init_security(void)
 {
+	int rc;
 	struct cred *cred = (struct cred *) current->real_cred;
 	struct task_security_struct *tsec;
 
@@ -159,7 +160,9 @@ static void cred_init_security(void)
 		panic("SELinux:  Failed to initialize initial task.\n");
 
 	tsec->osid = tsec->sid = SECINITSID_KERNEL;
-	cred->security = tsec;
+	rc = lsm_set_init_cred(cred, tsec, &selinux_ops);
+	if (rc)
+		panic("SELinux:  Failed to initialize initial task.\n");
 }
 
 /*
@@ -169,7 +172,7 @@ static inline u32 cred_sid(const struct cred *cred)
 {
 	const struct task_security_struct *tsec;
 
-	tsec = cred->security;
+	tsec = lsm_get_cred(cred, &selinux_ops);
 	return tsec->sid;
 }
 
@@ -191,8 +194,9 @@ static inline u32 task_sid(const struct task_struct *task)
  */
 static inline u32 current_sid(void)
 {
-	const struct task_security_struct *tsec = current_security();
+	const struct task_security_struct *tsec;
 
+	tsec = lsm_get_cred(current_cred(), &selinux_ops);
 	return tsec->sid;
 }
 
@@ -213,22 +217,23 @@ static int inode_alloc_security(struct inode *inode)
 	isec->sid = SECINITSID_UNLABELED;
 	isec->sclass = SECCLASS_FILE;
 	isec->task_sid = sid;
-	inode->i_security = isec;
+	lsm_set_inode(inode, isec, &selinux_ops);
 
 	return 0;
 }
 
 static void inode_free_security(struct inode *inode)
 {
-	struct inode_security_struct *isec = inode->i_security;
-	struct superblock_security_struct *sbsec = inode->i_sb->s_security;
+	struct inode_security_struct *isec = lsm_get_inode(inode, &selinux_ops);
+	struct superblock_security_struct *sbsec =
+				lsm_get_super(inode->i_sb, &selinux_ops);
 
 	spin_lock(&sbsec->isec_lock);
 	if (!list_empty(&isec->list))
 		list_del_init(&isec->list);
 	spin_unlock(&sbsec->isec_lock);
 
-	inode->i_security = NULL;
+	lsm_set_inode(inode, NULL, &selinux_ops);
 	kmem_cache_free(sel_inode_cache, isec);
 }
 
@@ -243,15 +248,15 @@ static int file_alloc_security(struct file *file)
 
 	fsec->sid = sid;
 	fsec->fown_sid = sid;
-	file->f_security = fsec;
+	lsm_set_file(file, fsec, &selinux_ops);
 
 	return 0;
 }
 
 static void file_free_security(struct file *file)
 {
-	struct file_security_struct *fsec = file->f_security;
-	file->f_security = NULL;
+	struct file_security_struct *fsec = lsm_get_file(file, &selinux_ops);
+	lsm_set_file(file, NULL, &selinux_ops);
 	kfree(fsec);
 }
 
@@ -270,15 +275,16 @@ static int superblock_alloc_security(struct super_block *sb)
 	sbsec->sid = SECINITSID_UNLABELED;
 	sbsec->def_sid = SECINITSID_FILE;
 	sbsec->mntpoint_sid = SECINITSID_UNLABELED;
-	sb->s_security = sbsec;
+	lsm_set_super(sb, sbsec, &selinux_ops);
 
 	return 0;
 }
 
 static void superblock_free_security(struct super_block *sb)
 {
-	struct superblock_security_struct *sbsec = sb->s_security;
-	sb->s_security = NULL;
+	struct superblock_security_struct *sbsec =
+						lsm_get_super(sb, &selinux_ops);
+	lsm_set_super(sb, NULL, &selinux_ops);
 	kfree(sbsec);
 }
 
@@ -324,9 +330,10 @@ static int may_context_mount_sb_relabel(u32 sid,
 			struct superblock_security_struct *sbsec,
 			const struct cred *cred)
 {
-	const struct task_security_struct *tsec = cred->security;
+	const struct task_security_struct *tsec;
 	int rc;
 
+	tsec = lsm_get_cred(cred, &selinux_ops);
 	rc = avc_has_perm(tsec->sid, sbsec->sid, SECCLASS_FILESYSTEM,
 			  FILESYSTEM__RELABELFROM, NULL);
 	if (rc)
@@ -341,8 +348,10 @@ static int may_context_mount_inode_relabel(u32 sid,
 			struct superblock_security_struct *sbsec,
 			const struct cred *cred)
 {
-	const struct task_security_struct *tsec = cred->security;
+	const struct task_security_struct *tsec;
 	int rc;
+
+	tsec = lsm_get_cred(cred, &selinux_ops);
 	rc = avc_has_perm(tsec->sid, sbsec->sid, SECCLASS_FILESYSTEM,
 			  FILESYSTEM__RELABELFROM, NULL);
 	if (rc)
@@ -355,7 +364,8 @@ static int may_context_mount_inode_relabel(u32 sid,
 
 static int sb_finish_set_opts(struct super_block *sb)
 {
-	struct superblock_security_struct *sbsec = sb->s_security;
+	struct superblock_security_struct *sbsec =
+						lsm_get_super(sb, &selinux_ops);
 	struct dentry *root = sb->s_root;
 	struct inode *root_inode = root->d_inode;
 	int rc = 0;
@@ -445,7 +455,8 @@ static int selinux_get_mnt_opts(const struct super_block *sb,
 				struct security_mnt_opts *opts)
 {
 	int rc = 0, i;
-	struct superblock_security_struct *sbsec = sb->s_security;
+	struct superblock_security_struct *sbsec =
+						lsm_get_super(sb, &selinux_ops);
 	char *context = NULL;
 	u32 len;
 	char tmp;
@@ -505,8 +516,9 @@ static int selinux_get_mnt_opts(const struct super_block *sb,
 	}
 	if (sbsec->flags & ROOTCONTEXT_MNT) {
 		struct inode *root = sbsec->sb->s_root->d_inode;
-		struct inode_security_struct *isec = root->i_security;
+		struct inode_security_struct *isec;
 
+		isec = lsm_get_inode(root, &selinux_ops);
 		rc = security_sid_to_context(isec->sid, &context, &len);
 		if (rc)
 			goto out_free;
@@ -556,10 +568,12 @@ static int selinux_set_mnt_opts(struct super_block *sb,
 {
 	const struct cred *cred = current_cred();
 	int rc = 0, i;
-	struct superblock_security_struct *sbsec = sb->s_security;
+	struct superblock_security_struct *sbsec =
+						lsm_get_super(sb, &selinux_ops);
 	const char *name = sb->s_type->name;
 	struct inode *inode = sbsec->sb->s_root->d_inode;
-	struct inode_security_struct *root_isec = inode->i_security;
+	struct inode_security_struct *root_isec =
+					lsm_get_inode(inode, &selinux_ops);
 	u32 fscontext_sid = 0, context_sid = 0, rootcontext_sid = 0;
 	u32 defcontext_sid = 0;
 	char **mount_options = opts->mnt_opts;
@@ -754,8 +768,10 @@ out_double_mount:
 static void selinux_sb_clone_mnt_opts(const struct super_block *oldsb,
 					struct super_block *newsb)
 {
-	const struct superblock_security_struct *oldsbsec = oldsb->s_security;
-	struct superblock_security_struct *newsbsec = newsb->s_security;
+	const struct superblock_security_struct *oldsbsec =
+					lsm_get_super(oldsb, &selinux_ops);
+	struct superblock_security_struct *newsbsec =
+					lsm_get_super(newsb, &selinux_ops);
 
 	int set_fscontext =	(oldsbsec->flags & FSCONTEXT_MNT);
 	int set_context =	(oldsbsec->flags & CONTEXT_MNT);
@@ -790,16 +806,19 @@ static void selinux_sb_clone_mnt_opts(const struct super_block *oldsb,
 			newsbsec->sid = sid;
 		if (!set_rootcontext) {
 			struct inode *newinode = newsb->s_root->d_inode;
-			struct inode_security_struct *newisec = newinode->i_security;
+			struct inode_security_struct *newisec =
+					lsm_get_inode(newinode, &selinux_ops);
 			newisec->sid = sid;
 		}
 		newsbsec->mntpoint_sid = sid;
 	}
 	if (set_rootcontext) {
 		const struct inode *oldinode = oldsb->s_root->d_inode;
-		const struct inode_security_struct *oldisec = oldinode->i_security;
+		const struct inode_security_struct *oldisec =
+					lsm_get_inode(oldinode, &selinux_ops);
 		struct inode *newinode = newsb->s_root->d_inode;
-		struct inode_security_struct *newisec = newinode->i_security;
+		struct inode_security_struct *newisec =
+					lsm_get_inode(newinode, &selinux_ops);
 
 		newisec->sid = oldisec->sid;
 	}
@@ -1163,7 +1182,7 @@ static int selinux_proc_get_sid(struct dentry *dentry,
 static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dentry)
 {
 	struct superblock_security_struct *sbsec = NULL;
-	struct inode_security_struct *isec = inode->i_security;
+	struct inode_security_struct *isec = lsm_get_inode(inode, &selinux_ops);
 	u32 sid;
 	struct dentry *dentry;
 #define INITCONTEXTLEN 255
@@ -1178,7 +1197,7 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 	if (isec->initialized)
 		goto out_unlock;
 
-	sbsec = inode->i_sb->s_security;
+	sbsec = lsm_get_super(inode->i_sb, &selinux_ops);
 	if (!(sbsec->flags & SE_SBINITIALIZED)) {
 		/* Defer initialization until selinux_complete_init,
 		   after the initial policy is loaded and the security
@@ -1390,8 +1409,10 @@ static int task_has_perm(const struct task_struct *tsk1,
 	u32 sid1, sid2;
 
 	rcu_read_lock();
-	__tsec1 = __task_cred(tsk1)->security;	sid1 = __tsec1->sid;
-	__tsec2 = __task_cred(tsk2)->security;	sid2 = __tsec2->sid;
+	__tsec1 = lsm_get_cred(__task_cred(tsk1), &selinux_ops);
+	sid1 = __tsec1->sid;
+	__tsec2 = lsm_get_cred(__task_cred(tsk2), &selinux_ops);
+	sid2 = __tsec2->sid;
 	rcu_read_unlock();
 	return avc_has_perm(sid1, sid2, SECCLASS_PROCESS, perms, NULL);
 }
@@ -1481,7 +1502,7 @@ static int inode_has_perm(const struct cred *cred,
 		return 0;
 
 	sid = cred_sid(cred);
-	isec = inode->i_security;
+	isec = lsm_get_inode(inode, &selinux_ops);
 
 	return avc_has_perm_flags(sid, isec->sid, isec->sclass, perms, adp, flags);
 }
@@ -1528,7 +1549,7 @@ static int file_has_perm(const struct cred *cred,
 			 struct file *file,
 			 u32 av)
 {
-	struct file_security_struct *fsec = file->f_security;
+	struct file_security_struct *fsec = lsm_get_file(file, &selinux_ops);
 	struct inode *inode = file_inode(file);
 	struct common_audit_data ad;
 	u32 sid = cred_sid(cred);
@@ -1560,15 +1581,16 @@ static int may_create(struct inode *dir,
 		      struct dentry *dentry,
 		      u16 tclass)
 {
-	const struct task_security_struct *tsec = current_security();
+	const struct task_security_struct *tsec =
+				lsm_get_cred(current_cred(), &selinux_ops);
 	struct inode_security_struct *dsec;
 	struct superblock_security_struct *sbsec;
 	u32 sid, newsid;
 	struct common_audit_data ad;
 	int rc;
 
-	dsec = dir->i_security;
-	sbsec = dir->i_sb->s_security;
+	dsec = lsm_get_inode(dir, &selinux_ops);
+	sbsec = lsm_get_super(dir->i_sb, &selinux_ops);
 
 	sid = tsec->sid;
 	newsid = tsec->create_sid;
@@ -1623,8 +1645,8 @@ static int may_link(struct inode *dir,
 	u32 av;
 	int rc;
 
-	dsec = dir->i_security;
-	isec = dentry->d_inode->i_security;
+	dsec = lsm_get_inode(dir, &selinux_ops);
+	isec = lsm_get_inode(dentry->d_inode, &selinux_ops);
 
 	ad.type = LSM_AUDIT_DATA_DENTRY;
 	ad.u.dentry = dentry;
@@ -1667,10 +1689,10 @@ static inline int may_rename(struct inode *old_dir,
 	int old_is_dir, new_is_dir;
 	int rc;
 
-	old_dsec = old_dir->i_security;
-	old_isec = old_dentry->d_inode->i_security;
+	old_dsec = lsm_get_inode(old_dir, &selinux_ops);
+	old_isec = lsm_get_inode(old_dentry->d_inode, &selinux_ops);
 	old_is_dir = S_ISDIR(old_dentry->d_inode->i_mode);
-	new_dsec = new_dir->i_security;
+	new_dsec = lsm_get_inode(new_dir, &selinux_ops);
 
 	ad.type = LSM_AUDIT_DATA_DENTRY;
 
@@ -1698,7 +1720,7 @@ static inline int may_rename(struct inode *old_dir,
 	if (rc)
 		return rc;
 	if (new_dentry->d_inode) {
-		new_isec = new_dentry->d_inode->i_security;
+		new_isec = lsm_get_inode(new_dentry->d_inode, &selinux_ops);
 		new_is_dir = S_ISDIR(new_dentry->d_inode->i_mode);
 		rc = avc_has_perm(sid, new_isec->sid,
 				  new_isec->sclass,
@@ -1719,7 +1741,7 @@ static int superblock_has_perm(const struct cred *cred,
 	struct superblock_security_struct *sbsec;
 	u32 sid = cred_sid(cred);
 
-	sbsec = sb->s_security;
+	sbsec = lsm_get_super(sb, &selinux_ops);
 	return avc_has_perm(sid, sbsec->sid, SECCLASS_FILESYSTEM, perms, ad);
 }
 
@@ -1838,8 +1860,8 @@ static int selinux_capset(struct cred *new, const struct cred *old,
 {
 	int error;
 
-	error = cap_capset(new, old,
-				      effective, inheritable, permitted);
+	error = cap_capset(new, old, effective, inheritable, permitted);
+
 	if (error)
 		return error;
 
@@ -1970,9 +1992,9 @@ static int selinux_bprm_set_creds(struct linux_binprm *bprm)
 	if (bprm->cred_prepared)
 		return 0;
 
-	old_tsec = current_security();
-	new_tsec = bprm->cred->security;
-	isec = inode->i_security;
+	old_tsec = lsm_get_cred(current_cred(), &selinux_ops);
+	new_tsec = lsm_get_cred(bprm->cred, &selinux_ops);
+	isec = lsm_get_inode(inode, &selinux_ops);
 
 	/* Default to the current task SID. */
 	new_tsec->sid = old_tsec->sid;
@@ -2047,7 +2069,8 @@ static int selinux_bprm_set_creds(struct linux_binprm *bprm)
 			rcu_read_lock();
 			tracer = ptrace_parent(current);
 			if (likely(tracer != NULL)) {
-				sec = __task_cred(tracer)->security;
+				sec = lsm_get_cred(__task_cred(tracer),
+						   &selinux_ops);
 				ptsid = sec->sid;
 			}
 			rcu_read_unlock();
@@ -2070,7 +2093,8 @@ static int selinux_bprm_set_creds(struct linux_binprm *bprm)
 
 static int selinux_bprm_secureexec(struct linux_binprm *bprm)
 {
-	const struct task_security_struct *tsec = current_security();
+	const struct task_security_struct *tsec =
+				lsm_get_cred(current_cred(), &selinux_ops);
 	u32 sid, osid;
 	int atsecure = 0;
 
@@ -2152,7 +2176,7 @@ static void selinux_bprm_committing_creds(struct linux_binprm *bprm)
 	struct rlimit *rlim, *initrlim;
 	int rc, i;
 
-	new_tsec = bprm->cred->security;
+	new_tsec = lsm_get_cred(bprm->cred, &selinux_ops);
 	if (new_tsec->sid == new_tsec->osid)
 		return;
 
@@ -2193,7 +2217,8 @@ static void selinux_bprm_committing_creds(struct linux_binprm *bprm)
  */
 static void selinux_bprm_committed_creds(struct linux_binprm *bprm)
 {
-	const struct task_security_struct *tsec = current_security();
+	const struct task_security_struct *tsec =
+				lsm_get_cred(current_cred(), &selinux_ops);
 	struct itimerval itimer;
 	u32 osid, sid;
 	int rc, i;
@@ -2340,7 +2365,8 @@ static int selinux_sb_remount(struct super_block *sb, void *data)
 	int rc, i, *flags;
 	struct security_mnt_opts opts;
 	char *secdata, **mount_options;
-	struct superblock_security_struct *sbsec = sb->s_security;
+	struct superblock_security_struct *sbsec =
+						lsm_get_super(sb, &selinux_ops);
 
 	if (!(sbsec->flags & SE_SBINITIALIZED))
 		return 0;
@@ -2392,7 +2418,8 @@ static int selinux_sb_remount(struct super_block *sb, void *data)
 			break;
 		case ROOTCONTEXT_MNT: {
 			struct inode_security_struct *root_isec;
-			root_isec = sb->s_root->d_inode->i_security;
+			root_isec = lsm_get_inode(sb->s_root->d_inode,
+								&selinux_ops);
 
 			if (bad_option(sbsec, ROOTCONTEXT_MNT, root_isec->sid, sid))
 				goto out_bad_option;
@@ -2488,15 +2515,16 @@ static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
 				       const struct qstr *qstr, char **name,
 				       void **value, size_t *len)
 {
-	const struct task_security_struct *tsec = current_security();
+	const struct task_security_struct *tsec =
+				lsm_get_cred(current_cred(), &selinux_ops);
 	struct inode_security_struct *dsec;
 	struct superblock_security_struct *sbsec;
 	u32 sid, newsid, clen;
 	int rc;
 	char *namep = NULL, *context;
 
-	dsec = dir->i_security;
-	sbsec = dir->i_sb->s_security;
+	dsec = lsm_get_inode(dir, &selinux_ops);
+	sbsec = lsm_get_super(dir->i_sb, &selinux_ops);
 
 	sid = tsec->sid;
 	newsid = tsec->create_sid;
@@ -2520,7 +2548,8 @@ static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
 
 	/* Possibly defer initialization to selinux_complete_init. */
 	if (sbsec->flags & SE_SBINITIALIZED) {
-		struct inode_security_struct *isec = inode->i_security;
+		struct inode_security_struct *isec =
+					lsm_get_inode(inode, &selinux_ops);
 		isec->sclass = inode_mode_to_security_class(inode->i_mode);
 		isec->sid = newsid;
 		isec->initialized = 1;
@@ -2609,7 +2638,7 @@ static noinline int audit_inode_permission(struct inode *inode,
 					   unsigned flags)
 {
 	struct common_audit_data ad;
-	struct inode_security_struct *isec = inode->i_security;
+	struct inode_security_struct *isec = lsm_get_inode(inode, &selinux_ops);
 	int rc;
 
 	ad.type = LSM_AUDIT_DATA_INODE;
@@ -2649,7 +2678,7 @@ static int selinux_inode_permission(struct inode *inode, int mask)
 	perms = file_mask_to_av(inode->i_mode, mask);
 
 	sid = cred_sid(cred);
-	isec = inode->i_security;
+	isec = lsm_get_inode(inode, &selinux_ops);
 
 	rc = avc_has_perm_noaudit(sid, isec->sid, isec->sclass, perms, 0, &avd);
 	audited = avc_audit_required(perms, &avd, rc,
@@ -2724,7 +2753,7 @@ static int selinux_inode_setxattr(struct dentry *dentry, const char *name,
 				  const void *value, size_t size, int flags)
 {
 	struct inode *inode = dentry->d_inode;
-	struct inode_security_struct *isec = inode->i_security;
+	struct inode_security_struct *isec = lsm_get_inode(inode, &selinux_ops);
 	struct superblock_security_struct *sbsec;
 	struct common_audit_data ad;
 	u32 newsid, sid = current_sid();
@@ -2733,7 +2762,7 @@ static int selinux_inode_setxattr(struct dentry *dentry, const char *name,
 	if (strcmp(name, XATTR_NAME_SELINUX))
 		return selinux_inode_setotherxattr(dentry, name);
 
-	sbsec = inode->i_sb->s_security;
+	sbsec = lsm_get_super(inode->i_sb, &selinux_ops);
 	if (!(sbsec->flags & SE_SBLABELSUPP))
 		return -EOPNOTSUPP;
 
@@ -2801,7 +2830,7 @@ static void selinux_inode_post_setxattr(struct dentry *dentry, const char *name,
 					int flags)
 {
 	struct inode *inode = dentry->d_inode;
-	struct inode_security_struct *isec = inode->i_security;
+	struct inode_security_struct *isec = lsm_get_inode(inode, &selinux_ops);
 	u32 newsid;
 	int rc;
 
@@ -2856,7 +2885,7 @@ static int selinux_inode_getsecurity(const struct inode *inode, const char *name
 	u32 size;
 	int error;
 	char *context = NULL;
-	struct inode_security_struct *isec = inode->i_security;
+	struct inode_security_struct *isec = lsm_get_inode(inode, &selinux_ops);
 
 	if (strcmp(name, XATTR_SELINUX_SUFFIX))
 		return -EOPNOTSUPP;
@@ -2892,7 +2921,7 @@ out_nofree:
 static int selinux_inode_setsecurity(struct inode *inode, const char *name,
 				     const void *value, size_t size, int flags)
 {
-	struct inode_security_struct *isec = inode->i_security;
+	struct inode_security_struct *isec = lsm_get_inode(inode, &selinux_ops);
 	u32 newsid;
 	int rc;
 
@@ -2921,7 +2950,7 @@ static int selinux_inode_listsecurity(struct inode *inode, char *buffer, size_t
 
 static void selinux_inode_getsecid(const struct inode *inode, u32 *secid)
 {
-	struct inode_security_struct *isec = inode->i_security;
+	struct inode_security_struct *isec = lsm_get_inode(inode, &selinux_ops);
 	*secid = isec->sid;
 }
 
@@ -3169,7 +3198,7 @@ static int selinux_file_set_fowner(struct file *file)
 {
 	struct file_security_struct *fsec;
 
-	fsec = file->f_security;
+	fsec = lsm_get_file(file, &selinux_ops);
 	fsec->fown_sid = current_sid();
 
 	return 0;
@@ -3186,7 +3215,7 @@ static int selinux_file_send_sigiotask(struct task_struct *tsk,
 	/* struct fown_struct is never outside the context of a struct file */
 	file = container_of(fown, struct file, f_owner);
 
-	fsec = file->f_security;
+	fsec = lsm_get_file(file, &selinux_ops);
 
 	if (!signum)
 		perm = signal_to_av(SIGIO); /* as per send_sigio_to_task */
@@ -3209,8 +3238,8 @@ static int selinux_file_open(struct file *file, const struct cred *cred)
 	struct file_security_struct *fsec;
 	struct inode_security_struct *isec;
 
-	fsec = file->f_security;
-	isec = file_inode(file)->i_security;
+	fsec = lsm_get_file(file, &selinux_ops);
+	isec = lsm_get_inode(file->f_path.dentry->d_inode, &selinux_ops);
 	/*
 	 * Save inode label and policy sequence number
 	 * at open-time so that selinux_file_permission
@@ -3249,7 +3278,7 @@ static int selinux_cred_alloc_blank(struct cred *cred, gfp_t gfp)
 	if (!tsec)
 		return -ENOMEM;
 
-	cred->security = tsec;
+	lsm_set_cred(cred, tsec, &selinux_ops);
 	return 0;
 }
 
@@ -3258,14 +3287,14 @@ static int selinux_cred_alloc_blank(struct cred *cred, gfp_t gfp)
  */
 static void selinux_cred_free(struct cred *cred)
 {
-	struct task_security_struct *tsec = cred->security;
+	struct task_security_struct *tsec = lsm_get_cred(cred, &selinux_ops);
 
 	/*
 	 * cred->security == NULL if security_cred_alloc_blank() or
 	 * security_prepare_creds() returned an error.
 	 */
-	BUG_ON(cred->security && (unsigned long) cred->security < PAGE_SIZE);
-	cred->security = (void *) 0x7UL;
+	BUG_ON(tsec && (unsigned long) tsec < PAGE_SIZE);
+	lsm_set_cred(cred, NULL, &selinux_ops);
 	kfree(tsec);
 }
 
@@ -3278,13 +3307,13 @@ static int selinux_cred_prepare(struct cred *new, const struct cred *old,
 	const struct task_security_struct *old_tsec;
 	struct task_security_struct *tsec;
 
-	old_tsec = old->security;
+	old_tsec = lsm_get_cred(old, &selinux_ops);
 
 	tsec = kmemdup(old_tsec, sizeof(struct task_security_struct), gfp);
 	if (!tsec)
 		return -ENOMEM;
 
-	new->security = tsec;
+	lsm_set_cred(new, tsec, &selinux_ops);
 	return 0;
 }
 
@@ -3293,9 +3322,15 @@ static int selinux_cred_prepare(struct cred *new, const struct cred *old,
  */
 static void selinux_cred_transfer(struct cred *new, const struct cred *old)
 {
-	const struct task_security_struct *old_tsec = old->security;
-	struct task_security_struct *tsec = new->security;
+	const struct task_security_struct *old_tsec;
+	struct task_security_struct *tsec;
+
+	old_tsec = lsm_get_cred(old, &selinux_ops);
+	tsec = lsm_get_cred(new, &selinux_ops);
 
+	/*
+	 * This is a data copy, not a pointer assignment.
+	 */
 	*tsec = *old_tsec;
 }
 
@@ -3305,7 +3340,7 @@ static void selinux_cred_transfer(struct cred *new, const struct cred *old)
  */
 static int selinux_kernel_act_as(struct cred *new, u32 secid)
 {
-	struct task_security_struct *tsec = new->security;
+	struct task_security_struct *tsec = lsm_get_cred(new, &selinux_ops);
 	u32 sid = current_sid();
 	int ret;
 
@@ -3328,8 +3363,8 @@ static int selinux_kernel_act_as(struct cred *new, u32 secid)
  */
 static int selinux_kernel_create_files_as(struct cred *new, struct inode *inode)
 {
-	struct inode_security_struct *isec = inode->i_security;
-	struct task_security_struct *tsec = new->security;
+	struct inode_security_struct *isec = lsm_get_inode(inode, &selinux_ops);
+	struct task_security_struct *tsec = lsm_get_cred(new, &selinux_ops);
 	u32 sid = current_sid();
 	int ret;
 
@@ -3450,6 +3485,7 @@ static int selinux_task_kill(struct task_struct *p, struct siginfo *info,
 		perm = PROCESS__SIGNULL; /* null signal; existence test */
 	else
 		perm = signal_to_av(sig);
+
 	if (secid)
 		rc = avc_has_perm(secid, task_sid(p),
 				  SECCLASS_PROCESS, perm, NULL);
@@ -3466,7 +3502,7 @@ static int selinux_task_wait(struct task_struct *p)
 static void selinux_task_to_inode(struct task_struct *p,
 				  struct inode *inode)
 {
-	struct inode_security_struct *isec = inode->i_security;
+	struct inode_security_struct *isec = lsm_get_inode(inode, &selinux_ops);
 	u32 sid = task_sid(p);
 
 	isec->sid = sid;
@@ -3721,7 +3757,7 @@ static int socket_sockcreate_sid(const struct task_security_struct *tsec,
 
 static int sock_has_perm(struct task_struct *task, struct sock *sk, u32 perms)
 {
-	struct sk_security_struct *sksec = sk->sk_security;
+	struct sk_security_struct *sksec = lsm_get_sock(sk, &selinux_ops);
 	struct common_audit_data ad;
 	struct lsm_network_audit net = {0,};
 	u32 tsid = task_sid(task);
@@ -3739,7 +3775,8 @@ static int sock_has_perm(struct task_struct *task, struct sock *sk, u32 perms)
 static int selinux_socket_create(int family, int type,
 				 int protocol, int kern)
 {
-	const struct task_security_struct *tsec = current_security();
+	const struct task_security_struct *tsec =
+				lsm_get_cred(current_cred(), &selinux_ops);
 	u32 newsid;
 	u16 secclass;
 	int rc;
@@ -3758,8 +3795,10 @@ static int selinux_socket_create(int family, int type,
 static int selinux_socket_post_create(struct socket *sock, int family,
 				      int type, int protocol, int kern)
 {
-	const struct task_security_struct *tsec = current_security();
-	struct inode_security_struct *isec = SOCK_INODE(sock)->i_security;
+	const struct task_security_struct *tsec =
+				lsm_get_cred(current_cred(), &selinux_ops);
+	struct inode_security_struct *isec =
+				lsm_get_inode(SOCK_INODE(sock), &selinux_ops);
 	struct sk_security_struct *sksec;
 	int err = 0;
 
@@ -3776,7 +3815,7 @@ static int selinux_socket_post_create(struct socket *sock, int family,
 	isec->initialized = 1;
 
 	if (sock->sk) {
-		sksec = sock->sk->sk_security;
+		sksec = lsm_get_sock(sock->sk, &selinux_ops);
 		sksec->sid = isec->sid;
 		sksec->sclass = isec->sclass;
 		err = selinux_netlbl_socket_post_create(sock->sk, family);
@@ -3807,7 +3846,8 @@ static int selinux_socket_bind(struct socket *sock, struct sockaddr *address, in
 	family = sk->sk_family;
 	if (family == PF_INET || family == PF_INET6) {
 		char *addrp;
-		struct sk_security_struct *sksec = sk->sk_security;
+		struct sk_security_struct *sksec =
+					lsm_get_sock(sk, &selinux_ops);
 		struct common_audit_data ad;
 		struct lsm_network_audit net = {0,};
 		struct sockaddr_in *addr4 = NULL;
@@ -3891,7 +3931,7 @@ out:
 static int selinux_socket_connect(struct socket *sock, struct sockaddr *address, int addrlen)
 {
 	struct sock *sk = sock->sk;
-	struct sk_security_struct *sksec = sk->sk_security;
+	struct sk_security_struct *sksec = lsm_get_sock(sk, &selinux_ops);
 	int err;
 
 	err = sock_has_perm(current, sk, SOCKET__CONNECT);
@@ -3959,9 +3999,9 @@ static int selinux_socket_accept(struct socket *sock, struct socket *newsock)
 	if (err)
 		return err;
 
-	newisec = SOCK_INODE(newsock)->i_security;
+	newisec = lsm_get_inode(SOCK_INODE(newsock), &selinux_ops);
 
-	isec = SOCK_INODE(sock)->i_security;
+	isec = lsm_get_inode(SOCK_INODE(sock), &selinux_ops);
 	newisec->sclass = isec->sclass;
 	newisec->sid = isec->sid;
 	newisec->initialized = 1;
@@ -4017,9 +4057,12 @@ static int selinux_socket_unix_stream_connect(struct sock *sock,
 					      struct sock *other,
 					      struct sock *newsk)
 {
-	struct sk_security_struct *sksec_sock = sock->sk_security;
-	struct sk_security_struct *sksec_other = other->sk_security;
-	struct sk_security_struct *sksec_new = newsk->sk_security;
+	struct sk_security_struct *sksec_sock =
+					lsm_get_sock(sock, &selinux_ops);
+	struct sk_security_struct *sksec_other =
+					lsm_get_sock(other, &selinux_ops);
+	struct sk_security_struct *sksec_new =
+					lsm_get_sock(newsk, &selinux_ops);
 	struct common_audit_data ad;
 	struct lsm_network_audit net = {0,};
 	int err;
@@ -4050,8 +4093,8 @@ static int selinux_socket_unix_stream_connect(struct sock *sock,
 static int selinux_socket_unix_may_send(struct socket *sock,
 					struct socket *other)
 {
-	struct sk_security_struct *ssec = sock->sk->sk_security;
-	struct sk_security_struct *osec = other->sk->sk_security;
+	struct sk_security_struct *ssec = lsm_get_sock(sock->sk, &selinux_ops);
+	struct sk_security_struct *osec = lsm_get_sock(other->sk, &selinux_ops);
 	struct common_audit_data ad;
 	struct lsm_network_audit net = {0,};
 
@@ -4090,7 +4133,7 @@ static int selinux_sock_rcv_skb_compat(struct sock *sk, struct sk_buff *skb,
 				       u16 family)
 {
 	int err = 0;
-	struct sk_security_struct *sksec = sk->sk_security;
+	struct sk_security_struct *sksec = lsm_get_sock(sk, &selinux_ops);
 	u32 sk_sid = sksec->sid;
 	struct common_audit_data ad;
 	struct lsm_network_audit net = {0,};
@@ -4122,7 +4165,7 @@ static int selinux_sock_rcv_skb_compat(struct sock *sk, struct sk_buff *skb,
 static int selinux_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 {
 	int err;
-	struct sk_security_struct *sksec = sk->sk_security;
+	struct sk_security_struct *sksec = lsm_get_sock(sk, &selinux_ops);
 	u16 family = sk->sk_family;
 	u32 sk_sid = sksec->sid;
 	struct common_audit_data ad;
@@ -4192,7 +4235,7 @@ static int selinux_socket_getpeersec_stream(struct socket *sock, char __user *op
 	int err = 0;
 	char *scontext;
 	u32 scontext_len;
-	struct sk_security_struct *sksec = sock->sk->sk_security;
+	struct sk_security_struct *sksec = lsm_get_sock(sock->sk, &selinux_ops);
 	u32 peer_sid = SECSID_NULL;
 
 	if (sksec->sclass == SECCLASS_UNIX_STREAM_SOCKET ||
@@ -4257,24 +4300,24 @@ static int selinux_sk_alloc_security(struct sock *sk, int family, gfp_t priority
 	sksec->peer_sid = SECINITSID_UNLABELED;
 	sksec->sid = SECINITSID_UNLABELED;
 	selinux_netlbl_sk_security_reset(sksec);
-	sk->sk_security = sksec;
+	lsm_set_sock(sk, sksec, &selinux_ops);
 
 	return 0;
 }
 
 static void selinux_sk_free_security(struct sock *sk)
 {
-	struct sk_security_struct *sksec = sk->sk_security;
+	struct sk_security_struct *sksec = lsm_get_sock(sk, &selinux_ops);
 
-	sk->sk_security = NULL;
+	lsm_set_sock(sk, NULL, &selinux_ops);
 	selinux_netlbl_sk_security_free(sksec);
 	kfree(sksec);
 }
 
 static void selinux_sk_clone_security(const struct sock *sk, struct sock *newsk)
 {
-	struct sk_security_struct *sksec = sk->sk_security;
-	struct sk_security_struct *newsksec = newsk->sk_security;
+	struct sk_security_struct *sksec = lsm_get_sock(sk, &selinux_ops);
+	struct sk_security_struct *newsksec = lsm_get_sock(newsk, &selinux_ops);
 
 	newsksec->sid = sksec->sid;
 	newsksec->peer_sid = sksec->peer_sid;
@@ -4288,7 +4331,8 @@ static void selinux_sk_getsecid(struct sock *sk, u32 *secid)
 	if (!sk)
 		*secid = SECINITSID_ANY_SOCKET;
 	else {
-		struct sk_security_struct *sksec = sk->sk_security;
+		struct sk_security_struct *sksec =
+					lsm_get_sock(sk, &selinux_ops);
 
 		*secid = sksec->sid;
 	}
@@ -4296,8 +4340,9 @@ static void selinux_sk_getsecid(struct sock *sk, u32 *secid)
 
 static void selinux_sock_graft(struct sock *sk, struct socket *parent)
 {
-	struct inode_security_struct *isec = SOCK_INODE(parent)->i_security;
-	struct sk_security_struct *sksec = sk->sk_security;
+	struct inode_security_struct *isec =
+			lsm_get_inode(SOCK_INODE(parent), &selinux_ops);
+	struct sk_security_struct *sksec = lsm_get_sock(sk, &selinux_ops);
 
 	if (sk->sk_family == PF_INET || sk->sk_family == PF_INET6 ||
 	    sk->sk_family == PF_UNIX)
@@ -4308,7 +4353,7 @@ static void selinux_sock_graft(struct sock *sk, struct socket *parent)
 static int selinux_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 				     struct request_sock *req)
 {
-	struct sk_security_struct *sksec = sk->sk_security;
+	struct sk_security_struct *sksec = lsm_get_sock(sk, &selinux_ops);
 	int err;
 	u16 family = sk->sk_family;
 	u32 newsid;
@@ -4338,7 +4383,7 @@ static int selinux_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 static void selinux_inet_csk_clone(struct sock *newsk,
 				   const struct request_sock *req)
 {
-	struct sk_security_struct *newsksec = newsk->sk_security;
+	struct sk_security_struct *newsksec = lsm_get_sock(newsk, &selinux_ops);
 
 	newsksec->sid = req->secid;
 	newsksec->peer_sid = req->peer_secid;
@@ -4355,7 +4400,7 @@ static void selinux_inet_csk_clone(struct sock *newsk,
 static void selinux_inet_conn_established(struct sock *sk, struct sk_buff *skb)
 {
 	u16 family = sk->sk_family;
-	struct sk_security_struct *sksec = sk->sk_security;
+	struct sk_security_struct *sksec = lsm_get_sock(sk, &selinux_ops);
 
 	/* handle mapped IPv4 packets arriving via IPv6 sockets */
 	if (family == PF_INET6 && skb->protocol == htons(ETH_P_IP))
@@ -4374,7 +4419,7 @@ static int selinux_secmark_relabel_packet(u32 sid)
 	const struct task_security_struct *__tsec;
 	u32 tsid;
 
-	__tsec = current_security();
+	__tsec = lsm_get_cred(current_cred(), &selinux_ops);
 	tsid = __tsec->sid;
 
 	return avc_has_perm(tsid, sid, SECCLASS_PACKET, PACKET__RELABELTO, NULL);
@@ -4479,7 +4524,7 @@ static int selinux_nlmsg_perm(struct sock *sk, struct sk_buff *skb)
 	int err = 0;
 	u32 perm;
 	struct nlmsghdr *nlh;
-	struct sk_security_struct *sksec = sk->sk_security;
+	struct sk_security_struct *sksec = lsm_get_sock(sk, &selinux_ops);
 
 	if (skb->len < NLMSG_SPACE(0)) {
 		err = -EINVAL;
@@ -4599,7 +4644,8 @@ static unsigned int selinux_ip_output(struct sk_buff *skb,
 	 * because we want to make sure we apply the necessary labeling
 	 * before IPsec is applied so we can leverage AH protection */
 	if (skb->sk) {
-		struct sk_security_struct *sksec = skb->sk->sk_security;
+		struct sk_security_struct *sksec =
+					lsm_get_sock(skb->sk, &selinux_ops);
 		sid = sksec->sid;
 	} else
 		sid = SECINITSID_KERNEL;
@@ -4631,7 +4677,7 @@ static unsigned int selinux_ip_postroute_compat(struct sk_buff *skb,
 
 	if (sk == NULL)
 		return NF_ACCEPT;
-	sksec = sk->sk_security;
+	sksec = lsm_get_sock(sk, &selinux_ops);
 
 	ad.type = LSM_AUDIT_DATA_NET;
 	ad.u.net = &net;
@@ -4699,7 +4745,8 @@ static unsigned int selinux_ip_postroute(struct sk_buff *skb, int ifindex,
 			peer_sid = SECINITSID_KERNEL;
 		}
 	} else {
-		struct sk_security_struct *sksec = sk->sk_security;
+		struct sk_security_struct *sksec =
+					lsm_get_sock(sk, &selinux_ops);
 		peer_sid = sksec->sid;
 		secmark_perm = PACKET__SEND;
 	}
@@ -4783,15 +4830,15 @@ static int ipc_alloc_security(struct task_struct *task,
 	sid = task_sid(task);
 	isec->sclass = sclass;
 	isec->sid = sid;
-	perm->security = isec;
+	lsm_set_ipc(perm, isec, &selinux_ops);
 
 	return 0;
 }
 
 static void ipc_free_security(struct kern_ipc_perm *perm)
 {
-	struct ipc_security_struct *isec = perm->security;
-	perm->security = NULL;
+	struct ipc_security_struct *isec = lsm_get_ipc(perm, &selinux_ops);
+	lsm_set_ipc(perm, NULL, &selinux_ops);
 	kfree(isec);
 }
 
@@ -4804,16 +4851,16 @@ static int msg_msg_alloc_security(struct msg_msg *msg)
 		return -ENOMEM;
 
 	msec->sid = SECINITSID_UNLABELED;
-	msg->security = msec;
+	lsm_set_msg(msg, msec, &selinux_ops);
 
 	return 0;
 }
 
 static void msg_msg_free_security(struct msg_msg *msg)
 {
-	struct msg_security_struct *msec = msg->security;
+	struct msg_security_struct *msec = lsm_get_msg(msg, &selinux_ops);
 
-	msg->security = NULL;
+	lsm_set_msg(msg, NULL, &selinux_ops);
 	kfree(msec);
 }
 
@@ -4824,7 +4871,7 @@ static int ipc_has_perm(struct kern_ipc_perm *ipc_perms,
 	struct common_audit_data ad;
 	u32 sid = current_sid();
 
-	isec = ipc_perms->security;
+	isec = lsm_get_ipc(ipc_perms, &selinux_ops);
 
 	ad.type = LSM_AUDIT_DATA_IPC;
 	ad.u.ipc_id = ipc_perms->key;
@@ -4854,7 +4901,7 @@ static int selinux_msg_queue_alloc_security(struct msg_queue *msq)
 	if (rc)
 		return rc;
 
-	isec = msq->q_perm.security;
+	isec = lsm_get_ipc(&msq->q_perm, &selinux_ops);
 
 	ad.type = LSM_AUDIT_DATA_IPC;
 	ad.u.ipc_id = msq->q_perm.key;
@@ -4879,7 +4926,7 @@ static int selinux_msg_queue_associate(struct msg_queue *msq, int msqflg)
 	struct common_audit_data ad;
 	u32 sid = current_sid();
 
-	isec = msq->q_perm.security;
+	isec = lsm_get_ipc(&msq->q_perm, &selinux_ops);
 
 	ad.type = LSM_AUDIT_DATA_IPC;
 	ad.u.ipc_id = msq->q_perm.key;
@@ -4924,8 +4971,8 @@ static int selinux_msg_queue_msgsnd(struct msg_queue *msq, struct msg_msg *msg,
 	u32 sid = current_sid();
 	int rc;
 
-	isec = msq->q_perm.security;
-	msec = msg->security;
+	isec = lsm_get_ipc(&msq->q_perm, &selinux_ops);
+	msec = lsm_get_msg(msg, &selinux_ops);
 
 	/*
 	 * First time through, need to assign label to the message
@@ -4969,8 +5016,8 @@ static int selinux_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg,
 	u32 sid = task_sid(target);
 	int rc;
 
-	isec = msq->q_perm.security;
-	msec = msg->security;
+	isec = lsm_get_ipc(&msq->q_perm, &selinux_ops);
+	msec = lsm_get_msg(msg, &selinux_ops);
 
 	ad.type = LSM_AUDIT_DATA_IPC;
 	ad.u.ipc_id = msq->q_perm.key;
@@ -4995,7 +5042,7 @@ static int selinux_shm_alloc_security(struct shmid_kernel *shp)
 	if (rc)
 		return rc;
 
-	isec = shp->shm_perm.security;
+	isec = lsm_get_ipc(&shp->shm_perm, &selinux_ops);
 
 	ad.type = LSM_AUDIT_DATA_IPC;
 	ad.u.ipc_id = shp->shm_perm.key;
@@ -5020,7 +5067,7 @@ static int selinux_shm_associate(struct shmid_kernel *shp, int shmflg)
 	struct common_audit_data ad;
 	u32 sid = current_sid();
 
-	isec = shp->shm_perm.security;
+	isec = lsm_get_ipc(&shp->shm_perm, &selinux_ops);
 
 	ad.type = LSM_AUDIT_DATA_IPC;
 	ad.u.ipc_id = shp->shm_perm.key;
@@ -5087,7 +5134,7 @@ static int selinux_sem_alloc_security(struct sem_array *sma)
 	if (rc)
 		return rc;
 
-	isec = sma->sem_perm.security;
+	isec = lsm_get_ipc(&sma->sem_perm, &selinux_ops);
 
 	ad.type = LSM_AUDIT_DATA_IPC;
 	ad.u.ipc_id = sma->sem_perm.key;
@@ -5112,7 +5159,7 @@ static int selinux_sem_associate(struct sem_array *sma, int semflg)
 	struct common_audit_data ad;
 	u32 sid = current_sid();
 
-	isec = sma->sem_perm.security;
+	isec = lsm_get_ipc(&sma->sem_perm, &selinux_ops);
 
 	ad.type = LSM_AUDIT_DATA_IPC;
 	ad.u.ipc_id = sma->sem_perm.key;
@@ -5194,7 +5241,7 @@ static int selinux_ipc_permission(struct kern_ipc_perm *ipcp, short flag)
 
 static void selinux_ipc_getsecid(struct kern_ipc_perm *ipcp, u32 *secid)
 {
-	struct ipc_security_struct *isec = ipcp->security;
+	struct ipc_security_struct *isec = lsm_get_ipc(ipcp, &selinux_ops);
 	*secid = isec->sid;
 }
 
@@ -5219,7 +5266,7 @@ static int selinux_getprocattr(struct task_struct *p,
 	}
 
 	rcu_read_lock();
-	__tsec = __task_cred(p)->security;
+	__tsec = lsm_get_cred(__task_cred(p), &selinux_ops);
 
 	if (!strcmp(name, "current"))
 		sid = __tsec->sid;
@@ -5328,7 +5375,7 @@ static int selinux_setprocattr(struct task_struct *p,
 	   operation.  See selinux_bprm_set_creds for the execve
 	   checks and may_create for the file creation checks. The
 	   operation will then fail if the context is not permitted. */
-	tsec = new->security;
+	tsec = lsm_get_cred(new, &selinux_ops);
 	if (!strcmp(name, "exec")) {
 		tsec->exec_sid = sid;
 	} else if (!strcmp(name, "fscreate")) {
@@ -5442,21 +5489,21 @@ static int selinux_key_alloc(struct key *k, const struct cred *cred,
 	if (!ksec)
 		return -ENOMEM;
 
-	tsec = cred->security;
+	tsec = lsm_get_cred(cred, &selinux_ops);
 	if (tsec->keycreate_sid)
 		ksec->sid = tsec->keycreate_sid;
 	else
 		ksec->sid = tsec->sid;
 
-	k->security = ksec;
+	lsm_set_key(k, ksec, &selinux_ops);
 	return 0;
 }
 
 static void selinux_key_free(struct key *k)
 {
-	struct key_security_struct *ksec = k->security;
+	struct key_security_struct *ksec = lsm_get_key(k, &selinux_ops);
 
-	k->security = NULL;
+	lsm_set_key(k, NULL, &selinux_ops);
 	kfree(ksec);
 }
 
@@ -5477,14 +5524,14 @@ static int selinux_key_permission(key_ref_t key_ref,
 	sid = cred_sid(cred);
 
 	key = key_ref_to_ptr(key_ref);
-	ksec = key->security;
+	ksec = lsm_get_key(key, &selinux_ops);
 
 	return avc_has_perm(sid, ksec->sid, SECCLASS_KEY, perm, NULL);
 }
 
 static int selinux_key_getsecurity(struct key *key, char **_buffer)
 {
-	struct key_security_struct *ksec = key->security;
+	struct key_security_struct *ksec = lsm_get_key(key, &selinux_ops);
 	char *context = NULL;
 	unsigned len;
 	int rc;
@@ -5498,7 +5545,7 @@ static int selinux_key_getsecurity(struct key *key, char **_buffer)
 
 #endif
 
-static struct security_operations selinux_ops = {
+struct security_operations selinux_ops = {
 	.name =				"selinux",
 
 	.ptrace_access_check =		selinux_ptrace_access_check,
@@ -5702,6 +5749,7 @@ static struct security_operations selinux_ops = {
 
 static __init int selinux_init(void)
 {
+
 	if (!security_module_enable(&selinux_ops)) {
 		selinux_enabled = 0;
 		return 0;
@@ -5720,8 +5768,8 @@ static __init int selinux_init(void)
 	default_noexec = !(VM_DATA_DEFAULT_FLAGS & VM_EXEC);
 
 	sel_inode_cache = kmem_cache_create("selinux_inode_security",
-					    sizeof(struct inode_security_struct),
-					    0, SLAB_PANIC, NULL);
+				    sizeof(struct inode_security_struct),
+				    0, SLAB_PANIC, NULL);
 	avc_init();
 
 	if (register_security(&selinux_ops))
diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
index aa47bca..c4f9cf1 100644
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -24,6 +24,7 @@
 #include <linux/binfmts.h>
 #include <linux/in.h>
 #include <linux/spinlock.h>
+#include <linux/lsm.h>
 #include "flask.h"
 #include "avc.h"
 
@@ -119,5 +120,6 @@ struct key_security_struct {
 };
 
 extern unsigned int selinux_checkreqprot;
+extern struct security_operations selinux_ops;
 
 #endif /* _SELINUX_OBJSEC_H_ */
diff --git a/security/selinux/include/xfrm.h b/security/selinux/include/xfrm.h
index 65f67cb..1219221 100644
--- a/security/selinux/include/xfrm.h
+++ b/security/selinux/include/xfrm.h
@@ -31,7 +31,7 @@ static inline struct inode_security_struct *get_sock_isec(struct sock *sk)
 	if (!sk->sk_socket)
 		return NULL;
 
-	return SOCK_INODE(sk->sk_socket)->i_security;
+	return lsm_get_inode(SOCK_INODE(sk->sk_socket), &selinux_ops);
 }
 
 #ifdef CONFIG_SECURITY_NETWORK_XFRM
diff --git a/security/selinux/netlabel.c b/security/selinux/netlabel.c
index da4b8b2..7a9cbd0 100644
--- a/security/selinux/netlabel.c
+++ b/security/selinux/netlabel.c
@@ -81,7 +81,7 @@ static int selinux_netlbl_sidlookup_cached(struct sk_buff *skb,
 static struct netlbl_lsm_secattr *selinux_netlbl_sock_genattr(struct sock *sk)
 {
 	int rc;
-	struct sk_security_struct *sksec = sk->sk_security;
+	struct sk_security_struct *sksec = lsm_get_sock(sk, &selinux_ops);
 	struct netlbl_lsm_secattr *secattr;
 
 	if (sksec->nlbl_secattr != NULL)
@@ -221,7 +221,8 @@ int selinux_netlbl_skbuff_setsid(struct sk_buff *skb,
 	 * being labeled by it's parent socket, if it is just exit */
 	sk = skb->sk;
 	if (sk != NULL) {
-		struct sk_security_struct *sksec = sk->sk_security;
+		struct sk_security_struct *sksec =
+					lsm_get_sock(sk, &selinux_ops);
 		if (sksec->nlbl_state != NLBL_REQSKB)
 			return 0;
 		secattr = sksec->nlbl_secattr;
@@ -283,7 +284,7 @@ inet_conn_request_return:
  */
 void selinux_netlbl_inet_csk_clone(struct sock *sk, u16 family)
 {
-	struct sk_security_struct *sksec = sk->sk_security;
+	struct sk_security_struct *sksec = lsm_get_sock(sk, &selinux_ops);
 
 	if (family == PF_INET)
 		sksec->nlbl_state = NLBL_LABELED;
@@ -304,7 +305,7 @@ void selinux_netlbl_inet_csk_clone(struct sock *sk, u16 family)
 int selinux_netlbl_socket_post_create(struct sock *sk, u16 family)
 {
 	int rc;
-	struct sk_security_struct *sksec = sk->sk_security;
+	struct sk_security_struct *sksec = lsm_get_sock(sk, &selinux_ops);
 	struct netlbl_lsm_secattr *secattr;
 
 	if (family != PF_INET)
@@ -402,7 +403,7 @@ int selinux_netlbl_socket_setsockopt(struct socket *sock,
 {
 	int rc = 0;
 	struct sock *sk = sock->sk;
-	struct sk_security_struct *sksec = sk->sk_security;
+	struct sk_security_struct *sksec = lsm_get_sock(sk, &selinux_ops);
 	struct netlbl_lsm_secattr secattr;
 
 	if (level == IPPROTO_IP && optname == IP_OPTIONS &&
@@ -435,7 +436,7 @@ int selinux_netlbl_socket_setsockopt(struct socket *sock,
 int selinux_netlbl_socket_connect(struct sock *sk, struct sockaddr *addr)
 {
 	int rc;
-	struct sk_security_struct *sksec = sk->sk_security;
+	struct sk_security_struct *sksec = lsm_get_sock(sk, &selinux_ops);
 	struct netlbl_lsm_secattr *secattr;
 
 	if (sksec->nlbl_state != NLBL_REQSKB &&
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index ff42773..e9a10a5 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -83,7 +83,7 @@ static int task_has_security(struct task_struct *tsk,
 	u32 sid = 0;
 
 	rcu_read_lock();
-	tsec = __task_cred(tsk)->security;
+	tsec = lsm_get_cred(__task_cred(tsk), &selinux_ops);
 	if (tsec)
 		sid = tsec->sid;
 	rcu_read_unlock();
@@ -1262,7 +1262,7 @@ static int sel_make_bools(void)
 		if (len >= PAGE_SIZE)
 			goto out;
 
-		isec = (struct inode_security_struct *)inode->i_security;
+		isec = lsm_get_inode(inode, &selinux_ops);
 		ret = security_genfs_sid("selinuxfs", page, SECCLASS_FILE, &sid);
 		if (ret)
 			goto out;
@@ -1827,7 +1827,7 @@ static int sel_fill_super(struct super_block *sb, void *data, int silent)
 		goto err;
 
 	inode->i_ino = ++sel_last_ino;
-	isec = (struct inode_security_struct *)inode->i_security;
+	isec = lsm_get_inode(inode, &selinux_ops);
 	isec->sid = SECINITSID_DEVNULL;
 	isec->sclass = SECCLASS_CHR_FILE;
 	isec->initialized = 1;
diff --git a/security/selinux/xfrm.c b/security/selinux/xfrm.c
index 8ab2951..5574ae4 100644
--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -198,7 +198,8 @@ static int selinux_xfrm_sec_ctx_alloc(struct xfrm_sec_ctx **ctxp,
 	struct xfrm_user_sec_ctx *uctx, u32 sid)
 {
 	int rc = 0;
-	const struct task_security_struct *tsec = current_security();
+	const struct task_security_struct *tsec =
+				lsm_get_cred(current_cred(), &selinux_ops);
 	struct xfrm_sec_ctx *ctx = NULL;
 	char *ctx_str = NULL;
 	u32 str_len;
@@ -334,7 +335,8 @@ void selinux_xfrm_policy_free(struct xfrm_sec_ctx *ctx)
  */
 int selinux_xfrm_policy_delete(struct xfrm_sec_ctx *ctx)
 {
-	const struct task_security_struct *tsec = current_security();
+	const struct task_security_struct *tsec =
+				lsm_get_cred(current_cred(), &selinux_ops);
 	int rc = 0;
 
 	if (ctx) {
@@ -379,7 +381,8 @@ void selinux_xfrm_state_free(struct xfrm_state *x)
   */
 int selinux_xfrm_state_delete(struct xfrm_state *x)
 {
-	const struct task_security_struct *tsec = current_security();
+	const struct task_security_struct *tsec =
+				lsm_get_cred(current_cred(), &selinux_ops);
 	struct xfrm_sec_ctx *ctx = x->security;
 	int rc = 0;
 
diff --git a/security/smack/smack.h b/security/smack/smack.h
index 99b3612..d112298 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -20,6 +20,7 @@
 #include <net/netlabel.h>
 #include <linux/list.h>
 #include <linux/rculist.h>
+#include <linux/lsm.h>
 #include <linux/lsm_audit.h>
 
 /*
@@ -203,6 +204,7 @@ struct smk_audit_info {
  * These functions are in smack_lsm.c
  */
 struct inode_smack *new_inode_smack(char *);
+int smk_setcurrent(char *, size_t);
 
 /*
  * These functions are in smack_access.c
@@ -221,6 +223,7 @@ u32 smack_to_secid(const char *);
 /*
  * Shared data.
  */
+extern int smack_use_netlbl;
 extern int smack_cipso_direct;
 extern int smack_cipso_mapped;
 extern char *smack_net_ambient;
@@ -243,18 +246,18 @@ extern struct security_operations smack_ops;
 /*
  * Is the directory transmuting?
  */
-static inline int smk_inode_transmutable(const struct inode *isp)
+static inline int smk_inode_transmutable(struct inode *isp)
 {
-	struct inode_smack *sip = isp->i_security;
+	struct inode_smack *sip = lsm_get_inode(isp, &smack_ops);
 	return (sip->smk_flags & SMK_INODE_TRANSMUTE) != 0;
 }
 
 /*
  * Present a pointer to the smack label in an inode blob.
  */
-static inline char *smk_of_inode(const struct inode *isp)
+static inline char *smk_of_inode(struct inode *isp)
 {
-	struct inode_smack *sip = isp->i_security;
+	struct inode_smack *sip = lsm_get_inode(isp, &smack_ops);
 	return sip->smk_inode;
 }
 
@@ -279,7 +282,9 @@ static inline char *smk_of_forked(const struct task_smack *tsp)
  */
 static inline char *smk_of_current(void)
 {
-	return smk_of_task(current_security());
+	struct task_smack *tsp = lsm_get_cred(current_cred(), &smack_ops);
+
+	return tsp->smk_task;
 }
 
 /*
diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index db14689..b4b4044 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -197,7 +197,7 @@ out_audit:
  */
 int smk_curacc(char *obj_label, u32 mode, struct smk_audit_info *a)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = lsm_get_cred(current_cred(), &smack_ops);
 	char *sp = smk_of_task(tsp);
 	int may;
 	int rc;
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index fa64740..5fef975 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -40,7 +40,16 @@
 #include <linux/binfmts.h>
 #include "smack.h"
 
-#define task_security(task)	(task_cred_xxx((task), security))
+static void *task_security(struct task_struct *task)
+{
+	const struct cred *cred;
+
+	rcu_read_lock();
+	cred = __task_cred(task);
+	rcu_read_unlock();
+
+	return lsm_get_cred(cred, &smack_ops);
+}
 
 #define TRANS_TRUE	"TRUE"
 #define TRANS_TRUE_SIZE	4
@@ -174,8 +183,7 @@ static int smack_ptrace_access_check(struct task_struct *ctp, unsigned int mode)
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
 	smk_ad_setfield_u_tsk(&ad, ctp);
 
-	rc = smk_curacc(tsp, MAY_READWRITE, &ad);
-	return rc;
+	return smk_curacc(tsp, MAY_READWRITE, &ad);
 }
 
 /**
@@ -200,8 +208,7 @@ static int smack_ptrace_traceme(struct task_struct *ptp)
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
 	smk_ad_setfield_u_tsk(&ad, ptp);
 
-	rc = smk_curacc(tsp, MAY_READWRITE, &ad);
-	return rc;
+	return smk_curacc(tsp, MAY_READWRITE, &ad);
 }
 
 /**
@@ -252,7 +259,7 @@ static int smack_sb_alloc_security(struct super_block *sb)
 	sbsp->smk_hat = smack_known_hat.smk_known;
 	sbsp->smk_initialized = 0;
 
-	sb->s_security = sbsp;
+	lsm_set_super(sb, sbsp, &smack_ops);
 
 	return 0;
 }
@@ -264,8 +271,10 @@ static int smack_sb_alloc_security(struct super_block *sb)
  */
 static void smack_sb_free_security(struct super_block *sb)
 {
-	kfree(sb->s_security);
-	sb->s_security = NULL;
+	struct superblock_smack *sbsp = lsm_get_super(sb, &smack_ops);
+
+	kfree(sbsp);
+	lsm_set_super(sb, NULL, &smack_ops);
 }
 
 /**
@@ -325,7 +334,7 @@ static int smack_sb_kern_mount(struct super_block *sb, int flags, void *data)
 {
 	struct dentry *root = sb->s_root;
 	struct inode *inode = root->d_inode;
-	struct superblock_smack *sp = sb->s_security;
+	struct superblock_smack *sp = lsm_get_super(sb, &smack_ops);
 	struct inode_smack *isp;
 	char *op;
 	char *commap;
@@ -368,9 +377,9 @@ static int smack_sb_kern_mount(struct super_block *sb, int flags, void *data)
 	/*
 	 * Initialize the root inode.
 	 */
-	isp = inode->i_security;
+	isp = lsm_get_inode(inode, &smack_ops);
 	if (isp == NULL)
-		inode->i_security = new_inode_smack(sp->smk_root);
+		lsm_set_inode(inode, new_inode_smack(sp->smk_root), &smack_ops);
 	else
 		isp->smk_inode = sp->smk_root;
 
@@ -386,7 +395,7 @@ static int smack_sb_kern_mount(struct super_block *sb, int flags, void *data)
  */
 static int smack_sb_statfs(struct dentry *dentry)
 {
-	struct superblock_smack *sbp = dentry->d_sb->s_security;
+	struct superblock_smack *sbp = lsm_get_super(dentry->d_sb, &smack_ops);
 	int rc;
 	struct smk_audit_info ad;
 
@@ -411,12 +420,13 @@ static int smack_sb_statfs(struct dentry *dentry)
 static int smack_sb_mount(const char *dev_name, struct path *path,
 			  const char *type, unsigned long flags, void *data)
 {
-	struct superblock_smack *sbp = path->dentry->d_sb->s_security;
+	struct superblock_smack *sbp;
 	struct smk_audit_info ad;
 
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_PATH);
 	smk_ad_setfield_u_fs_path(&ad, *path);
 
+	sbp = lsm_get_super(path->dentry->d_sb, &smack_ops);
 	return smk_curacc(sbp->smk_floor, MAY_WRITE, &ad);
 }
 
@@ -440,7 +450,7 @@ static int smack_sb_umount(struct vfsmount *mnt, int flags)
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_PATH);
 	smk_ad_setfield_u_fs_path(&ad, path);
 
-	sbp = path.dentry->d_sb->s_security;
+	sbp = lsm_get_super(path.dentry->d_sb, &smack_ops);
 	return smk_curacc(sbp->smk_floor, MAY_WRITE, &ad);
 }
 
@@ -457,7 +467,7 @@ static int smack_sb_umount(struct vfsmount *mnt, int flags)
 static int smack_bprm_set_creds(struct linux_binprm *bprm)
 {
 	struct inode *inode = file_inode(bprm->file);
-	struct task_smack *bsp = bprm->cred->security;
+	struct task_smack *bsp = lsm_get_cred(bprm->cred, &smack_ops);
 	struct inode_smack *isp;
 	int rc;
 
@@ -468,7 +478,7 @@ static int smack_bprm_set_creds(struct linux_binprm *bprm)
 	if (bprm->cred_prepared)
 		return 0;
 
-	isp = inode->i_security;
+	isp = lsm_get_inode(inode, &smack_ops);
 	if (isp->smk_task == NULL || isp->smk_task == bsp->smk_task)
 		return 0;
 
@@ -489,7 +499,7 @@ static int smack_bprm_set_creds(struct linux_binprm *bprm)
  */
 static void smack_bprm_committing_creds(struct linux_binprm *bprm)
 {
-	struct task_smack *bsp = bprm->cred->security;
+	struct task_smack *bsp = lsm_get_cred(bprm->cred, &smack_ops);
 
 	if (bsp->smk_task != bsp->smk_forked)
 		current->pdeath_signal = 0;
@@ -503,7 +513,7 @@ static void smack_bprm_committing_creds(struct linux_binprm *bprm)
  */
 static int smack_bprm_secureexec(struct linux_binprm *bprm)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = lsm_get_cred(current_cred(), &smack_ops);
 	int ret = cap_bprm_secureexec(bprm);
 
 	if (!ret && (tsp->smk_task != tsp->smk_forked))
@@ -524,9 +534,12 @@ static int smack_bprm_secureexec(struct linux_binprm *bprm)
  */
 static int smack_inode_alloc_security(struct inode *inode)
 {
-	inode->i_security = new_inode_smack(smk_of_current());
-	if (inode->i_security == NULL)
+	struct inode_smack *isp = new_inode_smack(smk_of_current());
+
+	if (isp == NULL)
 		return -ENOMEM;
+
+	lsm_set_inode(inode, isp, &smack_ops);
 	return 0;
 }
 
@@ -538,8 +551,8 @@ static int smack_inode_alloc_security(struct inode *inode)
  */
 static void smack_inode_free_security(struct inode *inode)
 {
-	kfree(inode->i_security);
-	inode->i_security = NULL;
+	kfree(lsm_get_inode(inode, &smack_ops));
+	lsm_set_inode(inode, NULL, &smack_ops);
 }
 
 /**
@@ -558,7 +571,7 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 				     void **value, size_t *len)
 {
 	struct smack_known *skp;
-	struct inode_smack *issp = inode->i_security;
+	struct inode_smack *issp = lsm_get_inode(inode, &smack_ops);
 	char *csp = smk_of_current();
 	char *isp = smk_of_inode(inode);
 	char *dsp = smk_of_inode(dir);
@@ -863,7 +876,7 @@ static void smack_inode_post_setxattr(struct dentry *dentry, const char *name,
 				      const void *value, size_t size, int flags)
 {
 	char *nsp;
-	struct inode_smack *isp = dentry->d_inode->i_security;
+	struct inode_smack *isp = lsm_get_inode(dentry->d_inode, &smack_ops);
 
 	if (strcmp(name, XATTR_NAME_SMACK) == 0) {
 		nsp = smk_import(value, size);
@@ -938,7 +951,7 @@ static int smack_inode_removexattr(struct dentry *dentry, const char *name)
 		rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE, &ad);
 
 	if (rc == 0) {
-		isp = dentry->d_inode->i_security;
+		isp = lsm_get_inode(dentry->d_inode, &smack_ops);
 		isp->smk_task = NULL;
 		isp->smk_mmap = NULL;
 	}
@@ -955,9 +968,8 @@ static int smack_inode_removexattr(struct dentry *dentry, const char *name)
  *
  * Returns the size of the attribute or an error code
  */
-static int smack_inode_getsecurity(const struct inode *inode,
-				   const char *name, void **buffer,
-				   bool alloc)
+static int smack_inode_getsecurity(const struct inode *inode, const char *name,
+					void **buffer, bool alloc)
 {
 	struct socket_smack *ssp;
 	struct socket *sock;
@@ -968,7 +980,7 @@ static int smack_inode_getsecurity(const struct inode *inode,
 	int rc = 0;
 
 	if (strcmp(name, XATTR_SMACK_SUFFIX) == 0) {
-		isp = smk_of_inode(inode);
+		isp = smk_of_inode(ip);
 		ilen = strlen(isp) + 1;
 		*buffer = isp;
 		return ilen;
@@ -985,7 +997,7 @@ static int smack_inode_getsecurity(const struct inode *inode,
 	if (sock == NULL || sock->sk == NULL)
 		return -EOPNOTSUPP;
 
-	ssp = sock->sk->sk_security;
+	ssp = lsm_get_sock(sock->sk, &smack_ops);
 
 	if (strcmp(name, XATTR_SMACK_IPIN) == 0)
 		isp = ssp->smk_in;
@@ -1015,13 +1027,11 @@ static int smack_inode_getsecurity(const struct inode *inode,
 static int smack_inode_listsecurity(struct inode *inode, char *buffer,
 				    size_t buffer_size)
 {
-	int len = strlen(XATTR_NAME_SMACK);
+	const int len = sizeof(XATTR_NAME_SMACK);
 
-	if (buffer != NULL && len <= buffer_size) {
+	if (buffer != NULL && len <= buffer_size)
 		memcpy(buffer, XATTR_NAME_SMACK, len);
-		return len;
-	}
-	return -EINVAL;
+	return len;
 }
 
 /**
@@ -1031,7 +1041,7 @@ static int smack_inode_listsecurity(struct inode *inode, char *buffer,
  */
 static void smack_inode_getsecid(const struct inode *inode, u32 *secid)
 {
-	struct inode_smack *isp = inode->i_security;
+	struct inode_smack *isp = lsm_get_inode(inode, &smack_ops);
 
 	*secid = smack_to_secid(isp->smk_inode);
 }
@@ -1070,7 +1080,7 @@ static int smack_file_permission(struct file *file, int mask)
  */
 static int smack_file_alloc_security(struct file *file)
 {
-	file->f_security = smk_of_current();
+	lsm_set_file(file, smk_of_current(), &smack_ops);
 	return 0;
 }
 
@@ -1083,7 +1093,7 @@ static int smack_file_alloc_security(struct file *file)
  */
 static void smack_file_free_security(struct file *file)
 {
-	file->f_security = NULL;
+	lsm_set_file(file, NULL, &smack_ops);
 }
 
 /**
@@ -1101,15 +1111,16 @@ static int smack_file_ioctl(struct file *file, unsigned int cmd,
 {
 	int rc = 0;
 	struct smk_audit_info ad;
+	char *fsp = lsm_get_file(file, &smack_ops);
 
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_PATH);
 	smk_ad_setfield_u_fs_path(&ad, file->f_path);
 
 	if (_IOC_DIR(cmd) & _IOC_WRITE)
-		rc = smk_curacc(file->f_security, MAY_WRITE, &ad);
+		rc = smk_curacc(fsp, MAY_WRITE, &ad);
 
 	if (rc == 0 && (_IOC_DIR(cmd) & _IOC_READ))
-		rc = smk_curacc(file->f_security, MAY_READ, &ad);
+		rc = smk_curacc(fsp, MAY_READ, &ad);
 
 	return rc;
 }
@@ -1127,7 +1138,7 @@ static int smack_file_lock(struct file *file, unsigned int cmd)
 
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_PATH);
 	smk_ad_setfield_u_fs_path(&ad, file->f_path);
-	return smk_curacc(file->f_security, MAY_WRITE, &ad);
+	return smk_curacc(lsm_get_file(file, &smack_ops), MAY_WRITE, &ad);
 }
 
 /**
@@ -1157,7 +1168,7 @@ static int smack_file_fcntl(struct file *file, unsigned int cmd,
 	case F_SETSIG:
 		smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_PATH);
 		smk_ad_setfield_u_fs_path(&ad, file->f_path);
-		rc = smk_curacc(file->f_security, MAY_WRITE, &ad);
+		rc = smk_curacc(lsm_get_file(file, &smack_ops), MAY_WRITE, &ad);
 		break;
 	default:
 		break;
@@ -1195,12 +1206,12 @@ static int smack_mmap_file(struct file *file,
 	if (file == NULL)
 		return 0;
 
-	isp = file_inode(file)->i_security;
+	isp = lsm_get_inode(file_inode(file), &smack_ops);
 	if (isp->smk_mmap == NULL)
 		return 0;
 	msmack = isp->smk_mmap;
 
-	tsp = current_security();
+	tsp = lsm_get_cred(current_cred(), &smack_ops);
 	sp = smk_of_current();
 	skp = smk_find_entry(sp);
 	rc = 0;
@@ -1279,7 +1290,7 @@ static int smack_mmap_file(struct file *file,
  */
 static int smack_file_set_fowner(struct file *file)
 {
-	file->f_security = smk_of_current();
+	lsm_set_file(file, smk_of_current(), &smack_ops);
 	return 0;
 }
 
@@ -1299,22 +1310,24 @@ static int smack_file_send_sigiotask(struct task_struct *tsk,
 {
 	struct file *file;
 	int rc;
-	char *tsp = smk_of_task(tsk->cred->security);
+	char *tsp = smk_of_task(lsm_get_cred(tsk->cred, &smack_ops));
+	char *fsp;
 	struct smk_audit_info ad;
 
 	/*
 	 * struct fown_struct is never outside the context of a struct file
 	 */
 	file = container_of(fown, struct file, f_owner);
+	fsp = lsm_get_file(file, &smack_ops);
 
 	/* we don't log here as rc can be overriden */
-	rc = smk_access(file->f_security, tsp, MAY_WRITE, NULL);
+	rc = smk_access(fsp, tsp, MAY_WRITE, NULL);
 	if (rc != 0 && has_capability(tsk, CAP_MAC_OVERRIDE))
 		rc = 0;
 
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
 	smk_ad_setfield_u_tsk(&ad, tsk);
-	smack_log(file->f_security, tsp, MAY_WRITE, rc, &ad);
+	smack_log(fsp, tsp, MAY_WRITE, rc, &ad);
 	return rc;
 }
 
@@ -1339,7 +1352,7 @@ static int smack_file_receive(struct file *file)
 	if (file->f_mode & FMODE_WRITE)
 		may |= MAY_WRITE;
 
-	return smk_curacc(file->f_security, may, &ad);
+	return smk_curacc(lsm_get_file(file, &smack_ops), may, &ad);
 }
 
 /**
@@ -1353,9 +1366,9 @@ static int smack_file_receive(struct file *file)
  */
 static int smack_file_open(struct file *file, const struct cred *cred)
 {
-	struct inode_smack *isp = file_inode(file)->i_security;
+	struct inode_smack *isp = lsm_get_inode(file_inode(file), &smack_ops);
 
-	file->f_security = isp->smk_inode;
+	lsm_set_file(file, isp->smk_inode, &smack_ops);
 
 	return 0;
 }
@@ -1381,7 +1394,7 @@ static int smack_cred_alloc_blank(struct cred *cred, gfp_t gfp)
 	if (tsp == NULL)
 		return -ENOMEM;
 
-	cred->security = tsp;
+	lsm_set_cred(cred, tsp, &smack_ops);
 
 	return 0;
 }
@@ -1394,14 +1407,14 @@ static int smack_cred_alloc_blank(struct cred *cred, gfp_t gfp)
  */
 static void smack_cred_free(struct cred *cred)
 {
-	struct task_smack *tsp = cred->security;
+	struct task_smack *tsp = lsm_get_cred(cred, &smack_ops);
 	struct smack_rule *rp;
 	struct list_head *l;
 	struct list_head *n;
 
 	if (tsp == NULL)
 		return;
-	cred->security = NULL;
+	lsm_set_cred(cred, NULL, &smack_ops);
 
 	list_for_each_safe(l, n, &tsp->smk_rules) {
 		rp = list_entry(l, struct smack_rule, list);
@@ -1422,7 +1435,7 @@ static void smack_cred_free(struct cred *cred)
 static int smack_cred_prepare(struct cred *new, const struct cred *old,
 			      gfp_t gfp)
 {
-	struct task_smack *old_tsp = old->security;
+	struct task_smack *old_tsp = lsm_get_cred(old, &smack_ops);
 	struct task_smack *new_tsp;
 	int rc;
 
@@ -1434,7 +1447,7 @@ static int smack_cred_prepare(struct cred *new, const struct cred *old,
 	if (rc != 0)
 		return rc;
 
-	new->security = new_tsp;
+	lsm_set_cred(new, new_tsp, &smack_ops);
 	return 0;
 }
 
@@ -1447,8 +1460,8 @@ static int smack_cred_prepare(struct cred *new, const struct cred *old,
  */
 static void smack_cred_transfer(struct cred *new, const struct cred *old)
 {
-	struct task_smack *old_tsp = old->security;
-	struct task_smack *new_tsp = new->security;
+	struct task_smack *old_tsp = lsm_get_cred(old, &smack_ops);
+	struct task_smack *new_tsp = lsm_get_cred(new, &smack_ops);
 
 	new_tsp->smk_task = old_tsp->smk_task;
 	new_tsp->smk_forked = old_tsp->smk_task;
@@ -1468,7 +1481,7 @@ static void smack_cred_transfer(struct cred *new, const struct cred *old)
  */
 static int smack_kernel_act_as(struct cred *new, u32 secid)
 {
-	struct task_smack *new_tsp = new->security;
+	struct task_smack *new_tsp = lsm_get_cred(new, &smack_ops);
 	char *smack = smack_from_secid(secid);
 
 	if (smack == NULL)
@@ -1489,8 +1502,8 @@ static int smack_kernel_act_as(struct cred *new, u32 secid)
 static int smack_kernel_create_files_as(struct cred *new,
 					struct inode *inode)
 {
-	struct inode_smack *isp = inode->i_security;
-	struct task_smack *tsp = new->security;
+	struct inode_smack *isp = lsm_get_inode(inode, &smack_ops);
+	struct task_smack *tsp = lsm_get_cred(new, &smack_ops);
 
 	tsp->smk_forked = isp->smk_inode;
 	tsp->smk_task = isp->smk_inode;
@@ -1709,7 +1722,7 @@ static int smack_task_wait(struct task_struct *p)
  */
 static void smack_task_to_inode(struct task_struct *p, struct inode *inode)
 {
-	struct inode_smack *isp = inode->i_security;
+	struct inode_smack *isp = lsm_get_inode(inode, &smack_ops);
 	isp->smk_inode = smk_of_task(task_security(p));
 }
 
@@ -1740,7 +1753,7 @@ static int smack_sk_alloc_security(struct sock *sk, int family, gfp_t gfp_flags)
 	ssp->smk_out = csp;
 	ssp->smk_packet = NULL;
 
-	sk->sk_security = ssp;
+	lsm_set_sock(sk, ssp, &smack_ops);
 
 	return 0;
 }
@@ -1753,7 +1766,8 @@ static int smack_sk_alloc_security(struct sock *sk, int family, gfp_t gfp_flags)
  */
 static void smack_sk_free_security(struct sock *sk)
 {
-	kfree(sk->sk_security);
+	kfree(lsm_get_sock(sk, &smack_ops));
+	lsm_set_sock(sk, NULL, &smack_ops);
 }
 
 /**
@@ -1806,7 +1820,7 @@ static char *smack_host_label(struct sockaddr_in *sip)
 static int smack_netlabel(struct sock *sk, int labeled)
 {
 	struct smack_known *skp;
-	struct socket_smack *ssp = sk->sk_security;
+	struct socket_smack *ssp = lsm_get_sock(sk, &smack_ops);
 	int rc = 0;
 
 	/*
@@ -1850,7 +1864,7 @@ static int smack_netlabel_send(struct sock *sk, struct sockaddr_in *sap)
 	int rc;
 	int sk_lbl;
 	char *hostsp;
-	struct socket_smack *ssp = sk->sk_security;
+	struct socket_smack *ssp = lsm_get_sock(sk, &smack_ops);
 	struct smk_audit_info ad;
 
 	rcu_read_lock();
@@ -1893,7 +1907,7 @@ static int smack_inode_setsecurity(struct inode *inode, const char *name,
 				   const void *value, size_t size, int flags)
 {
 	char *sp;
-	struct inode_smack *nsp = inode->i_security;
+	struct inode_smack *nsp = lsm_get_inode(inode, &smack_ops);
 	struct socket_smack *ssp;
 	struct socket *sock;
 	int rc = 0;
@@ -1920,7 +1934,7 @@ static int smack_inode_setsecurity(struct inode *inode, const char *name,
 	if (sock == NULL || sock->sk == NULL)
 		return -EOPNOTSUPP;
 
-	ssp = sock->sk->sk_security;
+	ssp = lsm_get_sock(sock->sk, &smack_ops);
 
 	if (strcmp(name, XATTR_SMACK_IPIN) == 0)
 		ssp->smk_in = sp;
@@ -2011,7 +2025,7 @@ static int smack_flags_to_may(int flags)
  */
 static int smack_msg_msg_alloc_security(struct msg_msg *msg)
 {
-	msg->security = smk_of_current();
+	lsm_set_msg(msg, smk_of_current(), &smack_ops);
 	return 0;
 }
 
@@ -2023,7 +2037,7 @@ static int smack_msg_msg_alloc_security(struct msg_msg *msg)
  */
 static void smack_msg_msg_free_security(struct msg_msg *msg)
 {
-	msg->security = NULL;
+	lsm_set_msg(msg, NULL, &smack_ops);
 }
 
 /**
@@ -2034,7 +2048,7 @@ static void smack_msg_msg_free_security(struct msg_msg *msg)
  */
 static char *smack_of_shm(struct shmid_kernel *shp)
 {
-	return (char *)shp->shm_perm.security;
+	return lsm_get_ipc(&shp->shm_perm, &smack_ops);
 }
 
 /**
@@ -2045,9 +2059,7 @@ static char *smack_of_shm(struct shmid_kernel *shp)
  */
 static int smack_shm_alloc_security(struct shmid_kernel *shp)
 {
-	struct kern_ipc_perm *isp = &shp->shm_perm;
-
-	isp->security = smk_of_current();
+	lsm_set_ipc(&shp->shm_perm, smk_of_current(), &smack_ops);
 	return 0;
 }
 
@@ -2059,9 +2071,7 @@ static int smack_shm_alloc_security(struct shmid_kernel *shp)
  */
 static void smack_shm_free_security(struct shmid_kernel *shp)
 {
-	struct kern_ipc_perm *isp = &shp->shm_perm;
-
-	isp->security = NULL;
+	lsm_set_ipc(&shp->shm_perm, NULL, &smack_ops);
 }
 
 /**
@@ -2073,14 +2083,13 @@ static void smack_shm_free_security(struct shmid_kernel *shp)
  */
 static int smk_curacc_shm(struct shmid_kernel *shp, int access)
 {
-	char *ssp = smack_of_shm(shp);
 	struct smk_audit_info ad;
 
 #ifdef CONFIG_AUDIT
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_IPC);
 	ad.a.u.ipc_id = shp->shm_perm.id;
 #endif
-	return smk_curacc(ssp, access, &ad);
+	return smk_curacc(smack_of_shm(shp), access, &ad);
 }
 
 /**
@@ -2092,10 +2101,7 @@ static int smk_curacc_shm(struct shmid_kernel *shp, int access)
  */
 static int smack_shm_associate(struct shmid_kernel *shp, int shmflg)
 {
-	int may;
-
-	may = smack_flags_to_may(shmflg);
-	return smk_curacc_shm(shp, may);
+	return smk_curacc_shm(shp, smack_flags_to_may(shmflg));
 }
 
 /**
@@ -2143,10 +2149,7 @@ static int smack_shm_shmctl(struct shmid_kernel *shp, int cmd)
 static int smack_shm_shmat(struct shmid_kernel *shp, char __user *shmaddr,
 			   int shmflg)
 {
-	int may;
-
-	may = smack_flags_to_may(shmflg);
-	return smk_curacc_shm(shp, may);
+	return smk_curacc_shm(shp, smack_flags_to_may(shmflg));
 }
 
 /**
@@ -2157,7 +2160,7 @@ static int smack_shm_shmat(struct shmid_kernel *shp, char __user *shmaddr,
  */
 static char *smack_of_sem(struct sem_array *sma)
 {
-	return (char *)sma->sem_perm.security;
+	return lsm_get_ipc(&sma->sem_perm, &smack_ops);
 }
 
 /**
@@ -2168,9 +2171,7 @@ static char *smack_of_sem(struct sem_array *sma)
  */
 static int smack_sem_alloc_security(struct sem_array *sma)
 {
-	struct kern_ipc_perm *isp = &sma->sem_perm;
-
-	isp->security = smk_of_current();
+	lsm_set_ipc(&sma->sem_perm, smk_of_current(), &smack_ops);
 	return 0;
 }
 
@@ -2182,9 +2183,7 @@ static int smack_sem_alloc_security(struct sem_array *sma)
  */
 static void smack_sem_free_security(struct sem_array *sma)
 {
-	struct kern_ipc_perm *isp = &sma->sem_perm;
-
-	isp->security = NULL;
+	lsm_set_ipc(&sma->sem_perm, NULL, &smack_ops);
 }
 
 /**
@@ -2215,10 +2214,7 @@ static int smk_curacc_sem(struct sem_array *sma, int access)
  */
 static int smack_sem_associate(struct sem_array *sma, int semflg)
 {
-	int may;
-
-	may = smack_flags_to_may(semflg);
-	return smk_curacc_sem(sma, may);
+	return smk_curacc_sem(sma, smack_flags_to_may(semflg));
 }
 
 /**
@@ -2286,9 +2282,7 @@ static int smack_sem_semop(struct sem_array *sma, struct sembuf *sops,
  */
 static int smack_msg_queue_alloc_security(struct msg_queue *msq)
 {
-	struct kern_ipc_perm *kisp = &msq->q_perm;
-
-	kisp->security = smk_of_current();
+	lsm_set_ipc(&msq->q_perm, smk_of_current(), &smack_ops);
 	return 0;
 }
 
@@ -2300,9 +2294,7 @@ static int smack_msg_queue_alloc_security(struct msg_queue *msq)
  */
 static void smack_msg_queue_free_security(struct msg_queue *msq)
 {
-	struct kern_ipc_perm *kisp = &msq->q_perm;
-
-	kisp->security = NULL;
+	lsm_set_ipc(&msq->q_perm, NULL, &smack_ops);
 }
 
 /**
@@ -2313,7 +2305,7 @@ static void smack_msg_queue_free_security(struct msg_queue *msq)
  */
 static char *smack_of_msq(struct msg_queue *msq)
 {
-	return (char *)msq->q_perm.security;
+	return lsm_get_ipc(&msq->q_perm, &smack_ops);
 }
 
 /**
@@ -2344,10 +2336,7 @@ static int smk_curacc_msq(struct msg_queue *msq, int access)
  */
 static int smack_msg_queue_associate(struct msg_queue *msq, int msqflg)
 {
-	int may;
-
-	may = smack_flags_to_may(msqflg);
-	return smk_curacc_msq(msq, may);
+	return smk_curacc_msq(msq, smack_flags_to_may(msqflg));
 }
 
 /**
@@ -2394,10 +2383,7 @@ static int smack_msg_queue_msgctl(struct msg_queue *msq, int cmd)
 static int smack_msg_queue_msgsnd(struct msg_queue *msq, struct msg_msg *msg,
 				  int msqflg)
 {
-	int may;
-
-	may = smack_flags_to_may(msqflg);
-	return smk_curacc_msq(msq, may);
+	return smk_curacc_msq(msq, smack_flags_to_may(msqflg));
 }
 
 /**
@@ -2425,15 +2411,14 @@ static int smack_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg,
  */
 static int smack_ipc_permission(struct kern_ipc_perm *ipp, short flag)
 {
-	char *isp = ipp->security;
-	int may = smack_flags_to_may(flag);
 	struct smk_audit_info ad;
 
 #ifdef CONFIG_AUDIT
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_IPC);
 	ad.a.u.ipc_id = ipp->id;
 #endif
-	return smk_curacc(isp, may, &ad);
+	return smk_curacc(lsm_get_ipc(ipp, &smack_ops),
+				smack_flags_to_may(flag), &ad);
 }
 
 /**
@@ -2443,9 +2428,7 @@ static int smack_ipc_permission(struct kern_ipc_perm *ipp, short flag)
  */
 static void smack_ipc_getsecid(struct kern_ipc_perm *ipp, u32 *secid)
 {
-	char *smack = ipp->security;
-
-	*secid = smack_to_secid(smack);
+	*secid = smack_to_secid(lsm_get_ipc(ipp, &smack_ops));
 }
 
 /**
@@ -2471,7 +2454,7 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
 	if (inode == NULL)
 		return;
 
-	isp = inode->i_security;
+	isp = lsm_get_inode(inode, &smack_ops);
 
 	mutex_lock(&isp->smk_lock);
 	/*
@@ -2482,7 +2465,7 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
 		goto unlockandout;
 
 	sbp = inode->i_sb;
-	sbsp = sbp->s_security;
+	sbsp = lsm_get_super(sbp, &smack_ops);
 	/*
 	 * We're going to use the superblock default label
 	 * if there's no label on the file.
@@ -2664,40 +2647,26 @@ static int smack_getprocattr(struct task_struct *p, char *name, char **value)
 }
 
 /**
- * smack_setprocattr - Smack process attribute setting
- * @p: the object task
- * @name: the name of the attribute in /proc/.../attr
+ * smk_setcurrent - Set Smack process attribute setting
  * @value: the value to set
  * @size: the size of the value
  *
- * Sets the Smack value of the task. Only setting self
- * is permitted and only with privilege
+ * Sets the Smack value of the task. Only with privilege
  *
  * Returns the length of the smack label or an error code
  */
-static int smack_setprocattr(struct task_struct *p, char *name,
-			     void *value, size_t size)
+int smk_setcurrent(char *value, size_t size)
 {
 	struct task_smack *tsp;
 	struct cred *new;
 	char *newsmack;
 
-	/*
-	 * Changing another process' Smack value is too dangerous
-	 * and supports no sane use case.
-	 */
-	if (p != current)
-		return -EPERM;
-
 	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
 
 	if (value == NULL || size == 0 || size >= SMK_LONGLABEL)
 		return -EINVAL;
 
-	if (strcmp(name, "current") != 0)
-		return -EINVAL;
-
 	newsmack = smk_import(value, size);
 	if (newsmack == NULL)
 		return -EINVAL;
@@ -2712,7 +2681,7 @@ static int smack_setprocattr(struct task_struct *p, char *name,
 	if (new == NULL)
 		return -ENOMEM;
 
-	tsp = new->security;
+	tsp = lsm_get_cred(new, &smack_ops);
 	tsp->smk_task = newsmack;
 
 	commit_creds(new);
@@ -2720,6 +2689,33 @@ static int smack_setprocattr(struct task_struct *p, char *name,
 }
 
 /**
+ * smack_setprocattr - Smack process attribute setting
+ * @p: the object task
+ * @name: the name of the attribute in /proc/.../attr
+ * @value: the value to set
+ * @size: the size of the value
+ *
+ * Sets the Smack value of the task. Only setting self
+ * is permitted and only with privilege
+ *
+ * Returns the length of the smack label or an error code
+ */
+static int smack_setprocattr(struct task_struct *p, char *name,
+			     void *value, size_t size)
+{
+	/*
+	 * Changing another process' Smack value is too dangerous
+	 * and supports no sane use case.
+	 */
+	if (p != current)
+		return -EPERM;
+	if (strcmp(name, "current") != 0)
+		return -EINVAL;
+
+	return smk_setcurrent(value, size);
+}
+
+/**
  * smack_unix_stream_connect - Smack access on UDS
  * @sock: one sock
  * @other: the other sock
@@ -2731,9 +2727,9 @@ static int smack_setprocattr(struct task_struct *p, char *name,
 static int smack_unix_stream_connect(struct sock *sock,
 				     struct sock *other, struct sock *newsk)
 {
-	struct socket_smack *ssp = sock->sk_security;
-	struct socket_smack *osp = other->sk_security;
-	struct socket_smack *nsp = newsk->sk_security;
+	struct socket_smack *ssp = lsm_get_sock(sock, &smack_ops);
+	struct socket_smack *osp = lsm_get_sock(other, &smack_ops);
+	struct socket_smack *nsp = lsm_get_sock(newsk, &smack_ops);
 	struct smk_audit_info ad;
 	int rc = 0;
 
@@ -2768,8 +2764,8 @@ static int smack_unix_stream_connect(struct sock *sock,
  */
 static int smack_unix_may_send(struct socket *sock, struct socket *other)
 {
-	struct socket_smack *ssp = sock->sk->sk_security;
-	struct socket_smack *osp = other->sk->sk_security;
+	struct socket_smack *ssp = lsm_get_sock(sock->sk, &smack_ops);
+	struct socket_smack *osp = lsm_get_sock(other->sk, &smack_ops);
 	struct smk_audit_info ad;
 	int rc = 0;
 
@@ -2888,7 +2884,7 @@ static char *smack_from_secattr(struct netlbl_lsm_secattr *sap,
 static int smack_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 {
 	struct netlbl_lsm_secattr secattr;
-	struct socket_smack *ssp = sk->sk_security;
+	struct socket_smack *ssp = lsm_get_sock(sk, &smack_ops);
 	char *csp;
 	int rc;
 	struct smk_audit_info ad;
@@ -2900,6 +2896,8 @@ static int smack_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 
 	/*
 	 * Translate what netlabel gave us.
+	 * If Netlabel is unavailable use the ambient label.
+	 * In this case we'd expect the ambient label to be "@".
 	 */
 	netlbl_secattr_init(&secattr);
 
@@ -2947,7 +2945,7 @@ static int smack_socket_getpeersec_stream(struct socket *sock,
 	int slen = 1;
 	int rc = 0;
 
-	ssp = sock->sk->sk_security;
+	ssp = lsm_get_sock(sock->sk, &smack_ops);
 	if (ssp->smk_packet != NULL) {
 		rcp = ssp->smk_packet;
 		slen = strlen(rcp) + 1;
@@ -2994,14 +2992,14 @@ static int smack_socket_getpeersec_dgram(struct socket *sock,
 		family = sock->sk->sk_family;
 
 	if (family == PF_UNIX) {
-		ssp = sock->sk->sk_security;
+		ssp = lsm_get_sock(sock->sk, &smack_ops);
 		s = smack_to_secid(ssp->smk_out);
 	} else if (family == PF_INET || family == PF_INET6) {
 		/*
 		 * Translate what netlabel gave us.
 		 */
 		if (sock != NULL && sock->sk != NULL)
-			ssp = sock->sk->sk_security;
+			ssp = lsm_get_sock(sock->sk, &smack_ops);
 		netlbl_secattr_init(&secattr);
 		rc = netlbl_skbuff_getattr(skb, family, &secattr);
 		if (rc == 0) {
@@ -3032,7 +3030,7 @@ static void smack_sock_graft(struct sock *sk, struct socket *parent)
 	    (sk->sk_family != PF_INET && sk->sk_family != PF_INET6))
 		return;
 
-	ssp = sk->sk_security;
+	ssp = lsm_get_sock(sk, &smack_ops);
 	ssp->smk_in = ssp->smk_out = smk_of_current();
 	/* cssp->smk_packet is already set in smack_inet_csk_clone() */
 }
@@ -3051,7 +3049,7 @@ static int smack_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 {
 	u16 family = sk->sk_family;
 	struct smack_known *skp;
-	struct socket_smack *ssp = sk->sk_security;
+	struct socket_smack *ssp = lsm_get_sock(sk, &smack_ops);
 	struct netlbl_lsm_secattr secattr;
 	struct sockaddr_in addr;
 	struct iphdr *hdr;
@@ -3125,7 +3123,7 @@ static int smack_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 static void smack_inet_csk_clone(struct sock *sk,
 				 const struct request_sock *req)
 {
-	struct socket_smack *ssp = sk->sk_security;
+	struct socket_smack *ssp = lsm_get_sock(sk, &smack_ops);
 
 	if (req->peer_secid != 0)
 		ssp->smk_packet = smack_from_secid(req->peer_secid);
@@ -3155,7 +3153,8 @@ static void smack_inet_csk_clone(struct sock *sk,
 static int smack_key_alloc(struct key *key, const struct cred *cred,
 			   unsigned long flags)
 {
-	key->security = smk_of_task(cred->security);
+	lsm_set_key(key, smk_of_task(lsm_get_cred(cred, &smack_ops)),
+			&smack_ops);
 	return 0;
 }
 
@@ -3167,7 +3166,7 @@ static int smack_key_alloc(struct key *key, const struct cred *cred,
  */
 static void smack_key_free(struct key *key)
 {
-	key->security = NULL;
+	lsm_set_key(key, NULL, &smack_ops);
 }
 
 /*
@@ -3184,16 +3183,18 @@ static int smack_key_permission(key_ref_t key_ref,
 {
 	struct key *keyp;
 	struct smk_audit_info ad;
-	char *tsp = smk_of_task(cred->security);
+	char *tsp = smk_of_task(lsm_get_cred(cred, &smack_ops));
+	char *ksp;
 
 	keyp = key_ref_to_ptr(key_ref);
 	if (keyp == NULL)
 		return -EINVAL;
+	ksp = lsm_get_key(keyp, &smack_ops);
 	/*
 	 * If the key hasn't been initialized give it access so that
 	 * it may do so.
 	 */
-	if (keyp->security == NULL)
+	if (ksp == NULL)
 		return 0;
 	/*
 	 * This should not occur
@@ -3205,8 +3206,7 @@ static int smack_key_permission(key_ref_t key_ref,
 	ad.a.u.key_struct.key = keyp->serial;
 	ad.a.u.key_struct.key_desc = keyp->description;
 #endif
-	return smk_access(tsp, keyp->security,
-				 MAY_READWRITE, &ad);
+	return smk_access(tsp, ksp, MAY_READWRITE, &ad);
 }
 #endif /* CONFIG_KEYS */
 
@@ -3342,7 +3342,7 @@ static int smack_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
 
 	if (secdata)
 		*secdata = sp;
-	*seclen = strlen(sp);
+	*seclen = strlen(sp) + 1;
 	return 0;
 }
 
@@ -3571,6 +3571,7 @@ static __init void init_smack_known_list(void)
  */
 static __init int smack_init(void)
 {
+	int rc;
 	struct cred *cred;
 	struct task_smack *tsp;
 
@@ -3588,7 +3589,10 @@ static __init int smack_init(void)
 	 * Set the security state for the initial task.
 	 */
 	cred = (struct cred *) current->cred;
-	cred->security = tsp;
+
+	rc = lsm_set_init_cred(cred, tsp, &smack_ops);
+	if (rc != 0)
+		panic("smack: Unable to initialize credentials.\n");
 
 	/* initialize the smack_known_list */
 	init_smack_known_list();
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 76a5dca..5335444 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -108,7 +108,7 @@ struct smack_master_list {
 	struct smack_rule	*smk_rule;
 };
 
-LIST_HEAD(smack_rule_list);
+static LIST_HEAD(smack_rule_list);
 
 static int smk_cipso_doi_value = SMACK_CIPSO_DOI_DEFAULT;
 
@@ -1173,12 +1173,12 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
 	}
 	smk_netlabel_audit_set(&audit_info);
 
+	rc = 0;
 	if (found == 0) {
 		skp = kzalloc(sizeof(*skp), GFP_KERNEL);
 		if (skp == NULL)
 			rc = -ENOMEM;
 		else {
-			rc = 0;
 			skp->smk_host.sin_addr.s_addr = newname.sin_addr.s_addr;
 			skp->smk_mask.s_addr = mask.s_addr;
 			skp->smk_label = sp;
@@ -1191,8 +1191,6 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
 			rc = netlbl_cfg_unlbl_static_del(&init_net, NULL,
 					&skp->smk_host.sin_addr, &skp->smk_mask,
 					PF_INET, &audit_info);
-		else
-			rc = 0;
 		skp->smk_label = sp;
 	}
 
@@ -1582,7 +1580,7 @@ static ssize_t smk_write_onlycap(struct file *file, const char __user *buf,
 				 size_t count, loff_t *ppos)
 {
 	char *data;
-	char *sp = smk_of_task(current->cred->security);
+	char *sp = smk_of_task(lsm_get_cred(current->cred, &smack_ops));
 	int rc = count;
 
 	if (!smack_privileged(CAP_MAC_ADMIN))
@@ -1696,14 +1694,14 @@ static const struct file_operations smk_logging_ops = {
 
 static void *load_self_seq_start(struct seq_file *s, loff_t *pos)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = lsm_get_cred(current_cred(), &smack_ops);
 
 	return smk_seq_start(s, pos, &tsp->smk_rules);
 }
 
 static void *load_self_seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = lsm_get_cred(current_cred(), &smack_ops);
 
 	return smk_seq_next(s, v, pos, &tsp->smk_rules);
 }
@@ -1750,7 +1748,7 @@ static int smk_open_load_self(struct inode *inode, struct file *file)
 static ssize_t smk_write_load_self(struct file *file, const char __user *buf,
 			      size_t count, loff_t *ppos)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = lsm_get_cred(current_cred(), &smack_ops);
 
 	return smk_write_rules_list(file, buf, count, ppos, &tsp->smk_rules,
 				    &tsp->smk_rules_lock, SMK_FIXED24_FMT);
@@ -1905,14 +1903,14 @@ static const struct file_operations smk_load2_ops = {
 
 static void *load_self2_seq_start(struct seq_file *s, loff_t *pos)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = lsm_get_cred(current_cred(), &smack_ops);
 
 	return smk_seq_start(s, pos, &tsp->smk_rules);
 }
 
 static void *load_self2_seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = lsm_get_cred(current_cred(), &smack_ops);
 
 	return smk_seq_next(s, v, pos, &tsp->smk_rules);
 }
@@ -1958,7 +1956,7 @@ static int smk_open_load_self2(struct inode *inode, struct file *file)
 static ssize_t smk_write_load_self2(struct file *file, const char __user *buf,
 			      size_t count, loff_t *ppos)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = lsm_get_cred(current_cred(), &smack_ops);
 
 	return smk_write_rules_list(file, buf, count, ppos, &tsp->smk_rules,
 				    &tsp->smk_rules_lock, SMK_LONG_FMT);
diff --git a/security/tomoyo/common.h b/security/tomoyo/common.h
index d4f166b..ef0cdcc 100644
--- a/security/tomoyo/common.h
+++ b/security/tomoyo/common.h
@@ -28,6 +28,7 @@
 #include <linux/in.h>
 #include <linux/in6.h>
 #include <linux/un.h>
+#include <linux/lsm.h>
 #include <net/sock.h>
 #include <net/af_unix.h>
 #include <net/ip.h>
@@ -1079,6 +1080,7 @@ extern struct list_head tomoyo_domain_list;
 extern struct list_head tomoyo_name_list[TOMOYO_MAX_HASH];
 extern struct list_head tomoyo_namespace_list;
 extern struct mutex tomoyo_policy_lock;
+extern struct security_operations tomoyo_security_ops;
 extern struct srcu_struct tomoyo_ss;
 extern struct tomoyo_domain_info tomoyo_kernel_domain;
 extern struct tomoyo_policy_namespace tomoyo_kernel_namespace;
@@ -1202,7 +1204,7 @@ static inline void tomoyo_put_group(struct tomoyo_group *group)
  */
 static inline struct tomoyo_domain_info *tomoyo_domain(void)
 {
-	return current_cred()->security;
+	return lsm_get_cred(current_cred(), &tomoyo_security_ops);
 }
 
 /**
@@ -1215,7 +1217,7 @@ static inline struct tomoyo_domain_info *tomoyo_domain(void)
 static inline struct tomoyo_domain_info *tomoyo_real_domain(struct task_struct
 							    *task)
 {
-	return task_cred_xxx(task, security);
+	return lsm_get_cred(__task_cred(task), &tomoyo_security_ops);
 }
 
 /**
diff --git a/security/tomoyo/domain.c b/security/tomoyo/domain.c
index 3865145..15042e7 100644
--- a/security/tomoyo/domain.c
+++ b/security/tomoyo/domain.c
@@ -840,7 +840,7 @@ force_jump_domain:
 		domain = old_domain;
 	/* Update reference count on "struct tomoyo_domain_info". */
 	atomic_inc(&domain->users);
-	bprm->cred->security = domain;
+	lsm_set_cred(bprm->cred, domain, &tomoyo_security_ops);
 	kfree(exename.name);
 	if (!retval) {
 		ee->r.domain = domain;
diff --git a/security/tomoyo/securityfs_if.c b/security/tomoyo/securityfs_if.c
index fcf3278..2c0332c 100644
--- a/security/tomoyo/securityfs_if.c
+++ b/security/tomoyo/securityfs_if.c
@@ -75,8 +75,10 @@ static ssize_t tomoyo_write_self(struct file *file, const char __user *buf,
 					error = -ENOMEM;
 				} else {
 					struct tomoyo_domain_info *old_domain =
-						cred->security;
-					cred->security = new_domain;
+						lsm_get_cred(cred,
+							&tomoyo_security_ops);
+					lsm_set_cred(cred, new_domain,
+							&tomoyo_security_ops);
 					atomic_inc(&new_domain->users);
 					atomic_dec(&old_domain->users);
 					commit_creds(cred);
@@ -242,7 +244,8 @@ static int __init tomoyo_initerface_init(void)
 	struct dentry *tomoyo_dir;
 
 	/* Don't create securityfs entries unless registered. */
-	if (current_cred()->security != &tomoyo_kernel_domain)
+	if (lsm_get_cred(current_cred(), &tomoyo_security_ops) !=
+			&tomoyo_kernel_domain)
 		return 0;
 
 	tomoyo_dir = securityfs_create_dir("tomoyo", NULL);
diff --git a/security/tomoyo/tomoyo.c b/security/tomoyo/tomoyo.c
index a2ee362..2b4cade 100644
--- a/security/tomoyo/tomoyo.c
+++ b/security/tomoyo/tomoyo.c
@@ -17,7 +17,7 @@
  */
 static int tomoyo_cred_alloc_blank(struct cred *new, gfp_t gfp)
 {
-	new->security = NULL;
+	lsm_set_cred(new, NULL, &tomoyo_security_ops);
 	return 0;
 }
 
@@ -33,8 +33,10 @@ static int tomoyo_cred_alloc_blank(struct cred *new, gfp_t gfp)
 static int tomoyo_cred_prepare(struct cred *new, const struct cred *old,
 			       gfp_t gfp)
 {
-	struct tomoyo_domain_info *domain = old->security;
-	new->security = domain;
+	struct tomoyo_domain_info *domain;
+
+	domain = lsm_get_cred(old, &tomoyo_security_ops);
+	lsm_set_cred(new, domain, &tomoyo_security_ops);
 	if (domain)
 		atomic_inc(&domain->users);
 	return 0;
@@ -58,9 +60,13 @@ static void tomoyo_cred_transfer(struct cred *new, const struct cred *old)
  */
 static void tomoyo_cred_free(struct cred *cred)
 {
-	struct tomoyo_domain_info *domain = cred->security;
-	if (domain)
+	struct tomoyo_domain_info *domain;
+
+	domain = lsm_get_cred(cred, &tomoyo_security_ops);
+	if (domain) {
 		atomic_dec(&domain->users);
+		lsm_set_cred(cred, NULL, &tomoyo_security_ops);
+	}
 }
 
 /**
@@ -98,13 +104,13 @@ static int tomoyo_bprm_set_creds(struct linux_binprm *bprm)
 	 * stored inside "bprm->cred->security" will be acquired later inside
 	 * tomoyo_find_next_domain().
 	 */
-	atomic_dec(&((struct tomoyo_domain_info *)
-		     bprm->cred->security)->users);
+	atomic_dec(&((struct tomoyo_domain_info *)lsm_get_cred(bprm->cred,
+						&tomoyo_security_ops))->users);
 	/*
 	 * Tell tomoyo_bprm_check_security() is called for the first time of an
 	 * execve operation.
 	 */
-	bprm->cred->security = NULL;
+	lsm_set_cred(bprm->cred, NULL, &tomoyo_security_ops);
 	return 0;
 }
 
@@ -117,8 +123,9 @@ static int tomoyo_bprm_set_creds(struct linux_binprm *bprm)
  */
 static int tomoyo_bprm_check_security(struct linux_binprm *bprm)
 {
-	struct tomoyo_domain_info *domain = bprm->cred->security;
+	struct tomoyo_domain_info *domain;
 
+	domain = lsm_get_cred(bprm->cred, &tomoyo_security_ops);
 	/*
 	 * Execute permission is checked against pathname passed to do_execve()
 	 * using current domain.
@@ -503,7 +510,7 @@ static int tomoyo_socket_sendmsg(struct socket *sock, struct msghdr *msg,
  * tomoyo_security_ops is a "struct security_operations" which is used for
  * registering TOMOYO.
  */
-static struct security_operations tomoyo_security_ops = {
+struct security_operations tomoyo_security_ops = {
 	.name                = "tomoyo",
 	.cred_alloc_blank    = tomoyo_cred_alloc_blank,
 	.cred_prepare        = tomoyo_cred_prepare,
@@ -545,16 +552,22 @@ struct srcu_struct tomoyo_ss;
  */
 static int __init tomoyo_init(void)
 {
+	int rc;
 	struct cred *cred = (struct cred *) current_cred();
 
+	/* register ourselves with the security framework */
 	if (!security_module_enable(&tomoyo_security_ops))
 		return 0;
-	/* register ourselves with the security framework */
-	if (register_security(&tomoyo_security_ops) ||
-	    init_srcu_struct(&tomoyo_ss))
+
+	if (init_srcu_struct(&tomoyo_ss))
 		panic("Failure registering TOMOYO Linux");
 	printk(KERN_INFO "TOMOYO Linux initialized\n");
-	cred->security = &tomoyo_kernel_domain;
+
+	rc = lsm_set_init_cred(cred, &tomoyo_kernel_domain,
+				&tomoyo_security_ops);
+	if (rc)
+		panic("Failure allocating credential for TOMOYO Linux");
+
 	tomoyo_mm_init();
 	return 0;
 }


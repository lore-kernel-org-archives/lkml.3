Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab3GYScJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:32:09 -0400
Received: from smtp104.biz.mail.gq1.yahoo.com ([98.137.12.179]:36873 "HELO
	smtp104.biz.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756342Ab3GYScE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 14:32:04 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ubyzmSkVM1mL4I2xL_mtfRt9eClPRH7g5bm39leyflKf1jQ
 8t5Dhyq.PREPxzgphhJcajiAOx9SWiR.vB_RH5fk_zus6b0h_pRg3ySzDLcA
 8k49tpwwHdME0.gb9MAaazySF.6bHHZ1osEGMfW3nSNSaGsm_KmHthO9EOY1
 EBe4A7L9aFCnYQeF.yvlIqGnfUcuLuPRxc4DEEKYMpTx39qlVATCneBaMim_
 v5Acz_DFe4VXPdOn5ILwXOI9rFXhriEJZEjtWu1p9aO9PT6oq4wNnwOmylqg
 vM34xGm7zeKqGFzedpRFb_HPw0Zj0eg7.AHCmVrnMdvwdo3NWmlfDwhilJXi
 gqNznXF7sQAxxHFGY6_2zRaNJpabZyXN2C2r3jTDBWR4ysqi5Xu6jtHLaqLE
 8E.BsMQ5jyeWZJLS0bSy1lKY4B0HrE9.Beio6Sq2YxLyl20_hJfmlEpfEhtK
 TrFeetIn68zvwe9mTfX1qAy6yYsBkO0_7fzfXARgvRrWd_q5u3eRmTNQvasw
 y3Bt4vMVAO8N4
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with )
        by smtp104.biz.mail.gq1.yahoo.com with SMTP; 25 Jul 2013 11:32:02 -0700 PDT
Message-ID: <51F16F21.3020305@schaufler-ca.com>
Date: Thu, 25 Jul 2013 11:32:01 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: LKLM <linux-kernel@vger.kernel.org>
CC: Casey Schaufler <casey@schaufler-ca.com>,
        LSM <linux-security-module@vger.kernel.org>,
        SE Linux <selinux@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v14 1/6] LSM: Security blob abstraction
References: <51F16CFB.6040603@schaufler-ca.com>
In-Reply-To: <51F16CFB.6040603@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH v14 1/6] LSM: Security blob abstraction

Create an abstracted interface for security blobs.
Instead of directly accessing security blob pointers
Use lsm_get and lsm_set functions that hide the actual
mechanism used to maintain the security blobs. This
affects most uses of inode->i_security, file->f_security,
cred->security and similar fields in keys, sockets,
superblocks, ipc and keys.

The use of a single 32 bit integer to refer to a security blob
does not scale to the case where there may be more than one
relevant security blob. Where it is possible to do so the use
of secids (u32) has been replaced with a struct secids, which
provides for multiple u32 values. There are components where
u32 secids remain at the request of the maintainer of that
component.


Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---
 drivers/usb/core/devio.c                           |   13 +-
 include/linux/cred.h                               |    4 +-
 include/linux/lsm.h                                |  177 +++++++++++
 include/linux/sched.h                              |    2 +-
 include/linux/security.h                           |   76 +++--
 include/net/af_unix.h                              |    2 +-
 include/net/netlabel.h                             |    5 +-
 include/net/scm.h                                  |    4 +-
 include/net/xfrm.h                                 |    5 +-
 kernel/audit.c                                     |   41 ++-
 kernel/audit.h                                     |    9 +-
 kernel/auditfilter.c                               |    4 +-
 kernel/auditsc.c                                   |   43 +--
 kernel/cred.c                                      |    6 +-
 kernel/signal.c                                    |    7 +-
 net/ipv4/cipso_ipv4.c                              |    8 +-
 net/ipv4/ip_sockglue.c                             |    5 +-
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |    5 +-
 net/netfilter/nf_conntrack_netlink.c               |    9 +-
 net/netfilter/nf_conntrack_standalone.c            |    5 +-
 net/netfilter/xt_SECMARK.c                         |    7 +-
 net/netlabel/netlabel_unlabeled.c                  |   32 +-
 net/netlabel/netlabel_user.c                       |    5 +-
 net/netlabel/netlabel_user.h                       |    1 +
 net/unix/af_unix.c                                 |    8 +-
 net/xfrm/xfrm_user.c                               |   33 +-
 security/apparmor/context.c                        |   10 +-
 security/apparmor/domain.c                         |    8 +-
 security/apparmor/include/apparmor.h               |    3 +
 security/apparmor/include/context.h                |    9 +-
 security/apparmor/lsm.c                            |   34 +-
 security/integrity/ima/ima.h                       |    4 +-
 security/integrity/ima/ima_policy.c                |    6 +-
 security/security.c                                |   69 ++--
 security/selinux/hooks.c                           |  333 +++++++++++---------
 security/selinux/include/objsec.h                  |    1 +
 security/selinux/include/xfrm.h                    |    2 +-
 security/selinux/netlabel.c                        |   13 +-
 security/selinux/selinuxfs.c                       |    7 +-
 security/selinux/ss/services.c                     |    5 +-
 security/selinux/xfrm.c                            |    9 +-
 security/smack/smack.h                             |    7 +-
 security/smack/smack_access.c                      |    2 +-
 security/smack/smack_lsm.c                         |  180 +++++------
 security/smack/smackfs.c                           |   16 +-
 security/tomoyo/common.h                           |    4 +-
 security/tomoyo/domain.c                           |    2 +-
 security/tomoyo/securityfs_if.c                    |    7 +-
 security/tomoyo/tomoyo.c                           |   23 +-
 49 files changed, 815 insertions(+), 455 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index c88c4fb..ab26dc4 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -47,6 +47,7 @@
 #include <linux/cdev.h>
 #include <linux/notifier.h>
 #include <linux/security.h>
+#include <linux/lsm.h>
 #include <linux/user_namespace.h>
 #include <linux/scatterlist.h>
 #include <asm/uaccess.h>
@@ -75,7 +76,7 @@ struct dev_state {
 	const struct cred *cred;
 	void __user *disccontext;
 	unsigned long ifclaimed;
-	u32 secid;
+	struct secids secid;
 	u32 disabled_bulk_eps;
 };
 
@@ -91,7 +92,7 @@ struct async {
 	struct urb *urb;
 	unsigned int mem_usage;
 	int status;
-	u32 secid;
+	struct secids secid;
 	u8 bulk_addr;
 	u8 bulk_status;
 };
@@ -492,10 +493,11 @@ static void async_completed(struct urb *urb)
 	struct dev_state *ps = as->ps;
 	struct siginfo sinfo;
 	struct pid *pid = NULL;
-	u32 secid = 0;
+	struct secids secid;
 	const struct cred *cred = NULL;
 	int signr;
 
+	lsm_init_secid(&secid, 0, 0);
 	spin_lock(&ps->lock);
 	list_move_tail(&as->asynclist, &ps->async_completed);
 	as->status = urb->status;
@@ -521,7 +523,8 @@ static void async_completed(struct urb *urb)
 	spin_unlock(&ps->lock);
 
 	if (signr) {
-		kill_pid_info_as_cred(sinfo.si_signo, &sinfo, pid, cred, secid);
+		kill_pid_info_as_cred(sinfo.si_signo, &sinfo, pid, cred,
+					&secid);
 		put_pid(pid);
 		put_cred(cred);
 	}
@@ -2217,7 +2220,7 @@ static void usbdev_remove(struct usb_device *udev)
 			sinfo.si_code = SI_ASYNCIO;
 			sinfo.si_addr = ps->disccontext;
 			kill_pid_info_as_cred(ps->discsignr, &sinfo,
-					ps->disc_pid, ps->cred, ps->secid);
+					ps->disc_pid, ps->cred, &ps->secid);
 		}
 	}
 }
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 04421e8..fb0f399 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -22,6 +22,7 @@
 struct user_struct;
 struct cred;
 struct inode;
+struct secids;
 
 /*
  * COW Supplementary groups list
@@ -151,7 +152,7 @@ extern const struct cred *override_creds(const struct cred *);
 extern void revert_creds(const struct cred *);
 extern struct cred *prepare_kernel_cred(struct task_struct *);
 extern int change_create_files_as(struct cred *, struct inode *);
-extern int set_security_override(struct cred *, u32);
+extern int set_security_override(struct cred *, struct secids *);
 extern int set_security_override_from_ctx(struct cred *, const char *);
 extern int set_create_files_as(struct cred *, struct inode *);
 extern void __init cred_init(void);
@@ -338,7 +339,6 @@ static inline void put_cred(const struct cred *_cred)
 #define current_fsgid() 	(current_cred_xxx(fsgid))
 #define current_cap()		(current_cred_xxx(cap_effective))
 #define current_user()		(current_cred_xxx(user))
-#define current_security()	(current_cred_xxx(security))
 
 extern struct user_namespace init_user_ns;
 #ifdef CONFIG_USER_NS
diff --git a/include/linux/lsm.h b/include/linux/lsm.h
new file mode 100644
index 0000000..d5453ed
--- /dev/null
+++ b/include/linux/lsm.h
@@ -0,0 +1,177 @@
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
+#ifdef CONFIG_SECURITY
+
+static inline void *lsm_get_blob(void *bp, const int lsm)
+{
+	return bp;
+}
+
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
+				const struct security_operations *sop)
+{
+	lsm_set_blob(&cred->security, value, 0);
+}
+
+static inline int lsm_set_init_cred(struct cred *cred, void *value,
+					const struct security_operations *sop)
+{
+	lsm_set_blob(&cred->security, value, 0);
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
+				const struct security_operations *sop)
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
+				const struct security_operations *sop)
+{
+	return lsm_get_blob(ipc->security, 0);
+}
+
+static inline void lsm_set_ipc(struct kern_ipc_perm *ipc, void *value,
+				const struct security_operations *sop)
+{
+	lsm_set_blob(&ipc->security, value, 0);
+}
+
+static inline void *lsm_get_msg(const struct msg_msg *msg,
+				const struct security_operations *sop)
+{
+	return lsm_get_blob(msg->security, 0);
+}
+
+static inline void lsm_set_msg(struct msg_msg *msg, void *value,
+				const struct security_operations *sop)
+{
+	lsm_set_blob(&msg->security, value, 0);
+}
+
+#ifdef CONFIG_KEYS
+static inline void *lsm_get_key(const struct key *key,
+				const struct security_operations *sop)
+{
+	return lsm_get_blob(key->security, 0);
+}
+
+static inline void lsm_set_key(struct key *key, void *value,
+				const struct security_operations *sop)
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
+				const struct security_operations *sop)
+{
+	lsm_set_blob(&sock->sk_security, value, 0);
+}
+
+#endif /* CONFIG_SECURITY */
+
+static inline u32 lsm_get_secid(const struct secids *secid, int order)
+{
+	if (secid->si_count == 0)
+		return 0;
+	return secid->si_lsm[order];
+}
+
+static inline void lsm_set_secid(struct secids *secid, u32 lsecid, int order)
+{
+	if (secid->si_lsm[order] == lsecid)
+		return;
+	if (lsecid == 0)
+		secid->si_count--;
+	else if (secid->si_lsm[order] == 0)
+		secid->si_count++;
+	secid->si_lsm[order] = lsecid;
+}
+
+static inline void lsm_init_secid(struct secids *secid, u32 lsecid, int order)
+{
+	memset(secid, 0, sizeof(*secid));
+
+	if (lsecid != 0)
+		secid->si_count = 1;
+	secid->si_lsm[order] = lsecid;
+}
+
+static inline int lsm_zero_secid(struct secids *secid)
+{
+	if (secid->si_count == 0)
+		return 1;
+	return 0;
+}
+
+#endif /* ! _LINUX_LSM_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 178a8d9..857d988 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2010,7 +2010,7 @@ extern int force_sig_info(int, struct siginfo *, struct task_struct *);
 extern int __kill_pgrp_info(int sig, struct siginfo *info, struct pid *pgrp);
 extern int kill_pid_info(int sig, struct siginfo *info, struct pid *pid);
 extern int kill_pid_info_as_cred(int, struct siginfo *, struct pid *,
-				const struct cred *, u32);
+				const struct cred *, struct secids *);
 extern int kill_pgrp(struct pid *pid, int sig, int priv);
 extern int kill_pid(struct pid *pid, int sig, int priv);
 extern int kill_proc_info(int, struct siginfo *, pid_t);
diff --git a/include/linux/security.h b/include/linux/security.h
index 4686491..e02cad4 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -56,6 +56,10 @@ struct mm_struct;
 /* Maximum number of letters for an LSM name string */
 #define SECURITY_NAME_MAX	10
 
+/* Maximum number of LSMs that can be used at a time.  */
+#define LSM_SLOTS            1
+#define LSM_NAMES_MAX      ((SECURITY_NAME_MAX + 1) * LSM_SLOTS)
+
 /* If capable should audit the security request */
 #define SECURITY_CAP_NOAUDIT 0
 #define SECURITY_CAP_AUDIT 1
@@ -156,6 +160,12 @@ extern int mmap_min_addr_handler(struct ctl_table *table, int write,
 typedef int (*initxattrs) (struct inode *inode,
 			   const struct xattr *xattr_array, void *fs_data);
 
+/* A collection of secids, which are what (certain) LSMs deal with */
+struct secids {
+	int	si_count;
+	u32	si_lsm[LSM_SLOTS];
+};
+
 #ifdef CONFIG_SECURITY
 
 struct security_mnt_opts {
@@ -1766,7 +1776,7 @@ int security_inode_killpriv(struct dentry *dentry);
 int security_inode_getsecurity(const struct inode *inode, const char *name, void **buffer, bool alloc);
 int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags);
 int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size);
-void security_inode_getsecid(const struct inode *inode, u32 *secid);
+void security_inode_getsecid(const struct inode *inode, struct secids *secid);
 int security_file_permission(struct file *file, int mask);
 int security_file_alloc(struct file *file);
 void security_file_free(struct file *file);
@@ -1789,7 +1799,7 @@ int security_cred_alloc_blank(struct cred *cred, gfp_t gfp);
 void security_cred_free(struct cred *cred);
 int security_prepare_creds(struct cred *new, const struct cred *old, gfp_t gfp);
 void security_transfer_creds(struct cred *new, const struct cred *old);
-int security_kernel_act_as(struct cred *new, u32 secid);
+int security_kernel_act_as(struct cred *new, struct secids *secid);
 int security_kernel_create_files_as(struct cred *new, struct inode *inode);
 int security_kernel_module_request(char *kmod_name);
 int security_kernel_module_from_file(struct file *file);
@@ -1798,7 +1808,7 @@ int security_task_fix_setuid(struct cred *new, const struct cred *old,
 int security_task_setpgid(struct task_struct *p, pid_t pgid);
 int security_task_getpgid(struct task_struct *p);
 int security_task_getsid(struct task_struct *p);
-void security_task_getsecid(struct task_struct *p, u32 *secid);
+void security_task_getsecid(struct task_struct *p, struct secids *secid);
 int security_task_setnice(struct task_struct *p, int nice);
 int security_task_setioprio(struct task_struct *p, int ioprio);
 int security_task_getioprio(struct task_struct *p);
@@ -1808,13 +1818,13 @@ int security_task_setscheduler(struct task_struct *p);
 int security_task_getscheduler(struct task_struct *p);
 int security_task_movememory(struct task_struct *p);
 int security_task_kill(struct task_struct *p, struct siginfo *info,
-			int sig, u32 secid);
+			int sig, struct secids *secid);
 int security_task_wait(struct task_struct *p);
 int security_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			unsigned long arg4, unsigned long arg5);
 void security_task_to_inode(struct task_struct *p, struct inode *inode);
 int security_ipc_permission(struct kern_ipc_perm *ipcp, short flag);
-void security_ipc_getsecid(struct kern_ipc_perm *ipcp, u32 *secid);
+void security_ipc_getsecid(struct kern_ipc_perm *ipcp, struct secids *secid);
 int security_msg_msg_alloc(struct msg_msg *msg);
 void security_msg_msg_free(struct msg_msg *msg);
 int security_msg_queue_alloc(struct msg_queue *msq);
@@ -1840,8 +1850,9 @@ void security_d_instantiate(struct dentry *dentry, struct inode *inode);
 int security_getprocattr(struct task_struct *p, char *name, char **value);
 int security_setprocattr(struct task_struct *p, char *name, void *value, size_t size);
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
-int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
-int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid);
+int security_secid_to_secctx(struct secids *secid, char **secdata, u32 *seclen);
+int security_secctx_to_secid(const char *secdata, u32 seclen,
+			     struct secids *secid);
 void security_release_secctx(char *secdata, u32 seclen);
 
 int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
@@ -2188,9 +2199,11 @@ static inline int security_inode_listsecurity(struct inode *inode, char *buffer,
 	return 0;
 }
 
-static inline void security_inode_getsecid(const struct inode *inode, u32 *secid)
+static inline void security_inode_getsecid(const struct inode *inode,
+						struct secids *secid)
 {
-	*secid = 0;
+	secid->si_count = 0;
+	secid->si_lsm[0] = 0;
 }
 
 static inline int security_file_permission(struct file *file, int mask)
@@ -2292,7 +2305,8 @@ static inline void security_transfer_creds(struct cred *new,
 {
 }
 
-static inline int security_kernel_act_as(struct cred *cred, u32 secid)
+static inline int security_kernel_act_as(struct cred *cred,
+						struct secids *secid)
 {
 	return 0;
 }
@@ -2335,9 +2349,11 @@ static inline int security_task_getsid(struct task_struct *p)
 	return 0;
 }
 
-static inline void security_task_getsecid(struct task_struct *p, u32 *secid)
+static inline void security_task_getsecid(struct task_struct *p,
+						struct secids *secid)
 {
-	*secid = 0;
+	secid->si_count = 0;
+	secid->si_lsm[0] = 0;
 }
 
 static inline int security_task_setnice(struct task_struct *p, int nice)
@@ -2379,7 +2395,7 @@ static inline int security_task_movememory(struct task_struct *p)
 
 static inline int security_task_kill(struct task_struct *p,
 				     struct siginfo *info, int sig,
-				     u32 secid)
+				     struct secids *secid)
 {
 	return 0;
 }
@@ -2406,9 +2422,11 @@ static inline int security_ipc_permission(struct kern_ipc_perm *ipcp,
 	return 0;
 }
 
-static inline void security_ipc_getsecid(struct kern_ipc_perm *ipcp, u32 *secid)
+static inline void security_ipc_getsecid(struct kern_ipc_perm *ipcp,
+						struct secids *secid)
 {
-	*secid = 0;
+	secid->si_count = 0;
+	secid->si_lsm[0] = 0;
 }
 
 static inline int security_msg_msg_alloc(struct msg_msg *msg)
@@ -2520,14 +2538,15 @@ static inline int security_netlink_send(struct sock *sk, struct sk_buff *skb)
 	return cap_netlink_send(sk, skb);
 }
 
-static inline int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
+static inline int security_secid_to_secctx(struct secids *secid,
+						char **secdata, u32 *seclen)
 {
 	return -EOPNOTSUPP;
 }
 
 static inline int security_secctx_to_secid(const char *secdata,
 					   u32 seclen,
-					   u32 *secid)
+					   struct secids *secid)
 {
 	return -EOPNOTSUPP;
 }
@@ -2572,7 +2591,8 @@ int security_socket_shutdown(struct socket *sock, int how);
 int security_sock_rcv_skb(struct sock *sk, struct sk_buff *skb);
 int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
 				      int __user *optlen, unsigned len);
-int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb, u32 *secid);
+int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb,
+					struct secids *secid);
 int security_sk_alloc(struct sock *sk, int family, gfp_t priority);
 void security_sk_free(struct sock *sk);
 void security_sk_clone(const struct sock *sk, struct sock *newsk);
@@ -2585,7 +2605,7 @@ void security_inet_csk_clone(struct sock *newsk,
 			const struct request_sock *req);
 void security_inet_conn_established(struct sock *sk,
 			struct sk_buff *skb);
-int security_secmark_relabel_packet(u32 secid);
+int security_secmark_relabel_packet(struct secids *secid);
 void security_secmark_refcount_inc(void);
 void security_secmark_refcount_dec(void);
 int security_tun_dev_alloc_security(void **security);
@@ -2701,7 +2721,9 @@ static inline int security_socket_getpeersec_stream(struct socket *sock, char __
 	return -ENOPROTOOPT;
 }
 
-static inline int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb, u32 *secid)
+static inline int security_socket_getpeersec_dgram(struct socket *sock,
+							struct sk_buff *skb,
+							struct secids *secid)
 {
 	return -ENOPROTOOPT;
 }
@@ -2747,7 +2769,7 @@ static inline void security_inet_conn_established(struct sock *sk,
 {
 }
 
-static inline int security_secmark_relabel_packet(u32 secid)
+static inline int security_secmark_relabel_packet(struct secids *secid)
 {
 	return 0;
 }
@@ -2855,7 +2877,8 @@ static inline int security_xfrm_state_delete(struct xfrm_state *x)
 	return 0;
 }
 
-static inline int security_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir)
+static inline int security_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx,
+					      u32 fl_secid, u8 dir)
 {
 	return 0;
 }
@@ -3000,8 +3023,8 @@ static inline int security_key_getsecurity(struct key *key, char **_buffer)
 #ifdef CONFIG_SECURITY
 int security_audit_rule_init(u32 field, u32 op, char *rulestr, void **lsmrule);
 int security_audit_rule_known(struct audit_krule *krule);
-int security_audit_rule_match(u32 secid, u32 field, u32 op, void *lsmrule,
-			      struct audit_context *actx);
+int security_audit_rule_match(struct secids *secid, u32 field, u32 op,
+			      void *lsmrule, struct audit_context *actx);
 void security_audit_rule_free(void *lsmrule);
 
 #else
@@ -3017,8 +3040,9 @@ static inline int security_audit_rule_known(struct audit_krule *krule)
 	return 0;
 }
 
-static inline int security_audit_rule_match(u32 secid, u32 field, u32 op,
-				   void *lsmrule, struct audit_context *actx)
+static inline int security_audit_rule_match(struct secids *secid, u32 field,
+						u32 op, void *lsmrule,
+						struct audit_context *actx)
 {
 	return 0;
 }
diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index dbdfd2b..32b53b7 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -33,7 +33,7 @@ struct unix_skb_parms {
 	kgid_t			gid;
 	struct scm_fp_list	*fp;		/* Passed files		*/
 #ifdef CONFIG_SECURITY_NETWORK
-	u32			secid;		/* Security ID		*/
+	struct secids		secid;		/* Security ID		*/
 #endif
 };
 
diff --git a/include/net/netlabel.h b/include/net/netlabel.h
index 2c95d55..e84fbb5 100644
--- a/include/net/netlabel.h
+++ b/include/net/netlabel.h
@@ -36,6 +36,7 @@
 #include <linux/skbuff.h>
 #include <linux/in.h>
 #include <linux/in6.h>
+#include <linux/lsm.h>
 #include <net/netlink.h>
 #include <net/request_sock.h>
 #include <linux/atomic.h>
@@ -109,7 +110,7 @@ struct cipso_v4_doi;
 
 /* NetLabel audit information */
 struct netlbl_audit {
-	u32 secid;
+	struct secids secid;
 	kuid_t loginuid;
 	u32 sessionid;
 };
@@ -213,7 +214,7 @@ struct netlbl_lsm_secattr {
 			struct netlbl_lsm_secattr_catmap *cat;
 			u32 lvl;
 		} mls;
-		u32 secid;
+		struct secids secid;
 	} attr;
 };
 
diff --git a/include/net/scm.h b/include/net/scm.h
index 8de2d37..349ec25 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -29,7 +29,7 @@ struct scm_cookie {
 	struct scm_fp_list	*fp;		/* Passed files		*/
 	struct scm_creds	creds;		/* Skb credentials	*/
 #ifdef CONFIG_SECURITY_NETWORK
-	u32			secid;		/* Passed security ID 	*/
+	struct secids		secid;		/* Passed security ID	*/
 #endif
 };
 
@@ -93,7 +93,7 @@ static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct sc
 	int err;
 
 	if (test_bit(SOCK_PASSSEC, &sock->flags)) {
-		err = security_secid_to_secctx(scm->secid, &secdata, &seclen);
+		err = security_secid_to_secctx(&scm->secid, &secdata, &seclen);
 
 		if (!err) {
 			put_cmsg(msg, SOL_SOCKET, SCM_SECURITY, seclen, secdata);
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 94ce082..d8ac020 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -13,6 +13,7 @@
 #include <linux/mutex.h>
 #include <linux/audit.h>
 #include <linux/slab.h>
+#include <linux/lsm.h>
 
 #include <net/sock.h>
 #include <net/dst.h>
@@ -699,11 +700,13 @@ static inline void xfrm_audit_helper_usrinfo(kuid_t auid, u32 ses, u32 secid,
 {
 	char *secctx;
 	u32 secctx_len;
+	struct secids secids;
 
 	audit_log_format(audit_buf, " auid=%u ses=%u",
 			 from_kuid(&init_user_ns, auid), ses);
+	lsm_init_secid(&secids, secid, 0);
 	if (secid != 0 &&
-	    security_secid_to_secctx(secid, &secctx, &secctx_len) == 0) {
+	    security_secid_to_secctx(&secids, &secctx, &secctx_len) == 0) {
 		audit_log_format(audit_buf, " subj=%s", secctx);
 		security_release_secctx(secctx, secctx_len);
 	} else
diff --git a/kernel/audit.c b/kernel/audit.c
index 91e53d0..d49f7ab 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -51,6 +51,7 @@
 #include <linux/kthread.h>
 #include <linux/kernel.h>
 #include <linux/syscalls.h>
+#include <linux/lsm.h>
 
 #include <linux/audit.h>
 
@@ -109,7 +110,7 @@ static int	audit_backlog_wait_overflow = 0;
 /* The identity of the user shutting down the audit system. */
 kuid_t		audit_sig_uid = INVALID_UID;
 pid_t		audit_sig_pid = -1;
-u32		audit_sig_sid = 0;
+struct secids	audit_sig_sid;
 
 /* Records can be lost in several ways:
    0) [suppressed in audit_alloc]
@@ -792,20 +793,21 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	}
 	case AUDIT_SIGNAL_INFO:
 		len = 0;
-		if (audit_sig_sid) {
-			err = security_secid_to_secctx(audit_sig_sid, &ctx, &len);
+		if (!lsm_zero_secid(&audit_sig_sid)) {
+			err = security_secid_to_secctx(&audit_sig_sid, &ctx,
+							&len);
 			if (err)
 				return err;
 		}
 		sig_data = kmalloc(sizeof(*sig_data) + len, GFP_KERNEL);
 		if (!sig_data) {
-			if (audit_sig_sid)
+			if (!lsm_zero_secid(&audit_sig_sid))
 				security_release_secctx(ctx, len);
 			return -ENOMEM;
 		}
 		sig_data->uid = from_kuid(&init_user_ns, audit_sig_uid);
 		sig_data->pid = audit_sig_pid;
-		if (audit_sig_sid) {
+		if (!lsm_zero_secid(&audit_sig_sid)) {
 			memcpy(sig_data->ctx, ctx, len);
 			security_release_secctx(ctx, len);
 		}
@@ -1521,12 +1523,11 @@ void audit_log_name(struct audit_context *context, struct audit_names *n,
 				 MAJOR(n->rdev),
 				 MINOR(n->rdev));
 	}
-	if (n->osid != 0) {
+	if (!lsm_zero_secid(&n->osid)) {
 		char *ctx = NULL;
 		u32 len;
-		if (security_secid_to_secctx(
-			n->osid, &ctx, &len)) {
-			audit_log_format(ab, " osid=%u", n->osid);
+		if (security_secid_to_secctx(&n->osid, &ctx, &len)) {
+			audit_log_format(ab, " osid=%u", n->osid.si_count);
 			if (call_panic)
 				*call_panic = 2;
 		} else {
@@ -1544,13 +1545,13 @@ int audit_log_task_context(struct audit_buffer *ab)
 	char *ctx = NULL;
 	unsigned len;
 	int error;
-	u32 sid;
+	struct secids sid;
 
 	security_task_getsecid(current, &sid);
-	if (!sid)
+	if (lsm_zero_secid(&sid))
 		return 0;
 
-	error = security_secid_to_secctx(sid, &ctx, &len);
+	error = security_secid_to_secctx(&sid, &ctx, &len);
 	if (error) {
 		if (error != -EINVAL)
 			goto error_path;
@@ -1709,21 +1710,27 @@ void audit_log(struct audit_context *ctx, gfp_t gfp_mask, int type,
 
 #ifdef CONFIG_SECURITY
 /**
- * audit_log_secctx - Converts and logs SELinux context
+ * audit_log_secctx - Converts and logs security module(s) context
  * @ab: audit_buffer
  * @secid: security number
  *
  * This is a helper function that calls security_secid_to_secctx to convert
- * secid to secctx and then adds the (converted) SELinux context to the audit
- * log by calling audit_log_format, thus also preventing leak of internal secid
- * to userspace. If secid cannot be converted audit_panic is called.
+ * secid to secctx and then adds the (converted) security module context
+ * to the audit log by calling audit_log_format, thus also preventing leak
+ * of internal secid to userspace. If secid cannot be converted audit_panic
+ * is called.
+ *
+ * This function is only used to create contexts for secmarks.
+ * As such, it does not pass a struct secids.
  */
 void audit_log_secctx(struct audit_buffer *ab, u32 secid)
 {
 	u32 len;
 	char *secctx;
+	struct secids secids;
 
-	if (security_secid_to_secctx(secid, &secctx, &len)) {
+	lsm_init_secid(&secids, secid, 0);
+	if (security_secid_to_secctx(&secids, &secctx, &len)) {
 		audit_panic("Cannot convert secid to context");
 	} else {
 		audit_log_format(ab, " obj=%s", secctx);
diff --git a/kernel/audit.h b/kernel/audit.h
index 1c95131..fcc5bb4 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -22,6 +22,7 @@
 #include <linux/fs.h>
 #include <linux/audit.h>
 #include <linux/skbuff.h>
+#include <linux/lsm.h>
 #include <uapi/linux/mqueue.h>
 
 /* 0 = no checking
@@ -93,7 +94,7 @@ struct audit_names {
 	kuid_t			uid;
 	kgid_t			gid;
 	dev_t			rdev;
-	u32			osid;
+	struct secids		osid;
 	struct audit_cap_data	fcap;
 	unsigned int		fcap_ver;
 	unsigned char		type;		/* record type */
@@ -145,7 +146,7 @@ struct audit_context {
 	kuid_t		    target_auid;
 	kuid_t		    target_uid;
 	unsigned int	    target_sessionid;
-	u32		    target_sid;
+	struct secids	    target_sid;
 	char		    target_comm[TASK_COMM_LEN];
 
 	struct audit_tree_refs *trees, *first_trees;
@@ -162,7 +163,7 @@ struct audit_context {
 			kuid_t			uid;
 			kgid_t			gid;
 			umode_t			mode;
-			u32			osid;
+			struct secids		osid;
 			int			has_perm;
 			uid_t			perm_uid;
 			gid_t			perm_gid;
@@ -303,7 +304,7 @@ extern char *audit_unpack_string(void **, size_t *, size_t);
 
 extern pid_t audit_sig_pid;
 extern kuid_t audit_sig_uid;
-extern u32 audit_sig_sid;
+extern struct secids audit_sig_sid;
 
 #ifdef CONFIG_AUDITSYSCALL
 extern int __audit_signal_info(int sig, struct task_struct *t);
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 6bd4a90..701d308 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1216,7 +1216,7 @@ static int audit_filter_user_rules(struct audit_krule *rule, int type,
 	for (i = 0; i < rule->field_count; i++) {
 		struct audit_field *f = &rule->fields[i];
 		int result = 0;
-		u32 sid;
+		struct secids sid;
 
 		switch (f->type) {
 		case AUDIT_PID:
@@ -1246,7 +1246,7 @@ static int audit_filter_user_rules(struct audit_krule *rule, int type,
 		case AUDIT_SUBJ_CLR:
 			if (f->lsm_rule) {
 				security_task_getsecid(current, &sid);
-				result = security_audit_rule_match(sid,
+				result = security_audit_rule_match(&sid,
 								   f->type,
 								   f->op,
 								   f->lsm_rule,
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 3c8a601..5a6478a 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -60,6 +60,7 @@
 #include <linux/compiler.h>
 #include <asm/unistd.h>
 #include <linux/security.h>
+#include <linux/lsm.h>
 #include <linux/list.h>
 #include <linux/tty.h>
 #include <linux/binfmts.h>
@@ -108,7 +109,7 @@ struct audit_aux_data_pids {
 	kuid_t			target_auid[AUDIT_AUX_PIDS];
 	kuid_t			target_uid[AUDIT_AUX_PIDS];
 	unsigned int		target_sessionid[AUDIT_AUX_PIDS];
-	u32			target_sid[AUDIT_AUX_PIDS];
+	struct secids		target_sid[AUDIT_AUX_PIDS];
 	char 			target_comm[AUDIT_AUX_PIDS][TASK_COMM_LEN];
 	int			pid_count;
 };
@@ -456,7 +457,7 @@ static int audit_filter_rules(struct task_struct *tsk,
 {
 	const struct cred *cred;
 	int i, need_sid = 1;
-	u32 sid;
+	struct secids sid;
 
 	cred = rcu_dereference_check(tsk->cred, tsk == current || task_creation);
 
@@ -631,7 +632,8 @@ static int audit_filter_rules(struct task_struct *tsk,
 					security_task_getsecid(tsk, &sid);
 					need_sid = 0;
 				}
-				result = security_audit_rule_match(sid, f->type,
+				result = security_audit_rule_match(&sid,
+								  f->type,
 				                                  f->op,
 				                                  f->lsm_rule,
 				                                  ctx);
@@ -648,13 +650,17 @@ static int audit_filter_rules(struct task_struct *tsk,
 				/* Find files that match */
 				if (name) {
 					result = security_audit_rule_match(
-					           name->osid, f->type, f->op,
-					           f->lsm_rule, ctx);
+							&name->osid, f->type,
+							f->op, f->lsm_rule,
+							ctx);
 				} else if (ctx) {
 					list_for_each_entry(n, &ctx->names_list, list) {
-						if (security_audit_rule_match(n->osid, f->type,
-									      f->op, f->lsm_rule,
-									      ctx)) {
+						if (security_audit_rule_match(
+								&n->osid,
+								f->type,
+								f->op,
+								f->lsm_rule,
+								ctx)) {
 							++result;
 							break;
 						}
@@ -663,7 +669,7 @@ static int audit_filter_rules(struct task_struct *tsk,
 				/* Find ipc objects that match */
 				if (!ctx || ctx->type != AUDIT_IPC)
 					break;
-				if (security_audit_rule_match(ctx->ipc.osid,
+				if (security_audit_rule_match(&ctx->ipc.osid,
 							      f->type, f->op,
 							      f->lsm_rule, ctx))
 					++result;
@@ -970,8 +976,9 @@ static inline void audit_free_context(struct audit_context *context)
 }
 
 static int audit_log_pid_context(struct audit_context *context, pid_t pid,
-				 kuid_t auid, kuid_t uid, unsigned int sessionid,
-				 u32 sid, char *comm)
+				 kuid_t auid, kuid_t uid,
+				 unsigned int sessionid, struct secids *sid,
+				 char *comm)
 {
 	struct audit_buffer *ab;
 	char *ctx = NULL;
@@ -985,7 +992,7 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 	audit_log_format(ab, "opid=%d oauid=%d ouid=%d oses=%d", pid,
 			 from_kuid(&init_user_ns, auid),
 			 from_kuid(&init_user_ns, uid), sessionid);
-	if (sid) {
+	if (!lsm_zero_secid(sid)) {
 		if (security_secid_to_secctx(sid, &ctx, &len)) {
 			audit_log_format(ab, " obj=(none)");
 			rc = 1;
@@ -1204,17 +1211,17 @@ static void show_special(struct audit_context *context, int *call_panic)
 				context->socketcall.args[i]);
 		break; }
 	case AUDIT_IPC: {
-		u32 osid = context->ipc.osid;
+		struct secids *osid = &context->ipc.osid;
 
 		audit_log_format(ab, "ouid=%u ogid=%u mode=%#ho",
 				 from_kuid(&init_user_ns, context->ipc.uid),
 				 from_kgid(&init_user_ns, context->ipc.gid),
 				 context->ipc.mode);
-		if (osid) {
+		if (!lsm_zero_secid(osid)) {
 			char *ctx = NULL;
 			u32 len;
 			if (security_secid_to_secctx(osid, &ctx, &len)) {
-				audit_log_format(ab, " osid=%u", osid);
+				audit_log_format(ab, " osc=%u", osid->si_count);
 				*call_panic = 1;
 			} else {
 				audit_log_format(ab, " obj=%s", ctx);
@@ -1378,7 +1385,7 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 						  axs->target_auid[i],
 						  axs->target_uid[i],
 						  axs->target_sessionid[i],
-						  axs->target_sid[i],
+						  &axs->target_sid[i],
 						  axs->target_comm[i]))
 				call_panic = 1;
 	}
@@ -1387,7 +1394,7 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 	    audit_log_pid_context(context, context->target_pid,
 				  context->target_auid, context->target_uid,
 				  context->target_sessionid,
-				  context->target_sid, context->target_comm))
+				  &context->target_sid, context->target_comm))
 			call_panic = 1;
 
 	if (context->pwd.dentry && context->pwd.mnt) {
@@ -1533,7 +1540,7 @@ void __audit_syscall_exit(int success, long return_code)
 	context->aux = NULL;
 	context->aux_pids = NULL;
 	context->target_pid = 0;
-	context->target_sid = 0;
+	lsm_init_secid(&context->target_sid, 0, 0);
 	context->sockaddr_len = 0;
 	context->type = 0;
 	context->fds[0] = -1;
diff --git a/kernel/cred.c b/kernel/cred.c
index e0573a4..c94a3ff 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -641,7 +641,7 @@ EXPORT_SYMBOL(prepare_kernel_cred);
  * Set the LSM security ID in a set of credentials so that the subjective
  * security is overridden when an alternative set of credentials is used.
  */
-int set_security_override(struct cred *new, u32 secid)
+int set_security_override(struct cred *new, struct secids *secid)
 {
 	return security_kernel_act_as(new, secid);
 }
@@ -659,14 +659,14 @@ EXPORT_SYMBOL(set_security_override);
  */
 int set_security_override_from_ctx(struct cred *new, const char *secctx)
 {
-	u32 secid;
+	struct secids secid;
 	int ret;
 
 	ret = security_secctx_to_secid(secctx, strlen(secctx), &secid);
 	if (ret < 0)
 		return ret;
 
-	return set_security_override(new, secid);
+	return set_security_override(new, &secid);
 }
 EXPORT_SYMBOL(set_security_override_from_ctx);
 
diff --git a/kernel/signal.c b/kernel/signal.c
index 113411b..ce19c78 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -19,6 +19,7 @@
 #include <linux/binfmts.h>
 #include <linux/coredump.h>
 #include <linux/security.h>
+#include <linux/lsm.h>
 #include <linux/syscalls.h>
 #include <linux/ptrace.h>
 #include <linux/signal.h>
@@ -789,6 +790,7 @@ static int check_kill_permission(int sig, struct siginfo *info,
 {
 	struct pid *sid;
 	int error;
+	struct secids secid;
 
 	if (!valid_signal(sig))
 		return -EINVAL;
@@ -816,7 +818,8 @@ static int check_kill_permission(int sig, struct siginfo *info,
 		}
 	}
 
-	return security_task_kill(t, info, sig, 0);
+	lsm_init_secid(&secid, 0, 0);
+	return security_task_kill(t, info, sig, &secid);
 }
 
 /**
@@ -1390,7 +1393,7 @@ static int kill_as_cred_perm(const struct cred *cred,
 
 /* like kill_pid_info(), but doesn't use uid/euid of "current" */
 int kill_pid_info_as_cred(int sig, struct siginfo *info, struct pid *pid,
-			 const struct cred *cred, u32 secid)
+			 const struct cred *cred, struct secids *secid)
 {
 	int ret = -EINVAL;
 	struct task_struct *p;
diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 667c1d4..1b47808 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -45,6 +45,7 @@
 #include <linux/jhash.h>
 #include <linux/audit.h>
 #include <linux/slab.h>
+#include <linux/lsm.h>
 #include <net/ip.h>
 #include <net/icmp.h>
 #include <net/tcp.h>
@@ -1569,7 +1570,7 @@ static int cipso_v4_gentag_loc(const struct cipso_v4_doi *doi_def,
 
 	buffer[0] = CIPSO_V4_TAG_LOCAL;
 	buffer[1] = CIPSO_V4_TAG_LOC_BLEN;
-	*(u32 *)&buffer[2] = secattr->attr.secid;
+	*(u32 *)&buffer[2] = lsm_get_secid(&secattr->attr.secid, 0);
 
 	return CIPSO_V4_TAG_LOC_BLEN;
 }
@@ -1589,7 +1590,10 @@ static int cipso_v4_parsetag_loc(const struct cipso_v4_doi *doi_def,
 				 const unsigned char *tag,
 				 struct netlbl_lsm_secattr *secattr)
 {
-	secattr->attr.secid = *(u32 *)&tag[2];
+	u32 secid;
+
+	secid = *(u32 *)&tag[2];
+	lsm_init_secid(&secattr->attr.secid, secid, 0);
 	secattr->flags |= NETLBL_SECATTR_SECID;
 
 	return 0;
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index d9c4f11..a55f8c0 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -108,14 +108,15 @@ static void ip_cmsg_recv_retopts(struct msghdr *msg, struct sk_buff *skb)
 static void ip_cmsg_recv_security(struct msghdr *msg, struct sk_buff *skb)
 {
 	char *secdata;
-	u32 seclen, secid;
+	u32 seclen;
+	struct secids secid;
 	int err;
 
 	err = security_socket_getpeersec_dgram(NULL, skb, &secid);
 	if (err)
 		return;
 
-	err = security_secid_to_secctx(secid, &secdata, &seclen);
+	err = security_secid_to_secctx(&secid, &secdata, &seclen);
 	if (err)
 		return;
 
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
index 4c48e43..f7704fe 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
@@ -13,6 +13,7 @@
 #include <linux/seq_file.h>
 #include <linux/percpu.h>
 #include <linux/security.h>
+#include <linux/lsm.h>
 #include <net/net_namespace.h>
 
 #include <linux/netfilter.h>
@@ -99,8 +100,10 @@ static int ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 	int ret;
 	u32 len;
 	char *secctx;
+	struct secids secid;
 
-	ret = security_secid_to_secctx(ct->secmark, &secctx, &len);
+	lsm_init_secid(&secid, ct->secmark, 0);
+	ret = security_secid_to_secctx(&secid, &secctx, &len);
 	if (ret)
 		return 0;
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index ecf065f..d45138e 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -23,6 +23,7 @@
 #include <linux/types.h>
 #include <linux/timer.h>
 #include <linux/security.h>
+#include <linux/lsm.h>
 #include <linux/skbuff.h>
 #include <linux/errno.h>
 #include <linux/netlink.h>
@@ -301,8 +302,10 @@ ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 	struct nlattr *nest_secctx;
 	int len, ret;
 	char *secctx;
+	struct secids secid;
 
-	ret = security_secid_to_secctx(ct->secmark, &secctx, &len);
+	lsm_init_secid(&secid, ct->secmark, 0);
+	ret = security_secid_to_secctx(&secid, &secctx, &len);
 	if (ret)
 		return 0;
 
@@ -548,8 +551,10 @@ ctnetlink_secctx_size(const struct nf_conn *ct)
 {
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
 	int len, ret;
+	struct secids secid;
 
-	ret = security_secid_to_secctx(ct->secmark, NULL, &len);
+	lsm_init_secid(&secid, ct->secmark, 0);
+	ret = security_secid_to_secctx(&secid, NULL, &len);
 	if (ret)
 		return 0;
 
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index bd700b4..831116a 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -17,6 +17,7 @@
 #include <linux/percpu.h>
 #include <linux/netdevice.h>
 #include <linux/security.h>
+#include <linux/lsm.h>
 #include <net/net_namespace.h>
 #ifdef CONFIG_SYSCTL
 #include <linux/sysctl.h>
@@ -124,8 +125,10 @@ static int ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 	int ret;
 	u32 len;
 	char *secctx;
+	struct secids secid;
 
-	ret = security_secid_to_secctx(ct->secmark, &secctx, &len);
+	lsm_init_secid(&secid, ct->secmark, 0);
+	ret = security_secid_to_secctx(&secid, &secctx, &len);
 	if (ret)
 		return 0;
 
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index 9faf5e0..823ed01 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -15,6 +15,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/module.h>
 #include <linux/security.h>
+#include <linux/lsm.h>
 #include <linux/skbuff.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_SECMARK.h>
@@ -52,24 +53,26 @@ secmark_tg(struct sk_buff *skb, const struct xt_action_param *par)
 static int checkentry_lsm(struct xt_secmark_target_info *info)
 {
 	int err;
+	struct secids secid;
 
 	info->secctx[SECMARK_SECCTX_MAX - 1] = '\0';
 	info->secid = 0;
 
 	err = security_secctx_to_secid(info->secctx, strlen(info->secctx),
-				       &info->secid);
+				       &secid);
 	if (err) {
 		if (err == -EINVAL)
 			pr_info("invalid security context \'%s\'\n", info->secctx);
 		return err;
 	}
 
+	info->secid = lsm_get_secid(&secid, 0);
 	if (!info->secid) {
 		pr_info("unable to map security context \'%s\'\n", info->secctx);
 		return -ENOENT;
 	}
 
-	err = security_secmark_relabel_packet(info->secid);
+	err = security_secmark_relabel_packet(&secid);
 	if (err) {
 		pr_info("unable to obtain relabeling permission\n");
 		return err;
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index 8a6c6ea..cd1e571 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -81,7 +81,7 @@ struct netlbl_unlhsh_tbl {
 #define netlbl_unlhsh_addr4_entry(iter) \
 	container_of(iter, struct netlbl_unlhsh_addr4, list)
 struct netlbl_unlhsh_addr4 {
-	u32 secid;
+	struct secids secid;
 
 	struct netlbl_af4list list;
 	struct rcu_head rcu;
@@ -89,7 +89,7 @@ struct netlbl_unlhsh_addr4 {
 #define netlbl_unlhsh_addr6_entry(iter) \
 	container_of(iter, struct netlbl_unlhsh_addr6, list)
 struct netlbl_unlhsh_addr6 {
-	u32 secid;
+	struct secids secid;
 
 	struct netlbl_af6list list;
 	struct rcu_head rcu;
@@ -263,7 +263,7 @@ static int netlbl_unlhsh_add_addr4(struct netlbl_unlhsh_iface *iface,
 	entry->list.addr = addr->s_addr & mask->s_addr;
 	entry->list.mask = mask->s_addr;
 	entry->list.valid = 1;
-	entry->secid = secid;
+	lsm_init_secid(&entry->secid, secid, 0);
 
 	spin_lock(&netlbl_unlhsh_lock);
 	ret_val = netlbl_af4list_add(&entry->list, &iface->addr4_list);
@@ -307,7 +307,7 @@ static int netlbl_unlhsh_add_addr6(struct netlbl_unlhsh_iface *iface,
 	entry->list.addr.s6_addr32[3] &= mask->s6_addr32[3];
 	entry->list.mask = *mask;
 	entry->list.valid = 1;
-	entry->secid = secid;
+	lsm_init_secid(&entry->secid, secid, 0);
 
 	spin_lock(&netlbl_unlhsh_lock);
 	ret_val = netlbl_af6list_add(&entry->list, &iface->addr6_list);
@@ -394,6 +394,7 @@ int netlbl_unlhsh_add(struct net *net,
 	struct net_device *dev;
 	struct netlbl_unlhsh_iface *iface;
 	struct audit_buffer *audit_buf = NULL;
+	struct secids secids;
 	char *secctx = NULL;
 	u32 secctx_len;
 
@@ -458,7 +459,8 @@ int netlbl_unlhsh_add(struct net *net,
 unlhsh_add_return:
 	rcu_read_unlock();
 	if (audit_buf != NULL) {
-		if (security_secid_to_secctx(secid,
+		lsm_init_secid(&secids, secid, 0);
+		if (security_secid_to_secctx(&secids,
 					     &secctx,
 					     &secctx_len) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s", secctx);
@@ -515,7 +517,7 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 		if (dev != NULL)
 			dev_put(dev);
 		if (entry != NULL &&
-		    security_secid_to_secctx(entry->secid,
+		    security_secid_to_secctx(&entry->secid,
 					     &secctx, &secctx_len) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s", secctx);
 			security_release_secctx(secctx, secctx_len);
@@ -576,7 +578,7 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 		if (dev != NULL)
 			dev_put(dev);
 		if (entry != NULL &&
-		    security_secid_to_secctx(entry->secid,
+		    security_secid_to_secctx(&entry->secid,
 					     &secctx, &secctx_len) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s", secctx);
 			security_release_secctx(secctx, secctx_len);
@@ -902,7 +904,7 @@ static int netlbl_unlabel_staticadd(struct sk_buff *skb,
 	void *addr;
 	void *mask;
 	u32 addr_len;
-	u32 secid;
+	struct secids secid;
 	struct netlbl_audit audit_info;
 
 	/* Don't allow users to add both IPv4 and IPv6 addresses for a
@@ -931,7 +933,8 @@ static int netlbl_unlabel_staticadd(struct sk_buff *skb,
 		return ret_val;
 
 	return netlbl_unlhsh_add(&init_net,
-				 dev_name, addr, mask, addr_len, secid,
+				 dev_name, addr, mask, addr_len,
+				 lsm_get_secid(&secid, 0),
 				 &audit_info);
 }
 
@@ -953,7 +956,7 @@ static int netlbl_unlabel_staticadddef(struct sk_buff *skb,
 	void *addr;
 	void *mask;
 	u32 addr_len;
-	u32 secid;
+	struct secids secid;
 	struct netlbl_audit audit_info;
 
 	/* Don't allow users to add both IPv4 and IPv6 addresses for a
@@ -980,7 +983,8 @@ static int netlbl_unlabel_staticadddef(struct sk_buff *skb,
 		return ret_val;
 
 	return netlbl_unlhsh_add(&init_net,
-				 NULL, addr, mask, addr_len, secid,
+				 NULL, addr, mask, addr_len,
+				 lsm_get_secid(&secid, 0),
 				 &audit_info);
 }
 
@@ -1092,7 +1096,7 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 	struct netlbl_unlhsh_walk_arg *cb_arg = arg;
 	struct net_device *dev;
 	void *data;
-	u32 secid;
+	struct secids *secid;
 	char *secctx;
 	u32 secctx_len;
 
@@ -1134,7 +1138,7 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 		if (ret_val != 0)
 			goto list_cb_failure;
 
-		secid = addr4->secid;
+		secid = &addr4->secid;
 	} else {
 		ret_val = nla_put(cb_arg->skb,
 				  NLBL_UNLABEL_A_IPV6ADDR,
@@ -1150,7 +1154,7 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 		if (ret_val != 0)
 			goto list_cb_failure;
 
-		secid = addr6->secid;
+		secid = &addr6->secid;
 	}
 
 	ret_val = security_secid_to_secctx(secid, &secctx, &secctx_len);
diff --git a/net/netlabel/netlabel_user.c b/net/netlabel/netlabel_user.c
index 9650c4a..898153c 100644
--- a/net/netlabel/netlabel_user.c
+++ b/net/netlabel/netlabel_user.c
@@ -35,6 +35,7 @@
 #include <linux/audit.h>
 #include <linux/tty.h>
 #include <linux/security.h>
+#include <linux/lsm.h>
 #include <linux/gfp.h>
 #include <net/sock.h>
 #include <net/netlink.h>
@@ -112,8 +113,8 @@ struct audit_buffer *netlbl_audit_start_common(int type,
 			 from_kuid(&init_user_ns, audit_info->loginuid),
 			 audit_info->sessionid);
 
-	if (audit_info->secid != 0 &&
-	    security_secid_to_secctx(audit_info->secid,
+	if (!lsm_zero_secid(&audit_info->secid) &&
+	    security_secid_to_secctx(&audit_info->secid,
 				     &secctx,
 				     &secctx_len) == 0) {
 		audit_log_format(audit_buf, " subj=%s", secctx);
diff --git a/net/netlabel/netlabel_user.h b/net/netlabel/netlabel_user.h
index 8196978..f23656b 100644
--- a/net/netlabel/netlabel_user.h
+++ b/net/netlabel/netlabel_user.h
@@ -35,6 +35,7 @@
 #include <linux/skbuff.h>
 #include <linux/capability.h>
 #include <linux/audit.h>
+#include <linux/lsm.h>
 #include <net/netlink.h>
 #include <net/genetlink.h>
 #include <net/netlabel.h>
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 826e099..964bbe3 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -137,12 +137,16 @@ static struct hlist_head *unix_sockets_unbound(void *addr)
 #ifdef CONFIG_SECURITY_NETWORK
 static void unix_get_secdata(struct scm_cookie *scm, struct sk_buff *skb)
 {
-	memcpy(UNIXSID(skb), &scm->secid, sizeof(u32));
+	struct secids *skb_secid = UNIXSID(skb);
+
+	*skb_secid = scm->secid;
 }
 
 static inline void unix_set_secdata(struct scm_cookie *scm, struct sk_buff *skb)
 {
-	scm->secid = *UNIXSID(skb);
+	struct secids *skb_secid = UNIXSID(skb);
+
+	scm->secid = *skb_secid;
 }
 #else
 static inline void unix_get_secdata(struct scm_cookie *scm, struct sk_buff *skb)
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 3f565e4..85f6bca 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -23,6 +23,7 @@
 #include <linux/ipsec.h>
 #include <linux/init.h>
 #include <linux/security.h>
+#include <linux/lsm.h>
 #include <net/sock.h>
 #include <net/xfrm.h>
 #include <net/netlink.h>
@@ -601,6 +602,7 @@ static int xfrm_add_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
 	kuid_t loginuid = audit_get_loginuid(current);
 	u32 sessionid = audit_get_sessionid(current);
 	u32 sid;
+	struct secids sids;
 
 	err = verify_newsa_info(p, attrs);
 	if (err)
@@ -616,7 +618,8 @@ static int xfrm_add_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
 	else
 		err = xfrm_state_update(x);
 
-	security_task_getsecid(current, &sid);
+	security_task_getsecid(current, &sids);
+	sid = lsm_get_secid(&sids, 0);
 	xfrm_audit_state_add(x, err ? 0 : 1, loginuid, sessionid, sid);
 
 	if (err < 0) {
@@ -680,6 +683,7 @@ static int xfrm_del_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
 	kuid_t loginuid = audit_get_loginuid(current);
 	u32 sessionid = audit_get_sessionid(current);
 	u32 sid;
+	struct secids sids;
 
 	x = xfrm_user_state_lookup(net, p, attrs, &err);
 	if (x == NULL)
@@ -704,7 +708,8 @@ static int xfrm_del_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
 	km_state_notify(x, &c);
 
 out:
-	security_task_getsecid(current, &sid);
+	security_task_getsecid(current, &sids);
+	sid = lsm_get_secid(&sids, 0);
 	xfrm_audit_state_delete(x, err ? 0 : 1, loginuid, sessionid, sid);
 	xfrm_state_put(x);
 	return err;
@@ -1406,6 +1411,7 @@ static int xfrm_add_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 	kuid_t loginuid = audit_get_loginuid(current);
 	u32 sessionid = audit_get_sessionid(current);
 	u32 sid;
+	struct secids sids;
 
 	err = verify_newpolicy_info(p);
 	if (err)
@@ -1424,7 +1430,8 @@ static int xfrm_add_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 	 * a type XFRM_MSG_UPDPOLICY - JHS */
 	excl = nlh->nlmsg_type == XFRM_MSG_NEWPOLICY;
 	err = xfrm_policy_insert(p->dir, xp, excl);
-	security_task_getsecid(current, &sid);
+	security_task_getsecid(current, &sids);
+	sid = lsm_get_secid(&sids, 0);
 	xfrm_audit_policy_add(xp, err ? 0 : 1, loginuid, sessionid, sid);
 
 	if (err) {
@@ -1664,8 +1671,10 @@ static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 		kuid_t loginuid = audit_get_loginuid(current);
 		u32 sessionid = audit_get_sessionid(current);
 		u32 sid;
+		struct secids sids;
 
-		security_task_getsecid(current, &sid);
+		security_task_getsecid(current, &sids);
+		sid = lsm_get_secid(&sids, 0);
 		xfrm_audit_policy_delete(xp, err ? 0 : 1, loginuid, sessionid,
 					 sid);
 
@@ -1693,11 +1702,13 @@ static int xfrm_flush_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct km_event c;
 	struct xfrm_usersa_flush *p = nlmsg_data(nlh);
 	struct xfrm_audit audit_info;
+	struct secids secid;
 	int err;
 
 	audit_info.loginuid = audit_get_loginuid(current);
 	audit_info.sessionid = audit_get_sessionid(current);
-	security_task_getsecid(current, &audit_info.secid);
+	security_task_getsecid(current, &secid);
+	audit_info.secid = lsm_get_secid(&secid, 0);
 	err = xfrm_state_flush(net, p->proto, &audit_info);
 	if (err) {
 		if (err == -ESRCH) /* empty table */
@@ -1883,6 +1894,7 @@ static int xfrm_flush_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 	u8 type = XFRM_POLICY_TYPE_MAIN;
 	int err;
 	struct xfrm_audit audit_info;
+	struct secids secid;
 
 	err = copy_from_user_policy_type(&type, attrs);
 	if (err)
@@ -1890,7 +1902,8 @@ static int xfrm_flush_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	audit_info.loginuid = audit_get_loginuid(current);
 	audit_info.sessionid = audit_get_sessionid(current);
-	security_task_getsecid(current, &audit_info.secid);
+	security_task_getsecid(current, &secid);
+	audit_info.secid = lsm_get_secid(&secid, 0);
 	err = xfrm_policy_flush(net, type, &audit_info);
 	if (err) {
 		if (err == -ESRCH) /* empty table */
@@ -1960,8 +1973,10 @@ static int xfrm_add_pol_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
 		kuid_t loginuid = audit_get_loginuid(current);
 		u32 sessionid = audit_get_sessionid(current);
 		u32 sid;
+		struct secids sids;
 
-		security_task_getsecid(current, &sid);
+		security_task_getsecid(current, &sids);
+		sid = lsm_get_secid(&sids, 0);
 		xfrm_policy_delete(xp, p->dir);
 		xfrm_audit_policy_delete(xp, 1, loginuid, sessionid, sid);
 
@@ -2003,8 +2018,10 @@ static int xfrm_add_sa_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
 		kuid_t loginuid = audit_get_loginuid(current);
 		u32 sessionid = audit_get_sessionid(current);
 		u32 sid;
+		struct secids sids;
 
-		security_task_getsecid(current, &sid);
+		security_task_getsecid(current, &sids);
+		sid = lsm_get_secid(&sids, 0);
 		__xfrm_state_delete(x);
 		xfrm_audit_state_delete(x, 1, loginuid, sessionid, sid);
 	}
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
diff --git a/security/apparmor/include/apparmor.h b/security/apparmor/include/apparmor.h
index 40aedd9..e94439a 100644
--- a/security/apparmor/include/apparmor.h
+++ b/security/apparmor/include/apparmor.h
@@ -61,6 +61,9 @@ extern unsigned int aa_g_path_max;
 /* Flag indicating whether initialization completed */
 extern int apparmor_initialized __initdata;
 
+extern struct security_operations apparmor_ops;
+
+
 /* fn's in lib */
 char *aa_split_fqname(char *args, char **ns_name);
 void aa_info_message(const char *str);
diff --git a/security/apparmor/include/context.h b/security/apparmor/include/context.h
index a9cbee4..d844ae0 100644
--- a/security/apparmor/include/context.h
+++ b/security/apparmor/include/context.h
@@ -18,6 +18,7 @@
 #include <linux/cred.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/lsm.h>
 
 #include "policy.h"
 
@@ -89,7 +90,8 @@ int aa_restore_previous_profile(u64 cookie);
  */
 static inline bool __aa_task_is_confined(struct task_struct *task)
 {
-	struct aa_task_cxt *cxt = __task_cred(task)->security;
+	struct aa_task_cxt *cxt =
+		lsm_get_cred(__task_cred(task), &apparmor_ops);
 
 	BUG_ON(!cxt || !cxt->profile);
 	if (unconfined(aa_newest_version(cxt->profile)))
@@ -108,7 +110,7 @@ static inline bool __aa_task_is_confined(struct task_struct *task)
  */
 static inline struct aa_profile *aa_cred_profile(const struct cred *cred)
 {
-	struct aa_task_cxt *cxt = cred->security;
+	struct aa_task_cxt *cxt = lsm_get_cred(cred, &apparmor_ops);
 	BUG_ON(!cxt || !cxt->profile);
 	return aa_newest_version(cxt->profile);
 }
@@ -136,7 +138,8 @@ static inline struct aa_profile *__aa_current_profile(void)
  */
 static inline struct aa_profile *aa_current_profile(void)
 {
-	const struct aa_task_cxt *cxt = current_cred()->security;
+	const struct aa_task_cxt *cxt =
+		lsm_get_cred(current_cred(), &apparmor_ops);
 	struct aa_profile *profile;
 	BUG_ON(!cxt || !cxt->profile);
 
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index b21830e..64557a0 100644
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
 
@@ -418,14 +418,14 @@ static int apparmor_file_alloc_security(struct file *file)
 
 static void apparmor_file_free_security(struct file *file)
 {
-	struct aa_file_cxt *cxt = file->f_security;
+	struct aa_file_cxt *cxt = lsm_get_file(file, &apparmor_ops);
 
 	aa_free_file_context(cxt);
 }
 
 static int common_file_perm(int op, struct file *file, u32 mask)
 {
-	struct aa_file_cxt *fcxt = file->f_security;
+	struct aa_file_cxt *fcxt = lsm_get_file(file, &apparmor_ops);
 	struct aa_profile *profile, *fprofile = aa_cred_profile(file->f_cred);
 	int error = 0;
 
@@ -472,7 +472,7 @@ static int common_mmap(int op, struct file *file, unsigned long prot,
 	struct dentry *dentry;
 	int mask = 0;
 
-	if (!file || !file->f_security)
+	if (!file || !lsm_get_file(file, &apparmor_ops))
 		return 0;
 
 	if (prot & PROT_READ)
@@ -510,7 +510,7 @@ static int apparmor_getprocattr(struct task_struct *task, char *name,
 	struct aa_profile *profile;
 	/* released below */
 	const struct cred *cred = get_task_cred(task);
-	struct aa_task_cxt *cxt = cred->security;
+	struct aa_task_cxt *cxt = lsm_get_cred(cred, &apparmor_ops);
 	profile = aa_cred_profile(cred);
 
 	if (strcmp(name, "current") == 0)
@@ -614,7 +614,7 @@ static int apparmor_task_setrlimit(struct task_struct *task,
 	return error;
 }
 
-static struct security_operations apparmor_ops = {
+struct security_operations apparmor_ops = {
 	.name =				"apparmor",
 
 	.ptrace_access_check =		apparmor_ptrace_access_check,
@@ -886,7 +886,7 @@ static int __init set_init_cxt(void)
 		return -ENOMEM;
 
 	cxt->profile = aa_get_profile(root_ns->unconfined);
-	cred->security = cxt;
+	lsm_set_cred(cred, cxt, &apparmor_ops);
 
 	return 0;
 }
@@ -931,7 +931,7 @@ static int __init apparmor_init(void)
 	return error;
 
 set_init_cxt_out:
-	aa_free_task_context(current->real_cred->security);
+	aa_free_task_context(lsm_get_cred(current->real_cred, &apparmor_ops));
 
 register_security_out:
 	aa_free_root_ns();
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index a41c9c1..b922449 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -192,8 +192,8 @@ static inline int security_filter_rule_init(u32 field, u32 op, char *rulestr,
 	return -EINVAL;
 }
 
-static inline int security_filter_rule_match(u32 secid, u32 field, u32 op,
-					     void *lsmrule,
+static inline int security_filter_rule_match(struct secids *secid, u32 field,
+					     u32 op, void *lsmrule,
 					     struct audit_context *actx)
 {
 	return -EINVAL;
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 399433a..a0a4e90 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -184,7 +184,7 @@ static bool ima_match_rules(struct ima_rule_entry *rule,
 		return false;
 	for (i = 0; i < MAX_LSM_RULES; i++) {
 		int rc = 0;
-		u32 osid, sid;
+		struct secids osid, sid;
 		int retried = 0;
 
 		if (!rule->lsm[i].rule)
@@ -195,7 +195,7 @@ retry:
 		case LSM_OBJ_ROLE:
 		case LSM_OBJ_TYPE:
 			security_inode_getsecid(inode, &osid);
-			rc = security_filter_rule_match(osid,
+			rc = security_filter_rule_match(&osid,
 							rule->lsm[i].type,
 							Audit_equal,
 							rule->lsm[i].rule,
@@ -205,7 +205,7 @@ retry:
 		case LSM_SUBJ_ROLE:
 		case LSM_SUBJ_TYPE:
 			security_task_getsecid(tsk, &sid);
-			rc = security_filter_rule_match(sid,
+			rc = security_filter_rule_match(&sid,
 							rule->lsm[i].type,
 							Audit_equal,
 							rule->lsm[i].rule,
diff --git a/security/security.c b/security/security.c
index a3dce87..19759ad 100644
--- a/security/security.c
+++ b/security/security.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/security.h>
+#include <linux/lsm.h>
 #include <linux/integrity.h>
 #include <linux/ima.h>
 #include <linux/evm.h>
@@ -648,9 +649,12 @@ int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer
 	return security_ops->inode_listsecurity(inode, buffer, buffer_size);
 }
 
-void security_inode_getsecid(const struct inode *inode, u32 *secid)
+void security_inode_getsecid(const struct inode *inode, struct secids *secid)
 {
-	security_ops->inode_getsecid(inode, secid);
+	u32 sid;
+
+	security_ops->inode_getsecid(inode, &sid);
+	lsm_init_secid(secid, sid, 0);
 }
 
 int security_file_permission(struct file *file, int mask)
@@ -805,9 +809,9 @@ void security_transfer_creds(struct cred *new, const struct cred *old)
 	security_ops->cred_transfer(new, old);
 }
 
-int security_kernel_act_as(struct cred *new, u32 secid)
+int security_kernel_act_as(struct cred *new, struct secids *secid)
 {
-	return security_ops->kernel_act_as(new, secid);
+	return security_ops->kernel_act_as(new, lsm_get_secid(secid, 0));
 }
 
 int security_kernel_create_files_as(struct cred *new, struct inode *inode)
@@ -851,9 +855,12 @@ int security_task_getsid(struct task_struct *p)
 	return security_ops->task_getsid(p);
 }
 
-void security_task_getsecid(struct task_struct *p, u32 *secid)
+void security_task_getsecid(struct task_struct *p, struct secids *secid)
 {
-	security_ops->task_getsecid(p, secid);
+	u32 sid;
+
+	security_ops->task_getsecid(p, &sid);
+	lsm_init_secid(secid, sid, 0);
 }
 EXPORT_SYMBOL(security_task_getsecid);
 
@@ -894,9 +901,9 @@ int security_task_movememory(struct task_struct *p)
 }
 
 int security_task_kill(struct task_struct *p, struct siginfo *info,
-			int sig, u32 secid)
+			int sig, struct secids *secid)
 {
-	return security_ops->task_kill(p, info, sig, secid);
+	return security_ops->task_kill(p, info, sig, lsm_get_secid(secid, 0));
 }
 
 int security_task_wait(struct task_struct *p)
@@ -926,9 +933,12 @@ int security_ipc_permission(struct kern_ipc_perm *ipcp, short flag)
 	return security_ops->ipc_permission(ipcp, flag);
 }
 
-void security_ipc_getsecid(struct kern_ipc_perm *ipcp, u32 *secid)
+void security_ipc_getsecid(struct kern_ipc_perm *ipcp, struct secids *secid)
 {
-	security_ops->ipc_getsecid(ipcp, secid);
+	u32 sid;
+
+	security_ops->ipc_getsecid(ipcp, &sid);
+	lsm_init_secid(secid, sid, 0);
 }
 
 int security_msg_msg_alloc(struct msg_msg *msg)
@@ -1047,15 +1057,22 @@ int security_netlink_send(struct sock *sk, struct sk_buff *skb)
 	return security_ops->netlink_send(sk, skb);
 }
 
-int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
+int security_secid_to_secctx(struct secids *secid, char **secdata, u32 *seclen)
 {
-	return security_ops->secid_to_secctx(secid, secdata, seclen);
+	return security_ops->secid_to_secctx(lsm_get_secid(secid, 0),
+						secdata, seclen);
 }
 EXPORT_SYMBOL(security_secid_to_secctx);
 
-int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid)
+int security_secctx_to_secid(const char *secdata, u32 seclen,
+				struct secids *secid)
 {
-	return security_ops->secctx_to_secid(secdata, seclen, secid);
+	u32 sid;
+	int rc;
+
+	rc = security_ops->secctx_to_secid(secdata, seclen, &sid);
+	lsm_init_secid(secid, sid, 0);
+	return rc;
 }
 EXPORT_SYMBOL(security_secctx_to_secid);
 
@@ -1177,9 +1194,15 @@ int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
 	return security_ops->socket_getpeersec_stream(sock, optval, optlen, len);
 }
 
-int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb, u32 *secid)
+int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb,
+					struct secids *secid)
 {
-	return security_ops->socket_getpeersec_dgram(sock, skb, secid);
+	u32 sid;
+	int rc;
+
+	rc = security_ops->socket_getpeersec_dgram(sock, skb, &sid);
+	lsm_init_secid(secid, sid, 0);
+	return rc;
 }
 EXPORT_SYMBOL(security_socket_getpeersec_dgram);
 
@@ -1236,9 +1259,9 @@ void security_inet_conn_established(struct sock *sk,
 	security_ops->inet_conn_established(sk, skb);
 }
 
-int security_secmark_relabel_packet(u32 secid)
+int security_secmark_relabel_packet(struct secids *secid)
 {
-	return security_ops->secmark_relabel_packet(secid);
+	return security_ops->secmark_relabel_packet(lsm_get_secid(secid, 0));
 }
 EXPORT_SYMBOL(security_secmark_relabel_packet);
 
@@ -1351,7 +1374,8 @@ void security_xfrm_state_free(struct xfrm_state *x)
 	security_ops->xfrm_state_free_security(x);
 }
 
-int security_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir)
+int security_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx,
+				u32 fl_secid, u8 dir)
 {
 	return security_ops->xfrm_policy_lookup(ctx, fl_secid, dir);
 }
@@ -1421,10 +1445,11 @@ void security_audit_rule_free(void *lsmrule)
 	security_ops->audit_rule_free(lsmrule);
 }
 
-int security_audit_rule_match(u32 secid, u32 field, u32 op, void *lsmrule,
-			      struct audit_context *actx)
+int security_audit_rule_match(struct secids *secid, u32 field, u32 op,
+			      void *lsmrule, struct audit_context *actx)
 {
-	return security_ops->audit_rule_match(secid, field, op, lsmrule, actx);
+	return security_ops->audit_rule_match(lsm_get_secid(secid, 0), field,
+						op, lsmrule, actx);
 }
 
 #endif /* CONFIG_AUDIT */
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 5c6f2cd..4cd7556 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -30,6 +30,7 @@
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/security.h>
+#include <linux/lsm.h>
 #include <linux/xattr.h>
 #include <linux/capability.h>
 #include <linux/unistd.h>
@@ -159,7 +160,7 @@ static void cred_init_security(void)
 		panic("SELinux:  Failed to initialize initial task.\n");
 
 	tsec->osid = tsec->sid = SECINITSID_KERNEL;
-	cred->security = tsec;
+	lsm_set_cred(cred, tsec, &selinux_ops);
 }
 
 /*
@@ -169,7 +170,7 @@ static inline u32 cred_sid(const struct cred *cred)
 {
 	const struct task_security_struct *tsec;
 
-	tsec = cred->security;
+	tsec = lsm_get_cred(cred, &selinux_ops);
 	return tsec->sid;
 }
 
@@ -191,7 +192,8 @@ static inline u32 task_sid(const struct task_struct *task)
  */
 static inline u32 current_sid(void)
 {
-	const struct task_security_struct *tsec = current_security();
+	const struct task_security_struct *tsec =
+		lsm_get_cred(current_cred(), &selinux_ops);
 
 	return tsec->sid;
 }
@@ -213,22 +215,23 @@ static int inode_alloc_security(struct inode *inode)
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
+		lsm_get_super(inode->i_sb, &selinux_ops);
 
 	spin_lock(&sbsec->isec_lock);
 	if (!list_empty(&isec->list))
 		list_del_init(&isec->list);
 	spin_unlock(&sbsec->isec_lock);
 
-	inode->i_security = NULL;
+	lsm_set_inode(inode, NULL, &selinux_ops);
 	kmem_cache_free(sel_inode_cache, isec);
 }
 
@@ -243,15 +246,15 @@ static int file_alloc_security(struct file *file)
 
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
 
@@ -270,15 +273,16 @@ static int superblock_alloc_security(struct super_block *sb)
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
+		lsm_get_super(sb, &selinux_ops);
+	lsm_set_super(sb, NULL, &selinux_ops);
 	kfree(sbsec);
 }
 
@@ -324,7 +328,8 @@ static int may_context_mount_sb_relabel(u32 sid,
 			struct superblock_security_struct *sbsec,
 			const struct cred *cred)
 {
-	const struct task_security_struct *tsec = cred->security;
+	const struct task_security_struct *tsec =
+		lsm_get_cred(cred, &selinux_ops);
 	int rc;
 
 	rc = avc_has_perm(tsec->sid, sbsec->sid, SECCLASS_FILESYSTEM,
@@ -341,7 +346,8 @@ static int may_context_mount_inode_relabel(u32 sid,
 			struct superblock_security_struct *sbsec,
 			const struct cred *cred)
 {
-	const struct task_security_struct *tsec = cred->security;
+	const struct task_security_struct *tsec =
+		lsm_get_cred(cred, &selinux_ops);
 	int rc;
 	rc = avc_has_perm(tsec->sid, sbsec->sid, SECCLASS_FILESYSTEM,
 			  FILESYSTEM__RELABELFROM, NULL);
@@ -355,7 +361,8 @@ static int may_context_mount_inode_relabel(u32 sid,
 
 static int sb_finish_set_opts(struct super_block *sb)
 {
-	struct superblock_security_struct *sbsec = sb->s_security;
+	struct superblock_security_struct *sbsec =
+		lsm_get_super(sb, &selinux_ops);
 	struct dentry *root = sb->s_root;
 	struct inode *root_inode = root->d_inode;
 	int rc = 0;
@@ -445,7 +452,8 @@ static int selinux_get_mnt_opts(const struct super_block *sb,
 				struct security_mnt_opts *opts)
 {
 	int rc = 0, i;
-	struct superblock_security_struct *sbsec = sb->s_security;
+	struct superblock_security_struct *sbsec =
+		lsm_get_super(sb, &selinux_ops);
 	char *context = NULL;
 	u32 len;
 	char tmp;
@@ -505,7 +513,8 @@ static int selinux_get_mnt_opts(const struct super_block *sb,
 	}
 	if (sbsec->flags & ROOTCONTEXT_MNT) {
 		struct inode *root = sbsec->sb->s_root->d_inode;
-		struct inode_security_struct *isec = root->i_security;
+		struct inode_security_struct *isec =
+			lsm_get_inode(root, &selinux_ops);
 
 		rc = security_sid_to_context(isec->sid, &context, &len);
 		if (rc)
@@ -556,10 +565,12 @@ static int selinux_set_mnt_opts(struct super_block *sb,
 {
 	const struct cred *cred = current_cred();
 	int rc = 0, i;
-	struct superblock_security_struct *sbsec = sb->s_security;
+	struct superblock_security_struct *sbsec =
+		lsm_get_super(sb, &selinux_ops);
 	const char *name = sb->s_type->name;
 	struct inode *inode = sbsec->sb->s_root->d_inode;
-	struct inode_security_struct *root_isec = inode->i_security;
+	struct inode_security_struct *root_isec =
+			lsm_get_inode(inode, &selinux_ops);
 	u32 fscontext_sid = 0, context_sid = 0, rootcontext_sid = 0;
 	u32 defcontext_sid = 0;
 	char **mount_options = opts->mnt_opts;
@@ -754,8 +765,10 @@ out_double_mount:
 static int selinux_cmp_sb_context(const struct super_block *oldsb,
 				    const struct super_block *newsb)
 {
-	struct superblock_security_struct *old = oldsb->s_security;
-	struct superblock_security_struct *new = newsb->s_security;
+	struct superblock_security_struct *old =
+		lsm_get_super(oldsb, &selinux_ops);
+	struct superblock_security_struct *new =
+		lsm_get_super(newsb, &selinux_ops);
 	char oldflags = old->flags & SE_MNTMASK;
 	char newflags = new->flags & SE_MNTMASK;
 
@@ -768,8 +781,10 @@ static int selinux_cmp_sb_context(const struct super_block *oldsb,
 	if ((oldflags & DEFCONTEXT_MNT) && old->def_sid != new->def_sid)
 		goto mismatch;
 	if (oldflags & ROOTCONTEXT_MNT) {
-		struct inode_security_struct *oldroot = oldsb->s_root->d_inode->i_security;
-		struct inode_security_struct *newroot = newsb->s_root->d_inode->i_security;
+		struct inode_security_struct *oldroot =
+			lsm_get_inode(oldsb->s_root->d_inode, &selinux_ops);
+		struct inode_security_struct *newroot =
+			lsm_get_inode(newsb->s_root->d_inode, &selinux_ops);
 		if (oldroot->sid != newroot->sid)
 			goto mismatch;
 	}
@@ -784,8 +799,10 @@ mismatch:
 static int selinux_sb_clone_mnt_opts(const struct super_block *oldsb,
 					struct super_block *newsb)
 {
-	const struct superblock_security_struct *oldsbsec = oldsb->s_security;
-	struct superblock_security_struct *newsbsec = newsb->s_security;
+	const struct superblock_security_struct *oldsbsec =
+		lsm_get_super(oldsb, &selinux_ops);
+	struct superblock_security_struct *newsbsec =
+		lsm_get_super(newsb, &selinux_ops);
 
 	int set_fscontext =	(oldsbsec->flags & FSCONTEXT_MNT);
 	int set_context =	(oldsbsec->flags & CONTEXT_MNT);
@@ -820,16 +837,19 @@ static int selinux_sb_clone_mnt_opts(const struct super_block *oldsb,
 			newsbsec->sid = sid;
 		if (!set_rootcontext) {
 			struct inode *newinode = newsb->s_root->d_inode;
-			struct inode_security_struct *newisec = newinode->i_security;
+			struct inode_security_struct *newisec =
+				lsm_get_inode(newinode, &selinux_ops);
 			newisec->sid = sid;
 		}
 		newsbsec->mntpoint_sid = sid;
 	}
 	if (set_rootcontext) {
 		const struct inode *oldinode = oldsb->s_root->d_inode;
-		const struct inode_security_struct *oldisec = oldinode->i_security;
+		const struct inode_security_struct *oldisec =
+			lsm_get_inode(oldinode, &selinux_ops);
 		struct inode *newinode = newsb->s_root->d_inode;
-		struct inode_security_struct *newisec = newinode->i_security;
+		struct inode_security_struct *newisec =
+			lsm_get_inode(newinode, &selinux_ops);
 
 		newisec->sid = oldisec->sid;
 	}
@@ -1194,7 +1214,8 @@ static int selinux_proc_get_sid(struct dentry *dentry,
 static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dentry)
 {
 	struct superblock_security_struct *sbsec = NULL;
-	struct inode_security_struct *isec = inode->i_security;
+	struct inode_security_struct *isec =
+		lsm_get_inode(inode, &selinux_ops);
 	u32 sid;
 	struct dentry *dentry;
 #define INITCONTEXTLEN 255
@@ -1209,7 +1230,7 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 	if (isec->initialized)
 		goto out_unlock;
 
-	sbsec = inode->i_sb->s_security;
+	sbsec = lsm_get_super(inode->i_sb, &selinux_ops);
 	if (!(sbsec->flags & SE_SBINITIALIZED)) {
 		/* Defer initialization until selinux_complete_init,
 		   after the initial policy is loaded and the security
@@ -1421,8 +1442,10 @@ static int task_has_perm(const struct task_struct *tsk1,
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
@@ -1512,7 +1535,7 @@ static int inode_has_perm(const struct cred *cred,
 		return 0;
 
 	sid = cred_sid(cred);
-	isec = inode->i_security;
+	isec = lsm_get_inode(inode, &selinux_ops);
 
 	return avc_has_perm_flags(sid, isec->sid, isec->sclass, perms, adp, flags);
 }
@@ -1559,7 +1582,7 @@ static int file_has_perm(const struct cred *cred,
 			 struct file *file,
 			 u32 av)
 {
-	struct file_security_struct *fsec = file->f_security;
+	struct file_security_struct *fsec = lsm_get_file(file, &selinux_ops);
 	struct inode *inode = file_inode(file);
 	struct common_audit_data ad;
 	u32 sid = cred_sid(cred);
@@ -1591,15 +1614,16 @@ static int may_create(struct inode *dir,
 		      struct dentry *dentry,
 		      u16 tclass)
 {
-	const struct task_security_struct *tsec = current_security();
+	const struct task_security_struct *tsec =
+		lsm_get_cred(current_cred(), &selinux_ops);
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
@@ -1654,8 +1678,8 @@ static int may_link(struct inode *dir,
 	u32 av;
 	int rc;
 
-	dsec = dir->i_security;
-	isec = dentry->d_inode->i_security;
+	dsec = lsm_get_inode(dir, &selinux_ops);
+	isec = lsm_get_inode(dentry->d_inode, &selinux_ops);
 
 	ad.type = LSM_AUDIT_DATA_DENTRY;
 	ad.u.dentry = dentry;
@@ -1698,10 +1722,10 @@ static inline int may_rename(struct inode *old_dir,
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
 
@@ -1729,7 +1753,7 @@ static inline int may_rename(struct inode *old_dir,
 	if (rc)
 		return rc;
 	if (new_dentry->d_inode) {
-		new_isec = new_dentry->d_inode->i_security;
+		new_isec = lsm_get_inode(new_dentry->d_inode, &selinux_ops);
 		new_is_dir = S_ISDIR(new_dentry->d_inode->i_mode);
 		rc = avc_has_perm(sid, new_isec->sid,
 				  new_isec->sclass,
@@ -1750,7 +1774,7 @@ static int superblock_has_perm(const struct cred *cred,
 	struct superblock_security_struct *sbsec;
 	u32 sid = cred_sid(cred);
 
-	sbsec = sb->s_security;
+	sbsec = lsm_get_super(sb, &selinux_ops);
 	return avc_has_perm(sid, sbsec->sid, SECCLASS_FILESYSTEM, perms, ad);
 }
 
@@ -2001,9 +2025,9 @@ static int selinux_bprm_set_creds(struct linux_binprm *bprm)
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
@@ -2078,7 +2102,8 @@ static int selinux_bprm_set_creds(struct linux_binprm *bprm)
 			rcu_read_lock();
 			tracer = ptrace_parent(current);
 			if (likely(tracer != NULL)) {
-				sec = __task_cred(tracer)->security;
+				sec = lsm_get_cred(__task_cred(tracer),
+							&selinux_ops);
 				ptsid = sec->sid;
 			}
 			rcu_read_unlock();
@@ -2101,7 +2126,8 @@ static int selinux_bprm_set_creds(struct linux_binprm *bprm)
 
 static int selinux_bprm_secureexec(struct linux_binprm *bprm)
 {
-	const struct task_security_struct *tsec = current_security();
+	const struct task_security_struct *tsec =
+		lsm_get_cred(current_cred(), &selinux_ops);
 	u32 sid, osid;
 	int atsecure = 0;
 
@@ -2183,7 +2209,7 @@ static void selinux_bprm_committing_creds(struct linux_binprm *bprm)
 	struct rlimit *rlim, *initrlim;
 	int rc, i;
 
-	new_tsec = bprm->cred->security;
+	new_tsec = lsm_get_cred(bprm->cred, &selinux_ops);
 	if (new_tsec->sid == new_tsec->osid)
 		return;
 
@@ -2224,7 +2250,8 @@ static void selinux_bprm_committing_creds(struct linux_binprm *bprm)
  */
 static void selinux_bprm_committed_creds(struct linux_binprm *bprm)
 {
-	const struct task_security_struct *tsec = current_security();
+	const struct task_security_struct *tsec =
+		lsm_get_cred(current_cred(), &selinux_ops);
 	struct itimerval itimer;
 	u32 osid, sid;
 	int rc, i;
@@ -2371,7 +2398,8 @@ static int selinux_sb_remount(struct super_block *sb, void *data)
 	int rc, i, *flags;
 	struct security_mnt_opts opts;
 	char *secdata, **mount_options;
-	struct superblock_security_struct *sbsec = sb->s_security;
+	struct superblock_security_struct *sbsec =
+		lsm_get_super(sb, &selinux_ops);
 
 	if (!(sbsec->flags & SE_SBINITIALIZED))
 		return 0;
@@ -2423,7 +2451,8 @@ static int selinux_sb_remount(struct super_block *sb, void *data)
 			break;
 		case ROOTCONTEXT_MNT: {
 			struct inode_security_struct *root_isec;
-			root_isec = sb->s_root->d_inode->i_security;
+			root_isec = lsm_get_inode(sb->s_root->d_inode,
+							&selinux_ops);
 
 			if (bad_option(sbsec, ROOTCONTEXT_MNT, root_isec->sid, sid))
 				goto out_bad_option;
@@ -2519,15 +2548,16 @@ static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
 				       const struct qstr *qstr, char **name,
 				       void **value, size_t *len)
 {
-	const struct task_security_struct *tsec = current_security();
+	const struct task_security_struct *tsec =
+		lsm_get_cred(current_cred(), &selinux_ops);
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
@@ -2551,7 +2581,8 @@ static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
 
 	/* Possibly defer initialization to selinux_complete_init. */
 	if (sbsec->flags & SE_SBINITIALIZED) {
-		struct inode_security_struct *isec = inode->i_security;
+		struct inode_security_struct *isec =
+			lsm_get_inode(inode, &selinux_ops);
 		isec->sclass = inode_mode_to_security_class(inode->i_mode);
 		isec->sid = newsid;
 		isec->initialized = 1;
@@ -2640,7 +2671,7 @@ static noinline int audit_inode_permission(struct inode *inode,
 					   unsigned flags)
 {
 	struct common_audit_data ad;
-	struct inode_security_struct *isec = inode->i_security;
+	struct inode_security_struct *isec = lsm_get_inode(inode, &selinux_ops);
 	int rc;
 
 	ad.type = LSM_AUDIT_DATA_INODE;
@@ -2680,7 +2711,7 @@ static int selinux_inode_permission(struct inode *inode, int mask)
 	perms = file_mask_to_av(inode->i_mode, mask);
 
 	sid = cred_sid(cred);
-	isec = inode->i_security;
+	isec = lsm_get_inode(inode, &selinux_ops);
 
 	rc = avc_has_perm_noaudit(sid, isec->sid, isec->sclass, perms, 0, &avd);
 	audited = avc_audit_required(perms, &avd, rc,
@@ -2755,7 +2786,7 @@ static int selinux_inode_setxattr(struct dentry *dentry, const char *name,
 				  const void *value, size_t size, int flags)
 {
 	struct inode *inode = dentry->d_inode;
-	struct inode_security_struct *isec = inode->i_security;
+	struct inode_security_struct *isec = lsm_get_inode(inode, &selinux_ops);
 	struct superblock_security_struct *sbsec;
 	struct common_audit_data ad;
 	u32 newsid, sid = current_sid();
@@ -2764,7 +2795,7 @@ static int selinux_inode_setxattr(struct dentry *dentry, const char *name,
 	if (strcmp(name, XATTR_NAME_SELINUX))
 		return selinux_inode_setotherxattr(dentry, name);
 
-	sbsec = inode->i_sb->s_security;
+	sbsec = lsm_get_super(inode->i_sb, &selinux_ops);
 	if (!(sbsec->flags & SE_SBLABELSUPP))
 		return -EOPNOTSUPP;
 
@@ -2832,7 +2863,7 @@ static void selinux_inode_post_setxattr(struct dentry *dentry, const char *name,
 					int flags)
 {
 	struct inode *inode = dentry->d_inode;
-	struct inode_security_struct *isec = inode->i_security;
+	struct inode_security_struct *isec = lsm_get_inode(inode, &selinux_ops);
 	u32 newsid;
 	int rc;
 
@@ -2887,7 +2918,7 @@ static int selinux_inode_getsecurity(const struct inode *inode, const char *name
 	u32 size;
 	int error;
 	char *context = NULL;
-	struct inode_security_struct *isec = inode->i_security;
+	struct inode_security_struct *isec = lsm_get_inode(inode, &selinux_ops);
 
 	if (strcmp(name, XATTR_SELINUX_SUFFIX))
 		return -EOPNOTSUPP;
@@ -2923,7 +2954,7 @@ out_nofree:
 static int selinux_inode_setsecurity(struct inode *inode, const char *name,
 				     const void *value, size_t size, int flags)
 {
-	struct inode_security_struct *isec = inode->i_security;
+	struct inode_security_struct *isec = lsm_get_inode(inode, &selinux_ops);
 	u32 newsid;
 	int rc;
 
@@ -2952,7 +2983,7 @@ static int selinux_inode_listsecurity(struct inode *inode, char *buffer, size_t
 
 static void selinux_inode_getsecid(const struct inode *inode, u32 *secid)
 {
-	struct inode_security_struct *isec = inode->i_security;
+	struct inode_security_struct *isec = lsm_get_inode(inode, &selinux_ops);
 	*secid = isec->sid;
 }
 
@@ -2974,8 +3005,8 @@ static int selinux_revalidate_file_permission(struct file *file, int mask)
 static int selinux_file_permission(struct file *file, int mask)
 {
 	struct inode *inode = file_inode(file);
-	struct file_security_struct *fsec = file->f_security;
-	struct inode_security_struct *isec = inode->i_security;
+	struct file_security_struct *fsec = lsm_get_file(file, &selinux_ops);
+	struct inode_security_struct *isec = lsm_get_inode(inode, &selinux_ops);
 	u32 sid = current_sid();
 
 	if (!mask)
@@ -3200,7 +3231,7 @@ static int selinux_file_set_fowner(struct file *file)
 {
 	struct file_security_struct *fsec;
 
-	fsec = file->f_security;
+	fsec = lsm_get_file(file, &selinux_ops);
 	fsec->fown_sid = current_sid();
 
 	return 0;
@@ -3217,7 +3248,7 @@ static int selinux_file_send_sigiotask(struct task_struct *tsk,
 	/* struct fown_struct is never outside the context of a struct file */
 	file = container_of(fown, struct file, f_owner);
 
-	fsec = file->f_security;
+	fsec = lsm_get_file(file, &selinux_ops);
 
 	if (!signum)
 		perm = signal_to_av(SIGIO); /* as per send_sigio_to_task */
@@ -3240,8 +3271,8 @@ static int selinux_file_open(struct file *file, const struct cred *cred)
 	struct file_security_struct *fsec;
 	struct inode_security_struct *isec;
 
-	fsec = file->f_security;
-	isec = file_inode(file)->i_security;
+	fsec = lsm_get_file(file, &selinux_ops);
+	isec = lsm_get_inode(file_inode(file), &selinux_ops);
 	/*
 	 * Save inode label and policy sequence number
 	 * at open-time so that selinux_file_permission
@@ -3280,7 +3311,7 @@ static int selinux_cred_alloc_blank(struct cred *cred, gfp_t gfp)
 	if (!tsec)
 		return -ENOMEM;
 
-	cred->security = tsec;
+	lsm_set_cred(cred, tsec, &selinux_ops);
 	return 0;
 }
 
@@ -3289,14 +3320,14 @@ static int selinux_cred_alloc_blank(struct cred *cred, gfp_t gfp)
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
+	lsm_set_cred(cred, (void *) 0x7UL, &selinux_ops);
 	kfree(tsec);
 }
 
@@ -3309,13 +3340,13 @@ static int selinux_cred_prepare(struct cred *new, const struct cred *old,
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
 
@@ -3324,8 +3355,9 @@ static int selinux_cred_prepare(struct cred *new, const struct cred *old,
  */
 static void selinux_cred_transfer(struct cred *new, const struct cred *old)
 {
-	const struct task_security_struct *old_tsec = old->security;
-	struct task_security_struct *tsec = new->security;
+	const struct task_security_struct *old_tsec =
+		lsm_get_cred(old, &selinux_ops);
+	struct task_security_struct *tsec = lsm_get_cred(new, &selinux_ops);
 
 	*tsec = *old_tsec;
 }
@@ -3336,7 +3368,7 @@ static void selinux_cred_transfer(struct cred *new, const struct cred *old)
  */
 static int selinux_kernel_act_as(struct cred *new, u32 secid)
 {
-	struct task_security_struct *tsec = new->security;
+	struct task_security_struct *tsec = lsm_get_cred(new, &selinux_ops);
 	u32 sid = current_sid();
 	int ret;
 
@@ -3359,8 +3391,8 @@ static int selinux_kernel_act_as(struct cred *new, u32 secid)
  */
 static int selinux_kernel_create_files_as(struct cred *new, struct inode *inode)
 {
-	struct inode_security_struct *isec = inode->i_security;
-	struct task_security_struct *tsec = new->security;
+	struct inode_security_struct *isec = lsm_get_inode(inode, &selinux_ops);
+	struct task_security_struct *tsec = lsm_get_cred(new, &selinux_ops);
 	u32 sid = current_sid();
 	int ret;
 
@@ -3497,7 +3529,7 @@ static int selinux_task_wait(struct task_struct *p)
 static void selinux_task_to_inode(struct task_struct *p,
 				  struct inode *inode)
 {
-	struct inode_security_struct *isec = inode->i_security;
+	struct inode_security_struct *isec = lsm_get_inode(inode, &selinux_ops);
 	u32 sid = task_sid(p);
 
 	isec->sid = sid;
@@ -3752,7 +3784,7 @@ static int socket_sockcreate_sid(const struct task_security_struct *tsec,
 
 static int sock_has_perm(struct task_struct *task, struct sock *sk, u32 perms)
 {
-	struct sk_security_struct *sksec = sk->sk_security;
+	struct sk_security_struct *sksec = lsm_get_sock(sk, &selinux_ops);
 	struct common_audit_data ad;
 	struct lsm_network_audit net = {0,};
 	u32 tsid = task_sid(task);
@@ -3770,7 +3802,8 @@ static int sock_has_perm(struct task_struct *task, struct sock *sk, u32 perms)
 static int selinux_socket_create(int family, int type,
 				 int protocol, int kern)
 {
-	const struct task_security_struct *tsec = current_security();
+	const struct task_security_struct *tsec =
+		lsm_get_cred(current_cred(), &selinux_ops);
 	u32 newsid;
 	u16 secclass;
 	int rc;
@@ -3789,8 +3822,10 @@ static int selinux_socket_create(int family, int type,
 static int selinux_socket_post_create(struct socket *sock, int family,
 				      int type, int protocol, int kern)
 {
-	const struct task_security_struct *tsec = current_security();
-	struct inode_security_struct *isec = SOCK_INODE(sock)->i_security;
+	const struct task_security_struct *tsec =
+		lsm_get_cred(current_cred(), &selinux_ops);
+	struct inode_security_struct *isec =
+		lsm_get_inode(SOCK_INODE(sock), &selinux_ops);
 	struct sk_security_struct *sksec;
 	int err = 0;
 
@@ -3807,7 +3842,7 @@ static int selinux_socket_post_create(struct socket *sock, int family,
 	isec->initialized = 1;
 
 	if (sock->sk) {
-		sksec = sock->sk->sk_security;
+		sksec = lsm_get_sock(sock->sk, &selinux_ops);
 		sksec->sid = isec->sid;
 		sksec->sclass = isec->sclass;
 		err = selinux_netlbl_socket_post_create(sock->sk, family);
@@ -3838,7 +3873,8 @@ static int selinux_socket_bind(struct socket *sock, struct sockaddr *address, in
 	family = sk->sk_family;
 	if (family == PF_INET || family == PF_INET6) {
 		char *addrp;
-		struct sk_security_struct *sksec = sk->sk_security;
+		struct sk_security_struct *sksec =
+			lsm_get_sock(sk, &selinux_ops);
 		struct common_audit_data ad;
 		struct lsm_network_audit net = {0,};
 		struct sockaddr_in *addr4 = NULL;
@@ -3922,7 +3958,7 @@ out:
 static int selinux_socket_connect(struct socket *sock, struct sockaddr *address, int addrlen)
 {
 	struct sock *sk = sock->sk;
-	struct sk_security_struct *sksec = sk->sk_security;
+	struct sk_security_struct *sksec = lsm_get_sock(sk, &selinux_ops);
 	int err;
 
 	err = sock_has_perm(current, sk, SOCKET__CONNECT);
@@ -3990,9 +4026,9 @@ static int selinux_socket_accept(struct socket *sock, struct socket *newsock)
 	if (err)
 		return err;
 
-	newisec = SOCK_INODE(newsock)->i_security;
+	newisec = lsm_get_inode(SOCK_INODE(newsock), &selinux_ops);
 
-	isec = SOCK_INODE(sock)->i_security;
+	isec = lsm_get_inode(SOCK_INODE(sock), &selinux_ops);
 	newisec->sclass = isec->sclass;
 	newisec->sid = isec->sid;
 	newisec->initialized = 1;
@@ -4048,9 +4084,12 @@ static int selinux_socket_unix_stream_connect(struct sock *sock,
 					      struct sock *other,
 					      struct sock *newsk)
 {
-	struct sk_security_struct *sksec_sock = sock->sk_security;
-	struct sk_security_struct *sksec_other = other->sk_security;
-	struct sk_security_struct *sksec_new = newsk->sk_security;
+	struct sk_security_struct *sksec_sock =
+			lsm_get_sock(sock, &selinux_ops);
+	struct sk_security_struct *sksec_other =
+			lsm_get_sock(other, &selinux_ops);
+	struct sk_security_struct *sksec_new =
+			lsm_get_sock(newsk, &selinux_ops);
 	struct common_audit_data ad;
 	struct lsm_network_audit net = {0,};
 	int err;
@@ -4081,8 +4120,8 @@ static int selinux_socket_unix_stream_connect(struct sock *sock,
 static int selinux_socket_unix_may_send(struct socket *sock,
 					struct socket *other)
 {
-	struct sk_security_struct *ssec = sock->sk->sk_security;
-	struct sk_security_struct *osec = other->sk->sk_security;
+	struct sk_security_struct *ssec = lsm_get_sock(sock->sk, &selinux_ops);
+	struct sk_security_struct *osec = lsm_get_sock(other->sk, &selinux_ops);
 	struct common_audit_data ad;
 	struct lsm_network_audit net = {0,};
 
@@ -4121,7 +4160,7 @@ static int selinux_sock_rcv_skb_compat(struct sock *sk, struct sk_buff *skb,
 				       u16 family)
 {
 	int err = 0;
-	struct sk_security_struct *sksec = sk->sk_security;
+	struct sk_security_struct *sksec = lsm_get_sock(sk, &selinux_ops);
 	u32 sk_sid = sksec->sid;
 	struct common_audit_data ad;
 	struct lsm_network_audit net = {0,};
@@ -4153,7 +4192,7 @@ static int selinux_sock_rcv_skb_compat(struct sock *sk, struct sk_buff *skb,
 static int selinux_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 {
 	int err;
-	struct sk_security_struct *sksec = sk->sk_security;
+	struct sk_security_struct *sksec = lsm_get_sock(sk, &selinux_ops);
 	u16 family = sk->sk_family;
 	u32 sk_sid = sksec->sid;
 	struct common_audit_data ad;
@@ -4223,7 +4262,7 @@ static int selinux_socket_getpeersec_stream(struct socket *sock, char __user *op
 	int err = 0;
 	char *scontext;
 	u32 scontext_len;
-	struct sk_security_struct *sksec = sock->sk->sk_security;
+	struct sk_security_struct *sksec = lsm_get_sock(sock->sk, &selinux_ops);
 	u32 peer_sid = SECSID_NULL;
 
 	if (sksec->sclass == SECCLASS_UNIX_STREAM_SOCKET ||
@@ -4288,24 +4327,24 @@ static int selinux_sk_alloc_security(struct sock *sk, int family, gfp_t priority
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
@@ -4319,7 +4358,8 @@ static void selinux_sk_getsecid(struct sock *sk, u32 *secid)
 	if (!sk)
 		*secid = SECINITSID_ANY_SOCKET;
 	else {
-		struct sk_security_struct *sksec = sk->sk_security;
+		struct sk_security_struct *sksec =
+			lsm_get_sock(sk, &selinux_ops);
 
 		*secid = sksec->sid;
 	}
@@ -4327,8 +4367,9 @@ static void selinux_sk_getsecid(struct sock *sk, u32 *secid)
 
 static void selinux_sock_graft(struct sock *sk, struct socket *parent)
 {
-	struct inode_security_struct *isec = SOCK_INODE(parent)->i_security;
-	struct sk_security_struct *sksec = sk->sk_security;
+	struct inode_security_struct *isec =
+		lsm_get_inode(SOCK_INODE(parent), &selinux_ops);
+	struct sk_security_struct *sksec = lsm_get_sock(sk, &selinux_ops);
 
 	if (sk->sk_family == PF_INET || sk->sk_family == PF_INET6 ||
 	    sk->sk_family == PF_UNIX)
@@ -4339,7 +4380,7 @@ static void selinux_sock_graft(struct sock *sk, struct socket *parent)
 static int selinux_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 				     struct request_sock *req)
 {
-	struct sk_security_struct *sksec = sk->sk_security;
+	struct sk_security_struct *sksec = lsm_get_sock(sk, &selinux_ops);
 	int err;
 	u16 family = sk->sk_family;
 	u32 newsid;
@@ -4369,7 +4410,7 @@ static int selinux_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 static void selinux_inet_csk_clone(struct sock *newsk,
 				   const struct request_sock *req)
 {
-	struct sk_security_struct *newsksec = newsk->sk_security;
+	struct sk_security_struct *newsksec = lsm_get_sock(newsk, &selinux_ops);
 
 	newsksec->sid = req->secid;
 	newsksec->peer_sid = req->peer_secid;
@@ -4386,7 +4427,7 @@ static void selinux_inet_csk_clone(struct sock *newsk,
 static void selinux_inet_conn_established(struct sock *sk, struct sk_buff *skb)
 {
 	u16 family = sk->sk_family;
-	struct sk_security_struct *sksec = sk->sk_security;
+	struct sk_security_struct *sksec = lsm_get_sock(sk, &selinux_ops);
 
 	/* handle mapped IPv4 packets arriving via IPv6 sockets */
 	if (family == PF_INET6 && skb->protocol == htons(ETH_P_IP))
@@ -4405,7 +4446,7 @@ static int selinux_secmark_relabel_packet(u32 sid)
 	const struct task_security_struct *__tsec;
 	u32 tsid;
 
-	__tsec = current_security();
+	__tsec = lsm_get_cred(current_cred(), &selinux_ops);
 	tsid = __tsec->sid;
 
 	return avc_has_perm(tsid, sid, SECCLASS_PACKET, PACKET__RELABELTO, NULL);
@@ -4471,7 +4512,7 @@ static int selinux_tun_dev_attach_queue(void *security)
 static int selinux_tun_dev_attach(struct sock *sk, void *security)
 {
 	struct tun_security_struct *tunsec = security;
-	struct sk_security_struct *sksec = sk->sk_security;
+	struct sk_security_struct *sksec = lsm_get_sock(sk, &selinux_ops);
 
 	/* we don't currently perform any NetLabel based labeling here and it
 	 * isn't clear that we would want to do so anyway; while we could apply
@@ -4510,7 +4551,7 @@ static int selinux_nlmsg_perm(struct sock *sk, struct sk_buff *skb)
 	int err = 0;
 	u32 perm;
 	struct nlmsghdr *nlh;
-	struct sk_security_struct *sksec = sk->sk_security;
+	struct sk_security_struct *sksec = lsm_get_sock(sk, &selinux_ops);
 
 	if (skb->len < NLMSG_HDRLEN) {
 		err = -EINVAL;
@@ -4630,7 +4671,8 @@ static unsigned int selinux_ip_output(struct sk_buff *skb,
 	 * because we want to make sure we apply the necessary labeling
 	 * before IPsec is applied so we can leverage AH protection */
 	if (skb->sk) {
-		struct sk_security_struct *sksec = skb->sk->sk_security;
+		struct sk_security_struct *sksec =
+			lsm_get_sock(skb->sk, &selinux_ops);
 		sid = sksec->sid;
 	} else
 		sid = SECINITSID_KERNEL;
@@ -4662,7 +4704,7 @@ static unsigned int selinux_ip_postroute_compat(struct sk_buff *skb,
 
 	if (sk == NULL)
 		return NF_ACCEPT;
-	sksec = sk->sk_security;
+	sksec = lsm_get_sock(sk, &selinux_ops);
 
 	ad.type = LSM_AUDIT_DATA_NET;
 	ad.u.net = &net;
@@ -4730,7 +4772,8 @@ static unsigned int selinux_ip_postroute(struct sk_buff *skb, int ifindex,
 			peer_sid = SECINITSID_KERNEL;
 		}
 	} else {
-		struct sk_security_struct *sksec = sk->sk_security;
+		struct sk_security_struct *sksec =
+			lsm_get_sock(sk, &selinux_ops);
 		peer_sid = sksec->sid;
 		secmark_perm = PACKET__SEND;
 	}
@@ -4814,15 +4857,15 @@ static int ipc_alloc_security(struct task_struct *task,
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
 
@@ -4835,16 +4878,16 @@ static int msg_msg_alloc_security(struct msg_msg *msg)
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
 
@@ -4855,7 +4898,7 @@ static int ipc_has_perm(struct kern_ipc_perm *ipc_perms,
 	struct common_audit_data ad;
 	u32 sid = current_sid();
 
-	isec = ipc_perms->security;
+	isec = lsm_get_ipc(ipc_perms, &selinux_ops);
 
 	ad.type = LSM_AUDIT_DATA_IPC;
 	ad.u.ipc_id = ipc_perms->key;
@@ -4885,7 +4928,7 @@ static int selinux_msg_queue_alloc_security(struct msg_queue *msq)
 	if (rc)
 		return rc;
 
-	isec = msq->q_perm.security;
+	isec = lsm_get_ipc(&msq->q_perm, &selinux_ops);
 
 	ad.type = LSM_AUDIT_DATA_IPC;
 	ad.u.ipc_id = msq->q_perm.key;
@@ -4910,7 +4953,7 @@ static int selinux_msg_queue_associate(struct msg_queue *msq, int msqflg)
 	struct common_audit_data ad;
 	u32 sid = current_sid();
 
-	isec = msq->q_perm.security;
+	isec = lsm_get_ipc(&msq->q_perm, &selinux_ops);
 
 	ad.type = LSM_AUDIT_DATA_IPC;
 	ad.u.ipc_id = msq->q_perm.key;
@@ -4955,8 +4998,8 @@ static int selinux_msg_queue_msgsnd(struct msg_queue *msq, struct msg_msg *msg,
 	u32 sid = current_sid();
 	int rc;
 
-	isec = msq->q_perm.security;
-	msec = msg->security;
+	isec = lsm_get_ipc(&msq->q_perm, &selinux_ops);
+	msec = lsm_get_msg(msg, &selinux_ops);
 
 	/*
 	 * First time through, need to assign label to the message
@@ -5000,8 +5043,8 @@ static int selinux_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg,
 	u32 sid = task_sid(target);
 	int rc;
 
-	isec = msq->q_perm.security;
-	msec = msg->security;
+	isec = lsm_get_ipc(&msq->q_perm, &selinux_ops);
+	msec = lsm_get_msg(msg, &selinux_ops);
 
 	ad.type = LSM_AUDIT_DATA_IPC;
 	ad.u.ipc_id = msq->q_perm.key;
@@ -5026,7 +5069,7 @@ static int selinux_shm_alloc_security(struct shmid_kernel *shp)
 	if (rc)
 		return rc;
 
-	isec = shp->shm_perm.security;
+	isec = lsm_get_ipc(&shp->shm_perm, &selinux_ops);
 
 	ad.type = LSM_AUDIT_DATA_IPC;
 	ad.u.ipc_id = shp->shm_perm.key;
@@ -5051,7 +5094,7 @@ static int selinux_shm_associate(struct shmid_kernel *shp, int shmflg)
 	struct common_audit_data ad;
 	u32 sid = current_sid();
 
-	isec = shp->shm_perm.security;
+	isec = lsm_get_ipc(&shp->shm_perm, &selinux_ops);
 
 	ad.type = LSM_AUDIT_DATA_IPC;
 	ad.u.ipc_id = shp->shm_perm.key;
@@ -5118,7 +5161,7 @@ static int selinux_sem_alloc_security(struct sem_array *sma)
 	if (rc)
 		return rc;
 
-	isec = sma->sem_perm.security;
+	isec = lsm_get_ipc(&sma->sem_perm, &selinux_ops);
 
 	ad.type = LSM_AUDIT_DATA_IPC;
 	ad.u.ipc_id = sma->sem_perm.key;
@@ -5143,7 +5186,7 @@ static int selinux_sem_associate(struct sem_array *sma, int semflg)
 	struct common_audit_data ad;
 	u32 sid = current_sid();
 
-	isec = sma->sem_perm.security;
+	isec = lsm_get_ipc(&sma->sem_perm, &selinux_ops);
 
 	ad.type = LSM_AUDIT_DATA_IPC;
 	ad.u.ipc_id = sma->sem_perm.key;
@@ -5225,7 +5268,7 @@ static int selinux_ipc_permission(struct kern_ipc_perm *ipcp, short flag)
 
 static void selinux_ipc_getsecid(struct kern_ipc_perm *ipcp, u32 *secid)
 {
-	struct ipc_security_struct *isec = ipcp->security;
+	struct ipc_security_struct *isec = lsm_get_ipc(ipcp, &selinux_ops);
 	*secid = isec->sid;
 }
 
@@ -5250,7 +5293,7 @@ static int selinux_getprocattr(struct task_struct *p,
 	}
 
 	rcu_read_lock();
-	__tsec = __task_cred(p)->security;
+	__tsec = lsm_get_cred(__task_cred(p), &selinux_ops);
 
 	if (!strcmp(name, "current"))
 		sid = __tsec->sid;
@@ -5359,7 +5402,7 @@ static int selinux_setprocattr(struct task_struct *p,
 	   operation.  See selinux_bprm_set_creds for the execve
 	   checks and may_create for the file creation checks. The
 	   operation will then fail if the context is not permitted. */
-	tsec = new->security;
+	tsec = lsm_get_cred(new, &selinux_ops);
 	if (!strcmp(name, "exec")) {
 		tsec->exec_sid = sid;
 	} else if (!strcmp(name, "fscreate")) {
@@ -5473,21 +5516,21 @@ static int selinux_key_alloc(struct key *k, const struct cred *cred,
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
 
@@ -5508,14 +5551,14 @@ static int selinux_key_permission(key_ref_t key_ref,
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
@@ -5529,7 +5572,7 @@ static int selinux_key_getsecurity(struct key *key, char **_buffer)
 
 #endif
 
-static struct security_operations selinux_ops = {
+struct security_operations selinux_ops = {
 	.name =				"selinux",
 
 	.ptrace_access_check =		selinux_ptrace_access_check,
diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
index aa47bca..9628bcb 100644
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -119,5 +119,6 @@ struct key_security_struct {
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
index da4b8b2..63154c6 100644
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
+			lsm_get_sock(sk, &selinux_ops);
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
index ff42773..bac7874 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/string.h>
 #include <linux/security.h>
+#include <linux/lsm.h>
 #include <linux/major.h>
 #include <linux/seq_file.h>
 #include <linux/percpu.h>
@@ -83,7 +84,7 @@ static int task_has_security(struct task_struct *tsk,
 	u32 sid = 0;
 
 	rcu_read_lock();
-	tsec = __task_cred(tsk)->security;
+	tsec = lsm_get_cred(__task_cred(tsk), &selinux_ops);
 	if (tsec)
 		sid = tsec->sid;
 	rcu_read_unlock();
@@ -1262,7 +1263,7 @@ static int sel_make_bools(void)
 		if (len >= PAGE_SIZE)
 			goto out;
 
-		isec = (struct inode_security_struct *)inode->i_security;
+		isec = lsm_get_inode(inode, &selinux_ops);
 		ret = security_genfs_sid("selinuxfs", page, SECCLASS_FILE, &sid);
 		if (ret)
 			goto out;
@@ -1827,7 +1828,7 @@ static int sel_fill_super(struct super_block *sb, void *data, int silent)
 		goto err;
 
 	inode->i_ino = ++sel_last_ino;
-	isec = (struct inode_security_struct *)inode->i_security;
+	isec = lsm_get_inode(inode, &selinux_ops);
 	isec->sid = SECINITSID_DEVNULL;
 	isec->sclass = SECCLASS_CHR_FILE;
 	isec->initialized = 1;
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index b4feecc..71b0939 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -48,6 +48,7 @@
 #include <linux/in.h>
 #include <linux/sched.h>
 #include <linux/audit.h>
+#include <linux/lsm.h>
 #include <linux/mutex.h>
 #include <linux/selinux.h>
 #include <linux/flex_array.h>
@@ -3129,7 +3130,7 @@ int security_netlbl_secattr_to_sid(struct netlbl_lsm_secattr *secattr,
 	if (secattr->flags & NETLBL_SECATTR_CACHE)
 		*sid = *(u32 *)secattr->cache->data;
 	else if (secattr->flags & NETLBL_SECATTR_SECID)
-		*sid = secattr->attr.secid;
+		*sid = lsm_get_secid(&secattr->attr.secid, 0);
 	else if (secattr->flags & NETLBL_SECATTR_MLS_LVL) {
 		rc = -EIDRM;
 		ctx = sidtab_search(&sidtab, SECINITSID_NETMSG);
@@ -3204,7 +3205,7 @@ int security_netlbl_sid_to_secattr(u32 sid, struct netlbl_lsm_secattr *secattr)
 	if (secattr->domain == NULL)
 		goto out;
 
-	secattr->attr.secid = sid;
+	lsm_set_secid(&secattr->attr.secid, sid, 0);
 	secattr->flags |= NETLBL_SECATTR_DOMAIN_CPY | NETLBL_SECATTR_SECID;
 	mls_export_netlbl_lvl(ctx, secattr);
 	rc = mls_export_netlbl_cat(ctx, secattr);
diff --git a/security/selinux/xfrm.c b/security/selinux/xfrm.c
index d030818..25fb459 100644
--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -198,7 +198,8 @@ static int selinux_xfrm_sec_ctx_alloc(struct xfrm_sec_ctx **ctxp,
 	struct xfrm_user_sec_ctx *uctx, u32 sid)
 {
 	int rc = 0;
-	const struct task_security_struct *tsec = current_security();
+	const struct task_security_struct *tsec =
+		lsm_get_cred(current_cred(), &selinux_ops);
 	struct xfrm_sec_ctx *ctx = NULL;
 	char *ctx_str = NULL;
 	u32 str_len;
@@ -336,7 +337,8 @@ void selinux_xfrm_policy_free(struct xfrm_sec_ctx *ctx)
  */
 int selinux_xfrm_policy_delete(struct xfrm_sec_ctx *ctx)
 {
-	const struct task_security_struct *tsec = current_security();
+	const struct task_security_struct *tsec =
+		lsm_get_cred(current_cred(), &selinux_ops);
 
 	if (!ctx)
 		return 0;
@@ -377,7 +379,8 @@ void selinux_xfrm_state_free(struct xfrm_state *x)
   */
 int selinux_xfrm_state_delete(struct xfrm_state *x)
 {
-	const struct task_security_struct *tsec = current_security();
+	const struct task_security_struct *tsec =
+		lsm_get_cred(current_cred(), &selinux_ops);
 	struct xfrm_sec_ctx *ctx = x->security;
 
 	if (!ctx)
diff --git a/security/smack/smack.h b/security/smack/smack.h
index 8ad3095..83997ba 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -16,6 +16,7 @@
 #include <linux/capability.h>
 #include <linux/spinlock.h>
 #include <linux/security.h>
+#include <linux/lsm.h>
 #include <linux/in.h>
 #include <net/netlabel.h>
 #include <linux/list.h>
@@ -240,7 +241,7 @@ extern struct security_operations smack_ops;
  */
 static inline int smk_inode_transmutable(const struct inode *isp)
 {
-	struct inode_smack *sip = isp->i_security;
+	struct inode_smack *sip = lsm_get_inode(isp, &smack_ops);
 	return (sip->smk_flags & SMK_INODE_TRANSMUTE) != 0;
 }
 
@@ -249,7 +250,7 @@ static inline int smk_inode_transmutable(const struct inode *isp)
  */
 static inline char *smk_of_inode(const struct inode *isp)
 {
-	struct inode_smack *sip = isp->i_security;
+	struct inode_smack *sip = lsm_get_inode(isp, &smack_ops);
 	return sip->smk_inode;
 }
 
@@ -274,7 +275,7 @@ static inline char *smk_of_forked(const struct task_smack *tsp)
  */
 static inline char *smk_of_current(void)
 {
-	return smk_of_task(current_security());
+	return smk_of_task(lsm_get_cred(current_cred(), &smack_ops));
 }
 
 /*
diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index 2e397a8..360a56c 100644
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
index d52c780..0170afd 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -252,7 +252,7 @@ static int smack_sb_alloc_security(struct super_block *sb)
 	sbsp->smk_hat = smack_known_hat.smk_known;
 	sbsp->smk_initialized = 0;
 
-	sb->s_security = sbsp;
+	lsm_set_super(sb, sbsp, &smack_ops);
 
 	return 0;
 }
@@ -264,8 +264,8 @@ static int smack_sb_alloc_security(struct super_block *sb)
  */
 static void smack_sb_free_security(struct super_block *sb)
 {
-	kfree(sb->s_security);
-	sb->s_security = NULL;
+	kfree(lsm_get_super(sb, &smack_ops));
+	lsm_set_super(sb, NULL, &smack_ops);
 }
 
 /**
@@ -325,7 +325,7 @@ static int smack_sb_kern_mount(struct super_block *sb, int flags, void *data)
 {
 	struct dentry *root = sb->s_root;
 	struct inode *inode = root->d_inode;
-	struct superblock_smack *sp = sb->s_security;
+	struct superblock_smack *sp = lsm_get_super(sb, &smack_ops);
 	struct inode_smack *isp;
 	char *op;
 	char *commap;
@@ -368,9 +368,9 @@ static int smack_sb_kern_mount(struct super_block *sb, int flags, void *data)
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
 
@@ -386,7 +386,7 @@ static int smack_sb_kern_mount(struct super_block *sb, int flags, void *data)
  */
 static int smack_sb_statfs(struct dentry *dentry)
 {
-	struct superblock_smack *sbp = dentry->d_sb->s_security;
+	struct superblock_smack *sbp = lsm_get_super(dentry->d_sb, &smack_ops);
 	int rc;
 	struct smk_audit_info ad;
 
@@ -411,7 +411,8 @@ static int smack_sb_statfs(struct dentry *dentry)
 static int smack_sb_mount(const char *dev_name, struct path *path,
 			  const char *type, unsigned long flags, void *data)
 {
-	struct superblock_smack *sbp = path->dentry->d_sb->s_security;
+	struct superblock_smack *sbp =
+		lsm_get_super(path->dentry->d_sb, &smack_ops);
 	struct smk_audit_info ad;
 
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_PATH);
@@ -440,7 +441,7 @@ static int smack_sb_umount(struct vfsmount *mnt, int flags)
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_PATH);
 	smk_ad_setfield_u_fs_path(&ad, path);
 
-	sbp = path.dentry->d_sb->s_security;
+	sbp = lsm_get_super(path.dentry->d_sb, &smack_ops);
 	return smk_curacc(sbp->smk_floor, MAY_WRITE, &ad);
 }
 
@@ -457,7 +458,7 @@ static int smack_sb_umount(struct vfsmount *mnt, int flags)
 static int smack_bprm_set_creds(struct linux_binprm *bprm)
 {
 	struct inode *inode = file_inode(bprm->file);
-	struct task_smack *bsp = bprm->cred->security;
+	struct task_smack *bsp = lsm_get_cred(bprm->cred, &smack_ops);
 	struct inode_smack *isp;
 	int rc;
 
@@ -468,7 +469,7 @@ static int smack_bprm_set_creds(struct linux_binprm *bprm)
 	if (bprm->cred_prepared)
 		return 0;
 
-	isp = inode->i_security;
+	isp = lsm_get_inode(inode, &smack_ops);
 	if (isp->smk_task == NULL || isp->smk_task == bsp->smk_task)
 		return 0;
 
@@ -489,7 +490,7 @@ static int smack_bprm_set_creds(struct linux_binprm *bprm)
  */
 static void smack_bprm_committing_creds(struct linux_binprm *bprm)
 {
-	struct task_smack *bsp = bprm->cred->security;
+	struct task_smack *bsp = lsm_get_cred(bprm->cred, &smack_ops);
 
 	if (bsp->smk_task != bsp->smk_forked)
 		current->pdeath_signal = 0;
@@ -503,7 +504,7 @@ static void smack_bprm_committing_creds(struct linux_binprm *bprm)
  */
 static int smack_bprm_secureexec(struct linux_binprm *bprm)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = lsm_get_cred(current_cred(), &smack_ops);
 	int ret = cap_bprm_secureexec(bprm);
 
 	if (!ret && (tsp->smk_task != tsp->smk_forked))
@@ -524,8 +525,8 @@ static int smack_bprm_secureexec(struct linux_binprm *bprm)
  */
 static int smack_inode_alloc_security(struct inode *inode)
 {
-	inode->i_security = new_inode_smack(smk_of_current());
-	if (inode->i_security == NULL)
+	lsm_set_inode(inode, new_inode_smack(smk_of_current()), &smack_ops);
+	if (lsm_get_inode(inode, &smack_ops) == NULL)
 		return -ENOMEM;
 	return 0;
 }
@@ -538,8 +539,8 @@ static int smack_inode_alloc_security(struct inode *inode)
  */
 static void smack_inode_free_security(struct inode *inode)
 {
-	kfree(inode->i_security);
-	inode->i_security = NULL;
+	kfree(lsm_get_inode(inode, &smack_ops));
+	lsm_set_inode(inode, NULL, &smack_ops);
 }
 
 /**
@@ -558,7 +559,7 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 				     void **value, size_t *len)
 {
 	struct smack_known *skp;
-	struct inode_smack *issp = inode->i_security;
+	struct inode_smack *issp = lsm_get_inode(inode, &smack_ops);
 	char *csp = smk_of_current();
 	char *isp = smk_of_inode(inode);
 	char *dsp = smk_of_inode(dir);
@@ -863,7 +864,7 @@ static void smack_inode_post_setxattr(struct dentry *dentry, const char *name,
 				      const void *value, size_t size, int flags)
 {
 	char *nsp;
-	struct inode_smack *isp = dentry->d_inode->i_security;
+	struct inode_smack *isp = lsm_get_inode(dentry->d_inode, &smack_ops);
 
 	if (strcmp(name, XATTR_NAME_SMACK) == 0) {
 		nsp = smk_import(value, size);
@@ -938,7 +939,7 @@ static int smack_inode_removexattr(struct dentry *dentry, const char *name)
 		rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE, &ad);
 
 	if (rc == 0) {
-		isp = dentry->d_inode->i_security;
+		isp = lsm_get_inode(dentry->d_inode, &smack_ops);
 		isp->smk_task = NULL;
 		isp->smk_mmap = NULL;
 	}
@@ -985,7 +986,7 @@ static int smack_inode_getsecurity(const struct inode *inode,
 	if (sock == NULL || sock->sk == NULL)
 		return -EOPNOTSUPP;
 
-	ssp = sock->sk->sk_security;
+	ssp = lsm_get_sock(sock->sk, &smack_ops);
 
 	if (strcmp(name, XATTR_SMACK_IPIN) == 0)
 		isp = ssp->smk_in;
@@ -1031,7 +1032,7 @@ static int smack_inode_listsecurity(struct inode *inode, char *buffer,
  */
 static void smack_inode_getsecid(const struct inode *inode, u32 *secid)
 {
-	struct inode_smack *isp = inode->i_security;
+	struct inode_smack *isp = lsm_get_inode(inode, &smack_ops);
 
 	*secid = smack_to_secid(isp->smk_inode);
 }
@@ -1070,7 +1071,7 @@ static int smack_file_permission(struct file *file, int mask)
  */
 static int smack_file_alloc_security(struct file *file)
 {
-	file->f_security = smk_of_current();
+	lsm_set_file(file, smk_of_current(), &smack_ops);
 	return 0;
 }
 
@@ -1083,7 +1084,7 @@ static int smack_file_alloc_security(struct file *file)
  */
 static void smack_file_free_security(struct file *file)
 {
-	file->f_security = NULL;
+	lsm_set_file(file, NULL, &smack_ops);
 }
 
 /**
@@ -1106,10 +1107,10 @@ static int smack_file_ioctl(struct file *file, unsigned int cmd,
 	smk_ad_setfield_u_fs_path(&ad, file->f_path);
 
 	if (_IOC_DIR(cmd) & _IOC_WRITE)
-		rc = smk_curacc(file->f_security, MAY_WRITE, &ad);
+		rc = smk_curacc(lsm_get_file(file, &smack_ops), MAY_WRITE, &ad);
 
 	if (rc == 0 && (_IOC_DIR(cmd) & _IOC_READ))
-		rc = smk_curacc(file->f_security, MAY_READ, &ad);
+		rc = smk_curacc(lsm_get_file(file, &smack_ops), MAY_READ, &ad);
 
 	return rc;
 }
@@ -1127,7 +1128,7 @@ static int smack_file_lock(struct file *file, unsigned int cmd)
 
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_PATH);
 	smk_ad_setfield_u_fs_path(&ad, file->f_path);
-	return smk_curacc(file->f_security, MAY_WRITE, &ad);
+	return smk_curacc(lsm_get_file(file, &smack_ops), MAY_WRITE, &ad);
 }
 
 /**
@@ -1157,7 +1158,7 @@ static int smack_file_fcntl(struct file *file, unsigned int cmd,
 	case F_SETSIG:
 		smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_PATH);
 		smk_ad_setfield_u_fs_path(&ad, file->f_path);
-		rc = smk_curacc(file->f_security, MAY_WRITE, &ad);
+		rc = smk_curacc(lsm_get_file(file, &smack_ops), MAY_WRITE, &ad);
 		break;
 	default:
 		break;
@@ -1195,12 +1196,12 @@ static int smack_mmap_file(struct file *file,
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
@@ -1279,7 +1280,7 @@ static int smack_mmap_file(struct file *file,
  */
 static int smack_file_set_fowner(struct file *file)
 {
-	file->f_security = smk_of_current();
+	lsm_set_file(file, smk_of_current(), &smack_ops);
 	return 0;
 }
 
@@ -1299,7 +1300,7 @@ static int smack_file_send_sigiotask(struct task_struct *tsk,
 {
 	struct file *file;
 	int rc;
-	char *tsp = smk_of_task(tsk->cred->security);
+	char *tsp = smk_of_task(lsm_get_cred(tsk->cred, &smack_ops));
 	struct smk_audit_info ad;
 
 	/*
@@ -1308,13 +1309,13 @@ static int smack_file_send_sigiotask(struct task_struct *tsk,
 	file = container_of(fown, struct file, f_owner);
 
 	/* we don't log here as rc can be overriden */
-	rc = smk_access(file->f_security, tsp, MAY_WRITE, NULL);
+	rc = smk_access(lsm_get_file(file, &smack_ops), tsp, MAY_WRITE, NULL);
 	if (rc != 0 && has_capability(tsk, CAP_MAC_OVERRIDE))
 		rc = 0;
 
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
 	smk_ad_setfield_u_tsk(&ad, tsk);
-	smack_log(file->f_security, tsp, MAY_WRITE, rc, &ad);
+	smack_log(lsm_get_file(file, &smack_ops), tsp, MAY_WRITE, rc, &ad);
 	return rc;
 }
 
@@ -1339,7 +1340,7 @@ static int smack_file_receive(struct file *file)
 	if (file->f_mode & FMODE_WRITE)
 		may |= MAY_WRITE;
 
-	return smk_curacc(file->f_security, may, &ad);
+	return smk_curacc(lsm_get_file(file, &smack_ops), may, &ad);
 }
 
 /**
@@ -1353,9 +1354,9 @@ static int smack_file_receive(struct file *file)
  */
 static int smack_file_open(struct file *file, const struct cred *cred)
 {
-	struct inode_smack *isp = file_inode(file)->i_security;
+	struct inode_smack *isp = lsm_get_inode(file_inode(file), &smack_ops);
 
-	file->f_security = isp->smk_inode;
+	lsm_set_file(file, isp->smk_inode, &smack_ops);
 
 	return 0;
 }
@@ -1381,7 +1382,7 @@ static int smack_cred_alloc_blank(struct cred *cred, gfp_t gfp)
 	if (tsp == NULL)
 		return -ENOMEM;
 
-	cred->security = tsp;
+	lsm_set_cred(cred, tsp, &smack_ops);
 
 	return 0;
 }
@@ -1394,14 +1395,14 @@ static int smack_cred_alloc_blank(struct cred *cred, gfp_t gfp)
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
@@ -1422,7 +1423,7 @@ static void smack_cred_free(struct cred *cred)
 static int smack_cred_prepare(struct cred *new, const struct cred *old,
 			      gfp_t gfp)
 {
-	struct task_smack *old_tsp = old->security;
+	struct task_smack *old_tsp = lsm_get_cred(old, &smack_ops);
 	struct task_smack *new_tsp;
 	int rc;
 
@@ -1434,7 +1435,7 @@ static int smack_cred_prepare(struct cred *new, const struct cred *old,
 	if (rc != 0)
 		return rc;
 
-	new->security = new_tsp;
+	lsm_set_cred(new, new_tsp, &smack_ops);
 	return 0;
 }
 
@@ -1447,8 +1448,8 @@ static int smack_cred_prepare(struct cred *new, const struct cred *old,
  */
 static void smack_cred_transfer(struct cred *new, const struct cred *old)
 {
-	struct task_smack *old_tsp = old->security;
-	struct task_smack *new_tsp = new->security;
+	struct task_smack *old_tsp = lsm_get_cred(old, &smack_ops);
+	struct task_smack *new_tsp = lsm_get_cred(new, &smack_ops);
 
 	new_tsp->smk_task = old_tsp->smk_task;
 	new_tsp->smk_forked = old_tsp->smk_task;
@@ -1468,7 +1469,7 @@ static void smack_cred_transfer(struct cred *new, const struct cred *old)
  */
 static int smack_kernel_act_as(struct cred *new, u32 secid)
 {
-	struct task_smack *new_tsp = new->security;
+	struct task_smack *new_tsp = lsm_get_cred(new, &smack_ops);
 	char *smack = smack_from_secid(secid);
 
 	if (smack == NULL)
@@ -1489,8 +1490,8 @@ static int smack_kernel_act_as(struct cred *new, u32 secid)
 static int smack_kernel_create_files_as(struct cred *new,
 					struct inode *inode)
 {
-	struct inode_smack *isp = inode->i_security;
-	struct task_smack *tsp = new->security;
+	struct inode_smack *isp = lsm_get_inode(inode, &smack_ops);
+	struct task_smack *tsp = lsm_get_cred(new, &smack_ops);
 
 	tsp->smk_forked = isp->smk_inode;
 	tsp->smk_task = isp->smk_inode;
@@ -1709,7 +1710,7 @@ static int smack_task_wait(struct task_struct *p)
  */
 static void smack_task_to_inode(struct task_struct *p, struct inode *inode)
 {
-	struct inode_smack *isp = inode->i_security;
+	struct inode_smack *isp = lsm_get_inode(inode, &smack_ops);
 	isp->smk_inode = smk_of_task(task_security(p));
 }
 
@@ -1740,7 +1741,7 @@ static int smack_sk_alloc_security(struct sock *sk, int family, gfp_t gfp_flags)
 	ssp->smk_out = csp;
 	ssp->smk_packet = NULL;
 
-	sk->sk_security = ssp;
+	lsm_set_sock(sk, ssp, &smack_ops);
 
 	return 0;
 }
@@ -1753,7 +1754,7 @@ static int smack_sk_alloc_security(struct sock *sk, int family, gfp_t gfp_flags)
  */
 static void smack_sk_free_security(struct sock *sk)
 {
-	kfree(sk->sk_security);
+	kfree(lsm_get_sock(sk, &smack_ops));
 }
 
 /**
@@ -1806,7 +1807,7 @@ static char *smack_host_label(struct sockaddr_in *sip)
 static int smack_netlabel(struct sock *sk, int labeled)
 {
 	struct smack_known *skp;
-	struct socket_smack *ssp = sk->sk_security;
+	struct socket_smack *ssp = lsm_get_sock(sk, &smack_ops);
 	int rc = 0;
 
 	/*
@@ -1850,7 +1851,7 @@ static int smack_netlabel_send(struct sock *sk, struct sockaddr_in *sap)
 	int rc;
 	int sk_lbl;
 	char *hostsp;
-	struct socket_smack *ssp = sk->sk_security;
+	struct socket_smack *ssp = lsm_get_sock(sk, &smack_ops);
 	struct smk_audit_info ad;
 
 	rcu_read_lock();
@@ -1893,7 +1894,7 @@ static int smack_inode_setsecurity(struct inode *inode, const char *name,
 				   const void *value, size_t size, int flags)
 {
 	char *sp;
-	struct inode_smack *nsp = inode->i_security;
+	struct inode_smack *nsp = lsm_get_inode(inode, &smack_ops);
 	struct socket_smack *ssp;
 	struct socket *sock;
 	int rc = 0;
@@ -1920,7 +1921,7 @@ static int smack_inode_setsecurity(struct inode *inode, const char *name,
 	if (sock == NULL || sock->sk == NULL)
 		return -EOPNOTSUPP;
 
-	ssp = sock->sk->sk_security;
+	ssp = lsm_get_sock(sock->sk, &smack_ops);
 
 	if (strcmp(name, XATTR_SMACK_IPIN) == 0)
 		ssp->smk_in = sp;
@@ -2011,7 +2012,7 @@ static int smack_flags_to_may(int flags)
  */
 static int smack_msg_msg_alloc_security(struct msg_msg *msg)
 {
-	msg->security = smk_of_current();
+	lsm_set_msg(msg, smk_of_current(), &smack_ops);
 	return 0;
 }
 
@@ -2023,7 +2024,7 @@ static int smack_msg_msg_alloc_security(struct msg_msg *msg)
  */
 static void smack_msg_msg_free_security(struct msg_msg *msg)
 {
-	msg->security = NULL;
+	lsm_set_msg(msg, NULL, &smack_ops);
 }
 
 /**
@@ -2034,7 +2035,7 @@ static void smack_msg_msg_free_security(struct msg_msg *msg)
  */
 static char *smack_of_shm(struct shmid_kernel *shp)
 {
-	return (char *)shp->shm_perm.security;
+	return (char *)lsm_get_ipc(&shp->shm_perm, &smack_ops);
 }
 
 /**
@@ -2047,7 +2048,7 @@ static int smack_shm_alloc_security(struct shmid_kernel *shp)
 {
 	struct kern_ipc_perm *isp = &shp->shm_perm;
 
-	isp->security = smk_of_current();
+	lsm_set_ipc(isp, smk_of_current(), &smack_ops);
 	return 0;
 }
 
@@ -2061,7 +2062,7 @@ static void smack_shm_free_security(struct shmid_kernel *shp)
 {
 	struct kern_ipc_perm *isp = &shp->shm_perm;
 
-	isp->security = NULL;
+	lsm_set_ipc(isp, NULL, &smack_ops);
 }
 
 /**
@@ -2157,7 +2158,7 @@ static int smack_shm_shmat(struct shmid_kernel *shp, char __user *shmaddr,
  */
 static char *smack_of_sem(struct sem_array *sma)
 {
-	return (char *)sma->sem_perm.security;
+	return (char *)lsm_get_ipc(&sma->sem_perm, &smack_ops);
 }
 
 /**
@@ -2170,7 +2171,7 @@ static int smack_sem_alloc_security(struct sem_array *sma)
 {
 	struct kern_ipc_perm *isp = &sma->sem_perm;
 
-	isp->security = smk_of_current();
+	lsm_set_ipc(isp, smk_of_current(), &smack_ops);
 	return 0;
 }
 
@@ -2184,7 +2185,7 @@ static void smack_sem_free_security(struct sem_array *sma)
 {
 	struct kern_ipc_perm *isp = &sma->sem_perm;
 
-	isp->security = NULL;
+	lsm_set_ipc(isp, NULL, &smack_ops);
 }
 
 /**
@@ -2288,7 +2289,7 @@ static int smack_msg_queue_alloc_security(struct msg_queue *msq)
 {
 	struct kern_ipc_perm *kisp = &msq->q_perm;
 
-	kisp->security = smk_of_current();
+	lsm_set_ipc(kisp, smk_of_current(), &smack_ops);
 	return 0;
 }
 
@@ -2302,7 +2303,7 @@ static void smack_msg_queue_free_security(struct msg_queue *msq)
 {
 	struct kern_ipc_perm *kisp = &msq->q_perm;
 
-	kisp->security = NULL;
+	lsm_set_ipc(kisp, NULL, &smack_ops);
 }
 
 /**
@@ -2313,7 +2314,7 @@ static void smack_msg_queue_free_security(struct msg_queue *msq)
  */
 static char *smack_of_msq(struct msg_queue *msq)
 {
-	return (char *)msq->q_perm.security;
+	return (char *)lsm_get_ipc(&msq->q_perm, &smack_ops);
 }
 
 /**
@@ -2425,7 +2426,7 @@ static int smack_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg,
  */
 static int smack_ipc_permission(struct kern_ipc_perm *ipp, short flag)
 {
-	char *isp = ipp->security;
+	char *isp = lsm_get_ipc(ipp, &smack_ops);
 	int may = smack_flags_to_may(flag);
 	struct smk_audit_info ad;
 
@@ -2443,7 +2444,7 @@ static int smack_ipc_permission(struct kern_ipc_perm *ipp, short flag)
  */
 static void smack_ipc_getsecid(struct kern_ipc_perm *ipp, u32 *secid)
 {
-	char *smack = ipp->security;
+	char *smack = lsm_get_ipc(ipp, &smack_ops);
 
 	*secid = smack_to_secid(smack);
 }
@@ -2471,7 +2472,7 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
 	if (inode == NULL)
 		return;
 
-	isp = inode->i_security;
+	isp = lsm_get_inode(inode, &smack_ops);
 
 	mutex_lock(&isp->smk_lock);
 	/*
@@ -2482,7 +2483,7 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
 		goto unlockandout;
 
 	sbp = inode->i_sb;
-	sbsp = sbp->s_security;
+	sbsp = lsm_get_super(sbp, &smack_ops);
 	/*
 	 * We're going to use the superblock default label
 	 * if there's no label on the file.
@@ -2712,7 +2713,7 @@ static int smack_setprocattr(struct task_struct *p, char *name,
 	if (new == NULL)
 		return -ENOMEM;
 
-	tsp = new->security;
+	tsp = lsm_get_cred(new, &smack_ops);
 	tsp->smk_task = newsmack;
 
 	commit_creds(new);
@@ -2731,9 +2732,9 @@ static int smack_setprocattr(struct task_struct *p, char *name,
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
 
@@ -2768,8 +2769,8 @@ static int smack_unix_stream_connect(struct sock *sock,
  */
 static int smack_unix_may_send(struct socket *sock, struct socket *other)
 {
-	struct socket_smack *ssp = sock->sk->sk_security;
-	struct socket_smack *osp = other->sk->sk_security;
+	struct socket_smack *ssp = lsm_get_sock(sock->sk, &smack_ops);
+	struct socket_smack *osp = lsm_get_sock(other->sk, &smack_ops);
 	struct smk_audit_info ad;
 	int rc = 0;
 
@@ -2859,7 +2860,7 @@ static char *smack_from_secattr(struct netlbl_lsm_secattr *sap,
 		/*
 		 * Looks like a fallback, which gives us a secid.
 		 */
-		sp = smack_from_secid(sap->attr.secid);
+		sp = smack_from_secid(lsm_get_secid(&sap->attr.secid, 0));
 		/*
 		 * This has got to be a bug because it is
 		 * impossible to specify a fallback without
@@ -2888,7 +2889,7 @@ static char *smack_from_secattr(struct netlbl_lsm_secattr *sap,
 static int smack_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 {
 	struct netlbl_lsm_secattr secattr;
-	struct socket_smack *ssp = sk->sk_security;
+	struct socket_smack *ssp = lsm_get_sock(sk, &smack_ops);
 	char *csp;
 	int rc;
 	struct smk_audit_info ad;
@@ -2947,7 +2948,7 @@ static int smack_socket_getpeersec_stream(struct socket *sock,
 	int slen = 1;
 	int rc = 0;
 
-	ssp = sock->sk->sk_security;
+	ssp = lsm_get_sock(sock->sk, &smack_ops);
 	if (ssp->smk_packet != NULL) {
 		rcp = ssp->smk_packet;
 		slen = strlen(rcp) + 1;
@@ -2994,14 +2995,14 @@ static int smack_socket_getpeersec_dgram(struct socket *sock,
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
@@ -3032,7 +3033,7 @@ static void smack_sock_graft(struct sock *sk, struct socket *parent)
 	    (sk->sk_family != PF_INET && sk->sk_family != PF_INET6))
 		return;
 
-	ssp = sk->sk_security;
+	ssp = lsm_get_sock(sk, &smack_ops);
 	ssp->smk_in = ssp->smk_out = smk_of_current();
 	/* cssp->smk_packet is already set in smack_inet_csk_clone() */
 }
@@ -3051,7 +3052,7 @@ static int smack_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 {
 	u16 family = sk->sk_family;
 	struct smack_known *skp;
-	struct socket_smack *ssp = sk->sk_security;
+	struct socket_smack *ssp = lsm_get_sock(sk, &smack_ops);
 	struct netlbl_lsm_secattr secattr;
 	struct sockaddr_in addr;
 	struct iphdr *hdr;
@@ -3125,7 +3126,7 @@ static int smack_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 static void smack_inet_csk_clone(struct sock *sk,
 				 const struct request_sock *req)
 {
-	struct socket_smack *ssp = sk->sk_security;
+	struct socket_smack *ssp = lsm_get_sock(sk, &smack_ops);
 
 	if (req->peer_secid != 0)
 		ssp->smk_packet = smack_from_secid(req->peer_secid);
@@ -3155,7 +3156,8 @@ static void smack_inet_csk_clone(struct sock *sk,
 static int smack_key_alloc(struct key *key, const struct cred *cred,
 			   unsigned long flags)
 {
-	key->security = smk_of_task(cred->security);
+	lsm_set_key(key, smk_of_task(lsm_get_cred(cred, &smack_ops)),
+			&smack_ops);
 	return 0;
 }
 
@@ -3167,7 +3169,7 @@ static int smack_key_alloc(struct key *key, const struct cred *cred,
  */
 static void smack_key_free(struct key *key)
 {
-	key->security = NULL;
+	lsm_set_key(key, NULL, &smack_ops);
 }
 
 /*
@@ -3184,7 +3186,7 @@ static int smack_key_permission(key_ref_t key_ref,
 {
 	struct key *keyp;
 	struct smk_audit_info ad;
-	char *tsp = smk_of_task(cred->security);
+	char *tsp = smk_of_task(lsm_get_cred(cred, &smack_ops));
 
 	keyp = key_ref_to_ptr(key_ref);
 	if (keyp == NULL)
@@ -3193,7 +3195,7 @@ static int smack_key_permission(key_ref_t key_ref,
 	 * If the key hasn't been initialized give it access so that
 	 * it may do so.
 	 */
-	if (keyp->security == NULL)
+	if (lsm_get_key(keyp, &smack_ops) == NULL)
 		return 0;
 	/*
 	 * This should not occur
@@ -3205,7 +3207,7 @@ static int smack_key_permission(key_ref_t key_ref,
 	ad.a.u.key_struct.key = keyp->serial;
 	ad.a.u.key_struct.key_desc = keyp->description;
 #endif
-	return smk_access(tsp, keyp->security,
+	return smk_access(tsp, lsm_get_key(keyp, &smack_ops),
 				 MAY_READWRITE, &ad);
 }
 #endif /* CONFIG_KEYS */
@@ -3588,7 +3590,7 @@ static __init int smack_init(void)
 	 * Set the security state for the initial task.
 	 */
 	cred = (struct cred *) current->cred;
-	cred->security = tsp;
+	lsm_set_cred(cred, tsp, &smack_ops);
 
 	/* initialize the smack_known_list */
 	init_smack_known_list();
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 53a08b8..af7629c 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -165,7 +165,7 @@ static void smk_netlabel_audit_set(struct netlbl_audit *nap)
 {
 	nap->loginuid = audit_get_loginuid(current);
 	nap->sessionid = audit_get_sessionid(current);
-	nap->secid = smack_to_secid(smk_of_current());
+	lsm_init_secid(&nap->secid, smack_to_secid(smk_of_current()), 0);
 }
 
 /*
@@ -1645,7 +1645,7 @@ static ssize_t smk_write_onlycap(struct file *file, const char __user *buf,
 				 size_t count, loff_t *ppos)
 {
 	char *data;
-	char *sp = smk_of_task(current->cred->security);
+	char *sp = smk_of_task(lsm_get_cred(current_cred(), &smack_ops));
 	int rc = count;
 
 	if (!smack_privileged(CAP_MAC_ADMIN))
@@ -1759,14 +1759,14 @@ static const struct file_operations smk_logging_ops = {
 
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
@@ -1813,7 +1813,7 @@ static int smk_open_load_self(struct inode *inode, struct file *file)
 static ssize_t smk_write_load_self(struct file *file, const char __user *buf,
 			      size_t count, loff_t *ppos)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = lsm_get_cred(current_cred(), &smack_ops);
 
 	return smk_write_rules_list(file, buf, count, ppos, &tsp->smk_rules,
 				    &tsp->smk_rules_lock, SMK_FIXED24_FMT);
@@ -1968,14 +1968,14 @@ static const struct file_operations smk_load2_ops = {
 
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
@@ -2021,7 +2021,7 @@ static int smk_open_load_self2(struct inode *inode, struct file *file)
 static ssize_t smk_write_load_self2(struct file *file, const char __user *buf,
 			      size_t count, loff_t *ppos)
 {
-	struct task_smack *tsp = current_security();
+	struct task_smack *tsp = lsm_get_cred(current_cred(), &smack_ops);
 
 	return smk_write_rules_list(file, buf, count, ppos, &tsp->smk_rules,
 				    &tsp->smk_rules_lock, SMK_LONG_FMT);
diff --git a/security/tomoyo/common.h b/security/tomoyo/common.h
index b897d48..9285c23 100644
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
@@ -1084,6 +1085,7 @@ extern struct tomoyo_domain_info tomoyo_kernel_domain;
 extern struct tomoyo_policy_namespace tomoyo_kernel_namespace;
 extern unsigned int tomoyo_memory_quota[TOMOYO_MAX_MEMORY_STAT];
 extern unsigned int tomoyo_memory_used[TOMOYO_MAX_MEMORY_STAT];
+extern struct security_operations tomoyo_ops;
 
 /********** Inlined functions. **********/
 
@@ -1202,7 +1204,7 @@ static inline void tomoyo_put_group(struct tomoyo_group *group)
  */
 static inline struct tomoyo_domain_info *tomoyo_domain(void)
 {
-	return current_cred()->security;
+	return lsm_get_cred(current_cred(), &tomoyo_ops);
 }
 
 /**
diff --git a/security/tomoyo/domain.c b/security/tomoyo/domain.c
index 3865145..e90482a 100644
--- a/security/tomoyo/domain.c
+++ b/security/tomoyo/domain.c
@@ -840,7 +840,7 @@ force_jump_domain:
 		domain = old_domain;
 	/* Update reference count on "struct tomoyo_domain_info". */
 	atomic_inc(&domain->users);
-	bprm->cred->security = domain;
+	lsm_set_cred(bprm->cred, domain, &tomoyo_ops);
 	kfree(exename.name);
 	if (!retval) {
 		ee->r.domain = domain;
diff --git a/security/tomoyo/securityfs_if.c b/security/tomoyo/securityfs_if.c
index 179a955..c7afa26 100644
--- a/security/tomoyo/securityfs_if.c
+++ b/security/tomoyo/securityfs_if.c
@@ -75,8 +75,9 @@ static ssize_t tomoyo_write_self(struct file *file, const char __user *buf,
 					error = -ENOMEM;
 				} else {
 					struct tomoyo_domain_info *old_domain =
-						cred->security;
-					cred->security = new_domain;
+						lsm_get_cred(cred, &tomoyo_ops);
+					lsm_set_cred(cred, new_domain,
+						&tomoyo_ops);
 					atomic_inc(&new_domain->users);
 					atomic_dec(&old_domain->users);
 					commit_creds(cred);
@@ -241,7 +242,7 @@ static int __init tomoyo_initerface_init(void)
 	struct dentry *tomoyo_dir;
 
 	/* Don't create securityfs entries unless registered. */
-	if (current_cred()->security != &tomoyo_kernel_domain)
+	if (lsm_get_cred(current_cred(), &tomoyo_ops) != &tomoyo_kernel_domain)
 		return 0;
 
 	tomoyo_dir = securityfs_create_dir("tomoyo", NULL);
diff --git a/security/tomoyo/tomoyo.c b/security/tomoyo/tomoyo.c
index f0b756e..624d8f2 100644
--- a/security/tomoyo/tomoyo.c
+++ b/security/tomoyo/tomoyo.c
@@ -17,7 +17,7 @@
  */
 static int tomoyo_cred_alloc_blank(struct cred *new, gfp_t gfp)
 {
-	new->security = NULL;
+	lsm_set_cred(new, NULL, &tomoyo_ops);
 	return 0;
 }
 
@@ -33,8 +33,8 @@ static int tomoyo_cred_alloc_blank(struct cred *new, gfp_t gfp)
 static int tomoyo_cred_prepare(struct cred *new, const struct cred *old,
 			       gfp_t gfp)
 {
-	struct tomoyo_domain_info *domain = old->security;
-	new->security = domain;
+	struct tomoyo_domain_info *domain = lsm_get_cred(old, &tomoyo_ops);
+	lsm_set_cred(new, domain, &tomoyo_ops);
 	if (domain)
 		atomic_inc(&domain->users);
 	return 0;
@@ -58,7 +58,7 @@ static void tomoyo_cred_transfer(struct cred *new, const struct cred *old)
  */
 static void tomoyo_cred_free(struct cred *cred)
 {
-	struct tomoyo_domain_info *domain = cred->security;
+	struct tomoyo_domain_info *domain = lsm_get_cred(cred, &tomoyo_ops);
 	if (domain)
 		atomic_dec(&domain->users);
 }
@@ -99,12 +99,12 @@ static int tomoyo_bprm_set_creds(struct linux_binprm *bprm)
 	 * tomoyo_find_next_domain().
 	 */
 	atomic_dec(&((struct tomoyo_domain_info *)
-		     bprm->cred->security)->users);
+		     lsm_get_cred(bprm->cred, &tomoyo_ops))->users);
 	/*
 	 * Tell tomoyo_bprm_check_security() is called for the first time of an
 	 * execve operation.
 	 */
-	bprm->cred->security = NULL;
+	lsm_set_cred(bprm->cred, NULL, &tomoyo_ops);
 	return 0;
 }
 
@@ -117,7 +117,8 @@ static int tomoyo_bprm_set_creds(struct linux_binprm *bprm)
  */
 static int tomoyo_bprm_check_security(struct linux_binprm *bprm)
 {
-	struct tomoyo_domain_info *domain = bprm->cred->security;
+	struct tomoyo_domain_info *domain =
+		lsm_get_cred(bprm->cred, &tomoyo_ops);
 
 	/*
 	 * Execute permission is checked against pathname passed to do_execve()
@@ -503,7 +504,7 @@ static int tomoyo_socket_sendmsg(struct socket *sock, struct msghdr *msg,
  * tomoyo_security_ops is a "struct security_operations" which is used for
  * registering TOMOYO.
  */
-static struct security_operations tomoyo_security_ops = {
+struct security_operations tomoyo_ops = {
 	.name                = "tomoyo",
 	.cred_alloc_blank    = tomoyo_cred_alloc_blank,
 	.cred_prepare        = tomoyo_cred_prepare,
@@ -547,13 +548,13 @@ static int __init tomoyo_init(void)
 {
 	struct cred *cred = (struct cred *) current_cred();
 
-	if (!security_module_enable(&tomoyo_security_ops))
+	if (!security_module_enable(&tomoyo_ops))
 		return 0;
 	/* register ourselves with the security framework */
-	if (register_security(&tomoyo_security_ops))
+	if (register_security(&tomoyo_ops))
 		panic("Failure registering TOMOYO Linux");
 	printk(KERN_INFO "TOMOYO Linux initialized\n");
-	cred->security = &tomoyo_kernel_domain;
+	lsm_set_cred(cred, &tomoyo_kernel_domain, &tomoyo_ops);
 	tomoyo_mm_init();
 	return 0;
 }


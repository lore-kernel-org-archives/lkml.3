Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab3DWQFB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:05:01 -0400
Received: from nm5.access.bullet.mail.sp2.yahoo.com ([98.139.44.132]:30200
	"EHLO nm5.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932153Ab3DWQEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:04:55 -0400
X-Yahoo-Newman-Id: 710134.62072.bm@smtp105.biz.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: sy530hcVM1l13T9hf33IUWfPLA0nixD3YZAzpGG.2mrNqo_
 SPKW11gyUCFttYIDFVrY.QoJhVcbWuEzLZJWPdOOOSwonMq.BplnZIzGKaai
 vKVX9wWigZ0eHCi5TNvAbdSrAZE__nFp.3yGE.07Ebu.5kH3QDFp3.YJKyUi
 qNof.5rBwE0FvN0WmVeQ.a..fl1iO81l3BcOasHXPYXcXDYYz.wGLnpILsNi
 lqOB49wCRu2snha8NqkhOQoejnzLBIqL_MjIzwIYMHhqmVs2OCxYZRgZEVE0
 AxvQ5zbYIMJWttLyNfxu9mDNeg1vXLATidYT3ZrZRzCSzxE9nn3Xyh2zKHDE
 PD.LcWMLmTdNfPH_EG8Mwgj9RjPE4nPyrB8YvV3XhtiLzWxX.vHfr37SfmFs
 ea9Y3X8qWHqTpUmZKkSX1wfOK4I1pdVAO_cCZFAkOsFdwkAWLKsNpcUAT0vb
 hNw--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with plain)
        by smtp105.biz.mail.ne1.yahoo.com with SMTP; 23 Apr 2013 09:04:53 -0700 PDT
Message-ID: <5176B126.2050700@schaufler-ca.com>
Date: Tue, 23 Apr 2013 09:04:54 -0700
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
Subject: [PATCH v13 8/9] LSM: Hook list management
References: <5176ABB7.5080300@schaufler-ca.com>
In-Reply-To: <5176ABB7.5080300@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH v13 8/9] LSM: Hook list management

Implement a list for each LSM hook. Execute all of the
registered hooks in the specified order. Manage security
blobs on behalf of the modules. Integrate with the
NetLabel, xfrm and secmark networking components. Move
the capablity module directly into the hook handlers.
Provide securityfs interfaces to display which lsms are
active and which is using the legacy interfaces in
/proc/pid/attr. Bring all existing modules in line with
the new world order.


Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---
 include/linux/lsm.h                                |   75 +-
 include/linux/security.h                           |  290 ++-
 include/net/xfrm.h                                 |    2 +-
 kernel/audit.c                                     |    6 +-
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |    2 +-
 net/netfilter/nf_conntrack_netlink.c               |   14 +-
 net/netfilter/nf_conntrack_standalone.c            |    3 +-
 security/Kconfig                                   |  176 +-
 security/apparmor/domain.c                         |   11 +-
 security/apparmor/lsm.c                            |   32 +-
 security/capability.c                              |    1 -
 security/commoncap.c                               |    6 -
 security/inode.c                                   |   79 +-
 security/security.c                                | 1975 ++++++++++++++++----
 security/selinux/hooks.c                           |   71 +-
 security/smack/smack_lsm.c                         |   50 +-
 security/smack/smackfs.c                           |    2 +-
 security/tomoyo/tomoyo.c                           |    8 +-
 security/yama/Kconfig                              |    1 +
 security/yama/yama_lsm.c                           |   34 +-
 20 files changed, 2233 insertions(+), 605 deletions(-)

diff --git a/include/linux/lsm.h b/include/linux/lsm.h
index 7c93865..d8ec5a4 100644
--- a/include/linux/lsm.h
+++ b/include/linux/lsm.h
@@ -10,11 +10,6 @@
  * Author:
  *	Casey Schaufler <casey@schaufler-ca.com>
  *
- * Abstraction layer for LSM security blobs.
- * This is pointless by itself, but necessary for multiple concurrent
- * modules support. Multiple concurrent module support is also refered
- * to as module stacking.
- *
  */
 #ifndef _LINUX_LSM_H
 #define _LINUX_LSM_H
@@ -27,124 +22,146 @@
 #include <linux/security.h>
 
 /*
- * Trivial implementation for the one-LSM-at-a-time case
+ * Just a set of slots for each LSM to keep its blob in.
  */
-static inline void *lsm_get_blob(const void *bp, const int lsm)
+struct lsm_blob {
+	int	lsm_setcount;			/* Number of blobs set */
+	void	*lsm_blobs[COMPOSER_MAX];	/* LSM specific blobs */
+};
+
+static inline struct lsm_blob *lsm_alloc_blob(gfp_t gfp)
 {
-	return (void *)bp;
+	return kzalloc(sizeof(struct lsm_blob), gfp);
+}
+
+static inline void *lsm_get_blob(const struct lsm_blob *bp, const int lsm)
+{
+	if (bp == NULL)
+		return NULL;
+	return bp->lsm_blobs[lsm];
 }
 
-/*
- * Trivial implementation for the one-LSM-at-a-time case
- */
 static inline void lsm_set_blob(void **vpp, void *value, const int lsm)
 {
-	*vpp = value;
+	struct lsm_blob *bp = *vpp;
+
+	if (value == NULL && bp->lsm_blobs[lsm] != NULL)
+		bp->lsm_setcount--;
+	if (value != NULL && bp->lsm_blobs[lsm] == NULL)
+		bp->lsm_setcount++;
+
+	bp->lsm_blobs[lsm] = value;
 }
 
 static inline void *lsm_get_cred(const struct cred *cred,
 					const struct security_operations *sop)
 {
-	return lsm_get_blob(cred->security, 0);
+	return lsm_get_blob(cred->security, sop->order);
 }
 
 static inline void lsm_set_cred(struct cred *cred, void *value,
 					const struct security_operations *sop)
 {
-	lsm_set_blob(&cred->security, value, 0);
+	lsm_set_blob(&cred->security, value, sop->order);
 }
 
 static inline int lsm_set_init_cred(struct cred *cred, void *value,
 					const struct security_operations *sop)
 {
-	cred->security = value;
+	if (cred->security == NULL) {
+		cred->security = lsm_alloc_blob(GFP_KERNEL);
+		if (cred->security == NULL)
+			return -ENOMEM;
+	}
+
+	lsm_set_blob(&cred->security, value, sop->order);
 	return 0;
 }
 
 static inline void *lsm_get_file(const struct file *file,
 					const struct security_operations *sop)
 {
-	return lsm_get_blob(file->f_security, 0);
+	return lsm_get_blob(file->f_security, sop->order);
 }
 
 static inline void lsm_set_file(struct file *file, void *value,
 					const struct security_operations *sop)
 {
-	lsm_set_blob(&file->f_security, value, 0);
+	lsm_set_blob(&file->f_security, value, sop->order);
 }
 
 static inline void *lsm_get_inode(const struct inode *inode,
 					const struct security_operations *sop)
 {
-	return lsm_get_blob(inode->i_security, 0);
+	return lsm_get_blob(inode->i_security, sop->order);
 }
 
 static inline void lsm_set_inode(struct inode *inode, void *value,
 					const struct security_operations *sop)
 {
-	lsm_set_blob(&inode->i_security, value, 0);
+	lsm_set_blob(&inode->i_security, value, sop->order);
 }
 
 static inline void *lsm_get_super(const struct super_block *super,
 					const struct security_operations *sop)
 {
-	return lsm_get_blob(super->s_security, 0);
+	return lsm_get_blob(super->s_security, sop->order);
 }
 
 static inline void lsm_set_super(struct super_block *super, void *value,
 					const struct security_operations *sop)
 {
-	lsm_set_blob(&super->s_security, value, 0);
+	lsm_set_blob(&super->s_security, value, sop->order);
 }
 
 static inline void *lsm_get_ipc(const struct kern_ipc_perm *ipc,
 					const struct security_operations *sop)
 {
-	return lsm_get_blob(ipc->security, 0);
+	return lsm_get_blob(ipc->security, sop->order);
 }
 
 static inline void lsm_set_ipc(struct kern_ipc_perm *ipc, void *value,
 					const struct security_operations *sop)
 {
-	lsm_set_blob(&ipc->security, value, 0);
+	lsm_set_blob(&ipc->security, value, sop->order);
 }
 
 static inline void *lsm_get_msg(const struct msg_msg *msg,
 					const struct security_operations *sop)
 {
-	return lsm_get_blob(msg->security, 0);
+	return lsm_get_blob(msg->security, sop->order);
 }
 
 static inline void lsm_set_msg(struct msg_msg *msg, void *value,
 					const struct security_operations *sop)
 {
-	lsm_set_blob(&msg->security, value, 0);
+	lsm_set_blob(&msg->security, value, sop->order);
 }
 
 #ifdef CONFIG_KEYS
 static inline void *lsm_get_key(const struct key *key,
 					const struct security_operations *sop)
 {
-	return lsm_get_blob(key->security, 0);
+	return lsm_get_blob(key->security, sop->order);
 }
 
 static inline void lsm_set_key(struct key *key, void *value,
 					const struct security_operations *sop)
 {
-	lsm_set_blob(&key->security, value, 0);
+	lsm_set_blob(&key->security, value, sop->order);
 }
 #endif
 
 static inline void *lsm_get_sock(const struct sock *sock,
 					const struct security_operations *sop)
 {
-	return lsm_get_blob(sock->sk_security, 0);
+	return lsm_get_blob(sock->sk_security, sop->order);
 }
 
 static inline void lsm_set_sock(struct sock *sock, void *value,
 					const struct security_operations *sop)
 {
-	lsm_set_blob(&sock->sk_security, value, 0);
+	lsm_set_blob(&sock->sk_security, value, sop->order);
 }
 
 #endif /* ! _LINUX_LSM_H */
diff --git a/include/linux/security.h b/include/linux/security.h
index da0fc7f..9a073b7 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -56,6 +56,10 @@ struct mm_struct;
 /* Maximum number of letters for an LSM name string */
 #define SECURITY_NAME_MAX	10
 
+/* Maximum number of LSMs that can be used at a time.  */
+#define COMPOSER_MAX            CONFIG_SECURITY_COMPOSER_MAX
+#define COMPOSER_NAMES_MAX      ((SECURITY_NAME_MAX + 1) * COMPOSER_MAX)
+
 /* If capable should audit the security request */
 #define SECURITY_CAP_NOAUDIT 0
 #define SECURITY_CAP_AUDIT 1
@@ -87,8 +91,6 @@ extern int cap_inode_removexattr(struct dentry *dentry, const char *name);
 extern int cap_inode_need_killpriv(struct dentry *dentry);
 extern int cap_inode_killpriv(struct dentry *dentry);
 extern int cap_mmap_addr(unsigned long addr);
-extern int cap_mmap_file(struct file *file, unsigned long reqprot,
-			 unsigned long prot, unsigned long flags);
 extern int cap_task_fix_setuid(struct cred *new, const struct cred *old, int flags);
 extern int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			  unsigned long arg4, unsigned long arg5);
@@ -112,8 +114,6 @@ struct seq_file;
 
 extern int cap_netlink_send(struct sock *sk, struct sk_buff *skb);
 
-void reset_security_ops(void);
-
 #ifdef CONFIG_MMU
 extern unsigned long mmap_min_addr;
 extern unsigned long dac_mmap_min_addr;
@@ -159,7 +159,9 @@ typedef int (*initxattrs) (struct inode *inode,
 /* A collection of secids, which are what (certain) LSMs deal with */
 struct secids {
 	int	si_count;
-	u32	si_lsm[1];
+#ifdef CONFIG_SECURITY
+	u32	si_lsm[COMPOSER_MAX];
+#endif
 };
 
 #ifdef CONFIG_SECURITY
@@ -190,15 +192,227 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
 	opts->num_mnt_opts = 0;
 }
 
+/*
+ * Index for LSM operations.
+ */
+enum lsm_hooks_index {
+	lsm_ptrace_access_check,
+	lsm_ptrace_traceme,
+	lsm_capget,
+	lsm_capset,
+	lsm_capable,
+	lsm_quotactl,
+	lsm_quota_on,
+	lsm_syslog,
+	lsm_settime,
+	lsm_vm_enough_memory,
+	lsm_bprm_set_creds,
+	lsm_bprm_check_security,
+	lsm_bprm_secureexec,
+	lsm_bprm_committing_creds,
+	lsm_bprm_committed_creds,
+	lsm_sb_alloc_security,
+	lsm_sb_free_security,
+	lsm_sb_copy_data,
+	lsm_sb_remount,
+	lsm_sb_kern_mount,
+	lsm_sb_show_options,
+	lsm_sb_statfs,
+	lsm_sb_mount,
+	lsm_sb_umount,
+	lsm_sb_pivotroot,
+	lsm_sb_set_mnt_opts,
+	lsm_sb_clone_mnt_opts,
+	lsm_sb_parse_opts_str,
+	lsm_path_unlink,
+	lsm_path_mkdir,
+	lsm_path_rmdir,
+	lsm_path_mknod,
+	lsm_path_truncate,
+	lsm_path_symlink,
+	lsm_path_link,
+	lsm_path_rename,
+	lsm_path_chmod,
+	lsm_path_chown,
+	lsm_path_chroot,
+	lsm_inode_alloc_security,
+	lsm_inode_free_security,
+	lsm_inode_init_security,
+	lsm_inode_create,
+	lsm_inode_link,
+	lsm_inode_unlink,
+	lsm_inode_symlink,
+	lsm_inode_mkdir,
+	lsm_inode_rmdir,
+	lsm_inode_mknod,
+	lsm_inode_rename,
+	lsm_inode_readlink,
+	lsm_inode_follow_link,
+	lsm_inode_permission,
+	lsm_inode_setattr,
+	lsm_inode_getattr,
+	lsm_inode_setxattr,
+	lsm_inode_post_setxattr,
+	lsm_inode_getxattr,
+	lsm_inode_listxattr,
+	lsm_inode_removexattr,
+	lsm_inode_need_killpriv,
+	lsm_inode_killpriv,
+	lsm_inode_getsecurity,
+	lsm_inode_setsecurity,
+	lsm_inode_listsecurity,
+	lsm_inode_getsecid,
+	lsm_file_permission,
+	lsm_file_alloc_security,
+	lsm_file_free_security,
+	lsm_file_ioctl,
+	lsm_mmap_addr,
+	lsm_mmap_file,
+	lsm_file_mprotect,
+	lsm_file_lock,
+	lsm_file_fcntl,
+	lsm_file_set_fowner,
+	lsm_file_send_sigiotask,
+	lsm_file_receive,
+	lsm_file_open,
+	lsm_task_create,
+	lsm_task_free,
+	lsm_cred_alloc_blank,
+	lsm_cred_free,
+	lsm_cred_prepare,
+	lsm_cred_transfer,
+	lsm_kernel_act_as,
+	lsm_kernel_create_files_as,
+	lsm_kernel_module_request,
+	lsm_kernel_module_from_file,
+	lsm_task_fix_setuid,
+	lsm_task_setpgid,
+	lsm_task_getpgid,
+	lsm_task_getsid,
+	lsm_task_getsecid,
+	lsm_task_setnice,
+	lsm_task_setioprio,
+	lsm_task_getioprio,
+	lsm_task_setrlimit,
+	lsm_task_setscheduler,
+	lsm_task_getscheduler,
+	lsm_task_movememory,
+	lsm_task_kill,
+	lsm_task_wait,
+	lsm_task_prctl,
+	lsm_task_to_inode,
+	lsm_ipc_permission,
+	lsm_ipc_getsecid,
+	lsm_msg_msg_alloc_security,
+	lsm_msg_msg_free_security,
+	lsm_msg_queue_alloc_security,
+	lsm_msg_queue_free_security,
+	lsm_msg_queue_associate,
+	lsm_msg_queue_msgctl,
+	lsm_msg_queue_msgsnd,
+	lsm_msg_queue_msgrcv,
+	lsm_shm_alloc_security,
+	lsm_shm_free_security,
+	lsm_shm_associate,
+	lsm_shm_shmctl,
+	lsm_shm_shmat,
+	lsm_sem_alloc_security,
+	lsm_sem_free_security,
+	lsm_sem_associate,
+	lsm_sem_semctl,
+	lsm_sem_semop,
+	lsm_netlink_send,
+	lsm_d_instantiate,
+	lsm_getprocattr,
+	lsm_setprocattr,
+	lsm_secid_to_secctx,
+	lsm_secctx_to_secid,
+	lsm_release_secctx,
+	lsm_inode_notifysecctx,
+	lsm_inode_setsecctx,
+	lsm_inode_getsecctx,
+	lsm_unix_stream_connect,
+	lsm_unix_may_send,
+	lsm_socket_create,
+	lsm_socket_post_create,
+	lsm_socket_bind,
+	lsm_socket_connect,
+	lsm_socket_listen,
+	lsm_socket_accept,
+	lsm_socket_sendmsg,
+	lsm_socket_recvmsg,
+	lsm_socket_getsockname,
+	lsm_socket_getpeername,
+	lsm_socket_getsockopt,
+	lsm_socket_setsockopt,
+	lsm_socket_shutdown,
+	lsm_socket_sock_rcv_skb,
+	lsm_socket_getpeersec_stream,
+	lsm_socket_getpeersec_dgram,
+	lsm_sk_alloc_security,
+	lsm_sk_free_security,
+	lsm_sk_clone_security,
+	lsm_sk_getsecid,
+	lsm_sock_graft,
+	lsm_inet_conn_request,
+	lsm_inet_csk_clone,
+	lsm_inet_conn_established,
+	lsm_secmark_relabel_packet,
+	lsm_secmark_refcount_inc,
+	lsm_secmark_refcount_dec,
+	lsm_req_classify_flow,
+	lsm_tun_dev_alloc_security,
+	lsm_tun_dev_free_security,
+	lsm_tun_dev_create,
+	lsm_tun_dev_attach_queue,
+	lsm_tun_dev_attach,
+	lsm_tun_dev_open,
+	lsm_skb_owned_by,
+	lsm_xfrm_policy_alloc_security,
+	lsm_xfrm_policy_clone_security,
+	lsm_xfrm_policy_free_security,
+	lsm_xfrm_policy_delete_security,
+	lsm_xfrm_state_alloc_security,
+	lsm_xfrm_state_free_security,
+	lsm_xfrm_state_delete_security,
+	lsm_xfrm_policy_lookup,
+	lsm_xfrm_state_pol_flow_match,
+	lsm_xfrm_decode_session,
+	lsm_key_alloc,
+	lsm_key_free,
+	lsm_key_permission,
+	lsm_key_getsecurity,
+	lsm_audit_rule_init,
+	lsm_audit_rule_known,
+	lsm_audit_rule_match,
+	lsm_audit_rule_free,
+	lsm_name, /* Used by security/inode.c */
+	LSM_MAX_HOOKS
+};
+
+/*
+ * There is a list for each hook.
+ */
+extern struct list_head lsm_hooks[LSM_MAX_HOOKS];
+
 /**
  * struct security_operations - main security structure
  *
  * Security module identifier.
  *
+ * @list:
+ *	An array of lists of hooks. These are traversed on
+ *	hook execution.
+ *
  * @name:
  *	A string that acts as a unique identifier for the LSM with max number
  *	of characters = SECURITY_NAME_MAX.
  *
+ * @order:
+ *	The numeric order in which this LSM will be invoked.
+ *	Set during LSM initialization. Used to identify
+ *	which security blob to use when there is more than one LSM.
+ *
  * Security hooks for program execution operations.
  *
  * @bprm_set_creds:
@@ -1408,7 +1622,9 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  * This is the main security structure.
  */
 struct security_operations {
+	struct list_head list[LSM_MAX_HOOKS];
 	char name[SECURITY_NAME_MAX + 1];
+	int order;
 
 	int (*ptrace_access_check) (struct task_struct *child, unsigned int mode);
 	int (*ptrace_traceme) (struct task_struct *parent);
@@ -1690,14 +1906,19 @@ struct security_operations {
 	void (*audit_rule_free) (void *lsmrule);
 #endif /* CONFIG_AUDIT */
 };
-extern struct security_operations *security_ops;
+
+/*
+ * The security operations vector for /proc interfaces.
+ */
+extern struct security_operations *lsm_present;
 
 /* prototypes */
 extern int security_init(void);
 extern int security_module_enable(struct security_operations *ops);
-extern int register_security(struct security_operations *ops);
-extern void __init security_fixup_ops(struct security_operations *ops);
 
+#ifdef CONFIG_SECURITY_SELINUX_DISABLE
+extern void security_module_disable(struct security_operations *ops);
+#endif /* CONFIG_SECURITY_SELINUX_DISABLE */
 
 /* Security operations */
 int security_ptrace_access_check(struct task_struct *child, unsigned int mode);
@@ -2198,7 +2419,7 @@ static inline int security_inode_listsecurity(struct inode *inode, char *buffer,
 
 static inline void security_inode_getsecid(const struct inode *inode, struct secids *secid)
 {
-	secid->si_lsm[0] = 0;
+	*secid = 0;
 }
 
 static inline int security_file_permission(struct file *file, int mask)
@@ -2345,7 +2566,7 @@ static inline int security_task_getsid(struct task_struct *p)
 
 static inline void security_task_getsecid(struct task_struct *p, struct secids *secid)
 {
-	secid->si_lsm[0] = 0;
+	*secid = 0;
 }
 
 static inline int security_task_setnice(struct task_struct *p, int nice)
@@ -2416,7 +2637,7 @@ static inline int security_ipc_permission(struct kern_ipc_perm *ipcp,
 
 static inline void security_ipc_getsecid(struct kern_ipc_perm *ipcp, struct secids *secid)
 {
-	secid->si_lsm[0] = 0;
+	*secid = 0;
 }
 
 static inline int security_msg_msg_alloc(struct msg_msg *msg)
@@ -2605,11 +2826,13 @@ int security_tun_dev_open(void *security);
 
 void security_skb_owned_by(struct sk_buff *skb, struct sock *sk);
 
+extern struct security_operations *lsm_secmark_ops;
+
 static inline int security_secmark_secctx_to_secid(const char *secdata,
						u32 seclen, u32 *secid)
 {
-	if (security_ops && security_ops->secctx_to_secid)
-		return security_ops->secctx_to_secid(secdata, seclen, secid);
+	if (lsm_secmark_ops && lsm_secmark_ops->secctx_to_secid)
+		return lsm_secmark_ops->secctx_to_secid(secdata, seclen, secid);
 	*secid = 0;
 	return 0;
 }
@@ -2837,11 +3060,13 @@ int security_xfrm_state_pol_flow_match(struct xfrm_state *x,
 int security_xfrm_decode_session(struct sk_buff *skb, u32 *secid);
 void security_skb_classify_flow(struct sk_buff *skb, struct flowi *fl);
 
+extern struct security_operations *lsm_xfrm_ops;
+
 static inline void security_xfrm_task_getsecid(struct task_struct *p,
 						u32 *secid)
 {
-	if (security_ops && security_ops->task_getsecid)
-		security_ops->task_getsecid(p, secid);
+	if (lsm_xfrm_ops && lsm_xfrm_ops->task_getsecid)
+		lsm_xfrm_ops->task_getsecid(p, secid);
 	else
 		*secid = 0;
 }
@@ -2849,8 +3074,8 @@ static inline void security_xfrm_task_getsecid(struct task_struct *p,
 static inline int security_xfrm_secid_to_secctx(u32 secid, char **secdata,
 						u32 *seclen)
 {
-	if (security_ops && security_ops->secid_to_secctx)
-		return security_ops->secid_to_secctx(secid, secdata, seclen);
+	if (lsm_xfrm_ops && lsm_xfrm_ops->secid_to_secctx)
+		return lsm_xfrm_ops->secid_to_secctx(secid, secdata, seclen);
 	return 0;
 }
 
@@ -3134,36 +3359,5 @@ static inline void free_secdata(void *secdata)
 { }
 #endif /* CONFIG_SECURITY */
 
-#ifdef CONFIG_SECURITY_YAMA
-extern int yama_ptrace_access_check(struct task_struct *child,
-				    unsigned int mode);
-extern int yama_ptrace_traceme(struct task_struct *parent);
-extern void yama_task_free(struct task_struct *task);
-extern int yama_task_prctl(int option, unsigned long arg2, unsigned long arg3,
-			   unsigned long arg4, unsigned long arg5);
-#else
-static inline int yama_ptrace_access_check(struct task_struct *child,
-					   unsigned int mode)
-{
-	return 0;
-}
-
-static inline int yama_ptrace_traceme(struct task_struct *parent)
-{
-	return 0;
-}
-
-static inline void yama_task_free(struct task_struct *task)
-{
-}
-
-static inline int yama_task_prctl(int option, unsigned long arg2,
-				  unsigned long arg3, unsigned long arg4,
-				  unsigned long arg5)
-{
-	return -ENOSYS;
-}
-#endif /* CONFIG_SECURITY_YAMA */
-
 #endif /* ! __LINUX_SECURITY_H */
 
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index a9f22be..6dde1d4 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -704,7 +704,7 @@ static inline void xfrm_audit_helper_usrinfo(kuid_t auid, u32 ses, u32 secid,
 	if (secid != 0 &&
 	    security_xfrm_secid_to_secctx(secid, &secctx, &secctx_len) == 0) {
 		audit_log_format(audit_buf, " subj=%s", secctx);
-		security_release_secctx(secctx, secctx_len, security_ops);
+		security_release_secctx(secctx, secctx_len, lsm_xfrm_ops);
 	} else
 		audit_log_task_context(audit_buf);
 }
diff --git a/kernel/audit.c b/kernel/audit.c
index a01ab21..1cca29d 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1549,9 +1549,13 @@ void audit_log_secctx(struct audit_buffer *ab, u32 secid)
 	struct secids secids;
 	struct security_operations *sop;
 
+	if (!lsm_secmark_ops)
+		return;
+
 	memset(&secids, 0, sizeof(secids));
 
-	secids.si_lsm[0] = secid;
+	secids.si_lsm[lsm_secmark_ops->order] = secid;
+	secids.si_count = 1;
 
 	if (security_secid_to_secctx(&secids, &secctx, &len, &sop)) {
 		audit_panic("Cannot convert secid to context");
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
index b42e160..03dd794 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
@@ -103,7 +103,7 @@ static int ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 
 	memset(&secid, 0, sizeof(secid));
 
-	secid.si_lsm[0] = ct->secmark;
+	secid.si_lsm[lsm_secmark_ops->order] = ct->secmark;
 	secid.si_count = 1;
 
 	ret = security_secid_to_secctx(&secid, &secctx, &len, &sop);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index cdcf9ab..7ebcbbf 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -304,7 +304,12 @@ ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 	struct secids secid;
 	struct security_operations *sop;
 
-	secid.si_lsm[0] = ct->secmark;
+	memset(&secid, 0, sizeof(secid));
+
+	if (lsm_secmark_ops) {
+		secid.si_lsm[lsm_secmark_ops->order] = ct->secmark;
+		secid.si_count = 1;
+	}
 
 	ret = security_secid_to_secctx(&secid, &secctx, &len, &sop);
 	if (ret)
@@ -555,7 +560,12 @@ ctnetlink_secctx_size(const struct nf_conn *ct)
 	struct secids secid;
 	struct security_operations *sop;
 
-	secid.si_lsm[0] = ct->secmark;
+	memset(&secid, 0, sizeof(secid));
+
+	if (lsm_secmark_ops) {
+		secid.si_lsm[lsm_secmark_ops->order] = ct->secmark;
+		secid.si_count = 1;
+	}
 
 	ret = security_secid_to_secctx(&secid, NULL, &len, &sop);
 	if (ret)
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index fc571d4..5f94265 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -128,7 +128,8 @@ static int ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 
 	memset(&secid, 0, sizeof(secid));
 
-	secid.si_lsm[0] = ct->secmark;
+	secid.si_lsm[lsm_secmark_ops->order] = ct->secmark;
+	secid.si_count = 1;
 
 	ret = security_secid_to_secctx(&secid, &secctx, &len, &sop);
 	if (ret)
diff --git a/security/Kconfig b/security/Kconfig
index e9c6ac7..b3a95b3 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -48,6 +48,40 @@ config SECURITY_NETWORK
 	  implement socket and networking access controls.
 	  If you are unsure how to answer this question, answer N.
 
+choice
+	depends on SECURITY && NETLABEL
+	prompt "Security module using Netlabel to label IP headers"
+	default NETLABEL_SECURITY_SMACK if SECURITY_SMACK
+	default NETLABEL_SECURITY_SELINUX if SECURITY_SELINUX
+
+	help
+	  Select the security module that will send attribute
+	  information in IP header options.
+	  Most SELinux configurations do not take advantage
+	  of Netlabel, while all Smack configurations do. Unless
+	  there is a need to do otherwise chose Smack in preference
+	  to SELinux.
+
+	config NETLABEL_SECURITY_SELINUX
+		bool "SELinux" if SECURITY_SELINUX=y
+		help
+		  Send SELinux MLS information in IP packet headers
+
+	config NETLABEL_SECURITY_SMACK
+		bool "Smack" if SECURITY_SMACK=y
+		help
+		  Send Smack labels in IP packet headers
+
+endchoice
+
+config NETLABEL_LSM
+	string
+	default "smack" if NETLABEL_SECURITY_SMACK
+	default "selinux" if NETLABEL_SECURITY_SELINUX
+	default "NOTHING"
+	help
+	  The name of the LSM to use with Netlabel
+
 config SECURITY_NETWORK_XFRM
 	bool "XFRM (IPSec) Networking Security Hooks"
 	depends on XFRM && SECURITY_NETWORK
@@ -61,6 +95,54 @@ config SECURITY_NETWORK_XFRM
 	  IPSec.
 	  If you are unsure how to answer this question, answer N.
 
+choice
+	depends on XFRM && SECURITY_NETWORK && SECURITY_NETWORK_XFRM
+	prompt "Security module providing the XFRM security hooks"
+	default XFRM_SECURITY_SELINUX if SECURITY_SELINUX
+
+	help
+	  Select the security module that will send attribute
+	  information based on IPSec policy
+	  Most SELinux configurations take advantage of XFRM.
+
+	config XFRM_SECURITY_SELINUX
+		bool "SELinux" if SECURITY_SELINUX=y
+		help
+		  Use SELinux IPSec policy
+
+endchoice
+
+choice
+	depends on SECURITY_NETWORK
+	prompt "Security module providing the secmark security hooks"
+	default SECMARK_SECURITY_SELINUX if SECURITY_SELINUX
+
+	help
+	  Select the security module that will send attribute
+	  information based on secmark policy
+	  Most SELinux configurations take advantage of secmark.
+
+	config SECMARK_SECURITY_SELINUX
+		bool "SELinux" if SECURITY_SELINUX=y
+		help
+		  Use SELinux secmark policy
+
+endchoice
+
+config SECMARK_LSM
+	string
+	default "selinux" if SECMARK_SECURITY_SELINUX
+	default "None"
+	help
+	  The name of the LSM to use with the networking secmark
+
+config XFRM_LSM
+	string
+	default "selinux" if XFRM_SECURITY_SELINUX
+	default "None"
+	help
+	  The name of the LSM to use with XFRM and IPSec policy
+
 config SECURITY_PATH
 	bool "Security hooks for pathname based access control"
 	depends on SECURITY
@@ -123,49 +205,89 @@ source security/tomoyo/Kconfig
 source security/apparmor/Kconfig
 source security/yama/Kconfig
 
+config SECURITY_COMPOSER_MAX
+	int "Maximum allowed security modules (1 to 12)"
+	depends on SECURITY
+	default 6
+	range 1 12
+	help
+	  The number of security modules that can be loaded.
+	  The default value allows for all of the upstream modules.
+	  The maximum allowed value is 12.
+
+config DEFAULT_SECURITY
+	string "Ordered list of LSMs to register"
+	depends on SECURITY
+	default "ALL"
+	help
+	  A comma separated list of LSMs to register.
+	  LSMs that are not configured that are listed
+	  will be ignored. If the "security=" option is
+	  specified in the boot line it will override
+	  this value. If the value is "ALL" all LSMs
+	  configured in the kernel will be loaded in
+	  the order they request registration.
+
 source security/integrity/Kconfig
 
 choice
-	prompt "Default security module"
-	default DEFAULT_SECURITY_SELINUX if SECURITY_SELINUX
-	default DEFAULT_SECURITY_SMACK if SECURITY_SMACK
-	default DEFAULT_SECURITY_TOMOYO if SECURITY_TOMOYO
-	default DEFAULT_SECURITY_APPARMOR if SECURITY_APPARMOR
-	default DEFAULT_SECURITY_YAMA if SECURITY_YAMA
-	default DEFAULT_SECURITY_DAC
+	depends on SECURITY
+	prompt "Presented security module"
+	default PRESENT_SECURITY_SELINUX \
+		if SECURITY_SELINUX && !(SECURITY_APPARMOR || SECURITY_SMACK)
+	default PRESENT_SECURITY_SMACK \
+		if SECURITY_SMACK && !(SECURITY_APPARMOR || SECURITY_SELINUX)
+	default PRESENT_SECURITY_APPARMOR \
+		if SECURITY_APPARMOR && !(SECURITY_SMACK || SECURITY_SELINUX)
+	default PRESENT_SECURITY_FIRST \
+		if SECURITY_APPARMOR || SECURITY_SMACK || SECURITY_SELINUX
+	default PRESENT_SECURITY_NONE
 
 	help
-	  Select the security module that will be used by default if the
-	  kernel parameter security= is not specified.
+	  Select the security module that will be presented
+	  with the /proc/*/attr interface.
+	  If not specified the first registered LSM that uses
+	  the /proc/*/attr interface will be chosen.
 
-	config DEFAULT_SECURITY_SELINUX
+	config PRESENT_SECURITY_SELINUX
 		bool "SELinux" if SECURITY_SELINUX=y
+		help
+		  Present SELinux context information in the
+		  files in /proc/*/attr
 
-	config DEFAULT_SECURITY_SMACK
+	config PRESENT_SECURITY_SMACK
 		bool "Simplified Mandatory Access Control" if SECURITY_SMACK=y
+		help
+		  Present Smack process label information
+		  in /proc/*/attr/current
 
-	config DEFAULT_SECURITY_TOMOYO
-		bool "TOMOYO" if SECURITY_TOMOYO=y
-
-	config DEFAULT_SECURITY_APPARMOR
+	config PRESENT_SECURITY_APPARMOR
 		bool "AppArmor" if SECURITY_APPARMOR=y
+		help
+		  Present AppArmor context information in the
+		  files in /proc/*/attr
 
-	config DEFAULT_SECURITY_YAMA
-		bool "Yama" if SECURITY_YAMA=y
+	config PRESENT_SECURITY_FIRST
+		bool "Use first registered LSM"
+		help
+		  Present information from the first LSM that uses
+		  /proc/*/attr in the files in /proc/*/attr
 
-	config DEFAULT_SECURITY_DAC
-		bool "Unix Discretionary Access Controls"
+	config PRESENT_SECURITY_NONE
+		bool "Present Nothing"
+		help
+		  Do not present LSM information in /proc/*/attr
 
 endchoice
 
-config DEFAULT_SECURITY
+config PRESENT_SECURITY
 	string
-	default "selinux" if DEFAULT_SECURITY_SELINUX
-	default "smack" if DEFAULT_SECURITY_SMACK
-	default "tomoyo" if DEFAULT_SECURITY_TOMOYO
-	default "apparmor" if DEFAULT_SECURITY_APPARMOR
-	default "yama" if DEFAULT_SECURITY_YAMA
-	default "" if DEFAULT_SECURITY_DAC
+	default "selinux" if PRESENT_SECURITY_SELINUX
+	default "smack" if PRESENT_SECURITY_SMACK
+	default "apparmor" if PRESENT_SECURITY_APPARMOR
+	default "FIRSTLSM" if PRESENT_SECURITY_FIRST
+	default "NOTHING"
+	help
+	  The name of the LSM to present in /proc/.../attr
 
 endmenu
-
diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index 1614111..e67c88c 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -353,9 +353,7 @@ int apparmor_bprm_set_creds(struct linux_binprm *bprm)
 		file_inode(bprm->file)->i_mode
 	};
 	const char *name = NULL, *target = NULL, *info = NULL;
-	int error = cap_bprm_set_creds(bprm);
-	if (error)
-		return error;
+	int error = 0;
 
 	if (bprm->cred_prepared)
 		return 0;
@@ -539,15 +537,10 @@ cleanup:
  */
 int apparmor_bprm_secureexec(struct linux_binprm *bprm)
 {
-	int ret = cap_bprm_secureexec(bprm);
-
 	/* the decision to use secure exec is computed in set_creds
 	 * and stored in bprm->unsafe.
 	 */
-	if (!ret && (bprm->unsafe & AA_SECURE_X_NEEDED))
-		ret = 1;
-
-	return ret;
+	return bprm->unsafe & AA_SECURE_X_NEEDED;
 }
 
 /**
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 8784681..6542339 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -96,19 +96,11 @@ static void apparmor_cred_transfer(struct cred *new, const struct cred *old)
 static int apparmor_ptrace_access_check(struct task_struct *child,
 					unsigned int mode)
 {
-	int error = cap_ptrace_access_check(child, mode);
-	if (error)
-		return error;
-
 	return aa_ptrace(current, child, mode);
 }
 
 static int apparmor_ptrace_traceme(struct task_struct *parent)
 {
-	int error = cap_ptrace_traceme(parent);
-	if (error)
-		return error;
-
 	return aa_ptrace(parent, current, PTRACE_MODE_ATTACH);
 }
 
@@ -140,14 +132,11 @@ static int apparmor_capable(const struct cred *cred, struct user_namespace *ns,
 			    int cap, int audit)
 {
 	struct aa_profile *profile;
-	/* cap_capable returns 0 on success, else -EPERM */
-	int error = cap_capable(cred, ns, cap, audit);
-	if (!error) {
-		profile = aa_cred_profile(cred);
-		if (!unconfined(profile))
-			error = aa_capable(current, profile, cap, audit);
-	}
-	return error;
+
+	profile = aa_cred_profile(cred);
+	if (!unconfined(profile))
+		return aa_capable(current, profile, cap, audit);
+	return 0;
 }
 
 /**
@@ -897,7 +886,7 @@ static int __init apparmor_init(void)
 {
 	int error;
 
-	if (!apparmor_enabled || !security_module_enable(&apparmor_ops)) {
+	if (!apparmor_enabled || security_module_enable(&apparmor_ops)) {
 		aa_info_message("AppArmor disabled by boot time parameter");
 		apparmor_enabled = 0;
 		return 0;
@@ -915,12 +904,6 @@ static int __init apparmor_init(void)
 		goto register_security_out;
 	}
 
-	error = register_security(&apparmor_ops);
-	if (error) {
-		AA_ERROR("Unable to register AppArmor\n");
-		goto set_init_cxt_out;
-	}
-
 	/* Report that AppArmor successfully initialized */
 	apparmor_initialized = 1;
 	if (aa_g_profile_mode == APPARMOR_COMPLAIN)
@@ -932,9 +915,6 @@ static int __init apparmor_init(void)
 
 	return error;
 
-set_init_cxt_out:
-	aa_free_task_context(current->real_cred->security);
-
 register_security_out:
 	aa_free_root_ns();
 
diff --git a/security/capability.c b/security/capability.c
index 08bca78..d7b2a38 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -975,7 +975,6 @@ void __init security_fixup_ops(struct security_operations *ops)
 	set_to_cap_if_null(ops, file_free_security);
 	set_to_cap_if_null(ops, file_ioctl);
 	set_to_cap_if_null(ops, mmap_addr);
-	set_to_cap_if_null(ops, mmap_file);
 	set_to_cap_if_null(ops, file_mprotect);
 	set_to_cap_if_null(ops, file_lock);
 	set_to_cap_if_null(ops, file_fcntl);
diff --git a/security/commoncap.c b/security/commoncap.c
index c44b6fe..3b12ab1 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -988,9 +988,3 @@ int cap_mmap_addr(unsigned long addr)
 	}
 	return ret;
 }
-
-int cap_mmap_file(struct file *file, unsigned long reqprot,
-		  unsigned long prot, unsigned long flags)
-{
-	return 0;
-}
diff --git a/security/inode.c b/security/inode.c
index 43ce6e1..1ca6aaf 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -21,6 +21,9 @@
 #include <linux/namei.h>
 #include <linux/security.h>
 #include <linux/magic.h>
+#ifdef CONFIG_SECURITY
+#include <linux/lsm.h>
+#endif
 
 static struct vfsmount *mount;
 static int mount_count;
@@ -215,6 +218,70 @@ void securityfs_remove(struct dentry *dentry)
 }
 EXPORT_SYMBOL_GPL(securityfs_remove);
 
+#ifdef CONFIG_SECURITY
+static struct dentry *lsm_dentry;
+static ssize_t lsm_read(struct file *filp, char __user *buf, size_t count,
+			loff_t *ppos)
+{
+	struct security_operations *sop;
+	char *data;
+	int len;
+
+	data = kzalloc(COMPOSER_NAMES_MAX + 1, GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
+	list_for_each_entry(sop, &lsm_hooks[lsm_name], list[lsm_name]) {
+		strcat(data, sop->name);
+		strcat(data, ",");
+	}
+	len = strlen(data);
+	if (len > 1)
+		data[len-1] = '\n';
+
+	len = simple_read_from_buffer(buf, count, ppos, data, len);
+	kfree(data);
+
+	return len;
+}
+
+static const struct file_operations lsm_ops = {
+	.read = lsm_read,
+	.llseek = generic_file_llseek,
+};
+
+static struct dentry *present_dentry;
+static ssize_t present_read(struct file *filp, char __user *buf, size_t count,
+			loff_t *ppos)
+{
+	struct security_operations *sop = lsm_present;
+	char *raw;
+	char *data;
+	int len;
+
+	if (sop)
+		raw = sop->name;
+	else
+		raw = "(none)";
+	len = strlen(raw);
+
+	data = kstrdup(raw, GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
+	data[len] = '\n';
+	len = simple_read_from_buffer(buf, count, ppos, data, len + 1);
+	kfree(data);
+
+	return len;
+}
+
+static const struct file_operations present_ops = {
+	.read = present_read,
+	.llseek = generic_file_llseek,
+};
+#endif /* CONFIG_SECURITY */
+
 static struct kobject *security_kobj;
 
 static int __init securityfs_init(void)
@@ -226,9 +293,17 @@ static int __init securityfs_init(void)
 		return -EINVAL;
 
 	retval = register_filesystem(&fs_type);
-	if (retval)
+	if (retval) {
 		kobject_put(security_kobj);
-	return retval;
+		return retval;
+	}
+#ifdef CONFIG_SECURITY
+	lsm_dentry = securityfs_create_file("lsm", S_IRUGO, NULL, NULL,
+		&lsm_ops);
+	present_dentry = securityfs_create_file("present", S_IRUGO, NULL, NULL,
+		&present_ops);
+#endif /* CONFIG_SECURITY */
+	return 0;
 }
 
 core_initcall(securityfs_init);
diff --git a/security/security.c b/security/security.c
index 67e435b..86147c4 100644
--- a/security/security.c
+++ b/security/security.c
@@ -25,32 +25,331 @@
 #include <linux/personality.h>
 #include <linux/backing-dev.h>
 #include <net/flow.h>
+#include <linux/lsm.h>
+#include <linux/shm.h>
+#include <linux/string.h>
+#ifdef CONFIG_NETLABEL_LSM
+#include <net/netlabel.h>
+#endif
 
 #define MAX_LSM_EVM_XATTR	2
+#define PRESENT_FIRST		"FIRSTLSM"
 
 /* Boot-time LSM user choice */
-static __initdata char chosen_lsm[SECURITY_NAME_MAX + 1] =
-	CONFIG_DEFAULT_SECURITY;
 
-struct security_operations *security_ops;
-EXPORT_SYMBOL(security_ops);
+static __initdata int lsm_order_set;
+static __initdata char specified_lsms[COMPOSER_MAX][SECURITY_NAME_MAX + 1];
+static __initdata char allowed_lsms[COMPOSER_NAMES_MAX];
+static __initdata char present_lsm[SECURITY_NAME_MAX + 1] =
+	CONFIG_PRESENT_SECURITY;
+
+struct list_head lsm_hooks[LSM_MAX_HOOKS];
+struct security_operations *lsm_present;
+struct security_operations *lsm_secmark_ops;
+EXPORT_SYMBOL(lsm_secmark_ops);
+#ifdef CONFIG_SECURITY_NETWORK_XFRM
+struct security_operations *lsm_xfrm_ops;
+EXPORT_SYMBOL(lsm_xfrm_ops);
+#endif
+
+static int (*present_getprocattr)
+		(struct task_struct *p, char *name, char **value);
+static int (*present_setprocattr)
+		(struct task_struct *p, char *name, void *value, size_t size);
 
-static struct security_operations default_security_ops = {
-	.name	= "default",
-};
+static int lsm_count;
 
-static inline int __init verify(struct security_operations *ops)
+#define for_each_hook(SOP, HOOK) \
+	list_for_each_entry(SOP, &lsm_hooks[lsm_##HOOK], list[lsm_##HOOK])
+
+/*
+ * Add an entry to a list of security operation vectors.
+ * The "interesting" logic is included here rather than in the
+ * caller to reduce the volume of the calling code.
+ */
+static void __init lsm_enlist(struct security_operations *ops,
+				const enum lsm_hooks_index index,
+				void *interesting)
 {
-	/* verify the security_operations structure exists */
-	if (!ops)
-		return -EINVAL;
-	security_fixup_ops(ops);
-	return 0;
+	struct security_operations *sop;
+
+	if (!interesting) {
+		INIT_LIST_HEAD(&ops->list[index]);
+		return;
+	}
+
+	if (list_empty(&lsm_hooks[index])) {
+		list_add_rcu(&ops->list[index], &lsm_hooks[index]);
+		return;
+	}
+
+	list_for_each_entry(sop, &lsm_hooks[index], list[index]) {
+		if (ops->order < sop->order) {
+			list_add_tail_rcu(&ops->list[index], &sop->list[index]);
+			return;
+		}
+		if (list_is_last(&sop->list[index], &lsm_hooks[index])) {
+			list_add_rcu(&ops->list[index], &sop->list[index]);
+			return;
+		}
+	}
+}
+
+static void __init lsm_enlist_ops(struct security_operations *sop)
+{
+	lsm_enlist(sop, lsm_ptrace_access_check, sop->ptrace_access_check);
+	lsm_enlist(sop, lsm_ptrace_traceme, sop->ptrace_traceme);
+	lsm_enlist(sop, lsm_capget, sop->capget);
+	lsm_enlist(sop, lsm_capset, sop->capset);
+	lsm_enlist(sop, lsm_capable, sop->capable);
+	lsm_enlist(sop, lsm_quotactl, sop->quotactl);
+	lsm_enlist(sop, lsm_quota_on, sop->quota_on);
+	lsm_enlist(sop, lsm_syslog, sop->syslog);
+	lsm_enlist(sop, lsm_settime, sop->settime);
+	lsm_enlist(sop, lsm_vm_enough_memory, sop->vm_enough_memory);
+	lsm_enlist(sop, lsm_bprm_set_creds, sop->bprm_set_creds);
+	lsm_enlist(sop, lsm_bprm_check_security, sop->bprm_check_security);
+	lsm_enlist(sop, lsm_bprm_committing_creds, sop->bprm_committing_creds);
+	lsm_enlist(sop, lsm_bprm_committed_creds, sop->bprm_committed_creds);
+	lsm_enlist(sop, lsm_bprm_secureexec, sop->bprm_secureexec);
+	lsm_enlist(sop, lsm_sb_alloc_security, sop->sb_alloc_security);
+	lsm_enlist(sop, lsm_sb_free_security, sop->sb_free_security);
+	lsm_enlist(sop, lsm_sb_copy_data, sop->sb_copy_data);
+	lsm_enlist(sop, lsm_sb_remount, sop->sb_remount);
+	lsm_enlist(sop, lsm_sb_kern_mount, sop->sb_kern_mount);
+	lsm_enlist(sop, lsm_sb_show_options, sop->sb_show_options);
+	lsm_enlist(sop, lsm_sb_statfs, sop->sb_statfs);
+	lsm_enlist(sop, lsm_sb_mount, sop->sb_mount);
+	lsm_enlist(sop, lsm_sb_umount, sop->sb_umount);
+	lsm_enlist(sop, lsm_sb_pivotroot, sop->sb_pivotroot);
+	lsm_enlist(sop, lsm_sb_set_mnt_opts, sop->sb_set_mnt_opts);
+	lsm_enlist(sop, lsm_sb_clone_mnt_opts, sop->sb_clone_mnt_opts);
+	lsm_enlist(sop, lsm_sb_parse_opts_str, sop->sb_parse_opts_str);
+	lsm_enlist(sop, lsm_inode_alloc_security, sop->inode_alloc_security);
+	lsm_enlist(sop, lsm_inode_free_security, sop->inode_free_security);
+	lsm_enlist(sop, lsm_inode_init_security, sop->inode_init_security);
+#ifdef CONFIG_SECURITY_PATH
+	lsm_enlist(sop, lsm_path_mknod, sop->path_mknod);
+	lsm_enlist(sop, lsm_path_mkdir, sop->path_mkdir);
+	lsm_enlist(sop, lsm_path_rmdir, sop->path_rmdir);
+	lsm_enlist(sop, lsm_path_unlink, sop->path_unlink);
+	lsm_enlist(sop, lsm_path_symlink, sop->path_symlink);
+	lsm_enlist(sop, lsm_path_link, sop->path_link);
+	lsm_enlist(sop, lsm_path_rename, sop->path_rename);
+	lsm_enlist(sop, lsm_path_truncate, sop->path_truncate);
+	lsm_enlist(sop, lsm_path_chmod, sop->path_chmod);
+	lsm_enlist(sop, lsm_path_chown, sop->path_chown);
+	lsm_enlist(sop, lsm_path_chroot, sop->path_chroot);
+#endif
+	lsm_enlist(sop, lsm_inode_create, sop->inode_create);
+	lsm_enlist(sop, lsm_inode_link, sop->inode_link);
+	lsm_enlist(sop, lsm_inode_unlink, sop->inode_unlink);
+	lsm_enlist(sop, lsm_inode_symlink, sop->inode_symlink);
+	lsm_enlist(sop, lsm_inode_mkdir, sop->inode_mkdir);
+	lsm_enlist(sop, lsm_inode_rmdir, sop->inode_rmdir);
+	lsm_enlist(sop, lsm_inode_mknod, sop->inode_mknod);
+	lsm_enlist(sop, lsm_inode_rename, sop->inode_rename);
+	lsm_enlist(sop, lsm_inode_readlink, sop->inode_readlink);
+	lsm_enlist(sop, lsm_inode_follow_link, sop->inode_follow_link);
+	lsm_enlist(sop, lsm_inode_permission, sop->inode_permission);
+	lsm_enlist(sop, lsm_inode_setattr, sop->inode_setattr);
+	lsm_enlist(sop, lsm_inode_getattr, sop->inode_getattr);
+	lsm_enlist(sop, lsm_inode_setxattr, sop->inode_setxattr);
+	lsm_enlist(sop, lsm_inode_post_setxattr, sop->inode_post_setxattr);
+	lsm_enlist(sop, lsm_inode_getxattr, sop->inode_getxattr);
+	lsm_enlist(sop, lsm_inode_listxattr, sop->inode_listxattr);
+	lsm_enlist(sop, lsm_inode_removexattr, sop->inode_removexattr);
+	lsm_enlist(sop, lsm_inode_need_killpriv, sop->inode_need_killpriv);
+	lsm_enlist(sop, lsm_inode_killpriv, sop->inode_killpriv);
+	lsm_enlist(sop, lsm_inode_getsecurity, sop->inode_getsecurity);
+	lsm_enlist(sop, lsm_inode_setsecurity, sop->inode_setsecurity);
+	lsm_enlist(sop, lsm_inode_listsecurity, sop->inode_listsecurity);
+	lsm_enlist(sop, lsm_inode_getsecid, sop->inode_getsecid);
+	lsm_enlist(sop, lsm_file_permission, sop->file_permission);
+	lsm_enlist(sop, lsm_file_alloc_security, sop->file_alloc_security);
+	lsm_enlist(sop, lsm_file_free_security, sop->file_free_security);
+	lsm_enlist(sop, lsm_file_ioctl, sop->file_ioctl);
+	lsm_enlist(sop, lsm_mmap_file, sop->mmap_file);
+	lsm_enlist(sop, lsm_mmap_addr, sop->mmap_addr);
+	lsm_enlist(sop, lsm_file_mprotect, sop->file_mprotect);
+	lsm_enlist(sop, lsm_file_lock, sop->file_lock);
+	lsm_enlist(sop, lsm_file_fcntl, sop->file_fcntl);
+	lsm_enlist(sop, lsm_file_set_fowner, sop->file_set_fowner);
+	lsm_enlist(sop, lsm_file_send_sigiotask, sop->file_send_sigiotask);
+	lsm_enlist(sop, lsm_file_receive, sop->file_receive);
+	lsm_enlist(sop, lsm_file_open, sop->file_open);
+	lsm_enlist(sop, lsm_task_create, sop->task_create);
+	lsm_enlist(sop, lsm_task_free, sop->task_free);
+	lsm_enlist(sop, lsm_cred_alloc_blank, sop->cred_alloc_blank);
+	lsm_enlist(sop, lsm_cred_free, sop->cred_free);
+	lsm_enlist(sop, lsm_cred_prepare, sop->cred_prepare);
+	lsm_enlist(sop, lsm_cred_transfer, sop->cred_transfer);
+	lsm_enlist(sop, lsm_kernel_act_as, sop->kernel_act_as);
+	lsm_enlist(sop, lsm_kernel_create_files_as,
+			sop->kernel_create_files_as);
+	lsm_enlist(sop, lsm_kernel_module_request, sop->kernel_module_request);
+	lsm_enlist(sop, lsm_kernel_module_from_file,
+			sop->kernel_module_from_file);
+	lsm_enlist(sop, lsm_task_fix_setuid, sop->task_fix_setuid);
+	lsm_enlist(sop, lsm_task_setpgid, sop->task_setpgid);
+	lsm_enlist(sop, lsm_task_getpgid, sop->task_getpgid);
+	lsm_enlist(sop, lsm_task_getsid, sop->task_getsid);
+	lsm_enlist(sop, lsm_task_getsecid, sop->task_getsecid);
+	lsm_enlist(sop, lsm_task_setnice, sop->task_setnice);
+	lsm_enlist(sop, lsm_task_setioprio, sop->task_setioprio);
+	lsm_enlist(sop, lsm_task_getioprio, sop->task_getioprio);
+	lsm_enlist(sop, lsm_task_setrlimit, sop->task_setrlimit);
+	lsm_enlist(sop, lsm_task_setscheduler, sop->task_setscheduler);
+	lsm_enlist(sop, lsm_task_getscheduler, sop->task_getscheduler);
+	lsm_enlist(sop, lsm_task_movememory, sop->task_movememory);
+	lsm_enlist(sop, lsm_task_kill, sop->task_kill);
+	lsm_enlist(sop, lsm_task_wait, sop->task_wait);
+	lsm_enlist(sop, lsm_task_prctl, sop->task_prctl);
+	lsm_enlist(sop, lsm_task_to_inode, sop->task_to_inode);
+	lsm_enlist(sop, lsm_ipc_permission, sop->ipc_permission);
+	lsm_enlist(sop, lsm_ipc_getsecid, sop->ipc_getsecid);
+	lsm_enlist(sop, lsm_msg_msg_alloc_security,
+			sop->msg_msg_alloc_security);
+	lsm_enlist(sop, lsm_msg_msg_free_security, sop->msg_msg_free_security);
+	lsm_enlist(sop, lsm_msg_queue_alloc_security,
+			sop->msg_queue_alloc_security);
+	lsm_enlist(sop, lsm_msg_queue_free_security,
+			sop->msg_queue_free_security);
+	lsm_enlist(sop, lsm_msg_queue_associate, sop->msg_queue_associate);
+	lsm_enlist(sop, lsm_msg_queue_msgctl, sop->msg_queue_msgctl);
+	lsm_enlist(sop, lsm_msg_queue_msgsnd, sop->msg_queue_msgsnd);
+	lsm_enlist(sop, lsm_msg_queue_msgrcv, sop->msg_queue_msgrcv);
+	lsm_enlist(sop, lsm_shm_alloc_security, sop->shm_alloc_security);
+	lsm_enlist(sop, lsm_shm_free_security, sop->shm_free_security);
+	lsm_enlist(sop, lsm_shm_associate, sop->shm_associate);
+	lsm_enlist(sop, lsm_shm_shmctl, sop->shm_shmctl);
+	lsm_enlist(sop, lsm_shm_shmat, sop->shm_shmat);
+	lsm_enlist(sop, lsm_sem_alloc_security, sop->sem_alloc_security);
+	lsm_enlist(sop, lsm_sem_free_security, sop->sem_free_security);
+	lsm_enlist(sop, lsm_sem_associate, sop->sem_associate);
+	lsm_enlist(sop, lsm_sem_semctl, sop->sem_semctl);
+	lsm_enlist(sop, lsm_sem_semop, sop->sem_semop);
+	lsm_enlist(sop, lsm_d_instantiate, sop->d_instantiate);
+	lsm_enlist(sop, lsm_getprocattr, sop->getprocattr);
+	lsm_enlist(sop, lsm_setprocattr, sop->setprocattr);
+	lsm_enlist(sop, lsm_netlink_send, sop->netlink_send);
+	lsm_enlist(sop, lsm_secid_to_secctx, sop->secid_to_secctx);
+	lsm_enlist(sop, lsm_secctx_to_secid, sop->secctx_to_secid);
+	lsm_enlist(sop, lsm_release_secctx, sop->release_secctx);
+	lsm_enlist(sop, lsm_inode_notifysecctx, sop->inode_notifysecctx);
+	lsm_enlist(sop, lsm_inode_setsecctx, sop->inode_setsecctx);
+	lsm_enlist(sop, lsm_inode_getsecctx, sop->inode_getsecctx);
+#ifdef CONFIG_SECURITY_NETWORK
+	lsm_enlist(sop, lsm_unix_stream_connect, sop->unix_stream_connect);
+	lsm_enlist(sop, lsm_unix_may_send, sop->unix_may_send);
+	lsm_enlist(sop, lsm_socket_create, sop->socket_create);
+	lsm_enlist(sop, lsm_socket_post_create, sop->socket_post_create);
+	lsm_enlist(sop, lsm_socket_bind, sop->socket_bind);
+	lsm_enlist(sop, lsm_socket_connect, sop->socket_connect);
+	lsm_enlist(sop, lsm_socket_listen, sop->socket_listen);
+	lsm_enlist(sop, lsm_socket_accept, sop->socket_accept);
+	lsm_enlist(sop, lsm_socket_sendmsg, sop->socket_sendmsg);
+	lsm_enlist(sop, lsm_socket_recvmsg, sop->socket_recvmsg);
+	lsm_enlist(sop, lsm_socket_getsockname, sop->socket_getsockname);
+	lsm_enlist(sop, lsm_socket_getpeername, sop->socket_getpeername);
+	lsm_enlist(sop, lsm_socket_getsockopt, sop->socket_getsockopt);
+	lsm_enlist(sop, lsm_socket_setsockopt, sop->socket_setsockopt);
+	lsm_enlist(sop, lsm_socket_shutdown, sop->socket_shutdown);
+	lsm_enlist(sop, lsm_socket_sock_rcv_skb, sop->socket_sock_rcv_skb);
+	lsm_enlist(sop, lsm_socket_getpeersec_stream,
+			sop->socket_getpeersec_stream);
+	lsm_enlist(sop, lsm_socket_getpeersec_dgram,
+			sop->socket_getpeersec_dgram);
+	lsm_enlist(sop, lsm_sk_alloc_security, sop->sk_alloc_security);
+	lsm_enlist(sop, lsm_sk_free_security, sop->sk_free_security);
+	lsm_enlist(sop, lsm_sk_clone_security, sop->sk_clone_security);
+	lsm_enlist(sop, lsm_req_classify_flow, sop->req_classify_flow);
+	lsm_enlist(sop, lsm_sock_graft, sop->sock_graft);
+	lsm_enlist(sop, lsm_inet_conn_request, sop->inet_conn_request);
+	lsm_enlist(sop, lsm_inet_csk_clone, sop->inet_csk_clone);
+	lsm_enlist(sop, lsm_inet_conn_established, sop->inet_conn_established);
+	lsm_enlist(sop, lsm_secmark_relabel_packet,
+			sop->secmark_relabel_packet);
+	lsm_enlist(sop, lsm_secmark_refcount_inc, sop->secmark_refcount_inc);
+	lsm_enlist(sop, lsm_secmark_refcount_dec, sop->secmark_refcount_dec);
+	lsm_enlist(sop, lsm_tun_dev_create, sop->tun_dev_create);
+	lsm_enlist(sop, lsm_tun_dev_attach, sop->tun_dev_attach);
+	lsm_enlist(sop, lsm_skb_owned_by, sop->skb_owned_by);
+#endif
+#ifdef CONFIG_SECURITY_NETWORK_XFRM
+	lsm_enlist(sop, lsm_xfrm_policy_alloc_security,
+			sop->xfrm_policy_alloc_security);
+	lsm_enlist(sop, lsm_xfrm_policy_clone_security,
+			sop->xfrm_policy_clone_security);
+	lsm_enlist(sop, lsm_xfrm_policy_free_security,
+			sop->xfrm_policy_free_security);
+	lsm_enlist(sop, lsm_xfrm_policy_delete_security,
+			sop->xfrm_policy_delete_security);
+	lsm_enlist(sop, lsm_xfrm_state_alloc_security,
+			sop->xfrm_state_alloc_security);
+	lsm_enlist(sop, lsm_xfrm_state_delete_security,
+			sop->xfrm_state_delete_security);
+	lsm_enlist(sop, lsm_xfrm_state_free_security,
+			sop->xfrm_state_free_security);
+	lsm_enlist(sop, lsm_xfrm_policy_lookup, sop->xfrm_policy_lookup);
+	lsm_enlist(sop, lsm_xfrm_state_pol_flow_match,
+			sop->xfrm_state_pol_flow_match);
+	lsm_enlist(sop, lsm_xfrm_decode_session, sop->xfrm_decode_session);
+#endif
+#ifdef CONFIG_KEYS
+	lsm_enlist(sop, lsm_key_alloc, sop->key_alloc);
+	lsm_enlist(sop, lsm_key_free, sop->key_free);
+	lsm_enlist(sop, lsm_key_permission, sop->key_permission);
+	lsm_enlist(sop, lsm_key_getsecurity, sop->key_getsecurity);
+#endif
+#ifdef CONFIG_AUDIT
+	lsm_enlist(sop, lsm_audit_rule_init, sop->audit_rule_init);
+	lsm_enlist(sop, lsm_audit_rule_known, sop->audit_rule_known);
+	lsm_enlist(sop, lsm_audit_rule_free, sop->audit_rule_free);
+	lsm_enlist(sop, lsm_audit_rule_match, sop->audit_rule_match);
+#endif
+
+	lsm_enlist(sop, lsm_name, sop->name);
+}
+
+/* Save user chosen LSM(s) */
+static int __init choose_lsm(char *str)
+{
+	char *cp;
+	char *ep;
+	int i;
+
+	if (lsm_order_set)
+		return 1;
+	if (!strcmp(str, "ALL"))
+		return 1;
+	lsm_order_set = 1;
+	pr_info("LSM order requested is \"%s\".\n", str);
+
+	strncpy(allowed_lsms, str, COMPOSER_NAMES_MAX);
+	cp = allowed_lsms;
+
+	for (i = 0; i < COMPOSER_MAX; i++) {
+		ep = strchr(cp, ',');
+		if (ep != NULL)
+			*ep = '\0';
+		if (strlen(cp) > SECURITY_NAME_MAX)
+			pr_warn("LSM \"%s\" is invalid and ignored.\n", cp);
+		else
+			strncpy(specified_lsms[i], cp, SECURITY_NAME_MAX);
+		if (ep == NULL)
+			break;
+		cp = ep + 1;
+	}
+
+	return 1;
 }
+__setup("security=", choose_lsm);
 
 static void __init do_security_initcalls(void)
 {
 	initcall_t *call;
+
 	call = __security_initcall_start;
 	while (call < __security_initcall_end) {
 		(*call) ();
@@ -65,93 +364,368 @@ static void __init do_security_initcalls(void)
  */
 int __init security_init(void)
 {
-	printk(KERN_INFO "Security Framework initialized\n");
+	enum lsm_hooks_index i;
+
+	for (i = 0; i < LSM_MAX_HOOKS; i++)
+		INIT_LIST_HEAD(&lsm_hooks[i]);
+
+	(void) choose_lsm(CONFIG_DEFAULT_SECURITY);
+	pr_info("Security Framework initialized\n");
 
-	security_fixup_ops(&default_security_ops);
-	security_ops = &default_security_ops;
 	do_security_initcalls();
 
 	return 0;
 }
 
-void reset_security_ops(void)
+/*
+ * Only SELinux calls security_module_disable.
+ */
+#ifdef CONFIG_SECURITY_SELINUX_DISABLE
+
+static void lsm_delist_ops(struct security_operations *sop)
 {
-	security_ops = &default_security_ops;
+	enum lsm_hooks_index i;
+
+	for (i = 0; i < LSM_MAX_HOOKS; i++)
+		if (sop->list[i].next && !list_empty(&sop->list[i]))
+			list_del_rcu(&sop->list[i]);
+	return;
 }
 
-/* Save user chosen LSM */
-static int __init choose_lsm(char *str)
+/**
+ * security_module_disable - Remove hooks for an LSM
+ *
+ * @ops: the security operations for the LSM
+ *
+ * Remove the hooks for the LSM from the lists of security operations.
+ * This is not sufficient to "unregister" an LSM. The LSM will still
+ * have a slot in the lsm_blob and as the hooks that implement freeing
+ * of LSM data are removed memory leakage is almost certain to occur
+ * if the module uses security blobs.
+ */
+void security_module_disable(struct security_operations *ops)
 {
-	strncpy(chosen_lsm, str, SECURITY_NAME_MAX);
-	return 1;
+	/*
+	 * This LSM is configured to own /proc/.../attr.
+	 */
+	if (lsm_present == ops)
+		lsm_present = NULL;
+
+	lsm_delist_ops(ops);
 }
-__setup("security=", choose_lsm);
+
+#endif /* CONFIG_SECURITY_SELINUX_DISABLE */
 
 /**
  * security_module_enable - Load given security module on boot ?
  * @ops: a pointer to the struct security_operations that is to be checked.
  *
+ * returns 0 on success, -EINVAL -ENOENT -EBUSY as appropriate
+ *
  * Each LSM must pass this method before registering its own operations
  * to avoid security registration races. This method may also be used
  * to check if your LSM is currently loaded during kernel initialization.
  *
- * Return true if:
- *	-The passed LSM is the one chosen by user at boot time,
- *	-or the passed LSM is configured as the default and the user did not
- *	 choose an alternate LSM at boot time.
- * Otherwise, return false.
  */
 int __init security_module_enable(struct security_operations *ops)
 {
-	return !strcmp(ops->name, chosen_lsm);
-}
+	struct security_operations *sop;
+	int i;
 
-/**
- * register_security - registers a security framework with the kernel
- * @ops: a pointer to the struct security_options that is to be registered
- *
- * This function allows a security module to register itself with the
- * kernel security subsystem.  Some rudimentary checking is done on the @ops
- * value passed to this function. You'll need to check first if your LSM
- * is allowed to register its @ops by calling security_module_enable(@ops).
- *
- * If there is already a security module registered with the kernel,
- * an error will be returned.  Otherwise %0 is returned on success.
- */
-int __init register_security(struct security_operations *ops)
-{
-	if (verify(ops)) {
-		printk(KERN_DEBUG "%s could not verify "
-		       "security_operations structure.\n", __func__);
+	/*
+	 * Set up the operation vector early, but only once.
+	 * This allows LSM specific file systems to check to see if they
+	 * should come on line.
+	 */
+	if (ops == NULL) {
+		pr_debug("%s could not verify security_operations.\n",
+				__func__);
 		return -EINVAL;
 	}
+	/*
+	 * Return success if the LSM is already registered
+	 */
+	for_each_hook(sop, name)
+		if (sop == ops)
+			return 0;
+
+	/*
+	 * This LSM has not yet been ordered.
+	 */
+	ops->order = -1;
+
+	if (lsm_count >= COMPOSER_MAX) {
+		pr_warn("Too many security modules. %s not loaded.\n",
+				ops->name);
+		return -EBUSY;
+	}
 
-	if (security_ops != &default_security_ops)
-		return -EAGAIN;
+	if (lsm_order_set) {
+		for (i = 0; specified_lsms[i][0] != '\0'; i++) {
+			if (strcmp(ops->name, specified_lsms[i]) == 0) {
+				ops->order = i;
+				break;
+			}
+		}
+		if (ops->order == -1) {
+			pr_notice("LSM %s declined by boot options.\n",
+					ops->name);
+			return -ENOENT;
+		}
+	}
+	/*
+	 * The order will already be set if the command line
+	 * includes "security=" or CONFIG_DEFAULT_SECURITY was set.
+	 * Do this before the enlisting.
+	 */
+	if (ops->order == -1)
+		ops->order = lsm_count;
+	lsm_count++;
 
-	security_ops = ops;
+	/*
+	 * Use the LSM specified by CONFIG_SECURITY_PRESENT for
+	 * [gs]etprocattr. If the LSM specified is PRESENT_FIRST
+	 * use the first LSM to register that has the hooks.
+	 * If the specified LSM lacks the hooks treat it as if
+	 * there is no LSM registered that supplied them.
+	 */
+	if (ops->getprocattr && ops->setprocattr &&
+	    (!strcmp(ops->name, present_lsm) ||
+	     (!lsm_present && !strcmp(PRESENT_FIRST, present_lsm)))) {
+		lsm_present = ops;
+		present_getprocattr = ops->getprocattr;
+		present_setprocattr = ops->setprocattr;
+		pr_info("Security Module %s is presented in /proc.\n",
+			ops->name);
+	}
+#ifdef CONFIG_NETLABEL_LSM
+	/*
+	 * Reserve the netlabel subsystem for the specified LSM.
+	 */
+	if (!strcmp(ops->name, CONFIG_NETLABEL_LSM)) {
+		i = netlbl_register_lsm(ops);
+		pr_info("Security Module %s %s Netlabel network labeling.\n",
+			ops->name, i ? "denied" : "uses");
+	}
+#endif
+#ifdef CONFIG_XFRM_LSM
+	/*
+	 * Reserve the XFRM subsystem for the specified LSM.
+	 */
+	if (!strcmp(ops->name, CONFIG_XFRM_LSM)) {
+		lsm_xfrm_ops = ops;
+		pr_info("Security Module %s uses XFRM network labeling.\n",
+			ops->name);
+	}
+#endif
+	/*
+	 * Reserve the networking secmark for the specified LSM.
+	 */
+	if (!strcmp(ops->name, CONFIG_SECMARK_LSM)) {
+		lsm_secmark_ops = ops;
+		pr_info("Security Module %s uses secmark network labeling.\n",
+			ops->name);
+	}
+	/*
+	 * Return success after registering the LSM.
+	 */
+	lsm_enlist_ops(ops);
 
 	return 0;
 }
 
 /* Security operations */
 
+/*
+ * Because so many of the cases are treated the same it
+ * cleans things up to use these macros instead of having
+ * duplicate text all over the place.
+ *
+ * call_void_hook:
+ *	This is a hook that does not return a value.
+ *
+ * call_int_hook:
+ *	This is a hook that returns a value. Return the last
+ *	non-zero return.
+ *
+ * call_int_must:
+ *	Returns 1 if any LSMs actually had hooks and one
+ *	or more got called. The return value goes into RC.
+ *
+ * call_int_cap_first:
+ *	Like cap_int_hook, but call the cap_hook first and
+ *	bail on fail.
+ *
+ * call_int_cap_last:
+ *	Like cap_int_cap_first, but call the cap_hook last.
+ *
+ * call_alloc_hook:
+ *	Allocate not only the LSM security blobs, but a blob
+ *	to hold pointers to all of them as well.
+ *
+ */
+#define call_void_hook(FUNC, ...)					\
+	do {								\
+		struct security_operations *sop;			\
+									\
+		list_for_each_entry(sop, &lsm_hooks[lsm_##FUNC],	\
+					list[lsm_##FUNC])		\
+			sop->FUNC(__VA_ARGS__);				\
+	} while (0)							\
+
+#define call_int_hook(FUNC, ...) ({					\
+	int rc = 0;							\
+	do {								\
+		struct security_operations *sop;			\
+		int thisrc;						\
+									\
+		list_for_each_entry(sop, &lsm_hooks[lsm_##FUNC],	\
+					list[lsm_##FUNC]) {		\
+			thisrc = sop->FUNC(__VA_ARGS__);		\
+			if (thisrc)					\
+				rc = thisrc;				\
+		}							\
+	} while (0);							\
+	rc;								\
+})
+
+#define call_int_must(RC, FUNC, ...) ({					\
+	int called = 0;							\
+	RC = 0;								\
+	do {								\
+		struct security_operations *sop;			\
+		int thisrc;						\
+									\
+		list_for_each_entry(sop, &lsm_hooks[lsm_##FUNC],	\
+					list[lsm_##FUNC]) {		\
+			thisrc = sop->FUNC(__VA_ARGS__);		\
+			if (thisrc)					\
+				RC = thisrc;				\
+			called = 1;					\
+		}							\
+	} while (0);							\
+	called;								\
+})
+
+#define call_int_cap_first(FUNC, ...) ({				\
+	int rc = 0;							\
+	do {								\
+		struct security_operations *sop;			\
+		int thisrc;						\
+									\
+		thisrc = cap_##FUNC(__VA_ARGS__);			\
+		if (thisrc) {						\
+			rc = thisrc;					\
+			break;						\
+		}							\
+									\
+		list_for_each_entry(sop, &lsm_hooks[lsm_##FUNC],	\
+					list[lsm_##FUNC]) {		\
+			thisrc = sop->FUNC(__VA_ARGS__);		\
+			if (thisrc)					\
+				rc = thisrc;				\
+		}							\
+	} while (0);							\
+	rc;								\
+})
+
+#define call_int_cap_last(FUNC, ...) ({					\
+	int rc = 0;							\
+	do {								\
+		struct security_operations *sop;			\
+		int thisrc;						\
+									\
+		list_for_each_entry(sop, &lsm_hooks[lsm_##FUNC],	\
+					list[lsm_##FUNC]) {		\
+			thisrc = sop->FUNC(__VA_ARGS__);		\
+			if (thisrc)					\
+				rc = thisrc;				\
+		}							\
+									\
+		if (!rc)						\
+			rc = cap_##FUNC(__VA_ARGS__);			\
+	} while (0);							\
+	rc;								\
+})
+
+
+#define call_alloc_hook(ALLOC, FREE, FIELD, GFP, ARG) ({		\
+	int rc = 0;							\
+	do {								\
+		struct security_operations *sop;			\
+		struct security_operations *note[COMPOSER_MAX];		\
+		struct lsm_blob tblob;					\
+		struct lsm_blob *bp = NULL;				\
+		int successes = 0;					\
+									\
+		memset(&tblob, 0, sizeof(tblob));			\
+		FIELD = &tblob;						\
+		for_each_hook(sop, ALLOC) {				\
+			rc = sop->ALLOC(ARG);				\
+			if (rc)						\
+				break;					\
+			note[successes++] = sop;			\
+		}							\
+		if (tblob.lsm_setcount != 0) {				\
+			if (rc == 0)					\
+				bp = kmemdup(&tblob, sizeof(tblob), GFP); \
+			if (bp == NULL) {				\
+				if (rc == 0)				\
+					rc = -ENOMEM;			\
+				while (successes > 0)			\
+					note[--successes]->FREE(ARG);	\
+			}						\
+		}							\
+		FIELD = bp;						\
+	} while (0);							\
+	rc;								\
+})
+
 int security_ptrace_access_check(struct task_struct *child, unsigned int mode)
 {
-	return security_ops->ptrace_access_check(child, mode);
+	return call_int_cap_first(ptrace_access_check, child, mode);
 }
 
 int security_ptrace_traceme(struct task_struct *parent)
 {
-	return security_ops->ptrace_traceme(parent);
+	return call_int_cap_first(ptrace_traceme, parent);
 }
 
+/*
+ * Odd duck hook handling.
+ * This hook returns the set of capabilities available to
+ * the "target" task. Apparmor restricts the capabilities
+ * based on profile and SELinux may deny the ability to
+ * look and see what they are. cap_capget never fails.
+ */
 int security_capget(struct task_struct *target,
 		     kernel_cap_t *effective,
 		     kernel_cap_t *inheritable,
 		     kernel_cap_t *permitted)
 {
-	return security_ops->capget(target, effective, inheritable, permitted);
+	struct security_operations *sop;
+	kernel_cap_t cap[3];
+	kernel_cap_t this[3];
+	int rc;
+	int i;
+
+	rc = cap_capget(target, &cap[0], &cap[1], &cap[2]);
+	if (rc != 0)
+		return rc;
+
+	for_each_hook(sop, capget) {
+		rc = sop->capget(target, &this[0], &this[1], &this[2]);
+		if (rc != 0)
+			return rc;
+		for (i = 0; i < 3; i++)
+			cap[i] = cap_intersect(cap[i], this[i]);
+	}
+
+	*effective = cap[0];
+	*inheritable = cap[1];
+	*permitted = cap[2];
+
+	return 0;
 }
 
 int security_capset(struct cred *new, const struct cred *old,
@@ -159,195 +733,225 @@ int security_capset(struct cred *new, const struct cred *old,
 		    const kernel_cap_t *inheritable,
 		    const kernel_cap_t *permitted)
 {
-	return security_ops->capset(new, old,
-				    effective, inheritable, permitted);
+	return call_int_cap_first(capset, new, old, effective,
+				  inheritable, permitted);
 }
 
 int security_capable(const struct cred *cred, struct user_namespace *ns,
 		     int cap)
 {
-	return security_ops->capable(cred, ns, cap, SECURITY_CAP_AUDIT);
+	return call_int_cap_first(capable, cred, ns, cap, SECURITY_CAP_AUDIT);
 }
 
 int security_capable_noaudit(const struct cred *cred, struct user_namespace *ns,
 			     int cap)
 {
-	return security_ops->capable(cred, ns, cap, SECURITY_CAP_NOAUDIT);
+	return call_int_cap_first(capable, cred, ns, cap, SECURITY_CAP_NOAUDIT);
 }
 
 int security_quotactl(int cmds, int type, int id, struct super_block *sb)
 {
-	return security_ops->quotactl(cmds, type, id, sb);
+	return call_int_hook(quotactl, cmds, type, id, sb);
 }
 
 int security_quota_on(struct dentry *dentry)
 {
-	return security_ops->quota_on(dentry);
+	return call_int_hook(quota_on, dentry);
 }
 
 int security_syslog(int type)
 {
-	return security_ops->syslog(type);
+	return call_int_hook(syslog, type);
 }
 
 int security_settime(const struct timespec *ts, const struct timezone *tz)
 {
-	return security_ops->settime(ts, tz);
+	return call_int_cap_first(settime, ts, tz);
 }
 
 int security_vm_enough_memory_mm(struct mm_struct *mm, long pages)
 {
-	return security_ops->vm_enough_memory(mm, pages);
+	return call_int_cap_first(vm_enough_memory, mm, pages);
 }
 
 int security_bprm_set_creds(struct linux_binprm *bprm)
 {
-	return security_ops->bprm_set_creds(bprm);
+	return call_int_cap_first(bprm_set_creds, bprm);
 }
 
 int security_bprm_check(struct linux_binprm *bprm)
 {
-	int ret;
+	int rc = call_int_hook(bprm_check_security, bprm);
+
+	if (rc)
+		return rc;
 
-	ret = security_ops->bprm_check_security(bprm);
-	if (ret)
-		return ret;
 	return ima_bprm_check(bprm);
 }
 
+
 void security_bprm_committing_creds(struct linux_binprm *bprm)
 {
-	security_ops->bprm_committing_creds(bprm);
+	call_void_hook(bprm_committing_creds, bprm);
 }
 
 void security_bprm_committed_creds(struct linux_binprm *bprm)
 {
-	security_ops->bprm_committed_creds(bprm);
+	call_void_hook(bprm_committed_creds, bprm);
 }
 
 int security_bprm_secureexec(struct linux_binprm *bprm)
 {
-	return security_ops->bprm_secureexec(bprm);
+	return call_int_cap_last(bprm_secureexec, bprm);
 }
 
 int security_sb_alloc(struct super_block *sb)
 {
-	return security_ops->sb_alloc_security(sb);
+	return call_alloc_hook(sb_alloc_security, sb_free_security,
+			sb->s_security, GFP_KERNEL, sb);
 }
 
 void security_sb_free(struct super_block *sb)
 {
-	security_ops->sb_free_security(sb);
+	call_void_hook(sb_free_security, sb);
+
+	kfree(sb->s_security);
+	sb->s_security = NULL;
 }
 
 int security_sb_copy_data(char *orig, char *copy)
 {
-	return security_ops->sb_copy_data(orig, copy);
+	return call_int_hook(sb_copy_data, orig, copy);
 }
 EXPORT_SYMBOL(security_sb_copy_data);
 
 int security_sb_remount(struct super_block *sb, void *data)
 {
-	return security_ops->sb_remount(sb, data);
+	return call_int_hook(sb_remount, sb, data);
 }
 
 int security_sb_kern_mount(struct super_block *sb, int flags, void *data)
 {
-	return security_ops->sb_kern_mount(sb, flags, data);
+	return call_int_hook(sb_kern_mount, sb, flags, data);
 }
 
 int security_sb_show_options(struct seq_file *m, struct super_block *sb)
 {
-	return security_ops->sb_show_options(m, sb);
+	return call_int_hook(sb_show_options, m, sb);
 }
 
 int security_sb_statfs(struct dentry *dentry)
 {
-	return security_ops->sb_statfs(dentry);
+	return call_int_hook(sb_statfs, dentry);
 }
 
 int security_sb_mount(const char *dev_name, struct path *path,
                        const char *type, unsigned long flags, void *data)
 {
-	return security_ops->sb_mount(dev_name, path, type, flags, data);
+	return call_int_hook(sb_mount, dev_name, path, type, flags, data);
 }
 
 int security_sb_umount(struct vfsmount *mnt, int flags)
 {
-	return security_ops->sb_umount(mnt, flags);
+	return call_int_hook(sb_umount, mnt, flags);
 }
 
 int security_sb_pivotroot(struct path *old_path, struct path *new_path)
 {
-	return security_ops->sb_pivotroot(old_path, new_path);
+	return call_int_hook(sb_pivotroot, old_path, new_path);
 }
 
 int security_sb_set_mnt_opts(struct super_block *sb,
 				struct security_mnt_opts *opts)
 {
-	return security_ops->sb_set_mnt_opts(sb, opts);
+	int rc;
+
+	if (call_int_must(rc, sb_set_mnt_opts, sb, opts))
+		return rc;
+
+	if (unlikely(opts->num_mnt_opts))
+		return -EOPNOTSUPP;
+	return 0;
 }
 EXPORT_SYMBOL(security_sb_set_mnt_opts);
 
 void security_sb_clone_mnt_opts(const struct super_block *oldsb,
 				struct super_block *newsb)
 {
-	security_ops->sb_clone_mnt_opts(oldsb, newsb);
+	call_void_hook(sb_clone_mnt_opts, oldsb, newsb);
 }
 EXPORT_SYMBOL(security_sb_clone_mnt_opts);
 
 int security_sb_parse_opts_str(char *options, struct security_mnt_opts *opts)
 {
-	return security_ops->sb_parse_opts_str(options, opts);
+	return call_int_hook(sb_parse_opts_str, options, opts);
 }
 EXPORT_SYMBOL(security_sb_parse_opts_str);
 
 int security_inode_alloc(struct inode *inode)
 {
-	inode->i_security = NULL;
-	return security_ops->inode_alloc_security(inode);
+	return call_alloc_hook(inode_alloc_security, inode_free_security,
+			inode->i_security, GFP_KERNEL, inode);
 }
 
 void security_inode_free(struct inode *inode)
 {
 	integrity_inode_free(inode);
-	security_ops->inode_free_security(inode);
+
+	call_void_hook(inode_free_security, inode);
+
+	kfree(inode->i_security);
+	inode->i_security = NULL;
 }
 
 int security_inode_init_security(struct inode *inode, struct inode *dir,
 				 const struct qstr *qstr,
 				 const initxattrs initxattrs, void *fs_data)
 {
+	struct security_operations *sop;
 	struct xattr new_xattrs[MAX_LSM_EVM_XATTR + 1];
-	struct xattr *lsm_xattr, *evm_xattr, *xattr;
-	int ret;
+	struct xattr *lsm_xattr = new_xattrs;
+	struct xattr *evm_xattr;
+	struct xattr *xattr;
+	int thisrc;
+	int rc = 0;
+	int supported = 0;
 
 	if (unlikely(IS_PRIVATE(inode)))
 		return 0;
 
-	memset(new_xattrs, 0, sizeof new_xattrs);
 	if (!initxattrs)
-		return security_ops->inode_init_security(inode, dir, qstr,
-							 NULL, NULL, NULL);
-	lsm_xattr = new_xattrs;
-	ret = security_ops->inode_init_security(inode, dir, qstr,
-						&lsm_xattr->name,
-						&lsm_xattr->value,
-						&lsm_xattr->value_len);
-	if (ret)
-		goto out;
-
-	evm_xattr = lsm_xattr + 1;
-	ret = evm_inode_init_security(inode, lsm_xattr, evm_xattr);
-	if (ret)
-		goto out;
-	ret = initxattrs(inode, new_xattrs, fs_data);
-out:
-	for (xattr = new_xattrs; xattr->name != NULL; xattr++) {
-		kfree(xattr->name);
-		kfree(xattr->value);
+		return call_int_hook(inode_init_security, inode, dir, qstr,
+				NULL, NULL, NULL);
+
+	memset(new_xattrs, 0, sizeof new_xattrs);
+
+	for_each_hook(sop, inode_init_security) {
+		thisrc = sop->inode_init_security(inode, dir, qstr,
+					&lsm_xattr->name, &lsm_xattr->value,
+					&lsm_xattr->value_len);
+		if (thisrc != 0) {
+			if (thisrc != -EOPNOTSUPP) {
+				supported = 1;
+				rc = thisrc;
+			}
+			continue;
+		}
+		supported = 1;
+		evm_xattr = lsm_xattr + 1;
+		thisrc = evm_inode_init_security(inode, lsm_xattr, evm_xattr);
+		if (thisrc == 0)
+			thisrc = initxattrs(inode, new_xattrs, fs_data);
+		if (thisrc != 0)
+			rc = thisrc;
+		for (xattr = new_xattrs; xattr->name != NULL; xattr++) {
+			kfree(xattr->name);
+			kfree(xattr->value);
+		}
 	}
-	return (ret == -EOPNOTSUPP) ? 0 : ret;
+	if (supported)
+		return rc;
+	return 0;
 }
 EXPORT_SYMBOL(security_inode_init_security);
 
@@ -357,8 +961,9 @@ int security_old_inode_init_security(struct inode *inode, struct inode *dir,
 {
 	if (unlikely(IS_PRIVATE(inode)))
 		return -EOPNOTSUPP;
-	return security_ops->inode_init_security(inode, dir, qstr, name, value,
-						 len);
+
+	return call_int_hook(inode_init_security, inode, dir, qstr, name,
+							value, len);
 }
 EXPORT_SYMBOL(security_old_inode_init_security);
 
@@ -368,7 +973,8 @@ int security_path_mknod(struct path *dir, struct dentry *dentry, umode_t mode,
 {
 	if (unlikely(IS_PRIVATE(dir->dentry->d_inode)))
 		return 0;
-	return security_ops->path_mknod(dir, dentry, mode, dev);
+
+	return call_int_hook(path_mknod, dir, dentry, mode, dev);
 }
 EXPORT_SYMBOL(security_path_mknod);
 
@@ -376,7 +982,8 @@ int security_path_mkdir(struct path *dir, struct dentry *dentry, umode_t mode)
 {
 	if (unlikely(IS_PRIVATE(dir->dentry->d_inode)))
 		return 0;
-	return security_ops->path_mkdir(dir, dentry, mode);
+
+	return call_int_hook(path_mkdir, dir, dentry, mode);
 }
 EXPORT_SYMBOL(security_path_mkdir);
 
@@ -384,14 +991,16 @@ int security_path_rmdir(struct path *dir, struct dentry *dentry)
 {
 	if (unlikely(IS_PRIVATE(dir->dentry->d_inode)))
 		return 0;
-	return security_ops->path_rmdir(dir, dentry);
+
+	return call_int_hook(path_rmdir, dir, dentry);
 }
 
 int security_path_unlink(struct path *dir, struct dentry *dentry)
 {
 	if (unlikely(IS_PRIVATE(dir->dentry->d_inode)))
 		return 0;
-	return security_ops->path_unlink(dir, dentry);
+
+	return call_int_hook(path_unlink, dir, dentry);
 }
 EXPORT_SYMBOL(security_path_unlink);
 
@@ -400,7 +1009,8 @@ int security_path_symlink(struct path *dir, struct dentry *dentry,
 {
 	if (unlikely(IS_PRIVATE(dir->dentry->d_inode)))
 		return 0;
-	return security_ops->path_symlink(dir, dentry, old_name);
+
+	return call_int_hook(path_symlink, dir, dentry, old_name);
 }
 
 int security_path_link(struct dentry *old_dentry, struct path *new_dir,
@@ -408,7 +1018,8 @@ int security_path_link(struct dentry *old_dentry, struct path *new_dir,
 {
 	if (unlikely(IS_PRIVATE(old_dentry->d_inode)))
 		return 0;
-	return security_ops->path_link(old_dentry, new_dir, new_dentry);
+
+	return call_int_hook(path_link, old_dentry, new_dir, new_dentry);
 }
 
 int security_path_rename(struct path *old_dir, struct dentry *old_dentry,
@@ -417,8 +1028,9 @@ int security_path_rename(struct path *old_dir, struct dentry *old_dentry,
 	if (unlikely(IS_PRIVATE(old_dentry->d_inode) ||
 		     (new_dentry->d_inode && IS_PRIVATE(new_dentry->d_inode))))
 		return 0;
-	return security_ops->path_rename(old_dir, old_dentry, new_dir,
-					 new_dentry);
+
+	return call_int_hook(path_rename, old_dir, old_dentry, new_dir,
+						new_dentry);
 }
 EXPORT_SYMBOL(security_path_rename);
 
@@ -426,26 +1038,29 @@ int security_path_truncate(struct path *path)
 {
 	if (unlikely(IS_PRIVATE(path->dentry->d_inode)))
 		return 0;
-	return security_ops->path_truncate(path);
+
+	return call_int_hook(path_truncate, path);
 }
 
 int security_path_chmod(struct path *path, umode_t mode)
 {
 	if (unlikely(IS_PRIVATE(path->dentry->d_inode)))
 		return 0;
-	return security_ops->path_chmod(path, mode);
+
+	return call_int_hook(path_chmod, path, mode);
 }
 
 int security_path_chown(struct path *path, kuid_t uid, kgid_t gid)
 {
 	if (unlikely(IS_PRIVATE(path->dentry->d_inode)))
 		return 0;
-	return security_ops->path_chown(path, uid, gid);
+
+	return call_int_hook(path_chown, path, uid, gid);
 }
 
 int security_path_chroot(struct path *path)
 {
-	return security_ops->path_chroot(path);
+	return call_int_hook(path_chroot, path);
 }
 #endif
 
@@ -453,7 +1068,8 @@ int security_inode_create(struct inode *dir, struct dentry *dentry, umode_t mode
 {
 	if (unlikely(IS_PRIVATE(dir)))
 		return 0;
-	return security_ops->inode_create(dir, dentry, mode);
+
+	return call_int_hook(inode_create, dir, dentry, mode);
 }
 EXPORT_SYMBOL_GPL(security_inode_create);
 
@@ -462,14 +1078,16 @@ int security_inode_link(struct dentry *old_dentry, struct inode *dir,
 {
 	if (unlikely(IS_PRIVATE(old_dentry->d_inode)))
 		return 0;
-	return security_ops->inode_link(old_dentry, dir, new_dentry);
+
+	return call_int_hook(inode_link, old_dentry, dir, new_dentry);
 }
 
 int security_inode_unlink(struct inode *dir, struct dentry *dentry)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_unlink(dir, dentry);
+
+	return call_int_hook(inode_unlink, dir, dentry);
 }
 
 int security_inode_symlink(struct inode *dir, struct dentry *dentry,
@@ -477,14 +1095,16 @@ int security_inode_symlink(struct inode *dir, struct dentry *dentry,
 {
 	if (unlikely(IS_PRIVATE(dir)))
 		return 0;
-	return security_ops->inode_symlink(dir, dentry, old_name);
+
+	return call_int_hook(inode_symlink, dir, dentry, old_name);
 }
 
 int security_inode_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	if (unlikely(IS_PRIVATE(dir)))
 		return 0;
-	return security_ops->inode_mkdir(dir, dentry, mode);
+
+	return call_int_hook(inode_mkdir, dir, dentry, mode);
 }
 EXPORT_SYMBOL_GPL(security_inode_mkdir);
 
@@ -492,14 +1112,16 @@ int security_inode_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_rmdir(dir, dentry);
+
+	return call_int_hook(inode_rmdir, dir, dentry);
 }
 
 int security_inode_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, dev_t dev)
 {
 	if (unlikely(IS_PRIVATE(dir)))
 		return 0;
-	return security_ops->inode_mknod(dir, dentry, mode, dev);
+
+	return call_int_hook(inode_mknod, dir, dentry, mode, dev);
 }
 
 int security_inode_rename(struct inode *old_dir, struct dentry *old_dentry,
@@ -508,40 +1130,45 @@ int security_inode_rename(struct inode *old_dir, struct dentry *old_dentry,
         if (unlikely(IS_PRIVATE(old_dentry->d_inode) ||
             (new_dentry->d_inode && IS_PRIVATE(new_dentry->d_inode))))
 		return 0;
-	return security_ops->inode_rename(old_dir, old_dentry,
-					   new_dir, new_dentry);
+
+	return call_int_hook(inode_rename, old_dir, old_dentry, new_dir,
+						new_dentry);
 }
 
 int security_inode_readlink(struct dentry *dentry)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_readlink(dentry);
+
+	return call_int_hook(inode_readlink, dentry);
 }
 
 int security_inode_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_follow_link(dentry, nd);
+
+	return call_int_hook(inode_follow_link, dentry, nd);
 }
 
 int security_inode_permission(struct inode *inode, int mask)
 {
 	if (unlikely(IS_PRIVATE(inode)))
 		return 0;
-	return security_ops->inode_permission(inode, mask);
+
+	return call_int_hook(inode_permission, inode, mask);
 }
 
 int security_inode_setattr(struct dentry *dentry, struct iattr *attr)
 {
-	int ret;
+	int rc;
 
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	ret = security_ops->inode_setattr(dentry, attr);
-	if (ret)
-		return ret;
+
+	rc = call_int_hook(inode_setattr, dentry, attr);
+	if (rc)
+		return rc;
 	return evm_inode_setattr(dentry, attr);
 }
 EXPORT_SYMBOL_GPL(security_inode_setattr);
@@ -550,22 +1177,25 @@ int security_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_getattr(mnt, dentry);
+
+	return call_int_hook(inode_getattr, mnt, dentry);
 }
 
 int security_inode_setxattr(struct dentry *dentry, const char *name,
 			    const void *value, size_t size, int flags)
 {
-	int ret;
+	int rc;
 
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	ret = security_ops->inode_setxattr(dentry, name, value, size, flags);
-	if (ret)
-		return ret;
-	ret = ima_inode_setxattr(dentry, name, value, size);
-	if (ret)
-		return ret;
+
+	rc = call_int_hook(inode_setxattr, dentry, name, value, size, flags);
+
+	if (rc)
+		return rc;
+	rc = ima_inode_setxattr(dentry, name, value, size);
+	if (rc)
+		return rc;
 	return evm_inode_setxattr(dentry, name, value, size);
 }
 
@@ -574,7 +1204,9 @@ void security_inode_post_setxattr(struct dentry *dentry, const char *name,
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return;
-	security_ops->inode_post_setxattr(dentry, name, value, size, flags);
+
+	call_void_hook(inode_post_setxattr, dentry, name, value, size, flags);
+
 	evm_inode_post_setxattr(dentry, name, value, size);
 }
 
@@ -582,93 +1214,154 @@ int security_inode_getxattr(struct dentry *dentry, const char *name)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_getxattr(dentry, name);
+
+	return call_int_hook(inode_getxattr, dentry, name);
 }
 
 int security_inode_listxattr(struct dentry *dentry)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_listxattr(dentry);
+
+	return call_int_hook(inode_listxattr, dentry);
 }
 
 int security_inode_removexattr(struct dentry *dentry, const char *name)
 {
-	int ret;
+	int rc;
 
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	ret = security_ops->inode_removexattr(dentry, name);
-	if (ret)
-		return ret;
-	ret = ima_inode_removexattr(dentry, name);
-	if (ret)
-		return ret;
+
+	if (!call_int_must(rc, inode_removexattr, dentry, name))
+		rc = cap_inode_removexattr(dentry, name);
+
+	if (rc)
+		return rc;
+
+	rc = ima_inode_removexattr(dentry, name);
+	if (rc)
+		return rc;
 	return evm_inode_removexattr(dentry, name);
 }
 
 int security_inode_need_killpriv(struct dentry *dentry)
 {
-	return security_ops->inode_need_killpriv(dentry);
+	return call_int_cap_first(inode_need_killpriv, dentry);
 }
 
 int security_inode_killpriv(struct dentry *dentry)
 {
-	return security_ops->inode_killpriv(dentry);
+	return call_int_cap_first(inode_killpriv, dentry);
 }
 
-int security_inode_getsecurity(const struct inode *inode, const char *name,
-				void **buffer, bool alloc,
-				struct security_operations **secops)
+int security_inode_getsecurity(const struct inode *inode, const char *name, void **buffer, bool alloc, struct security_operations **secops)
 {
+	struct security_operations *sop;
+	int rc;
+
 	if (unlikely(IS_PRIVATE(inode)))
 		return -EOPNOTSUPP;
-	return security_ops->inode_getsecurity(inode, name, buffer, alloc);
+
+	/*
+	 * Only one LSM will supply a given "name".
+	 * -EOPNOTSUPP is an indication that the LSM does not
+	 * provide a value for the provided name.
+	 */
+	for_each_hook(sop, inode_getsecurity) {
+		rc = sop->inode_getsecurity(inode, name, buffer, alloc);
+		if (rc != -EOPNOTSUPP) {
+			*secops = sop;
+			return rc;
+		}
+	}
+	return -EOPNOTSUPP;
 }
 
 int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags)
 {
+	struct security_operations *sop;
+	int rc;
+
 	if (unlikely(IS_PRIVATE(inode)))
 		return -EOPNOTSUPP;
-	return security_ops->inode_setsecurity(inode, name, value, size, flags);
+
+	/*
+	 * Only one LSM will set a given "name".
+	 * -EOPNOTSUPP is an indication that the LSM does not
+	 * set a value for the provided name.
+	 */
+	for_each_hook(sop, inode_setsecurity) {
+		rc = sop->inode_setsecurity(inode, name, value, size, flags);
+		if (rc != -EOPNOTSUPP)
+			return rc;
+	}
+	return -EOPNOTSUPP;
 }
 
 int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size)
 {
+	struct security_operations *sop;
+	int rc = 0;
+	int thisrc;
+
 	if (unlikely(IS_PRIVATE(inode)))
 		return 0;
-	return security_ops->inode_listsecurity(inode, buffer, buffer_size);
+
+	/*
+	 * inode_listsecurity hooks never return negative values.
+	 */
+	for_each_hook(sop, inode_listsecurity) {
+		thisrc = sop->inode_listsecurity(inode, buffer, buffer_size);
+		if (buffer != NULL)
+			buffer += thisrc;
+		buffer_size -= thisrc;
+		rc += thisrc;
+	}
+	return rc;
 }
 
 void security_inode_getsecid(const struct inode *inode, struct secids *secid)
 {
-	security_ops->inode_getsecid(inode, &secid->si_lsm[0]);
+	struct security_operations *sop;
+
+	memset(secid, 0, sizeof(*secid));
+
+	for_each_hook(sop, inode_getsecid) {
+		sop->inode_getsecid(inode, &secid->si_lsm[sop->order]);
+		secid->si_count++;
+	}
 }
 
 int security_file_permission(struct file *file, int mask)
 {
-	int ret;
+	int rc;
 
-	ret = security_ops->file_permission(file, mask);
-	if (ret)
-		return ret;
+	rc = call_int_hook(file_permission, file, mask);
+
+	if (rc)
+		return rc;
 
 	return fsnotify_perm(file, mask);
 }
 
 int security_file_alloc(struct file *file)
 {
-	return security_ops->file_alloc_security(file);
+	return call_alloc_hook(file_alloc_security, file_free_security,
+			file->f_security, GFP_KERNEL, file);
 }
 
 void security_file_free(struct file *file)
 {
-	security_ops->file_free_security(file);
+	call_void_hook(file_free_security, file);
+
+	kfree(file->f_security);
+	file->f_security = NULL;
 }
 
 int security_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	return security_ops->file_ioctl(file, cmd, arg);
+	return call_int_hook(file_ioctl, file, cmd, arg);
 }
 
 static inline unsigned long mmap_prot(struct file *file, unsigned long prot)
@@ -708,366 +1401,813 @@ static inline unsigned long mmap_prot(struct file *file, unsigned long prot)
 int security_mmap_file(struct file *file, unsigned long prot,
 			unsigned long flags)
 {
-	int ret;
-	ret = security_ops->mmap_file(file, prot,
-					mmap_prot(file, prot), flags);
-	if (ret)
-		return ret;
+	int rc;
+
+	rc = call_int_hook(mmap_file, file, prot, mmap_prot(file, prot),
+			   flags);
+
+	if (rc)
+		return rc;
 	return ima_file_mmap(file, prot);
 }
 
 int security_mmap_addr(unsigned long addr)
 {
-	return security_ops->mmap_addr(addr);
+	return call_int_cap_last(mmap_addr, addr);
 }
 
 int security_file_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
 			    unsigned long prot)
 {
-	return security_ops->file_mprotect(vma, reqprot, prot);
+	return call_int_hook(file_mprotect, vma, reqprot, prot);
 }
 
 int security_file_lock(struct file *file, unsigned int cmd)
 {
-	return security_ops->file_lock(file, cmd);
+	return call_int_hook(file_lock, file, cmd);
 }
 
 int security_file_fcntl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	return security_ops->file_fcntl(file, cmd, arg);
+	return call_int_hook(file_fcntl, file, cmd, arg);
 }
 
 int security_file_set_fowner(struct file *file)
 {
-	return security_ops->file_set_fowner(file);
+	return call_int_hook(file_set_fowner, file);
 }
 
 int security_file_send_sigiotask(struct task_struct *tsk,
 				  struct fown_struct *fown, int sig)
 {
-	return security_ops->file_send_sigiotask(tsk, fown, sig);
+	return call_int_hook(file_send_sigiotask, tsk, fown, sig);
 }
 
 int security_file_receive(struct file *file)
 {
-	return security_ops->file_receive(file);
+	return call_int_hook(file_receive, file);
 }
 
 int security_file_open(struct file *file, const struct cred *cred)
 {
-	int ret;
+	int rc;
 
-	ret = security_ops->file_open(file, cred);
-	if (ret)
-		return ret;
+	rc = call_int_hook(file_open, file, cred);
+
+	if (rc)
+		return rc;
 
 	return fsnotify_perm(file, MAY_OPEN);
 }
 
 int security_task_create(unsigned long clone_flags)
 {
-	return security_ops->task_create(clone_flags);
+	return call_int_hook(task_create, clone_flags);
 }
 
 void security_task_free(struct task_struct *task)
 {
-	security_ops->task_free(task);
+	call_void_hook(task_free, task);
 }
 
 int security_cred_alloc_blank(struct cred *cred, gfp_t gfp)
 {
-	return security_ops->cred_alloc_blank(cred, gfp);
+	struct security_operations *sop;
+	struct security_operations *note[COMPOSER_MAX];
+	struct lsm_blob tblob;
+	struct lsm_blob *bp = NULL;
+	int rc = 0;
+	int successes = 0;
+
+	memset(&tblob, 0, sizeof(tblob));
+	cred->security = &tblob;
+
+	for_each_hook(sop, cred_alloc_blank) {
+		rc = sop->cred_alloc_blank(cred, gfp);
+		if (rc)
+			break;
+		note[successes++] = sop;
+	}
+
+	if (tblob.lsm_setcount != 0) {
+		if (rc == 0)
+			bp = kmemdup(&tblob, sizeof(tblob), gfp);
+		if (bp == NULL) {
+			if (rc == 0)
+				rc = -ENOMEM;
+			while (successes > 0)
+				note[--successes]->cred_free(cred);
+		}
+	}
+	cred->security = bp;
+	return rc;
 }
 
 void security_cred_free(struct cred *cred)
 {
-	security_ops->cred_free(cred);
+	call_void_hook(cred_free, cred);
+
+	if (cred->security == NULL)
+		return;
+
+	kfree(cred->security);
+	cred->security = NULL;
 }
 
 int security_prepare_creds(struct cred *new, const struct cred *old, gfp_t gfp)
 {
-	return security_ops->cred_prepare(new, old, gfp);
+	struct security_operations *sop;
+	struct security_operations *note[COMPOSER_MAX];
+	struct lsm_blob tblob;
+	struct lsm_blob *bp = NULL;
+	int rc = 0;
+	int successes = 0;
+
+	/*
+	 * new->security will be NULL on entry.
+	 */
+	memset(&tblob, 0, sizeof(tblob));
+	new->security = &tblob;
+
+	for_each_hook(sop, cred_prepare) {
+		rc = sop->cred_prepare(new, old, gfp);
+		if (rc)
+			break;
+		note[successes++] = sop;
+	}
+
+	if (tblob.lsm_setcount != 0) {
+		if (rc == 0)
+			bp = kmemdup(&tblob, sizeof(tblob), gfp);
+		if (bp == NULL) {
+			if (rc == 0)
+				rc = -ENOMEM;
+			while (successes > 0)
+				note[--successes]->cred_free(new);
+		}
+	}
+	new->security = bp;
+	return rc;
 }
 
 void security_transfer_creds(struct cred *new, const struct cred *old)
 {
-	security_ops->cred_transfer(new, old);
+	call_void_hook(cred_transfer, new, old);
 }
 
 int security_kernel_act_as(struct cred *new, struct secids *secid)
 {
-	return security_ops->kernel_act_as(new, secid->si_lsm[0]);
+	struct security_operations *sop;
+	int thisrc;
+	int rc = 0;
+
+	for_each_hook(sop, kernel_act_as) {
+		thisrc = sop->kernel_act_as(new, secid->si_lsm[sop->order]);
+		if (thisrc)
+			rc = thisrc;
+	}
+	return rc;
 }
 
 int security_kernel_create_files_as(struct cred *new, struct inode *inode)
 {
-	return security_ops->kernel_create_files_as(new, inode);
+	return call_int_hook(kernel_create_files_as, new, inode);
 }
 
 int security_kernel_module_request(char *kmod_name)
 {
-	return security_ops->kernel_module_request(kmod_name);
+	return call_int_hook(kernel_module_request, kmod_name);
 }
 
 int security_kernel_module_from_file(struct file *file)
 {
-	int ret;
+	int rc;
 
-	ret = security_ops->kernel_module_from_file(file);
-	if (ret)
-		return ret;
+	rc = call_int_hook(kernel_module_from_file, file);
+	if (rc)
+		return rc;
 	return ima_module_check(file);
 }
 
 int security_task_fix_setuid(struct cred *new, const struct cred *old,
 			     int flags)
 {
-	return security_ops->task_fix_setuid(new, old, flags);
+	return call_int_cap_first(task_fix_setuid, new, old, flags);
 }
 
 int security_task_setpgid(struct task_struct *p, pid_t pgid)
 {
-	return security_ops->task_setpgid(p, pgid);
+	return call_int_hook(task_setpgid, p, pgid);
 }
 
 int security_task_getpgid(struct task_struct *p)
 {
-	return security_ops->task_getpgid(p);
+	return call_int_hook(task_getpgid, p);
 }
 
 int security_task_getsid(struct task_struct *p)
 {
-	return security_ops->task_getsid(p);
+	return call_int_hook(task_getsid, p);
 }
 
 void security_task_getsecid(struct task_struct *p, struct secids *secid)
 {
-	security_ops->task_getsecid(p, &secid->si_lsm[0]);
+	struct security_operations *sop;
+
+	memset(secid, 0, sizeof(*secid));
+
+	for_each_hook(sop, task_getsecid) {
+		sop->task_getsecid(p, &secid->si_lsm[sop->order]);
+		secid->si_count++;
+	}
 }
 EXPORT_SYMBOL(security_task_getsecid);
 
 int security_task_setnice(struct task_struct *p, int nice)
 {
-	return security_ops->task_setnice(p, nice);
+	return call_int_cap_first(task_setnice, p, nice);
 }
 
 int security_task_setioprio(struct task_struct *p, int ioprio)
 {
-	return security_ops->task_setioprio(p, ioprio);
+	return call_int_cap_first(task_setioprio, p, ioprio);
 }
 
 int security_task_getioprio(struct task_struct *p)
 {
-	return security_ops->task_getioprio(p);
+	return call_int_hook(task_getioprio, p);
 }
 
 int security_task_setrlimit(struct task_struct *p, unsigned int resource,
 		struct rlimit *new_rlim)
 {
-	return security_ops->task_setrlimit(p, resource, new_rlim);
+	return call_int_hook(task_setrlimit, p, resource, new_rlim);
 }
 
 int security_task_setscheduler(struct task_struct *p)
 {
-	return security_ops->task_setscheduler(p);
+	return call_int_cap_first(task_setscheduler, p);
 }
 
 int security_task_getscheduler(struct task_struct *p)
 {
-	return security_ops->task_getscheduler(p);
+	return call_int_hook(task_getscheduler, p);
 }
 
 int security_task_movememory(struct task_struct *p)
 {
-	return security_ops->task_movememory(p);
+	return call_int_hook(task_movememory, p);
 }
 
 int security_task_kill(struct task_struct *p, struct siginfo *info,
-			int sig, const struct cred *ocred)
+			int sig, const struct cred *cred)
 {
-	return security_ops->task_kill(p, info, sig, ocred);
+	return call_int_hook(task_kill, p, info, sig, cred);
 }
 
 int security_task_wait(struct task_struct *p)
 {
-	return security_ops->task_wait(p);
+	return call_int_hook(task_wait, p);
 }
 
 int security_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			 unsigned long arg4, unsigned long arg5)
 {
-	return security_ops->task_prctl(option, arg2, arg3, arg4, arg5);
+	struct security_operations *sop;
+	int rc;
+
+	rc = cap_task_prctl(option, arg2, arg3, arg4, arg5);
+	if (rc != -ENOSYS)
+		return rc;
+
+	for_each_hook(sop, task_prctl) {
+		rc = sop->task_prctl(option, arg2, arg3, arg4, arg5);
+		/*
+		 * -ENOSYS returned if the lsm doesn't handle that control.
+		 * If the LSM does handle the control return the result.
+		 * The assumption for the time being is that no two LSMs
+		 * will handle a control.
+		 */
+		if (rc != -ENOSYS)
+			return rc;
+	}
+	return -ENOSYS;
 }
 
 void security_task_to_inode(struct task_struct *p, struct inode *inode)
 {
-	security_ops->task_to_inode(p, inode);
+	call_void_hook(task_to_inode, p, inode);
 }
 
 int security_ipc_permission(struct kern_ipc_perm *ipcp, short flag)
 {
-	return security_ops->ipc_permission(ipcp, flag);
+	return call_int_hook(ipc_permission, ipcp, flag);
 }
 
 void security_ipc_getsecid(struct kern_ipc_perm *ipcp, struct secids *secid)
 {
-	security_ops->ipc_getsecid(ipcp, &secid->si_lsm[0]);
+	struct security_operations *sop;
+
+	memset(secid, 0, sizeof(*secid));
+
+	for_each_hook(sop, ipc_getsecid) {
+		sop->ipc_getsecid(ipcp, &secid->si_lsm[sop->order]);
+		secid->si_count++;
+	}
 }
 
 int security_msg_msg_alloc(struct msg_msg *msg)
 {
-	return security_ops->msg_msg_alloc_security(msg);
+	return call_alloc_hook(msg_msg_alloc_security, msg_msg_free_security,
+			msg->security, GFP_KERNEL, msg);
 }
 
 void security_msg_msg_free(struct msg_msg *msg)
 {
-	security_ops->msg_msg_free_security(msg);
+	call_void_hook(msg_msg_free_security, msg);
+
+	kfree(msg->security);
+	msg->security = NULL;
 }
 
 int security_msg_queue_alloc(struct msg_queue *msq)
 {
-	return security_ops->msg_queue_alloc_security(msq);
+	struct kern_ipc_perm *kp = &msq->q_perm;
+
+	return call_alloc_hook(msg_queue_alloc_security,
+			msg_queue_free_security, kp->security, GFP_KERNEL,
+			msq);
 }
 
 void security_msg_queue_free(struct msg_queue *msq)
 {
-	security_ops->msg_queue_free_security(msq);
+	call_void_hook(msg_queue_free_security, msq);
+
+	kfree(msq->q_perm.security);
+	msq->q_perm.security = NULL;
 }
 
 int security_msg_queue_associate(struct msg_queue *msq, int msqflg)
 {
-	return security_ops->msg_queue_associate(msq, msqflg);
+	return call_int_hook(msg_queue_associate, msq, msqflg);
 }
 
 int security_msg_queue_msgctl(struct msg_queue *msq, int cmd)
 {
-	return security_ops->msg_queue_msgctl(msq, cmd);
+	return call_int_hook(msg_queue_msgctl, msq, cmd);
 }
 
 int security_msg_queue_msgsnd(struct msg_queue *msq,
 			       struct msg_msg *msg, int msqflg)
 {
-	return security_ops->msg_queue_msgsnd(msq, msg, msqflg);
+	return call_int_hook(msg_queue_msgsnd, msq, msg, msqflg);
 }
 
 int security_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg,
 			       struct task_struct *target, long type, int mode)
 {
-	return security_ops->msg_queue_msgrcv(msq, msg, target, type, mode);
+	return call_int_hook(msg_queue_msgrcv, msq, msg, target, type, mode);
 }
 
 int security_shm_alloc(struct shmid_kernel *shp)
 {
-	return security_ops->shm_alloc_security(shp);
+	struct kern_ipc_perm *kp = &shp->shm_perm;
+
+	return call_alloc_hook(shm_alloc_security, shm_free_security,
+			kp->security, GFP_KERNEL, shp);
 }
 
 void security_shm_free(struct shmid_kernel *shp)
 {
-	security_ops->shm_free_security(shp);
+	call_void_hook(shm_free_security, shp);
+
+	kfree(shp->shm_perm.security);
+	shp->shm_perm.security = NULL;
 }
 
 int security_shm_associate(struct shmid_kernel *shp, int shmflg)
 {
-	return security_ops->shm_associate(shp, shmflg);
+	return call_int_hook(shm_associate, shp, shmflg);
 }
 
 int security_shm_shmctl(struct shmid_kernel *shp, int cmd)
 {
-	return security_ops->shm_shmctl(shp, cmd);
+	return call_int_hook(shm_shmctl, shp, cmd);
 }
 
 int security_shm_shmat(struct shmid_kernel *shp, char __user *shmaddr, int shmflg)
 {
-	return security_ops->shm_shmat(shp, shmaddr, shmflg);
+	return call_int_hook(shm_shmat, shp, shmaddr, shmflg);
 }
 
 int security_sem_alloc(struct sem_array *sma)
 {
-	return security_ops->sem_alloc_security(sma);
+	struct kern_ipc_perm *kp = &sma->sem_perm;
+
+	return call_alloc_hook(sem_alloc_security, sem_free_security,
+			kp->security, GFP_KERNEL, sma);
 }
 
 void security_sem_free(struct sem_array *sma)
 {
-	security_ops->sem_free_security(sma);
+	call_void_hook(sem_free_security, sma);
+
+	kfree(sma->sem_perm.security);
+	sma->sem_perm.security = NULL;
 }
 
 int security_sem_associate(struct sem_array *sma, int semflg)
 {
-	return security_ops->sem_associate(sma, semflg);
+	return call_int_hook(sem_associate, sma, semflg);
 }
 
 int security_sem_semctl(struct sem_array *sma, int cmd)
 {
-	return security_ops->sem_semctl(sma, cmd);
+	return call_int_hook(sem_semctl, sma, cmd);
 }
 
 int security_sem_semop(struct sem_array *sma, struct sembuf *sops,
 			unsigned nsops, int alter)
 {
-	return security_ops->sem_semop(sma, sops, nsops, alter);
+	return call_int_hook(sem_semop, sma, sops, nsops, alter);
 }
 
 void security_d_instantiate(struct dentry *dentry, struct inode *inode)
 {
 	if (unlikely(inode && IS_PRIVATE(inode)))
 		return;
-	security_ops->d_instantiate(dentry, inode);
+
+	call_void_hook(d_instantiate, dentry, inode);
 }
 EXPORT_SYMBOL(security_d_instantiate);
 
 int security_getprocattr(struct task_struct *p, char *name, char **value)
 {
-	return security_ops->getprocattr(p, name, value);
+	struct security_operations *sop;
+	struct secids secid;
+	char *lsm;
+	int lsmlen;
+	int rc;
+
+	/*
+	 * Names will either be in the legacy form containing
+	 * no periods (".") or they will be the LSM name followed
+	 * by the legacy suffix. "current" or "selinux.current"
+	 * The exception is "context", which gets all of the LSMs.
+	 *
+	 * Legacy names are handled by the presenting LSM.
+	 * Suffixed names are handled by the named LSM.
+	 */
+	if (strcmp(name, "context") == 0) {
+		security_task_getsecid(p, &secid);
+		rc = security_secid_to_secctx(&secid, &lsm, &lsmlen, &sop);
+		if (rc == 0) {
+			*value = kstrdup(lsm, GFP_KERNEL);
+			if (*value == NULL)
+				rc = -ENOMEM;
+			else
+				rc = strlen(*value);
+			security_release_secctx(lsm, lsmlen, sop);
+		}
+		return rc;
+	}
+
+	if (lsm_present && !strchr(name, '.'))
+		return present_getprocattr(p, name, value);
+
+	for_each_hook(sop, getprocattr) {
+		lsm = sop->name;
+		lsmlen = strlen(lsm);
+		if (!strncmp(name, lsm, lsmlen) && name[lsmlen] == '.')
+			return sop->getprocattr(p, name + lsmlen + 1, value);
+	}
+	return -EINVAL;
 }
 
-int security_setprocattr(struct task_struct *p, char *name, void *value, size_t size)
+int security_setprocattr(struct task_struct *p, char *name, void *value,
+				size_t size)
 {
-	return security_ops->setprocattr(p, name, value, size);
+	struct security_operations *sop;
+	char *lsm;
+	int lsmlen;
+
+	/*
+	 * Names will either be in the legacy form containing
+	 * no periods (".") or they will be the LSM name followed
+	 * by the legacy suffix.
+	 * "current" or "selinux.current"
+	 *
+	 * Legacy names are handled by the presenting LSM.
+	 * Suffixed names are handled by the named LSM.
+	 */
+	if (lsm_present && !strchr(name, '.'))
+		return present_setprocattr(p, name, value, size);
+
+	for_each_hook(sop, setprocattr) {
+		lsm = sop->name;
+		lsmlen = strlen(lsm);
+		if (!strncmp(name, lsm, lsmlen) && name[lsmlen] == '.')
+			return sop->setprocattr(p, name + lsmlen + 1, value,
+						size);
+	}
+	return -EINVAL;
 }
 
 int security_netlink_send(struct sock *sk, struct sk_buff *skb)
 {
-	return security_ops->netlink_send(sk, skb);
+	return call_int_cap_first(netlink_send, sk, skb);
 }
 
 int security_secid_to_secctx(struct secids *secid, char **secdata, u32 *seclen,
 				struct security_operations **secops)
 {
-	return security_ops->secid_to_secctx(secid->si_lsm[0], secdata, seclen);
+	struct security_operations *sop;
+	struct security_operations *gotthis = NULL;
+	char *data;
+	char *cp;
+	char *thisdata[COMPOSER_MAX];
+	u32 thislen[COMPOSER_MAX];
+	int thisrc[COMPOSER_MAX];
+	int gotmany = 0;
+	int ord;
+	u32 lenmany = 2;
+	int rc = 0;
+
+	for_each_hook(sop, secid_to_secctx) {
+		ord = sop->order;
+		if (secdata == NULL)
+			thisrc[ord] = sop->secid_to_secctx(secid->si_lsm[ord],
+						NULL, &thislen[ord]);
+		else
+			thisrc[ord] = sop->secid_to_secctx(secid->si_lsm[ord],
+						&thisdata[ord], &thislen[ord]);
+		if (thisrc[ord] == 0) {
+			if (gotthis == NULL)
+				gotthis = sop;
+			else
+				gotmany = 1;
+			lenmany += thislen[ord] + strlen(sop->name) + 3;
+		} else
+			rc = thisrc[ord];
+	}
+	if (gotthis == NULL) {
+		if (rc == 0)
+			return -EOPNOTSUPP;
+		return rc;
+	}
+	if (!gotmany) {
+		if (secdata != NULL)
+			*secdata = thisdata[gotthis->order];
+		*seclen = thislen[gotthis->order];
+		*secops = gotthis;
+		return 0;
+	}
+	if (secdata == NULL) {
+		*seclen = lenmany;
+		*secops = NULL;
+		return 0;
+	}
+
+	data = kzalloc(lenmany, GFP_KERNEL);
+	if (data != NULL) {
+		cp = data;
+		for_each_hook(sop, secid_to_secctx) {
+			ord = sop->order;
+			if (thisrc[ord] == 0)
+				cp += sprintf(cp, "%s='%s'", sop->name,
+							thisdata[ord]);
+		}
+		*secdata = data;
+		*seclen = lenmany;
+		*secops = NULL;
+		rc = 0;
+	} else
+		rc = -ENOMEM;
+
+	for_each_hook(sop, secid_to_secctx) {
+		ord = sop->order;
+		sop->release_secctx(thisdata[ord], thislen[ord]);
+	}
+
+	return rc;
 }
 EXPORT_SYMBOL(security_secid_to_secctx);
 
+static int lsm_specific_ctx(const char *secdata, char *lsm, char *ctx)
+{
+	char fmt[SECURITY_NAME_MAX + 10];
+	char *cp;
+	int rc;
+
+	sprintf(fmt, "%s='", lsm);
+	cp = strstr(secdata, fmt);
+	if (cp == NULL)
+		return 0;
+
+	sprintf(fmt, "%s='%%[^']'", lsm);
+	rc = sscanf(cp, fmt, ctx);
+
+	return rc;
+}
+
 int security_secctx_to_secid(const char *secdata, u32 seclen,
 				struct secids *secid)
 {
-	return security_ops->secctx_to_secid(secdata, seclen,
-						&secid->si_lsm[0]);
+	struct security_operations *sop;
+	char *cp;
+	char *thisdata;
+	int thisrc;
+	int gotten = 0;
+	int rc = 0;
+
+	memset(secid, 0, sizeof(*secid));
+
+	cp = strnstr(secdata, "='", seclen);
+	if (cp == NULL) {
+		for_each_hook(sop, secctx_to_secid) {
+			thisrc = sop->secctx_to_secid(secdata, seclen,
+						&secid->si_lsm[sop->order]);
+			if (thisrc)
+				rc = thisrc;
+			else
+				gotten = 1;
+		}
+	} else {
+		thisdata = kzalloc(seclen, GFP_KERNEL);
+		if (thisdata == NULL)
+			return -ENOMEM;
+
+		for_each_hook(sop, secctx_to_secid) {
+			thisrc = lsm_specific_ctx(secdata, sop->name, thisdata);
+			if (thisrc == 0)
+				continue;
+			thisrc = sop->secctx_to_secid(thisdata, seclen,
+						&secid->si_lsm[sop->order]);
+			if (thisrc)
+				rc = thisrc;
+			else
+				gotten = 1;
+		}
+		kfree(thisdata);
+	}
+	if (gotten)
+		return 0;
+	return rc;
 }
 EXPORT_SYMBOL(security_secctx_to_secid);
 
 void security_release_secctx(char *secdata, u32 seclen,
 				struct security_operations *sop)
 {
-	security_ops->release_secctx(secdata, seclen);
+	if (sop)
+		sop->release_secctx(secdata, seclen);
+	else
+		kfree(secdata);
 }
 EXPORT_SYMBOL(security_release_secctx);
 
 int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen)
 {
-	return security_ops->inode_notifysecctx(inode, ctx, ctxlen);
+	struct security_operations *sop;
+	char *thisdata = NULL;
+	int thisrc;
+	int rc = 0;
+
+	if (ctx != NULL)
+		thisdata = strnstr(ctx, "='", ctxlen);
+	if (thisdata == NULL) {
+		for_each_hook(sop, inode_notifysecctx) {
+			thisrc = sop->inode_notifysecctx(inode, ctx, ctxlen);
+			if (thisrc)
+				rc = thisrc;
+		}
+		return rc;
+	}
+
+	thisdata = kzalloc(ctxlen, GFP_KERNEL);
+	if (thisdata == NULL)
+		return -ENOMEM;
+
+	for_each_hook(sop, inode_setsecctx) {
+		thisrc = lsm_specific_ctx(ctx, sop->name, thisdata);
+		if (thisrc == 0)
+			continue;
+		thisrc = sop->inode_notifysecctx(inode, thisdata, ctxlen);
+		if (thisrc)
+			rc = thisrc;
+	}
+	kfree(thisdata);
+	return rc;
 }
 EXPORT_SYMBOL(security_inode_notifysecctx);
 
 int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen)
 {
-	return security_ops->inode_setsecctx(dentry, ctx, ctxlen);
+	struct security_operations *sop;
+	char *thisdata = NULL;
+	int thisrc;
+	int rc = 0;
+
+	if (ctx != NULL)
+		thisdata = strnstr(ctx, "='", ctxlen);
+	if (thisdata == NULL) {
+		for_each_hook(sop, inode_setsecctx) {
+			thisrc = sop->inode_setsecctx(dentry, ctx, ctxlen);
+			if (thisrc)
+				rc = thisrc;
+		}
+		return rc;
+	}
+
+	thisdata = kzalloc(ctxlen, GFP_KERNEL);
+	if (thisdata == NULL)
+		return -ENOMEM;
+
+	for_each_hook(sop, inode_setsecctx) {
+		thisrc = lsm_specific_ctx(ctx, sop->name, thisdata);
+		if (thisrc == 0)
+			continue;
+		thisrc = sop->inode_setsecctx(dentry, thisdata, ctxlen);
+		if (thisrc)
+			rc = thisrc;
+	}
+	kfree(thisdata);
+	return rc;
 }
 EXPORT_SYMBOL(security_inode_setsecctx);
 
 int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen,
 				struct security_operations **secops)
 {
-	return security_ops->inode_getsecctx(inode, ctx, ctxlen);
+	struct security_operations *sop;
+	struct security_operations *gotthis = NULL;
+	void *data;
+	char *cp;
+	void *thisdata[COMPOSER_MAX];
+	u32 thislen[COMPOSER_MAX];
+	int thisrc[COMPOSER_MAX];
+	int gotmany = 0;
+	int ord;
+	u32 len = 2;
+	int rc = 0;
+
+	for_each_hook(sop, inode_getsecctx) {
+		ord = sop->order;
+		if (ctx == NULL)
+			thisrc[ord] = sop->inode_getsecctx(inode,
+						NULL, &thislen[ord]);
+		else
+			thisrc[ord] = sop->inode_getsecctx(inode,
+						&thisdata[ord], &thislen[ord]);
+		if (thisrc[ord] == 0) {
+			if (gotthis == NULL)
+				gotthis = sop;
+			else
+				gotmany = 1;
+			len += thislen[ord] + strlen(sop->name) + 3;
+		} else
+			rc = thisrc[ord];
+	}
+	if (gotthis == NULL) {
+		if (rc == 0)
+			return -EOPNOTSUPP;
+		return rc;
+	}
+	if (!gotmany) {
+		if (ctx != NULL)
+			*ctx = thisdata[gotthis->order];
+		*ctxlen = thislen[gotthis->order];
+		*secops = gotthis;
+		return 0;
+	}
+	if (ctx == NULL) {
+		*ctxlen = len;
+		*secops = NULL;
+		return 0;
+	}
+
+	data = kzalloc(len, GFP_KERNEL);
+	if (data != NULL) {
+		cp = (char *)data;
+		for_each_hook(sop, inode_getsecctx) {
+			ord = sop->order;
+			if (thisrc[ord] == 0)
+				cp += sprintf(cp, "%s='%s'", sop->name,
+							(char *)thisdata[ord]);
+		}
+		*ctx = data;
+		*ctxlen = len;
+		*secops = NULL;
+		rc = 0;
+	} else
+		rc = -ENOMEM;
+
+	for_each_hook(sop, inode_getsecctx) {
+		ord = sop->order;
+		sop->release_secctx(thisdata[ord], thislen[ord]);
+	}
+
+	return rc;
 }
 EXPORT_SYMBOL(security_inode_getsecctx);
 
@@ -1075,246 +2215,352 @@ EXPORT_SYMBOL(security_inode_getsecctx);
 
 int security_unix_stream_connect(struct sock *sock, struct sock *other, struct sock *newsk)
 {
-	return security_ops->unix_stream_connect(sock, other, newsk);
+	return call_int_hook(unix_stream_connect, sock, other, newsk);
 }
 EXPORT_SYMBOL(security_unix_stream_connect);
 
 int security_unix_may_send(struct socket *sock,  struct socket *other)
 {
-	return security_ops->unix_may_send(sock, other);
+	return call_int_hook(unix_may_send, sock, other);
 }
 EXPORT_SYMBOL(security_unix_may_send);
 
 int security_socket_create(int family, int type, int protocol, int kern)
 {
-	return security_ops->socket_create(family, type, protocol, kern);
+	return call_int_hook(socket_create, family, type, protocol, kern);
 }
 
 int security_socket_post_create(struct socket *sock, int family,
 				int type, int protocol, int kern)
 {
-	return security_ops->socket_post_create(sock, family, type,
+	return call_int_hook(socket_post_create, sock, family, type,
 						protocol, kern);
 }
 
 int security_socket_bind(struct socket *sock, struct sockaddr *address, int addrlen)
 {
-	return security_ops->socket_bind(sock, address, addrlen);
+	return call_int_hook(socket_bind, sock, address, addrlen);
 }
 
 int security_socket_connect(struct socket *sock, struct sockaddr *address, int addrlen)
 {
-	return security_ops->socket_connect(sock, address, addrlen);
+	return call_int_hook(socket_connect, sock, address, addrlen);
 }
 
 int security_socket_listen(struct socket *sock, int backlog)
 {
-	return security_ops->socket_listen(sock, backlog);
+	return call_int_hook(socket_listen, sock, backlog);
 }
 
 int security_socket_accept(struct socket *sock, struct socket *newsock)
 {
-	return security_ops->socket_accept(sock, newsock);
+	return call_int_hook(socket_accept, sock, newsock);
 }
 
 int security_socket_sendmsg(struct socket *sock, struct msghdr *msg, int size)
 {
-	return security_ops->socket_sendmsg(sock, msg, size);
+	return call_int_hook(socket_sendmsg, sock, msg, size);
 }
 
 int security_socket_recvmsg(struct socket *sock, struct msghdr *msg,
 			    int size, int flags)
 {
-	return security_ops->socket_recvmsg(sock, msg, size, flags);
+	return call_int_hook(socket_recvmsg, sock, msg, size, flags);
 }
 
 int security_socket_getsockname(struct socket *sock)
 {
-	return security_ops->socket_getsockname(sock);
+	return call_int_hook(socket_getsockname, sock);
 }
 
 int security_socket_getpeername(struct socket *sock)
 {
-	return security_ops->socket_getpeername(sock);
+	return call_int_hook(socket_getpeername, sock);
 }
 
 int security_socket_getsockopt(struct socket *sock, int level, int optname)
 {
-	return security_ops->socket_getsockopt(sock, level, optname);
+	return call_int_hook(socket_getsockopt, sock, level, optname);
 }
 
 int security_socket_setsockopt(struct socket *sock, int level, int optname)
 {
-	return security_ops->socket_setsockopt(sock, level, optname);
+	return call_int_hook(socket_setsockopt, sock, level, optname);
 }
 
 int security_socket_shutdown(struct socket *sock, int how)
 {
-	return security_ops->socket_shutdown(sock, how);
+	return call_int_hook(socket_shutdown, sock, how);
 }
 
 int security_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 {
-	return security_ops->socket_sock_rcv_skb(sk, skb);
+	return call_int_hook(socket_sock_rcv_skb, sk, skb);
 }
 EXPORT_SYMBOL(security_sock_rcv_skb);
 
 int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
 				      int __user *optlen, unsigned len)
 {
-	return security_ops->socket_getpeersec_stream(sock, optval, optlen, len);
+	struct security_operations *sop;
+	char __user *thisval = optval;
+	int thisrc;
+	int called = 0;
+	int rc = -ENOPROTOOPT;
+
+	for_each_hook(sop, socket_getpeersec_stream) {
+		if (called) {
+			thisrc = copy_to_user(thisval++, " ", 1);
+			if (thisrc) {
+				rc = -EFAULT;
+				break;
+			}
+			len--;
+		}
+		thisrc = sop->socket_getpeersec_stream(sock, thisval,
+							optlen, len);
+		if (thisrc == -ENOPROTOOPT)
+			continue;
+		if (thisrc == 0) {
+			rc = 0;
+			thisval += *optlen;
+			len -= *optlen;
+		}
+		else if (rc != 0)
+			rc = thisrc;
+		called = 1;
+	}
+	if (called) {
+		if (rc == 0) {
+			len = strlen(optval) + 1;
+			if (put_user(len, optlen) != 0)
+				rc = -EFAULT;
+		}
+	}
+	return rc;
 }
 
 int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb,
 					struct secids *secid)
 {
-	return security_ops->socket_getpeersec_dgram(sock, skb,
-							&secid->si_lsm[0]);
+	struct security_operations *sop;
+	int thisrc;
+	int rc = -ENOPROTOOPT;
+
+	memset(secid, 0, sizeof(*secid));
+
+	for_each_hook(sop, socket_getpeersec_dgram) {
+		thisrc = sop->socket_getpeersec_dgram(sock, skb,
+					&secid->si_lsm[sop->order]);
+		if (thisrc == -ENOPROTOOPT)
+			continue;
+		if (!thisrc) {
+			rc = 0;
+			secid->si_count++;
+		}
+	}
+	return rc;
 }
 EXPORT_SYMBOL(security_socket_getpeersec_dgram);
 
 int security_sk_alloc(struct sock *sk, int family, gfp_t priority)
 {
-	return security_ops->sk_alloc_security(sk, family, priority);
+	struct security_operations *sop;
+	struct security_operations *note[COMPOSER_MAX];
+	struct lsm_blob tblob;
+	struct lsm_blob *bp = NULL;
+	int rc = 0;
+	int successes = 0;
+
+	memset(&tblob, 0, sizeof(tblob));
+	sk->sk_security = &tblob;
+
+	for_each_hook(sop, sk_alloc_security) {
+		rc = sop->sk_alloc_security(sk, family, priority);
+		if (rc)
+			break;
+		note[successes++] = sop;
+	}
+
+	if (tblob.lsm_setcount != 0) {
+		if (rc == 0)
+			bp = kmemdup(&tblob, sizeof(tblob), priority);
+		if (bp == NULL) {
+			if (rc == 0)
+				rc = -ENOMEM;
+			while (successes > 0)
+				note[--successes]->sk_free_security(sk);
+		}
+	}
+	sk->sk_security = bp;
+	return rc;
 }
 
 void security_sk_free(struct sock *sk)
 {
-	security_ops->sk_free_security(sk);
+	call_void_hook(sk_free_security, sk);
+
+	kfree(sk->sk_security);
+	sk->sk_security = NULL;
 }
 
 void security_sk_clone(const struct sock *sk, struct sock *newsk)
 {
-	security_ops->sk_clone_security(sk, newsk);
+	call_void_hook(sk_clone_security, sk, newsk);
 }
 EXPORT_SYMBOL(security_sk_clone);
 
 void security_sk_classify_flow(struct sock *sk, struct flowi *fl)
 {
-	security_ops->sk_getsecid(sk, &fl->flowi_secid);
+	call_void_hook(sk_getsecid, sk, &fl->flowi_secid);
 }
 EXPORT_SYMBOL(security_sk_classify_flow);
 
 void security_req_classify_flow(const struct request_sock *req, struct flowi *fl)
 {
-	security_ops->req_classify_flow(req, fl);
+	call_void_hook(req_classify_flow, req, fl);
 }
 EXPORT_SYMBOL(security_req_classify_flow);
 
 void security_sock_graft(struct sock *sk, struct socket *parent)
 {
-	security_ops->sock_graft(sk, parent);
+	call_void_hook(sock_graft, sk, parent);
 }
 EXPORT_SYMBOL(security_sock_graft);
 
 int security_inet_conn_request(struct sock *sk,
 			struct sk_buff *skb, struct request_sock *req)
 {
-	return security_ops->inet_conn_request(sk, skb, req);
+	return call_int_hook(inet_conn_request, sk, skb, req);
 }
 EXPORT_SYMBOL(security_inet_conn_request);
 
 void security_inet_csk_clone(struct sock *newsk,
 			const struct request_sock *req)
 {
-	security_ops->inet_csk_clone(newsk, req);
+	call_void_hook(inet_csk_clone, newsk, req);
 }
 
 void security_inet_conn_established(struct sock *sk,
 			struct sk_buff *skb)
 {
-	security_ops->inet_conn_established(sk, skb);
+	call_void_hook(inet_conn_established, sk, skb);
 }
 
 int security_secmark_relabel_packet(u32 secid)
 {
-	return security_ops->secmark_relabel_packet(secid);
+	if (lsm_secmark_ops)
+		return lsm_secmark_ops->secmark_relabel_packet(secid);
+	return 0;
 }
 EXPORT_SYMBOL(security_secmark_relabel_packet);
 
 void security_secmark_refcount_inc(void)
 {
-	security_ops->secmark_refcount_inc();
+	if (lsm_secmark_ops)
+		lsm_secmark_ops->secmark_refcount_inc();
 }
 EXPORT_SYMBOL(security_secmark_refcount_inc);
 
 void security_secmark_refcount_dec(void)
 {
-	security_ops->secmark_refcount_dec();
+	if (lsm_secmark_ops)
+		lsm_secmark_ops->secmark_refcount_dec();
 }
 EXPORT_SYMBOL(security_secmark_refcount_dec);
 
 int security_tun_dev_alloc_security(void **security)
 {
-	return security_ops->tun_dev_alloc_security(security);
+	return call_int_hook(tun_dev_alloc_security, security);
 }
 EXPORT_SYMBOL(security_tun_dev_alloc_security);
 
 void security_tun_dev_free_security(void *security)
 {
-	security_ops->tun_dev_free_security(security);
+	call_void_hook(tun_dev_free_security, security);
 }
 EXPORT_SYMBOL(security_tun_dev_free_security);
 
 int security_tun_dev_create(void)
 {
-	return security_ops->tun_dev_create();
+	return call_int_hook(tun_dev_create);
 }
 EXPORT_SYMBOL(security_tun_dev_create);
 
 int security_tun_dev_attach_queue(void *security)
 {
-	return security_ops->tun_dev_attach_queue(security);
+	return call_int_hook(tun_dev_attach_queue, security);
 }
 EXPORT_SYMBOL(security_tun_dev_attach_queue);
 
 int security_tun_dev_attach(struct sock *sk, void *security)
 {
-	return security_ops->tun_dev_attach(sk, security);
+	return call_int_hook(tun_dev_attach, sk, security);
 }
 EXPORT_SYMBOL(security_tun_dev_attach);
 
 int security_tun_dev_open(void *security)
 {
-	return security_ops->tun_dev_open(security);
+	return call_int_hook(tun_dev_open, security);
 }
 EXPORT_SYMBOL(security_tun_dev_open);
 
 void security_skb_owned_by(struct sk_buff *skb, struct sock *sk)
 {
-	security_ops->skb_owned_by(skb, sk);
+	call_void_hook(skb_owned_by, skb, sk);
 }
 
 #endif	/* CONFIG_SECURITY_NETWORK */
 
 #ifdef CONFIG_SECURITY_NETWORK_XFRM
+/*
+ * The xfrm hooks present special issues for composition
+ * as they don't use the usual scheme for passing in blobs.
+ * LSM registration checks ensure that only one xfrm using
+ * security module is loaded at a time.
+ * This shouldn't be much of an issue since SELinux is the
+ * only security module ever expected to use xfrm.
+ */
+#define call_xfrm_int_hook(FUNC, ...) ({		\
+	int rc = 0;					\
+	do {						\
+		if (!lsm_xfrm_ops)			\
+			break;				\
+		if (!lsm_xfrm_ops->FUNC)		\
+			break;				\
+		rc = lsm_xfrm_ops->FUNC(__VA_ARGS__);	\
+	} while (0);					\
+	rc;						\
+})
 
 int security_xfrm_policy_alloc(struct xfrm_sec_ctx **ctxp, struct xfrm_user_sec_ctx *sec_ctx)
 {
-	return security_ops->xfrm_policy_alloc_security(ctxp, sec_ctx);
+	return call_xfrm_int_hook(xfrm_policy_alloc_security, ctxp, sec_ctx);
 }
 EXPORT_SYMBOL(security_xfrm_policy_alloc);
 
 int security_xfrm_policy_clone(struct xfrm_sec_ctx *old_ctx,
 			      struct xfrm_sec_ctx **new_ctxp)
 {
-	return security_ops->xfrm_policy_clone_security(old_ctx, new_ctxp);
+	return call_xfrm_int_hook(xfrm_policy_clone_security, old_ctx,
+					new_ctxp);
 }
 
 void security_xfrm_policy_free(struct xfrm_sec_ctx *ctx)
 {
-	security_ops->xfrm_policy_free_security(ctx);
+	if (lsm_xfrm_ops && lsm_xfrm_ops->xfrm_policy_free_security)
+		lsm_xfrm_ops->xfrm_policy_free_security(ctx);
 }
 EXPORT_SYMBOL(security_xfrm_policy_free);
 
 int security_xfrm_policy_delete(struct xfrm_sec_ctx *ctx)
 {
-	return security_ops->xfrm_policy_delete_security(ctx);
+	return call_xfrm_int_hook(xfrm_policy_delete_security, ctx);
 }
 
 int security_xfrm_state_alloc(struct xfrm_state *x, struct xfrm_user_sec_ctx *sec_ctx)
 {
-	return security_ops->xfrm_state_alloc_security(x, sec_ctx, 0);
+	return call_xfrm_int_hook(xfrm_state_alloc_security, x, sec_ctx, 0);
 }
 EXPORT_SYMBOL(security_xfrm_state_alloc);
 
@@ -1327,42 +2573,46 @@ int security_xfrm_state_alloc_acquire(struct xfrm_state *x,
 	 * We want the context to be taken from secid which is usually
 	 * from the sock.
 	 */
-	return security_ops->xfrm_state_alloc_security(x, NULL, secid);
+	return call_xfrm_int_hook(xfrm_state_alloc_security, x, NULL, secid);
 }
 
 int security_xfrm_state_delete(struct xfrm_state *x)
 {
-	return security_ops->xfrm_state_delete_security(x);
+	return call_xfrm_int_hook(xfrm_state_delete_security, x);
 }
 EXPORT_SYMBOL(security_xfrm_state_delete);
 
 void security_xfrm_state_free(struct xfrm_state *x)
 {
-	security_ops->xfrm_state_free_security(x);
+	if (lsm_xfrm_ops && lsm_xfrm_ops->xfrm_state_free_security)
+		lsm_xfrm_ops->xfrm_state_free_security(x);
 }
 
 int security_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir)
 {
-	return security_ops->xfrm_policy_lookup(ctx, fl_secid, dir);
+	return call_xfrm_int_hook(xfrm_policy_lookup, ctx, fl_secid, dir);
 }
 
 int security_xfrm_state_pol_flow_match(struct xfrm_state *x,
 				       struct xfrm_policy *xp,
 				       const struct flowi *fl)
 {
-	return security_ops->xfrm_state_pol_flow_match(x, xp, fl);
+	if (lsm_xfrm_ops && lsm_xfrm_ops->xfrm_state_pol_flow_match)
+		return lsm_xfrm_ops->xfrm_state_pol_flow_match(x, xp, fl);
+
+	return 1;
 }
 
 int security_xfrm_decode_session(struct sk_buff *skb, u32 *secid)
 {
-	return security_ops->xfrm_decode_session(skb, secid, 1);
+	return call_xfrm_int_hook(xfrm_decode_session, skb, secid, 1);
 }
 
 void security_skb_classify_flow(struct sk_buff *skb, struct flowi *fl)
 {
-	int rc = security_ops->xfrm_decode_session(skb, &fl->flowi_secid, 0);
+	int rc;
 
-	BUG_ON(rc);
+	rc = call_xfrm_int_hook(xfrm_decode_session, skb, &fl->flowi_secid, 0);
 }
 EXPORT_SYMBOL(security_skb_classify_flow);
 
@@ -1373,23 +2623,60 @@ EXPORT_SYMBOL(security_skb_classify_flow);
 int security_key_alloc(struct key *key, const struct cred *cred,
 		       unsigned long flags)
 {
-	return security_ops->key_alloc(key, cred, flags);
+	struct security_operations *sop;
+	struct security_operations *note[COMPOSER_MAX];
+	struct lsm_blob tblob;
+	struct lsm_blob *bp = NULL;
+	int rc = 0;
+	int successes = 0;
+
+	memset(&tblob, 0, sizeof(tblob));
+	key->security = &tblob;
+
+	for_each_hook(sop, key_alloc) {
+		rc = sop->key_alloc(key, cred, flags);
+		if (rc)
+			break;
+		note[successes++] = sop;
+	}
+
+	if (tblob.lsm_setcount != 0) {
+		if (rc == 0)
+			bp = kmemdup(&tblob, sizeof(tblob), GFP_KERNEL);
+		if (bp == NULL) {
+			if (rc == 0)
+				rc = -ENOMEM;
+			while (successes > 0)
+				note[--successes]->key_free(key);
+		}
+	}
+
+	key->security = bp;
+	return rc;
 }
 
 void security_key_free(struct key *key)
 {
-	security_ops->key_free(key);
+	call_void_hook(key_free, key);
+
+	kfree(key->security);
+	key->security = NULL;
 }
 
 int security_key_permission(key_ref_t key_ref,
 			    const struct cred *cred, key_perm_t perm)
 {
-	return security_ops->key_permission(key_ref, cred, perm);
+	return call_int_hook(key_permission, key_ref, cred, perm);
 }
 
 int security_key_getsecurity(struct key *key, char **_buffer)
 {
-	return security_ops->key_getsecurity(key, _buffer);
+	int rc;
+
+	if (call_int_must(rc, key_getsecurity, key, _buffer))
+		return rc;
+	*_buffer = NULL;
+	return 0;
 }
 
 #endif	/* CONFIG_KEYS */
@@ -1398,24 +2685,86 @@ int security_key_getsecurity(struct key *key, char **_buffer)
 
 int security_audit_rule_init(u32 field, u32 op, char *rulestr, void **lsmrule)
 {
-	return security_ops->audit_rule_init(field, op, rulestr, lsmrule);
+	struct security_operations *sop;
+	struct lsm_blob tblob;
+	struct lsm_blob *bp = NULL;
+	int thisrc;
+	int rc = 0;
+
+	memset(&tblob, 0, sizeof(tblob));
+
+	for_each_hook(sop, audit_rule_init) {
+		thisrc = sop->audit_rule_init(field, op, rulestr,
+						&tblob.lsm_blobs[sop->order]);
+		if (thisrc == 0)
+			tblob.lsm_setcount++;
+		else if (thisrc == -EINVAL) {
+			tblob.lsm_setcount++;
+			pr_warn("audit rule \"%s\" is invalid for %s.\n",
+				rulestr, sop->name);
+		} else
+			rc = thisrc;
+	}
+
+	if (tblob.lsm_setcount != 0) {
+		bp = kmemdup(&tblob, sizeof(tblob), GFP_KERNEL);
+		if (bp == NULL) {
+			rc = -ENOMEM;
+			for_each_hook(sop, audit_rule_free)
+				sop->audit_rule_free(
+					tblob.lsm_blobs[sop->order]);
+		}
+	}
+
+	*lsmrule = bp;
+	return rc;
 }
 
 int security_audit_rule_known(struct audit_krule *krule)
 {
-	return security_ops->audit_rule_known(krule);
+	struct security_operations *sop;
+
+	for_each_hook(sop, audit_rule_free)
+		if (sop->audit_rule_known(krule))
+			return 1;
+	return 0;
 }
 
 void security_audit_rule_free(void *lsmrule)
 {
-	security_ops->audit_rule_free(lsmrule);
+	struct security_operations *sop;
+	struct lsm_blob *bp = lsmrule;
+
+	if (bp == NULL)
+		return;
+
+	for_each_hook(sop, audit_rule_free)
+		sop->audit_rule_free(bp->lsm_blobs[sop->order]);
+
+	kfree(bp);
 }
 
-int security_audit_rule_match(struct secids *secid, u32 field, u32 op, void *lsmrule,
-			      struct audit_context *actx)
+int security_audit_rule_match(struct secids *secid, u32 field, u32 op,
+				void *lsmrule, struct audit_context *actx)
 {
-	return security_ops->audit_rule_match(secid->si_lsm[0], field, op,
-						lsmrule, actx);
+	struct security_operations *sop;
+	struct lsm_blob *bp = lsmrule;
+	int order;
+	int rc;
+
+	if (lsmrule == NULL)
+		return 0;
+
+	for_each_hook(sop, audit_rule_match) {
+		order = sop->order;
+		if (bp->lsm_blobs[order] != NULL) {
+			rc = sop->audit_rule_match(secid->si_lsm[order], field,
+						op, bp->lsm_blobs[order], actx);
+			if (rc)
+				return rc;
+		}
+	}
+	return 0;
 }
 
 #endif /* CONFIG_AUDIT */
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 7104c6b..434adb0 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1815,12 +1815,6 @@ static inline u32 open_file_to_av(struct file *file)
 static int selinux_ptrace_access_check(struct task_struct *child,
 				     unsigned int mode)
 {
-	int rc;
-
-	rc = cap_ptrace_access_check(child, mode);
-	if (rc)
-		return rc;
-
 	if (mode & PTRACE_MODE_READ) {
 		u32 sid = current_sid();
 		u32 csid = task_sid(child);
@@ -1832,12 +1826,6 @@ static int selinux_ptrace_access_check(struct task_struct *child,
 
 static int selinux_ptrace_traceme(struct task_struct *parent)
 {
-	int rc;
-
-	rc = cap_ptrace_traceme(parent);
-	if (rc)
-		return rc;
-
 	return task_has_perm(parent, current, PROCESS__PTRACE);
 }
 
@@ -1858,13 +1846,6 @@ static int selinux_capset(struct cred *new, const struct cred *old,
 			  const kernel_cap_t *inheritable,
 			  const kernel_cap_t *permitted)
 {
-	int error;
-
-	error = cap_capset(new, old, effective, inheritable, permitted);
-
-	if (error)
-		return error;
-
 	return cred_has_perm(old, new, PROCESS__SETCAP);
 }
 
@@ -1881,12 +1862,6 @@ static int selinux_capset(struct cred *new, const struct cred *old,
 static int selinux_capable(const struct cred *cred, struct user_namespace *ns,
 			   int cap, int audit)
 {
-	int rc;
-
-	rc = cap_capable(cred, ns, cap, audit);
-	if (rc)
-		return rc;
-
 	return cred_has_capability(cred, cap, audit);
 }
 
@@ -1983,10 +1958,6 @@ static int selinux_bprm_set_creds(struct linux_binprm *bprm)
 	struct inode *inode = file_inode(bprm->file);
 	int rc;
 
-	rc = cap_bprm_set_creds(bprm);
-	if (rc)
-		return rc;
-
 	/* SELinux context only depends on initial program or script and not
 	 * the script interpreter */
 	if (bprm->cred_prepared)
@@ -2110,7 +2081,7 @@ static int selinux_bprm_secureexec(struct linux_binprm *bprm)
 					PROCESS__NOATSECURE, NULL);
 	}
 
-	return (atsecure || cap_bprm_secureexec(bprm));
+	return atsecure;
 }
 
 static int match_file(const void *p, struct file *file, unsigned fd)
@@ -3414,23 +3385,11 @@ static void selinux_task_getsecid(struct task_struct *p, u32 *secid)
 
 static int selinux_task_setnice(struct task_struct *p, int nice)
 {
-	int rc;
-
-	rc = cap_task_setnice(p, nice);
-	if (rc)
-		return rc;
-
 	return current_has_perm(p, PROCESS__SETSCHED);
 }
 
 static int selinux_task_setioprio(struct task_struct *p, int ioprio)
 {
-	int rc;
-
-	rc = cap_task_setioprio(p, ioprio);
-	if (rc)
-		return rc;
-
 	return current_has_perm(p, PROCESS__SETSCHED);
 }
 
@@ -3456,12 +3415,6 @@ static int selinux_task_setrlimit(struct task_struct *p, unsigned int resource,
 
 static int selinux_task_setscheduler(struct task_struct *p)
 {
-	int rc;
-
-	rc = cap_task_setscheduler(p);
-	if (rc)
-		return rc;
-
 	return current_has_perm(p, PROCESS__SETSCHED);
 }
 
@@ -4806,12 +4759,6 @@ static unsigned int selinux_ipv6_postroute(unsigned int hooknum,
 
 static int selinux_netlink_send(struct sock *sk, struct sk_buff *skb)
 {
-	int err;
-
-	err = cap_netlink_send(sk, skb);
-	if (err)
-		return err;
-
 	return selinux_nlmsg_perm(sk, skb);
 }
 
@@ -5748,14 +5695,13 @@ struct security_operations selinux_ops = {
 
 static __init int selinux_init(void)
 {
-
-	if (!security_module_enable(&selinux_ops)) {
-		selinux_enabled = 0;
+	if (!selinux_enabled) {
+		pr_info("SELinux:  Disabled at boot.\n");
 		return 0;
 	}
 
-	if (!selinux_enabled) {
-		printk(KERN_INFO "SELinux:  Disabled at boot.\n");
+	if (security_module_enable(&selinux_ops)) {
+		selinux_enabled = 0;
 		return 0;
 	}
 
@@ -5771,9 +5717,6 @@ static __init int selinux_init(void)
 				    0, SLAB_PANIC, NULL);
 	avc_init();
 
-	if (register_security(&selinux_ops))
-		panic("SELinux: Unable to register with kernel.\n");
-
 	if (selinux_enforcing)
 		printk(KERN_DEBUG "SELinux:  Starting in enforcing mode\n");
 	else
@@ -5907,13 +5850,13 @@ int selinux_disable(void)
 		return -EINVAL;
 	}
 
+	security_module_disable(&selinux_ops);
+
 	printk(KERN_INFO "SELinux:  Disabled at runtime.\n");
 
 	selinux_disabled = 1;
 	selinux_enabled = 0;
 
-	reset_security_ops();
-
 	/* Try to destroy the avc node cache */
 	avc_disable();
 
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 7473498..2f7e736 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -171,14 +171,9 @@ static int smk_copy_rules(struct list_head *nhead, struct list_head *ohead,
  */
 static int smack_ptrace_access_check(struct task_struct *ctp, unsigned int mode)
 {
-	int rc;
 	struct smk_audit_info ad;
 	char *tsp;
 
-	rc = cap_ptrace_access_check(ctp, mode);
-	if (rc != 0)
-		return rc;
-
 	tsp = smk_of_task(task_security(ctp));
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
 	smk_ad_setfield_u_tsk(&ad, ctp);
@@ -196,14 +191,9 @@ static int smack_ptrace_access_check(struct task_struct *ctp, unsigned int mode)
  */
 static int smack_ptrace_traceme(struct task_struct *ptp)
 {
-	int rc;
 	struct smk_audit_info ad;
 	char *tsp;
 
-	rc = cap_ptrace_traceme(ptp);
-	if (rc != 0)
-		return rc;
-
 	tsp = smk_of_task(task_security(ptp));
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
 	smk_ad_setfield_u_tsk(&ad, ptp);
@@ -469,11 +459,6 @@ static int smack_bprm_set_creds(struct linux_binprm *bprm)
 	struct inode *inode = file_inode(bprm->file);
 	struct task_smack *bsp = lsm_get_cred(bprm->cred, &smack_ops);
 	struct inode_smack *isp;
-	int rc;
-
-	rc = cap_bprm_set_creds(bprm);
-	if (rc != 0)
-		return rc;
 
 	if (bprm->cred_prepared)
 		return 0;
@@ -514,12 +499,8 @@ static void smack_bprm_committing_creds(struct linux_binprm *bprm)
 static int smack_bprm_secureexec(struct linux_binprm *bprm)
 {
 	struct task_smack *tsp = lsm_get_cred(current_cred(), &smack_ops);
-	int ret = cap_bprm_secureexec(bprm);
 
-	if (!ret && (tsp->smk_task != tsp->smk_forked))
-		ret = 1;
-
-	return ret;
+	return (tsp->smk_task != tsp->smk_forked);
 }
 
 /*
@@ -1583,12 +1564,7 @@ static void smack_task_getsecid(struct task_struct *p, u32 *secid)
  */
 static int smack_task_setnice(struct task_struct *p, int nice)
 {
-	int rc;
-
-	rc = cap_task_setnice(p, nice);
-	if (rc == 0)
-		rc = smk_curacc_on_task(p, MAY_WRITE, __func__);
-	return rc;
+	return smk_curacc_on_task(p, MAY_WRITE, __func__);
 }
 
 /**
@@ -1600,12 +1576,7 @@ static int smack_task_setnice(struct task_struct *p, int nice)
  */
 static int smack_task_setioprio(struct task_struct *p, int ioprio)
 {
-	int rc;
-
-	rc = cap_task_setioprio(p, ioprio);
-	if (rc == 0)
-		rc = smk_curacc_on_task(p, MAY_WRITE, __func__);
-	return rc;
+	return smk_curacc_on_task(p, MAY_WRITE, __func__);
 }
 
 /**
@@ -1629,12 +1600,7 @@ static int smack_task_getioprio(struct task_struct *p)
  */
 static int smack_task_setscheduler(struct task_struct *p)
 {
-	int rc;
-
-	rc = cap_task_setscheduler(p);
-	if (rc == 0)
-		rc = smk_curacc_on_task(p, MAY_WRITE, __func__);
-	return rc;
+	return smk_curacc_on_task(p, MAY_WRITE, __func__);
 }
 
 /**
@@ -3591,7 +3557,7 @@ static __init int smack_init(void)
 	struct cred *cred;
 	struct task_smack *tsp;
 
-	if (!security_module_enable(&smack_ops))
+	if (security_module_enable(&smack_ops))
 		return 0;
 
 	tsp = new_task_smack(smack_known_floor.smk_known,
@@ -3613,12 +3579,6 @@ static __init int smack_init(void)
 	/* initialize the smack_known_list */
 	init_smack_known_list();
 
-	/*
-	 * Register with LSM
-	 */
-	if (register_security(&smack_ops))
-		panic("smack: Unable to register with kernel.\n");
-
 	return 0;
 }
 
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index f51f98f..aefe8e7 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -2217,7 +2217,7 @@ static int __init init_smk_fs(void)
 	int err;
 	int rc;
 
-	if (!security_module_enable(&smack_ops))
+	if (security_module_enable(&smack_ops))
 		return 0;
 
 	err = smk_init_sysfs();
diff --git a/security/tomoyo/tomoyo.c b/security/tomoyo/tomoyo.c
index 2b4cade..bfe54d6 100644
--- a/security/tomoyo/tomoyo.c
+++ b/security/tomoyo/tomoyo.c
@@ -78,12 +78,6 @@ static void tomoyo_cred_free(struct cred *cred)
  */
 static int tomoyo_bprm_set_creds(struct linux_binprm *bprm)
 {
-	int rc;
-
-	rc = cap_bprm_set_creds(bprm);
-	if (rc)
-		return rc;
-
 	/*
 	 * Do only if this function is called for the first time of an execve
 	 * operation.
@@ -556,7 +550,7 @@ static int __init tomoyo_init(void)
 	struct cred *cred = (struct cred *) current_cred();
 
 	/* register ourselves with the security framework */
-	if (!security_module_enable(&tomoyo_security_ops))
+	if (security_module_enable(&tomoyo_security_ops))
 		return 0;
 
 	if (init_srcu_struct(&tomoyo_ss))
diff --git a/security/yama/Kconfig b/security/yama/Kconfig
index 51d6709..a99aa1d 100644
--- a/security/yama/Kconfig
+++ b/security/yama/Kconfig
@@ -11,3 +11,4 @@ config SECURITY_YAMA
 	  Further information can be found in Documentation/security/Yama.txt.
 
 	  If you are unsure how to answer this question, answer N.
+
diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
index 63ad9bb..4958e68 100644
--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -154,13 +154,9 @@ void yama_task_free(struct task_struct *task)
 int yama_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			   unsigned long arg4, unsigned long arg5)
 {
-	int rc;
+	int rc = -ENOSYS;
 	struct task_struct *myself = current;
 
-	rc = cap_task_prctl(option, arg2, arg3, arg4, arg5);
-	if (rc != -ENOSYS)
-		return rc;
-
 	switch (option) {
 	case PR_SET_PTRACER:
 		/* Since a thread can call prctl(), find the group leader
@@ -282,14 +278,7 @@ static int ptracer_exception_found(struct task_struct *tracer,
 int yama_ptrace_access_check(struct task_struct *child,
 				    unsigned int mode)
 {
-	int rc;
-
-	/* If standard caps disallows it, so does Yama.  We should
-	 * only tighten restrictions further.
-	 */
-	rc = cap_ptrace_access_check(child, mode);
-	if (rc)
-		return rc;
+	int rc = 0;
 
 	/* require ptrace target be a child of ptracer on attach */
 	if (mode == PTRACE_MODE_ATTACH) {
@@ -335,14 +324,7 @@ int yama_ptrace_access_check(struct task_struct *child,
  */
 int yama_ptrace_traceme(struct task_struct *parent)
 {
-	int rc;
-
-	/* If standard caps disallows it, so does Yama.  We should
-	 * only tighten restrictions further.
-	 */
-	rc = cap_ptrace_traceme(parent);
-	if (rc)
-		return rc;
+	int rc = 0;
 
 	/* Only disallow PTRACE_TRACEME on more aggressive settings. */
 	switch (ptrace_scope) {
@@ -364,6 +346,14 @@ int yama_ptrace_traceme(struct task_struct *parent)
 	return rc;
 }
 
+static struct security_operations yama_ops = {
+	.name =			"yama",
+
+	.ptrace_access_check =	yama_ptrace_access_check,
+	.ptrace_traceme =	yama_ptrace_traceme,
+	.task_prctl =		yama_task_prctl,
+	.task_free =		yama_task_free,
+};
 
 #ifdef CONFIG_SYSCTL
 static int yama_dointvec_minmax(struct ctl_table *table, int write,
@@ -410,6 +400,8 @@ static struct ctl_table yama_sysctl_table[] = {
 
 static __init int yama_init(void)
 {
+	if (security_module_enable(&yama_ops))
+		return 0;
 
 	printk(KERN_INFO "Yama: becoming mindful.\n");
 


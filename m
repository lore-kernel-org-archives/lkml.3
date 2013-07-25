Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459Ab3GYSc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:32:27 -0400
Received: from smtp104.biz.mail.gq1.yahoo.com ([98.137.12.179]:37001 "HELO
	smtp104.biz.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757205Ab3GYScV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 14:32:21 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Y2zkW40VM1k9pvkoJxFq39YCUGxKCzhwgny9rqYhExP53I9
 n0CiQTpLigTnRclKLnWl91vJy40rXtiambJHJyjUMdvLP5_nTVoMXIT8cGH.
 Gja1J4ObDzMt.f090smE7TG83NVNLNAvqlWh2IfpoGicCoH9Bl.0Vfnkcl28
 jmRPTZrav5Sm7ILKgUxOOdyV1pZvtb1dShKZA9u1pKfA7BphkvAs5aVz.Vb4
 g_d2nkzy_y9hoyJH1gLguibTE7l_iqYpygtJanYDu5_O9HwnPwgj.OSs1JBk
 a8XJXuj4.t2EKDFatzPitQGdCkQsrNasX2Uyn0yLpuk3GbcxnnrNtrxJ0ZTZ
 aB1yCesMPvl5jVGmO9bFzq.YWLkjKP.Z.0r9EERxl2hXK9u9d_T1IZxdFbLh
 xnG1_mLT0MUwz0uJ1oMeGbFY26nq6slwwTSzfB3yUCVF8C__jxZXEPBR7kKP
 EAFqJp7cMtDIlrz1ziYZJsnTJy5Soblef30JgNtqTh6uIzl3WJ17tbd0_TW1
 pVwVl7ONn55AgK6MhrA--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with )
        by smtp104.biz.mail.gq1.yahoo.com with SMTP; 25 Jul 2013 11:32:19 -0700 PDT
Message-ID: <51F16F33.2050408@schaufler-ca.com>
Date: Thu, 25 Jul 2013 11:32:19 -0700
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
Subject: [PATCH v14 4/6] LSM: List based multiple LSM hooks
References: <51F16CFB.6040603@schaufler-ca.com>
In-Reply-To: <51F16CFB.6040603@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH v14 4/6] LSM: List based multiple LSM hooks

Change the basic hook logic to call all available LSM
versions of a particular hook. If the hook returns a value
return the last error code encountered, or success. If the
hook does not return a value just call them all. There are
special cases that violate this scheme, and they are handled
individually. Except in rare occasions the existing security
modules get the same arguments as they did before.

Introduce vectored security blobs. Security blobs are handled
by allocating a master blob that contains the blob pointers
provided by the individual LSMs. These master blobs are managed
in the lsm infrastructure.

Restructure the interpretation of the security= boot option and
CONFIG_SECURITY_DEFAULT to allow an ordered list of security modules.
Provide configuration options for the features that don't combine well,
NetLabel, xfrm, secmark and SO_PEERSEC.

Remove special case Yama stacking.
Remove the register_security interface and do all of the work
of registering an LSM in security_module_enable instead.
Put the security_module_disable interface (formerly reset_security_ops)
under ifdef. Make it general on the off chance another LSM may
want to use it in the future.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---
 fs/proc/base.c               |    8 +-
 include/linux/lsm.h          |  101 ++-
 include/linux/security.h     |  427 ++++++---
 include/net/af_unix.h        |    5 +-
 kernel/audit.c               |    2 +-
 kernel/auditsc.c             |    2 +-
 net/netfilter/xt_SECMARK.c   |    6 +-
 net/netlabel/netlabel_user.c |    2 +-
 net/unix/af_unix.c           |   14 +-
 security/Kconfig             |  194 ++++-
 security/Makefile            |    2 +-
 security/apparmor/domain.c   |    9 +-
 security/apparmor/lsm.c      |    9 -
 security/commoncap.c         |    6 -
 security/inode.c             |   12 +-
 security/security.c          | 1979 ++++++++++++++++++++++++++++++++++--------
 security/selinux/hooks.c     |   53 +-
 security/selinux/netlabel.c  |   29 +-
 security/smack/smack_lsm.c   |   48 +-
 security/tomoyo/tomoyo.c     |    9 +-
 security/yama/Kconfig        |    7 -
 security/yama/yama_lsm.c     |    9 -
 22 files changed, 2290 insertions(+), 643 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 3018f3d..941fe83 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -131,11 +131,11 @@ struct pid_entry {
 #define REG(NAME, MODE, fops)				\
 	NOD(NAME, (S_IFREG|(MODE)), NULL, &fops, {})
 #define INF(NAME, MODE, read)				\
-	NOD(NAME, (S_IFREG|(MODE)), 			\
+	NOD(NAME, (S_IFREG|(MODE)),			\
 		NULL, &proc_info_file_operations,	\
 		{ .proc_read = read } )
 #define ONE(NAME, MODE, show)				\
-	NOD(NAME, (S_IFREG|(MODE)), 			\
+	NOD(NAME, (S_IFREG|(MODE)),			\
 		NULL, &proc_single_file_operations,	\
 		{ .proc_show = show } )
 
@@ -210,7 +210,7 @@ static int proc_pid_cmdline(struct task_struct *task, char * buffer)
 	if (!mm->arg_end)
 		goto out_mm;	/* Shh! No looking before we're done */
 
- 	len = mm->arg_end - mm->arg_start;
+	len = mm->arg_end - mm->arg_start;
  
 	if (len > PAGE_SIZE)
 		len = PAGE_SIZE;
@@ -2369,7 +2369,7 @@ static const struct pid_entry attr_dir_stuff[] = {
 	REG("selinux.keycreate",  S_IRUGO|S_IWUGO, proc_pid_attr_operations),
 	REG("selinux.sockcreate", S_IRUGO|S_IWUGO, proc_pid_attr_operations),
 #endif
-	#ifdef CONFIG_SECURITY_SMACK
+#ifdef CONFIG_SECURITY_SMACK
 	REG("smack.current",      S_IRUGO|S_IWUGO, proc_pid_attr_operations),
 #endif
 #ifdef CONFIG_SECURITY_APPARMOR
diff --git a/include/linux/lsm.h b/include/linux/lsm.h
index eb82e6f..87736ba 100644
--- a/include/linux/lsm.h
+++ b/include/linux/lsm.h
@@ -25,164 +25,187 @@
 
 extern struct security_operations *security_ops;
 
-static inline void *lsm_get_blob(void *bp, const int lsm)
+/*
+ * Just a set of slots for each LSM to keep its blob in.
+ */
+struct lsm_blob {
+	int	lsm_setcount;		/* Number of blobs set */
+	void	*lsm_blobs[LSM_SLOTS];	/* LSM specific blobs */
+};
+
+static inline struct lsm_blob *lsm_alloc_blob(gfp_t gfp)
 {
-	return bp;
+	return kzalloc(sizeof(struct lsm_blob), gfp);
+}
+
+static inline void *lsm_get_blob(void *vp, const int lsm)
+{
+	struct lsm_blob *bp = vp;
+
+	if (bp == NULL)
+		return NULL;
+	return bp->lsm_blobs[lsm];
 }
 
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
-	lsm_set_blob(&cred->security, value, 0);
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
 
 #endif /* CONFIG_SECURITY */
 
 static inline u32 lsm_get_secid(const struct secids *secid, int order)
 {
-	if (secid->si_count == 0)
-		return 0;
 	return secid->si_lsm[order];
 }
 
 static inline void lsm_set_secid(struct secids *secid, u32 lsecid, int order)
 {
-	if (secid->si_lsm[order] == lsecid)
-		return;
-	if (lsecid == 0)
-		secid->si_count--;
-	else if (secid->si_lsm[order] == 0)
-		secid->si_count++;
 	secid->si_lsm[order] = lsecid;
 }
 
 static inline void lsm_init_secid(struct secids *secid, u32 lsecid, int order)
 {
+	int i;
+
 	memset(secid, 0, sizeof(*secid));
 
 	if (lsecid == 0)
 		return;
-	/*
-	 * An order of -1 means set it for all LSMs.
-	 */
-	if (order < 0) {
-		secid->si_lsm[0] = lsecid;
-		secid->si_count++;
-	} else {
+	if (order >= 0) {
 		secid->si_lsm[order] = lsecid;
-		secid->si_count = 1;
+		return;
 	}
+	for (i = 0; i < LSM_SLOTS; i++)
+		secid->si_lsm[i] = lsecid;
 }
 
 static inline int lsm_zero_secid(struct secids *secid)
 {
-	if (secid->si_count == 0)
-		return 1;
-	return 0;
+	int i;
+
+	for (i = 0; i < LSM_SLOTS; i++)
+		if (secid->si_lsm[i] != 0)
+			return 0;
+	return 1;
 }
 
 #ifdef CONFIG_SECURITY
diff --git a/include/linux/security.h b/include/linux/security.h
index 2041cda..f63edec 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -57,8 +57,8 @@ struct mm_struct;
 #define SECURITY_NAME_MAX	10
 
 /* Maximum number of LSMs that can be used at a time.  */
-#define LSM_SLOTS            1
-#define LSM_NAMES_MAX      ((SECURITY_NAME_MAX + 1) * LSM_SLOTS)
+#define LSM_SLOTS	CONFIG_SECURITY_LSM_MAX
+#define LSM_NAMES_MAX	((SECURITY_NAME_MAX + 1) * LSM_SLOTS)
 
 /* If capable should audit the security request */
 #define SECURITY_CAP_NOAUDIT 0
@@ -91,8 +91,6 @@ extern int cap_inode_removexattr(struct dentry *dentry, const char *name);
 extern int cap_inode_need_killpriv(struct dentry *dentry);
 extern int cap_inode_killpriv(struct dentry *dentry);
 extern int cap_mmap_addr(unsigned long addr);
-extern int cap_mmap_file(struct file *file, unsigned long reqprot,
-			 unsigned long prot, unsigned long flags);
 extern int cap_task_fix_setuid(struct cred *new, const struct cred *old, int flags);
 extern int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			  unsigned long arg4, unsigned long arg5);
@@ -116,8 +114,6 @@ struct seq_file;
 
 extern int cap_netlink_send(struct sock *sk, struct sk_buff *skb);
 
-void reset_security_ops(void);
-
 #ifdef CONFIG_MMU
 extern unsigned long mmap_min_addr;
 extern unsigned long dac_mmap_min_addr;
@@ -152,10 +148,11 @@ struct request_sock;
 #define LSM_UNSAFE_NO_NEW_PRIVS	8
 
 /* Unstackable features */
-#define LSM_FEATURE_PRESENT	0x1
-#define LSM_FEATURE_NETLABEL	0x2
-#define LSM_FEATURE_XFRM	0x4
-#define LSM_FEATURE_SECMARK	0x8
+#define LSM_FEATURE_PRESENT	0x01
+#define LSM_FEATURE_NETLABEL	0x02
+#define LSM_FEATURE_XFRM	0x04
+#define LSM_FEATURE_SECMARK	0x08
+#define LSM_FEATURE_SECIDS	0x10
 
 #ifdef CONFIG_MMU
 extern int mmap_min_addr_handler(struct ctl_table *table, int write,
@@ -168,7 +165,6 @@ typedef int (*initxattrs) (struct inode *inode,
 
 /* A collection of secids, which are what (certain) LSMs deal with */
 struct secids {
-	int	si_count;
 	u32	si_lsm[LSM_SLOTS];
 };
 
@@ -200,11 +196,218 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
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
@@ -1339,9 +1542,11 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	Convert secid to security context.  If secdata is NULL the length of
  *	the result will be returned in seclen, but no secdata will be returned.
  *	This does mean that the length could change between calls to check the
- *	length and the next call which actually allocates and returns the secdata.
+ *	length and the next call which actually allocates and returns the
+ *	secdata.
  *	@secid contains the security ID.
- *	@secdata contains the pointer that stores the converted security context.
+ *	@secdata contains the pointer that stores the converted security
+ *	context.
  *	@seclen pointer which contains the length of the data
  * @secctx_to_secid:
  *	Convert security context to secid.
@@ -1422,11 +1627,13 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  * This is the main security structure.
  */
 struct security_operations {
+	struct list_head list[LSM_MAX_HOOKS];
 	char name[SECURITY_NAME_MAX + 1];
 	int order;
 	int features;
 
-	int (*ptrace_access_check) (struct task_struct *child, unsigned int mode);
+	int (*ptrace_access_check) (struct task_struct *child,
+				    unsigned int mode);
 	int (*ptrace_traceme) (struct task_struct *parent);
 	int (*capget) (struct task_struct *target,
 		       kernel_cap_t *effective,
@@ -1466,14 +1673,16 @@ struct security_operations {
 				struct security_mnt_opts *opts);
 	int (*sb_clone_mnt_opts) (const struct super_block *oldsb,
 				   struct super_block *newsb);
-	int (*sb_parse_opts_str) (char *options, struct security_mnt_opts *opts);
+	int (*sb_parse_opts_str) (char *options,
+				  struct security_mnt_opts *opts);
 
 #ifdef CONFIG_SECURITY_PATH
 	int (*path_unlink) (struct path *dir, struct dentry *dentry);
-	int (*path_mkdir) (struct path *dir, struct dentry *dentry, umode_t mode);
+	int (*path_mkdir) (struct path *dir, struct dentry *dentry,
+			   umode_t mode);
 	int (*path_rmdir) (struct path *dir, struct dentry *dentry);
-	int (*path_mknod) (struct path *dir, struct dentry *dentry, umode_t mode,
-			   unsigned int dev);
+	int (*path_mknod) (struct path *dir, struct dentry *dentry,
+			   umode_t mode, unsigned int dev);
 	int (*path_truncate) (struct path *path);
 	int (*path_symlink) (struct path *dir, struct dentry *dentry,
 			     const char *old_name);
@@ -1498,7 +1707,8 @@ struct security_operations {
 	int (*inode_unlink) (struct inode *dir, struct dentry *dentry);
 	int (*inode_symlink) (struct inode *dir,
 			      struct dentry *dentry, const char *old_name);
-	int (*inode_mkdir) (struct inode *dir, struct dentry *dentry, umode_t mode);
+	int (*inode_mkdir) (struct inode *dir, struct dentry *dentry,
+			    umode_t mode);
 	int (*inode_rmdir) (struct inode *dir, struct dentry *dentry);
 	int (*inode_mknod) (struct inode *dir, struct dentry *dentry,
 			    umode_t mode, dev_t dev);
@@ -1518,9 +1728,12 @@ struct security_operations {
 	int (*inode_removexattr) (struct dentry *dentry, const char *name);
 	int (*inode_need_killpriv) (struct dentry *dentry);
 	int (*inode_killpriv) (struct dentry *dentry);
-	int (*inode_getsecurity) (const struct inode *inode, const char *name, void **buffer, bool alloc);
-	int (*inode_setsecurity) (struct inode *inode, const char *name, const void *value, size_t size, int flags);
-	int (*inode_listsecurity) (struct inode *inode, char *buffer, size_t buffer_size);
+	int (*inode_getsecurity) (const struct inode *inode, const char *name,
+				  void **buffer, bool alloc);
+	int (*inode_setsecurity) (struct inode *inode, const char *name,
+				  const void *value, size_t size, int flags);
+	int (*inode_listsecurity) (struct inode *inode, char *buffer,
+				   size_t buffer_size);
 	void (*inode_getsecid) (const struct inode *inode, u32 *secid);
 
 	int (*file_permission) (struct file *file, int mask);
@@ -1613,7 +1826,8 @@ struct security_operations {
 	void (*d_instantiate) (struct dentry *dentry, struct inode *inode);
 
 	int (*getprocattr) (struct task_struct *p, char *name, char **value);
-	int (*setprocattr) (struct task_struct *p, char *name, void *value, size_t size);
+	int (*setprocattr) (struct task_struct *p, char *name, void *value,
+			    size_t size);
 	int (*secid_to_secctx) (u32 secid, char **secdata, u32 *seclen);
 	int (*secctx_to_secid) (const char *secdata, u32 seclen, u32 *secid);
 	void (*release_secctx) (char *secdata, u32 seclen);
@@ -1623,7 +1837,8 @@ struct security_operations {
 	int (*inode_getsecctx)(struct inode *inode, void **ctx, u32 *ctxlen);
 
 #ifdef CONFIG_SECURITY_NETWORK
-	int (*unix_stream_connect) (struct sock *sock, struct sock *other, struct sock *newsk);
+	int (*unix_stream_connect) (struct sock *sock, struct sock *other,
+				    struct sock *newsk);
 	int (*unix_may_send) (struct socket *sock, struct socket *other);
 
 	int (*socket_create) (int family, int type, int protocol, int kern);
@@ -1645,8 +1860,11 @@ struct security_operations {
 	int (*socket_setsockopt) (struct socket *sock, int level, int optname);
 	int (*socket_shutdown) (struct socket *sock, int how);
 	int (*socket_sock_rcv_skb) (struct sock *sk, struct sk_buff *skb);
-	int (*socket_getpeersec_stream) (struct socket *sock, char __user *optval, int __user *optlen, unsigned len);
-	int (*socket_getpeersec_dgram) (struct socket *sock, struct sk_buff *skb, u32 *secid);
+	int (*socket_getpeersec_stream) (struct socket *sock,
+					 char __user *optval,
+					 int __user *optlen, unsigned len);
+	int (*socket_getpeersec_dgram) (struct socket *sock,
+					struct sk_buff *skb, u32 *secid);
 	int (*sk_alloc_security) (struct sock *sk, int family, gfp_t priority);
 	void (*sk_free_security) (struct sock *sk);
 	void (*sk_clone_security) (const struct sock *sk, struct sock *newsk);
@@ -1654,12 +1872,14 @@ struct security_operations {
 	void (*sock_graft) (struct sock *sk, struct socket *parent);
 	int (*inet_conn_request) (struct sock *sk, struct sk_buff *skb,
 				  struct request_sock *req);
-	void (*inet_csk_clone) (struct sock *newsk, const struct request_sock *req);
+	void (*inet_csk_clone) (struct sock *newsk,
+				const struct request_sock *req);
 	void (*inet_conn_established) (struct sock *sk, struct sk_buff *skb);
 	int (*secmark_relabel_packet) (u32 secid);
 	void (*secmark_refcount_inc) (void);
 	void (*secmark_refcount_dec) (void);
-	void (*req_classify_flow) (const struct request_sock *req, struct flowi *fl);
+	void (*req_classify_flow) (const struct request_sock *req,
+				   struct flowi *fl);
 	int (*tun_dev_alloc_security) (void **security);
 	void (*tun_dev_free_security) (void *security);
 	int (*tun_dev_create) (void);
@@ -1672,7 +1892,8 @@ struct security_operations {
 #ifdef CONFIG_SECURITY_NETWORK_XFRM
 	int (*xfrm_policy_alloc_security) (struct xfrm_sec_ctx **ctxp,
 			struct xfrm_user_sec_ctx *sec_ctx);
-	int (*xfrm_policy_clone_security) (struct xfrm_sec_ctx *old_ctx, struct xfrm_sec_ctx **new_ctx);
+	int (*xfrm_policy_clone_security) (struct xfrm_sec_ctx *old_ctx,
+					   struct xfrm_sec_ctx **new_ctx);
 	void (*xfrm_policy_free_security) (struct xfrm_sec_ctx *ctx);
 	int (*xfrm_policy_delete_security) (struct xfrm_sec_ctx *ctx);
 	int (*xfrm_state_alloc_security) (struct xfrm_state *x,
@@ -1680,7 +1901,8 @@ struct security_operations {
 		u32 secid);
 	void (*xfrm_state_free_security) (struct xfrm_state *x);
 	int (*xfrm_state_delete_security) (struct xfrm_state *x);
-	int (*xfrm_policy_lookup) (struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir);
+	int (*xfrm_policy_lookup) (struct xfrm_sec_ctx *ctx, u32 fl_secid,
+				   u8 dir);
 	int (*xfrm_state_pol_flow_match) (struct xfrm_state *x,
 					  struct xfrm_policy *xp,
 					  const struct flowi *fl);
@@ -1689,7 +1911,8 @@ struct security_operations {
 
 	/* key management security hooks */
 #ifdef CONFIG_KEYS
-	int (*key_alloc) (struct key *key, const struct cred *cred, unsigned long flags);
+	int (*key_alloc) (struct key *key, const struct cred *cred,
+			  unsigned long flags);
 	void (*key_free) (struct key *key);
 	int (*key_permission) (key_ref_t key_ref,
 			       const struct cred *cred,
@@ -1698,7 +1921,8 @@ struct security_operations {
 #endif	/* CONFIG_KEYS */
 
 #ifdef CONFIG_AUDIT
-	int (*audit_rule_init) (u32 field, u32 op, char *rulestr, void **lsmrule);
+	int (*audit_rule_init) (u32 field, u32 op, char *rulestr,
+				void **lsmrule);
 	int (*audit_rule_known) (struct audit_krule *krule);
 	int (*audit_rule_match) (u32 secid, u32 field, u32 op, void *lsmrule,
 				 struct audit_context *actx);
@@ -1709,9 +1933,11 @@ struct security_operations {
 /* prototypes */
 extern int security_init(void);
 extern int security_module_enable(struct security_operations *ops);
-extern int register_security(struct security_operations *ops);
 extern void __init security_fixup_ops(struct security_operations *ops);
 
+#ifdef CONFIG_SECURITY_SELINUX_DISABLE
+extern void security_module_disable(struct security_operations *ops);
+#endif /* CONFIG_SECURITY_SELINUX_DISABLE */
 
 /* Security operations */
 int security_ptrace_access_check(struct task_struct *child, unsigned int mode);
@@ -1749,7 +1975,8 @@ int security_sb_mount(const char *dev_name, struct path *path,
 		      const char *type, unsigned long flags, void *data);
 int security_sb_umount(struct vfsmount *mnt, int flags);
 int security_sb_pivotroot(struct path *old_path, struct path *new_path);
-int security_sb_set_mnt_opts(struct super_block *sb, struct security_mnt_opts *opts);
+int security_sb_set_mnt_opts(struct super_block *sb,
+			     struct security_mnt_opts *opts);
 int security_sb_clone_mnt_opts(const struct super_block *oldsb,
 				struct super_block *newsb);
 int security_sb_parse_opts_str(char *options, struct security_mnt_opts *opts);
@@ -1762,15 +1989,18 @@ int security_inode_init_security(struct inode *inode, struct inode *dir,
 int security_old_inode_init_security(struct inode *inode, struct inode *dir,
 				     const struct qstr *qstr, char **name,
 				     void **value, size_t *len);
-int security_inode_create(struct inode *dir, struct dentry *dentry, umode_t mode);
+int security_inode_create(struct inode *dir, struct dentry *dentry,
+			  umode_t mode);
 int security_inode_link(struct dentry *old_dentry, struct inode *dir,
 			 struct dentry *new_dentry);
 int security_inode_unlink(struct inode *dir, struct dentry *dentry);
 int security_inode_symlink(struct inode *dir, struct dentry *dentry,
 			   const char *old_name);
-int security_inode_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode);
+int security_inode_mkdir(struct inode *dir, struct dentry *dentry,
+			 umode_t mode);
 int security_inode_rmdir(struct inode *dir, struct dentry *dentry);
-int security_inode_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, dev_t dev);
+int security_inode_mknod(struct inode *dir, struct dentry *dentry,
+			 umode_t mode, dev_t dev);
 int security_inode_rename(struct inode *old_dir, struct dentry *old_dentry,
 			  struct inode *new_dir, struct dentry *new_dentry);
 int security_inode_readlink(struct dentry *dentry);
@@ -1790,8 +2020,10 @@ int security_inode_killpriv(struct dentry *dentry);
 int security_inode_getsecurity(const struct inode *inode, const char *name,
 			       void **buffer, bool alloc,
 			       struct security_operations **sop);
-int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags);
-int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size);
+int security_inode_setsecurity(struct inode *inode, const char *name,
+			       const void *value, size_t size, int flags);
+int security_inode_listsecurity(struct inode *inode, char *buffer,
+				size_t buffer_size);
 void security_inode_getsecid(const struct inode *inode, struct secids *secid);
 int security_file_permission(struct file *file, int mask);
 int security_file_alloc(struct file *file);
@@ -1829,7 +2061,7 @@ int security_task_setnice(struct task_struct *p, int nice);
 int security_task_setioprio(struct task_struct *p, int ioprio);
 int security_task_getioprio(struct task_struct *p);
 int security_task_setrlimit(struct task_struct *p, unsigned int resource,
-		struct rlimit *new_rlim);
+			    struct rlimit *new_rlim);
 int security_task_setscheduler(struct task_struct *p);
 int security_task_getscheduler(struct task_struct *p);
 int security_task_movememory(struct task_struct *p);
@@ -1855,7 +2087,8 @@ int security_shm_alloc(struct shmid_kernel *shp);
 void security_shm_free(struct shmid_kernel *shp);
 int security_shm_associate(struct shmid_kernel *shp, int shmflg);
 int security_shm_shmctl(struct shmid_kernel *shp, int cmd);
-int security_shm_shmat(struct shmid_kernel *shp, char __user *shmaddr, int shmflg);
+int security_shm_shmat(struct shmid_kernel *shp, char __user *shmaddr,
+		       int shmflg);
 int security_sem_alloc(struct sem_array *sma);
 void security_sem_free(struct sem_array *sma);
 int security_sem_associate(struct sem_array *sma, int semflg);
@@ -1864,7 +2097,8 @@ int security_sem_semop(struct sem_array *sma, struct sembuf *sops,
 			unsigned nsops, int alter);
 void security_d_instantiate(struct dentry *dentry, struct inode *inode);
 int security_getprocattr(struct task_struct *p, char *name, char **value);
-int security_setprocattr(struct task_struct *p, char *name, void *value, size_t size);
+int security_setprocattr(struct task_struct *p, char *name, void *value,
+			 size_t size);
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
 int security_secid_to_secctx(struct secids *secid, char **secdata, u32 *seclen,
 			     struct security_operations **secops);
@@ -2228,7 +2462,6 @@ static inline int security_inode_listsecurity(struct inode *inode, char *buffer,
 static inline void security_inode_getsecid(const struct inode *inode,
 						struct secids *secid)
 {
-	secid->si_count = 0;
 	secid->si_lsm[0] = 0;
 }
 
@@ -2378,7 +2611,6 @@ static inline int security_task_getsid(struct task_struct *p)
 static inline void security_task_getsecid(struct task_struct *p,
 						struct secids *secid)
 {
-	secid->si_count = 0;
 	secid->si_lsm[0] = 0;
 }
 
@@ -2439,7 +2671,8 @@ static inline int security_task_prctl(int option, unsigned long arg2,
 	return cap_task_prctl(option, arg2, arg3, arg3, arg5);
 }
 
-static inline void security_task_to_inode(struct task_struct *p, struct inode *inode)
+static inline void security_task_to_inode(struct task_struct *p,
+					  struct inode *inode)
 { }
 
 static inline int security_ipc_permission(struct kern_ipc_perm *ipcp,
@@ -2451,7 +2684,6 @@ static inline int security_ipc_permission(struct kern_ipc_perm *ipcp,
 static inline void security_ipc_getsecid(struct kern_ipc_perm *ipcp,
 						struct secids *secid)
 {
-	secid->si_count = 0;
 	secid->si_lsm[0] = 0;
 }
 
@@ -2546,15 +2778,18 @@ static inline int security_sem_semop(struct sem_array *sma,
 	return 0;
 }
 
-static inline void security_d_instantiate(struct dentry *dentry, struct inode *inode)
+static inline void security_d_instantiate(struct dentry *dentry,
+					  struct inode *inode)
 { }
 
-static inline int security_getprocattr(struct task_struct *p, char *name, char **value)
+static inline int security_getprocattr(struct task_struct *p, char *name,
+				       char **value)
 {
 	return -EINVAL;
 }
 
-static inline int security_setprocattr(struct task_struct *p, char *name, void *value, size_t size)
+static inline int security_setprocattr(struct task_struct *p, char *name,
+				       void *value, size_t size)
 {
 	return -EINVAL;
 }
@@ -2583,11 +2818,13 @@ static inline void security_release_secctx(char *secdata, u32 seclen,
 {
 }
 
-static inline int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen)
+static inline int security_inode_notifysecctx(struct inode *inode, void *ctx,
+					      u32 ctxlen)
 {
 	return -EOPNOTSUPP;
 }
-static inline int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen)
+static inline int security_inode_setsecctx(struct dentry *dentry, void *ctx,
+					   u32 ctxlen)
 {
 	return -EOPNOTSUPP;
 }
@@ -2601,13 +2838,16 @@ static inline int security_inode_getsecctx(struct inode *inode, void **ctx,
 
 #ifdef CONFIG_SECURITY_NETWORK
 
-int security_unix_stream_connect(struct sock *sock, struct sock *other, struct sock *newsk);
+int security_unix_stream_connect(struct sock *sock, struct sock *other,
+				 struct sock *newsk);
 int security_unix_may_send(struct socket *sock,  struct socket *other);
 int security_socket_create(int family, int type, int protocol, int kern);
 int security_socket_post_create(struct socket *sock, int family,
 				int type, int protocol, int kern);
-int security_socket_bind(struct socket *sock, struct sockaddr *address, int addrlen);
-int security_socket_connect(struct socket *sock, struct sockaddr *address, int addrlen);
+int security_socket_bind(struct socket *sock, struct sockaddr *address,
+			 int addrlen);
+int security_socket_connect(struct socket *sock, struct sockaddr *address,
+			    int addrlen);
 int security_socket_listen(struct socket *sock, int backlog);
 int security_socket_accept(struct socket *sock, struct socket *newsock);
 int security_socket_sendmsg(struct socket *sock, struct msghdr *msg, int size);
@@ -2627,7 +2867,8 @@ int security_sk_alloc(struct sock *sk, int family, gfp_t priority);
 void security_sk_free(struct sock *sk);
 void security_sk_clone(const struct sock *sk, struct sock *newsk);
 void security_sk_classify_flow(struct sock *sk, struct flowi *fl);
-void security_req_classify_flow(const struct request_sock *req, struct flowi *fl);
+void security_req_classify_flow(const struct request_sock *req,
+				struct flowi *fl);
 void security_sock_graft(struct sock*sk, struct socket *parent);
 int security_inet_conn_request(struct sock *sk,
 			struct sk_buff *skb, struct request_sock *req);
@@ -2745,8 +2986,10 @@ static inline int security_sock_rcv_skb(struct sock *sk,
 	return 0;
 }
 
-static inline int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
-						    int __user *optlen, unsigned len)
+static inline int security_socket_getpeersec_stream(struct socket *sock,
+						    char __user *optval,
+						    int __user *optlen,
+						    unsigned len)
 {
 	return -ENOPROTOOPT;
 }
@@ -2775,7 +3018,8 @@ static inline void security_sk_classify_flow(struct sock *sk, struct flowi *fl)
 {
 }
 
-static inline void security_req_classify_flow(const struct request_sock *req, struct flowi *fl)
+static inline void security_req_classify_flow(const struct request_sock *req,
+					      struct flowi *fl)
 {
 }
 
@@ -2849,11 +3093,14 @@ static inline void security_skb_owned_by(struct sk_buff *skb, struct sock *sk)
 
 #ifdef CONFIG_SECURITY_NETWORK_XFRM
 
-int security_xfrm_policy_alloc(struct xfrm_sec_ctx **ctxp, struct xfrm_user_sec_ctx *sec_ctx);
-int security_xfrm_policy_clone(struct xfrm_sec_ctx *old_ctx, struct xfrm_sec_ctx **new_ctxp);
+int security_xfrm_policy_alloc(struct xfrm_sec_ctx **ctxp,
+			       struct xfrm_user_sec_ctx *sec_ctx);
+int security_xfrm_policy_clone(struct xfrm_sec_ctx *old_ctx,
+			       struct xfrm_sec_ctx **new_ctxp);
 void security_xfrm_policy_free(struct xfrm_sec_ctx *ctx);
 int security_xfrm_policy_delete(struct xfrm_sec_ctx *ctx);
-int security_xfrm_state_alloc(struct xfrm_state *x, struct xfrm_user_sec_ctx *sec_ctx);
+int security_xfrm_state_alloc(struct xfrm_state *x,
+			      struct xfrm_user_sec_ctx *sec_ctx);
 int security_xfrm_state_alloc_acquire(struct xfrm_state *x,
 				      struct xfrm_sec_ctx *polsec, u32 secid);
 int security_xfrm_state_delete(struct xfrm_state *x);
@@ -2867,12 +3114,14 @@ void security_skb_classify_flow(struct sk_buff *skb, struct flowi *fl);
 
 #else	/* CONFIG_SECURITY_NETWORK_XFRM */
 
-static inline int security_xfrm_policy_alloc(struct xfrm_sec_ctx **ctxp, struct xfrm_user_sec_ctx *sec_ctx)
+static inline int security_xfrm_policy_alloc(struct xfrm_sec_ctx **ctxp,
+					     struct xfrm_user_sec_ctx *sec_ctx)
 {
 	return 0;
 }
 
-static inline int security_xfrm_policy_clone(struct xfrm_sec_ctx *old, struct xfrm_sec_ctx **new_ctxp)
+static inline int security_xfrm_policy_clone(struct xfrm_sec_ctx *old,
+					     struct xfrm_sec_ctx **new_ctxp)
 {
 	return 0;
 }
@@ -2924,7 +3173,8 @@ static inline int security_xfrm_decode_session(struct sk_buff *skb, u32 *secid)
 	return 0;
 }
 
-static inline void security_skb_classify_flow(struct sk_buff *skb, struct flowi *fl)
+static inline void security_skb_classify_flow(struct sk_buff *skb,
+					      struct flowi *fl)
 {
 }
 
@@ -3014,7 +3264,8 @@ static inline int security_path_chroot(struct path *path)
 #ifdef CONFIG_KEYS
 #ifdef CONFIG_SECURITY
 
-int security_key_alloc(struct key *key, const struct cred *cred, unsigned long flags);
+int security_key_alloc(struct key *key, const struct cred *cred,
+		       unsigned long flags);
 void security_key_free(struct key *key);
 int security_key_permission(key_ref_t key_ref,
 			    const struct cred *cred, key_perm_t perm);
@@ -3086,9 +3337,10 @@ static inline void security_audit_rule_free(void *lsmrule)
 #ifdef CONFIG_SECURITYFS
 
 extern struct dentry *securityfs_create_file(const char *name, umode_t mode,
-					     struct dentry *parent, void *data,
-					     const struct file_operations *fops);
-extern struct dentry *securityfs_create_dir(const char *name, struct dentry *parent);
+					struct dentry *parent, void *data,
+					const struct file_operations *fops);
+extern struct dentry *securityfs_create_dir(const char *name,
+					    struct dentry *parent);
 extern void securityfs_remove(struct dentry *dentry);
 
 #else /* CONFIG_SECURITYFS */
@@ -3100,10 +3352,10 @@ static inline struct dentry *securityfs_create_dir(const char *name,
 }
 
 static inline struct dentry *securityfs_create_file(const char *name,
-						    umode_t mode,
-						    struct dentry *parent,
-						    void *data,
-						    const struct file_operations *fops)
+					umode_t mode,
+					struct dentry *parent,
+					void *data,
+					const struct file_operations *fops)
 {
 	return ERR_PTR(-ENODEV);
 }
@@ -3136,36 +3388,5 @@ static inline void free_secdata(void *secdata)
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
 
diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index 32b53b7..16f1d2a 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -33,12 +33,11 @@ struct unix_skb_parms {
 	kgid_t			gid;
 	struct scm_fp_list	*fp;		/* Passed files		*/
 #ifdef CONFIG_SECURITY_NETWORK
-	struct secids		secid;		/* Security ID		*/
+	struct secids		*secid;		/* Security ID		*/
 #endif
 };
 
-#define UNIXCB(skb) 	(*(struct unix_skb_parms *)&((skb)->cb))
-#define UNIXSID(skb)	(&UNIXCB((skb)).secid)
+#define UNIXCB(skb)	(*(struct unix_skb_parms *)&((skb)->cb))
 
 #define unix_state_lock(s)	spin_lock(&unix_sk(s)->lock)
 #define unix_state_unlock(s)	spin_unlock(&unix_sk(s)->lock)
diff --git a/kernel/audit.c b/kernel/audit.c
index 00f3d36..8bbfbf2 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1529,7 +1529,7 @@ void audit_log_name(struct audit_context *context, struct audit_names *n,
 		char *ctx = NULL;
 		u32 len;
 		if (security_secid_to_secctx(&n->osid, &ctx, &len, &sop)) {
-			audit_log_format(ab, " osid=%u", n->osid.si_count);
+			audit_log_format(ab, " osid=%u", 0);
 			if (call_panic)
 				*call_panic = 2;
 		} else {
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index a1620f5..2932ac5 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1223,7 +1223,7 @@ static void show_special(struct audit_context *context, int *call_panic)
 			u32 len;
 			struct security_operations *sop;
 			if (security_secid_to_secctx(osid, &ctx, &len, &sop)) {
-				audit_log_format(ab, " osc=%u", osid->si_count);
+				audit_log_format(ab, " osc=%u", 0);
 				*call_panic = 1;
 			} else {
 				audit_log_format(ab, " obj=%s", ctx);
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index 9887626..1264079 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -62,13 +62,15 @@ static int checkentry_lsm(struct xt_secmark_target_info *info)
 				       &secid, lsm_secmark_ops());
 	if (err) {
 		if (err == -EINVAL)
-			pr_info("invalid security context \'%s\'\n", info->secctx);
+			pr_info("invalid security context \'%s\'\n",
+					info->secctx);
 		return err;
 	}
 
 	info->secid = lsm_get_secid(&secid, lsm_secmark_order());
 	if (!info->secid) {
-		pr_info("unable to map security context \'%s\'\n", info->secctx);
+		pr_info("unable to map security context \'%s\'\n",
+				info->secctx);
 		return -ENOENT;
 	}
 
diff --git a/net/netlabel/netlabel_user.c b/net/netlabel/netlabel_user.c
index 556f695..20e3e0d 100644
--- a/net/netlabel/netlabel_user.c
+++ b/net/netlabel/netlabel_user.c
@@ -114,7 +114,7 @@ struct audit_buffer *netlbl_audit_start_common(int type,
 			 from_kuid(&init_user_ns, audit_info->loginuid),
 			 audit_info->sessionid);
 
-	if (!lsm_zero_secid(&audit_info->secid) &&
+	if (lsm_get_secid(&audit_info->secid, lsm_netlbl_order()) &&
 	    security_secid_to_secctx(&audit_info->secid,
 				     &secctx,
 				     &secctx_len, &sop) == 0) {
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 964bbe3..56cd1d4 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -137,16 +137,22 @@ static struct hlist_head *unix_sockets_unbound(void *addr)
 #ifdef CONFIG_SECURITY_NETWORK
 static void unix_get_secdata(struct scm_cookie *scm, struct sk_buff *skb)
 {
-	struct secids *skb_secid = UNIXSID(skb);
+	struct secids *sip = kzalloc(sizeof(*sip), GFP_KERNEL);
 
-	*skb_secid = scm->secid;
+	if (sip)
+		memcpy(sip, &scm->secid, sizeof(*sip));
+	UNIXCB(skb).secid = sip;
 }
 
 static inline void unix_set_secdata(struct scm_cookie *scm, struct sk_buff *skb)
 {
-	struct secids *skb_secid = UNIXSID(skb);
+	struct secids *sip = UNIXCB(skb).secid;
 
-	scm->secid = *skb_secid;
+	if (sip) {
+		memcpy(&scm->secid, sip, sizeof(scm->secid));
+		kfree(sip);
+	} else
+		memset(&scm->secid, 0, sizeof(scm->secid));
 }
 #else
 static inline void unix_get_secdata(struct scm_cookie *scm, struct sk_buff *skb)
diff --git a/security/Kconfig b/security/Kconfig
index e9c6ac7..c6bedca 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -48,6 +48,44 @@ config SECURITY_NETWORK
 	  implement socket and networking access controls.
 	  If you are unsure how to answer this question, answer N.
 
+choice
+	depends on SECURITY && NETLABEL
+	prompt "Netlabel LSM"
+	default NETLABEL_SECURITY_FIRST
+
+	help
+	  Select the security module that will send attribute
+	  information in IP header options.
+	  Most SELinux configurations do not take advantage
+	  of Netlabel, while all Smack configurations do. Unless
+	  there is a need to do otherwise chose Smack in preference
+	  to SELinux.
+
+	config NETLABEL_SECURITY_FIRST
+		bool "First LSM using NetLabel"
+		help
+		  Send SELinux MLS information in IP packet headers
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
+	default "(first)"
+	help
+	  The name of the LSM to use with Netlabel
+
 config SECURITY_NETWORK_XFRM
 	bool "XFRM (IPSec) Networking Security Hooks"
 	depends on XFRM && SECURITY_NETWORK
@@ -61,6 +99,76 @@ config SECURITY_NETWORK_XFRM
 	  IPSec.
 	  If you are unsure how to answer this question, answer N.
 
+choice
+	depends on XFRM && SECURITY_NETWORK && SECURITY_NETWORK_XFRM
+	prompt "XFRM LSM"
+	default XFRM_SECURITY_FIRST
+
+	help
+	  Select the security module that will send attribute
+	  information based on IPSec policy
+	  Most SELinux configurations take advantage of XFRM.
+
+	config XFRM_SECURITY_FIRST
+		bool "First LSM using XFRM"
+		help
+		  Use first configured IPSec policy
+
+	config XFRM_SECURITY_SELINUX
+		bool "SELinux" if SECURITY_SELINUX=y
+		help
+		  Use SELinux IPSec policy
+
+endchoice
+
+config XFRM_LSM
+	string
+	default "selinux" if XFRM_SECURITY_SELINUX
+	default "(first)"
+	help
+	  The name of the LSM to use with XFRM and IPSec policy
+
+choice
+	depends on SECURITY_NETWORK
+	prompt "secmark LSM"
+	default SECMARK_SECURITY_FIRST
+
+	help
+	  Select the security module that will send attribute
+	  information based on secmark policy
+	  Most SELinux configurations take advantage of secmark.
+
+	config SECMARK_SECURITY_FIRST
+		bool "First LSM using secmark"
+		help
+		  Use first configured secmark policy
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
+	default "(first)"
+	help
+	  The name of the LSM to use with the networking secmark
+
+config SECURITY_PLAIN_CONTEXT
+	bool "Backward compatable contexts without lsm='value' formatting"
+	depends on SECURITY_SELINUX || SECURITY_SMACK
+	default y
+	help
+	  Without this value set security context strings will
+	  include the name of the lsm with which they are associated
+	  even if there is only one LSM that uses security contexts.
+	  This matches the way contexts were handled before it was
+	  possible to have multiple concurrent security modules.
+	  If you are unsure how to answer this question, answer Y.
+
 config SECURITY_PATH
 	bool "Security hooks for pathname based access control"
 	depends on SECURITY
@@ -123,49 +231,81 @@ source security/tomoyo/Kconfig
 source security/apparmor/Kconfig
 source security/yama/Kconfig
 
+config SECURITY_LSM_MAX
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
+	default "(all)"
+	help
+	  A comma separated list of LSMs to register.
+	  LSMs that are not configured that are listed
+	  will be ignored. If the "security=" option is
+	  specified in the boot line it will override
+	  this value. If the value is "(all)" all LSMs
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
+	default PRESENT_SECURITY_FIRST
 
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
+		bool "First LSM using /proc/.../attr"
+		help
+		  Present information from the first LSM that uses
+		  /proc/*/attr
 
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
+	default "(first)" if PRESENT_SECURITY_FIRST
+	default "(none)"
+	help
+	  The name of the LSM to present in /proc/.../attr
 
 endmenu
-
diff --git a/security/Makefile b/security/Makefile
index c26c81e..0370e41 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -14,8 +14,8 @@ obj-y					+= commoncap.o
 obj-$(CONFIG_MMU)			+= min_addr.o
 
 # Object file lists
-obj-$(CONFIG_SECURITY)			+= security.o capability.o
 obj-$(CONFIG_SECURITYFS)		+= inode.o
+obj-$(CONFIG_SECURITY)			+= security.o
 # Must precede capability.o in order to stack properly.
 obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
 obj-$(CONFIG_SECURITY_SMACK)		+= smack/built-in.o
diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index 2286daa..cce4dbe 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -537,12 +537,15 @@ cleanup:
  */
 int apparmor_bprm_secureexec(struct linux_binprm *bprm)
 {
+	int ret = cap_bprm_secureexec(bprm);
+
 	/* the decision to use secure exec is computed in set_creds
 	 * and stored in bprm->unsafe.
 	 */
-	if (bprm->unsafe & AA_SECURE_X_NEEDED)
-		return 1;
-	return 0;
+	if (!ret && (bprm->unsafe & AA_SECURE_X_NEEDED))
+		ret = 1;
+
+	return ret;
 }
 
 /**
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 709b2d7..78b271a 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -902,12 +902,6 @@ static int __init apparmor_init(void)
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
@@ -919,9 +913,6 @@ static int __init apparmor_init(void)
 
 	return error;
 
-set_init_cxt_out:
-	aa_free_task_context(lsm_get_cred(current->real_cred, &apparmor_ops));
-
 register_security_out:
 	aa_free_root_ns();
 
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
index 27157b4..36c3487 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -225,15 +225,19 @@ static ssize_t lsm_read(struct file *filp, char __user *buf, size_t count,
 	char *data;
 	int len;
 
-	data = kzalloc(SECURITY_NAME_MAX + 1, GFP_KERNEL);
+	data = kzalloc(LSM_NAMES_MAX + 1, GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
 
-	strcat(data, sop->name);
-	strcat(data, "\n");
+	list_for_each_entry(sop, &lsm_hooks[lsm_name], list[lsm_name]) {
+		strcat(data, sop->name);
+		strcat(data, ",");
+	}
 	len = strlen(data);
+	if (len > 1)
+		data[len-1] = '\n';
 
-	len = simple_read_from_buffer(buf, count, ppos, data, len + 1);
+	len = simple_read_from_buffer(buf, count, ppos, data, len);
 	kfree(data);
 
 	return len;
diff --git a/security/security.c b/security/security.c
index 9c87a4b..0ef87e5 100644
--- a/security/security.c
+++ b/security/security.c
@@ -4,6 +4,8 @@
  * Copyright (C) 2001 WireX Communications, Inc <chris@wirex.com>
  * Copyright (C) 2001-2002 Greg Kroah-Hartman <greg@kroah.com>
  * Copyright (C) 2001 Networks Associates Technology, Inc <ssmalley@nai.com>
+ * Copyright (C) 2013 Intel Corporation
+ * Copyright (C) 2013 Casey Schaufler <casey@schaufler-ca.com>
  *
  *	This program is free software; you can redistribute it and/or modify
  *	it under the terms of the GNU General Public License as published by
@@ -25,6 +27,8 @@
 #include <linux/mount.h>
 #include <linux/personality.h>
 #include <linux/backing-dev.h>
+#include <linux/shm.h>
+#include <linux/string.h>
 #include <net/flow.h>
 #ifdef CONFIG_NETLABEL
 #include <net/netlabel.h>
@@ -32,9 +36,17 @@
 
 #define MAX_LSM_EVM_XATTR	2
 
-/* Boot-time LSM user choice */
-static __initdata char chosen_lsm[SECURITY_NAME_MAX + 1] =
-	CONFIG_DEFAULT_SECURITY;
+struct list_head lsm_hooks[LSM_MAX_HOOKS];
+static __initdata int lsm_order_set;
+static __initdata int lsm_count;
+static __initdata char *specified_lsms[LSM_SLOTS];
+static __initdata char allowed_lsms[LSM_NAMES_MAX];
+
+/*
+ * Boot-time LSM user choice
+ */
+#define LSM_FIRST	"(first)"
+#define LSM_ALL		"(all)"
 
 #ifdef CONFIG_SECURITY_NETWORK_XFRM
 struct security_operations *xfrm_ops;
@@ -47,32 +59,306 @@ struct security_operations *netlbl_ops;
 struct security_operations *secmark_ops;
 EXPORT_SYMBOL(secmark_ops);
 #endif /* CONFIG_NETWORK_SECMARK */
-
-struct security_operations *security_ops;
-
+#ifdef CONFIG_SECURITY_PLAIN_CONTEXT
+struct security_operations *secid_ops;
+static __initdata int lsm_secid_users;
+#endif /* CONFIG_SECURITY_PLAIN_CONTEXT */
 struct security_operations *present_ops;
 static int (*present_getprocattr)
 	(struct task_struct *p, char *name, char **value);
 static int (*present_setprocattr)
 	(struct task_struct *p, char *name, void *value, size_t size);
-EXPORT_SYMBOL(security_ops);
 
-static struct security_operations default_security_ops = {
-	.name	= "default",
-};
+#define for_each_hook(SOP, HOOK) \
+	list_for_each_entry(SOP, &lsm_hooks[lsm_##HOOK], list[lsm_##HOOK])
 
-static inline int __init verify(struct security_operations *ops)
+/*
+ * Add an entry to a list of security operation vectors.
+ * The "interesting" logic is included here rather than in the
+ * caller to reduce the volume of the calling code.
+ */
+static void __init lsm_enlist(struct security_operations *ops,
+			      const enum lsm_hooks_index index,
+			      void *interesting)
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
 }
 
+/* Save user chosen LSM(s) */
+static int __init choose_lsm(char *str)
+{
+	char *cp;
+	char *ep;
+	int i;
+
+	if (lsm_order_set || !strcmp(str, LSM_ALL))
+		return 1;
+	lsm_order_set = 1;
+	pr_info("LSM order requested is \"%s\".\n", str);
+
+	strncpy(allowed_lsms, str, LSM_NAMES_MAX);
+	cp = allowed_lsms;
+
+	for (i = 0; i < LSM_SLOTS; i++) {
+		ep = strchr(cp, ',');
+		if (ep != NULL)
+			*ep = '\0';
+		if (strlen(cp) > SECURITY_NAME_MAX)
+			pr_warn("LSM \"%s\" is invalid and ignored.\n", cp);
+		else
+			specified_lsms[i] = cp;
+		if (ep == NULL)
+			break;
+		cp = ep + 1;
+	}
+
+	return 1;
+}
+__setup("security=", choose_lsm);
+
+
 static void __init do_security_initcalls(void)
 {
 	initcall_t *call;
+
 	call = __security_initcall_start;
 	while (call < __security_initcall_end) {
 		(*call) ();
@@ -87,46 +373,98 @@ static void __init do_security_initcalls(void)
  */
 int __init security_init(void)
 {
-#ifdef CONFIG_NETLABEL
-	int rc;
-#endif
+	enum lsm_hooks_index i;
 
-	printk(KERN_INFO "Security Framework initialized\n");
+	for (i = 0; i < LSM_MAX_HOOKS; i++)
+		INIT_LIST_HEAD(&lsm_hooks[i]);
 
-	security_fixup_ops(&default_security_ops);
-	security_ops = &default_security_ops;
+	(void) choose_lsm(CONFIG_DEFAULT_SECURITY);
+	pr_info("Security Framework initialized\n");
 	do_security_initcalls();
 
-	present_ops = security_ops;
-	present_getprocattr = present_ops->getprocattr;
-	present_setprocattr = present_ops->setprocattr;
-#ifdef CONFIG_SECURITY_NETWORK_XFRM
-	xfrm_ops = security_ops;
-#endif
+	if (present_ops)
+		pr_info("Security Module %s presented in /proc/.../attr.\n",
+			present_ops->name);
 #ifdef CONFIG_NETLABEL
-	rc = netlbl_lsm_register(security_ops);
-	if (rc < 0)
-		printk(KERN_INFO "NetLabel registration error %d\n", -rc);
+	/*
+	 * Reserve the netlabel subsystem for the specified LSM.
+	 */
+	if (netlbl_ops) {
+		i = netlbl_lsm_register(netlbl_ops);
+		pr_info("Security Module %s %s Netlabel network labeling.\n",
+			netlbl_ops->name, i ? "denied" : "uses");
+	}
+#endif
+#ifdef CONFIG_SECURITY_NETWORK_XFRM
+	if (xfrm_ops)
+		pr_info("Security Module %s uses XFRM network labeling.\n",
+			xfrm_ops->name);
 #endif
 #ifdef CONFIG_NETWORK_SECMARK
-	secmark_ops = security_ops;
+	/*
+	 * Reserve the networking secmark for the specified LSM.
+	 */
+	if (secmark_ops)
+		pr_info("Security Module %s uses secmark network labeling.\n",
+			secmark_ops->name);
 #endif
 
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
+	if (present_ops == ops)
+		present_ops = NULL;
+
+	lsm_delist_ops(ops);
+}
+
+#endif /* CONFIG_SECURITY_SELINUX_DISABLE */
+
+static int __init owns_feature(struct security_operations *fops,
+			       struct security_operations *lops,
+			       char *configured, int feature)
+{
+	if (!(lops->features & feature))
+		return 0;
+	if (!strcmp(lops->name, configured))
+		return 1;
+	if (strcmp(configured, LSM_FIRST))
+		return 0;
+	if (!fops || fops->order > lops->order)
+		return 1;
+	return 0;
 }
-__setup("security=", choose_lsm);
 
 /**
  * security_module_enable - Load given security module on boot ?
@@ -137,60 +475,261 @@ __setup("security=", choose_lsm);
  * to check if your LSM is currently loaded during kernel initialization.
  *
  * Return true if:
- *	-The passed LSM is the one chosen by user at boot time,
- *	-or the passed LSM is configured as the default and the user did not
- *	 choose an alternate LSM at boot time.
+ *	-The passed LSM is chosen by user at boot time,
+ *	-or the passed LSM is configured and the user did not
+ *	 choose to exclude it at boot time.
  * Otherwise, return false.
  */
 int __init security_module_enable(struct security_operations *ops)
 {
-	return !strcmp(ops->name, chosen_lsm);
-}
-
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
-		return -EINVAL;
+	struct security_operations *sop;
+	int i;
+	/*
+	 * Set up the operation vector early, but only once.
+	 * This allows LSM specific file systems to check to see if they
+	 * should come on line.
+	 */
+	if (ops == NULL) {
+		pr_debug("%s could not verify security_operations.\n",
+			__func__);
+		return 0;
 	}
+	/*
+	 * Return success if the LSM is already registered
+	 */
+	for_each_hook(sop, name)
+		if (sop == ops)
+			return 1;
+	/*
+	 * This LSM has not yet been ordered.
+	 */
+	ops->order = -1;
 
-	if (security_ops != &default_security_ops)
-		return -EAGAIN;
-
-	security_ops = ops;
+	if (lsm_count >= LSM_SLOTS) {
+		pr_warn("Too many security modules. %s not loaded.\n",
+			ops->name);
+		return 0;
+	}
+	if (lsm_order_set) {
+		for (i = 0; i < LSM_SLOTS && specified_lsms[i]; i++) {
+			if (strcmp(ops->name, specified_lsms[i]) == 0) {
+				ops->order = i;
+				break;
+			}
+		}
+		if (ops->order == -1) {
+			pr_notice("LSM %s declined by boot options.\n",
+				ops->name);
+			return 0;
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
+	/*
+	 * Allocate the features that require a dedicated module.
+	 * Give the feature to the first module in the list that
+	 * supports it unless explicitly told otherwise.
+	 * If a module is specified that does not supply the
+	 * required hooks don't assign the feature to anyone.
+	 *
+	 * CONFIG_SECURITY_PRESENT
+	 *      What shows up in /proc/.../attr/current
+	 * CONFIG_NETLABEL_LSM
+	 *      CIPSO networking
+	 * CONFIG_XFRM_LSM
+	 *      XFRM networking
+	 * CONFIG_SECMARK_LSM
+	 *      Networking secmark
+	 */
+#ifdef CONFIG_SECURITY_PLAIN_CONTEXT
+	if (ops->features & LSM_FEATURE_SECIDS) {
+		if (++lsm_secid_users == 1)
+			secid_ops = ops;
+		else
+			secid_ops = NULL;
+	}
+#endif
+	if (owns_feature(present_ops, ops, CONFIG_PRESENT_SECURITY,
+				LSM_FEATURE_PRESENT)) {
+		present_ops = ops;
+		present_getprocattr = ops->getprocattr;
+		present_setprocattr = ops->setprocattr;
+	}
+#ifdef CONFIG_NETLABEL
+	if (owns_feature(netlbl_ops, ops, CONFIG_NETLABEL_LSM,
+				LSM_FEATURE_NETLABEL))
+		netlbl_ops = ops;
+#endif
+#ifdef CONFIG_SECURITY_NETWORK_XFRM
+	if (owns_feature(xfrm_ops, ops, CONFIG_XFRM_LSM, LSM_FEATURE_XFRM))
+		xfrm_ops = ops;
+#endif
+#ifdef CONFIG_NETWORK_SECMARK
+	if (owns_feature(secmark_ops, ops, CONFIG_SECMARK_LSM,
+				LSM_FEATURE_SECMARK))
+		secmark_ops = ops;
+#endif
+	/*
+	 * Return success after registering the LSM.
+	 */
+	lsm_enlist_ops(ops);
 
-	return 0;
+	return 1;
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
+		struct security_operations *note[LSM_SLOTS];		\
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
 	int rc = cap_ptrace_access_check(child, mode);
 
 	if (rc)
 		return rc;
-
-#ifdef CONFIG_SECURITY_YAMA_STACKED
-	rc = yama_ptrace_access_check(child, mode);
-	if (rc)
-		return rc;
-#endif
-
-	return security_ops->ptrace_access_check(child, mode);
+	return call_int_hook(ptrace_access_check, child, mode);
 }
 
 int security_ptrace_traceme(struct task_struct *parent)
@@ -199,25 +738,46 @@ int security_ptrace_traceme(struct task_struct *parent)
 
 	if (rc)
 		return rc;
-
-#ifdef CONFIG_SECURITY_YAMA_STACKED
-	rc = yama_ptrace_traceme(parent);
-	if (rc)
-		return rc;
-#endif
-	return security_ops->ptrace_traceme(parent);
+	return call_int_hook(ptrace_traceme, parent);
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
-	int rc = cap_capget(target, effective, inheritable, permitted);
+	struct security_operations *sop;
+	kernel_cap_t cap[3];
+	kernel_cap_t this[3];
+	int thisrc;
+	int rc;
+	int i;
 
-	if (rc)
-		return rc;
-	return security_ops->capget(target, effective, inheritable, permitted);
+	rc = cap_capget(target, &cap[0], &cap[1], &cap[2]);
+
+	for_each_hook(sop, capget) {
+		thisrc = sop->capget(target, &this[0], &this[1], &this[2]);
+		if (thisrc != 0)
+			rc = thisrc;
+		else
+			for (i = 0; i < 3; i++)
+				cap[i] = cap_intersect(cap[i], this[i]);
+	}
+
+	if (rc == 0) {
+		*effective = cap[0];
+		*inheritable = cap[1];
+		*permitted = cap[2];
+	}
+
+	return rc;
 }
 
 int security_capset(struct cred *new, const struct cred *old,
@@ -229,8 +789,8 @@ int security_capset(struct cred *new, const struct cred *old,
 
 	if (rc)
 		return rc;
-	return security_ops->capset(new, old,
-				    effective, inheritable, permitted);
+	return call_int_hook(capset, new, old, effective,
+					inheritable, permitted);
 }
 
 int security_capable(const struct cred *cred, struct user_namespace *ns,
@@ -240,7 +800,7 @@ int security_capable(const struct cred *cred, struct user_namespace *ns,
 
 	if (rc)
 		return rc;
-	return security_ops->capable(cred, ns, cap, SECURITY_CAP_AUDIT);
+	return call_int_hook(capable, cred, ns, cap, SECURITY_CAP_AUDIT);
 }
 
 int security_capable_noaudit(const struct cred *cred, struct user_namespace *ns,
@@ -250,22 +810,22 @@ int security_capable_noaudit(const struct cred *cred, struct user_namespace *ns,
 
 	if (rc)
 		return rc;
-	return security_ops->capable(cred, ns, cap, SECURITY_CAP_NOAUDIT);
+	return call_int_hook(capable, cred, ns, cap, SECURITY_CAP_NOAUDIT);
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
@@ -274,7 +834,7 @@ int security_settime(const struct timespec *ts, const struct timezone *tz)
 
 	if (rc)
 		return rc;
-	return security_ops->settime(ts, tz);
+	return call_int_hook(settime, ts, tz);
 }
 
 int security_vm_enough_memory_mm(struct mm_struct *mm, long pages)
@@ -283,7 +843,7 @@ int security_vm_enough_memory_mm(struct mm_struct *mm, long pages)
 
 	if (rc)
 		return rc;
-	return security_ops->vm_enough_memory(mm, pages);
+	return call_int_hook(vm_enough_memory, mm, pages);
 }
 
 int security_bprm_set_creds(struct linux_binprm *bprm)
@@ -292,14 +852,14 @@ int security_bprm_set_creds(struct linux_binprm *bprm)
 
 	if (rc)
 		return rc;
-	return security_ops->bprm_set_creds(bprm);
+	return call_int_hook(bprm_set_creds, bprm);
 }
 
 int security_bprm_check(struct linux_binprm *bprm)
 {
 	int ret;
 
-	ret = security_ops->bprm_check_security(bprm);
+	ret = call_int_hook(bprm_check_security, bprm);
 	if (ret)
 		return ret;
 	return ima_bprm_check(bprm);
@@ -307,141 +867,164 @@ int security_bprm_check(struct linux_binprm *bprm)
 
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
-	int rc = security_ops->bprm_secureexec(bprm);
-
-	if (rc)
-		return rc;
-	return cap_bprm_secureexec(bprm);
+	return call_int_hook(bprm_secureexec, bprm);
 }
 
 int security_sb_alloc(struct super_block *sb)
 {
-	return security_ops->sb_alloc_security(sb);
+	return call_alloc_hook(sb_alloc_security, sb_free_security,
+				sb->s_security, GFP_KERNEL, sb);
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
 
 int security_sb_clone_mnt_opts(const struct super_block *oldsb,
 				struct super_block *newsb)
 {
-	return security_ops->sb_clone_mnt_opts(oldsb, newsb);
+	return call_int_hook(sb_clone_mnt_opts, oldsb, newsb);
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
+				inode->i_security, GFP_KERNEL, inode);
 }
 
 void security_inode_free(struct inode *inode)
 {
 	integrity_inode_free(inode);
-	security_ops->inode_free_security(inode);
+	call_void_hook(inode_free_security, inode);
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
+		return call_int_hook(inode_init_security, inode, dir, qstr,
+					NULL, NULL, NULL);
 
-	evm_xattr = lsm_xattr + 1;
-	ret = evm_inode_init_security(inode, lsm_xattr, evm_xattr);
-	if (ret)
-		goto out;
-	ret = initxattrs(inode, new_xattrs, fs_data);
-out:
-	for (xattr = new_xattrs; xattr->name != NULL; xattr++) {
-		kfree(xattr->name);
-		kfree(xattr->value);
+	memset(new_xattrs, 0, sizeof new_xattrs);
+
+	for_each_hook(sop, inode_init_security) {
+		thisrc = sop->inode_init_security(inode, dir, qstr,
+				&lsm_xattr->name, &lsm_xattr->value,
+				&lsm_xattr->value_len);
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
 
@@ -451,8 +1034,8 @@ int security_old_inode_init_security(struct inode *inode, struct inode *dir,
 {
 	if (unlikely(IS_PRIVATE(inode)))
 		return -EOPNOTSUPP;
-	return security_ops->inode_init_security(inode, dir, qstr, name, value,
-						 len);
+	return call_int_hook(inode_init_security, inode, dir, qstr, name,
+						value, len);
 }
 EXPORT_SYMBOL(security_old_inode_init_security);
 
@@ -462,7 +1045,7 @@ int security_path_mknod(struct path *dir, struct dentry *dentry, umode_t mode,
 {
 	if (unlikely(IS_PRIVATE(dir->dentry->d_inode)))
 		return 0;
-	return security_ops->path_mknod(dir, dentry, mode, dev);
+	return call_int_hook(path_mknod, dir, dentry, mode, dev);
 }
 EXPORT_SYMBOL(security_path_mknod);
 
@@ -470,7 +1053,7 @@ int security_path_mkdir(struct path *dir, struct dentry *dentry, umode_t mode)
 {
 	if (unlikely(IS_PRIVATE(dir->dentry->d_inode)))
 		return 0;
-	return security_ops->path_mkdir(dir, dentry, mode);
+	return call_int_hook(path_mkdir, dir, dentry, mode);
 }
 EXPORT_SYMBOL(security_path_mkdir);
 
@@ -478,14 +1061,14 @@ int security_path_rmdir(struct path *dir, struct dentry *dentry)
 {
 	if (unlikely(IS_PRIVATE(dir->dentry->d_inode)))
 		return 0;
-	return security_ops->path_rmdir(dir, dentry);
+	return call_int_hook(path_rmdir, dir, dentry);
 }
 
 int security_path_unlink(struct path *dir, struct dentry *dentry)
 {
 	if (unlikely(IS_PRIVATE(dir->dentry->d_inode)))
 		return 0;
-	return security_ops->path_unlink(dir, dentry);
+	return call_int_hook(path_unlink, dir, dentry);
 }
 EXPORT_SYMBOL(security_path_unlink);
 
@@ -494,7 +1077,7 @@ int security_path_symlink(struct path *dir, struct dentry *dentry,
 {
 	if (unlikely(IS_PRIVATE(dir->dentry->d_inode)))
 		return 0;
-	return security_ops->path_symlink(dir, dentry, old_name);
+	return call_int_hook(path_symlink, dir, dentry, old_name);
 }
 
 int security_path_link(struct dentry *old_dentry, struct path *new_dir,
@@ -502,7 +1085,7 @@ int security_path_link(struct dentry *old_dentry, struct path *new_dir,
 {
 	if (unlikely(IS_PRIVATE(old_dentry->d_inode)))
 		return 0;
-	return security_ops->path_link(old_dentry, new_dir, new_dentry);
+	return call_int_hook(path_link, old_dentry, new_dir, new_dentry);
 }
 
 int security_path_rename(struct path *old_dir, struct dentry *old_dentry,
@@ -511,7 +1094,7 @@ int security_path_rename(struct path *old_dir, struct dentry *old_dentry,
 	if (unlikely(IS_PRIVATE(old_dentry->d_inode) ||
 		     (new_dentry->d_inode && IS_PRIVATE(new_dentry->d_inode))))
 		return 0;
-	return security_ops->path_rename(old_dir, old_dentry, new_dir,
+	return call_int_hook(path_rename, old_dir, old_dentry, new_dir,
 					 new_dentry);
 }
 EXPORT_SYMBOL(security_path_rename);
@@ -520,26 +1103,26 @@ int security_path_truncate(struct path *path)
 {
 	if (unlikely(IS_PRIVATE(path->dentry->d_inode)))
 		return 0;
-	return security_ops->path_truncate(path);
+	return call_int_hook(path_truncate, path);
 }
 
 int security_path_chmod(struct path *path, umode_t mode)
 {
 	if (unlikely(IS_PRIVATE(path->dentry->d_inode)))
 		return 0;
-	return security_ops->path_chmod(path, mode);
+	return call_int_hook(path_chmod, path, mode);
 }
 
 int security_path_chown(struct path *path, kuid_t uid, kgid_t gid)
 {
 	if (unlikely(IS_PRIVATE(path->dentry->d_inode)))
 		return 0;
-	return security_ops->path_chown(path, uid, gid);
+	return call_int_hook(path_chown, path, uid, gid);
 }
 
 int security_path_chroot(struct path *path)
 {
-	return security_ops->path_chroot(path);
+	return call_int_hook(path_chroot, path);
 }
 #endif
 
@@ -547,7 +1130,7 @@ int security_inode_create(struct inode *dir, struct dentry *dentry, umode_t mode
 {
 	if (unlikely(IS_PRIVATE(dir)))
 		return 0;
-	return security_ops->inode_create(dir, dentry, mode);
+	return call_int_hook(inode_create, dir, dentry, mode);
 }
 EXPORT_SYMBOL_GPL(security_inode_create);
 
@@ -556,14 +1139,14 @@ int security_inode_link(struct dentry *old_dentry, struct inode *dir,
 {
 	if (unlikely(IS_PRIVATE(old_dentry->d_inode)))
 		return 0;
-	return security_ops->inode_link(old_dentry, dir, new_dentry);
+	return call_int_hook(inode_link, old_dentry, dir, new_dentry);
 }
 
 int security_inode_unlink(struct inode *dir, struct dentry *dentry)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_unlink(dir, dentry);
+	return call_int_hook(inode_unlink, dir, dentry);
 }
 
 int security_inode_symlink(struct inode *dir, struct dentry *dentry,
@@ -571,14 +1154,14 @@ int security_inode_symlink(struct inode *dir, struct dentry *dentry,
 {
 	if (unlikely(IS_PRIVATE(dir)))
 		return 0;
-	return security_ops->inode_symlink(dir, dentry, old_name);
+	return call_int_hook(inode_symlink, dir, dentry, old_name);
 }
 
 int security_inode_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	if (unlikely(IS_PRIVATE(dir)))
 		return 0;
-	return security_ops->inode_mkdir(dir, dentry, mode);
+	return call_int_hook(inode_mkdir, dir, dentry, mode);
 }
 EXPORT_SYMBOL_GPL(security_inode_mkdir);
 
@@ -586,14 +1169,14 @@ int security_inode_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_rmdir(dir, dentry);
+	return call_int_hook(inode_rmdir, dir, dentry);
 }
 
 int security_inode_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, dev_t dev)
 {
 	if (unlikely(IS_PRIVATE(dir)))
 		return 0;
-	return security_ops->inode_mknod(dir, dentry, mode, dev);
+	return call_int_hook(inode_mknod, dir, dentry, mode, dev);
 }
 
 int security_inode_rename(struct inode *old_dir, struct dentry *old_dentry,
@@ -602,7 +1185,7 @@ int security_inode_rename(struct inode *old_dir, struct dentry *old_dentry,
         if (unlikely(IS_PRIVATE(old_dentry->d_inode) ||
             (new_dentry->d_inode && IS_PRIVATE(new_dentry->d_inode))))
 		return 0;
-	return security_ops->inode_rename(old_dir, old_dentry,
+	return call_int_hook(inode_rename, old_dir, old_dentry,
 					   new_dir, new_dentry);
 }
 
@@ -610,21 +1193,21 @@ int security_inode_readlink(struct dentry *dentry)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_readlink(dentry);
+	return call_int_hook(inode_readlink, dentry);
 }
 
 int security_inode_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_follow_link(dentry, nd);
+	return call_int_hook(inode_follow_link, dentry, nd);
 }
 
 int security_inode_permission(struct inode *inode, int mask)
 {
 	if (unlikely(IS_PRIVATE(inode)))
 		return 0;
-	return security_ops->inode_permission(inode, mask);
+	return call_int_hook(inode_permission, inode, mask);
 }
 
 int security_inode_setattr(struct dentry *dentry, struct iattr *attr)
@@ -633,7 +1216,7 @@ int security_inode_setattr(struct dentry *dentry, struct iattr *attr)
 
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	ret = security_ops->inode_setattr(dentry, attr);
+	ret = call_int_hook(inode_setattr, dentry, attr);
 	if (ret)
 		return ret;
 	return evm_inode_setattr(dentry, attr);
@@ -644,7 +1227,7 @@ int security_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_getattr(mnt, dentry);
+	return call_int_hook(inode_getattr, mnt, dentry);
 }
 
 int security_inode_setxattr(struct dentry *dentry, const char *name,
@@ -654,7 +1237,7 @@ int security_inode_setxattr(struct dentry *dentry, const char *name,
 
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	ret = security_ops->inode_setxattr(dentry, name, value, size, flags);
+	ret = call_int_hook(inode_setxattr, dentry, name, value, size, flags);
 	if (ret)
 		return ret;
 	ret = ima_inode_setxattr(dentry, name, value, size);
@@ -668,7 +1251,7 @@ void security_inode_post_setxattr(struct dentry *dentry, const char *name,
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return;
-	security_ops->inode_post_setxattr(dentry, name, value, size, flags);
+	call_void_hook(inode_post_setxattr, dentry, name, value, size, flags);
 	evm_inode_post_setxattr(dentry, name, value, size);
 }
 
@@ -676,14 +1259,14 @@ int security_inode_getxattr(struct dentry *dentry, const char *name)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_getxattr(dentry, name);
+	return call_int_hook(inode_getxattr, dentry, name);
 }
 
 int security_inode_listxattr(struct dentry *dentry)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_listxattr(dentry);
+	return call_int_hook(inode_listxattr, dentry);
 }
 
 int security_inode_removexattr(struct dentry *dentry, const char *name)
@@ -692,7 +1275,8 @@ int security_inode_removexattr(struct dentry *dentry, const char *name)
 
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	ret = security_ops->inode_removexattr(dentry, name);
+	if (!call_int_must(ret, inode_removexattr, dentry, name))
+		ret = cap_inode_removexattr(dentry, name);
 	if (ret)
 		return ret;
 	ret = ima_inode_removexattr(dentry, name);
@@ -707,7 +1291,7 @@ int security_inode_need_killpriv(struct dentry *dentry)
 
 	if (rc)
 		return rc;
-	return security_ops->inode_need_killpriv(dentry);
+	return call_int_hook(inode_need_killpriv, dentry);
 }
 
 int security_inode_killpriv(struct dentry *dentry)
@@ -716,45 +1300,92 @@ int security_inode_killpriv(struct dentry *dentry)
 
 	if (rc)
 		return rc;
-	return security_ops->inode_killpriv(dentry);
+	return call_int_hook(inode_killpriv, dentry);
 }
 
 int security_inode_getsecurity(const struct inode *inode, const char *name,
 			       void **buffer, bool alloc,
-			       struct security_operations **sop)
+			       struct security_operations **secops)
 {
+	struct security_operations *sop;
+	int ret;
+
 	if (unlikely(IS_PRIVATE(inode)))
 		return -EOPNOTSUPP;
-	return security_ops->inode_getsecurity(inode, name, buffer, alloc);
+	/*
+	 * Only one LSM will supply a given "name".
+	 * -EOPNOTSUPP is an indication that the LSM does not
+	 * provide a value for the provided name.
+	 */
+	for_each_hook(sop, inode_getsecurity) {
+		ret = sop->inode_getsecurity(inode, name, buffer, alloc);
+		if (ret != -EOPNOTSUPP) {
+			*secops = sop;
+			return ret;
+		}
+	}
+	return -EOPNOTSUPP;
 }
 
-int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags)
+int security_inode_setsecurity(struct inode *inode, const char *name,
+			       const void *value, size_t size, int flags)
 {
+	struct security_operations *sop;
+	int ret;
+
 	if (unlikely(IS_PRIVATE(inode)))
 		return -EOPNOTSUPP;
-	return security_ops->inode_setsecurity(inode, name, value, size, flags);
+	/*
+	 * Only one LSM will set a given "name".
+	 * -EOPNOTSUPP is an indication that the LSM does not
+	 * set a value for the provided name.
+	 */
+	for_each_hook(sop, inode_setsecurity) {
+		ret = sop->inode_setsecurity(inode, name, value, size, flags);
+		if (ret != -EOPNOTSUPP)
+			return ret;
+	}
+	return -EOPNOTSUPP;
 }
 
 int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size)
 {
+	struct security_operations *sop;
+	int ret = 0;
+	int thisrc;
+
 	if (unlikely(IS_PRIVATE(inode)))
 		return 0;
-	return security_ops->inode_listsecurity(inode, buffer, buffer_size);
+	/*
+	 * inode_listsecurity hooks never return negative values.
+	 */
+	for_each_hook(sop, inode_listsecurity) {
+		thisrc = sop->inode_listsecurity(inode, buffer, buffer_size);
+		if (buffer != NULL)
+			buffer += thisrc;
+		buffer_size -= thisrc;
+		ret += thisrc;
+	}
+	return ret;
 }
 
 void security_inode_getsecid(const struct inode *inode, struct secids *secid)
 {
+	struct security_operations *sop;
 	u32 sid;
 
-	security_ops->inode_getsecid(inode, &sid);
-	lsm_init_secid(secid, sid, -1);
+	lsm_set_secid(secid, 0, -1);
+	for_each_hook(sop, inode_getsecid) {
+		sop->inode_getsecid(inode, &sid);
+		lsm_set_secid(secid, sid, sop->order);
+	}
 }
 
 int security_file_permission(struct file *file, int mask)
 {
 	int ret;
 
-	ret = security_ops->file_permission(file, mask);
+	ret = call_int_hook(file_permission, file, mask);
 	if (ret)
 		return ret;
 
@@ -763,17 +1394,20 @@ int security_file_permission(struct file *file, int mask)
 
 int security_file_alloc(struct file *file)
 {
-	return security_ops->file_alloc_security(file);
+	return call_alloc_hook(file_alloc_security, file_free_security,
+		file->f_security, GFP_KERNEL, file);
 }
 
 void security_file_free(struct file *file)
 {
-	security_ops->file_free_security(file);
+	call_void_hook(file_free_security, file);
+	kfree(file->f_security);
+	file->f_security = NULL;
 }
 
 int security_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	return security_ops->file_ioctl(file, cmd, arg);
+	return call_int_hook(file_ioctl, file, cmd, arg);
 }
 
 static inline unsigned long mmap_prot(struct file *file, unsigned long prot)
@@ -814,7 +1448,7 @@ int security_mmap_file(struct file *file, unsigned long prot,
 			unsigned long flags)
 {
 	int ret;
-	ret = security_ops->mmap_file(file, prot,
+	ret = call_int_hook(mmap_file, file, prot,
 					mmap_prot(file, prot), flags);
 	if (ret)
 		return ret;
@@ -823,50 +1457,46 @@ int security_mmap_file(struct file *file, unsigned long prot,
 
 int security_mmap_addr(unsigned long addr)
 {
-	int rc = security_ops->mmap_addr(addr);
-
-	if (rc)
-		return rc;
-	return cap_mmap_addr(addr);
+	return call_int_hook(mmap_addr, addr);
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
 	int ret;
 
-	ret = security_ops->file_open(file, cred);
+	ret = call_int_hook(file_open, file, cred);
 	if (ret)
 		return ret;
 
@@ -875,57 +1505,124 @@ int security_file_open(struct file *file, const struct cred *cred)
 
 int security_task_create(unsigned long clone_flags)
 {
-	return security_ops->task_create(clone_flags);
+	return call_int_hook(task_create, clone_flags);
 }
 
 void security_task_free(struct task_struct *task)
 {
-#ifdef CONFIG_SECURITY_YAMA_STACKED
-	yama_task_free(task);
-#endif
-	security_ops->task_free(task);
+	call_void_hook(task_free, task);
 }
 
 int security_cred_alloc_blank(struct cred *cred, gfp_t gfp)
 {
-	return security_ops->cred_alloc_blank(cred, gfp);
+	struct security_operations *sop;
+	struct security_operations *note[LSM_SLOTS];
+	struct lsm_blob tblob;
+	struct lsm_blob *bp = NULL;
+	int ret = 0;
+	int successes = 0;
+
+	memset(&tblob, 0, sizeof(tblob));
+	cred->security = &tblob;
+
+	for_each_hook(sop, cred_alloc_blank) {
+		ret = sop->cred_alloc_blank(cred, gfp);
+		if (ret)
+			break;
+		note[successes++] = sop;
+	}
+
+	if (tblob.lsm_setcount != 0) {
+		if (ret == 0)
+			bp = kmemdup(&tblob, sizeof(tblob), gfp);
+		if (bp == NULL) {
+			if (ret == 0)
+				ret = -ENOMEM;
+			while (successes > 0)
+				note[--successes]->cred_free(cred);
+		}
+	}
+	cred->security = bp;
+	return ret;
 }
 
 void security_cred_free(struct cred *cred)
 {
-	security_ops->cred_free(cred);
+	call_void_hook(cred_free, cred);
+	kfree(cred->security);
+	cred->security = NULL;
 }
 
 int security_prepare_creds(struct cred *new, const struct cred *old, gfp_t gfp)
 {
-	return security_ops->cred_prepare(new, old, gfp);
+	struct security_operations *sop;
+	struct security_operations *note[LSM_SLOTS];
+	struct lsm_blob tblob;
+	struct lsm_blob *bp = NULL;
+	int ret = 0;
+	int successes = 0;
+
+	/*
+	 * new->security will be NULL on entry.
+	 */
+	memset(&tblob, 0, sizeof(tblob));
+	new->security = &tblob;
+
+	for_each_hook(sop, cred_prepare) {
+		ret = sop->cred_prepare(new, old, gfp);
+		if (ret)
+			break;
+		note[successes++] = sop;
+	}
+
+	if (tblob.lsm_setcount != 0) {
+		if (ret == 0)
+			bp = kmemdup(&tblob, sizeof(tblob), gfp);
+		if (bp == NULL) {
+			if (ret == 0)
+			ret = -ENOMEM;
+			while (successes > 0)
+				note[--successes]->cred_free(new);
+		}
+	}
+	new->security = bp;
+	return ret;
 }
 
 void security_transfer_creds(struct cred *new, const struct cred *old)
 {
-	security_ops->cred_transfer(new, old);
+	call_void_hook(cred_transfer, new, old);
 }
 
 int security_kernel_act_as(struct cred *new, struct secids *secid)
 {
-	return security_ops->kernel_act_as(new, lsm_get_secid(secid, 0));
+	struct security_operations *sop;
+	int thisrc;
+	int ret = 0;
+
+	for_each_hook(sop, kernel_act_as) {
+		thisrc = sop->kernel_act_as(new, secid->si_lsm[sop->order]);
+		if (thisrc)
+			ret = thisrc;
+	}
+	return ret;
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
 	int ret;
 
-	ret = security_ops->kernel_module_from_file(file);
+	ret = call_int_hook(kernel_module_from_file, file);
 	if (ret)
 		return ret;
 	return ima_module_check(file);
@@ -938,40 +1635,45 @@ int security_task_fix_setuid(struct cred *new, const struct cred *old,
 
 	if (rc)
 		return rc;
-	return security_ops->task_fix_setuid(new, old, flags);
+	return call_int_hook(task_fix_setuid, new, old, flags);
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
+	struct security_operations *sop;
 	u32 sid;
 
-	security_ops->task_getsecid(p, &sid);
-	lsm_init_secid(secid, sid, -1);
+	lsm_init_secid(secid, 0, -1);
+
+	for_each_hook(sop, task_getsecid) {
+		sop->task_getsecid(p, &sid);
+		lsm_set_secid(secid, sid, sop->order);
+	}
 }
 EXPORT_SYMBOL(security_task_getsecid);
 
 int security_task_setnice(struct task_struct *p, int nice)
 {
-	int rc = cap_task_setnice(p, nice);
+	int ret = cap_task_setnice(p, nice);
 
-	if (rc)
-		return rc;
-	return security_ops->task_setnice(p, nice);
+	if (ret)
+		return ret;
+	return call_int_hook(task_setnice, p, nice);
 }
 
 int security_task_setioprio(struct task_struct *p, int ioprio)
@@ -980,178 +1682,224 @@ int security_task_setioprio(struct task_struct *p, int ioprio)
 
 	if (rc)
 		return rc;
-	return security_ops->task_setioprio(p, ioprio);
+	return call_int_hook(task_setioprio, p, ioprio);
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
-	int rc = cap_task_setscheduler(p);
+	int ret = cap_task_setscheduler(p);
 
-	if (rc)
-		return rc;
-	return security_ops->task_setscheduler(p);
+	if (ret)
+		return ret;
+	return call_int_hook(task_setscheduler, p);
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
 			int sig, struct secids *secid)
 {
-	return security_ops->task_kill(p, info, sig, lsm_get_secid(secid, 0));
+	struct security_operations *sop;
+	int thisrc;
+	int ret = 0;
+
+	for_each_hook(sop, kernel_act_as) {
+		thisrc = sop->task_kill(p, info, sig,
+					lsm_get_secid(secid, sop->order));
+		if (thisrc)
+			ret = thisrc;
+	}
+	return ret;
 }
 
 int security_task_wait(struct task_struct *p)
 {
-	return security_ops->task_wait(p);
+	return call_int_hook(task_wait, p);
 }
 
 int security_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			 unsigned long arg4, unsigned long arg5)
 {
-#ifdef CONFIG_SECURITY_YAMA_STACKED
-	int rc;
-	rc = yama_task_prctl(option, arg2, arg3, arg4, arg5);
-	if (rc != -ENOSYS)
-		return rc;
-#endif
-	return security_ops->task_prctl(option, arg2, arg3, arg4, arg5);
+	struct security_operations *sop;
+	int ret;
+
+	ret = cap_task_prctl(option, arg2, arg3, arg4, arg5);
+	if (ret != -ENOSYS)
+		return ret;
+	for_each_hook(sop, task_prctl) {
+		ret = sop->task_prctl(option, arg2, arg3, arg4, arg5);
+		/*
+		 * -ENOSYS returned if the lsm doesn't handle that control.
+		 * If the LSM does handle the control return the result.
+		 * The assumption for the time being is that no two LSMs
+		 * will handle a control.
+		 */
+		if (ret != -ENOSYS)
+			return ret;
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
+	struct security_operations *sop;
 	u32 sid;
 
-	security_ops->ipc_getsecid(ipcp, &sid);
-	lsm_init_secid(secid, sid, -1);
+	lsm_init_secid(secid, 0, -1);
+
+	for_each_hook(sop, ipc_getsecid) {
+		sop->ipc_getsecid(ipcp, &sid);
+		lsm_set_secid(secid, sid, sop->order);
+	}
 }
 
 int security_msg_msg_alloc(struct msg_msg *msg)
 {
-	return security_ops->msg_msg_alloc_security(msg);
+	return call_alloc_hook(msg_msg_alloc_security, msg_msg_free_security,
+				msg->security, GFP_KERNEL, msg);
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
+				kp->security, GFP_KERNEL, shp);
 }
 
 void security_shm_free(struct shmid_kernel *shp)
 {
-	security_ops->shm_free_security(shp);
+	call_void_hook(shm_free_security, shp);
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
+				kp->security, GFP_KERNEL, sma);
 }
 
 void security_sem_free(struct sem_array *sma)
 {
-	security_ops->sem_free_security(sma);
+	call_void_hook(sem_free_security, sma);
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
+	call_void_hook(d_instantiate, dentry, inode);
 }
 EXPORT_SYMBOL(security_d_instantiate);
 
@@ -1161,7 +1909,7 @@ int security_getprocattr(struct task_struct *p, char *name, char **value)
 	struct secids secid;
 	char *lsm;
 	int lsmlen;
-	int rc;
+	int ret;
 
 	/*
 	 * Names will either be in the legacy form containing
@@ -1174,30 +1922,32 @@ int security_getprocattr(struct task_struct *p, char *name, char **value)
 	 */
 	if (strcmp(name, "context") == 0) {
 		security_task_getsecid(p, &secid);
-		rc = security_secid_to_secctx(&secid, &lsm, &lsmlen, &sop);
-		if (rc == 0) {
+		ret = security_secid_to_secctx(&secid, &lsm, &lsmlen, &sop);
+		if (ret == 0) {
 			*value = kstrdup(lsm, GFP_KERNEL);
 			if (*value == NULL)
-				rc = -ENOMEM;
+				ret = -ENOMEM;
 			else
-				rc = strlen(*value);
+				ret = strlen(*value);
 			security_release_secctx(lsm, lsmlen, sop);
 		}
-		return rc;
+		return ret;
 	}
 
 	if (present_ops && !strchr(name, '.'))
 		return present_getprocattr(p, name, value);
 
-	sop = security_ops;
-	lsm = sop->name;
-	lsmlen = strlen(lsm);
-	if (!strncmp(name, lsm, lsmlen) && name[lsmlen] == '.')
-		return sop->getprocattr(p, name + lsmlen + 1, value);
+	for_each_hook(sop, getprocattr) {
+		lsm = sop->name;
+		lsmlen = strlen(lsm);
+		if (!strncmp(name, lsm, lsmlen) && name[lsmlen] == '.')
+			return sop->getprocattr(p, name + lsmlen + 1, value);
+	}
 	return -EINVAL;
 }
 
-int security_setprocattr(struct task_struct *p, char *name, void *value, size_t size)
+int security_setprocattr(struct task_struct *p, char *name, void *value,
+			 size_t size)
 {
 	struct security_operations *sop;
 	char *lsm;
@@ -1215,11 +1965,13 @@ int security_setprocattr(struct task_struct *p, char *name, void *value, size_t
 	if (present_ops && !strchr(name, '.'))
 		return present_setprocattr(p, name, value, size);
 
-	sop = present_ops;
-	lsm = sop->name;
-	lsmlen = strlen(lsm);
-	if (!strncmp(name, lsm, lsmlen) && name[lsmlen] == '.')
-		return sop->setprocattr(p, name + lsmlen + 1, value, size);
+	for_each_hook(sop, setprocattr) {
+		lsm = sop->name;
+		lsmlen = strlen(lsm);
+		if (!strncmp(name, lsm, lsmlen) && name[lsmlen] == '.')
+			return sop->setprocattr(p, name + lsmlen + 1, value,
+						size);
+	}
 	return -EINVAL;
 }
 
@@ -1229,305 +1981,694 @@ int security_netlink_send(struct sock *sk, struct sk_buff *skb)
 
 	if (rc)
 		return rc;
-	return security_ops->netlink_send(sk, skb);
+	return call_int_hook(netlink_send, sk, skb);
 }
 
 int security_secid_to_secctx(struct secids *secid, char **secdata, u32 *seclen,
-			     struct security_operations **sop)
+			     struct security_operations **secops)
 {
-	return security_ops->secid_to_secctx(lsm_get_secid(secid, 0),
-						secdata, seclen);
+	struct security_operations *sop;
+	struct security_operations *gotthis = NULL;
+	char *data;
+	char *cp;
+	char *thisdata[LSM_SLOTS];
+	u32 thislen[LSM_SLOTS];
+	int thisrc[LSM_SLOTS];
+	int gotmany = 0;
+	int ord;
+	u32 lenmany = 2;
+	int ret = 0;
+
+#ifdef CONFIG_SECURITY_PLAIN_CONTEXT
+	if (secid_ops) {
+		ret = secid_ops->secid_to_secctx(
+			secid->si_lsm[secid_ops->order], secdata, seclen);
+		*secops = secid_ops;
+		return ret;
+	}
+#endif
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
+			ret = thisrc[ord];
+	}
+	if (gotthis == NULL) {
+		if (ret == 0)
+			return -EOPNOTSUPP;
+		return ret;
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
+		ret = 0;
+	} else
+		ret = -ENOMEM;
+
+	for_each_hook(sop, secid_to_secctx) {
+		ord = sop->order;
+		sop->release_secctx(thisdata[ord], thislen[ord]);
+	}
+
+	return ret;
 }
 EXPORT_SYMBOL(security_secid_to_secctx);
 
+static int lsm_specific_ctx(const char *secdata, char *lsm, char *ctx)
+{
+	char fmt[SECURITY_NAME_MAX + 10];
+	char *cp;
+
+	sprintf(fmt, "%s='", lsm);
+	cp = strstr(secdata, fmt);
+	if (cp == NULL)
+		return 0;
+
+	sprintf(fmt, "%s='%%[^']'", lsm);
+	return sscanf(cp, fmt, ctx);
+}
+
 int security_secctx_to_secid(const char *secdata, u32 seclen,
 			     struct secids *secid,
-			     struct security_operations *sop)
+			     struct security_operations *secops)
 {
+	struct security_operations *sop;
+	char *cp;
+	char *thisdata;
+	int thisrc;
+	int gotten = 0;
+	int ret = 0;
 	u32 sid;
-	int rc;
 
-	rc = security_ops->secctx_to_secid(secdata, seclen, &sid);
-	lsm_init_secid(secid, sid, -1);
-	return rc;
+	lsm_init_secid(secid, 0, -1);
+
+	if (secops) {
+		ret = secops->secctx_to_secid(secdata, seclen, &sid);
+		lsm_set_secid(secid, sid, secops->order);
+		return ret;
+	}
+#ifdef CONFIG_SECURITY_PLAIN_CONTEXT
+	if (secid_ops) {
+		ret = secid_ops->secctx_to_secid(secdata, seclen, &sid);
+		lsm_set_secid(secid, sid, secid_ops->order);
+		return ret;
+	}
+#endif
+
+	cp = strnstr(secdata, "='", seclen);
+	if (cp == NULL) {
+		for_each_hook(sop, secctx_to_secid) {
+			thisrc = sop->secctx_to_secid(secdata, seclen, &sid);
+			lsm_set_secid(secid, sid, sop->order);
+			if (thisrc)
+				ret = thisrc;
+			gotten = 1;
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
+			thisrc = sop->secctx_to_secid(thisdata, seclen, &sid);
+			lsm_set_secid(secid, sid, sop->order);
+			if (thisrc)
+				ret = thisrc;
+			gotten = 1;
+		}
+		kfree(thisdata);
+	}
+	if (gotten)
+		return 0;
+	return ret;
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
+	int ret = 0;
+
+	if (ctx != NULL)
+		thisdata = strnstr(ctx, "='", ctxlen);
+	if (thisdata == NULL) {
+		for_each_hook(sop, inode_notifysecctx) {
+			thisrc = sop->inode_notifysecctx(inode, ctx, ctxlen);
+			if (thisrc)
+				ret = thisrc;
+		}
+		return ret;
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
+			ret = thisrc;
+	}
+	kfree(thisdata);
+	return ret;
 }
 EXPORT_SYMBOL(security_inode_notifysecctx);
 
 int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen)
 {
-	return security_ops->inode_setsecctx(dentry, ctx, ctxlen);
+	struct security_operations *sop;
+	char *thisdata = NULL;
+	int thisrc;
+	int ret = 0;
+
+	if (ctx != NULL)
+		thisdata = strnstr(ctx, "='", ctxlen);
+	if (thisdata == NULL) {
+		for_each_hook(sop, inode_setsecctx) {
+			thisrc = sop->inode_setsecctx(dentry, ctx, ctxlen);
+			if (thisrc)
+				ret = thisrc;
+		}
+		return ret;
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
+			ret = thisrc;
+	}
+	kfree(thisdata);
+	return ret;
 }
 EXPORT_SYMBOL(security_inode_setsecctx);
 
 int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen,
-			     struct security_operations **sop)
+				struct security_operations **secops)
 {
-	return security_ops->inode_getsecctx(inode, ctx, ctxlen);
+	struct security_operations *sop;
+	struct security_operations *gotthis = NULL;
+	void *data;
+	char *cp;
+	void *thisdata[LSM_SLOTS];
+	u32 thislen[LSM_SLOTS];
+	int thisrc[LSM_SLOTS];
+	int gotmany = 0;
+	int ord;
+	u32 len = 2;
+	int ret = 0;
+
+#ifdef CONFIG_SECURITY_PLAIN_CONTEXT
+	if (secid_ops) {
+		ret = secid_ops->inode_getsecctx(inode, ctx, ctxlen);
+		*secops = secid_ops;
+		return ret;
+	}
+#endif
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
+			ret = thisrc[ord];
+	}
+	if (gotthis == NULL) {
+		if (ret == 0)
+			return -EOPNOTSUPP;
+		return ret;
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
+		ret = 0;
+	} else
+		ret = -ENOMEM;
+
+	for_each_hook(sop, inode_getsecctx) {
+		ord = sop->order;
+		sop->release_secctx(thisdata[ord], thislen[ord]);
+	}
+
+	return ret;
 }
 EXPORT_SYMBOL(security_inode_getsecctx);
 
 #ifdef CONFIG_SECURITY_NETWORK
 
-int security_unix_stream_connect(struct sock *sock, struct sock *other, struct sock *newsk)
+int security_unix_stream_connect(struct sock *sock, struct sock *other,
+				 struct sock *newsk)
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
-						protocol, kern);
+	return call_int_hook(socket_post_create, sock, family, type,
+					protocol, kern);
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
+	char *result;
+	char *tp;
+	char *thisval;
+	int thislen;
+	int thisrc;
+	int ret = -ENOPROTOOPT;
+
+	thisval = kzalloc(len * 2, GFP_KERNEL);
+	if (thisval == NULL)
+		return -ENOMEM;
+	result = thisval;
+	tp = result + len;
+
+#ifdef CONFIG_SECURITY_PLAIN_CONTEXT
+	if (secid_ops) {
+		ret = secid_ops->socket_getpeersec_stream(sock, result,
+							&thislen, len);
+		goto sendout;
+	}
+#endif
+
+	for_each_hook(sop, socket_getpeersec_stream) {
+		thisrc = sop->socket_getpeersec_stream(sock, tp, &thislen, len);
+		if (thisrc == 0) {
+			thislen += strlen(sop->name) + 3;
+			if (thislen >= len) {
+				ret = -ERANGE;
+				break;
+			}
+			thisval += sprintf(thisval, "%s='%s'", sop->name, tp);
+			len -= thislen;
+			ret = 0;
+		} else if (thisrc != -ENOPROTOOPT)
+			ret = thisrc;
+	}
+#ifdef CONFIG_SECURITY_PLAIN_CONTEXT
+sendout:
+#endif
+	if (ret == 0) {
+		len = strlen(result) + 1;
+		if (put_user(len, optlen))
+			ret = -EFAULT;
+		else if (copy_to_user(optval, result, len))
+			ret = -EFAULT;
+	}
+	kfree(result);
+	return ret;
 }
 
 int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb,
-					struct secids *secid)
+				     struct secids *secid)
 {
+	struct security_operations *sop;
+	int thisrc;
+	int ret = -ENOPROTOOPT;
 	u32 sid;
-	int rc;
 
-	rc = security_ops->socket_getpeersec_dgram(sock, skb, &sid);
-	lsm_init_secid(secid, sid, -1);
-	return rc;
+	lsm_init_secid(secid, 0, -1);
+
+	for_each_hook(sop, socket_getpeersec_dgram) {
+		thisrc = sop->socket_getpeersec_dgram(sock, skb, &sid);
+		lsm_set_secid(secid, sid, sop->order);
+		if (!thisrc)
+			ret = 0;
+		else if (thisrc != -ENOPROTOOPT)
+			ret = thisrc;
+	}
+	return ret;
 }
 EXPORT_SYMBOL(security_socket_getpeersec_dgram);
 
 int security_sk_alloc(struct sock *sk, int family, gfp_t priority)
 {
-	return security_ops->sk_alloc_security(sk, family, priority);
+	struct security_operations *sop;
+	struct security_operations *note[LSM_SLOTS];
+	struct lsm_blob tblob;
+	struct lsm_blob *bp = NULL;
+	int ret = 0;
+	int successes = 0;
+
+	memset(&tblob, 0, sizeof(tblob));
+	sk->sk_security = &tblob;
+
+	for_each_hook(sop, sk_alloc_security) {
+		ret = sop->sk_alloc_security(sk, family, priority);
+		if (ret)
+			break;
+		note[successes++] = sop;
+	}
+
+	if (tblob.lsm_setcount != 0) {
+		if (ret == 0)
+			bp = kmemdup(&tblob, sizeof(tblob), priority);
+		if (bp == NULL) {
+			if (ret == 0)
+				ret = -ENOMEM;
+			while (successes > 0)
+				note[--successes]->sk_free_security(sk);
+		}
+	}
+	sk->sk_security = bp;
+	return ret;
 }
 
 void security_sk_free(struct sock *sk)
 {
-	security_ops->sk_free_security(sk);
+	call_void_hook(sk_free_security, sk);
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
 
-void security_req_classify_flow(const struct request_sock *req, struct flowi *fl)
+void security_req_classify_flow(const struct request_sock *req,
+				struct flowi *fl)
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
 
-int security_inet_conn_request(struct sock *sk,
-			struct sk_buff *skb, struct request_sock *req)
+int security_inet_conn_request(struct sock *sk, struct sk_buff *skb,
+			       struct request_sock *req)
 {
-	return security_ops->inet_conn_request(sk, skb, req);
+	return call_int_hook(inet_conn_request, sk, skb, req);
 }
 EXPORT_SYMBOL(security_inet_conn_request);
 
 void security_inet_csk_clone(struct sock *newsk,
-			const struct request_sock *req)
+			     const struct request_sock *req)
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
 
 int security_secmark_relabel_packet(struct secids *secid)
 {
-	return security_ops->secmark_relabel_packet(lsm_get_secid(secid,
-							lsm_secmark_order()));
+	u32 sid = lsm_get_secid(secid, lsm_secmark_order());
+
+	if (secmark_ops)
+		return secmark_ops->secmark_relabel_packet(sid);
+	return 0;
 }
 EXPORT_SYMBOL(security_secmark_relabel_packet);
 
 void security_secmark_refcount_inc(void)
 {
-	security_ops->secmark_refcount_inc();
+	if (secmark_ops)
+		secmark_ops->secmark_refcount_inc();
 }
 EXPORT_SYMBOL(security_secmark_refcount_inc);
 
 void security_secmark_refcount_dec(void)
 {
-	security_ops->secmark_refcount_dec();
+	if (secmark_ops)
+		secmark_ops->secmark_refcount_dec();
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
-
-int security_xfrm_policy_alloc(struct xfrm_sec_ctx **ctxp, struct xfrm_user_sec_ctx *sec_ctx)
-{
-	return security_ops->xfrm_policy_alloc_security(ctxp, sec_ctx);
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
+		if (!xfrm_ops)				\
+			break;				\
+		if (!xfrm_ops->FUNC)			\
+			break;				\
+		rc = xfrm_ops->FUNC(__VA_ARGS__);	\
+	} while (0);					\
+	rc;						\
+})
+
+int security_xfrm_policy_alloc(struct xfrm_sec_ctx **ctxp,
+			       struct xfrm_user_sec_ctx *sec_ctx)
+{
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
+	if (xfrm_ops && xfrm_ops->xfrm_policy_free_security)
+		xfrm_ops->xfrm_policy_free_security(ctx);
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
 
@@ -1540,41 +2681,47 @@ int security_xfrm_state_alloc_acquire(struct xfrm_state *x,
 	 * We want the context to be taken from secid which is usually
 	 * from the sock.
 	 */
-	return security_ops->xfrm_state_alloc_security(x, NULL, secid);
+	if (xfrm_ops && xfrm_ops->xfrm_state_alloc_security)
+		return xfrm_ops->xfrm_state_alloc_security(x, NULL, secid);
+	return 0;
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
+	if (xfrm_ops && xfrm_ops->xfrm_state_free_security)
+		xfrm_ops->xfrm_state_free_security(x);
 }
 
 int security_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx,
 				u32 fl_secid, u8 dir)
 {
-	return security_ops->xfrm_policy_lookup(ctx, fl_secid, dir);
+	return call_xfrm_int_hook(xfrm_policy_lookup, ctx, fl_secid, dir);
 }
 
 int security_xfrm_state_pol_flow_match(struct xfrm_state *x,
 				       struct xfrm_policy *xp,
 				       const struct flowi *fl)
 {
-	return security_ops->xfrm_state_pol_flow_match(x, xp, fl);
+	if (xfrm_ops && xfrm_ops->xfrm_state_pol_flow_match)
+		return xfrm_ops->xfrm_state_pol_flow_match(x, xp, fl);
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
+	int rc = call_xfrm_int_hook(xfrm_decode_session, skb,
+					&fl->flowi_secid, 0);
 
 	BUG_ON(rc);
 }
@@ -1587,23 +2734,59 @@ EXPORT_SYMBOL(security_skb_classify_flow);
 int security_key_alloc(struct key *key, const struct cred *cred,
 		       unsigned long flags)
 {
-	return security_ops->key_alloc(key, cred, flags);
+	struct security_operations *sop;
+	struct security_operations *note[LSM_SLOTS];
+	struct lsm_blob tblob;
+	struct lsm_blob *bp = NULL;
+	int ret = 0;
+	int successes = 0;
+
+	memset(&tblob, 0, sizeof(tblob));
+	key->security = &tblob;
+
+	for_each_hook(sop, key_alloc) {
+		ret = sop->key_alloc(key, cred, flags);
+		if (ret)
+			break;
+		note[successes++] = sop;
+	}
+
+	if (tblob.lsm_setcount != 0) {
+		if (ret == 0)
+			bp = kmemdup(&tblob, sizeof(tblob), GFP_KERNEL);
+		if (bp == NULL) {
+			if (ret == 0)
+				ret = -ENOMEM;
+			while (successes > 0)
+			note[--successes]->key_free(key);
+		}
+	}
+
+	key->security = bp;
+	return ret;
 }
 
 void security_key_free(struct key *key)
 {
-	security_ops->key_free(key);
+	call_void_hook(key_free, key);
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
+	int ret;
+
+	if (call_int_must(ret, key_getsecurity, key, _buffer))
+		return ret;
+	*_buffer = NULL;
+	return 0;
 }
 
 #endif	/* CONFIG_KEYS */
@@ -1612,24 +2795,86 @@ int security_key_getsecurity(struct key *key, char **_buffer)
 
 int security_audit_rule_init(u32 field, u32 op, char *rulestr, void **lsmrule)
 {
-	return security_ops->audit_rule_init(field, op, rulestr, lsmrule);
+	struct security_operations *sop;
+	struct lsm_blob tblob;
+	struct lsm_blob *bp = NULL;
+	int thisrc;
+	int ret = 0;
+
+	memset(&tblob, 0, sizeof(tblob));
+
+	for_each_hook(sop, audit_rule_init) {
+		thisrc = sop->audit_rule_init(field, op, rulestr,
+					&tblob.lsm_blobs[sop->order]);
+		if (thisrc == 0)
+			tblob.lsm_setcount++;
+		else if (thisrc == -EINVAL) {
+			tblob.lsm_setcount++;
+			pr_warn("audit rule \"%s\" is invalid for %s.\n",
+					rulestr, sop->name);
+		} else
+			ret = thisrc;
+	}
+
+	if (tblob.lsm_setcount != 0) {
+		bp = kmemdup(&tblob, sizeof(tblob), GFP_KERNEL);
+		if (bp == NULL) {
+			ret = -ENOMEM;
+			for_each_hook(sop, audit_rule_free)
+				sop->audit_rule_free(
+					tblob.lsm_blobs[sop->order]);
+		}
+	}
+
+	*lsmrule = bp;
+	return ret;
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
 
 int security_audit_rule_match(struct secids *secid, u32 field, u32 op,
 			      void *lsmrule, struct audit_context *actx)
 {
-	return security_ops->audit_rule_match(lsm_get_secid(secid, 0), field,
-						op, lsmrule, actx);
+	struct security_operations *sop;
+	struct lsm_blob *bp = lsmrule;
+	int order;
+	int ret;
+
+	if (lsmrule == NULL)
+		return 0;
+
+	for_each_hook(sop, audit_rule_match) {
+		order = sop->order;
+		if (bp->lsm_blobs[order] != NULL) {
+			ret = sop->audit_rule_match(secid->si_lsm[order], field,
+						op, bp->lsm_blobs[order], actx);
+			if (ret)
+				return ret;
+		}
+	}
+	return 0;
 }
 
 #endif /* CONFIG_AUDIT */
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 71f14bf..a5d73f1 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -154,13 +154,16 @@ static void cred_init_security(void)
 {
 	struct cred *cred = (struct cred *) current->real_cred;
 	struct task_security_struct *tsec;
+	int rc;
 
 	tsec = kzalloc(sizeof(struct task_security_struct), GFP_KERNEL);
 	if (!tsec)
 		panic("SELinux:  Failed to initialize initial task.\n");
 
 	tsec->osid = tsec->sid = SECINITSID_KERNEL;
-	lsm_set_cred(cred, tsec, &selinux_ops);
+	rc = lsm_set_init_cred(cred, tsec, &selinux_ops);
+	if (rc)
+		panic("SELinux:  Failed to initialize initial task.\n");
 }
 
 /*
@@ -1865,7 +1868,13 @@ static int selinux_ptrace_traceme(struct task_struct *parent)
 static int selinux_capget(struct task_struct *target, kernel_cap_t *effective,
 			  kernel_cap_t *inheritable, kernel_cap_t *permitted)
 {
-	return current_has_perm(target, PROCESS__GETCAP);
+	int error;
+
+	error = current_has_perm(target, PROCESS__GETCAP);
+	if (error)
+		return error;
+
+	return cap_capget(target, effective, inheritable, permitted);
 }
 
 static int selinux_capset(struct cred *new, const struct cred *old,
@@ -2108,7 +2117,7 @@ static int selinux_bprm_secureexec(struct linux_binprm *bprm)
 					PROCESS__NOATSECURE, NULL);
 	}
 
-	return atsecure;
+	return (atsecure || cap_bprm_secureexec(bprm));
 }
 
 static int match_file(const void *p, struct file *file, unsigned fd)
@@ -3091,11 +3100,15 @@ static int selinux_mmap_addr(unsigned long addr)
 	 * at bad behaviour/exploit that we always want to get the AVC, even
 	 * if DAC would have also denied the operation.
 	 */
-	if (addr < CONFIG_LSM_MMAP_MIN_ADDR)
+	if (addr < CONFIG_LSM_MMAP_MIN_ADDR) {
 		rc = avc_has_perm(sid, sid, SECCLASS_MEMPROTECT,
 				  MEMPROTECT__MMAP_ZERO, NULL);
+		if (rc)
+			return rc;
+	}
 
-	return rc;
+	/* do DAC check on address space usage */
+	return cap_mmap_addr(addr);
 }
 
 static int selinux_mmap_file(struct file *file, unsigned long reqprot,
@@ -4199,8 +4212,8 @@ static int selinux_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	return err;
 }
 
-static int selinux_socket_getpeersec_stream(struct socket *sock, char __user *optval,
-					    int __user *optlen, unsigned len)
+static int selinux_socket_getpeersec_stream(struct socket *sock, char *optval,
+					    int *optlen, unsigned len)
 {
 	int err = 0;
 	char *scontext;
@@ -4223,12 +4236,10 @@ static int selinux_socket_getpeersec_stream(struct socket *sock, char __user *op
 		goto out_len;
 	}
 
-	if (copy_to_user(optval, scontext, scontext_len))
-		err = -EFAULT;
+	strcpy(optval, scontext);
 
 out_len:
-	if (put_user(scontext_len, optlen))
-		err = -EFAULT;
+	*optlen = scontext_len;
 	kfree(scontext);
 	return err;
 }
@@ -5514,7 +5525,8 @@ struct security_operations selinux_ops = {
 	.features =			LSM_FEATURE_PRESENT |
 					LSM_FEATURE_NETLABEL |
 					LSM_FEATURE_XFRM |
-					LSM_FEATURE_SECMARK,
+					LSM_FEATURE_SECMARK |
+					LSM_FEATURE_SECIDS,
 
 	.ptrace_access_check =		selinux_ptrace_access_check,
 	.ptrace_traceme =		selinux_ptrace_traceme,
@@ -5717,13 +5729,12 @@ struct security_operations selinux_ops = {
 
 static __init int selinux_init(void)
 {
-	if (!security_module_enable(&selinux_ops)) {
+
+	if (!security_module_enable(&selinux_ops))
 		selinux_enabled = 0;
-		return 0;
-	}
 
 	if (!selinux_enabled) {
-		printk(KERN_INFO "SELinux:  Disabled at boot.\n");
+		pr_info("SELinux:  Disabled at boot.\n");
 		return 0;
 	}
 
@@ -5735,13 +5746,10 @@ static __init int selinux_init(void)
 	default_noexec = !(VM_DATA_DEFAULT_FLAGS & VM_EXEC);
 
 	sel_inode_cache = kmem_cache_create("selinux_inode_security",
-					    sizeof(struct inode_security_struct),
-					    0, SLAB_PANIC, NULL);
+					   sizeof(struct inode_security_struct),
+					   0, SLAB_PANIC, NULL);
 	avc_init();
 
-	if (register_security(&selinux_ops))
-		panic("SELinux: Unable to register with kernel.\n");
-
 	if (selinux_enforcing)
 		printk(KERN_DEBUG "SELinux:  Starting in enforcing mode\n");
 	else
@@ -5875,13 +5883,12 @@ int selinux_disable(void)
 		return -EINVAL;
 	}
 
+	security_module_disable(&selinux_ops);
 	printk(KERN_INFO "SELinux:  Disabled at runtime.\n");
 
 	selinux_disabled = 1;
 	selinux_enabled = 0;
 
-	reset_security_ops();
-
 	/* Try to destroy the avc node cache */
 	avc_disable();
 
diff --git a/security/selinux/netlabel.c b/security/selinux/netlabel.c
index 43504ea..162d95f 100644
--- a/security/selinux/netlabel.c
+++ b/security/selinux/netlabel.c
@@ -109,7 +109,8 @@ static struct netlbl_lsm_secattr *selinux_netlbl_sock_genattr(struct sock *sk)
  */
 void selinux_netlbl_cache_invalidate(void)
 {
-	netlbl_cache_invalidate();
+	if (netlbl_lsm_owner(&selinux_ops))
+		netlbl_cache_invalidate();
 }
 
 /**
@@ -127,7 +128,8 @@ void selinux_netlbl_cache_invalidate(void)
  */
 void selinux_netlbl_err(struct sk_buff *skb, int error, int gateway)
 {
-	netlbl_skbuff_err(skb, error, gateway);
+	if (netlbl_lsm_owner(&selinux_ops))
+		netlbl_skbuff_err(skb, error, gateway);
 }
 
 /**
@@ -140,7 +142,7 @@ void selinux_netlbl_err(struct sk_buff *skb, int error, int gateway)
  */
 void selinux_netlbl_sk_security_free(struct sk_security_struct *sksec)
 {
-	if (sksec->nlbl_secattr != NULL)
+	if (netlbl_lsm_owner(&selinux_ops) && sksec->nlbl_secattr != NULL)
 		netlbl_secattr_free(sksec->nlbl_secattr);
 }
 
@@ -156,7 +158,8 @@ void selinux_netlbl_sk_security_free(struct sk_security_struct *sksec)
  */
 void selinux_netlbl_sk_security_reset(struct sk_security_struct *sksec)
 {
-	sksec->nlbl_state = NLBL_UNSET;
+	if (netlbl_lsm_owner(&selinux_ops))
+		sksec->nlbl_state = NLBL_UNSET;
 }
 
 /**
@@ -217,6 +220,9 @@ int selinux_netlbl_skbuff_setsid(struct sk_buff *skb,
 	struct netlbl_lsm_secattr *secattr = NULL;
 	struct sock *sk;
 
+	if (!netlbl_lsm_owner(&selinux_ops))
+		return 0;
+
 	/* if this is a locally generated packet check to see if it is already
 	 * being labeled by it's parent socket, if it is just exit */
 	sk = skb->sk;
@@ -259,6 +265,9 @@ int selinux_netlbl_inet_conn_request(struct request_sock *req, u16 family)
 	int rc;
 	struct netlbl_lsm_secattr secattr;
 
+	if (!netlbl_lsm_owner(&selinux_ops))
+		return 0;
+
 	if (family != PF_INET)
 		return 0;
 
@@ -286,6 +295,9 @@ void selinux_netlbl_inet_csk_clone(struct sock *sk, u16 family)
 {
 	struct sk_security_struct *sksec = lsm_get_sock(sk, &selinux_ops);
 
+	if (!netlbl_lsm_owner(&selinux_ops))
+		return;
+
 	if (family == PF_INET)
 		sksec->nlbl_state = NLBL_LABELED;
 	else
@@ -308,6 +320,9 @@ int selinux_netlbl_socket_post_create(struct sock *sk, u16 family)
 	struct sk_security_struct *sksec = lsm_get_sock(sk, &selinux_ops);
 	struct netlbl_lsm_secattr *secattr;
 
+	if (!netlbl_lsm_owner(&selinux_ops))
+		return 0;
+
 	if (family != PF_INET)
 		return 0;
 
@@ -406,6 +421,9 @@ int selinux_netlbl_socket_setsockopt(struct socket *sock,
 	struct sk_security_struct *sksec = lsm_get_sock(sk, &selinux_ops);
 	struct netlbl_lsm_secattr secattr;
 
+	if (!netlbl_lsm_owner(&selinux_ops))
+		return 0;
+
 	if (level == IPPROTO_IP && optname == IP_OPTIONS &&
 	    (sksec->nlbl_state == NLBL_LABELED ||
 	     sksec->nlbl_state == NLBL_CONNLABELED)) {
@@ -439,6 +457,9 @@ int selinux_netlbl_socket_connect(struct sock *sk, struct sockaddr *addr)
 	struct sk_security_struct *sksec = lsm_get_sock(sk, &selinux_ops);
 	struct netlbl_lsm_secattr *secattr;
 
+	if (!netlbl_lsm_owner(&selinux_ops))
+		return 0;
+
 	if (sksec->nlbl_state != NLBL_REQSKB &&
 	    sksec->nlbl_state != NLBL_CONNLABELED)
 		return 0;
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index c91d32c..22c0041 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -40,11 +40,20 @@
 #include <linux/binfmts.h>
 #include "smack.h"
 
-#define task_security(task)	(task_cred_xxx((task), security))
-
 #define TRANS_TRUE	"TRUE"
 #define TRANS_TRUE_SIZE	4
 
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
+
 /**
  * smk_fetch - Fetch the smack label from a file.
  * @ip: a pointer to the inode
@@ -492,10 +501,12 @@ static void smack_bprm_committing_creds(struct linux_binprm *bprm)
 static int smack_bprm_secureexec(struct linux_binprm *bprm)
 {
 	struct task_smack *tsp = lsm_get_cred(current_cred(), &smack_ops);
+	int ret = cap_bprm_secureexec(bprm);
 
-	if (tsp->smk_task != tsp->smk_forked)
-		return 1;
-	return 0;
+	if (!ret && (tsp->smk_task != tsp->smk_forked))
+		ret = 1;
+
+	return ret;
 }
 
 /*
@@ -2911,9 +2922,8 @@ static int smack_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
  *
  * returns zero on success, an error code otherwise
  */
-static int smack_socket_getpeersec_stream(struct socket *sock,
-					  char __user *optval,
-					  int __user *optlen, unsigned len)
+static int smack_socket_getpeersec_stream(struct socket *sock, char *optval,
+					  int *optlen, unsigned len)
 {
 	struct socket_smack *ssp;
 	char *rcp = "";
@@ -2928,11 +2938,9 @@ static int smack_socket_getpeersec_stream(struct socket *sock,
 
 	if (slen > len)
 		rc = -ERANGE;
-	else if (copy_to_user(optval, rcp, slen) != 0)
-		rc = -EFAULT;
-
-	if (put_user(slen, optlen) != 0)
-		rc = -EFAULT;
+	else
+		strcpy(optval, rcp);
+	*optlen = slen;
 
 	return rc;
 }
@@ -3377,7 +3385,8 @@ static int smack_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen)
 struct security_operations smack_ops = {
 	.name =				"smack",
 	.features =			LSM_FEATURE_PRESENT |
-					LSM_FEATURE_NETLABEL,
+					LSM_FEATURE_NETLABEL |
+					LSM_FEATURE_SECIDS,
 
 	.ptrace_access_check =		smack_ptrace_access_check,
 	.ptrace_traceme =		smack_ptrace_traceme,
@@ -3555,6 +3564,7 @@ static __init void init_smack_known_list(void)
  */
 static __init int smack_init(void)
 {
+	int rc;
 	struct cred *cred;
 	struct task_smack *tsp;
 
@@ -3572,19 +3582,15 @@ static __init int smack_init(void)
 	 * Set the security state for the initial task.
 	 */
 	cred = (struct cred *) current->cred;
-	lsm_set_cred(cred, tsp, &smack_ops);
+	rc = lsm_set_init_cred(cred, tsp, &smack_ops);
+	if (rc != 0)
+		panic("smack: Unable to initialize credentials.\n");
 
 	/* initialize the smack_known_list */
 	init_smack_known_list();
 
 	smack_net_ambient = smack_known_floor.smk_known;
 
-	/*
-	 * Register with LSM
-	 */
-	if (register_security(&smack_ops))
-		panic("smack: Unable to register with kernel.\n");
-
 	return 0;
 }
 
diff --git a/security/tomoyo/tomoyo.c b/security/tomoyo/tomoyo.c
index 5b410b3..2525599 100644
--- a/security/tomoyo/tomoyo.c
+++ b/security/tomoyo/tomoyo.c
@@ -540,15 +540,16 @@ DEFINE_SRCU(tomoyo_ss);
  */
 static int __init tomoyo_init(void)
 {
+	int rc;
 	struct cred *cred = (struct cred *) current_cred();
 
+	/* register ourselves with the security framework */
 	if (!security_module_enable(&tomoyo_ops))
 		return 0;
-	/* register ourselves with the security framework */
-	if (register_security(&tomoyo_ops))
-		panic("Failure registering TOMOYO Linux");
 	printk(KERN_INFO "TOMOYO Linux initialized\n");
-	lsm_set_cred(cred, &tomoyo_kernel_domain, &tomoyo_ops);
+	rc = lsm_set_init_cred(cred, &tomoyo_kernel_domain, &tomoyo_ops);
+	if (rc)
+		panic("Failure allocating credential for TOMOYO Linux");
 	tomoyo_mm_init();
 	return 0;
 }
diff --git a/security/yama/Kconfig b/security/yama/Kconfig
index 20ef514..a99aa1d 100644
--- a/security/yama/Kconfig
+++ b/security/yama/Kconfig
@@ -12,10 +12,3 @@ config SECURITY_YAMA
 
 	  If you are unsure how to answer this question, answer N.
 
-config SECURITY_YAMA_STACKED
-	bool "Yama stacked with other LSMs"
-	depends on SECURITY_YAMA
-	default n
-	help
-	  When Yama is built into the kernel, force it to stack with the
-	  selected primary LSM.
diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
index cf57c7f..78d7f45 100644
--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -346,7 +346,6 @@ int yama_ptrace_traceme(struct task_struct *parent)
 	return rc;
 }
 
-#ifndef CONFIG_SECURITY_YAMA_STACKED
 static struct security_operations yama_ops = {
 	.name =			"yama",
 
@@ -355,7 +354,6 @@ static struct security_operations yama_ops = {
 	.task_prctl =		yama_task_prctl,
 	.task_free =		yama_task_free,
 };
-#endif
 
 #ifdef CONFIG_SYSCTL
 static int yama_dointvec_minmax(struct ctl_table *table, int write,
@@ -402,18 +400,11 @@ static struct ctl_table yama_sysctl_table[] = {
 
 static __init int yama_init(void)
 {
-#ifndef CONFIG_SECURITY_YAMA_STACKED
 	if (!security_module_enable(&yama_ops))
 		return 0;
-#endif
 
 	printk(KERN_INFO "Yama: becoming mindful.\n");
 
-#ifndef CONFIG_SECURITY_YAMA_STACKED
-	if (register_security(&yama_ops))
-		panic("Yama: kernel registration failed.\n");
-#endif
-
 #ifdef CONFIG_SYSCTL
 	if (!register_sysctl_paths(yama_sysctl_path, yama_sysctl_table))
 		panic("Yama: sysctl registration failed.\n");


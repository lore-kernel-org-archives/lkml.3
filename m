Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185Ab3DWQI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:08:26 -0400
Received: from nm8-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.118]:25284
	"EHLO nm8-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757139Ab3DWQEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:04:21 -0400
X-Yahoo-Newman-Id: 79860.36801.bm@smtp110.biz.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: DmFWKGoVM1n4qcCZVL4n0qLX7gTOaoWdsEZIDZnmH0EJhqR
 IK74feJUB39crGX7hSv.MCqv07KCo0jSRhfsD_OQGGgCosLuErNaUjYAhuMZ
 A5V878aXr.yZkqfGQZdftlLEioGSI6.uBEYFct1BYI_GVy3SVblJYVSLkzAH
 6f98pM7r4NDvLLJ2hasKSLOaCLLZGe8.p36kkRCN4gnCd5GoE5IKZ4uRn03K
 xoTGv4EN5PplP3MVp2ZoaoAzankp2RhY.V4S1wRDgwFU.hsNNjggXInw3bs0
 6ODh9eQDIFwxucJJfNggATyzo9Er1DKbevuphwjXG3SlfWROPnsfsQgCRAAJ
 gRnPHacLsjtiBw_NTWsYoYhfNoLdanMQ.hr4ueJpVnwASEjss5CIR6suSLZ1
 ul4Fj7Ia6gISC1ty2jKOtcxMlo95CygRd7aHDnKGzyhRsyRrMiznESCF376v
 6Mg--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with plain)
        by smtp110.biz.mail.ne1.yahoo.com with SMTP; 23 Apr 2013 09:04:19 -0700 PDT
Message-ID: <5176B105.8030200@schaufler-ca.com>
Date: Tue, 23 Apr 2013 09:04:21 -0700
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
Subject: [PATCH v13 3/9] LSM: Multiple concurrent secids
References: <5176ABB7.5080300@schaufler-ca.com>
In-Reply-To: <5176ABB7.5080300@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH v13 3/9] LSM: Multiple concurrent secids

Change the representation of a secid from a single u32
to a structure containing multiple instances of u32s.
This permits interfaces that require information about
the security context maintained by multiple LSMs (i.e.
audit) and hooks that provide that information to do so.

The networking interfaces that require a single secid
have been changed to hook into the mechanism.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---
 include/linux/audit.h                              |    9 ++-
 include/linux/cred.h                               |    3 +-
 include/linux/security.h                           |   44 +++++++-----
 include/net/af_unix.h                              |    3 +-
 include/net/scm.h                                  |    4 +-
 include/net/xfrm.h                                 |    5 +-
 kernel/audit.c                                     |   73 +++++++++++---------
 kernel/audit.h                                     |    4 +-
 kernel/auditfilter.c                               |   16 +++--
 kernel/auditsc.c                                   |   66 +++++++++---------
 kernel/cred.c                                      |    6 +-
 net/ipv4/ip_sockglue.c                             |    5 +-
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |   11 ++-
 net/netfilter/nf_conntrack_netlink.c               |   14 +++-
 net/netfilter/nf_conntrack_standalone.c            |    7 +-
 net/netfilter/xt_SECMARK.c                         |    7 +-
 net/netlabel/netlabel_unlabeled.c                  |   33 +++++----
 net/netlabel/netlabel_user.c                       |    7 +-
 net/netlabel/netlabel_user.h                       |    5 +-
 net/unix/af_unix.c                                 |   17 ++++-
 net/xfrm/xfrm_user.c                               |   32 +++++----
 security/capability.c                              |    2 +-
 security/integrity/ima/ima_policy.c                |    7 +-
 security/security.c                                |   41 ++++++-----
 24 files changed, 256 insertions(+), 165 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 5a6d718..0be1759e 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -43,6 +43,7 @@ struct mq_attr;
 struct mqstat;
 struct audit_watch;
 struct audit_tree;
+struct secids;
 
 struct audit_krule {
 	int			vers_ops;
@@ -423,9 +424,11 @@ extern void		    audit_log_link_denied(const char *operation,
 						  struct path *link);
 extern void		    audit_log_lost(const char *message);
 #ifdef CONFIG_SECURITY
-extern void 		    audit_log_secctx(struct audit_buffer *ab, u32 secid);
+extern void 		    audit_log_secctx(struct audit_buffer *ab,
+					     u32 secid);
 #else
-static inline void	    audit_log_secctx(struct audit_buffer *ab, u32 secid)
+static inline void	    audit_log_secctx(struct audit_buffer *ab,
+					     u32 secid)
 { }
 #endif
 
@@ -436,7 +439,7 @@ extern int audit_filter_user(void);
 extern int audit_filter_type(int type);
 extern int  audit_receive_filter(int type, int pid, int seq,
 				void *data, size_t datasz, kuid_t loginuid,
-				u32 sessionid, u32 sid);
+				u32 sessionid, struct secids *sid);
 extern int audit_enabled;
 #else /* CONFIG_AUDIT */
 static inline __printf(4, 5)
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 04421e8..459302a 100644
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
diff --git a/include/linux/security.h b/include/linux/security.h
index a1079ab..038df6f 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -156,6 +156,12 @@ extern int mmap_min_addr_handler(struct ctl_table *table, int write,
 typedef int (*initxattrs) (struct inode *inode,
 			   const struct xattr *xattr_array, void *fs_data);
 
+/* A collection of secids, which are what (certain) LSMs deal with */
+struct secids {
+	int	si_count;
+	u32	si_lsm[1];
+};
+
 #ifdef CONFIG_SECURITY
 
 struct security_mnt_opts {
@@ -1767,7 +1773,7 @@ int security_inode_killpriv(struct dentry *dentry);
 int security_inode_getsecurity(const struct inode *inode, const char *name, void **buffer, bool alloc);
 int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags);
 int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size);
-void security_inode_getsecid(const struct inode *inode, u32 *secid);
+void security_inode_getsecid(const struct inode *inode, struct secids *secid);
 int security_file_permission(struct file *file, int mask);
 int security_file_alloc(struct file *file);
 void security_file_free(struct file *file);
@@ -1790,7 +1796,7 @@ int security_cred_alloc_blank(struct cred *cred, gfp_t gfp);
 void security_cred_free(struct cred *cred);
 int security_prepare_creds(struct cred *new, const struct cred *old, gfp_t gfp);
 void security_transfer_creds(struct cred *new, const struct cred *old);
-int security_kernel_act_as(struct cred *new, u32 secid);
+int security_kernel_act_as(struct cred *new, struct secids *secid);
 int security_kernel_create_files_as(struct cred *new, struct inode *inode);
 int security_kernel_module_request(char *kmod_name);
 int security_kernel_module_from_file(struct file *file);
@@ -1799,7 +1805,7 @@ int security_task_fix_setuid(struct cred *new, const struct cred *old,
 int security_task_setpgid(struct task_struct *p, pid_t pgid);
 int security_task_getpgid(struct task_struct *p);
 int security_task_getsid(struct task_struct *p);
-void security_task_getsecid(struct task_struct *p, u32 *secid);
+void security_task_getsecid(struct task_struct *p, struct secids *secid);
 int security_task_setnice(struct task_struct *p, int nice);
 int security_task_setioprio(struct task_struct *p, int ioprio);
 int security_task_getioprio(struct task_struct *p);
@@ -1815,7 +1821,7 @@ int security_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			unsigned long arg4, unsigned long arg5);
 void security_task_to_inode(struct task_struct *p, struct inode *inode);
 int security_ipc_permission(struct kern_ipc_perm *ipcp, short flag);
-void security_ipc_getsecid(struct kern_ipc_perm *ipcp, u32 *secid);
+void security_ipc_getsecid(struct kern_ipc_perm *ipcp, struct secids *secid);
 int security_msg_msg_alloc(struct msg_msg *msg);
 void security_msg_msg_free(struct msg_msg *msg);
 int security_msg_queue_alloc(struct msg_queue *msq);
@@ -1841,8 +1847,8 @@ void security_d_instantiate(struct dentry *dentry, struct inode *inode);
 int security_getprocattr(struct task_struct *p, char *name, char **value);
 int security_setprocattr(struct task_struct *p, char *name, void *value, size_t size);
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
-int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
-int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid);
+int security_secid_to_secctx(struct secids *secid, char **secdata, u32 *seclen);
+int security_secctx_to_secid(const char *secdata, u32 seclen, struct secids *secid);
 void security_release_secctx(char *secdata, u32 seclen);
 
 int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
@@ -2187,9 +2193,9 @@ static inline int security_inode_listsecurity(struct inode *inode, char *buffer,
 	return 0;
 }
 
-static inline void security_inode_getsecid(const struct inode *inode, u32 *secid)
+static inline void security_inode_getsecid(const struct inode *inode, struct secids *secid)
 {
-	*secid = 0;
+	secid->si_lsm[0] = 0;
 }
 
 static inline int security_file_permission(struct file *file, int mask)
@@ -2291,7 +2297,7 @@ static inline void security_transfer_creds(struct cred *new,
 {
 }
 
-static inline int security_kernel_act_as(struct cred *cred, u32 secid)
+static inline int security_kernel_act_as(struct cred *cred, struct secids *secid)
 {
 	return 0;
 }
@@ -2334,9 +2340,9 @@ static inline int security_task_getsid(struct task_struct *p)
 	return 0;
 }
 
-static inline void security_task_getsecid(struct task_struct *p, u32 *secid)
+static inline void security_task_getsecid(struct task_struct *p, struct secids *secid)
 {
-	*secid = 0;
+	secid->si_lsm[0] = 0;
 }
 
 static inline int security_task_setnice(struct task_struct *p, int nice)
@@ -2405,9 +2411,9 @@ static inline int security_ipc_permission(struct kern_ipc_perm *ipcp,
 	return 0;
 }
 
-static inline void security_ipc_getsecid(struct kern_ipc_perm *ipcp, u32 *secid)
+static inline void security_ipc_getsecid(struct kern_ipc_perm *ipcp, struct secids *secid)
 {
-	*secid = 0;
+	secid->si_lsm[0] = 0;
 }
 
 static inline int security_msg_msg_alloc(struct msg_msg *msg)
@@ -2519,14 +2525,14 @@ static inline int security_netlink_send(struct sock *sk, struct sk_buff *skb)
 	return cap_netlink_send(sk, skb);
 }
 
-static inline int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
+static inline int security_secid_to_secctx(struct secids *secid, char **secdata, u32 *seclen)
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
@@ -2571,7 +2577,7 @@ int security_socket_shutdown(struct socket *sock, int how);
 int security_sock_rcv_skb(struct sock *sk, struct sk_buff *skb);
 int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
 				      int __user *optlen, unsigned len);
-int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb, u32 *secid);
+int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb, struct secids *secid);
 int security_sk_alloc(struct sock *sk, int family, gfp_t priority);
 void security_sk_free(struct sock *sk);
 void security_sk_clone(const struct sock *sk, struct sock *newsk);
@@ -2700,7 +2706,7 @@ static inline int security_socket_getpeersec_stream(struct socket *sock, char __
 	return -ENOPROTOOPT;
 }
 
-static inline int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb, u32 *secid)
+static inline int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb, struct secids *secid)
 {
 	return -ENOPROTOOPT;
 }
@@ -2999,7 +3005,7 @@ static inline int security_key_getsecurity(struct key *key, char **_buffer)
 #ifdef CONFIG_SECURITY
 int security_audit_rule_init(u32 field, u32 op, char *rulestr, void **lsmrule);
 int security_audit_rule_known(struct audit_krule *krule);
-int security_audit_rule_match(u32 secid, u32 field, u32 op, void *lsmrule,
+int security_audit_rule_match(struct secids *secid, u32 field, u32 op, void *lsmrule,
 			      struct audit_context *actx);
 void security_audit_rule_free(void *lsmrule);
 
@@ -3016,7 +3022,7 @@ static inline int security_audit_rule_known(struct audit_krule *krule)
 	return 0;
 }
 
-static inline int security_audit_rule_match(u32 secid, u32 field, u32 op,
+static inline int security_audit_rule_match(struct secids *secid, u32 field, u32 op,
 				   void *lsmrule, struct audit_context *actx)
 {
 	return 0;
diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index 0a996a3..9cb2470 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -32,12 +32,11 @@ struct unix_skb_parms {
 	const struct cred	*cred;
 	struct scm_fp_list	*fp;		/* Passed files		*/
 #ifdef CONFIG_SECURITY_NETWORK
-	u32			secid;		/* Security ID		*/
+	struct secids		*secid;		/* Security ID		*/
 #endif
 };
 
 #define UNIXCB(skb) 	(*(struct unix_skb_parms *)&((skb)->cb))
-#define UNIXSID(skb)	(&UNIXCB((skb)).secid)
 
 #define unix_state_lock(s)	spin_lock(&unix_sk(s)->lock)
 #define unix_state_unlock(s)	spin_unlock(&unix_sk(s)->lock)
diff --git a/include/net/scm.h b/include/net/scm.h
index 975cca0..e0ce1eb 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -30,7 +30,7 @@ struct scm_cookie {
 	struct scm_fp_list	*fp;		/* Passed files		*/
 	struct scm_creds	creds;		/* Skb credentials	*/
 #ifdef CONFIG_SECURITY_NETWORK
-	u32			secid;		/* Passed security ID 	*/
+	struct secids		secid;		/* Passed security ID 	*/
 #endif
 };
 
@@ -97,7 +97,7 @@ static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct sc
 	int err;
 
 	if (test_bit(SOCK_PASSSEC, &sock->flags)) {
-		err = security_secid_to_secctx(scm->secid, &secdata, &seclen);
+		err = security_secid_to_secctx(&scm->secid, &secdata, &seclen);
 
 		if (!err) {
 			put_cmsg(msg, SOL_SOCKET, SCM_SECURITY, seclen, secdata);
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 24c8886..45976ad 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -698,11 +698,14 @@ static inline void xfrm_audit_helper_usrinfo(kuid_t auid, u32 ses, u32 secid,
 {
 	char *secctx;
 	u32 secctx_len;
+	struct secids sid;
+
+	sid.si_lsm[0] = secid;
 
 	audit_log_format(audit_buf, " auid=%u ses=%u",
 			 from_kuid(&init_user_ns, auid), ses);
 	if (secid != 0 &&
-	    security_secid_to_secctx(secid, &secctx, &secctx_len) == 0) {
+	    security_secid_to_secctx(&sid, &secctx, &secctx_len) == 0) {
 		audit_log_format(audit_buf, " subj=%s", secctx);
 		security_release_secctx(secctx, secctx_len);
 	} else
diff --git a/kernel/audit.c b/kernel/audit.c
index d596e53..eab4b52 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -107,7 +107,7 @@ static int	audit_backlog_wait_overflow = 0;
 /* The identity of the user shutting down the audit system. */
 kuid_t		audit_sig_uid = INVALID_UID;
 pid_t		audit_sig_pid = -1;
-u32		audit_sig_sid = 0;
+struct secids	audit_sig_sid;
 
 /* Records can be lost in several ways:
    0) [suppressed in audit_alloc]
@@ -265,8 +265,8 @@ void audit_log_lost(const char *message)
 }
 
 static int audit_log_config_change(char *function_name, int new, int old,
-				   kuid_t loginuid, u32 sessionid, u32 sid,
-				   int allow_changes)
+				   kuid_t loginuid, u32 sessionid,
+				   struct secids *sid, int allow_changes)
 {
 	struct audit_buffer *ab;
 	int rc = 0;
@@ -282,7 +282,7 @@ static int audit_log_config_change(char *function_name, int new, int old,
 
 		rc = security_secid_to_secctx(sid, &ctx, &len);
 		if (rc) {
-			audit_log_format(ab, " sid=%u", sid);
+			audit_log_format(ab, " sid=%u", sid->si_count);
 			allow_changes = 0; /* Something weird, deny request */
 		} else {
 			audit_log_format(ab, " subj=%s", ctx);
@@ -296,7 +296,7 @@ static int audit_log_config_change(char *function_name, int new, int old,
 
 static int audit_do_config_change(char *function_name, int *to_change,
 				  int new, kuid_t loginuid, u32 sessionid,
-				  u32 sid)
+				  struct secids *sid)
 {
 	int allow_changes, rc = 0, old = *to_change;
 
@@ -323,20 +323,20 @@ static int audit_do_config_change(char *function_name, int *to_change,
 }
 
 static int audit_set_rate_limit(int limit, kuid_t loginuid, u32 sessionid,
-				u32 sid)
+				struct secids *sid)
 {
 	return audit_do_config_change("audit_rate_limit", &audit_rate_limit,
 				      limit, loginuid, sessionid, sid);
 }
 
 static int audit_set_backlog_limit(int limit, kuid_t loginuid, u32 sessionid,
-				   u32 sid)
+				   struct secids *sid)
 {
 	return audit_do_config_change("audit_backlog_limit", &audit_backlog_limit,
 				      limit, loginuid, sessionid, sid);
 }
 
-static int audit_set_enabled(int state, kuid_t loginuid, u32 sessionid, u32 sid)
+static int audit_set_enabled(int state, kuid_t loginuid, u32 sessionid, struct secids *sid)
 {
 	int rc;
 	if (state < AUDIT_OFF || state > AUDIT_LOCKED)
@@ -351,7 +351,7 @@ static int audit_set_enabled(int state, kuid_t loginuid, u32 sessionid, u32 sid)
 	return rc;
 }
 
-static int audit_set_failure(int state, kuid_t loginuid, u32 sessionid, u32 sid)
+static int audit_set_failure(int state, kuid_t loginuid, u32 sessionid, struct secids *sid)
 {
 	if (state != AUDIT_FAIL_SILENT
 	    && state != AUDIT_FAIL_PRINTK
@@ -609,7 +609,7 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
 }
 
 static int audit_log_common_recv_msg(struct audit_buffer **ab, u16 msg_type,
-				     kuid_t auid, u32 ses, u32 sid)
+				     kuid_t auid, u32 ses, struct secids *sid)
 {
 	int rc = 0;
 	char *ctx = NULL;
@@ -630,7 +630,7 @@ static int audit_log_common_recv_msg(struct audit_buffer **ab, u16 msg_type,
 	if (sid) {
 		rc = security_secid_to_secctx(sid, &ctx, &len);
 		if (rc)
-			audit_log_format(*ab, " ssid=%u", sid);
+			audit_log_format(*ab, " ssid=%u", sid->si_count);
 		else {
 			audit_log_format(*ab, " subj=%s", ctx);
 			security_release_secctx(ctx, len);
@@ -642,7 +642,8 @@ static int audit_log_common_recv_msg(struct audit_buffer **ab, u16 msg_type,
 
 static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 {
-	u32			seq, sid;
+	u32			seq;
+	struct secids		sid;
 	void			*data;
 	struct audit_status	*status_get, status_set;
 	int			err;
@@ -692,13 +693,13 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		status_get   = (struct audit_status *)data;
 		if (status_get->mask & AUDIT_STATUS_ENABLED) {
 			err = audit_set_enabled(status_get->enabled,
-						loginuid, sessionid, sid);
+						loginuid, sessionid, &sid);
 			if (err < 0)
 				return err;
 		}
 		if (status_get->mask & AUDIT_STATUS_FAILURE) {
 			err = audit_set_failure(status_get->failure,
-						loginuid, sessionid, sid);
+						loginuid, sessionid, &sid);
 			if (err < 0)
 				return err;
 		}
@@ -708,20 +709,21 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 			if (audit_enabled != AUDIT_OFF)
 				audit_log_config_change("audit_pid", new_pid,
 							audit_pid, loginuid,
-							sessionid, sid, 1);
+							sessionid, &sid, 1);
 
 			audit_pid = new_pid;
 			audit_nlk_portid = NETLINK_CB(skb).portid;
 		}
 		if (status_get->mask & AUDIT_STATUS_RATE_LIMIT) {
 			err = audit_set_rate_limit(status_get->rate_limit,
-						   loginuid, sessionid, sid);
+						   loginuid, sessionid, &sid);
 			if (err < 0)
 				return err;
 		}
 		if (status_get->mask & AUDIT_STATUS_BACKLOG_LIMIT)
 			err = audit_set_backlog_limit(status_get->backlog_limit,
-						      loginuid, sessionid, sid);
+						      loginuid, sessionid,
+						      &sid);
 		break;
 	case AUDIT_USER:
 	case AUDIT_FIRST_USER_MSG ... AUDIT_LAST_USER_MSG:
@@ -739,7 +741,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 					break;
 			}
 			audit_log_common_recv_msg(&ab, msg_type,
-						  loginuid, sessionid, sid);
+						  loginuid, sessionid, &sid);
 
 			if (msg_type != AUDIT_USER_TTY)
 				audit_log_format(ab, " msg='%.1024s'",
@@ -764,7 +766,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 			return -EINVAL;
 		if (audit_enabled == AUDIT_LOCKED) {
 			audit_log_common_recv_msg(&ab, AUDIT_CONFIG_CHANGE,
-						  loginuid, sessionid, sid);
+						  loginuid, sessionid, &sid);
 
 			audit_log_format(ab, " audit_enabled=%d res=0",
 					 audit_enabled);
@@ -775,7 +777,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	case AUDIT_LIST:
 		err = audit_receive_filter(msg_type, NETLINK_CB(skb).portid,
 					   seq, data, nlmsg_len(nlh),
-					   loginuid, sessionid, sid);
+					   loginuid, sessionid, &sid);
 		break;
 	case AUDIT_ADD_RULE:
 	case AUDIT_DEL_RULE:
@@ -783,7 +785,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 			return -EINVAL;
 		if (audit_enabled == AUDIT_LOCKED) {
 			audit_log_common_recv_msg(&ab, AUDIT_CONFIG_CHANGE,
-						  loginuid, sessionid, sid);
+						  loginuid, sessionid, &sid);
 
 			audit_log_format(ab, " audit_enabled=%d res=0",
 					 audit_enabled);
@@ -794,13 +796,13 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	case AUDIT_LIST_RULES:
 		err = audit_receive_filter(msg_type, NETLINK_CB(skb).portid,
 					   seq, data, nlmsg_len(nlh),
-					   loginuid, sessionid, sid);
+					   loginuid, sessionid, &sid);
 		break;
 	case AUDIT_TRIM:
 		audit_trim_trees();
 
 		audit_log_common_recv_msg(&ab, AUDIT_CONFIG_CHANGE,
-					  loginuid, sessionid, sid);
+					  loginuid, sessionid, &sid);
 
 		audit_log_format(ab, " op=trim res=1");
 		audit_log_end(ab);
@@ -832,7 +834,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		err = audit_tag_tree(old, new);
 
 		audit_log_common_recv_msg(&ab, AUDIT_CONFIG_CHANGE,
-					  loginuid, sessionid, sid);
+					  loginuid, sessionid, &sid);
 
 		audit_log_format(ab, " op=make_equiv old=");
 		audit_log_untrustedstring(ab, old);
@@ -846,20 +848,21 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	}
 	case AUDIT_SIGNAL_INFO:
 		len = 0;
-		if (audit_sig_sid) {
-			err = security_secid_to_secctx(audit_sig_sid, &ctx, &len);
+		if (audit_sig_sid.si_count) {
+			err = security_secid_to_secctx(&audit_sig_sid, &ctx,
+							&len);
 			if (err)
 				return err;
 		}
 		sig_data = kmalloc(sizeof(*sig_data) + len, GFP_KERNEL);
 		if (!sig_data) {
-			if (audit_sig_sid)
+			if (audit_sig_sid.si_count)
 				security_release_secctx(ctx, len);
 			return -ENOMEM;
 		}
 		sig_data->uid = from_kuid(&init_user_ns, audit_sig_uid);
 		sig_data->pid = audit_sig_pid;
-		if (audit_sig_sid) {
+		if (audit_sig_sid.si_count) {
 			memcpy(sig_data->ctx, ctx, len);
 			security_release_secctx(ctx, len);
 		}
@@ -1525,21 +1528,29 @@ void audit_log(struct audit_context *ctx, gfp_t gfp_mask, int type,
 
 #ifdef CONFIG_SECURITY
 /**
- * audit_log_secctx - Converts and logs SELinux context
+ * audit_log_secctx - Converts and logs security context
  * @ab: audit_buffer
  * @secid: security number
  *
  * This is a helper function that calls security_secid_to_secctx to convert
- * secid to secctx and then adds the (converted) SELinux context to the audit
+ * secid to secctx and then adds the (converted) security context to the audit
  * log by calling audit_log_format, thus also preventing leak of internal secid
  * to userspace. If secid cannot be converted audit_panic is called.
+ *
+ * This is only called by the secmark code.
  */
 void audit_log_secctx(struct audit_buffer *ab, u32 secid)
 {
 	u32 len;
 	char *secctx;
+	struct secids secids;
+
+	memset(&secids, 0, sizeof(secids));
+
+	secids.si_lsm[0] = secid;
+	secids.si_count = 1;
 
-	if (security_secid_to_secctx(secid, &secctx, &len)) {
+	if (security_secid_to_secctx(&secids, &secctx, &len)) {
 		audit_panic("Cannot convert secid to context");
 	} else {
 		audit_log_format(ab, " obj=%s", secctx);
diff --git a/kernel/audit.h b/kernel/audit.h
index d51cba8..a4d5d9a 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -95,8 +95,6 @@ struct audit_netlink_list {
 
 int audit_send_list(void *);
 
-extern int selinux_audit_rule_update(void);
-
 extern struct mutex audit_filter_mutex;
 extern void audit_free_rule_rcu(struct rcu_head *);
 extern struct list_head audit_filter_list[];
@@ -150,7 +148,7 @@ extern char *audit_unpack_string(void **, size_t *, size_t);
 
 extern pid_t audit_sig_pid;
 extern kuid_t audit_sig_uid;
-extern u32 audit_sig_sid;
+extern struct secids audit_sig_sid;
 
 #ifdef CONFIG_AUDITSYSCALL
 extern int __audit_signal_info(int sig, struct task_struct *t);
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index f9fc54b..765873b 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1109,8 +1109,9 @@ static void audit_list_rules(int pid, int seq, struct sk_buff_head *q)
 }
 
 /* Log rule additions and removals */
-static void audit_log_rule_change(kuid_t loginuid, u32 sessionid, u32 sid,
-				  char *action, struct audit_krule *rule,
+static void audit_log_rule_change(kuid_t loginuid, u32 sessionid,
+				  struct secids *sid, char *action,
+				  struct audit_krule *rule,
 				  int res)
 {
 	struct audit_buffer *ab;
@@ -1123,11 +1124,11 @@ static void audit_log_rule_change(kuid_t loginuid, u32 sessionid, u32 sid,
 		return;
 	audit_log_format(ab, "auid=%u ses=%u",
 			 from_kuid(&init_user_ns, loginuid), sessionid);
-	if (sid) {
+	if (sid->si_count) {
 		char *ctx = NULL;
 		u32 len;
 		if (security_secid_to_secctx(sid, &ctx, &len))
-			audit_log_format(ab, " ssid=%u", sid);
+			audit_log_format(ab, " ssid=%u", sid->si_count);
 		else {
 			audit_log_format(ab, " subj=%s", ctx);
 			security_release_secctx(ctx, len);
@@ -1152,7 +1153,8 @@ static void audit_log_rule_change(kuid_t loginuid, u32 sessionid, u32 sid,
  * @sid: SE Linux Security ID of sender
  */
 int audit_receive_filter(int type, int pid, int seq, void *data,
-			 size_t datasz, kuid_t loginuid, u32 sessionid, u32 sid)
+			 size_t datasz, kuid_t loginuid, u32 sessionid,
+			 struct secids *sid)
 {
 	struct task_struct *tsk;
 	struct audit_netlink_list *dest;
@@ -1362,7 +1364,7 @@ static int audit_filter_user_rules(struct audit_krule *rule,
 	for (i = 0; i < rule->field_count; i++) {
 		struct audit_field *f = &rule->fields[i];
 		int result = 0;
-		u32 sid;
+		struct secids sid;
 
 		switch (f->type) {
 		case AUDIT_PID:
@@ -1385,7 +1387,7 @@ static int audit_filter_user_rules(struct audit_krule *rule,
 		case AUDIT_SUBJ_CLR:
 			if (f->lsm_rule) {
 				security_task_getsecid(current, &sid);
-				result = security_audit_rule_match(sid,
+				result = security_audit_rule_match(&sid,
 								   f->type,
 								   f->op,
 								   f->lsm_rule,
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index a371f85..e7e788b 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -114,8 +114,8 @@ struct audit_names {
 	kuid_t			uid;
 	kgid_t			gid;
 	dev_t			rdev;
-	u32			osid;
-	struct audit_cap_data	 fcap;
+	struct secids		osid;
+	struct audit_cap_data	fcap;
 	unsigned int		fcap_ver;
 	int			name_len;	/* number of name's characters to log */
 	unsigned char		type;		/* record type */
@@ -151,7 +151,7 @@ struct audit_aux_data_pids {
 	kuid_t			target_auid[AUDIT_AUX_PIDS];
 	kuid_t			target_uid[AUDIT_AUX_PIDS];
 	unsigned int		target_sessionid[AUDIT_AUX_PIDS];
-	u32			target_sid[AUDIT_AUX_PIDS];
+	struct secids		target_sid[AUDIT_AUX_PIDS];
 	char 			target_comm[AUDIT_AUX_PIDS][TASK_COMM_LEN];
 	int			pid_count;
 };
@@ -215,7 +215,7 @@ struct audit_context {
 	kuid_t		    target_auid;
 	kuid_t		    target_uid;
 	unsigned int	    target_sessionid;
-	u32		    target_sid;
+	struct secids	    target_sid;
 	char		    target_comm[TASK_COMM_LEN];
 
 	struct audit_tree_refs *trees, *first_trees;
@@ -232,7 +232,7 @@ struct audit_context {
 			kuid_t			uid;
 			kgid_t			gid;
 			umode_t			mode;
-			u32			osid;
+			struct secids		osid;
 			int			has_perm;
 			uid_t			perm_uid;
 			gid_t			perm_gid;
@@ -599,7 +599,7 @@ static int audit_filter_rules(struct task_struct *tsk,
 {
 	const struct cred *cred;
 	int i, need_sid = 1;
-	u32 sid;
+	struct secids sid;
 
 	cred = rcu_dereference_check(tsk->cred, tsk == current || task_creation);
 
@@ -757,10 +757,11 @@ static int audit_filter_rules(struct task_struct *tsk,
 					security_task_getsecid(tsk, &sid);
 					need_sid = 0;
 				}
-				result = security_audit_rule_match(sid, f->type,
-				                                  f->op,
-				                                  f->lsm_rule,
-				                                  ctx);
+				result = security_audit_rule_match(&sid,
+								f->type,
+								f->op,
+								f->lsm_rule,
+								ctx);
 			}
 			break;
 		case AUDIT_OBJ_USER:
@@ -774,13 +775,16 @@ static int audit_filter_rules(struct task_struct *tsk,
 				/* Find files that match */
 				if (name) {
 					result = security_audit_rule_match(
-					           name->osid, f->type, f->op,
+						   &name->osid, f->type, f->op,
 					           f->lsm_rule, ctx);
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
@@ -789,7 +793,7 @@ static int audit_filter_rules(struct task_struct *tsk,
 				/* Find ipc objects that match */
 				if (!ctx || ctx->type != AUDIT_IPC)
 					break;
-				if (security_audit_rule_match(ctx->ipc.osid,
+				if (security_audit_rule_match(&ctx->ipc.osid,
 							      f->type, f->op,
 							      f->lsm_rule, ctx))
 					++result;
@@ -1104,13 +1108,13 @@ void audit_log_task_context(struct audit_buffer *ab)
 	char *ctx = NULL;
 	unsigned len;
 	int error;
-	u32 sid;
+	struct secids sid;
 
 	security_task_getsecid(current, &sid);
-	if (!sid)
+	if (sid.si_count == 0)
 		return;
 
-	error = security_secid_to_secctx(sid, &ctx, &len);
+	error = security_secid_to_secctx(&sid, &ctx, &len);
 	if (error) {
 		if (error != -EINVAL)
 			goto error_path;
@@ -1182,8 +1186,9 @@ void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk)
 EXPORT_SYMBOL(audit_log_task_info);
 
 static int audit_log_pid_context(struct audit_context *context, pid_t pid,
-				 kuid_t auid, kuid_t uid, unsigned int sessionid,
-				 u32 sid, char *comm)
+				 kuid_t auid, kuid_t uid,
+				 unsigned int sessionid, struct secids *sid,
+				 char *comm)
 {
 	struct audit_buffer *ab;
 	char *ctx = NULL;
@@ -1443,17 +1448,17 @@ static void show_special(struct audit_context *context, int *call_panic)
 				context->socketcall.args[i]);
 		break; }
 	case AUDIT_IPC: {
-		u32 osid = context->ipc.osid;
+		struct secids *sip = &context->ipc.osid;
 
 		audit_log_format(ab, "ouid=%u ogid=%u mode=%#ho",
 				 from_kuid(&init_user_ns, context->ipc.uid),
 				 from_kgid(&init_user_ns, context->ipc.gid),
 				 context->ipc.mode);
-		if (osid) {
+		if (sip->si_count) {
 			char *ctx = NULL;
 			u32 len;
-			if (security_secid_to_secctx(osid, &ctx, &len)) {
-				audit_log_format(ab, " osid=%u", osid);
+			if (security_secid_to_secctx(sip, &ctx, &len)) {
+				audit_log_format(ab, " osid=%u", sip->si_count);
 				*call_panic = 1;
 			} else {
 				audit_log_format(ab, " obj=%s", ctx);
@@ -1566,12 +1571,11 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
 				 MAJOR(n->rdev),
 				 MINOR(n->rdev));
 	}
-	if (n->osid != 0) {
+	if (n->osid.si_count != 0) {
 		char *ctx = NULL;
 		u32 len;
-		if (security_secid_to_secctx(
-			n->osid, &ctx, &len)) {
-			audit_log_format(ab, " osid=%u", n->osid);
+		if (security_secid_to_secctx(&n->osid, &ctx, &len)) {
+			audit_log_format(ab, " osid=%u", n->osid.si_count);
 			*call_panic = 2;
 		} else {
 			audit_log_format(ab, " obj=%s", ctx);
@@ -1679,7 +1683,7 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 						  axs->target_auid[i],
 						  axs->target_uid[i],
 						  axs->target_sessionid[i],
-						  axs->target_sid[i],
+						  &axs->target_sid[i],
 						  axs->target_comm[i]))
 				call_panic = 1;
 	}
@@ -1688,7 +1692,7 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 	    audit_log_pid_context(context, context->target_pid,
 				  context->target_auid, context->target_uid,
 				  context->target_sessionid,
-				  context->target_sid, context->target_comm))
+				  &context->target_sid, context->target_comm))
 			call_panic = 1;
 
 	if (context->pwd.dentry && context->pwd.mnt) {
@@ -1834,7 +1838,7 @@ void __audit_syscall_exit(int success, long return_code)
 	context->aux = NULL;
 	context->aux_pids = NULL;
 	context->target_pid = 0;
-	context->target_sid = 0;
+	context->target_sid.si_count = 0;
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
index f2ca127..03dd794 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
@@ -98,14 +98,21 @@ static int ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 	int ret;
 	u32 len;
 	char *secctx;
+	struct secids secid;
+	struct security_operations *sop;
 
-	ret = security_secid_to_secctx(ct->secmark, &secctx, &len);
+	memset(&secid, 0, sizeof(secid));
+
+	secid.si_lsm[lsm_secmark_ops->order] = ct->secmark;
+	secid.si_count = 1;
+
+	ret = security_secid_to_secctx(&secid, &secctx, &len, &sop);
 	if (ret)
 		return 0;
 
 	ret = seq_printf(s, "secctx=%s ", secctx);
 
-	security_release_secctx(secctx, len);
+	security_release_secctx(secctx, len, sop);
 	return ret;
 }
 #else
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 9904b15..4a95072 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -301,8 +301,13 @@ ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 	struct nlattr *nest_secctx;
 	int len, ret;
 	char *secctx;
+	struct secids secid;
 
-	ret = security_secid_to_secctx(ct->secmark, &secctx, &len);
+	memset(&secid, 0, sizeof(secid));
+
+	secid.si_lsm[0] = ct->secmark;
+
+	ret = security_secid_to_secctx(&secid, &secctx, &len);
 	if (ret)
 		return 0;
 
@@ -548,8 +553,13 @@ ctnetlink_secctx_size(const struct nf_conn *ct)
 {
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
 	int len, ret;
+	struct secids secid;
+
+	memset(&secid, 0, sizeof(secid));
+
+	secid.si_lsm[0] = ct->secmark;
 
-	ret = security_secid_to_secctx(ct->secmark, NULL, &len);
+	ret = security_secid_to_secctx(&secid, NULL, &len);
 	if (ret)
 		return 0;
 
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index fedee39..4e5bb3e 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -123,8 +123,13 @@ static int ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 	int ret;
 	u32 len;
 	char *secctx;
+	struct secids secid;
 
-	ret = security_secid_to_secctx(ct->secmark, &secctx, &len);
+	memset(&secid, 0, sizeof(secid));
+
+	secid.si_lsm[0] = ct->secmark;
+
+	ret = security_secid_to_secctx(&secid, &secctx, &len);
 	if (ret)
 		return 0;
 
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index 9faf5e0..0f7a066 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -52,12 +52,17 @@ secmark_tg(struct sk_buff *skb, const struct xt_action_param *par)
 static int checkentry_lsm(struct xt_secmark_target_info *info)
 {
 	int err;
+	struct secids secid;
 
 	info->secctx[SECMARK_SECCTX_MAX - 1] = '\0';
 	info->secid = 0;
 
+	secid.si_lsm[0] = 0;
+
 	err = security_secctx_to_secid(info->secctx, strlen(info->secctx),
-				       &info->secid);
+					&secid);
+	info->secid = secid.si_lsm[0];
+
 	if (err) {
 		if (err == -EINVAL)
 			pr_info("invalid security context \'%s\'\n", info->secctx);
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index 8a6c6ea..520caaa 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -396,6 +396,9 @@ int netlbl_unlhsh_add(struct net *net,
 	struct audit_buffer *audit_buf = NULL;
 	char *secctx = NULL;
 	u32 secctx_len;
+	struct secids sid;
+
+	sid.si_lsm[0] = secid;
 
 	if (addr_len != sizeof(struct in_addr) &&
 	    addr_len != sizeof(struct in6_addr))
@@ -458,7 +461,7 @@ int netlbl_unlhsh_add(struct net *net,
 unlhsh_add_return:
 	rcu_read_unlock();
 	if (audit_buf != NULL) {
-		if (security_secid_to_secctx(secid,
+		if (security_secid_to_secctx(&sid,
 					     &secctx,
 					     &secctx_len) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s", secctx);
@@ -495,6 +498,7 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 	struct net_device *dev;
 	char *secctx;
 	u32 secctx_len;
+	struct secids sid;
 
 	spin_lock(&netlbl_unlhsh_lock);
 	list_entry = netlbl_af4list_remove(addr->s_addr, mask->s_addr,
@@ -514,8 +518,9 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 					  addr->s_addr, mask->s_addr);
 		if (dev != NULL)
 			dev_put(dev);
+		sid.si_lsm[0] = entry->secid;
 		if (entry != NULL &&
-		    security_secid_to_secctx(entry->secid,
+		    security_secid_to_secctx(&sid,
 					     &secctx, &secctx_len) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s", secctx);
 			security_release_secctx(secctx, secctx_len);
@@ -557,6 +562,7 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 	struct net_device *dev;
 	char *secctx;
 	u32 secctx_len;
+	struct secids sid;
 
 	spin_lock(&netlbl_unlhsh_lock);
 	list_entry = netlbl_af6list_remove(addr, mask, &iface->addr6_list);
@@ -575,8 +581,9 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 					  addr, mask);
 		if (dev != NULL)
 			dev_put(dev);
+		sid.si_lsm[0] = entry->secid;
 		if (entry != NULL &&
-		    security_secid_to_secctx(entry->secid,
+		    security_secid_to_secctx(&sid,
 					     &secctx, &secctx_len) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s", secctx);
 			security_release_secctx(secctx, secctx_len);
@@ -902,7 +909,7 @@ static int netlbl_unlabel_staticadd(struct sk_buff *skb,
 	void *addr;
 	void *mask;
 	u32 addr_len;
-	u32 secid;
+	struct secids secid;
 	struct netlbl_audit audit_info;
 
 	/* Don't allow users to add both IPv4 and IPv6 addresses for a
@@ -931,7 +938,7 @@ static int netlbl_unlabel_staticadd(struct sk_buff *skb,
 		return ret_val;
 
 	return netlbl_unlhsh_add(&init_net,
-				 dev_name, addr, mask, addr_len, secid,
+				 dev_name, addr, mask, addr_len, secid.si_lsm[0],
 				 &audit_info);
 }
 
@@ -953,7 +960,7 @@ static int netlbl_unlabel_staticadddef(struct sk_buff *skb,
 	void *addr;
 	void *mask;
 	u32 addr_len;
-	u32 secid;
+	struct secids secid;
 	struct netlbl_audit audit_info;
 
 	/* Don't allow users to add both IPv4 and IPv6 addresses for a
@@ -980,7 +987,7 @@ static int netlbl_unlabel_staticadddef(struct sk_buff *skb,
 		return ret_val;
 
 	return netlbl_unlhsh_add(&init_net,
-				 NULL, addr, mask, addr_len, secid,
+				 NULL, addr, mask, addr_len, secid.si_lsm[0],
 				 &audit_info);
 }
 
@@ -1092,7 +1099,7 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 	struct netlbl_unlhsh_walk_arg *cb_arg = arg;
 	struct net_device *dev;
 	void *data;
-	u32 secid;
+	struct secids secid;
 	char *secctx;
 	u32 secctx_len;
 
@@ -1134,7 +1141,7 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 		if (ret_val != 0)
 			goto list_cb_failure;
 
-		secid = addr4->secid;
+		secid.si_lsm[0] = addr4->secid;
 	} else {
 		ret_val = nla_put(cb_arg->skb,
 				  NLBL_UNLABEL_A_IPV6ADDR,
@@ -1150,10 +1157,10 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 		if (ret_val != 0)
 			goto list_cb_failure;
 
-		secid = addr6->secid;
+		secid.si_lsm[0] = addr6->secid;
 	}
 
-	ret_val = security_secid_to_secctx(secid, &secctx, &secctx_len);
+	ret_val = security_secid_to_secctx(&secid, &secctx, &secctx_len);
 	if (ret_val != 0)
 		goto list_cb_failure;
 	ret_val = nla_put(cb_arg->skb,
@@ -1531,11 +1538,13 @@ int __init netlbl_unlabel_defconf(void)
 	int ret_val;
 	struct netlbl_dom_map *entry;
 	struct netlbl_audit audit_info;
+	struct secids secid;
 
 	/* Only the kernel is allowed to call this function and the only time
 	 * it is called is at bootup before the audit subsystem is reporting
 	 * messages so don't worry to much about these values. */
-	security_task_getsecid(current, &audit_info.secid);
+	security_task_getsecid(current, &secid);
+	audit_info.secid = secid.si_lsm[0];
 	audit_info.loginuid = GLOBAL_ROOT_UID;
 	audit_info.sessionid = 0;
 
diff --git a/net/netlabel/netlabel_user.c b/net/netlabel/netlabel_user.c
index 9650c4a..7ef8262 100644
--- a/net/netlabel/netlabel_user.c
+++ b/net/netlabel/netlabel_user.c
@@ -100,10 +100,13 @@ struct audit_buffer *netlbl_audit_start_common(int type,
 	struct audit_buffer *audit_buf;
 	char *secctx;
 	u32 secctx_len;
+	struct secids secid;
 
 	if (audit_enabled == 0)
 		return NULL;
 
+	secid.si_lsm[0] = audit_info->secid;
+
 	audit_buf = audit_log_start(current->audit_context, GFP_ATOMIC, type);
 	if (audit_buf == NULL)
 		return NULL;
@@ -113,9 +116,7 @@ struct audit_buffer *netlbl_audit_start_common(int type,
 			 audit_info->sessionid);
 
 	if (audit_info->secid != 0 &&
-	    security_secid_to_secctx(audit_info->secid,
-				     &secctx,
-				     &secctx_len) == 0) {
+	    security_secid_to_secctx(&secid, &secctx, &secctx_len) == 0) {
 		audit_log_format(audit_buf, " subj=%s", secctx);
 		security_release_secctx(secctx, secctx_len);
 	}
diff --git a/net/netlabel/netlabel_user.h b/net/netlabel/netlabel_user.h
index 8196978..a6f1705 100644
--- a/net/netlabel/netlabel_user.h
+++ b/net/netlabel/netlabel_user.h
@@ -49,7 +49,10 @@
 static inline void netlbl_netlink_auditinfo(struct sk_buff *skb,
 					    struct netlbl_audit *audit_info)
 {
-	security_task_getsecid(current, &audit_info->secid);
+	struct secids secid;
+
+	security_task_getsecid(current, &secid);
+	audit_info->secid = secid.si_lsm[0];
 	audit_info->loginuid = audit_get_loginuid(current);
 	audit_info->sessionid = audit_get_sessionid(current);
 }
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 2db702d..0051f1b 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -135,14 +135,27 @@ static struct hlist_head *unix_sockets_unbound(void *addr)
 #define UNIX_ABSTRACT(sk)	(unix_sk(sk)->addr->hash < UNIX_HASH_SIZE)
 
 #ifdef CONFIG_SECURITY_NETWORK
+/*
+ * Casey says - look for a memory leak here.
+ */
 static void unix_get_secdata(struct scm_cookie *scm, struct sk_buff *skb)
 {
-	memcpy(UNIXSID(skb), &scm->secid, sizeof(u32));
+	struct secids *sip = kzalloc(sizeof(*sip), GFP_KERNEL);
+
+	if (sip)
+		memcpy(sip, &scm->secid, sizeof(*sip));
+	UNIXCB(skb).secid = sip;
 }
 
 static inline void unix_set_secdata(struct scm_cookie *scm, struct sk_buff *skb)
 {
-	scm->secid = *UNIXSID(skb);
+	struct secids *sip = UNIXCB(skb).secid;
+
+	if (sip) {
+		memcpy(&scm->secid, sip, sizeof(scm->secid));
+		kfree(sip);
+	} else
+		memset(&scm->secid, 0, sizeof(scm->secid));
 }
 #else
 static inline void unix_get_secdata(struct scm_cookie *scm, struct sk_buff *skb)
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index fbd9e6c..5476610 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -597,7 +597,7 @@ static int xfrm_add_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct km_event c;
 	kuid_t loginuid = audit_get_loginuid(current);
 	u32 sessionid = audit_get_sessionid(current);
-	u32 sid;
+	struct secids sid;
 
 	err = verify_newsa_info(p, attrs);
 	if (err)
@@ -614,7 +614,7 @@ static int xfrm_add_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
 		err = xfrm_state_update(x);
 
 	security_task_getsecid(current, &sid);
-	xfrm_audit_state_add(x, err ? 0 : 1, loginuid, sessionid, sid);
+	xfrm_audit_state_add(x, err ? 0 : 1, loginuid, sessionid, sid.si_lsm[0]);
 
 	if (err < 0) {
 		x->km.state = XFRM_STATE_DEAD;
@@ -676,7 +676,7 @@ static int xfrm_del_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct xfrm_usersa_id *p = nlmsg_data(nlh);
 	kuid_t loginuid = audit_get_loginuid(current);
 	u32 sessionid = audit_get_sessionid(current);
-	u32 sid;
+	struct secids sid;
 
 	x = xfrm_user_state_lookup(net, p, attrs, &err);
 	if (x == NULL)
@@ -702,7 +702,7 @@ static int xfrm_del_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 out:
 	security_task_getsecid(current, &sid);
-	xfrm_audit_state_delete(x, err ? 0 : 1, loginuid, sessionid, sid);
+	xfrm_audit_state_delete(x, err ? 0 : 1, loginuid, sessionid, sid.si_lsm[0]);
 	xfrm_state_put(x);
 	return err;
 }
@@ -1395,7 +1395,7 @@ static int xfrm_add_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 	int excl;
 	kuid_t loginuid = audit_get_loginuid(current);
 	u32 sessionid = audit_get_sessionid(current);
-	u32 sid;
+	struct secids sid;
 
 	err = verify_newpolicy_info(p);
 	if (err)
@@ -1415,7 +1415,7 @@ static int xfrm_add_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 	excl = nlh->nlmsg_type == XFRM_MSG_NEWPOLICY;
 	err = xfrm_policy_insert(p->dir, xp, excl);
 	security_task_getsecid(current, &sid);
-	xfrm_audit_policy_add(xp, err ? 0 : 1, loginuid, sessionid, sid);
+	xfrm_audit_policy_add(xp, err ? 0 : 1, loginuid, sessionid, sid.si_lsm[0]);
 
 	if (err) {
 		security_xfrm_policy_free(xp->security);
@@ -1653,11 +1653,11 @@ static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 	} else {
 		kuid_t loginuid = audit_get_loginuid(current);
 		u32 sessionid = audit_get_sessionid(current);
-		u32 sid;
+		struct secids sid;
 
 		security_task_getsecid(current, &sid);
 		xfrm_audit_policy_delete(xp, err ? 0 : 1, loginuid, sessionid,
-					 sid);
+					 sid.si_lsm[0]);
 
 		if (err != 0)
 			goto out;
@@ -1682,10 +1682,12 @@ static int xfrm_flush_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct xfrm_usersa_flush *p = nlmsg_data(nlh);
 	struct xfrm_audit audit_info;
 	int err;
+	struct secids secid;
 
 	audit_info.loginuid = audit_get_loginuid(current);
 	audit_info.sessionid = audit_get_sessionid(current);
-	security_task_getsecid(current, &audit_info.secid);
+	security_task_getsecid(current, &secid);
+	audit_info.secid = secid.si_lsm[0];
 	err = xfrm_state_flush(net, p->proto, &audit_info);
 	if (err) {
 		if (err == -ESRCH) /* empty table */
@@ -1871,6 +1873,7 @@ static int xfrm_flush_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 	u8 type = XFRM_POLICY_TYPE_MAIN;
 	int err;
 	struct xfrm_audit audit_info;
+	struct secids secid;
 
 	err = copy_from_user_policy_type(&type, attrs);
 	if (err)
@@ -1878,7 +1881,8 @@ static int xfrm_flush_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	audit_info.loginuid = audit_get_loginuid(current);
 	audit_info.sessionid = audit_get_sessionid(current);
-	security_task_getsecid(current, &audit_info.secid);
+	security_task_getsecid(current, &secid);
+	audit_info.secid = secid.si_lsm[0];
 	err = xfrm_policy_flush(net, type, &audit_info);
 	if (err) {
 		if (err == -ESRCH) /* empty table */
@@ -1947,11 +1951,11 @@ static int xfrm_add_pol_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (up->hard) {
 		kuid_t loginuid = audit_get_loginuid(current);
 		u32 sessionid = audit_get_sessionid(current);
-		u32 sid;
+		struct secids sid;
 
 		security_task_getsecid(current, &sid);
 		xfrm_policy_delete(xp, p->dir);
-		xfrm_audit_policy_delete(xp, 1, loginuid, sessionid, sid);
+		xfrm_audit_policy_delete(xp, 1, loginuid, sessionid, sid.si_lsm[0]);
 
 	} else {
 		// reset the timers here?
@@ -1990,11 +1994,11 @@ static int xfrm_add_sa_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (ue->hard) {
 		kuid_t loginuid = audit_get_loginuid(current);
 		u32 sessionid = audit_get_sessionid(current);
-		u32 sid;
+		struct secids sid;
 
 		security_task_getsecid(current, &sid);
 		__xfrm_state_delete(x);
-		xfrm_audit_state_delete(x, 1, loginuid, sessionid, sid);
+		xfrm_audit_state_delete(x, 1, loginuid, sessionid, sid.si_lsm[0]);
 	}
 	err = 0;
 out:
diff --git a/security/capability.c b/security/capability.c
index 6783c3e..08bca78 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -447,7 +447,7 @@ static int cap_task_wait(struct task_struct *p)
 }
 
 static int cap_task_kill(struct task_struct *p, struct siginfo *info,
-			 int sig, u32 secid)
+			 int sig, const struct cred *ucred)
 {
 	return 0;
 }
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 399433a..147d61c 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -184,7 +184,8 @@ static bool ima_match_rules(struct ima_rule_entry *rule,
 		return false;
 	for (i = 0; i < MAX_LSM_RULES; i++) {
 		int rc = 0;
-		u32 osid, sid;
+		struct secids sid;
+		struct secids osid;
 		int retried = 0;
 
 		if (!rule->lsm[i].rule)
@@ -195,7 +196,7 @@ retry:
 		case LSM_OBJ_ROLE:
 		case LSM_OBJ_TYPE:
 			security_inode_getsecid(inode, &osid);
-			rc = security_filter_rule_match(osid,
+			rc = security_filter_rule_match(&osid,
 							rule->lsm[i].type,
 							Audit_equal,
 							rule->lsm[i].rule,
@@ -205,7 +206,7 @@ retry:
 		case LSM_SUBJ_ROLE:
 		case LSM_SUBJ_TYPE:
 			security_task_getsecid(tsk, &sid);
-			rc = security_filter_rule_match(sid,
+			rc = security_filter_rule_match(&sid,
 							rule->lsm[i].type,
 							Audit_equal,
 							rule->lsm[i].rule,
diff --git a/security/security.c b/security/security.c
index 03f248b..000a1fc 100644
--- a/security/security.c
+++ b/security/security.c
@@ -648,9 +648,9 @@ int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer
 	return security_ops->inode_listsecurity(inode, buffer, buffer_size);
 }
 
-void security_inode_getsecid(const struct inode *inode, u32 *secid)
+void security_inode_getsecid(const struct inode *inode, struct secids *secid)
 {
-	security_ops->inode_getsecid(inode, secid);
+	security_ops->inode_getsecid(inode, &secid->si_lsm[0]);
 }
 
 int security_file_permission(struct file *file, int mask)
@@ -805,9 +805,9 @@ void security_transfer_creds(struct cred *new, const struct cred *old)
 	security_ops->cred_transfer(new, old);
 }
 
-int security_kernel_act_as(struct cred *new, u32 secid)
+int security_kernel_act_as(struct cred *new, struct secids *secid)
 {
-	return security_ops->kernel_act_as(new, secid);
+	return security_ops->kernel_act_as(new, secid->si_lsm[0]);
 }
 
 int security_kernel_create_files_as(struct cred *new, struct inode *inode)
@@ -851,9 +851,9 @@ int security_task_getsid(struct task_struct *p)
 	return security_ops->task_getsid(p);
 }
 
-void security_task_getsecid(struct task_struct *p, u32 *secid)
+void security_task_getsecid(struct task_struct *p, struct secids *secid)
 {
-	security_ops->task_getsecid(p, secid);
+	security_ops->task_getsecid(p, &secid->si_lsm[0]);
 }
 EXPORT_SYMBOL(security_task_getsecid);
 
@@ -894,9 +894,9 @@ int security_task_movememory(struct task_struct *p)
 }
 
 int security_task_kill(struct task_struct *p, struct siginfo *info,
-			int sig, u32 secid)
+			int sig, const struct cred *ocred)
 {
-	return security_ops->task_kill(p, info, sig, secid);
+	return security_ops->task_kill(p, info, sig, ocred);
 }
 
 int security_task_wait(struct task_struct *p)
@@ -926,9 +926,9 @@ int security_ipc_permission(struct kern_ipc_perm *ipcp, short flag)
 	return security_ops->ipc_permission(ipcp, flag);
 }
 
-void security_ipc_getsecid(struct kern_ipc_perm *ipcp, u32 *secid)
+void security_ipc_getsecid(struct kern_ipc_perm *ipcp, struct secids *secid)
 {
-	security_ops->ipc_getsecid(ipcp, secid);
+	security_ops->ipc_getsecid(ipcp, &secid->si_lsm[0]);
 }
 
 int security_msg_msg_alloc(struct msg_msg *msg)
@@ -1047,15 +1047,17 @@ int security_netlink_send(struct sock *sk, struct sk_buff *skb)
 	return security_ops->netlink_send(sk, skb);
 }
 
-int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
+int security_secid_to_secctx(struct secids *secid, char **secdata, u32 *seclen)
 {
-	return security_ops->secid_to_secctx(secid, secdata, seclen);
+	return security_ops->secid_to_secctx(secid->si_lsm[0], secdata, seclen);
 }
 EXPORT_SYMBOL(security_secid_to_secctx);
 
-int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid)
+int security_secctx_to_secid(const char *secdata, u32 seclen,
+				struct secids *secid)
 {
-	return security_ops->secctx_to_secid(secdata, seclen, secid);
+	return security_ops->secctx_to_secid(secdata, seclen,
+						&secid->si_lsm[0]);
 }
 EXPORT_SYMBOL(security_secctx_to_secid);
 
@@ -1177,9 +1179,11 @@ int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
 	return security_ops->socket_getpeersec_stream(sock, optval, optlen, len);
 }
 
-int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb, u32 *secid)
+int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb,
+					struct secids *secid)
 {
-	return security_ops->socket_getpeersec_dgram(sock, skb, secid);
+	return security_ops->socket_getpeersec_dgram(sock, skb,
+							&secid->si_lsm[0]);
 }
 EXPORT_SYMBOL(security_socket_getpeersec_dgram);
 
@@ -1421,10 +1425,11 @@ void security_audit_rule_free(void *lsmrule)
 	security_ops->audit_rule_free(lsmrule);
 }
 
-int security_audit_rule_match(u32 secid, u32 field, u32 op, void *lsmrule,
+int security_audit_rule_match(struct secids *secid, u32 field, u32 op, void *lsmrule,
 			      struct audit_context *actx)
 {
-	return security_ops->audit_rule_match(secid, field, op, lsmrule, actx);
+	return security_ops->audit_rule_match(secid->si_lsm[0], field, op,
+						lsmrule, actx);
 }
 
 #endif /* CONFIG_AUDIT */


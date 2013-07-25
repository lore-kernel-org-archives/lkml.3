Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633Ab3GYSdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:33:12 -0400
Received: from smtp107.biz.mail.gq1.yahoo.com ([98.137.12.182]:20799 "HELO
	smtp107.biz.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757474Ab3GYSc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 14:32:57 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: UgYgwEkVM1nsiORS8ZKdgF0af9wXFa4c7kwdzQrjG_XR7ja
 .S20fllidfPs2SzEydfvQQSWzLy8TiUdyw0edwkzr.Qdo7DdMTA_ZaE6.BSR
 NHmcHzPdSwSMppxJjJcjnDpEAWIu97GF2Ut5KND8BEyUt5eFljx8lFRzaTwd
 lw7PP0VnRPG8t2nQzWQKMm7iTSvRPmwqArtu7F85XFsLVyJi.58Cn3_xVPFU
 ygnLFWS1NiNnQ16fzTaa0o8tcanOaK6hTGpdmoSVcn6IDkV1gK8s4GOSlq4E
 KFwCGg6_MeZqO6oh_PkZ3h7OQWIIKmyva0g1.a89bMDJfQrq.niFlrHvbeuo
 5l_FcA4l81OmON781wQJ.oSeUSqBJVHt0CTifeMpuz78jJbR4mfHcBJcsaoJ
 LfqW.mlNcZX1FqB_WIRPkp495vbPov08m49H54CGeX7EEPif3M1JIU3fGfWk
 NwMHgwqFF0tDaR.yxe7rvbIMpyCGqanUSu.F9MXL6QrpALYtqmnQZtOYeW_7
 u4O5kIJBs2d4w9vJjy1eOO9dg6LbkZnnFvqp.pa_hxqSvnllJ_x3ozLCy1s4
 pOHz7_xT4feLX9mw7n.9XZCZ2V2z4LDaIu88yaj_kmOaGt.A-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with )
        by smtp107.biz.mail.gq1.yahoo.com with SMTP; 25 Jul 2013 18:32:11 +0000 UTC
Message-ID: <51F16F2B.5020606@schaufler-ca.com>
Date: Thu, 25 Jul 2013 11:32:11 -0700
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
Subject: [PATCH v14 3/6] LSM: Explicit individual LSM associations
References: <51F16CFB.6040603@schaufler-ca.com>
In-Reply-To: <51F16CFB.6040603@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH v14 3/6] LSM: Explicit individual LSM associations

Expand the /proc/.../attr interface set to help include
LSM specific entries as well as the traditional shared
"current", "prev" and "exec" entries. Each LSM that uses
one of the traditional interfaces gets it's own interface
prefixed with the LSM name for the ones it cares about.
Thus, we have "smack.current", "selinux.current" and
"apparmor.current" in addition to "current". 

Add two new interfaces under /sys/kernel/security.
The lsm interface displays the comma seperated list of
active LSMs. The present interface displays the name
of the LSM providing the traditional /proc/.../attr
interfaces. User space code should no longer have to
grub around in odd places to determine what LSM is
being used and thus what data is available to it.

Introduce feature specific security operation vectors
for NetLabel, XFRM, secmark and presentation in the
traditional /proc/.../attr interfaces. This allows
proper handling of secids.

Add NetLabel interfaces that allow an LSM to request
ownership of the NetLabel subsystem and to determine
whether or not it has that ownership. These interfaces
are intended to allow a future in which NetLabel can
support multiple LSMs at the same time, although they
do not do so now.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---
 drivers/usb/core/devio.c                           |    2 +-
 fs/proc/base.c                                     |   30 ++++-
 include/linux/lsm.h                                |   57 ++++++++--
 include/linux/security.h                           |   14 +++
 include/net/netlabel.h                             |   10 +-
 include/net/xfrm.h                                 |    2 +-
 kernel/audit.c                                     |    2 +-
 kernel/auditsc.c                                   |    2 +-
 kernel/signal.c                                    |    2 +-
 net/ipv4/cipso_ipv4.c                              |    2 +-
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |    2 +-
 net/netfilter/nf_conntrack_netlink.c               |    4 +-
 net/netfilter/nf_conntrack_standalone.c            |    2 +-
 net/netlabel/netlabel_kapi.c                       |   47 +++++++-
 net/netlabel/netlabel_unlabeled.c                  |   11 +-
 security/apparmor/lsm.c                            |    1 +
 security/inode.c                                   |   73 +++++++++++-
 security/security.c                                |  116 ++++++++++++++++++--
 security/selinux/hooks.c                           |   12 +-
 security/selinux/netlabel.c                        |    4 +-
 security/smack/smack_lsm.c                         |   91 ++++++++-------
 security/smack/smackfs.c                           |   12 +-
 22 files changed, 403 insertions(+), 95 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index ab26dc4..f79c733 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -497,7 +497,7 @@ static void async_completed(struct urb *urb)
 	const struct cred *cred = NULL;
 	int signr;
 
-	lsm_init_secid(&secid, 0, 0);
+	lsm_init_secid(&secid, 0, -1);
 	spin_lock(&ps->lock);
 	list_move_tail(&as->asynclist, &ps->async_completed);
 	as->status = urb->status;
diff --git a/fs/proc/base.c b/fs/proc/base.c
index c3834da..3018f3d 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2354,12 +2354,30 @@ static const struct file_operations proc_pid_attr_operations = {
 };
 
 static const struct pid_entry attr_dir_stuff[] = {
-	REG("current",    S_IRUGO|S_IWUGO, proc_pid_attr_operations),
-	REG("prev",       S_IRUGO,	   proc_pid_attr_operations),
-	REG("exec",       S_IRUGO|S_IWUGO, proc_pid_attr_operations),
-	REG("fscreate",   S_IRUGO|S_IWUGO, proc_pid_attr_operations),
-	REG("keycreate",  S_IRUGO|S_IWUGO, proc_pid_attr_operations),
-	REG("sockcreate", S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("current",            S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("prev",               S_IRUGO,	   proc_pid_attr_operations),
+	REG("exec",               S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("fscreate",           S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("keycreate",          S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("sockcreate",         S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("context",            S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+#ifdef CONFIG_SECURITY_SELINUX
+	REG("selinux.current",    S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("selinux.prev",       S_IRUGO,         proc_pid_attr_operations),
+	REG("selinux.exec",       S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("selinux.fscreate",   S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("selinux.keycreate",  S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("selinux.sockcreate", S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+#endif
+	#ifdef CONFIG_SECURITY_SMACK
+	REG("smack.current",      S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+#endif
+#ifdef CONFIG_SECURITY_APPARMOR
+	REG("apparmor.current",   S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("apparmor.prev",      S_IRUGO,         proc_pid_attr_operations),
+	REG("apparmor.exec",      S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+#endif
+
 };
 
 static int proc_attr_dir_readdir(struct file * filp,
diff --git a/include/linux/lsm.h b/include/linux/lsm.h
index 8576f5b..eb82e6f 100644
--- a/include/linux/lsm.h
+++ b/include/linux/lsm.h
@@ -164,9 +164,18 @@ static inline void lsm_init_secid(struct secids *secid, u32 lsecid, int order)
 {
 	memset(secid, 0, sizeof(*secid));
 
-	if (lsecid != 0)
+	if (lsecid == 0)
+		return;
+	/*
+	 * An order of -1 means set it for all LSMs.
+	 */
+	if (order < 0) {
+		secid->si_lsm[0] = lsecid;
+		secid->si_count++;
+	} else {
+		secid->si_lsm[order] = lsecid;
 		secid->si_count = 1;
-	secid->si_lsm[order] = lsecid;
+	}
 }
 
 static inline int lsm_zero_secid(struct secids *secid)
@@ -178,39 +187,64 @@ static inline int lsm_zero_secid(struct secids *secid)
 
 #ifdef CONFIG_SECURITY
 
+extern struct security_operations *present_ops;
 static inline struct security_operations *lsm_present_ops(void)
 {
-	return security_ops;
+	return present_ops;
 }
 
 static inline int lsm_present_order(void)
 {
-	return 0;
+	return present_ops->order;
 }
 
+#ifdef CONFIG_NETLABEL
+extern struct security_operations *netlbl_ops;
+
 static inline struct security_operations *lsm_netlbl_ops(void)
 {
-	return security_ops;
+	return netlbl_ops;
 }
 
 static inline int lsm_netlbl_order(void)
 {
-	return 0;
+	return netlbl_ops->order;
 }
+#endif /* CONFIG_NETLABEL */
+
+#ifdef CONFIG_SECURITY_NETWORK_XFRM
+extern struct security_operations *xfrm_ops;
 
 static inline struct security_operations *lsm_xfrm_ops(void)
 {
-	return security_ops;
+	return xfrm_ops;
 }
 
 static inline int lsm_xfrm_order(void)
 {
-	return 0;
+	return xfrm_ops->order;
 }
+#endif /* CONFIG_SECURITY_NETWORK_XFRM */
+
+#ifdef CONFIG_NETWORK_SECMARK
+extern struct security_operations *secmark_ops;
 
 static inline struct security_operations *lsm_secmark_ops(void)
 {
-	return security_ops;
+	return secmark_ops;
+}
+
+static inline int lsm_secmark_order(void)
+{
+	return secmark_ops->order;
+}
+#endif /* CONFIG_NETWORK_SECMARK */
+
+#else /* CONFIG_SECURITY */
+
+static inline int lsm_xfrm_order(void)
+{
+	return 0;
 }
 
 static inline int lsm_secmark_order(void)
@@ -218,6 +252,11 @@ static inline int lsm_secmark_order(void)
 	return 0;
 }
 
+static inline struct security_operations *lsm_secmark_ops(void)
+{
+	return NULL;
+}
+
 #endif /* CONFIG_SECURITY */
 
 #endif /* ! _LINUX_LSM_H */
diff --git a/include/linux/security.h b/include/linux/security.h
index 870e264..2041cda 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -151,6 +151,12 @@ struct request_sock;
 #define LSM_UNSAFE_PTRACE_CAP	4
 #define LSM_UNSAFE_NO_NEW_PRIVS	8
 
+/* Unstackable features */
+#define LSM_FEATURE_PRESENT	0x1
+#define LSM_FEATURE_NETLABEL	0x2
+#define LSM_FEATURE_XFRM	0x4
+#define LSM_FEATURE_SECMARK	0x8
+
 #ifdef CONFIG_MMU
 extern int mmap_min_addr_handler(struct ctl_table *table, int write,
 				 void __user *buffer, size_t *lenp, loff_t *ppos);
@@ -202,6 +208,12 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  * @name:
  *	A string that acts as a unique identifier for the LSM with max number
  *	of characters = SECURITY_NAME_MAX.
+ * @order:
+ *     The numeric order in which this LSM will be invoked.
+ *     Set during LSM initialization. Used to identify
+ *     which security blob to use when there is more than one LSM.
+ * @features:
+ *     Indicates which of the unshared facilities this LSM supports.
  *
  * Security hooks for program execution operations.
  *
@@ -1411,6 +1423,8 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  */
 struct security_operations {
 	char name[SECURITY_NAME_MAX + 1];
+	int order;
+	int features;
 
 	int (*ptrace_access_check) (struct task_struct *child, unsigned int mode);
 	int (*ptrace_traceme) (struct task_struct *parent);
diff --git a/include/net/netlabel.h b/include/net/netlabel.h
index e84fbb5..791cd89 100644
--- a/include/net/netlabel.h
+++ b/include/net/netlabel.h
@@ -407,7 +407,9 @@ int netlbl_secattr_catmap_setrng(struct netlbl_lsm_secattr_catmap *catmap,
 /*
  * LSM protocol operations (NetLabel LSM/kernel API)
  */
-int netlbl_enabled(void);
+int netlbl_enabled(struct security_operations *lsm);
+int netlbl_lsm_owner(struct security_operations *lsm);
+int netlbl_lsm_register(struct security_operations *lsm);
 int netlbl_sock_setattr(struct sock *sk,
 			u16 family,
 			const struct netlbl_lsm_secattr *secattr);
@@ -521,7 +523,11 @@ static inline int netlbl_secattr_catmap_setrng(
 {
 	return 0;
 }
-static inline int netlbl_enabled(void)
+static inline int netlbl_lsm_register(struct security_operations *lsm)
+{
+	return 0;
+}
+static inline int netlbl_enabled(struct security_operations *lsm)
 {
 	return 0;
 }
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 49824d5..b4d4231 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -705,7 +705,7 @@ static inline void xfrm_audit_helper_usrinfo(kuid_t auid, u32 ses, u32 secid,
 
 	audit_log_format(audit_buf, " auid=%u ses=%u",
 			 from_kuid(&init_user_ns, auid), ses);
-	lsm_init_secid(&secids, secid, 0);
+	lsm_init_secid(&secids, secid, lsm_xfrm_order());
 	if (secid != 0 &&
 	    security_secid_to_secctx(&secids, &secctx, &secctx_len,
 					&sop) == 0) {
diff --git a/kernel/audit.c b/kernel/audit.c
index 3d55ca0..00f3d36 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1733,7 +1733,7 @@ void audit_log_secctx(struct audit_buffer *ab, u32 secid)
 	struct secids secids;
 	struct security_operations *sop;
 
-	lsm_init_secid(&secids, secid, 0);
+	lsm_init_secid(&secids, secid, lsm_secmark_order());
 	if (security_secid_to_secctx(&secids, &secctx, &len, &sop)) {
 		audit_panic("Cannot convert secid to context");
 	} else {
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 0bab5c5..a1620f5 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1542,7 +1542,7 @@ void __audit_syscall_exit(int success, long return_code)
 	context->aux = NULL;
 	context->aux_pids = NULL;
 	context->target_pid = 0;
-	lsm_init_secid(&context->target_sid, 0, 0);
+	lsm_init_secid(&context->target_sid, 0, -1);
 	context->sockaddr_len = 0;
 	context->type = 0;
 	context->fds[0] = -1;
diff --git a/kernel/signal.c b/kernel/signal.c
index ce19c78..6d3da58 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -818,7 +818,7 @@ static int check_kill_permission(int sig, struct siginfo *info,
 		}
 	}
 
-	lsm_init_secid(&secid, 0, 0);
+	lsm_init_secid(&secid, 0, -1);
 	return security_task_kill(t, info, sig, &secid);
 }
 
diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 00a2b2b..5ca352b 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -1594,7 +1594,7 @@ static int cipso_v4_parsetag_loc(const struct cipso_v4_doi *doi_def,
 	u32 secid;
 
 	secid = *(u32 *)&tag[2];
-	lsm_init_secid(&secattr->attr.secid, secid, 0);
+	lsm_init_secid(&secattr->attr.secid, secid, lsm_netlbl_order());
 	secattr->flags |= NETLBL_SECATTR_SECID;
 
 	return 0;
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
index 8f73bfb..8ce7e3d 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
@@ -103,7 +103,7 @@ static int ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 	struct secids secid;
 	struct security_operations *sop;
 
-	lsm_init_secid(&secid, ct->secmark, 0);
+	lsm_init_secid(&secid, ct->secmark, lsm_secmark_order());
 	ret = security_secid_to_secctx(&secid, &secctx, &len, &sop);
 	if (ret)
 		return 0;
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index e240d22..b167205 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -305,7 +305,7 @@ ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 	struct secids secid;
 	struct security_operations *sop;
 
-	lsm_init_secid(&secid, ct->secmark, 0);
+	lsm_init_secid(&secid, ct->secmark, lsm_secmark_order());
 	ret = security_secid_to_secctx(&secid, &secctx, &len, &sop);
 	if (ret)
 		return 0;
@@ -555,7 +555,7 @@ ctnetlink_secctx_size(const struct nf_conn *ct)
 	struct secids secid;
 	struct security_operations *sop;
 
-	lsm_init_secid(&secid, ct->secmark, 0);
+	lsm_init_secid(&secid, ct->secmark, lsm_secmark_order());
 	ret = security_secid_to_secctx(&secid, NULL, &len, &sop);
 	if (ret)
 		return 0;
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 8b19091..e04dfb0 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -128,7 +128,7 @@ static int ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 	struct secids secid;
 	struct security_operations *sop;
 
-	lsm_init_secid(&secid, ct->secmark, 0);
+	lsm_init_secid(&secid, ct->secmark, lsm_secmark_order());
 	ret = security_secid_to_secctx(&secid, &secctx, &len, &sop);
 	if (ret)
 		return 0;
diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
index 7c94aed..bd5fee6 100644
--- a/net/netlabel/netlabel_kapi.c
+++ b/net/netlabel/netlabel_kapi.c
@@ -608,6 +608,47 @@ int netlbl_secattr_catmap_setrng(struct netlbl_lsm_secattr_catmap *catmap,
  */
 
 /**
+ * netlbl_lsm_register - Reserve the NetLabel subsystem for an LSM
+ * @lsm: the security module making the request
+ *
+ * Description:
+ * To avoid potential conflicting views between LSMs over
+ * what should go in the network label reserve the Netlabel
+ * mechanism for use by one LSM. netlbl_enabled will return
+ * false for all other LSMs.
+ *
+ */
+int netlbl_lsm_register(struct security_operations *lsm)
+{
+	if (lsm == NULL)
+		return -EINVAL;
+
+	if (lsm_netlbl_ops() == NULL)
+		netlbl_ops = lsm;
+	else if (lsm_netlbl_ops() != lsm)
+		return -EBUSY;
+
+	printk(KERN_INFO "NetLabel: Registered LSM \"%s\".\n", lsm->name);
+	return 0;
+}
+
+/**
+ * netlbl_lsm_owner - Report if the NetLabel subsystem is registered for an LSM
+ * @lsm: the security module making the request
+ *
+ * Description:
+ * Report whether the LSM passed is the LSM registered for NetLabel
+ *
+ * Returns 1 if this is the registered NetLabel LSM, 0 otherwise
+ */
+int netlbl_lsm_owner(struct security_operations *lsm)
+{
+	if (lsm_netlbl_ops() == lsm)
+		return 1;
+	return 0;
+}
+
+/**
  * netlbl_enabled - Determine if the NetLabel subsystem is enabled
  *
  * Description:
@@ -619,8 +660,12 @@ int netlbl_secattr_catmap_setrng(struct netlbl_lsm_secattr_catmap *catmap,
  * be disabled.
  *
  */
-int netlbl_enabled(void)
+int netlbl_enabled(struct security_operations *lsm)
 {
+	if (lsm_netlbl_ops() == NULL)
+		return 0;
+	if (lsm_netlbl_ops() != lsm)
+		return 0;
 	/* At some point we probably want to expose this mechanism to the user
 	 * as well so that admins can toggle NetLabel regardless of the
 	 * configuration */
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index 3e9064a..be4e083 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -263,7 +263,7 @@ static int netlbl_unlhsh_add_addr4(struct netlbl_unlhsh_iface *iface,
 	entry->list.addr = addr->s_addr & mask->s_addr;
 	entry->list.mask = mask->s_addr;
 	entry->list.valid = 1;
-	lsm_init_secid(&entry->secid, secid, 0);
+	lsm_init_secid(&entry->secid, secid, lsm_netlbl_order());
 
 	spin_lock(&netlbl_unlhsh_lock);
 	ret_val = netlbl_af4list_add(&entry->list, &iface->addr4_list);
@@ -307,7 +307,7 @@ static int netlbl_unlhsh_add_addr6(struct netlbl_unlhsh_iface *iface,
 	entry->list.addr.s6_addr32[3] &= mask->s6_addr32[3];
 	entry->list.mask = *mask;
 	entry->list.valid = 1;
-	lsm_init_secid(&entry->secid, secid, 0);
+	lsm_init_secid(&entry->secid, secid, lsm_netlbl_order());
 
 	spin_lock(&netlbl_unlhsh_lock);
 	ret_val = netlbl_af6list_add(&entry->list, &iface->addr6_list);
@@ -460,7 +460,7 @@ int netlbl_unlhsh_add(struct net *net,
 unlhsh_add_return:
 	rcu_read_unlock();
 	if (audit_buf != NULL) {
-		lsm_init_secid(&secids, secid, 0);
+		lsm_init_secid(&secids, secid, lsm_netlbl_order());
 		if (security_secid_to_secctx(&secids,
 					     &secctx,
 					     &secctx_len, &sop) == 0) {
@@ -1099,7 +1099,7 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 	struct netlbl_unlhsh_walk_arg *cb_arg = arg;
 	struct net_device *dev;
 	void *data;
-	struct secids *secid;
+	const struct secids *secid;
 	char *secctx;
 	u32 secctx_len;
 	struct security_operations *sop;
@@ -1161,7 +1161,8 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 		secid = &addr6->secid;
 	}
 
-	ret_val = security_secid_to_secctx(secid, &secctx, &secctx_len, &sop);
+	ret_val = security_secid_to_secctx((struct secids *)secid, &secctx,
+						&secctx_len, &sop);
 	if (ret_val != 0)
 		goto list_cb_failure;
 	ret_val = nla_put(cb_arg->skb,
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index c9c463b..709b2d7 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -604,6 +604,7 @@ static int apparmor_task_setrlimit(struct task_struct *task,
 
 struct security_operations apparmor_ops = {
 	.name =				"apparmor",
+	.features =			LSM_FEATURE_PRESENT,
 
 	.ptrace_access_check =		apparmor_ptrace_access_check,
 	.ptrace_traceme =		apparmor_ptrace_traceme,
diff --git a/security/inode.c b/security/inode.c
index 43ce6e1..27157b4 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -20,6 +20,7 @@
 #include <linux/init.h>
 #include <linux/namei.h>
 #include <linux/security.h>
+#include <linux/lsm.h>
 #include <linux/magic.h>
 
 static struct vfsmount *mount;
@@ -215,6 +216,66 @@ void securityfs_remove(struct dentry *dentry)
 }
 EXPORT_SYMBOL_GPL(securityfs_remove);
 
+#ifdef CONFIG_SECURITY
+static struct dentry *lsm_dentry;
+static ssize_t lsm_read(struct file *filp, char __user *buf, size_t count,
+			loff_t *ppos)
+{
+	struct security_operations *sop = lsm_present_ops();
+	char *data;
+	int len;
+
+	data = kzalloc(SECURITY_NAME_MAX + 1, GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
+	strcat(data, sop->name);
+	strcat(data, "\n");
+	len = strlen(data);
+
+	len = simple_read_from_buffer(buf, count, ppos, data, len + 1);
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
+	struct security_operations *sop = lsm_present_ops();
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
+static const struct file_operations presentfile_ops = {
+	.read = present_read,
+	.llseek = generic_file_llseek,
+};
+#endif /* CONFIG_SECURITY */
+
 static struct kobject *security_kobj;
 
 static int __init securityfs_init(void)
@@ -226,9 +287,17 @@ static int __init securityfs_init(void)
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
+							&lsm_ops);
+	present_dentry = securityfs_create_file("present", S_IRUGO, NULL, NULL,
+							&presentfile_ops);
+#endif /* CONFIG_SECURITY */
+	return 0;
 }
 
 core_initcall(securityfs_init);
diff --git a/security/security.c b/security/security.c
index 8e5a77d..9c87a4b 100644
--- a/security/security.c
+++ b/security/security.c
@@ -26,6 +26,9 @@
 #include <linux/personality.h>
 #include <linux/backing-dev.h>
 #include <net/flow.h>
+#ifdef CONFIG_NETLABEL
+#include <net/netlabel.h>
+#endif
 
 #define MAX_LSM_EVM_XATTR	2
 
@@ -33,7 +36,25 @@
 static __initdata char chosen_lsm[SECURITY_NAME_MAX + 1] =
 	CONFIG_DEFAULT_SECURITY;
 
+#ifdef CONFIG_SECURITY_NETWORK_XFRM
+struct security_operations *xfrm_ops;
+EXPORT_SYMBOL(xfrm_ops);
+#endif /* CONFIG_SECURITY_NETWORK_XFRM */
+#ifdef CONFIG_NETLABEL
+struct security_operations *netlbl_ops;
+#endif /* CONFIG_NETLABEL */
+#ifdef CONFIG_NETWORK_SECMARK
+struct security_operations *secmark_ops;
+EXPORT_SYMBOL(secmark_ops);
+#endif /* CONFIG_NETWORK_SECMARK */
+
 struct security_operations *security_ops;
+
+struct security_operations *present_ops;
+static int (*present_getprocattr)
+	(struct task_struct *p, char *name, char **value);
+static int (*present_setprocattr)
+	(struct task_struct *p, char *name, void *value, size_t size);
 EXPORT_SYMBOL(security_ops);
 
 static struct security_operations default_security_ops = {
@@ -66,12 +87,31 @@ static void __init do_security_initcalls(void)
  */
 int __init security_init(void)
 {
+#ifdef CONFIG_NETLABEL
+	int rc;
+#endif
+
 	printk(KERN_INFO "Security Framework initialized\n");
 
 	security_fixup_ops(&default_security_ops);
 	security_ops = &default_security_ops;
 	do_security_initcalls();
 
+	present_ops = security_ops;
+	present_getprocattr = present_ops->getprocattr;
+	present_setprocattr = present_ops->setprocattr;
+#ifdef CONFIG_SECURITY_NETWORK_XFRM
+	xfrm_ops = security_ops;
+#endif
+#ifdef CONFIG_NETLABEL
+	rc = netlbl_lsm_register(security_ops);
+	if (rc < 0)
+		printk(KERN_INFO "NetLabel registration error %d\n", -rc);
+#endif
+#ifdef CONFIG_NETWORK_SECMARK
+	secmark_ops = security_ops;
+#endif
+
 	return 0;
 }
 
@@ -707,7 +747,7 @@ void security_inode_getsecid(const struct inode *inode, struct secids *secid)
 	u32 sid;
 
 	security_ops->inode_getsecid(inode, &sid);
-	lsm_init_secid(secid, sid, 0);
+	lsm_init_secid(secid, sid, -1);
 }
 
 int security_file_permission(struct file *file, int mask)
@@ -921,7 +961,7 @@ void security_task_getsecid(struct task_struct *p, struct secids *secid)
 	u32 sid;
 
 	security_ops->task_getsecid(p, &sid);
-	lsm_init_secid(secid, sid, 0);
+	lsm_init_secid(secid, sid, -1);
 }
 EXPORT_SYMBOL(security_task_getsecid);
 
@@ -1011,7 +1051,7 @@ void security_ipc_getsecid(struct kern_ipc_perm *ipcp, struct secids *secid)
 	u32 sid;
 
 	security_ops->ipc_getsecid(ipcp, &sid);
-	lsm_init_secid(secid, sid, 0);
+	lsm_init_secid(secid, sid, -1);
 }
 
 int security_msg_msg_alloc(struct msg_msg *msg)
@@ -1045,13 +1085,13 @@ int security_msg_queue_msgctl(struct msg_queue *msq, int cmd)
 }
 
 int security_msg_queue_msgsnd(struct msg_queue *msq,
-			       struct msg_msg *msg, int msqflg)
+			      struct msg_msg *msg, int msqflg)
 {
 	return security_ops->msg_queue_msgsnd(msq, msg, msqflg);
 }
 
 int security_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg,
-			       struct task_struct *target, long type, int mode)
+			      struct task_struct *target, long type, int mode)
 {
 	return security_ops->msg_queue_msgrcv(msq, msg, target, type, mode);
 }
@@ -1117,12 +1157,70 @@ EXPORT_SYMBOL(security_d_instantiate);
 
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
+	if (present_ops && !strchr(name, '.'))
+		return present_getprocattr(p, name, value);
+
+	sop = security_ops;
+	lsm = sop->name;
+	lsmlen = strlen(lsm);
+	if (!strncmp(name, lsm, lsmlen) && name[lsmlen] == '.')
+		return sop->getprocattr(p, name + lsmlen + 1, value);
+	return -EINVAL;
 }
 
 int security_setprocattr(struct task_struct *p, char *name, void *value, size_t size)
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
+	if (present_ops && !strchr(name, '.'))
+		return present_setprocattr(p, name, value, size);
+
+	sop = present_ops;
+	lsm = sop->name;
+	lsmlen = strlen(lsm);
+	if (!strncmp(name, lsm, lsmlen) && name[lsmlen] == '.')
+		return sop->setprocattr(p, name + lsmlen + 1, value, size);
+	return -EINVAL;
 }
 
 int security_netlink_send(struct sock *sk, struct sk_buff *skb)
@@ -1150,7 +1248,7 @@ int security_secctx_to_secid(const char *secdata, u32 seclen,
 	int rc;
 
 	rc = security_ops->secctx_to_secid(secdata, seclen, &sid);
-	lsm_init_secid(secid, sid, 0);
+	lsm_init_secid(secid, sid, -1);
 	return rc;
 }
 EXPORT_SYMBOL(security_secctx_to_secid);
@@ -1282,7 +1380,7 @@ int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb,
 	int rc;
 
 	rc = security_ops->socket_getpeersec_dgram(sock, skb, &sid);
-	lsm_init_secid(secid, sid, 0);
+	lsm_init_secid(secid, sid, -1);
 	return rc;
 }
 EXPORT_SYMBOL(security_socket_getpeersec_dgram);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 42b4bbb..71f14bf 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4159,7 +4159,7 @@ static int selinux_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 		return selinux_sock_rcv_skb_compat(sk, skb, family);
 
 	secmark_active = selinux_secmark_enabled();
-	peerlbl_active = netlbl_enabled() || selinux_xfrm_enabled();
+	peerlbl_active = netlbl_enabled(&selinux_ops) || selinux_xfrm_enabled();
 	if (!secmark_active && !peerlbl_active)
 		return 0;
 
@@ -4542,7 +4542,7 @@ static unsigned int selinux_ip_forward(struct sk_buff *skb, int ifindex,
 		return NF_ACCEPT;
 
 	secmark_active = selinux_secmark_enabled();
-	netlbl_active = netlbl_enabled();
+	netlbl_active = netlbl_enabled(&selinux_ops);
 	peerlbl_active = netlbl_active || selinux_xfrm_enabled();
 	if (!secmark_active && !peerlbl_active)
 		return NF_ACCEPT;
@@ -4607,7 +4607,7 @@ static unsigned int selinux_ip_output(struct sk_buff *skb,
 {
 	u32 sid;
 
-	if (!netlbl_enabled())
+	if (!netlbl_enabled(&selinux_ops))
 		return NF_ACCEPT;
 
 	/* we do this in the LOCAL_OUT path and not the POST_ROUTING path
@@ -4696,7 +4696,7 @@ static unsigned int selinux_ip_postroute(struct sk_buff *skb, int ifindex,
 		return NF_ACCEPT;
 #endif
 	secmark_active = selinux_secmark_enabled();
-	peerlbl_active = netlbl_enabled() || selinux_xfrm_enabled();
+	peerlbl_active = netlbl_enabled(&selinux_ops) || selinux_xfrm_enabled();
 	if (!secmark_active && !peerlbl_active)
 		return NF_ACCEPT;
 
@@ -5511,6 +5511,10 @@ static int selinux_key_getsecurity(struct key *key, char **_buffer)
 
 struct security_operations selinux_ops = {
 	.name =				"selinux",
+	.features =			LSM_FEATURE_PRESENT |
+					LSM_FEATURE_NETLABEL |
+					LSM_FEATURE_XFRM |
+					LSM_FEATURE_SECMARK,
 
 	.ptrace_access_check =		selinux_ptrace_access_check,
 	.ptrace_traceme =		selinux_ptrace_traceme,
diff --git a/security/selinux/netlabel.c b/security/selinux/netlabel.c
index 63154c6..43504ea 100644
--- a/security/selinux/netlabel.c
+++ b/security/selinux/netlabel.c
@@ -180,7 +180,7 @@ int selinux_netlbl_skbuff_getsid(struct sk_buff *skb,
 	int rc;
 	struct netlbl_lsm_secattr secattr;
 
-	if (!netlbl_enabled()) {
+	if (!netlbl_enabled(&selinux_ops)) {
 		*sid = SECSID_NULL;
 		return 0;
 	}
@@ -351,7 +351,7 @@ int selinux_netlbl_sock_rcv_skb(struct sk_security_struct *sksec,
 	u32 perm;
 	struct netlbl_lsm_secattr secattr;
 
-	if (!netlbl_enabled())
+	if (!netlbl_enabled(&selinux_ops))
 		return 0;
 
 	netlbl_secattr_init(&secattr);
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 7b9131a..c91d32c 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1780,6 +1780,8 @@ static int smack_netlabel(struct sock *sk, int labeled)
 	struct socket_smack *ssp = lsm_get_sock(sk, &smack_ops);
 	int rc = 0;
 
+	if (!netlbl_lsm_owner(&smack_ops))
+		return 0;
 	/*
 	 * Usually the netlabel code will handle changing the
 	 * packet labeling based on the label.
@@ -2861,7 +2863,7 @@ static int smack_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 {
 	struct netlbl_lsm_secattr secattr;
 	struct socket_smack *ssp = lsm_get_sock(sk, &smack_ops);
-	char *csp;
+	char *csp = smack_net_ambient;
 	int rc;
 	struct smk_audit_info ad;
 #ifdef CONFIG_AUDIT
@@ -2873,15 +2875,14 @@ static int smack_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	/*
 	 * Translate what netlabel gave us.
 	 */
-	netlbl_secattr_init(&secattr);
-
-	rc = netlbl_skbuff_getattr(skb, sk->sk_family, &secattr);
-	if (rc == 0)
-		csp = smack_from_secattr(&secattr, ssp);
-	else
-		csp = smack_net_ambient;
+	if (netlbl_lsm_owner(&smack_ops)) {
+		netlbl_secattr_init(&secattr);
+		rc = netlbl_skbuff_getattr(skb, sk->sk_family, &secattr);
+		if (rc == 0)
+			csp = smack_from_secattr(&secattr, ssp);
+		netlbl_secattr_destroy(&secattr);
+	}
 
-	netlbl_secattr_destroy(&secattr);
 
 #ifdef CONFIG_AUDIT
 	smk_ad_init_net(&ad, __func__, LSM_AUDIT_DATA_NET, &net);
@@ -2896,7 +2897,7 @@ static int smack_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	 * for networking.
 	 */
 	rc = smk_access(csp, ssp->smk_in, MAY_WRITE, &ad);
-	if (rc != 0)
+	if (rc != 0 && netlbl_lsm_owner(&smack_ops))
 		netlbl_skbuff_err(skb, rc, 0);
 	return rc;
 }
@@ -2969,18 +2970,21 @@ static int smack_socket_getpeersec_dgram(struct socket *sock,
 		ssp = lsm_get_sock(sock->sk, &smack_ops);
 		s = smack_to_secid(ssp->smk_out);
 	} else if (family == PF_INET || family == PF_INET6) {
-		/*
-		 * Translate what netlabel gave us.
-		 */
-		if (sock != NULL && sock->sk != NULL)
-			ssp = lsm_get_sock(sock->sk, &smack_ops);
-		netlbl_secattr_init(&secattr);
-		rc = netlbl_skbuff_getattr(skb, family, &secattr);
-		if (rc == 0) {
-			sp = smack_from_secattr(&secattr, ssp);
-			s = smack_to_secid(sp);
-		}
-		netlbl_secattr_destroy(&secattr);
+		if (netlbl_lsm_owner(&smack_ops)) {
+			/*
+			 * Translate what netlabel gave us.
+			 */
+			if (sock != NULL && sock->sk != NULL)
+				ssp = lsm_get_sock(sock->sk, &smack_ops);
+			netlbl_secattr_init(&secattr);
+			rc = netlbl_skbuff_getattr(skb, family, &secattr);
+			if (rc == 0) {
+				sp = smack_from_secattr(&secattr, ssp);
+				s = smack_to_secid(sp);
+			}
+			netlbl_secattr_destroy(&secattr);
+		} else
+			s = smack_to_secid(smack_net_ambient);
 	}
 	*secid = s;
 	if (s == 0)
@@ -3039,13 +3043,16 @@ static int smack_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 	if (family == PF_INET6 && skb->protocol == htons(ETH_P_IP))
 		family = PF_INET;
 
-	netlbl_secattr_init(&secattr);
-	rc = netlbl_skbuff_getattr(skb, family, &secattr);
-	if (rc == 0)
-		sp = smack_from_secattr(&secattr, ssp);
-	else
-		sp = smack_known_huh.smk_known;
-	netlbl_secattr_destroy(&secattr);
+	if (netlbl_lsm_owner(&smack_ops)) {
+		netlbl_secattr_init(&secattr);
+		rc = netlbl_skbuff_getattr(skb, family, &secattr);
+		if (rc == 0)
+			sp = smack_from_secattr(&secattr, ssp);
+		else
+			sp = smack_known_huh.smk_known;
+		netlbl_secattr_destroy(&secattr);
+	} else
+		sp = smack_net_ambient;
 
 #ifdef CONFIG_AUDIT
 	smk_ad_init_net(&ad, __func__, LSM_AUDIT_DATA_NET, &net);
@@ -3072,17 +3079,19 @@ static int smack_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 	 * if we do we only need to label the request_sock and the stack will
 	 * propagate the wire-label to the sock when it is created.
 	 */
-	hdr = ip_hdr(skb);
-	addr.sin_addr.s_addr = hdr->saddr;
-	rcu_read_lock();
-	hsp = smack_host_label(&addr);
-	rcu_read_unlock();
+	if (netlbl_lsm_owner(&smack_ops)) {
+		hdr = ip_hdr(skb);
+		addr.sin_addr.s_addr = hdr->saddr;
+		rcu_read_lock();
+		hsp = smack_host_label(&addr);
+		rcu_read_unlock();
 
-	if (hsp == NULL) {
-		skp = smk_find_entry(sp);
-		rc = netlbl_req_setattr(req, &skp->smk_netlabel);
-	} else
-		netlbl_req_delattr(req);
+		if (hsp == NULL) {
+			skp = smk_find_entry(sp);
+			rc = netlbl_req_setattr(req, &skp->smk_netlabel);
+		} else
+			netlbl_req_delattr(req);
+	}
 
 	return rc;
 }
@@ -3367,6 +3376,8 @@ static int smack_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen)
 
 struct security_operations smack_ops = {
 	.name =				"smack",
+	.features =			LSM_FEATURE_PRESENT |
+					LSM_FEATURE_NETLABEL,
 
 	.ptrace_access_check =		smack_ptrace_access_check,
 	.ptrace_traceme =		smack_ptrace_traceme,
@@ -3566,6 +3577,8 @@ static __init int smack_init(void)
 	/* initialize the smack_known_list */
 	init_smack_known_list();
 
+	smack_net_ambient = smack_known_floor.smk_known;
+
 	/*
 	 * Register with LSM
 	 */
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index af7629c..650a0f3 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -165,7 +165,8 @@ static void smk_netlabel_audit_set(struct netlbl_audit *nap)
 {
 	nap->loginuid = audit_get_loginuid(current);
 	nap->sessionid = audit_get_sessionid(current);
-	lsm_init_secid(&nap->secid, smack_to_secid(smk_of_current()), 0);
+	lsm_init_secid(&nap->secid, smack_to_secid(smk_of_current()),
+			lsm_netlbl_order());
 }
 
 /*
@@ -1236,12 +1237,12 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
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
@@ -1250,12 +1251,11 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
 	} else {
 		/* we delete the unlabeled entry, only if the previous label
 		 * wasn't the special CIPSO option */
-		if (skp->smk_label != smack_cipso_option)
+		if (skp->smk_label != smack_cipso_option &&
+		    netlbl_lsm_owner(&smack_ops))
 			rc = netlbl_cfg_unlbl_static_del(&init_net, NULL,
 					&skp->smk_host.sin_addr, &skp->smk_mask,
 					PF_INET, &audit_info);
-		else
-			rc = 0;
 		skp->smk_label = sp;
 	}
 
@@ -1264,7 +1264,7 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
 	 * this host so that incoming packets get labeled.
 	 * but only if we didn't get the special CIPSO option
 	 */
-	if (rc == 0 && sp != smack_cipso_option)
+	if (rc == 0 && sp != smack_cipso_option && netlbl_lsm_owner(&smack_ops))
 		rc = netlbl_cfg_unlbl_static_add(&init_net, NULL,
 			&skp->smk_host.sin_addr, &skp->smk_mask, PF_INET,
 			smack_to_secid(skp->smk_label), &audit_info);


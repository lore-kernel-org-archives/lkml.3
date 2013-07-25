Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745Ab3GYSeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:34:13 -0400
Received: from smtp105.biz.mail.gq1.yahoo.com ([98.137.12.180]:22959 "HELO
	smtp105.biz.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757369Ab3GYScY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 14:32:24 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: zajjwScVM1n5B1BJFfClN5zaQQfOPZpFMUdfJJP8W7xtiAy
 3EY6NMg_GNOYWgBdDocaCP7VT4_qqtXH49ITViOKPBmlCNvgliB51Sdrh7jH
 aC8UEbr4tJ4AT0ue9KEFlFLMcwKNhUqKrORB2McWCwev_Nstjn4QnMbsz.GH
 t6c9hYNq42dF7hmAvJXBLA_t.sXEa5GVFlOT.zJryTsMeU4G1KXRACJdfo4y
 35dBS13K.V9pnnF8X0N77BmcMFYGweOhpOT8rbq8oTpIM.6Bv899rKTHKkNz
 kcdDgXj2BRNXjx2OJTHk0KWdqQQhozuipGaDOW19TURGoXyEJNUqshRkgjSZ
 Dyb7pPo105tFrlEoNh5JBQzN62Fidb7S3aDpjYB8LKUHLj.DztTTKTE893kd
 7m.yg.sZF6Cu9iizPFMGHKVZ32iSqR52RnnXzLfPSytMvnMMOAm.XZvGwO.m
 FIOsL6HOYbIH.926X5A9wAaX9JoO2pTfnwb2gcJPGOzs.U26Jemy5v9C8lmU
 wUYUw_ZSFY5lUFKIOJlj7a1c5vyqkN.ajLcXdkGym0W6tZJF4mEBCXQWhwbb
 TvVRgTW9D7urIQtkCaEfc4Uz.FXb0GBOUZA--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with )
        by smtp105.biz.mail.gq1.yahoo.com with SMTP; 25 Jul 2013 11:32:23 -0700 PDT
Message-ID: <51F16F37.6040708@schaufler-ca.com>
Date: Thu, 25 Jul 2013 11:32:23 -0700
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
Subject: [PATCH v14 5/6] LSM: SO_PEERSEC configuration options
References: <51F16CFB.6040603@schaufler-ca.com>
In-Reply-To: <51F16CFB.6040603@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH v14 5/6] LSM: SO_PEERSEC configuration options

Refine the handling of SO_PEERSEC to enable legacy
user space runtimes, Fedora in particular, when running
with multiple LSMs that are capable of providing information
using getsockopt(). This introduces an additional configuration
option, and requires that the default be the legacy behavior.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---
 include/linux/lsm.h                                |   15 +++++
 include/linux/lsm_audit.h                          |    9 +--
 include/linux/security.h                           |    7 +-
 include/net/scm.h                                  |    2 +-
 include/net/xfrm.h                                 |    2 +-
 kernel/audit.c                                     |    8 +--
 kernel/auditsc.c                                   |    4 +-
 net/ipv4/ip_sockglue.c                             |    2 +-
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |    2 +-
 net/netfilter/nf_conntrack_netlink.c               |    4 +-
 net/netfilter/nf_conntrack_standalone.c            |    2 +-
 net/netlabel/netlabel_unlabeled.c                  |    8 +--
 net/netlabel/netlabel_user.c                       |    2 +-
 security/Kconfig                                   |   52 ++++++++++++---
 security/security.c                                |   70 ++++++++++----------
 security/selinux/hooks.c                           |    2 +-
 security/smack/smack_lsm.c                         |    2 +-
 17 files changed, 120 insertions(+), 73 deletions(-)

diff --git a/include/linux/lsm.h b/include/linux/lsm.h
index 87736ba..9d39526 100644
--- a/include/linux/lsm.h
+++ b/include/linux/lsm.h
@@ -263,6 +263,16 @@ static inline int lsm_secmark_order(void)
 }
 #endif /* CONFIG_NETWORK_SECMARK */
 
+static inline int lsm_peersec_order(void)
+{
+	return peersec_ops->order;
+}
+
+static inline struct security_operations *lsm_peersec_ops(void)
+{
+	return peersec_ops;
+}
+
 #else /* CONFIG_SECURITY */
 
 static inline int lsm_xfrm_order(void)
@@ -280,6 +290,11 @@ static inline struct security_operations *lsm_secmark_ops(void)
 	return NULL;
 }
 
+static inline struct security_operations *lsm_peersec_ops(void)
+{
+	return NULL;
+}
+
 #endif /* CONFIG_SECURITY */
 
 #endif /* ! _LINUX_LSM_H */
diff --git a/include/linux/lsm_audit.h b/include/linux/lsm_audit.h
index 1cc89e9..a575258 100644
--- a/include/linux/lsm_audit.h
+++ b/include/linux/lsm_audit.h
@@ -69,18 +69,15 @@ struct common_audit_data {
 #endif
 		char *kmod_name;
 	} u;
-	/* this union contains LSM specific data */
-	union {
 #ifdef CONFIG_SECURITY_SMACK
-		struct smack_audit_data *smack_audit_data;
+	struct smack_audit_data *smack_audit_data;
 #endif
 #ifdef CONFIG_SECURITY_SELINUX
-		struct selinux_audit_data *selinux_audit_data;
+	struct selinux_audit_data *selinux_audit_data;
 #endif
 #ifdef CONFIG_SECURITY_APPARMOR
-		struct apparmor_audit_data *apparmor_audit_data;
+	struct apparmor_audit_data *apparmor_audit_data;
 #endif
-	}; /* per LSM data pointer union */
 };
 
 #define v4info fam.v4
diff --git a/include/linux/security.h b/include/linux/security.h
index f63edec..3ec3489 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -57,7 +57,11 @@ struct mm_struct;
 #define SECURITY_NAME_MAX	10
 
 /* Maximum number of LSMs that can be used at a time.  */
+#ifdef CONFIG_SECURITY
 #define LSM_SLOTS	CONFIG_SECURITY_LSM_MAX
+#else
+#define LSM_SLOTS	1
+#endif
 #define LSM_NAMES_MAX	((SECURITY_NAME_MAX + 1) * LSM_SLOTS)
 
 /* If capable should audit the security request */
@@ -152,7 +156,7 @@ struct request_sock;
 #define LSM_FEATURE_NETLABEL	0x02
 #define LSM_FEATURE_XFRM	0x04
 #define LSM_FEATURE_SECMARK	0x08
-#define LSM_FEATURE_SECIDS	0x10
+#define LSM_FEATURE_PEERSEC	0x10
 
 #ifdef CONFIG_MMU
 extern int mmap_min_addr_handler(struct ctl_table *table, int write,
@@ -1938,6 +1942,7 @@ extern void __init security_fixup_ops(struct security_operations *ops);
 #ifdef CONFIG_SECURITY_SELINUX_DISABLE
 extern void security_module_disable(struct security_operations *ops);
 #endif /* CONFIG_SECURITY_SELINUX_DISABLE */
+extern struct security_operations *peersec_ops;
 
 /* Security operations */
 int security_ptrace_access_check(struct task_struct *child, unsigned int mode);
diff --git a/include/net/scm.h b/include/net/scm.h
index 5279fb1..f30fa64 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -91,7 +91,7 @@ static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct sc
 	char *secdata;
 	u32 seclen;
 	int err;
-	struct security_operations *sop;
+	struct security_operations *sop = peersec_ops;
 
 	if (test_bit(SOCK_PASSSEC, &sock->flags)) {
 		err = security_secid_to_secctx(&scm->secid, &secdata,
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index b4d4231..7301859 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -701,7 +701,7 @@ static inline void xfrm_audit_helper_usrinfo(kuid_t auid, u32 ses, u32 secid,
 	char *secctx;
 	u32 secctx_len;
 	struct secids secids;
-	struct security_operations *sop;
+	struct security_operations *sop = lsm_peersec_ops();
 
 	audit_log_format(audit_buf, " auid=%u ses=%u",
 			 from_kuid(&init_user_ns, auid), ses);
diff --git a/kernel/audit.c b/kernel/audit.c
index 8bbfbf2..1b82d15 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -640,7 +640,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	struct audit_sig_info   *sig_data;
 	char			*ctx = NULL;
 	u32			len;
-	struct security_operations *sop;
+	struct security_operations *sop = NULL;
 
 	err = audit_netlink_ok(skb, msg_type);
 	if (err)
@@ -1481,7 +1481,7 @@ void audit_copy_inode(struct audit_names *name, const struct dentry *dentry,
 void audit_log_name(struct audit_context *context, struct audit_names *n,
 		    struct path *path, int record_num, int *call_panic)
 {
-	struct security_operations *sop;
+	struct security_operations *sop = NULL;
 	struct audit_buffer *ab;
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_PATH);
 	if (!ab)
@@ -1548,7 +1548,7 @@ int audit_log_task_context(struct audit_buffer *ab)
 	unsigned len;
 	int error;
 	struct secids sid;
-	struct security_operations *sop;
+	struct security_operations *sop = NULL;
 
 	security_task_getsecid(current, &sid);
 	if (lsm_zero_secid(&sid))
@@ -1731,7 +1731,7 @@ void audit_log_secctx(struct audit_buffer *ab, u32 secid)
 	u32 len;
 	char *secctx;
 	struct secids secids;
-	struct security_operations *sop;
+	struct security_operations *sop = lsm_secmark_ops();
 
 	lsm_init_secid(&secids, secid, lsm_secmark_order());
 	if (security_secid_to_secctx(&secids, &secctx, &len, &sop)) {
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 2932ac5..db0feec 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -984,7 +984,7 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 	char *ctx = NULL;
 	u32 len;
 	int rc = 0;
-	struct security_operations *sop;
+	struct security_operations *sop = NULL;
 
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_OBJ_PID);
 	if (!ab)
@@ -1221,7 +1221,7 @@ static void show_special(struct audit_context *context, int *call_panic)
 		if (!lsm_zero_secid(osid)) {
 			char *ctx = NULL;
 			u32 len;
-			struct security_operations *sop;
+			struct security_operations *sop = NULL;
 			if (security_secid_to_secctx(osid, &ctx, &len, &sop)) {
 				audit_log_format(ab, " osc=%u", 0);
 				*call_panic = 1;
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 3986a24..b1dcd34 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -111,7 +111,7 @@ static void ip_cmsg_recv_security(struct msghdr *msg, struct sk_buff *skb)
 	u32 seclen;
 	struct secids secid;
 	int err;
-	struct security_operations *sop;
+	struct security_operations *sop = lsm_peersec_ops();
 
 	err = security_socket_getpeersec_dgram(NULL, skb, &secid);
 	if (err)
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
index 8ce7e3d..881b4fa 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
@@ -101,7 +101,7 @@ static int ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 	u32 len;
 	char *secctx;
 	struct secids secid;
-	struct security_operations *sop;
+	struct security_operations *sop = lsm_secmark_ops();
 
 	lsm_init_secid(&secid, ct->secmark, lsm_secmark_order());
 	ret = security_secid_to_secctx(&secid, &secctx, &len, &sop);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index b167205..34c809e 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -303,7 +303,7 @@ ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 	int len, ret;
 	char *secctx;
 	struct secids secid;
-	struct security_operations *sop;
+	struct security_operations *sop = lsm_secmark_ops();
 
 	lsm_init_secid(&secid, ct->secmark, lsm_secmark_order());
 	ret = security_secid_to_secctx(&secid, &secctx, &len, &sop);
@@ -553,7 +553,7 @@ ctnetlink_secctx_size(const struct nf_conn *ct)
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
 	int len, ret;
 	struct secids secid;
-	struct security_operations *sop;
+	struct security_operations *sop = lsm_secmark_ops();
 
 	lsm_init_secid(&secid, ct->secmark, lsm_secmark_order());
 	ret = security_secid_to_secctx(&secid, NULL, &len, &sop);
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index e04dfb0..cbe5c1b 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -126,7 +126,7 @@ static int ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 	u32 len;
 	char *secctx;
 	struct secids secid;
-	struct security_operations *sop;
+	struct security_operations *sop = lsm_secmark_ops();
 
 	lsm_init_secid(&secid, ct->secmark, lsm_secmark_order());
 	ret = security_secid_to_secctx(&secid, &secctx, &len, &sop);
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index be4e083..31211c9 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -397,7 +397,7 @@ int netlbl_unlhsh_add(struct net *net,
 	struct secids secids;
 	char *secctx = NULL;
 	u32 secctx_len;
-	struct security_operations *sop;
+	struct security_operations *sop = lsm_netlbl_ops();
 
 	if (addr_len != sizeof(struct in_addr) &&
 	    addr_len != sizeof(struct in6_addr))
@@ -498,7 +498,7 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 	struct net_device *dev;
 	char *secctx;
 	u32 secctx_len;
-	struct security_operations *sop;
+	struct security_operations *sop = lsm_netlbl_ops();
 
 	spin_lock(&netlbl_unlhsh_lock);
 	list_entry = netlbl_af4list_remove(addr->s_addr, mask->s_addr,
@@ -561,7 +561,7 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 	struct net_device *dev;
 	char *secctx;
 	u32 secctx_len;
-	struct security_operations *sop;
+	struct security_operations *sop = lsm_netlbl_ops();
 
 	spin_lock(&netlbl_unlhsh_lock);
 	list_entry = netlbl_af6list_remove(addr, mask, &iface->addr6_list);
@@ -1102,7 +1102,7 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 	const struct secids *secid;
 	char *secctx;
 	u32 secctx_len;
-	struct security_operations *sop;
+	struct security_operations *sop = lsm_netlbl_ops();
 
 	data = genlmsg_put(cb_arg->skb, NETLINK_CB(cb_arg->nl_cb->skb).portid,
 			   cb_arg->seq, &netlbl_unlabel_gnl_family,
diff --git a/net/netlabel/netlabel_user.c b/net/netlabel/netlabel_user.c
index 20e3e0d..53b38ce 100644
--- a/net/netlabel/netlabel_user.c
+++ b/net/netlabel/netlabel_user.c
@@ -101,7 +101,7 @@ struct audit_buffer *netlbl_audit_start_common(int type,
 	struct audit_buffer *audit_buf;
 	char *secctx;
 	u32 secctx_len;
-	struct security_operations *sop;
+	struct security_operations *sop = lsm_netlbl_ops();
 
 	if (audit_enabled == 0)
 		return NULL;
diff --git a/security/Kconfig b/security/Kconfig
index c6bedca..b8c9192 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -157,17 +157,49 @@ config SECMARK_LSM
 	help
 	  The name of the LSM to use with the networking secmark
 
-config SECURITY_PLAIN_CONTEXT
-	bool "Backward compatable contexts without lsm='value' formatting"
-	depends on SECURITY_SELINUX || SECURITY_SMACK
-	default y
+choice
+	depends on SECURITY && (SECURITY_SELINUX || SECURITY_SMACK)
+	prompt "Peersec LSM"
+	default PEERSEC_SECURITY_FIRST
+
 	help
-	  Without this value set security context strings will
-	  include the name of the lsm with which they are associated
-	  even if there is only one LSM that uses security contexts.
-	  This matches the way contexts were handled before it was
-	  possible to have multiple concurrent security modules.
-	  If you are unsure how to answer this question, answer Y.
+	  Select the security module that will send attribute
+	  information in IP header options.
+	  Most SELinux configurations do not take advantage
+	  of Netlabel, while all Smack configurations do. Unless
+	  there is a need to do otherwise chose Smack in preference
+	  to SELinux.
+
+	config PEERSEC_SECURITY_FIRST
+		bool "First LSM providing for SO_PEERSEC"
+		help
+		  Provide the first available LSM's information with SO_PEERSEC
+
+	config PEERSEC_SECURITY_ALL
+		bool "Use lsm='value'lsm='value' format"
+		help
+		  Provide all available security information in SO_PEERSEC
+
+	config PEERSEC_SECURITY_SELINUX
+		bool "SELinux" if SECURITY_SELINUX=y
+		help
+		  Provide SELinux context with SO_PEERSEC
+
+	config PEERSEC_SECURITY_SMACK
+		bool "Smack" if SECURITY_SMACK=y
+		help
+		  Provide Smack labels with SO_PEERSEC
+
+endchoice
+
+config PEERSEC_LSM
+	string
+	default "smack" if PEERSEC_SECURITY_SMACK
+	default "selinux" if PEERSEC_SECURITY_SELINUX
+	default "(all)" if PEERSEC_SECURITY_ALL
+	default "(first)"
+	help
+	  The name of the LSM to use with Netlabel
 
 config SECURITY_PATH
 	bool "Security hooks for pathname based access control"
diff --git a/security/security.c b/security/security.c
index 0ef87e5..119a377 100644
--- a/security/security.c
+++ b/security/security.c
@@ -59,10 +59,7 @@ struct security_operations *netlbl_ops;
 struct security_operations *secmark_ops;
 EXPORT_SYMBOL(secmark_ops);
 #endif /* CONFIG_NETWORK_SECMARK */
-#ifdef CONFIG_SECURITY_PLAIN_CONTEXT
-struct security_operations *secid_ops;
-static __initdata int lsm_secid_users;
-#endif /* CONFIG_SECURITY_PLAIN_CONTEXT */
+struct security_operations *peersec_ops;
 struct security_operations *present_ops;
 static int (*present_getprocattr)
 	(struct task_struct *p, char *name, char **value);
@@ -538,6 +535,8 @@ int __init security_module_enable(struct security_operations *ops)
 	 * If a module is specified that does not supply the
 	 * required hooks don't assign the feature to anyone.
 	 *
+	 * CONFIG_PEERSEC_LSM
+	 *      What shows up with SO_PEERSEC
 	 * CONFIG_SECURITY_PRESENT
 	 *      What shows up in /proc/.../attr/current
 	 * CONFIG_NETLABEL_LSM
@@ -547,14 +546,9 @@ int __init security_module_enable(struct security_operations *ops)
 	 * CONFIG_SECMARK_LSM
 	 *      Networking secmark
 	 */
-#ifdef CONFIG_SECURITY_PLAIN_CONTEXT
-	if (ops->features & LSM_FEATURE_SECIDS) {
-		if (++lsm_secid_users == 1)
-			secid_ops = ops;
-		else
-			secid_ops = NULL;
-	}
-#endif
+	if (owns_feature(peersec_ops, ops, CONFIG_PEERSEC_LSM,
+				LSM_FEATURE_PEERSEC))
+		peersec_ops = ops;
 	if (owns_feature(present_ops, ops, CONFIG_PRESENT_SECURITY,
 				LSM_FEATURE_PRESENT)) {
 		present_ops = ops;
@@ -1905,7 +1899,7 @@ EXPORT_SYMBOL(security_d_instantiate);
 
 int security_getprocattr(struct task_struct *p, char *name, char **value)
 {
-	struct security_operations *sop;
+	struct security_operations *sop = NULL;
 	struct secids secid;
 	char *lsm;
 	int lsmlen;
@@ -1984,10 +1978,19 @@ int security_netlink_send(struct sock *sk, struct sk_buff *skb)
 	return call_int_hook(netlink_send, sk, skb);
 }
 
+/*
+ * On input *secops is either the operations for the one LSM
+ * to get the text for or NULL, indicating that the entire set
+ * on security information is desired.
+ *
+ * On exit *secops will contain the operations for the LSM
+ * that allocated the secctx or NULL, indicating that the lsm
+ * infrastructure allocated it.
+ */
 int security_secid_to_secctx(struct secids *secid, char **secdata, u32 *seclen,
 			     struct security_operations **secops)
 {
-	struct security_operations *sop;
+	struct security_operations *sop = *secops;
 	struct security_operations *gotthis = NULL;
 	char *data;
 	char *cp;
@@ -1999,14 +2002,10 @@ int security_secid_to_secctx(struct secids *secid, char **secdata, u32 *seclen,
 	u32 lenmany = 2;
 	int ret = 0;
 
-#ifdef CONFIG_SECURITY_PLAIN_CONTEXT
-	if (secid_ops) {
-		ret = secid_ops->secid_to_secctx(
-			secid->si_lsm[secid_ops->order], secdata, seclen);
-		*secops = secid_ops;
-		return ret;
-	}
-#endif
+	
+	if (sop)
+		return sop->secid_to_secctx(secid->si_lsm[sop->order],
+						secdata, seclen);
 
 	for_each_hook(sop, secid_to_secctx) {
 		ord = sop->order;
@@ -2101,10 +2100,10 @@ int security_secctx_to_secid(const char *secdata, u32 seclen,
 		lsm_set_secid(secid, sid, secops->order);
 		return ret;
 	}
-#ifdef CONFIG_SECURITY_PLAIN_CONTEXT
-	if (secid_ops) {
-		ret = secid_ops->secctx_to_secid(secdata, seclen, &sid);
-		lsm_set_secid(secid, sid, secid_ops->order);
+#ifdef CONFIG_SECURITY_PLAIN_CONTEXT_CBS
+	if (peersec_ops) {
+		ret = peersec_ops->secctx_to_secid(secdata, seclen, &sid);
+		lsm_set_secid(secid, sid, peersec_ops->order);
 		return ret;
 	}
 #endif
@@ -2236,10 +2235,10 @@ int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen,
 	u32 len = 2;
 	int ret = 0;
 
-#ifdef CONFIG_SECURITY_PLAIN_CONTEXT
-	if (secid_ops) {
-		ret = secid_ops->inode_getsecctx(inode, ctx, ctxlen);
-		*secops = secid_ops;
+#ifdef CONFIG_SECURITY_PLAIN_CONTEXT_CBS
+	if (peersec_ops) {
+		ret = peersec_ops->inode_getsecctx(inode, ctx, ctxlen);
+		*secops = peersec_ops;
 		return ret;
 	}
 #endif
@@ -2410,13 +2409,11 @@ int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
 	result = thisval;
 	tp = result + len;
 
-#ifdef CONFIG_SECURITY_PLAIN_CONTEXT
-	if (secid_ops) {
-		ret = secid_ops->socket_getpeersec_stream(sock, result,
+	if (peersec_ops) {
+		ret = peersec_ops->socket_getpeersec_stream(sock, result,
 							&thislen, len);
 		goto sendout;
 	}
-#endif
 
 	for_each_hook(sop, socket_getpeersec_stream) {
 		thisrc = sop->socket_getpeersec_stream(sock, tp, &thislen, len);
@@ -2432,9 +2429,7 @@ int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
 		} else if (thisrc != -ENOPROTOOPT)
 			ret = thisrc;
 	}
-#ifdef CONFIG_SECURITY_PLAIN_CONTEXT
 sendout:
-#endif
 	if (ret == 0) {
 		len = strlen(result) + 1;
 		if (put_user(len, optlen))
@@ -2456,6 +2451,9 @@ int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb,
 
 	lsm_init_secid(secid, 0, -1);
 
+	if (peersec_ops)
+		return peersec_ops->socket_getpeersec_dgram(sock, skb, &sid);
+
 	for_each_hook(sop, socket_getpeersec_dgram) {
 		thisrc = sop->socket_getpeersec_dgram(sock, skb, &sid);
 		lsm_set_secid(secid, sid, sop->order);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index a5d73f1..aa3c024 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5526,7 +5526,7 @@ struct security_operations selinux_ops = {
 					LSM_FEATURE_NETLABEL |
 					LSM_FEATURE_XFRM |
 					LSM_FEATURE_SECMARK |
-					LSM_FEATURE_SECIDS,
+					LSM_FEATURE_PEERSEC,
 
 	.ptrace_access_check =		selinux_ptrace_access_check,
 	.ptrace_traceme =		selinux_ptrace_traceme,
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 22c0041..d96e0b3 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3386,7 +3386,7 @@ struct security_operations smack_ops = {
 	.name =				"smack",
 	.features =			LSM_FEATURE_PRESENT |
 					LSM_FEATURE_NETLABEL |
-					LSM_FEATURE_SECIDS,
+					LSM_FEATURE_PEERSEC,
 
 	.ptrace_access_check =		smack_ptrace_access_check,
 	.ptrace_traceme =		smack_ptrace_traceme,


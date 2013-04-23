Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab3DWQEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:04:38 -0400
Received: from nm15.access.bullet.mail.mud.yahoo.com ([66.94.237.216]:29102
	"EHLO nm15.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932082Ab3DWQEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:04:34 -0400
X-Yahoo-Newman-Id: 712335.68087.bm@smtp103.biz.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 9FQ4aU4VM1nNi_R2NKcQSl3XuRJJDX80JqhfHWITFBUYxng
 TFyQ0JVJaBP6ugxf_ODyGF.LFUJVR5pFg_26GTFKHyj73ziATevPHPVrk7s0
 fbvW_IoWFVr_pcn.CQRbMbc14CNlm_n.Xdtzrf7TohFqwvYdPR8kknC0dU6f
 hnW.3klyXuOq7bgTxc7v524bc2cKf6KIpyn4Lh4rOR1.3GIaB6zcWHPTO_UB
 IU.Zm_vk4I0SeW7NT5YyzqJJlIa8_5WMCDRt4l9do_jgNYPef8PxBXn9a3GH
 9FJGRYVpi5q7ibyN13GaL0uqb5cxYFPso2llpkSU6KSB9v4.Fci9U2r1DcsP
 YcrLqlrwNNmwVEerCjfA8TAVVQ1UY_5qw1MssCbTwbP5VQdcVckaTmJKF1NJ
 U3LfBBMzmrKYOVTsxLBKVGFf0BYIrqX5.NBZHwsPVGAC3EP0ywXqzWbjWWDC
 pXO26R20yEpsNlZazrG7aKAsTM43Vc_NLSXC7OMttS7WnxnR.gVESONBYreT
 hyUkuGT0ERhFEVhVVJjHCvylpCp8gxNHEqUsTGrmcAkXMhXtzYgbjp.2XG9z
 QOkjdMA0zBhFPCgcl1efaEpv5Dth2hXWCYJglbK7bsybNLyjHGv0fvru109i
 DBIU5RwJzUVlhxx_46zqFmUvERNU-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with plain)
        by smtp103.biz.mail.ne1.yahoo.com with SMTP; 23 Apr 2013 09:04:31 -0700 PDT
Message-ID: <5176B10F.9040607@schaufler-ca.com>
Date: Tue, 23 Apr 2013 09:04:31 -0700
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
Subject: [PATCH v13 5/9] LSM: Networking component isolation
References: <5176ABB7.5080300@schaufler-ca.com>
In-Reply-To: <5176ABB7.5080300@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH v13 5/9] LSM: Networking component isolation

The NetLabel, XFRM and secmark networking mechanisms are
limited to providing security information managed by one
LSM. These changes interface the single LSM networking
components with the multiple LSM system. Each of the
networking components will identify the security ops
vector of the LSM that will use it. There are various
wrapper functions provided to make this obvious and
painless.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---
 include/linux/security.h                           |   45 ++++++++++
 include/net/netlabel.h                             |    3 +-
 include/net/xfrm.h                                 |    8 +-
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |    2 +-
 net/netfilter/xt_SECMARK.c                         |    9 +-
 net/netlabel/netlabel_kapi.c                       |   37 ++++++--
 net/netlabel/netlabel_unlabeled.c                  |   56 +++++-------
 net/netlabel/netlabel_user.c                       |   10 +--
 net/netlabel/netlabel_user.h                       |   64 ++++++++++++-
 net/xfrm/xfrm_user.c                               |   44 +++++----
 security/security.c                                |    4 +-
 security/selinux/hooks.c                           |    8 +-
 security/selinux/netlabel.c                        |    4 +-
 security/smack/smack_lsm.c                         |   94 ++++++++++++--------
 security/smack/smackfs.c                           |   34 ++++++-
 15 files changed, 282 insertions(+), 140 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 4430b09..da0fc7f 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1690,6 +1690,7 @@ struct security_operations {
 	void (*audit_rule_free) (void *lsmrule);
 #endif /* CONFIG_AUDIT */
 };
+extern struct security_operations *security_ops;
 
 /* prototypes */
 extern int security_init(void);
@@ -2604,6 +2605,15 @@ int security_tun_dev_open(void *security);
 
 void security_skb_owned_by(struct sk_buff *skb, struct sock *sk);
 
+static inline int security_secmark_secctx_to_secid(const char *secdata,
+						u32 seclen, u32 *secid)
+{
+	if (security_ops && security_ops->secctx_to_secid)
+		return security_ops->secctx_to_secid(secdata, seclen, secid);
+	*secid = 0;
+	return 0;
+}
+
 #else	/* CONFIG_SECURITY_NETWORK */
 static inline int security_unix_stream_connect(struct sock *sock,
 					       struct sock *other,
@@ -2767,6 +2777,13 @@ static inline void security_secmark_refcount_dec(void)
 {
 }
 
+static inline int security_secmark_secctx_to_secid(const char *secdata,
+						u32 seclen, u32 *secid)
+{
+	*secid = 0;
+	return 0;
+}
+
 static inline int security_tun_dev_alloc_security(void **security)
 {
 	return 0;
@@ -2820,6 +2837,23 @@ int security_xfrm_state_pol_flow_match(struct xfrm_state *x,
 int security_xfrm_decode_session(struct sk_buff *skb, u32 *secid);
 void security_skb_classify_flow(struct sk_buff *skb, struct flowi *fl);
 
+static inline void security_xfrm_task_getsecid(struct task_struct *p,
+						u32 *secid)
+{
+	if (security_ops && security_ops->task_getsecid)
+		security_ops->task_getsecid(p, secid);
+	else
+		*secid = 0;
+}
+
+static inline int security_xfrm_secid_to_secctx(u32 secid, char **secdata,
+						u32 *seclen)
+{
+	if (security_ops && security_ops->secid_to_secctx)
+		return security_ops->secid_to_secctx(secid, secdata, seclen);
+	return 0;
+}
+
 #else	/* CONFIG_SECURITY_NETWORK_XFRM */
 
 static inline int security_xfrm_policy_alloc(struct xfrm_sec_ctx **ctxp, struct xfrm_user_sec_ctx *sec_ctx)
@@ -2882,6 +2916,17 @@ static inline void security_skb_classify_flow(struct sk_buff *skb, struct flowi
 {
 }
 
+static inline void security_xfrm_task_getsecid(struct task_struct *p,
+						u32 *secid)
+{
+	*secid = 0;
+}
+
+static inline int security_xfrm_secid_to_secctx(u32 secid, char **secdata,
+						u32 *seclen)
+{
+	return 0;
+}
 #endif	/* CONFIG_SECURITY_NETWORK_XFRM */
 
 #ifdef CONFIG_SECURITY_PATH
diff --git a/include/net/netlabel.h b/include/net/netlabel.h
index 2c95d55..c0cf965 100644
--- a/include/net/netlabel.h
+++ b/include/net/netlabel.h
@@ -406,7 +406,8 @@ int netlbl_secattr_catmap_setrng(struct netlbl_lsm_secattr_catmap *catmap,
 /*
  * LSM protocol operations (NetLabel LSM/kernel API)
  */
-int netlbl_enabled(void);
+int netlbl_register_lsm(struct security_operations *lsmops);
+int netlbl_enabled(struct security_operations *lsmops);
 int netlbl_sock_setattr(struct sock *sk,
 			u16 family,
 			const struct netlbl_lsm_secattr *secattr);
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 1dd770e..a9f22be 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -698,17 +698,13 @@ static inline void xfrm_audit_helper_usrinfo(kuid_t auid, u32 ses, u32 secid,
 {
 	char *secctx;
 	u32 secctx_len;
-	struct secids sid;
-	struct security_operations *sop;
-
-	sid.si_lsm[0] = secid;
 
 	audit_log_format(audit_buf, " auid=%u ses=%u",
 			 from_kuid(&init_user_ns, auid), ses);
 	if (secid != 0 &&
-	    security_secid_to_secctx(&sid, &secctx, &secctx_len, &sop) == 0) {
+	    security_xfrm_secid_to_secctx(secid, &secctx, &secctx_len) == 0) {
 		audit_log_format(audit_buf, " subj=%s", secctx);
-		security_release_secctx(secctx, secctx_len, sop);
+		security_release_secctx(secctx, secctx_len, security_ops);
 	} else
 		audit_log_task_context(audit_buf);
 }
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
index 03dd794..b42e160 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
@@ -103,7 +103,7 @@ static int ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 
 	memset(&secid, 0, sizeof(secid));
 
-	secid.si_lsm[lsm_secmark_ops->order] = ct->secmark;
+	secid.si_lsm[0] = ct->secmark;
 	secid.si_count = 1;
 
 	ret = security_secid_to_secctx(&secid, &secctx, &len, &sop);
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index 0f7a066..e6e51c4 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -52,17 +52,12 @@ secmark_tg(struct sk_buff *skb, const struct xt_action_param *par)
 static int checkentry_lsm(struct xt_secmark_target_info *info)
 {
 	int err;
-	struct secids secid;
 
 	info->secctx[SECMARK_SECCTX_MAX - 1] = '\0';
 	info->secid = 0;
 
-	secid.si_lsm[0] = 0;
-
-	err = security_secctx_to_secid(info->secctx, strlen(info->secctx),
-					&secid);
-	info->secid = secid.si_lsm[0];
-
+	err = security_secmark_secctx_to_secid(info->secctx,
+					strlen(info->secctx), &info->secid);
 	if (err) {
 		if (err == -EINVAL)
 			pr_info("invalid security context \'%s\'\n", info->secctx);
diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
index 7c94aed..2881d48 100644
--- a/net/netlabel/netlabel_kapi.c
+++ b/net/netlabel/netlabel_kapi.c
@@ -607,23 +607,48 @@ int netlbl_secattr_catmap_setrng(struct netlbl_lsm_secattr_catmap *catmap,
  * LSM Functions
  */
 
+struct security_operations *netlbl_active_lsm;
+/**
+ * netlbl_register_lsm - Reserve the NetLabel subsystem for an LSM
+ *
+ * Description:
+ * To avoid potential conflicting views between LSMs over
+ * what should go in the network label reserve the Netlabel
+ * mechanism for use by one LSM. netlbl_enabled will return
+ * false for all other LSMs.
+ *
+ */
+int netlbl_register_lsm(struct security_operations *lsm)
+{
+	if (lsm == NULL)
+		return -EINVAL;
+
+	if (netlbl_active_lsm == NULL)
+		netlbl_active_lsm = lsm;
+	else if (netlbl_active_lsm != lsm)
+		return -EBUSY;
+
+	printk(KERN_INFO "NetLabel: Registered LSM \"%s\".\n", lsm->name);
+	return 0;
+}
+
 /**
  * netlbl_enabled - Determine if the NetLabel subsystem is enabled
  *
  * Description:
  * The LSM can use this function to determine if it should use NetLabel
- * security attributes in it's enforcement mechanism.  Currently, NetLabel is
- * considered to be enabled when it's configuration contains a valid setup for
+ * security attributes in it's enforcement mechanism.  NetLabel is
+ * considered to be enabled when the LSM making the call is registered and
+ * the netlabel configuration contains a valid setup for
  * at least one labeled protocol (i.e. NetLabel can understand incoming
  * labeled packets of at least one type); otherwise NetLabel is considered to
  * be disabled.
  *
  */
-int netlbl_enabled(void)
+int netlbl_enabled(struct security_operations *lsm)
 {
-	/* At some point we probably want to expose this mechanism to the user
-	 * as well so that admins can toggle NetLabel regardless of the
-	 * configuration */
+	if (netlbl_active_lsm != lsm)
+		return 0;
 	return (atomic_read(&netlabel_mgmt_protocount) > 0);
 }
 
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index d77e085..2580a98 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -396,10 +396,6 @@ int netlbl_unlhsh_add(struct net *net,
 	struct audit_buffer *audit_buf = NULL;
 	char *secctx = NULL;
 	u32 secctx_len;
-	struct secids sid;
-	struct security_operations *sop;
-
-	sid.si_lsm[0] = secid;
 
 	if (addr_len != sizeof(struct in_addr) &&
 	    addr_len != sizeof(struct in6_addr))
@@ -462,12 +458,11 @@ int netlbl_unlhsh_add(struct net *net,
 unlhsh_add_return:
 	rcu_read_unlock();
 	if (audit_buf != NULL) {
-		if (security_secid_to_secctx(&sid,
+		if (netlbl_secid_to_secctx(secid,
 					     &secctx,
-					     &secctx_len,
-					     &sop) == 0) {
+					     &secctx_len) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s", secctx);
-			security_release_secctx(secctx, secctx_len, sop);
+			netlbl_release_secctx(secctx, secctx_len);
 		}
 		audit_log_format(audit_buf, " res=%u", ret_val == 0 ? 1 : 0);
 		audit_log_end(audit_buf);
@@ -500,8 +495,6 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 	struct net_device *dev;
 	char *secctx;
 	u32 secctx_len;
-	struct secids sid;
-	struct security_operations *sop;
 
 	spin_lock(&netlbl_unlhsh_lock);
 	list_entry = netlbl_af4list_remove(addr->s_addr, mask->s_addr,
@@ -521,12 +514,11 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 					  addr->s_addr, mask->s_addr);
 		if (dev != NULL)
 			dev_put(dev);
-		sid.si_lsm[0] = entry->secid;
 		if (entry != NULL &&
-		    security_secid_to_secctx(&sid,
-					     &secctx, &secctx_len, &sop) == 0) {
+		    netlbl_secid_to_secctx(entry->secid,
+					     &secctx, &secctx_len) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s", secctx);
-			security_release_secctx(secctx, secctx_len, sop);
+			netlbl_release_secctx(secctx, secctx_len);
 		}
 		audit_log_format(audit_buf, " res=%u", entry != NULL ? 1 : 0);
 		audit_log_end(audit_buf);
@@ -565,8 +557,6 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 	struct net_device *dev;
 	char *secctx;
 	u32 secctx_len;
-	struct secids sid;
-	struct security_operations *sop;
 
 	spin_lock(&netlbl_unlhsh_lock);
 	list_entry = netlbl_af6list_remove(addr, mask, &iface->addr6_list);
@@ -585,12 +575,11 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 					  addr, mask);
 		if (dev != NULL)
 			dev_put(dev);
-		sid.si_lsm[0] = entry->secid;
 		if (entry != NULL &&
-		    security_secid_to_secctx(&sid,
-					     &secctx, &secctx_len, &sop) == 0) {
+		    netlbl_secid_to_secctx(entry->secid,
+					     &secctx, &secctx_len) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s", secctx);
-			security_release_secctx(secctx, secctx_len, sop);
+			netlbl_release_secctx(secctx, secctx_len);
 		}
 		audit_log_format(audit_buf, " res=%u", entry != NULL ? 1 : 0);
 		audit_log_end(audit_buf);
@@ -913,7 +902,7 @@ static int netlbl_unlabel_staticadd(struct sk_buff *skb,
 	void *addr;
 	void *mask;
 	u32 addr_len;
-	struct secids secid;
+	u32 secid;
 	struct netlbl_audit audit_info;
 
 	/* Don't allow users to add both IPv4 and IPv6 addresses for a
@@ -934,7 +923,7 @@ static int netlbl_unlabel_staticadd(struct sk_buff *skb,
 	if (ret_val != 0)
 		return ret_val;
 	dev_name = nla_data(info->attrs[NLBL_UNLABEL_A_IFACE]);
-	ret_val = security_secctx_to_secid(
+	ret_val = netlbl_secctx_to_secid(
 		                  nla_data(info->attrs[NLBL_UNLABEL_A_SECCTX]),
 				  nla_len(info->attrs[NLBL_UNLABEL_A_SECCTX]),
 				  &secid);
@@ -942,7 +931,7 @@ static int netlbl_unlabel_staticadd(struct sk_buff *skb,
 		return ret_val;
 
 	return netlbl_unlhsh_add(&init_net,
-				 dev_name, addr, mask, addr_len, secid.si_lsm[0],
+				 dev_name, addr, mask, addr_len, secid,
 				 &audit_info);
 }
 
@@ -964,7 +953,7 @@ static int netlbl_unlabel_staticadddef(struct sk_buff *skb,
 	void *addr;
 	void *mask;
 	u32 addr_len;
-	struct secids secid;
+	u32 secid;
 	struct netlbl_audit audit_info;
 
 	/* Don't allow users to add both IPv4 and IPv6 addresses for a
@@ -983,7 +972,7 @@ static int netlbl_unlabel_staticadddef(struct sk_buff *skb,
 	ret_val = netlbl_unlabel_addrinfo_get(info, &addr, &mask, &addr_len);
 	if (ret_val != 0)
 		return ret_val;
-	ret_val = security_secctx_to_secid(
+	ret_val = netlbl_secctx_to_secid(
 		                  nla_data(info->attrs[NLBL_UNLABEL_A_SECCTX]),
 				  nla_len(info->attrs[NLBL_UNLABEL_A_SECCTX]),
 				  &secid);
@@ -991,7 +980,7 @@ static int netlbl_unlabel_staticadddef(struct sk_buff *skb,
 		return ret_val;
 
 	return netlbl_unlhsh_add(&init_net,
-				 NULL, addr, mask, addr_len, secid.si_lsm[0],
+				 NULL, addr, mask, addr_len, secid,
 				 &audit_info);
 }
 
@@ -1103,8 +1092,7 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 	struct netlbl_unlhsh_walk_arg *cb_arg = arg;
 	struct net_device *dev;
 	void *data;
-	struct secids secid;
-	struct security_operations *sop;
+	u32 secid;
 	char *secctx;
 	u32 secctx_len;
 
@@ -1146,7 +1134,7 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 		if (ret_val != 0)
 			goto list_cb_failure;
 
-		secid.si_lsm[0] = addr4->secid;
+		secid = addr4->secid;
 	} else {
 		ret_val = nla_put(cb_arg->skb,
 				  NLBL_UNLABEL_A_IPV6ADDR,
@@ -1162,17 +1150,17 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 		if (ret_val != 0)
 			goto list_cb_failure;
 
-		secid.si_lsm[0] = addr6->secid;
+		secid = addr6->secid;
 	}
 
-	ret_val = security_secid_to_secctx(&secid, &secctx, &secctx_len, &sop);
+	ret_val = netlbl_secid_to_secctx(secid, &secctx, &secctx_len);
 	if (ret_val != 0)
 		goto list_cb_failure;
 	ret_val = nla_put(cb_arg->skb,
 			  NLBL_UNLABEL_A_SECCTX,
 			  secctx_len,
 			  secctx);
-	security_release_secctx(secctx, secctx_len, sop);
+	netlbl_release_secctx(secctx, secctx_len);
 	if (ret_val != 0)
 		goto list_cb_failure;
 
@@ -1543,13 +1531,11 @@ int __init netlbl_unlabel_defconf(void)
 	int ret_val;
 	struct netlbl_dom_map *entry;
 	struct netlbl_audit audit_info;
-	struct secids secid;
 
 	/* Only the kernel is allowed to call this function and the only time
 	 * it is called is at bootup before the audit subsystem is reporting
 	 * messages so don't worry to much about these values. */
-	security_task_getsecid(current, &secid);
-	audit_info.secid = secid.si_lsm[0];
+	netlbl_task_getsecid(current, &audit_info.secid);
 	audit_info.loginuid = GLOBAL_ROOT_UID;
 	audit_info.sessionid = 0;
 
diff --git a/net/netlabel/netlabel_user.c b/net/netlabel/netlabel_user.c
index 469aa0e..e3b486d 100644
--- a/net/netlabel/netlabel_user.c
+++ b/net/netlabel/netlabel_user.c
@@ -100,14 +100,10 @@ struct audit_buffer *netlbl_audit_start_common(int type,
 	struct audit_buffer *audit_buf;
 	char *secctx;
 	u32 secctx_len;
-	struct secids secid;
-	struct security_operations *sop;
 
 	if (audit_enabled == 0)
 		return NULL;
 
-	secid.si_lsm[0] = audit_info->secid;
-
 	audit_buf = audit_log_start(current->audit_context, GFP_ATOMIC, type);
 	if (audit_buf == NULL)
 		return NULL;
@@ -117,9 +113,11 @@ struct audit_buffer *netlbl_audit_start_common(int type,
 			 audit_info->sessionid);
 
 	if (audit_info->secid != 0 &&
-	    security_secid_to_secctx(&secid, &secctx, &secctx_len, &sop) == 0) {
+	    netlbl_secid_to_secctx(audit_info->secid,
+				     &secctx,
+				     &secctx_len) == 0) {
 		audit_log_format(audit_buf, " subj=%s", secctx);
-		security_release_secctx(secctx, secctx_len, sop);
+		netlbl_release_secctx(secctx, secctx_len);
 	}
 
 	return audit_buf;
diff --git a/net/netlabel/netlabel_user.h b/net/netlabel/netlabel_user.h
index a6f1705..9990b24 100644
--- a/net/netlabel/netlabel_user.h
+++ b/net/netlabel/netlabel_user.h
@@ -41,6 +41,65 @@
 
 /* NetLabel NETLINK helper functions */
 
+extern struct security_operations *netlbl_active_lsm;
+
+/**
+ * netlbl_secid_to_secctx - call the registered secid_to_secctx LSM hook
+ * @secid - The secid to convert
+ * @secdata - Where to put the result
+ * @seclen - Where to put the length of the result
+ *
+ * Returns: the result of calling the hook.
+ */
+static inline int netlbl_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
+{
+	if (netlbl_active_lsm == NULL)
+		return -EINVAL;
+	return netlbl_active_lsm->secid_to_secctx(secid, secdata, seclen);
+}
+
+/**
+ * netlbl_release_secctx - call the registered release_secctx LSM hook
+ * @secdata - The security context to release
+ * @seclen - The size of the context to release
+ *
+ */
+static inline void netlbl_release_secctx(char *secdata, u32 seclen)
+{
+	if (netlbl_active_lsm != NULL)
+		netlbl_active_lsm->release_secctx(secdata, seclen);
+}
+
+/**
+ * netlbl_secctx_to_secid - call the registered seccts_to_secid LSM hook
+ * @secdata - The security context
+ * @seclen - The size of the security context
+ * @secid - Where to put the result
+ *
+ * Returns: the result of calling the hook
+ */
+static inline int netlbl_secctx_to_secid(const char *secdata, u32 seclen,
+					 u32 *secid)
+{
+	if (netlbl_active_lsm == NULL) {
+		*secid = 0;
+		return -EINVAL;
+	}
+	return netlbl_active_lsm->secctx_to_secid(secdata, seclen, secid);
+}
+
+/**
+ * netlbl_task_getsecid - call the registered task_getsecid LSM hook
+ * @p - The task
+ * @secid - Where to put the secid
+ *
+ */
+static inline void netlbl_task_getsecid(struct task_struct *p, u32 *secid)
+{
+	if (netlbl_active_lsm)
+		netlbl_active_lsm->task_getsecid(p, secid);
+}
+
 /**
  * netlbl_netlink_auditinfo - Fetch the audit information from a NETLINK msg
  * @skb: the packet
@@ -49,10 +108,7 @@
 static inline void netlbl_netlink_auditinfo(struct sk_buff *skb,
 					    struct netlbl_audit *audit_info)
 {
-	struct secids secid;
-
-	security_task_getsecid(current, &secid);
-	audit_info->secid = secid.si_lsm[0];
+	netlbl_task_getsecid(current, &audit_info->secid);
 	audit_info->loginuid = audit_get_loginuid(current);
 	audit_info->sessionid = audit_get_sessionid(current);
 }
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 5476610..8c1277b 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -597,7 +597,7 @@ static int xfrm_add_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct km_event c;
 	kuid_t loginuid = audit_get_loginuid(current);
 	u32 sessionid = audit_get_sessionid(current);
-	struct secids sid;
+	u32 sid;
 
 	err = verify_newsa_info(p, attrs);
 	if (err)
@@ -613,8 +613,8 @@ static int xfrm_add_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
 	else
 		err = xfrm_state_update(x);
 
-	security_task_getsecid(current, &sid);
-	xfrm_audit_state_add(x, err ? 0 : 1, loginuid, sessionid, sid.si_lsm[0]);
+	security_xfrm_task_getsecid(current, &sid);
+	xfrm_audit_state_add(x, err ? 0 : 1, loginuid, sessionid, sid);
 
 	if (err < 0) {
 		x->km.state = XFRM_STATE_DEAD;
@@ -676,7 +676,7 @@ static int xfrm_del_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct xfrm_usersa_id *p = nlmsg_data(nlh);
 	kuid_t loginuid = audit_get_loginuid(current);
 	u32 sessionid = audit_get_sessionid(current);
-	struct secids sid;
+	u32 sid;
 
 	x = xfrm_user_state_lookup(net, p, attrs, &err);
 	if (x == NULL)
@@ -701,8 +701,8 @@ static int xfrm_del_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
 	km_state_notify(x, &c);
 
 out:
-	security_task_getsecid(current, &sid);
-	xfrm_audit_state_delete(x, err ? 0 : 1, loginuid, sessionid, sid.si_lsm[0]);
+	security_xfrm_task_getsecid(current, &sid);
+	xfrm_audit_state_delete(x, err ? 0 : 1, loginuid, sessionid, sid);
 	xfrm_state_put(x);
 	return err;
 }
@@ -1395,7 +1395,7 @@ static int xfrm_add_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 	int excl;
 	kuid_t loginuid = audit_get_loginuid(current);
 	u32 sessionid = audit_get_sessionid(current);
-	struct secids sid;
+	u32 sid;
 
 	err = verify_newpolicy_info(p);
 	if (err)
@@ -1414,8 +1414,8 @@ static int xfrm_add_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 	 * a type XFRM_MSG_UPDPOLICY - JHS */
 	excl = nlh->nlmsg_type == XFRM_MSG_NEWPOLICY;
 	err = xfrm_policy_insert(p->dir, xp, excl);
-	security_task_getsecid(current, &sid);
-	xfrm_audit_policy_add(xp, err ? 0 : 1, loginuid, sessionid, sid.si_lsm[0]);
+	security_xfrm_task_getsecid(current, &sid);
+	xfrm_audit_policy_add(xp, err ? 0 : 1, loginuid, sessionid, sid);
 
 	if (err) {
 		security_xfrm_policy_free(xp->security);
@@ -1653,11 +1653,11 @@ static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 	} else {
 		kuid_t loginuid = audit_get_loginuid(current);
 		u32 sessionid = audit_get_sessionid(current);
-		struct secids sid;
+		u32 sid;
 
-		security_task_getsecid(current, &sid);
+		security_xfrm_task_getsecid(current, &sid);
 		xfrm_audit_policy_delete(xp, err ? 0 : 1, loginuid, sessionid,
-					 sid.si_lsm[0]);
+					 sid);
 
 		if (err != 0)
 			goto out;
@@ -1682,12 +1682,10 @@ static int xfrm_flush_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct xfrm_usersa_flush *p = nlmsg_data(nlh);
 	struct xfrm_audit audit_info;
 	int err;
-	struct secids secid;
 
 	audit_info.loginuid = audit_get_loginuid(current);
 	audit_info.sessionid = audit_get_sessionid(current);
-	security_task_getsecid(current, &secid);
-	audit_info.secid = secid.si_lsm[0];
+	security_xfrm_task_getsecid(current, &audit_info.secid);
 	err = xfrm_state_flush(net, p->proto, &audit_info);
 	if (err) {
 		if (err == -ESRCH) /* empty table */
@@ -1873,7 +1871,6 @@ static int xfrm_flush_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 	u8 type = XFRM_POLICY_TYPE_MAIN;
 	int err;
 	struct xfrm_audit audit_info;
-	struct secids secid;
 
 	err = copy_from_user_policy_type(&type, attrs);
 	if (err)
@@ -1881,8 +1878,7 @@ static int xfrm_flush_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	audit_info.loginuid = audit_get_loginuid(current);
 	audit_info.sessionid = audit_get_sessionid(current);
-	security_task_getsecid(current, &secid);
-	audit_info.secid = secid.si_lsm[0];
+	security_xfrm_task_getsecid(current, &audit_info.secid);
 	err = xfrm_policy_flush(net, type, &audit_info);
 	if (err) {
 		if (err == -ESRCH) /* empty table */
@@ -1951,11 +1947,11 @@ static int xfrm_add_pol_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (up->hard) {
 		kuid_t loginuid = audit_get_loginuid(current);
 		u32 sessionid = audit_get_sessionid(current);
-		struct secids sid;
+		u32 sid;
 
-		security_task_getsecid(current, &sid);
+		security_xfrm_task_getsecid(current, &sid);
 		xfrm_policy_delete(xp, p->dir);
-		xfrm_audit_policy_delete(xp, 1, loginuid, sessionid, sid.si_lsm[0]);
+		xfrm_audit_policy_delete(xp, 1, loginuid, sessionid, sid);
 
 	} else {
 		// reset the timers here?
@@ -1994,11 +1990,11 @@ static int xfrm_add_sa_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (ue->hard) {
 		kuid_t loginuid = audit_get_loginuid(current);
 		u32 sessionid = audit_get_sessionid(current);
-		struct secids sid;
+		u32 sid;
 
-		security_task_getsecid(current, &sid);
+		security_xfrm_task_getsecid(current, &sid);
 		__xfrm_state_delete(x);
-		xfrm_audit_state_delete(x, 1, loginuid, sessionid, sid.si_lsm[0]);
+		xfrm_audit_state_delete(x, 1, loginuid, sessionid, sid);
 	}
 	err = 0;
 out:
diff --git a/security/security.c b/security/security.c
index 6594d8d..d0b768c 100644
--- a/security/security.c
+++ b/security/security.c
@@ -32,7 +32,9 @@
 static __initdata char chosen_lsm[SECURITY_NAME_MAX + 1] =
 	CONFIG_DEFAULT_SECURITY;
 
-static struct security_operations *security_ops;
+struct security_operations *security_ops;
+EXPORT_SYMBOL(security_ops);
+
 static struct security_operations default_security_ops = {
 	.name	= "default",
 };
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 9ff6d6d..7104c6b 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4188,7 +4188,7 @@ static int selinux_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 		return selinux_sock_rcv_skb_compat(sk, skb, family);
 
 	secmark_active = selinux_secmark_enabled();
-	peerlbl_active = netlbl_enabled() || selinux_xfrm_enabled();
+	peerlbl_active = netlbl_enabled(&selinux_ops) || selinux_xfrm_enabled();
 	if (!secmark_active && !peerlbl_active)
 		return 0;
 
@@ -4571,7 +4571,7 @@ static unsigned int selinux_ip_forward(struct sk_buff *skb, int ifindex,
 		return NF_ACCEPT;
 
 	secmark_active = selinux_secmark_enabled();
-	netlbl_active = netlbl_enabled();
+	netlbl_active = netlbl_enabled(&selinux_ops);
 	peerlbl_active = netlbl_active || selinux_xfrm_enabled();
 	if (!secmark_active && !peerlbl_active)
 		return NF_ACCEPT;
@@ -4636,7 +4636,7 @@ static unsigned int selinux_ip_output(struct sk_buff *skb,
 {
 	u32 sid;
 
-	if (!netlbl_enabled())
+	if (!netlbl_enabled(&selinux_ops))
 		return NF_ACCEPT;
 
 	/* we do this in the LOCAL_OUT path and not the POST_ROUTING path
@@ -4725,7 +4725,7 @@ static unsigned int selinux_ip_postroute(struct sk_buff *skb, int ifindex,
 		return NF_ACCEPT;
 #endif
 	secmark_active = selinux_secmark_enabled();
-	peerlbl_active = netlbl_enabled() || selinux_xfrm_enabled();
+	peerlbl_active = netlbl_enabled(&selinux_ops) || selinux_xfrm_enabled();
 	if (!secmark_active && !peerlbl_active)
 		return NF_ACCEPT;
 
diff --git a/security/selinux/netlabel.c b/security/selinux/netlabel.c
index 7a9cbd0..471dce1 100644
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
index 223bbdf..7473498 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1667,9 +1667,6 @@ static int smack_task_movememory(struct task_struct *p)
  * @subcred: identifies the smack to use in lieu of current's
  *
  * Return 0 if write access is permitted
- *
- * The secid behavior is an artifact of an SELinux hack
- * in the USB code. Someday it may go away.
  */
 static int smack_task_kill(struct task_struct *p, struct siginfo *info,
 			   int sig, const struct cred *subcred)
@@ -1824,6 +1821,11 @@ static int smack_netlabel(struct sock *sk, int labeled)
 	int rc = 0;
 
 	/*
+	 * If Netlabel is unavailable send unlabeled.
+	 */
+	if (!smack_use_netlbl)
+		return 0;
+	/*
 	 * Usually the netlabel code will handle changing the
 	 * packet labeling based on the label.
 	 * The case of a single label host is different, because
@@ -2895,19 +2897,24 @@ static int smack_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 		return 0;
 
 	/*
-	 * Translate what netlabel gave us.
 	 * If Netlabel is unavailable use the ambient label.
 	 * In this case we'd expect the ambient label to be "@".
 	 */
-	netlbl_secattr_init(&secattr);
+	if (smack_use_netlbl) {
+		/*
+		 * Translate what netlabel gave us.
+		 */
+		netlbl_secattr_init(&secattr);
 
-	rc = netlbl_skbuff_getattr(skb, sk->sk_family, &secattr);
-	if (rc == 0)
-		csp = smack_from_secattr(&secattr, ssp);
-	else
-		csp = smack_net_ambient;
+		rc = netlbl_skbuff_getattr(skb, sk->sk_family, &secattr);
+		if (rc == 0)
+			csp = smack_from_secattr(&secattr, ssp);
+		else
+			csp = smack_net_ambient;
 
-	netlbl_secattr_destroy(&secattr);
+		netlbl_secattr_destroy(&secattr);
+	} else
+		csp = smack_net_ambient;
 
 #ifdef CONFIG_AUDIT
 	smk_ad_init_net(&ad, __func__, LSM_AUDIT_DATA_NET, &net);
@@ -2922,7 +2929,7 @@ static int smack_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	 * for networking.
 	 */
 	rc = smk_access(csp, ssp->smk_in, MAY_WRITE, &ad);
-	if (rc != 0)
+	if (rc != 0 && smack_use_netlbl)
 		netlbl_skbuff_err(skb, rc, 0);
 	return rc;
 }
@@ -2996,17 +3003,21 @@ static int smack_socket_getpeersec_dgram(struct socket *sock,
 		s = smack_to_secid(ssp->smk_out);
 	} else if (family == PF_INET || family == PF_INET6) {
 		/*
-		 * Translate what netlabel gave us.
+		 * Translate what netlabel gave us. Use the ambient
+		 * label if we can't use netlabel.
 		 */
-		if (sock != NULL && sock->sk != NULL)
-			ssp = lsm_get_sock(sock->sk, &smack_ops);
-		netlbl_secattr_init(&secattr);
-		rc = netlbl_skbuff_getattr(skb, family, &secattr);
-		if (rc == 0) {
-			sp = smack_from_secattr(&secattr, ssp);
-			s = smack_to_secid(sp);
-		}
-		netlbl_secattr_destroy(&secattr);
+		if (smack_use_netlbl) {
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
@@ -3065,13 +3076,16 @@ static int smack_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 	if (family == PF_INET6 && skb->protocol == htons(ETH_P_IP))
 		family = PF_INET;
 
-	netlbl_secattr_init(&secattr);
-	rc = netlbl_skbuff_getattr(skb, family, &secattr);
-	if (rc == 0)
-		sp = smack_from_secattr(&secattr, ssp);
-	else
-		sp = smack_known_huh.smk_known;
-	netlbl_secattr_destroy(&secattr);
+	if (smack_use_netlbl) {
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
@@ -3098,17 +3112,19 @@ static int smack_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 	 * if we do we only need to label the request_sock and the stack will
 	 * propagate the wire-label to the sock when it is created.
 	 */
-	hdr = ip_hdr(skb);
-	addr.sin_addr.s_addr = hdr->saddr;
-	rcu_read_lock();
-	hsp = smack_host_label(&addr);
-	rcu_read_unlock();
+	if (smack_use_netlbl) {
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
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 5335444..f51f98f 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -115,6 +115,13 @@ static int smk_cipso_doi_value = SMACK_CIPSO_DOI_DEFAULT;
 const char *smack_cipso_option = SMACK_CIPSO_OPTION;
 
 /*
+ * If another LSM has registered the Netlabel system
+ * this gets set false, indicating that all packets should get
+ * treated as if they are unlabeled, hence ambient.
+ */
+int smack_use_netlbl;
+
+/*
  * Values for parsing cipso rules
  * SMK_DIGITLEN: Length of a digit field in a rule.
  * SMK_CIPSOMIN: Minimum possible cipso rule length.
@@ -624,6 +631,22 @@ static void smk_cipso_doi(void)
 	struct cipso_v4_doi *doip;
 	struct netlbl_audit nai;
 
+	if (smack_net_ambient == NULL)
+		smack_net_ambient = smack_known_floor.smk_known;
+
+	/*
+	 * If someone else has registered use of netlbl abort
+	 */
+	if (!smack_use_netlbl) {
+		rc = netlbl_register_lsm(&smack_ops);
+		if (rc) {
+			printk(KERN_WARNING "%s:%d Netlabel use denied\n",
+				__func__, __LINE__);
+			return;
+		}
+		smack_use_netlbl = 1;
+	}
+
 	smk_netlabel_audit_set(&nai);
 
 	rc = netlbl_cfg_map_del(NULL, PF_INET, NULL, NULL, &nai);
@@ -1185,9 +1208,12 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
 			smk_netlbladdr_insert(skp);
 		}
 	} else {
-		/* we delete the unlabeled entry, only if the previous label
-		 * wasn't the special CIPSO option */
-		if (skp->smk_label != smack_cipso_option)
+		/*
+		 * Delete the unlabeled entry if the previous label
+		 * wasn't the special CIPSO option or if some other
+		 * LSM owns Netlabel.
+		 */
+		if (skp->smk_label != smack_cipso_option && smack_use_netlbl)
 			rc = netlbl_cfg_unlbl_static_del(&init_net, NULL,
 					&skp->smk_host.sin_addr, &skp->smk_mask,
 					PF_INET, &audit_info);
@@ -1199,7 +1225,7 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
 	 * this host so that incoming packets get labeled.
 	 * but only if we didn't get the special CIPSO option
 	 */
-	if (rc == 0 && sp != smack_cipso_option)
+	if (rc == 0 && sp != smack_cipso_option && smack_use_netlbl)
 		rc = netlbl_cfg_unlbl_static_add(&init_net, NULL,
 			&skp->smk_host.sin_addr, &skp->smk_mask, PF_INET,
 			smack_to_secid(skp->smk_label), &audit_info);


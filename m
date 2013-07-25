Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342Ab3GYScO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:32:14 -0400
Received: from smtp104.biz.mail.gq1.yahoo.com ([98.137.12.179]:36907 "HELO
	smtp104.biz.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757205Ab3GYScJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 14:32:09 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: MQfybc8VM1lXhgltK5TUfvUSTDVOdUtl9tQ_HNaEdZct7mx
 wX0WMYYmYGPLCg.G.Gkt2sCXPYBV1C_ldwwwOMzjLlJ5OlPzlkriY57LE5O2
 EKDMJxU2kOuPHO4Qm9bJvjawnMlhnJnNW8Q_arI7XHdzock39OGmY_.VN50u
 DFBue4M9Mf4XO2_4zRfYZkbpOTC7l161XDBqrQDK7oqI64n6ZnJrd4TeR5HA
 jQGbneZiBax_nvspQgr2zy4ah8XuJGnq2qJHjCbItFbWl9MG6Rwdjapqwxbw
 42OcgiiavZPwcdwfq3Po7wZonW1Ge1_n9OKITlIEQqGq1b6pTaUz28jcdl9T
 25RvvQrpQln76ADxBgtHBDqtbBc202PtDG8D7qGToQjdQF39RxLsD_O2RLUy
 EUs1XxxNeokoSabQNXjaDRBd7Y2K6QKHZMfvRAtcBWl4xdN8c1Ty.VlccdFO
 OT4N28y2mTlYTJlLXDBRVThg2KAzuJvkhTwdk.iKuJn6NGq3f.cEvclt1z5u
 RGW.TQsCxBJvC
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with )
        by smtp104.biz.mail.gq1.yahoo.com with SMTP; 25 Jul 2013 11:32:07 -0700 PDT
Message-ID: <51F16F27.4060206@schaufler-ca.com>
Date: Thu, 25 Jul 2013 11:32:07 -0700
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
Subject: [PATCH v14 2/6] LSM: Move the capability LSM into the hook handlers
References: <51F16CFB.6040603@schaufler-ca.com>
In-Reply-To: <51F16CFB.6040603@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH v14 2/6] LSM: Move the capability LSM into the hook handlers

Move the capability module hooks out of thier own module
and into security.c. Pull the calls out of the LSMs as
well, as the call is getting already getting done. It turns
out that in all but a few cases the LSMs that provide those
hooks call the capability function themselves. 

When a secctx is generated it may be done for a specific
LSM or for a collection of LSMs. In the former case the
LSM's free function will be required to release the memory
involved, while in the latter case the lsm infrastructure's
free code needs to be called. The context generation has to
note which LSM created a context, or if it was done for a
set. 

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---
 fs/sysfs/dir.c                                     |    3 +-
 fs/sysfs/inode.c                                   |   12 ++-
 fs/sysfs/sysfs.h                                   |    7 +-
 fs/xattr.c                                         |    8 +-
 include/linux/lsm.h                                |   46 +++++++++
 include/linux/security.h                           |   40 +++++---
 include/net/scm.h                                  |    9 +-
 include/net/xfrm.h                                 |    6 +-
 kernel/audit.c                                     |   22 +++--
 kernel/auditsc.c                                   |   10 +-
 kernel/cred.c                                      |   11 ++-
 net/ipv4/cipso_ipv4.c                              |    3 +-
 net/ipv4/ip_sockglue.c                             |    5 +-
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |    5 +-
 net/netfilter/nf_conntrack_netlink.c               |    8 +-
 net/netfilter/nf_conntrack_standalone.c            |    5 +-
 net/netfilter/xt_SECMARK.c                         |    4 +-
 net/netlabel/netlabel_unlabeled.c                  |   28 +++---
 net/netlabel/netlabel_user.c                       |    5 +-
 net/xfrm/xfrm_user.c                               |   16 +--
 security/apparmor/domain.c                         |   13 +--
 security/apparmor/lsm.c                            |   22 +----
 security/security.c                                |  104 +++++++++++++++++---
 security/selinux/hooks.c                           |   73 +-------------
 security/selinux/ss/services.c                     |    4 +-
 security/smack/smack_lsm.c                         |   45 ++-------
 security/tomoyo/common.h                           |    2 +-
 security/tomoyo/tomoyo.c                           |    6 --
 security/yama/yama_lsm.c                           |   24 +----
 29 files changed, 296 insertions(+), 250 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index e8e0e71..62937d1 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -278,7 +278,8 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
 		kfree(sd->s_name);
 	if (sd->s_iattr && sd->s_iattr->ia_secdata)
 		security_release_secctx(sd->s_iattr->ia_secdata,
-					sd->s_iattr->ia_secdata_len);
+					sd->s_iattr->ia_secdata_len,
+					sd->s_iattr->ia_sop);
 	kfree(sd->s_iattr);
 	sysfs_free_ino(sd->s_ino);
 	kmem_cache_free(sysfs_dir_cachep, sd);
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 0ce3ccf..677f37c 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -130,7 +130,9 @@ out:
 	return error;
 }
 
-static int sysfs_sd_setsecdata(struct sysfs_dirent *sd, void **secdata, u32 *secdata_len)
+static int sysfs_sd_setsecdata(struct sysfs_dirent *sd, void **secdata,
+				u32 *secdata_len,
+				struct security_operations *sop)
 {
 	struct sysfs_inode_attrs *iattrs;
 	void *old_secdata;
@@ -148,6 +150,7 @@ static int sysfs_sd_setsecdata(struct sysfs_dirent *sd, void **secdata, u32 *sec
 
 	iattrs->ia_secdata = *secdata;
 	iattrs->ia_secdata_len = *secdata_len;
+	iattrs->ia_sop = sop;
 
 	*secdata = old_secdata;
 	*secdata_len = old_secdata_len;
@@ -161,6 +164,7 @@ int sysfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 	void *secdata;
 	int error;
 	u32 secdata_len = 0;
+	struct security_operations *sop;
 
 	if (!sd)
 		return -EINVAL;
@@ -172,16 +176,16 @@ int sysfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 		if (error)
 			goto out;
 		error = security_inode_getsecctx(dentry->d_inode,
-						&secdata, &secdata_len);
+						&secdata, &secdata_len, &sop);
 		if (error)
 			goto out;
 
 		mutex_lock(&sysfs_mutex);
-		error = sysfs_sd_setsecdata(sd, &secdata, &secdata_len);
+		error = sysfs_sd_setsecdata(sd, &secdata, &secdata_len, sop);
 		mutex_unlock(&sysfs_mutex);
 
 		if (secdata)
-			security_release_secctx(secdata, secdata_len);
+			security_release_secctx(secdata, secdata_len, sop);
 	} else
 		return -EINVAL;
 out:
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index d1e4043..3895884 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -39,9 +39,10 @@ struct sysfs_elem_bin_attr {
 };
 
 struct sysfs_inode_attrs {
-	struct iattr	ia_iattr;
-	void		*ia_secdata;
-	u32		ia_secdata_len;
+	struct iattr			ia_iattr;
+	void				*ia_secdata;
+	u32				ia_secdata_len;
+	struct security_operations	*ia_sop;
 };
 
 /*
diff --git a/fs/xattr.c b/fs/xattr.c
index 3377dff..9def633 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -148,13 +148,15 @@ xattr_getsecurity(struct inode *inode, const char *name, void *value,
 {
 	void *buffer = NULL;
 	ssize_t len;
+	struct security_operations *sop;
 
 	if (!value || !size) {
-		len = security_inode_getsecurity(inode, name, &buffer, false);
+		len = security_inode_getsecurity(inode, name, &buffer, false,
+							&sop);
 		goto out_noalloc;
 	}
 
-	len = security_inode_getsecurity(inode, name, &buffer, true);
+	len = security_inode_getsecurity(inode, name, &buffer, true, &sop);
 	if (len < 0)
 		return len;
 	if (size < len) {
@@ -163,7 +165,7 @@ xattr_getsecurity(struct inode *inode, const char *name, void *value,
 	}
 	memcpy(value, buffer, len);
 out:
-	security_release_secctx(buffer, len);
+	security_release_secctx(buffer, len, sop);
 out_noalloc:
 	return len;
 }
diff --git a/include/linux/lsm.h b/include/linux/lsm.h
index d5453ed..8576f5b 100644
--- a/include/linux/lsm.h
+++ b/include/linux/lsm.h
@@ -23,6 +23,8 @@
 
 #ifdef CONFIG_SECURITY
 
+extern struct security_operations *security_ops;
+
 static inline void *lsm_get_blob(void *bp, const int lsm)
 {
 	return bp;
@@ -174,4 +176,48 @@ static inline int lsm_zero_secid(struct secids *secid)
 	return 0;
 }
 
+#ifdef CONFIG_SECURITY
+
+static inline struct security_operations *lsm_present_ops(void)
+{
+	return security_ops;
+}
+
+static inline int lsm_present_order(void)
+{
+	return 0;
+}
+
+static inline struct security_operations *lsm_netlbl_ops(void)
+{
+	return security_ops;
+}
+
+static inline int lsm_netlbl_order(void)
+{
+	return 0;
+}
+
+static inline struct security_operations *lsm_xfrm_ops(void)
+{
+	return security_ops;
+}
+
+static inline int lsm_xfrm_order(void)
+{
+	return 0;
+}
+
+static inline struct security_operations *lsm_secmark_ops(void)
+{
+	return security_ops;
+}
+
+static inline int lsm_secmark_order(void)
+{
+	return 0;
+}
+
+#endif /* CONFIG_SECURITY */
+
 #endif /* ! _LINUX_LSM_H */
diff --git a/include/linux/security.h b/include/linux/security.h
index e02cad4..870e264 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1773,7 +1773,9 @@ int security_inode_listxattr(struct dentry *dentry);
 int security_inode_removexattr(struct dentry *dentry, const char *name);
 int security_inode_need_killpriv(struct dentry *dentry);
 int security_inode_killpriv(struct dentry *dentry);
-int security_inode_getsecurity(const struct inode *inode, const char *name, void **buffer, bool alloc);
+int security_inode_getsecurity(const struct inode *inode, const char *name,
+			       void **buffer, bool alloc,
+			       struct security_operations **sop);
 int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags);
 int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size);
 void security_inode_getsecid(const struct inode *inode, struct secids *secid);
@@ -1850,15 +1852,22 @@ void security_d_instantiate(struct dentry *dentry, struct inode *inode);
 int security_getprocattr(struct task_struct *p, char *name, char **value);
 int security_setprocattr(struct task_struct *p, char *name, void *value, size_t size);
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
-int security_secid_to_secctx(struct secids *secid, char **secdata, u32 *seclen);
+int security_secid_to_secctx(struct secids *secid, char **secdata, u32 *seclen,
+			     struct security_operations **secops);
 int security_secctx_to_secid(const char *secdata, u32 seclen,
-			     struct secids *secid);
-void security_release_secctx(char *secdata, u32 seclen);
+			     struct secids *secid,
+			     struct security_operations *secops);
+void security_release_secctx(char *secdata, u32 seclen,
+			     struct security_operations *secops);
 
 int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
 int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen);
-int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen);
+int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen,
+			     struct security_operations **secops);
 #else /* CONFIG_SECURITY */
+struct security_operations {
+};
+
 struct security_mnt_opts {
 };
 
@@ -2184,7 +2193,10 @@ static inline int security_inode_killpriv(struct dentry *dentry)
 	return cap_inode_killpriv(dentry);
 }
 
-static inline int security_inode_getsecurity(const struct inode *inode, const char *name, void **buffer, bool alloc)
+static inline int security_inode_getsecurity(const struct inode *inode,
+					     const char *name, void **buffer,
+					     bool alloc,
+					     struct security_operations **sop)
 {
 	return -EOPNOTSUPP;
 }
@@ -2539,19 +2551,21 @@ static inline int security_netlink_send(struct sock *sk, struct sk_buff *skb)
 }
 
 static inline int security_secid_to_secctx(struct secids *secid,
-						char **secdata, u32 *seclen)
+					   char **secdata, u32 *seclen,
+					   struct security_operations **secops)
 {
 	return -EOPNOTSUPP;
 }
 
-static inline int security_secctx_to_secid(const char *secdata,
-					   u32 seclen,
-					   struct secids *secid)
+static inline int security_secctx_to_secid(const char *secdata, u32 seclen,
+					   struct secids *secid,
+				           struct security_operations *secops)
 {
 	return -EOPNOTSUPP;
 }
 
-static inline void security_release_secctx(char *secdata, u32 seclen)
+static inline void security_release_secctx(char *secdata, u32 seclen,
+					   struct security_operations *secops)
 {
 }
 
@@ -2563,7 +2577,9 @@ static inline int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32
 {
 	return -EOPNOTSUPP;
 }
-static inline int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen)
+static inline int security_inode_getsecctx(struct inode *inode, void **ctx,
+					   u32 *ctxlen,
+					   struct security_operations **secops)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/include/net/scm.h b/include/net/scm.h
index 349ec25..5279fb1 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -91,13 +91,16 @@ static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct sc
 	char *secdata;
 	u32 seclen;
 	int err;
+	struct security_operations *sop;
 
 	if (test_bit(SOCK_PASSSEC, &sock->flags)) {
-		err = security_secid_to_secctx(&scm->secid, &secdata, &seclen);
+		err = security_secid_to_secctx(&scm->secid, &secdata,
+						&seclen, &sop);
 
 		if (!err) {
-			put_cmsg(msg, SOL_SOCKET, SCM_SECURITY, seclen, secdata);
-			security_release_secctx(secdata, seclen);
+			put_cmsg(msg, SOL_SOCKET, SCM_SECURITY, seclen,
+					secdata);
+			security_release_secctx(secdata, seclen, sop);
 		}
 	}
 }
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index d8ac020..49824d5 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -701,14 +701,16 @@ static inline void xfrm_audit_helper_usrinfo(kuid_t auid, u32 ses, u32 secid,
 	char *secctx;
 	u32 secctx_len;
 	struct secids secids;
+	struct security_operations *sop;
 
 	audit_log_format(audit_buf, " auid=%u ses=%u",
 			 from_kuid(&init_user_ns, auid), ses);
 	lsm_init_secid(&secids, secid, 0);
 	if (secid != 0 &&
-	    security_secid_to_secctx(&secids, &secctx, &secctx_len) == 0) {
+	    security_secid_to_secctx(&secids, &secctx, &secctx_len,
+					&sop) == 0) {
 		audit_log_format(audit_buf, " subj=%s", secctx);
-		security_release_secctx(secctx, secctx_len);
+		security_release_secctx(secctx, secctx_len, sop);
 	} else
 		audit_log_task_context(audit_buf);
 }
diff --git a/kernel/audit.c b/kernel/audit.c
index d49f7ab..3d55ca0 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -640,6 +640,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	struct audit_sig_info   *sig_data;
 	char			*ctx = NULL;
 	u32			len;
+	struct security_operations *sop;
 
 	err = audit_netlink_ok(skb, msg_type);
 	if (err)
@@ -795,21 +796,21 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		len = 0;
 		if (!lsm_zero_secid(&audit_sig_sid)) {
 			err = security_secid_to_secctx(&audit_sig_sid, &ctx,
-							&len);
+							&len, &sop);
 			if (err)
 				return err;
 		}
 		sig_data = kmalloc(sizeof(*sig_data) + len, GFP_KERNEL);
 		if (!sig_data) {
 			if (!lsm_zero_secid(&audit_sig_sid))
-				security_release_secctx(ctx, len);
+				security_release_secctx(ctx, len, sop);
 			return -ENOMEM;
 		}
 		sig_data->uid = from_kuid(&init_user_ns, audit_sig_uid);
 		sig_data->pid = audit_sig_pid;
 		if (!lsm_zero_secid(&audit_sig_sid)) {
 			memcpy(sig_data->ctx, ctx, len);
-			security_release_secctx(ctx, len);
+			security_release_secctx(ctx, len, sop);
 		}
 		audit_send_reply(NETLINK_CB(skb).portid, seq, AUDIT_SIGNAL_INFO,
 				0, 0, sig_data, sizeof(*sig_data) + len);
@@ -1480,6 +1481,7 @@ void audit_copy_inode(struct audit_names *name, const struct dentry *dentry,
 void audit_log_name(struct audit_context *context, struct audit_names *n,
 		    struct path *path, int record_num, int *call_panic)
 {
+	struct security_operations *sop;
 	struct audit_buffer *ab;
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_PATH);
 	if (!ab)
@@ -1526,13 +1528,13 @@ void audit_log_name(struct audit_context *context, struct audit_names *n,
 	if (!lsm_zero_secid(&n->osid)) {
 		char *ctx = NULL;
 		u32 len;
-		if (security_secid_to_secctx(&n->osid, &ctx, &len)) {
+		if (security_secid_to_secctx(&n->osid, &ctx, &len, &sop)) {
 			audit_log_format(ab, " osid=%u", n->osid.si_count);
 			if (call_panic)
 				*call_panic = 2;
 		} else {
 			audit_log_format(ab, " obj=%s", ctx);
-			security_release_secctx(ctx, len);
+			security_release_secctx(ctx, len, sop);
 		}
 	}
 
@@ -1546,12 +1548,13 @@ int audit_log_task_context(struct audit_buffer *ab)
 	unsigned len;
 	int error;
 	struct secids sid;
+	struct security_operations *sop;
 
 	security_task_getsecid(current, &sid);
 	if (lsm_zero_secid(&sid))
 		return 0;
 
-	error = security_secid_to_secctx(&sid, &ctx, &len);
+	error = security_secid_to_secctx(&sid, &ctx, &len, &sop);
 	if (error) {
 		if (error != -EINVAL)
 			goto error_path;
@@ -1559,7 +1562,7 @@ int audit_log_task_context(struct audit_buffer *ab)
 	}
 
 	audit_log_format(ab, " subj=%s", ctx);
-	security_release_secctx(ctx, len);
+	security_release_secctx(ctx, len, sop);
 	return 0;
 
 error_path:
@@ -1728,13 +1731,14 @@ void audit_log_secctx(struct audit_buffer *ab, u32 secid)
 	u32 len;
 	char *secctx;
 	struct secids secids;
+	struct security_operations *sop;
 
 	lsm_init_secid(&secids, secid, 0);
-	if (security_secid_to_secctx(&secids, &secctx, &len)) {
+	if (security_secid_to_secctx(&secids, &secctx, &len, &sop)) {
 		audit_panic("Cannot convert secid to context");
 	} else {
 		audit_log_format(ab, " obj=%s", secctx);
-		security_release_secctx(secctx, len);
+		security_release_secctx(secctx, len, sop);
 	}
 }
 EXPORT_SYMBOL(audit_log_secctx);
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 5a6478a..0bab5c5 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -984,6 +984,7 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 	char *ctx = NULL;
 	u32 len;
 	int rc = 0;
+	struct security_operations *sop;
 
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_OBJ_PID);
 	if (!ab)
@@ -993,12 +994,12 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 			 from_kuid(&init_user_ns, auid),
 			 from_kuid(&init_user_ns, uid), sessionid);
 	if (!lsm_zero_secid(sid)) {
-		if (security_secid_to_secctx(sid, &ctx, &len)) {
+		if (security_secid_to_secctx(sid, &ctx, &len, &sop)) {
 			audit_log_format(ab, " obj=(none)");
 			rc = 1;
 		} else {
 			audit_log_format(ab, " obj=%s", ctx);
-			security_release_secctx(ctx, len);
+			security_release_secctx(ctx, len, sop);
 		}
 	}
 	audit_log_format(ab, " ocomm=");
@@ -1220,12 +1221,13 @@ static void show_special(struct audit_context *context, int *call_panic)
 		if (!lsm_zero_secid(osid)) {
 			char *ctx = NULL;
 			u32 len;
-			if (security_secid_to_secctx(osid, &ctx, &len)) {
+			struct security_operations *sop;
+			if (security_secid_to_secctx(osid, &ctx, &len, &sop)) {
 				audit_log_format(ab, " osc=%u", osid->si_count);
 				*call_panic = 1;
 			} else {
 				audit_log_format(ab, " obj=%s", ctx);
-				security_release_secctx(ctx, len);
+				security_release_secctx(ctx, len, sop);
 			}
 		}
 		if (context->ipc.has_perm) {
diff --git a/kernel/cred.c b/kernel/cred.c
index c94a3ff..7a88548 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -653,16 +653,21 @@ EXPORT_SYMBOL(set_security_override);
  * @secctx: The LSM security context to generate the security ID from.
  *
  * Set the LSM security ID in a set of credentials so that the subjective
- * security is overridden when an alternative set of credentials is used.  The
- * security ID is specified in string form as a security context to be
+ * security is overridden when an alternative set of credentials is used.
+ * The security ID is specified in string form as a security context to be
  * interpreted by the LSM.
+ *
+ * The last parameter to security_secctx_to_secid() indicates which
+ * LSM should interpret the context string. NULL means that the LSM
+ * infrastructure may have to figure out for itself which LSM or set
+ * of LSMs should get called.
  */
 int set_security_override_from_ctx(struct cred *new, const char *secctx)
 {
 	struct secids secid;
 	int ret;
 
-	ret = security_secctx_to_secid(secctx, strlen(secctx), &secid);
+	ret = security_secctx_to_secid(secctx, strlen(secctx), &secid, NULL);
 	if (ret < 0)
 		return ret;
 
diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 1b47808..00a2b2b 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -1570,7 +1570,8 @@ static int cipso_v4_gentag_loc(const struct cipso_v4_doi *doi_def,
 
 	buffer[0] = CIPSO_V4_TAG_LOCAL;
 	buffer[1] = CIPSO_V4_TAG_LOC_BLEN;
-	*(u32 *)&buffer[2] = lsm_get_secid(&secattr->attr.secid, 0);
+	*(u32 *)&buffer[2] = lsm_get_secid(&secattr->attr.secid,
+						lsm_netlbl_order());
 
 	return CIPSO_V4_TAG_LOC_BLEN;
 }
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index a55f8c0..3986a24 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -111,17 +111,18 @@ static void ip_cmsg_recv_security(struct msghdr *msg, struct sk_buff *skb)
 	u32 seclen;
 	struct secids secid;
 	int err;
+	struct security_operations *sop;
 
 	err = security_socket_getpeersec_dgram(NULL, skb, &secid);
 	if (err)
 		return;
 
-	err = security_secid_to_secctx(&secid, &secdata, &seclen);
+	err = security_secid_to_secctx(&secid, &secdata, &seclen, &sop);
 	if (err)
 		return;
 
 	put_cmsg(msg, SOL_IP, SCM_SECURITY, seclen, secdata);
-	security_release_secctx(secdata, seclen);
+	security_release_secctx(secdata, seclen, sop);
 }
 
 static void ip_cmsg_recv_dstaddr(struct msghdr *msg, struct sk_buff *skb)
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
index f7704fe..8f73bfb 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
@@ -101,15 +101,16 @@ static int ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 	u32 len;
 	char *secctx;
 	struct secids secid;
+	struct security_operations *sop;
 
 	lsm_init_secid(&secid, ct->secmark, 0);
-	ret = security_secid_to_secctx(&secid, &secctx, &len);
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
index d45138e..e240d22 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -303,9 +303,10 @@ ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 	int len, ret;
 	char *secctx;
 	struct secids secid;
+	struct security_operations *sop;
 
 	lsm_init_secid(&secid, ct->secmark, 0);
-	ret = security_secid_to_secctx(&secid, &secctx, &len);
+	ret = security_secid_to_secctx(&secid, &secctx, &len, &sop);
 	if (ret)
 		return 0;
 
@@ -320,7 +321,7 @@ ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 
 	ret = 0;
 nla_put_failure:
-	security_release_secctx(secctx, len);
+	security_release_secctx(secctx, len, sop);
 	return ret;
 }
 #else
@@ -552,9 +553,10 @@ ctnetlink_secctx_size(const struct nf_conn *ct)
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
 	int len, ret;
 	struct secids secid;
+	struct security_operations *sop;
 
 	lsm_init_secid(&secid, ct->secmark, 0);
-	ret = security_secid_to_secctx(&secid, NULL, &len);
+	ret = security_secid_to_secctx(&secid, NULL, &len, &sop);
 	if (ret)
 		return 0;
 
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 831116a..8b19091 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -126,15 +126,16 @@ static int ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 	u32 len;
 	char *secctx;
 	struct secids secid;
+	struct security_operations *sop;
 
 	lsm_init_secid(&secid, ct->secmark, 0);
-	ret = security_secid_to_secctx(&secid, &secctx, &len);
+	ret = security_secid_to_secctx(&secid, &secctx, &len, &sop);
 	if (ret)
 		return 0;
 
 	ret = seq_printf(s, "secctx=%s ", secctx);
 
-	security_release_secctx(secctx, len);
+	security_release_secctx(secctx, len, sop);
 	return ret;
 }
 #else
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index 823ed01..9887626 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -59,14 +59,14 @@ static int checkentry_lsm(struct xt_secmark_target_info *info)
 	info->secid = 0;
 
 	err = security_secctx_to_secid(info->secctx, strlen(info->secctx),
-				       &secid);
+				       &secid, lsm_secmark_ops());
 	if (err) {
 		if (err == -EINVAL)
 			pr_info("invalid security context \'%s\'\n", info->secctx);
 		return err;
 	}
 
-	info->secid = lsm_get_secid(&secid, 0);
+	info->secid = lsm_get_secid(&secid, lsm_secmark_order());
 	if (!info->secid) {
 		pr_info("unable to map security context \'%s\'\n", info->secctx);
 		return -ENOENT;
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index cd1e571..3e9064a 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -397,6 +397,7 @@ int netlbl_unlhsh_add(struct net *net,
 	struct secids secids;
 	char *secctx = NULL;
 	u32 secctx_len;
+	struct security_operations *sop;
 
 	if (addr_len != sizeof(struct in_addr) &&
 	    addr_len != sizeof(struct in6_addr))
@@ -462,9 +463,9 @@ unlhsh_add_return:
 		lsm_init_secid(&secids, secid, 0);
 		if (security_secid_to_secctx(&secids,
 					     &secctx,
-					     &secctx_len) == 0) {
+					     &secctx_len, &sop) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s", secctx);
-			security_release_secctx(secctx, secctx_len);
+			security_release_secctx(secctx, secctx_len, sop);
 		}
 		audit_log_format(audit_buf, " res=%u", ret_val == 0 ? 1 : 0);
 		audit_log_end(audit_buf);
@@ -497,6 +498,7 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 	struct net_device *dev;
 	char *secctx;
 	u32 secctx_len;
+	struct security_operations *sop;
 
 	spin_lock(&netlbl_unlhsh_lock);
 	list_entry = netlbl_af4list_remove(addr->s_addr, mask->s_addr,
@@ -518,9 +520,9 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 			dev_put(dev);
 		if (entry != NULL &&
 		    security_secid_to_secctx(&entry->secid,
-					     &secctx, &secctx_len) == 0) {
+					     &secctx, &secctx_len, &sop) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s", secctx);
-			security_release_secctx(secctx, secctx_len);
+			security_release_secctx(secctx, secctx_len, sop);
 		}
 		audit_log_format(audit_buf, " res=%u", entry != NULL ? 1 : 0);
 		audit_log_end(audit_buf);
@@ -559,6 +561,7 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 	struct net_device *dev;
 	char *secctx;
 	u32 secctx_len;
+	struct security_operations *sop;
 
 	spin_lock(&netlbl_unlhsh_lock);
 	list_entry = netlbl_af6list_remove(addr, mask, &iface->addr6_list);
@@ -579,9 +582,9 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 			dev_put(dev);
 		if (entry != NULL &&
 		    security_secid_to_secctx(&entry->secid,
-					     &secctx, &secctx_len) == 0) {
+					     &secctx, &secctx_len, &sop) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s", secctx);
-			security_release_secctx(secctx, secctx_len);
+			security_release_secctx(secctx, secctx_len, sop);
 		}
 		audit_log_format(audit_buf, " res=%u", entry != NULL ? 1 : 0);
 		audit_log_end(audit_buf);
@@ -928,13 +931,13 @@ static int netlbl_unlabel_staticadd(struct sk_buff *skb,
 	ret_val = security_secctx_to_secid(
 		                  nla_data(info->attrs[NLBL_UNLABEL_A_SECCTX]),
 				  nla_len(info->attrs[NLBL_UNLABEL_A_SECCTX]),
-				  &secid);
+				  &secid, lsm_netlbl_ops());
 	if (ret_val != 0)
 		return ret_val;
 
 	return netlbl_unlhsh_add(&init_net,
 				 dev_name, addr, mask, addr_len,
-				 lsm_get_secid(&secid, 0),
+				 lsm_get_secid(&secid, lsm_netlbl_order()),
 				 &audit_info);
 }
 
@@ -978,13 +981,13 @@ static int netlbl_unlabel_staticadddef(struct sk_buff *skb,
 	ret_val = security_secctx_to_secid(
 		                  nla_data(info->attrs[NLBL_UNLABEL_A_SECCTX]),
 				  nla_len(info->attrs[NLBL_UNLABEL_A_SECCTX]),
-				  &secid);
+				  &secid, lsm_netlbl_ops());
 	if (ret_val != 0)
 		return ret_val;
 
 	return netlbl_unlhsh_add(&init_net,
 				 NULL, addr, mask, addr_len,
-				 lsm_get_secid(&secid, 0),
+				 lsm_get_secid(&secid, lsm_netlbl_order()),
 				 &audit_info);
 }
 
@@ -1099,6 +1102,7 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 	struct secids *secid;
 	char *secctx;
 	u32 secctx_len;
+	struct security_operations *sop;
 
 	data = genlmsg_put(cb_arg->skb, NETLINK_CB(cb_arg->nl_cb->skb).portid,
 			   cb_arg->seq, &netlbl_unlabel_gnl_family,
@@ -1157,14 +1161,14 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 		secid = &addr6->secid;
 	}
 
-	ret_val = security_secid_to_secctx(secid, &secctx, &secctx_len);
+	ret_val = security_secid_to_secctx(secid, &secctx, &secctx_len, &sop);
 	if (ret_val != 0)
 		goto list_cb_failure;
 	ret_val = nla_put(cb_arg->skb,
 			  NLBL_UNLABEL_A_SECCTX,
 			  secctx_len,
 			  secctx);
-	security_release_secctx(secctx, secctx_len);
+	security_release_secctx(secctx, secctx_len, sop);
 	if (ret_val != 0)
 		goto list_cb_failure;
 
diff --git a/net/netlabel/netlabel_user.c b/net/netlabel/netlabel_user.c
index 898153c..556f695 100644
--- a/net/netlabel/netlabel_user.c
+++ b/net/netlabel/netlabel_user.c
@@ -101,6 +101,7 @@ struct audit_buffer *netlbl_audit_start_common(int type,
 	struct audit_buffer *audit_buf;
 	char *secctx;
 	u32 secctx_len;
+	struct security_operations *sop;
 
 	if (audit_enabled == 0)
 		return NULL;
@@ -116,9 +117,9 @@ struct audit_buffer *netlbl_audit_start_common(int type,
 	if (!lsm_zero_secid(&audit_info->secid) &&
 	    security_secid_to_secctx(&audit_info->secid,
 				     &secctx,
-				     &secctx_len) == 0) {
+				     &secctx_len, &sop) == 0) {
 		audit_log_format(audit_buf, " subj=%s", secctx);
-		security_release_secctx(secctx, secctx_len);
+		security_release_secctx(secctx, secctx_len, sop);
 	}
 
 	return audit_buf;
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 85f6bca..bacf995 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -619,7 +619,7 @@ static int xfrm_add_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
 		err = xfrm_state_update(x);
 
 	security_task_getsecid(current, &sids);
-	sid = lsm_get_secid(&sids, 0);
+	sid = lsm_get_secid(&sids, lsm_xfrm_order());
 	xfrm_audit_state_add(x, err ? 0 : 1, loginuid, sessionid, sid);
 
 	if (err < 0) {
@@ -709,7 +709,7 @@ static int xfrm_del_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 out:
 	security_task_getsecid(current, &sids);
-	sid = lsm_get_secid(&sids, 0);
+	sid = lsm_get_secid(&sids, lsm_xfrm_order());
 	xfrm_audit_state_delete(x, err ? 0 : 1, loginuid, sessionid, sid);
 	xfrm_state_put(x);
 	return err;
@@ -1431,7 +1431,7 @@ static int xfrm_add_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 	excl = nlh->nlmsg_type == XFRM_MSG_NEWPOLICY;
 	err = xfrm_policy_insert(p->dir, xp, excl);
 	security_task_getsecid(current, &sids);
-	sid = lsm_get_secid(&sids, 0);
+	sid = lsm_get_secid(&sids, lsm_xfrm_order());
 	xfrm_audit_policy_add(xp, err ? 0 : 1, loginuid, sessionid, sid);
 
 	if (err) {
@@ -1674,7 +1674,7 @@ static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 		struct secids sids;
 
 		security_task_getsecid(current, &sids);
-		sid = lsm_get_secid(&sids, 0);
+		sid = lsm_get_secid(&sids, lsm_xfrm_order());
 		xfrm_audit_policy_delete(xp, err ? 0 : 1, loginuid, sessionid,
 					 sid);
 
@@ -1708,7 +1708,7 @@ static int xfrm_flush_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
 	audit_info.loginuid = audit_get_loginuid(current);
 	audit_info.sessionid = audit_get_sessionid(current);
 	security_task_getsecid(current, &secid);
-	audit_info.secid = lsm_get_secid(&secid, 0);
+	audit_info.secid = lsm_get_secid(&secid, lsm_xfrm_order());
 	err = xfrm_state_flush(net, p->proto, &audit_info);
 	if (err) {
 		if (err == -ESRCH) /* empty table */
@@ -1903,7 +1903,7 @@ static int xfrm_flush_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 	audit_info.loginuid = audit_get_loginuid(current);
 	audit_info.sessionid = audit_get_sessionid(current);
 	security_task_getsecid(current, &secid);
-	audit_info.secid = lsm_get_secid(&secid, 0);
+	audit_info.secid = lsm_get_secid(&secid, lsm_xfrm_order());
 	err = xfrm_policy_flush(net, type, &audit_info);
 	if (err) {
 		if (err == -ESRCH) /* empty table */
@@ -1976,7 +1976,7 @@ static int xfrm_add_pol_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
 		struct secids sids;
 
 		security_task_getsecid(current, &sids);
-		sid = lsm_get_secid(&sids, 0);
+		sid = lsm_get_secid(&sids, lsm_xfrm_order());
 		xfrm_policy_delete(xp, p->dir);
 		xfrm_audit_policy_delete(xp, 1, loginuid, sessionid, sid);
 
@@ -2021,7 +2021,7 @@ static int xfrm_add_sa_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
 		struct secids sids;
 
 		security_task_getsecid(current, &sids);
-		sid = lsm_get_secid(&sids, 0);
+		sid = lsm_get_secid(&sids, lsm_xfrm_order());
 		__xfrm_state_delete(x);
 		xfrm_audit_state_delete(x, 1, loginuid, sessionid, sid);
 	}
diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index 1614111..2286daa 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -353,9 +353,7 @@ int apparmor_bprm_set_creds(struct linux_binprm *bprm)
 		file_inode(bprm->file)->i_mode
 	};
 	const char *name = NULL, *target = NULL, *info = NULL;
-	int error = cap_bprm_set_creds(bprm);
-	if (error)
-		return error;
+	int error;
 
 	if (bprm->cred_prepared)
 		return 0;
@@ -539,15 +537,12 @@ cleanup:
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
+	if (bprm->unsafe & AA_SECURE_X_NEEDED)
+		return 1;
+	return 0;
 }
 
 /**
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 64557a0..c9c463b 100644
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
 
@@ -139,15 +131,11 @@ static int apparmor_capget(struct task_struct *target, kernel_cap_t *effective,
 static int apparmor_capable(const struct cred *cred, struct user_namespace *ns,
 			    int cap, int audit)
 {
-	struct aa_profile *profile;
-	/* cap_capable returns 0 on success, else -EPERM */
-	int error = cap_capable(cred, ns, cap, audit);
-	if (!error) {
-		profile = aa_cred_profile(cred);
-		if (!unconfined(profile))
-			error = aa_capable(current, profile, cap, audit);
-	}
-	return error;
+	struct aa_profile *profile = aa_cred_profile(cred);
+
+	if (!unconfined(profile))
+		return aa_capable(current, profile, cap, audit);
+	return 0;
 }
 
 /**
diff --git a/security/security.c b/security/security.c
index 19759ad..8e5a77d 100644
--- a/security/security.c
+++ b/security/security.c
@@ -33,7 +33,9 @@
 static __initdata char chosen_lsm[SECURITY_NAME_MAX + 1] =
 	CONFIG_DEFAULT_SECURITY;
 
-static struct security_operations *security_ops;
+struct security_operations *security_ops;
+EXPORT_SYMBOL(security_ops);
+
 static struct security_operations default_security_ops = {
 	.name	= "default",
 };
@@ -137,19 +139,28 @@ int __init register_security(struct security_operations *ops)
 
 int security_ptrace_access_check(struct task_struct *child, unsigned int mode)
 {
+	int rc = cap_ptrace_access_check(child, mode);
+
+	if (rc)
+		return rc;
+
 #ifdef CONFIG_SECURITY_YAMA_STACKED
-	int rc;
 	rc = yama_ptrace_access_check(child, mode);
 	if (rc)
 		return rc;
 #endif
+
 	return security_ops->ptrace_access_check(child, mode);
 }
 
 int security_ptrace_traceme(struct task_struct *parent)
 {
+	int rc = cap_ptrace_traceme(parent);
+
+	if (rc)
+		return rc;
+
 #ifdef CONFIG_SECURITY_YAMA_STACKED
-	int rc;
 	rc = yama_ptrace_traceme(parent);
 	if (rc)
 		return rc;
@@ -162,6 +173,10 @@ int security_capget(struct task_struct *target,
 		     kernel_cap_t *inheritable,
 		     kernel_cap_t *permitted)
 {
+	int rc = cap_capget(target, effective, inheritable, permitted);
+
+	if (rc)
+		return rc;
 	return security_ops->capget(target, effective, inheritable, permitted);
 }
 
@@ -170,6 +185,10 @@ int security_capset(struct cred *new, const struct cred *old,
 		    const kernel_cap_t *inheritable,
 		    const kernel_cap_t *permitted)
 {
+	int rc = cap_capset(new, old, effective, inheritable, permitted);
+
+	if (rc)
+		return rc;
 	return security_ops->capset(new, old,
 				    effective, inheritable, permitted);
 }
@@ -177,12 +196,20 @@ int security_capset(struct cred *new, const struct cred *old,
 int security_capable(const struct cred *cred, struct user_namespace *ns,
 		     int cap)
 {
+	int rc = cap_capable(cred, ns, cap, SECURITY_CAP_AUDIT);
+
+	if (rc)
+		return rc;
 	return security_ops->capable(cred, ns, cap, SECURITY_CAP_AUDIT);
 }
 
 int security_capable_noaudit(const struct cred *cred, struct user_namespace *ns,
 			     int cap)
 {
+	int rc = cap_capable(cred, ns, cap, SECURITY_CAP_NOAUDIT);
+
+	if (rc)
+		return rc;
 	return security_ops->capable(cred, ns, cap, SECURITY_CAP_NOAUDIT);
 }
 
@@ -203,16 +230,28 @@ int security_syslog(int type)
 
 int security_settime(const struct timespec *ts, const struct timezone *tz)
 {
+	int rc = cap_settime(ts, tz);
+
+	if (rc)
+		return rc;
 	return security_ops->settime(ts, tz);
 }
 
 int security_vm_enough_memory_mm(struct mm_struct *mm, long pages)
 {
+	int rc = cap_vm_enough_memory(mm, pages);
+
+	if (rc)
+		return rc;
 	return security_ops->vm_enough_memory(mm, pages);
 }
 
 int security_bprm_set_creds(struct linux_binprm *bprm)
 {
+	int rc = cap_bprm_set_creds(bprm);
+
+	if (rc)
+		return rc;
 	return security_ops->bprm_set_creds(bprm);
 }
 
@@ -238,7 +277,11 @@ void security_bprm_committed_creds(struct linux_binprm *bprm)
 
 int security_bprm_secureexec(struct linux_binprm *bprm)
 {
-	return security_ops->bprm_secureexec(bprm);
+	int rc = security_ops->bprm_secureexec(bprm);
+
+	if (rc)
+		return rc;
+	return cap_bprm_secureexec(bprm);
 }
 
 int security_sb_alloc(struct super_block *sb)
@@ -620,15 +663,25 @@ int security_inode_removexattr(struct dentry *dentry, const char *name)
 
 int security_inode_need_killpriv(struct dentry *dentry)
 {
+	int rc = cap_inode_need_killpriv(dentry);
+
+	if (rc)
+		return rc;
 	return security_ops->inode_need_killpriv(dentry);
 }
 
 int security_inode_killpriv(struct dentry *dentry)
 {
+	int rc = cap_inode_killpriv(dentry);
+
+	if (rc)
+		return rc;
 	return security_ops->inode_killpriv(dentry);
 }
 
-int security_inode_getsecurity(const struct inode *inode, const char *name, void **buffer, bool alloc)
+int security_inode_getsecurity(const struct inode *inode, const char *name,
+			       void **buffer, bool alloc,
+			       struct security_operations **sop)
 {
 	if (unlikely(IS_PRIVATE(inode)))
 		return -EOPNOTSUPP;
@@ -730,7 +783,11 @@ int security_mmap_file(struct file *file, unsigned long prot,
 
 int security_mmap_addr(unsigned long addr)
 {
-	return security_ops->mmap_addr(addr);
+	int rc = security_ops->mmap_addr(addr);
+
+	if (rc)
+		return rc;
+	return cap_mmap_addr(addr);
 }
 
 int security_file_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
@@ -837,6 +894,10 @@ int security_kernel_module_from_file(struct file *file)
 int security_task_fix_setuid(struct cred *new, const struct cred *old,
 			     int flags)
 {
+	int rc = cap_task_fix_setuid(new, old, flags);
+
+	if (rc)
+		return rc;
 	return security_ops->task_fix_setuid(new, old, flags);
 }
 
@@ -866,11 +927,19 @@ EXPORT_SYMBOL(security_task_getsecid);
 
 int security_task_setnice(struct task_struct *p, int nice)
 {
+	int rc = cap_task_setnice(p, nice);
+
+	if (rc)
+		return rc;
 	return security_ops->task_setnice(p, nice);
 }
 
 int security_task_setioprio(struct task_struct *p, int ioprio)
 {
+	int rc = cap_task_setioprio(p, ioprio);
+
+	if (rc)
+		return rc;
 	return security_ops->task_setioprio(p, ioprio);
 }
 
@@ -887,6 +956,10 @@ int security_task_setrlimit(struct task_struct *p, unsigned int resource,
 
 int security_task_setscheduler(struct task_struct *p)
 {
+	int rc = cap_task_setscheduler(p);
+
+	if (rc)
+		return rc;
 	return security_ops->task_setscheduler(p);
 }
 
@@ -1054,10 +1127,15 @@ int security_setprocattr(struct task_struct *p, char *name, void *value, size_t
 
 int security_netlink_send(struct sock *sk, struct sk_buff *skb)
 {
+	int rc = cap_netlink_send(sk, skb);
+
+	if (rc)
+		return rc;
 	return security_ops->netlink_send(sk, skb);
 }
 
-int security_secid_to_secctx(struct secids *secid, char **secdata, u32 *seclen)
+int security_secid_to_secctx(struct secids *secid, char **secdata, u32 *seclen,
+			     struct security_operations **sop)
 {
 	return security_ops->secid_to_secctx(lsm_get_secid(secid, 0),
 						secdata, seclen);
@@ -1065,7 +1143,8 @@ int security_secid_to_secctx(struct secids *secid, char **secdata, u32 *seclen)
 EXPORT_SYMBOL(security_secid_to_secctx);
 
 int security_secctx_to_secid(const char *secdata, u32 seclen,
-				struct secids *secid)
+			     struct secids *secid,
+			     struct security_operations *sop)
 {
 	u32 sid;
 	int rc;
@@ -1076,7 +1155,8 @@ int security_secctx_to_secid(const char *secdata, u32 seclen,
 }
 EXPORT_SYMBOL(security_secctx_to_secid);
 
-void security_release_secctx(char *secdata, u32 seclen)
+void security_release_secctx(char *secdata, u32 seclen,
+			     struct security_operations *sop)
 {
 	security_ops->release_secctx(secdata, seclen);
 }
@@ -1094,7 +1174,8 @@ int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen)
 }
 EXPORT_SYMBOL(security_inode_setsecctx);
 
-int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen)
+int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen,
+			     struct security_operations **sop)
 {
 	return security_ops->inode_getsecctx(inode, ctx, ctxlen);
 }
@@ -1261,7 +1342,8 @@ void security_inet_conn_established(struct sock *sk,
 
 int security_secmark_relabel_packet(struct secids *secid)
 {
-	return security_ops->secmark_relabel_packet(lsm_get_secid(secid, 0));
+	return security_ops->secmark_relabel_packet(lsm_get_secid(secid,
+							lsm_secmark_order()));
 }
 EXPORT_SYMBOL(security_secmark_relabel_packet);
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 4cd7556..42b4bbb 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1848,12 +1848,6 @@ static inline u32 open_file_to_av(struct file *file)
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
@@ -1865,25 +1859,13 @@ static int selinux_ptrace_access_check(struct task_struct *child,
 
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
 
 static int selinux_capget(struct task_struct *target, kernel_cap_t *effective,
 			  kernel_cap_t *inheritable, kernel_cap_t *permitted)
 {
-	int error;
-
-	error = current_has_perm(target, PROCESS__GETCAP);
-	if (error)
-		return error;
-
-	return cap_capget(target, effective, inheritable, permitted);
+	return current_has_perm(target, PROCESS__GETCAP);
 }
 
 static int selinux_capset(struct cred *new, const struct cred *old,
@@ -1891,13 +1873,6 @@ static int selinux_capset(struct cred *new, const struct cred *old,
 			  const kernel_cap_t *inheritable,
 			  const kernel_cap_t *permitted)
 {
-	int error;
-
-	error = cap_capset(new, old,
-				      effective, inheritable, permitted);
-	if (error)
-		return error;
-
 	return cred_has_perm(old, new, PROCESS__SETCAP);
 }
 
@@ -1914,12 +1889,6 @@ static int selinux_capset(struct cred *new, const struct cred *old,
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
 
@@ -2014,11 +1983,7 @@ static int selinux_bprm_set_creds(struct linux_binprm *bprm)
 	struct inode_security_struct *isec;
 	struct common_audit_data ad;
 	struct inode *inode = file_inode(bprm->file);
-	int rc;
-
-	rc = cap_bprm_set_creds(bprm);
-	if (rc)
-		return rc;
+	int rc = 0;
 
 	/* SELinux context only depends on initial program or script and not
 	 * the script interpreter */
@@ -2143,7 +2108,7 @@ static int selinux_bprm_secureexec(struct linux_binprm *bprm)
 					PROCESS__NOATSECURE, NULL);
 	}
 
-	return (atsecure || cap_bprm_secureexec(bprm));
+	return atsecure;
 }
 
 static int match_file(const void *p, struct file *file, unsigned fd)
@@ -3126,15 +3091,11 @@ static int selinux_mmap_addr(unsigned long addr)
 	 * at bad behaviour/exploit that we always want to get the AVC, even
 	 * if DAC would have also denied the operation.
 	 */
-	if (addr < CONFIG_LSM_MMAP_MIN_ADDR) {
+	if (addr < CONFIG_LSM_MMAP_MIN_ADDR)
 		rc = avc_has_perm(sid, sid, SECCLASS_MEMPROTECT,
 				  MEMPROTECT__MMAP_ZERO, NULL);
-		if (rc)
-			return rc;
-	}
 
-	/* do DAC check on address space usage */
-	return cap_mmap_addr(addr);
+	return rc;
 }
 
 static int selinux_mmap_file(struct file *file, unsigned long reqprot,
@@ -3442,23 +3403,11 @@ static void selinux_task_getsecid(struct task_struct *p, u32 *secid)
 
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
 
@@ -3484,12 +3433,6 @@ static int selinux_task_setrlimit(struct task_struct *p, unsigned int resource,
 
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
 
@@ -4834,12 +4777,6 @@ static unsigned int selinux_ipv6_postroute(unsigned int hooknum,
 
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
 
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 71b0939..f7de6bb 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -3130,7 +3130,7 @@ int security_netlbl_secattr_to_sid(struct netlbl_lsm_secattr *secattr,
 	if (secattr->flags & NETLBL_SECATTR_CACHE)
 		*sid = *(u32 *)secattr->cache->data;
 	else if (secattr->flags & NETLBL_SECATTR_SECID)
-		*sid = lsm_get_secid(&secattr->attr.secid, 0);
+		*sid = lsm_get_secid(&secattr->attr.secid, lsm_netlbl_order());
 	else if (secattr->flags & NETLBL_SECATTR_MLS_LVL) {
 		rc = -EIDRM;
 		ctx = sidtab_search(&sidtab, SECINITSID_NETMSG);
@@ -3205,7 +3205,7 @@ int security_netlbl_sid_to_secattr(u32 sid, struct netlbl_lsm_secattr *secattr)
 	if (secattr->domain == NULL)
 		goto out;
 
-	lsm_set_secid(&secattr->attr.secid, sid, 0);
+	lsm_set_secid(&secattr->attr.secid, sid, lsm_netlbl_order());
 	secattr->flags |= NETLBL_SECATTR_DOMAIN_CPY | NETLBL_SECATTR_SECID;
 	mls_export_netlbl_lvl(ctx, secattr);
 	rc = mls_export_netlbl_cat(ctx, secattr);
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 0170afd..7b9131a 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -166,10 +166,6 @@ static int smack_ptrace_access_check(struct task_struct *ctp, unsigned int mode)
 	struct smk_audit_info ad;
 	char *tsp;
 
-	rc = cap_ptrace_access_check(ctp, mode);
-	if (rc != 0)
-		return rc;
-
 	tsp = smk_of_task(task_security(ctp));
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
 	smk_ad_setfield_u_tsk(&ad, ctp);
@@ -192,10 +188,6 @@ static int smack_ptrace_traceme(struct task_struct *ptp)
 	struct smk_audit_info ad;
 	char *tsp;
 
-	rc = cap_ptrace_traceme(ptp);
-	if (rc != 0)
-		return rc;
-
 	tsp = smk_of_task(task_security(ptp));
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
 	smk_ad_setfield_u_tsk(&ad, ptp);
@@ -460,11 +452,6 @@ static int smack_bprm_set_creds(struct linux_binprm *bprm)
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
@@ -505,12 +492,10 @@ static void smack_bprm_committing_creds(struct linux_binprm *bprm)
 static int smack_bprm_secureexec(struct linux_binprm *bprm)
 {
 	struct task_smack *tsp = lsm_get_cred(current_cred(), &smack_ops);
-	int ret = cap_bprm_secureexec(bprm);
-
-	if (!ret && (tsp->smk_task != tsp->smk_forked))
-		ret = 1;
 
-	return ret;
+	if (tsp->smk_task != tsp->smk_forked)
+		return 1;
+	return 0;
 }
 
 /*
@@ -1571,12 +1556,7 @@ static void smack_task_getsecid(struct task_struct *p, u32 *secid)
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
@@ -1588,12 +1568,7 @@ static int smack_task_setnice(struct task_struct *p, int nice)
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
@@ -1617,12 +1592,7 @@ static int smack_task_getioprio(struct task_struct *p)
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
@@ -2860,7 +2830,8 @@ static char *smack_from_secattr(struct netlbl_lsm_secattr *sap,
 		/*
 		 * Looks like a fallback, which gives us a secid.
 		 */
-		sp = smack_from_secid(lsm_get_secid(&sap->attr.secid, 0));
+		sp = smack_from_secid(lsm_get_secid(&sap->attr.secid,
+					lsm_netlbl_order()));
 		/*
 		 * This has got to be a bug because it is
 		 * impossible to specify a fallback without
diff --git a/security/tomoyo/common.h b/security/tomoyo/common.h
index 9285c23..a2906d3 100644
--- a/security/tomoyo/common.h
+++ b/security/tomoyo/common.h
@@ -1217,7 +1217,7 @@ static inline struct tomoyo_domain_info *tomoyo_domain(void)
 static inline struct tomoyo_domain_info *tomoyo_real_domain(struct task_struct
 							    *task)
 {
-	return task_cred_xxx(task, security);
+	 return lsm_get_cred(__task_cred(task), &tomoyo_ops);
 }
 
 /**
diff --git a/security/tomoyo/tomoyo.c b/security/tomoyo/tomoyo.c
index 624d8f2..5b410b3 100644
--- a/security/tomoyo/tomoyo.c
+++ b/security/tomoyo/tomoyo.c
@@ -72,12 +72,6 @@ static void tomoyo_cred_free(struct cred *cred)
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
diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
index 13c88fbc..cf57c7f 100644
--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -154,13 +154,9 @@ void yama_task_free(struct task_struct *task)
 int yama_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			   unsigned long arg4, unsigned long arg5)
 {
-	int rc;
+	int rc = 0;
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


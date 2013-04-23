Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab3DWQEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:04:31 -0400
Received: from nm5.access.bullet.mail.sp2.yahoo.com ([98.139.44.132]:29671
	"EHLO nm5.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756691Ab3DWQE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:04:26 -0400
X-Yahoo-Newman-Id: 619306.3822.bm@smtp107.biz.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: .eeCEtAVM1kIpATSsDZi965enmRuKteL00E7Pyw7vrS3uzY
 g3GpDEoVTF4R0HEzqpPkAT9lcXhXqXhAdeddo_iZ5xfMilMRCodiyKj1Rjc8
 cEUrOYywh2fFiElhzy_j4GFT3SCMQaawvgdLdbA9sbU_xzt7iiI_KFCoA9kA
 fzefy0uovfhApAQcBzt1n7K8BZW0e_wop9ETZDIQSuNK_GrgAAZHuK2D2h5N
 ccM2RL5jQQCRdqJySc7SY31QjFcUEHBbnnBqUf7m6AXl_5fo4CKfJ6n3HDSY
 nUWDLLPNUiH.MYSYURwsBVNxQgNSXoAckNRplejD7w_IvY7z_jimMViWlfBS
 BIG8CeOpH3KIsBenYofzcMajSzrct5DxPGaAcxB.lwzeVrHzmvg20Pg81OhF
 Nj29lbInx5biu1BnGV1PKXTNiL61ccCZ_9S7xothsXgp0fnLBL4aqZgJzuYI
 hjA--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with plain)
        by smtp107.biz.mail.ne1.yahoo.com with SMTP; 23 Apr 2013 09:04:24 -0700 PDT
Message-ID: <5176B109.1070508@schaufler-ca.com>
Date: Tue, 23 Apr 2013 09:04:25 -0700
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
Subject: [PATCH v13 4/9] LSM: Multiple security context maintenance
References: <5176ABB7.5080300@schaufler-ca.com>
In-Reply-To: <5176ABB7.5080300@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH v13 4/9] LSM: Multiple security context maintenance

The legacy use of a security context is that there is
a text string which is interpreted by a single LSM.
When there is more than one LSM that uses a security
context the conbined string is managed by the lsm
infrastructure. Because the blob release mechanism
can't tell how the blob was allocated it's necessary
to tell it. This is accomplished by providing the
security operations pointer of the LSM that created
the context or NULL if it was created by the lsm
infrastructure.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---
 fs/sysfs/dir.c                          |    3 ++-
 fs/sysfs/inode.c                        |    5 +++--
 fs/sysfs/sysfs.h                        |    7 ++++---
 fs/xattr.c                              |    8 +++++---
 include/linux/security.h                |   22 ++++++++++++----------
 include/net/scm.h                       |    6 ++++--
 include/net/xfrm.h                      |    5 +++--
 kernel/audit.c                          |   23 +++++++++++++----------
 kernel/auditfilter.c                    |    5 +++--
 kernel/auditsc.c                        |   20 ++++++++++++--------
 net/ipv4/ip_sockglue.c                  |    5 +++--
 net/netfilter/nf_conntrack_netlink.c    |   12 +++++-------
 net/netfilter/nf_conntrack_standalone.c |    5 +++--
 net/netlabel/netlabel_unlabeled.c       |   21 +++++++++++++--------
 net/netlabel/netlabel_user.c            |    5 +++--
 security/security.c                     |   13 +++++++++----
 16 files changed, 97 insertions(+), 68 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index e145126..9470c42 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -287,7 +287,8 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
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
index 0ce3ccf..4c318a3 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -157,6 +157,7 @@ static int sysfs_sd_setsecdata(struct sysfs_dirent *sd, void **secdata, u32 *sec
 int sysfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 		size_t size, int flags)
 {
+	struct security_operations *sop;
 	struct sysfs_dirent *sd = dentry->d_fsdata;
 	void *secdata;
 	int error;
@@ -172,7 +173,7 @@ int sysfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 		if (error)
 			goto out;
 		error = security_inode_getsecctx(dentry->d_inode,
-						&secdata, &secdata_len);
+						&secdata, &secdata_len, &sop);
 		if (error)
 			goto out;
 
@@ -181,7 +182,7 @@ int sysfs_setxattr(struct dentry *dentry, const char *name, const void *value,
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
index 3377dff..542e78d 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -146,15 +146,17 @@ ssize_t
 xattr_getsecurity(struct inode *inode, const char *name, void *value,
 			size_t size)
 {
+	struct security_operations *sop;
 	void *buffer = NULL;
 	ssize_t len;
 
 	if (!value || !size) {
-		len = security_inode_getsecurity(inode, name, &buffer, false);
+		len = security_inode_getsecurity(inode, name, &buffer,
+							false, &sop);
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
diff --git a/include/linux/security.h b/include/linux/security.h
index 038df6f..4430b09 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1323,9 +1323,11 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	Convert secid to security context.  If secdata is NULL the length of
  *	the result will be returned in seclen, but no secdata will be returned.
  *	This does mean that the length could change between calls to check the
- *	length and the next call which actually allocates and returns the secdata.
- *	@secid contains the security ID.
- *	@secdata contains the pointer that stores the converted security context.
+ *	length and the next call which actually allocates and returns the
+ *	secdata.
+ *	@secid contains the security IDs.
+ *	@secdata contains the pointer that stores the converted security
+ *	context.
  *	@seclen pointer which contains the length of the data
  * @secctx_to_secid:
  *	Convert security context to secid.
@@ -1770,7 +1772,7 @@ int security_inode_listxattr(struct dentry *dentry);
 int security_inode_removexattr(struct dentry *dentry, const char *name);
 int security_inode_need_killpriv(struct dentry *dentry);
 int security_inode_killpriv(struct dentry *dentry);
-int security_inode_getsecurity(const struct inode *inode, const char *name, void **buffer, bool alloc);
+int security_inode_getsecurity(const struct inode *inode, const char *name, void **buffer, bool alloc, struct security_operations **secops);
 int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags);
 int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size);
 void security_inode_getsecid(const struct inode *inode, struct secids *secid);
@@ -1847,13 +1849,13 @@ void security_d_instantiate(struct dentry *dentry, struct inode *inode);
 int security_getprocattr(struct task_struct *p, char *name, char **value);
 int security_setprocattr(struct task_struct *p, char *name, void *value, size_t size);
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
-int security_secid_to_secctx(struct secids *secid, char **secdata, u32 *seclen);
+int security_secid_to_secctx(struct secids *secid, char **secdata, u32 *seclen, struct security_operations **secops);
 int security_secctx_to_secid(const char *secdata, u32 seclen, struct secids *secid);
-void security_release_secctx(char *secdata, u32 seclen);
+void security_release_secctx(char *secdata, u32 seclen, struct security_operations *secops);
 
 int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
 int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen);
-int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen);
+int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen, struct security_operations **secops);
 #else /* CONFIG_SECURITY */
 struct security_mnt_opts {
 };
@@ -2178,7 +2180,7 @@ static inline int security_inode_killpriv(struct dentry *dentry)
 	return cap_inode_killpriv(dentry);
 }
 
-static inline int security_inode_getsecurity(const struct inode *inode, const char *name, void **buffer, bool alloc)
+static inline int security_inode_getsecurity(const struct inode *inode, const char *name, void **buffer, bool alloc, struct security_operations **secops)
 {
 	return -EOPNOTSUPP;
 }
@@ -2525,7 +2527,7 @@ static inline int security_netlink_send(struct sock *sk, struct sk_buff *skb)
 	return cap_netlink_send(sk, skb);
 }
 
-static inline int security_secid_to_secctx(struct secids *secid, char **secdata, u32 *seclen)
+static inline int security_secid_to_secctx(struct secids *secid, char **secdata, u32 *seclen, struct security_operations **secops)
 {
 	return -EOPNOTSUPP;
 }
@@ -2549,7 +2551,7 @@ static inline int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32
 {
 	return -EOPNOTSUPP;
 }
-static inline int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen)
+static inline int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen, struct security_operations **secops)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/include/net/scm.h b/include/net/scm.h
index e0ce1eb..33d1dda 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -92,16 +92,18 @@ static __inline__ int scm_send(struct socket *sock, struct msghdr *msg,
 #ifdef CONFIG_SECURITY_NETWORK
 static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct scm_cookie *scm)
 {
+	struct security_operations *sop;
 	char *secdata;
 	u32 seclen;
 	int err;
 
 	if (test_bit(SOCK_PASSSEC, &sock->flags)) {
-		err = security_secid_to_secctx(&scm->secid, &secdata, &seclen);
+		err = security_secid_to_secctx(&scm->secid, &secdata, &seclen,
+						&sop);
 
 		if (!err) {
 			put_cmsg(msg, SOL_SOCKET, SCM_SECURITY, seclen, secdata);
-			security_release_secctx(secdata, seclen);
+			security_release_secctx(secdata, seclen, sop);
 		}
 	}
 }
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 45976ad..1dd770e 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -699,15 +699,16 @@ static inline void xfrm_audit_helper_usrinfo(kuid_t auid, u32 ses, u32 secid,
 	char *secctx;
 	u32 secctx_len;
 	struct secids sid;
+	struct security_operations *sop;
 
 	sid.si_lsm[0] = secid;
 
 	audit_log_format(audit_buf, " auid=%u ses=%u",
 			 from_kuid(&init_user_ns, auid), ses);
 	if (secid != 0 &&
-	    security_secid_to_secctx(&sid, &secctx, &secctx_len) == 0) {
+	    security_secid_to_secctx(&sid, &secctx, &secctx_len, &sop) == 0) {
 		audit_log_format(audit_buf, " subj=%s", secctx);
-		security_release_secctx(secctx, secctx_len);
+		security_release_secctx(secctx, secctx_len, sop);
 	} else
 		audit_log_task_context(audit_buf);
 }
diff --git a/kernel/audit.c b/kernel/audit.c
index eab4b52..a01ab21 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -268,6 +268,7 @@ static int audit_log_config_change(char *function_name, int new, int old,
 				   kuid_t loginuid, u32 sessionid,
 				   struct secids *sid, int allow_changes)
 {
+	struct security_operations *sop;
 	struct audit_buffer *ab;
 	int rc = 0;
 
@@ -280,13 +281,13 @@ static int audit_log_config_change(char *function_name, int new, int old,
 		char *ctx = NULL;
 		u32 len;
 
-		rc = security_secid_to_secctx(sid, &ctx, &len);
+		rc = security_secid_to_secctx(sid, &ctx, &len, &sop);
 		if (rc) {
 			audit_log_format(ab, " sid=%u", sid->si_count);
 			allow_changes = 0; /* Something weird, deny request */
 		} else {
 			audit_log_format(ab, " subj=%s", ctx);
-			security_release_secctx(ctx, len);
+			security_release_secctx(ctx, len, sop);
 		}
 	}
 	audit_log_format(ab, " res=%d", allow_changes);
@@ -611,6 +612,7 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
 static int audit_log_common_recv_msg(struct audit_buffer **ab, u16 msg_type,
 				     kuid_t auid, u32 ses, struct secids *sid)
 {
+	struct security_operations *sop;
 	int rc = 0;
 	char *ctx = NULL;
 	u32 len;
@@ -628,12 +630,12 @@ static int audit_log_common_recv_msg(struct audit_buffer **ab, u16 msg_type,
 			 from_kuid(&init_user_ns, current_uid()),
 			 from_kuid(&init_user_ns, auid), ses);
 	if (sid) {
-		rc = security_secid_to_secctx(sid, &ctx, &len);
+		rc = security_secid_to_secctx(sid, &ctx, &len, &sop);
 		if (rc)
 			audit_log_format(*ab, " ssid=%u", sid->si_count);
 		else {
 			audit_log_format(*ab, " subj=%s", ctx);
-			security_release_secctx(ctx, len);
+			security_release_secctx(ctx, len, sop);
 		}
 	}
 
@@ -642,6 +644,7 @@ static int audit_log_common_recv_msg(struct audit_buffer **ab, u16 msg_type,
 
 static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 {
+	struct security_operations *sop;
 	u32			seq;
 	struct secids		sid;
 	void			*data;
@@ -850,21 +853,21 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		len = 0;
 		if (audit_sig_sid.si_count) {
 			err = security_secid_to_secctx(&audit_sig_sid, &ctx,
-							&len);
+							&len, &sop);
 			if (err)
 				return err;
 		}
 		sig_data = kmalloc(sizeof(*sig_data) + len, GFP_KERNEL);
 		if (!sig_data) {
 			if (audit_sig_sid.si_count)
-				security_release_secctx(ctx, len);
+				security_release_secctx(ctx, len, sop);
 			return -ENOMEM;
 		}
 		sig_data->uid = from_kuid(&init_user_ns, audit_sig_uid);
 		sig_data->pid = audit_sig_pid;
 		if (audit_sig_sid.si_count) {
 			memcpy(sig_data->ctx, ctx, len);
-			security_release_secctx(ctx, len);
+			security_release_secctx(ctx, len, sop);
 		}
 		audit_send_reply(NETLINK_CB(skb).portid, seq, AUDIT_SIGNAL_INFO,
 				0, 0, sig_data, sizeof(*sig_data) + len);
@@ -1544,17 +1547,17 @@ void audit_log_secctx(struct audit_buffer *ab, u32 secid)
 	u32 len;
 	char *secctx;
 	struct secids secids;
+	struct security_operations *sop;
 
 	memset(&secids, 0, sizeof(secids));
 
 	secids.si_lsm[0] = secid;
-	secids.si_count = 1;
 
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
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 765873b..9a65644 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1114,6 +1114,7 @@ static void audit_log_rule_change(kuid_t loginuid, u32 sessionid,
 				  struct audit_krule *rule,
 				  int res)
 {
+	struct security_operations *sop;
 	struct audit_buffer *ab;
 
 	if (!audit_enabled)
@@ -1127,11 +1128,11 @@ static void audit_log_rule_change(kuid_t loginuid, u32 sessionid,
 	if (sid->si_count) {
 		char *ctx = NULL;
 		u32 len;
-		if (security_secid_to_secctx(sid, &ctx, &len))
+		if (security_secid_to_secctx(sid, &ctx, &len, &sop))
 			audit_log_format(ab, " ssid=%u", sid->si_count);
 		else {
 			audit_log_format(ab, " subj=%s", ctx);
-			security_release_secctx(ctx, len);
+			security_release_secctx(ctx, len, sop);
 		}
 	}
 	audit_log_format(ab, " op=");
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index e7e788b..c00fe05 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1109,12 +1109,13 @@ void audit_log_task_context(struct audit_buffer *ab)
 	unsigned len;
 	int error;
 	struct secids sid;
+	struct security_operations *sop;
 
 	security_task_getsecid(current, &sid);
 	if (sid.si_count == 0)
 		return;
 
-	error = security_secid_to_secctx(&sid, &ctx, &len);
+	error = security_secid_to_secctx(&sid, &ctx, &len, &sop);
 	if (error) {
 		if (error != -EINVAL)
 			goto error_path;
@@ -1122,7 +1123,7 @@ void audit_log_task_context(struct audit_buffer *ab)
 	}
 
 	audit_log_format(ab, " subj=%s", ctx);
-	security_release_secctx(ctx, len);
+	security_release_secctx(ctx, len, sop);
 	return;
 
 error_path:
@@ -1190,6 +1191,7 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 				 unsigned int sessionid, struct secids *sid,
 				 char *comm)
 {
+	struct security_operations *sop;
 	struct audit_buffer *ab;
 	char *ctx = NULL;
 	u32 len;
@@ -1202,12 +1204,12 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 	audit_log_format(ab, "opid=%d oauid=%d ouid=%d oses=%d", pid,
 			 from_kuid(&init_user_ns, auid),
 			 from_kuid(&init_user_ns, uid), sessionid);
-	if (security_secid_to_secctx(sid, &ctx, &len)) {
+	if (security_secid_to_secctx(sid, &ctx, &len, &sop)) {
 		audit_log_format(ab, " obj=(none)");
 		rc = 1;
 	} else {
 		audit_log_format(ab, " obj=%s", ctx);
-		security_release_secctx(ctx, len);
+		security_release_secctx(ctx, len, sop);
 	}
 	audit_log_format(ab, " ocomm=");
 	audit_log_untrustedstring(ab, comm);
@@ -1432,6 +1434,7 @@ static void audit_log_fcaps(struct audit_buffer *ab, struct audit_names *name)
 
 static void show_special(struct audit_context *context, int *call_panic)
 {
+	struct security_operations *sop;
 	struct audit_buffer *ab;
 	int i;
 
@@ -1457,12 +1460,12 @@ static void show_special(struct audit_context *context, int *call_panic)
 		if (sip->si_count) {
 			char *ctx = NULL;
 			u32 len;
-			if (security_secid_to_secctx(sip, &ctx, &len)) {
+			if (security_secid_to_secctx(sip, &ctx, &len, &sop)) {
 				audit_log_format(ab, " osid=%u", sip->si_count);
 				*call_panic = 1;
 			} else {
 				audit_log_format(ab, " obj=%s", ctx);
-				security_release_secctx(ctx, len);
+				security_release_secctx(ctx, len, sop);
 			}
 		}
 		if (context->ipc.has_perm) {
@@ -1530,6 +1533,7 @@ static void show_special(struct audit_context *context, int *call_panic)
 static void audit_log_name(struct audit_context *context, struct audit_names *n,
 			   int record_num, int *call_panic)
 {
+	struct security_operations *sop;
 	struct audit_buffer *ab;
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_PATH);
 	if (!ab)
@@ -1574,12 +1578,12 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
 	if (n->osid.si_count != 0) {
 		char *ctx = NULL;
 		u32 len;
-		if (security_secid_to_secctx(&n->osid, &ctx, &len)) {
+		if (security_secid_to_secctx(&n->osid, &ctx, &len, &sop)) {
 			audit_log_format(ab, " osid=%u", n->osid.si_count);
 			*call_panic = 2;
 		} else {
 			audit_log_format(ab, " obj=%s", ctx);
-			security_release_secctx(ctx, len);
+			security_release_secctx(ctx, len, sop);
 		}
 	}
 
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index a55f8c0..7f0c3bb 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -110,18 +110,19 @@ static void ip_cmsg_recv_security(struct msghdr *msg, struct sk_buff *skb)
 	char *secdata;
 	u32 seclen;
 	struct secids secid;
+	struct security_operations *sop;
 	int err;
 
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
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 4a95072..cdcf9ab 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -302,12 +302,11 @@ ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 	int len, ret;
 	char *secctx;
 	struct secids secid;
-
-	memset(&secid, 0, sizeof(secid));
+	struct security_operations *sop;
 
 	secid.si_lsm[0] = ct->secmark;
 
-	ret = security_secid_to_secctx(&secid, &secctx, &len);
+	ret = security_secid_to_secctx(&secid, &secctx, &len, &sop);
 	if (ret)
 		return 0;
 
@@ -322,7 +321,7 @@ ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 
 	ret = 0;
 nla_put_failure:
-	security_release_secctx(secctx, len);
+	security_release_secctx(secctx, len, sop);
 	return ret;
 }
 #else
@@ -554,12 +553,11 @@ ctnetlink_secctx_size(const struct nf_conn *ct)
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
 	int len, ret;
 	struct secids secid;
-
-	memset(&secid, 0, sizeof(secid));
+	struct security_operations *sop;
 
 	secid.si_lsm[0] = ct->secmark;
 
-	ret = security_secid_to_secctx(&secid, NULL, &len);
+	ret = security_secid_to_secctx(&secid, NULL, &len, &sop);
 	if (ret)
 		return 0;
 
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 4e5bb3e..fc571d4 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -124,18 +124,19 @@ static int ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 	u32 len;
 	char *secctx;
 	struct secids secid;
+	struct security_operations *sop;
 
 	memset(&secid, 0, sizeof(secid));
 
 	secid.si_lsm[0] = ct->secmark;
 
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
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index 520caaa..d77e085 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -397,6 +397,7 @@ int netlbl_unlhsh_add(struct net *net,
 	char *secctx = NULL;
 	u32 secctx_len;
 	struct secids sid;
+	struct security_operations *sop;
 
 	sid.si_lsm[0] = secid;
 
@@ -463,9 +464,10 @@ unlhsh_add_return:
 	if (audit_buf != NULL) {
 		if (security_secid_to_secctx(&sid,
 					     &secctx,
-					     &secctx_len) == 0) {
+					     &secctx_len,
+					     &sop) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s", secctx);
-			security_release_secctx(secctx, secctx_len);
+			security_release_secctx(secctx, secctx_len, sop);
 		}
 		audit_log_format(audit_buf, " res=%u", ret_val == 0 ? 1 : 0);
 		audit_log_end(audit_buf);
@@ -499,6 +501,7 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 	char *secctx;
 	u32 secctx_len;
 	struct secids sid;
+	struct security_operations *sop;
 
 	spin_lock(&netlbl_unlhsh_lock);
 	list_entry = netlbl_af4list_remove(addr->s_addr, mask->s_addr,
@@ -521,9 +524,9 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 		sid.si_lsm[0] = entry->secid;
 		if (entry != NULL &&
 		    security_secid_to_secctx(&sid,
-					     &secctx, &secctx_len) == 0) {
+					     &secctx, &secctx_len, &sop) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s", secctx);
-			security_release_secctx(secctx, secctx_len);
+			security_release_secctx(secctx, secctx_len, sop);
 		}
 		audit_log_format(audit_buf, " res=%u", entry != NULL ? 1 : 0);
 		audit_log_end(audit_buf);
@@ -563,6 +566,7 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 	char *secctx;
 	u32 secctx_len;
 	struct secids sid;
+	struct security_operations *sop;
 
 	spin_lock(&netlbl_unlhsh_lock);
 	list_entry = netlbl_af6list_remove(addr, mask, &iface->addr6_list);
@@ -584,9 +588,9 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 		sid.si_lsm[0] = entry->secid;
 		if (entry != NULL &&
 		    security_secid_to_secctx(&sid,
-					     &secctx, &secctx_len) == 0) {
+					     &secctx, &secctx_len, &sop) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s", secctx);
-			security_release_secctx(secctx, secctx_len);
+			security_release_secctx(secctx, secctx_len, sop);
 		}
 		audit_log_format(audit_buf, " res=%u", entry != NULL ? 1 : 0);
 		audit_log_end(audit_buf);
@@ -1100,6 +1104,7 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 	struct net_device *dev;
 	void *data;
 	struct secids secid;
+	struct security_operations *sop;
 	char *secctx;
 	u32 secctx_len;
 
@@ -1160,14 +1165,14 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 		secid.si_lsm[0] = addr6->secid;
 	}
 
-	ret_val = security_secid_to_secctx(&secid, &secctx, &secctx_len);
+	ret_val = security_secid_to_secctx(&secid, &secctx, &secctx_len, &sop);
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
index 7ef8262..469aa0e 100644
--- a/net/netlabel/netlabel_user.c
+++ b/net/netlabel/netlabel_user.c
@@ -101,6 +101,7 @@ struct audit_buffer *netlbl_audit_start_common(int type,
 	char *secctx;
 	u32 secctx_len;
 	struct secids secid;
+	struct security_operations *sop;
 
 	if (audit_enabled == 0)
 		return NULL;
@@ -116,9 +117,9 @@ struct audit_buffer *netlbl_audit_start_common(int type,
 			 audit_info->sessionid);
 
 	if (audit_info->secid != 0 &&
-	    security_secid_to_secctx(&secid, &secctx, &secctx_len) == 0) {
+	    security_secid_to_secctx(&secid, &secctx, &secctx_len, &sop) == 0) {
 		audit_log_format(audit_buf, " subj=%s", secctx);
-		security_release_secctx(secctx, secctx_len);
+		security_release_secctx(secctx, secctx_len, sop);
 	}
 
 	return audit_buf;
diff --git a/security/security.c b/security/security.c
index 000a1fc..6594d8d 100644
--- a/security/security.c
+++ b/security/security.c
@@ -627,7 +627,9 @@ int security_inode_killpriv(struct dentry *dentry)
 	return security_ops->inode_killpriv(dentry);
 }
 
-int security_inode_getsecurity(const struct inode *inode, const char *name, void **buffer, bool alloc)
+int security_inode_getsecurity(const struct inode *inode, const char *name,
+				void **buffer, bool alloc,
+				struct security_operations **secops)
 {
 	if (unlikely(IS_PRIVATE(inode)))
 		return -EOPNOTSUPP;
@@ -1047,7 +1049,8 @@ int security_netlink_send(struct sock *sk, struct sk_buff *skb)
 	return security_ops->netlink_send(sk, skb);
 }
 
-int security_secid_to_secctx(struct secids *secid, char **secdata, u32 *seclen)
+int security_secid_to_secctx(struct secids *secid, char **secdata, u32 *seclen,
+				struct security_operations **secops)
 {
 	return security_ops->secid_to_secctx(secid->si_lsm[0], secdata, seclen);
 }
@@ -1061,7 +1064,8 @@ int security_secctx_to_secid(const char *secdata, u32 seclen,
 }
 EXPORT_SYMBOL(security_secctx_to_secid);
 
-void security_release_secctx(char *secdata, u32 seclen)
+void security_release_secctx(char *secdata, u32 seclen,
+				struct security_operations *sop)
 {
 	security_ops->release_secctx(secdata, seclen);
 }
@@ -1079,7 +1083,8 @@ int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen)
 }
 EXPORT_SYMBOL(security_inode_setsecctx);
 
-int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen)
+int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen,
+				struct security_operations **secops)
 {
 	return security_ops->inode_getsecctx(inode, ctx, ctxlen);
 }


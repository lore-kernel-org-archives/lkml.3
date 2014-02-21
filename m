Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812AbaBUMyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:54:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47319 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932660AbaBUMvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:51:52 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steve French <smfrench@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 116/121] retrieving CIFS ACLs when mounted with SMB2 fails dropping session
Date: Fri, 21 Feb 2014 12:49:00 +0000
Message-Id: <1392986945-9693-117-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <smfrench@gmail.com>

commit 83e3bc23ef9ce7c03b7b4e5d3d790246ea59db3e upstream.

The get/set ACL xattr support for CIFS ACLs attempts to send old
cifs dialect protocol requests even when mounted with SMB2 or later
dialects. Sending cifs requests on an smb2 session causes problems -
the server drops the session due to the illegal request.

This patch makes CIFS ACL operations protocol specific to fix that.

Attempting to query/set CIFS ACLs for SMB2 will now return
EOPNOTSUPP (until we add worker routines for sending query
ACL requests via SMB2) instead of sending invalid (cifs)
requests.

A separate followon patch will be needed to fix cifs_acl_to_fattr
(which takes a cifs specific u16 fid so can't be abstracted
to work with SMB2 until that is changed) and will be needed
to fix mount problems when "cifsacl" is specified on mount
with e.g. vers=2.1

Signed-off-by: Steve French <smfrench@gmail.com>
Reviewed-by: Shirish Pargaonkar <spargaonkar@suse.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/cifs/cifsacl.c  | 28 ++++++++++++++++++++++++----
 fs/cifs/cifsglob.h |  4 ++++
 fs/cifs/smb1ops.c  |  4 ++++
 fs/cifs/xattr.c    | 15 +++++++++++----
 4 files changed, 43 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 51f5e0e..494b683 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -1027,15 +1027,30 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 nmode,
 	__u32 secdesclen = 0;
 	struct cifs_ntsd *pntsd = NULL; /* acl obtained from server */
 	struct cifs_ntsd *pnntsd = NULL; /* modified acl to be sent to server */
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
+	struct cifs_tcon *tcon;
+
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+	tcon = tlink_tcon(tlink);
 
 	cifs_dbg(NOISY, "set ACL from mode for %s\n", path);
 
 	/* Get the security descriptor */
-	pntsd = get_cifs_acl(CIFS_SB(inode->i_sb), inode, path, &secdesclen);
+
+	if (tcon->ses->server->ops->get_acl == NULL) {
+		cifs_put_tlink(tlink);
+		return -EOPNOTSUPP;
+	}
+
+	pntsd = tcon->ses->server->ops->get_acl(cifs_sb, inode, path,
+						&secdesclen);
 	if (IS_ERR(pntsd)) {
 		rc = PTR_ERR(pntsd);
 		cifs_dbg(VFS, "%s: error %d getting sec desc\n", __func__, rc);
-		goto out;
+		cifs_put_tlink(tlink);
+		return rc;
 	}
 
 	/*
@@ -1048,6 +1063,7 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 nmode,
 	pnntsd = kmalloc(secdesclen, GFP_KERNEL);
 	if (!pnntsd) {
 		kfree(pntsd);
+		cifs_put_tlink(tlink);
 		return -ENOMEM;
 	}
 
@@ -1056,14 +1072,18 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 nmode,
 
 	cifs_dbg(NOISY, "build_sec_desc rc: %d\n", rc);
 
+	if (tcon->ses->server->ops->set_acl == NULL)
+		rc = -EOPNOTSUPP;
+
 	if (!rc) {
 		/* Set the security descriptor */
-		rc = set_cifs_acl(pnntsd, secdesclen, inode, path, aclflag);
+		rc = tcon->ses->server->ops->set_acl(pnntsd, secdesclen, inode,
+						     path, aclflag);
 		cifs_dbg(NOISY, "set_cifs_acl rc: %d\n", rc);
 	}
+	cifs_put_tlink(tlink);
 
 	kfree(pnntsd);
 	kfree(pntsd);
-out:
 	return rc;
 }
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 3229979..46b5209f 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -379,6 +379,10 @@ struct smb_version_operations {
 	int (*set_EA)(const unsigned int, struct cifs_tcon *, const char *,
 			const char *, const void *, const __u16,
 			const struct nls_table *, int);
+	struct cifs_ntsd * (*get_acl)(struct cifs_sb_info *, struct inode *,
+			const char *, u32 *);
+	int (*set_acl)(struct cifs_ntsd *, __u32, struct inode *, const char *,
+			int);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 7bdd38e..fd3db42 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -949,6 +949,10 @@ struct smb_version_operations smb1_operations = {
 	.query_all_EAs = CIFSSMBQAllEAs,
 	.set_EA = CIFSSMBSetEA,
 #endif /* CIFS_XATTR */
+#ifdef CONFIG_CIFS_ACL
+	.get_acl = get_cifs_acl,
+	.set_acl = set_cifs_acl,
+#endif /* CIFS_ACL */
 };
 
 struct smb_version_values smb1_values = {
diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index 95c43bb..5ac836a 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -176,8 +176,12 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 			rc = -ENOMEM;
 		} else {
 			memcpy(pacl, ea_value, value_size);
-			rc = set_cifs_acl(pacl, value_size,
-				direntry->d_inode, full_path, CIFS_ACL_DACL);
+			if (pTcon->ses->server->ops->set_acl)
+				rc = pTcon->ses->server->ops->set_acl(pacl,
+						value_size, direntry->d_inode,
+						full_path, CIFS_ACL_DACL);
+			else
+				rc = -EOPNOTSUPP;
 			if (rc == 0) /* force revalidate of the inode */
 				CIFS_I(direntry->d_inode)->time = 0;
 			kfree(pacl);
@@ -323,8 +327,11 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
 			u32 acllen;
 			struct cifs_ntsd *pacl;
 
-			pacl = get_cifs_acl(cifs_sb, direntry->d_inode,
-						full_path, &acllen);
+			if (pTcon->ses->server->ops->get_acl == NULL)
+				goto get_ea_exit; /* rc already EOPNOTSUPP */
+
+			pacl = pTcon->ses->server->ops->get_acl(cifs_sb,
+					direntry->d_inode, full_path, &acllen);
 			if (IS_ERR(pacl)) {
 				rc = PTR_ERR(pacl);
 				cifs_dbg(VFS, "%s: error %zd getting sec desc\n",
-- 
1.9.0


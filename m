Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162AbaBUAhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:37:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45721 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530AbaBTXwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:52:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steve French <smfrench@gmail.com>,
        Shirish Pargaonkar <spargaonkar@suse.com>
Subject: [PATCH 3.12 08/82] retrieving CIFS ACLs when mounted with SMB2 fails dropping session
Date: Thu, 20 Feb 2014 15:51:51 -0800
Message-Id: <20140220235019.732209116@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220235019.483734207@linuxfoundation.org>
References: <20140220235019.483734207@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/cifsacl.c  |   28 ++++++++++++++++++++++++----
 fs/cifs/cifsglob.h |    4 ++++
 fs/cifs/smb1ops.c  |    4 ++++
 fs/cifs/xattr.c    |   15 +++++++++++----
 4 files changed, 43 insertions(+), 8 deletions(-)

--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -1027,15 +1027,30 @@ id_mode_to_cifs_acl(struct inode *inode,
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
@@ -1048,6 +1063,7 @@ id_mode_to_cifs_acl(struct inode *inode,
 	pnntsd = kmalloc(secdesclen, GFP_KERNEL);
 	if (!pnntsd) {
 		kfree(pntsd);
+		cifs_put_tlink(tlink);
 		return -ENOMEM;
 	}
 
@@ -1056,14 +1072,18 @@ id_mode_to_cifs_acl(struct inode *inode,
 
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
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -385,6 +385,10 @@ struct smb_version_operations {
 	int (*set_EA)(const unsigned int, struct cifs_tcon *, const char *,
 			const char *, const void *, const __u16,
 			const struct nls_table *, int);
+	struct cifs_ntsd * (*get_acl)(struct cifs_sb_info *, struct inode *,
+			const char *, u32 *);
+	int (*set_acl)(struct cifs_ntsd *, __u32, struct inode *, const char *,
+			int);
 };
 
 struct smb_version_values {
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -1007,6 +1007,10 @@ struct smb_version_operations smb1_opera
 	.query_all_EAs = CIFSSMBQAllEAs,
 	.set_EA = CIFSSMBSetEA,
 #endif /* CIFS_XATTR */
+#ifdef CONFIG_CIFS_ACL
+	.get_acl = get_cifs_acl,
+	.set_acl = set_cifs_acl,
+#endif /* CIFS_ACL */
 };
 
 struct smb_version_values smb1_values = {
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -176,8 +176,12 @@ int cifs_setxattr(struct dentry *direntr
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
@@ -323,8 +327,11 @@ ssize_t cifs_getxattr(struct dentry *dir
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



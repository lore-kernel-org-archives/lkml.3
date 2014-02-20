Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbaBUAK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:10:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46138 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177AbaBTXxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:53:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steve French <smfrench@gmail.com>
Subject: [PATCH 3.13 07/99] CIFS: Fix SMB2 mounts so they dont try to set or get xattrs via cifs
Date: Thu, 20 Feb 2014 15:52:02 -0800
Message-Id: <20140220235118.422765535@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220235118.191692546@linuxfoundation.org>
References: <20140220235118.191692546@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <smfrench@gmail.com>

commit 666753c3ef8fc88b0ddd5be4865d0aa66428ac35 upstream.

When mounting with smb2 (or smb2.1 or smb3) we need to check to make
sure that attempts to query or set extended attributes do not
attempt to send the request with the older cifs protocol instead
(eventually we also need to add the support in SMB2
to query/set extended attributes but this patch prevents us from
using the wrong protocol for extended attribute operations).

Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/cifsglob.h |    6 ++++++
 fs/cifs/xattr.c    |   49 ++++++++++++++++++++++++++++++-------------------
 2 files changed, 36 insertions(+), 19 deletions(-)

--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -385,6 +385,12 @@ struct smb_version_operations {
 			struct cifsFileInfo *target_file, u64 src_off, u64 len,
 			u64 dest_off);
 	int (*validate_negotiate)(const unsigned int, struct cifs_tcon *);
+	ssize_t (*query_all_EAs)(const unsigned int, struct cifs_tcon *,
+			const unsigned char *, const unsigned char *, char *,
+			size_t, const struct nls_table *, int);
+	int (*set_EA)(const unsigned int, struct cifs_tcon *, const char *,
+			const char *, const void *, const __u16,
+			const struct nls_table *, int);
 };
 
 struct smb_version_values {
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -82,9 +82,11 @@ int cifs_removexattr(struct dentry *dire
 			goto remove_ea_exit;
 
 		ea_name += XATTR_USER_PREFIX_LEN; /* skip past user. prefix */
-		rc = CIFSSMBSetEA(xid, pTcon, full_path, ea_name, NULL,
-			(__u16)0, cifs_sb->local_nls,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+		if (pTcon->ses->server->ops->set_EA)
+			rc = pTcon->ses->server->ops->set_EA(xid, pTcon,
+				full_path, ea_name, NULL, (__u16)0,
+				cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
+					CIFS_MOUNT_MAP_SPECIAL_CHR);
 	}
 remove_ea_exit:
 	kfree(full_path);
@@ -149,18 +151,22 @@ int cifs_setxattr(struct dentry *direntr
 			cifs_dbg(FYI, "attempt to set cifs inode metadata\n");
 
 		ea_name += XATTR_USER_PREFIX_LEN; /* skip past user. prefix */
-		rc = CIFSSMBSetEA(xid, pTcon, full_path, ea_name, ea_value,
-			(__u16)value_size, cifs_sb->local_nls,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+		if (pTcon->ses->server->ops->set_EA)
+			rc = pTcon->ses->server->ops->set_EA(xid, pTcon,
+				full_path, ea_name, ea_value, (__u16)value_size,
+				cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
+					CIFS_MOUNT_MAP_SPECIAL_CHR);
 	} else if (strncmp(ea_name, XATTR_OS2_PREFIX, XATTR_OS2_PREFIX_LEN)
 		   == 0) {
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
 			goto set_ea_exit;
 
 		ea_name += XATTR_OS2_PREFIX_LEN; /* skip past os2. prefix */
-		rc = CIFSSMBSetEA(xid, pTcon, full_path, ea_name, ea_value,
-			(__u16)value_size, cifs_sb->local_nls,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+		if (pTcon->ses->server->ops->set_EA)
+			rc = pTcon->ses->server->ops->set_EA(xid, pTcon,
+				full_path, ea_name, ea_value, (__u16)value_size,
+				cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
+					CIFS_MOUNT_MAP_SPECIAL_CHR);
 	} else if (strncmp(ea_name, CIFS_XATTR_CIFS_ACL,
 			strlen(CIFS_XATTR_CIFS_ACL)) == 0) {
 #ifdef CONFIG_CIFS_ACL
@@ -272,17 +278,21 @@ ssize_t cifs_getxattr(struct dentry *dir
 			/* revalidate/getattr then populate from inode */
 		} /* BB add else when above is implemented */
 		ea_name += XATTR_USER_PREFIX_LEN; /* skip past user. prefix */
-		rc = CIFSSMBQAllEAs(xid, pTcon, full_path, ea_name, ea_value,
-			buf_size, cifs_sb->local_nls,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+		if (pTcon->ses->server->ops->query_all_EAs)
+			rc = pTcon->ses->server->ops->query_all_EAs(xid, pTcon,
+				full_path, ea_name, ea_value, buf_size,
+				cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
+					CIFS_MOUNT_MAP_SPECIAL_CHR);
 	} else if (strncmp(ea_name, XATTR_OS2_PREFIX, XATTR_OS2_PREFIX_LEN) == 0) {
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
 			goto get_ea_exit;
 
 		ea_name += XATTR_OS2_PREFIX_LEN; /* skip past os2. prefix */
-		rc = CIFSSMBQAllEAs(xid, pTcon, full_path, ea_name, ea_value,
-			buf_size, cifs_sb->local_nls,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+		if (pTcon->ses->server->ops->query_all_EAs)
+			rc = pTcon->ses->server->ops->query_all_EAs(xid, pTcon,
+				full_path, ea_name, ea_value, buf_size,
+				cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
+					CIFS_MOUNT_MAP_SPECIAL_CHR);
 	} else if (strncmp(ea_name, POSIX_ACL_XATTR_ACCESS,
 			  strlen(POSIX_ACL_XATTR_ACCESS)) == 0) {
 #ifdef CONFIG_CIFS_POSIX
@@ -400,11 +410,12 @@ ssize_t cifs_listxattr(struct dentry *di
 	/* if proc/fs/cifs/streamstoxattr is set then
 		search server for EAs or streams to
 		returns as xattrs */
-	rc = CIFSSMBQAllEAs(xid, pTcon, full_path, NULL, data,
-				buf_size, cifs_sb->local_nls,
-				cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
 
+	if (pTcon->ses->server->ops->query_all_EAs)
+		rc = pTcon->ses->server->ops->query_all_EAs(xid, pTcon,
+				full_path, NULL, data, buf_size,
+				cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
+					CIFS_MOUNT_MAP_SPECIAL_CHR);
 list_ea_exit:
 	kfree(full_path);
 	free_xid(xid);



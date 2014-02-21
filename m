Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932835AbaBUMzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:55:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47311 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932662AbaBUMvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:51:49 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steve French <smfrench@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 114/121] [CIFS] Fix SMB2 mounts so they don't try to set or get xattrs via cifs
Date: Fri, 21 Feb 2014 12:48:58 +0000
Message-Id: <1392986945-9693-115-git-send-email-luis.henriques@canonical.com>
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

commit 666753c3ef8fc88b0ddd5be4865d0aa66428ac35 upstream.

When mounting with smb2 (or smb2.1 or smb3) we need to check to make
sure that attempts to query or set extended attributes do not
attempt to send the request with the older cifs protocol instead
(eventually we also need to add the support in SMB2
to query/set extended attributes but this patch prevents us from
using the wrong protocol for extended attribute operations).

Signed-off-by: Steve French <smfrench@gmail.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/cifs/cifsglob.h |  6 ++++++
 fs/cifs/xattr.c    | 49 ++++++++++++++++++++++++++++++-------------------
 2 files changed, 36 insertions(+), 19 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 52ca861..3229979 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -373,6 +373,12 @@ struct smb_version_operations {
 	int (*query_mf_symlink)(const unsigned char *path, char *pbuf,
 			unsigned int *pbytes_read, struct cifs_sb_info *cifs_sb,
 			unsigned int xid);
+	ssize_t (*query_all_EAs)(const unsigned int, struct cifs_tcon *,
+			const unsigned char *, const unsigned char *, char *,
+			size_t, const struct nls_table *, int);
+	int (*set_EA)(const unsigned int, struct cifs_tcon *, const char *,
+			const char *, const void *, const __u16,
+			const struct nls_table *, int);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index 09afda4..95c43bb 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -82,9 +82,11 @@ int cifs_removexattr(struct dentry *direntry, const char *ea_name)
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
@@ -149,18 +151,22 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
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
@@ -272,17 +278,21 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
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
@@ -400,11 +410,12 @@ ssize_t cifs_listxattr(struct dentry *direntry, char *data, size_t buf_size)
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
-- 
1.9.0


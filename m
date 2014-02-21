Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826AbaBUMyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:54:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47315 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932668AbaBUMvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:51:50 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steve French <smfrench@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 115/121] Add protocol specific operation for CIFS xattrs
Date: Fri, 21 Feb 2014 12:48:59 +0000
Message-Id: <1392986945-9693-116-git-send-email-luis.henriques@canonical.com>
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

commit d979f3b0a1f0b5499ab85e68cdf02b56852918b6 upstream.

Changeset 666753c3ef8fc88b0ddd5be4865d0aa66428ac35 added protocol
operations for get/setxattr to avoid calling cifs operations
on smb2/smb3 mounts for xattr operations and this changeset
adds the calls to cifs specific protocol operations for xattrs
(in order to reenable cifs support for xattrs which was
temporarily disabled by the previous changeset.  We do not
have SMB2/SMB3 worker function for setting xattrs yet so
this only enables it for cifs.

CCing stable since without these two small changsets (its
small coreq 666753c3ef8fc88b0ddd5be4865d0aa66428ac35 is
also needed) calling getfattr/setfattr on smb2/smb3 mounts
causes problems.

Signed-off-by: Steve French <smfrench@gmail.com>
Reviewed-by: Shirish Pargaonkar <spargaonkar@suse.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/cifs/inode.c   | 13 +++++++++----
 fs/cifs/smb1ops.c |  4 ++++
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 993983c..40a982d 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -491,10 +491,15 @@ static int cifs_sfu_mode(struct cifs_fattr *fattr, const unsigned char *path,
 		return PTR_ERR(tlink);
 	tcon = tlink_tcon(tlink);
 
-	rc = CIFSSMBQAllEAs(xid, tcon, path, "SETFILEBITS",
-			    ea_value, 4 /* size of buf */, cifs_sb->local_nls,
-			    cifs_sb->mnt_cifs_flags &
-				CIFS_MOUNT_MAP_SPECIAL_CHR);
+	if (tcon->ses->server->ops->query_all_EAs == NULL) {
+		cifs_put_tlink(tlink);
+		return -EOPNOTSUPP;
+	}
+
+	rc = tcon->ses->server->ops->query_all_EAs(xid, tcon, path,
+			"SETFILEBITS", ea_value, 4 /* size of buf */,
+			cifs_sb->local_nls,
+			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
 	cifs_put_tlink(tlink);
 	if (rc < 0)
 		return (int)rc;
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 6094397..7bdd38e 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -945,6 +945,10 @@ struct smb_version_operations smb1_operations = {
 	.mand_unlock_range = cifs_unlock_range,
 	.push_mand_locks = cifs_push_mandatory_locks,
 	.query_mf_symlink = open_query_close_cifs_symlink,
+#ifdef CONFIG_CIFS_XATTR
+	.query_all_EAs = CIFSSMBQAllEAs,
+	.set_EA = CIFSSMBSetEA,
+#endif /* CIFS_XATTR */
 };
 
 struct smb_version_values smb1_values = {
-- 
1.9.0


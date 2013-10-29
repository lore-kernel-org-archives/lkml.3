Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab3J2SID (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:08:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59349 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab3J2SH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:07:59 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Klos <honza.klos@gmail.com>, Steve French <smfrench@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 64/81] cifs: Fix inability to write files >2GB to SMB2/3 shares
Date: Tue, 29 Oct 2013 11:04:25 -0700
Message-Id: <1383069882-11437-65-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Klos <honza.klos@gmail.com>

commit 2f6c9479633780ba4a3484bba7eba5a721a5cf20 upstream.

When connecting to SMB2/3 shares, maximum file size is set to non-LFS maximum in superblock. This is due to cap_large_files bit being different for SMB1 and SMB2/3 (where it is just an internal flag that is not negotiated and the SMB1 one corresponds to multichannel capability, so maybe LFS works correctly if server sends 0x08 flag) while capabilities are checked always for the SMB1 bit in cifs_read_super().

The patch fixes this by checking for the correct bit according to the protocol version.

Signed-off-by: Jan Klos <honza.klos@gmail.com>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <smfrench@gmail.com>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/cifs/cifsfs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index b9db388..e946529 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -120,14 +120,16 @@ cifs_read_super(struct super_block *sb)
 {
 	struct inode *inode;
 	struct cifs_sb_info *cifs_sb;
+	struct cifs_tcon *tcon;
 	int rc = 0;
 
 	cifs_sb = CIFS_SB(sb);
+	tcon = cifs_sb_master_tcon(cifs_sb);
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIXACL)
 		sb->s_flags |= MS_POSIXACL;
 
-	if (cifs_sb_master_tcon(cifs_sb)->ses->capabilities & CAP_LARGE_FILES)
+	if (tcon->ses->capabilities & tcon->ses->server->vals->cap_large_files)
 		sb->s_maxbytes = MAX_LFS_FILESIZE;
 	else
 		sb->s_maxbytes = MAX_NON_LFS;
@@ -154,7 +156,7 @@ cifs_read_super(struct super_block *sb)
 	}
 
 	/* do that *after* d_make_root() - we want NULL ->d_op for root here */
-	if (cifs_sb_master_tcon(cifs_sb)->nocase)
+	if (tcon->nocase)
 		sb->s_d_op = &cifs_ci_dentry_ops;
 	else
 		sb->s_d_op = &cifs_dentry_ops;
-- 
1.8.1.2


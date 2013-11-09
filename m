Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933508Ab3KIHT7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:19:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33231 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758554Ab3KIGvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:51:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Klos <honza.klos@gmail.com>, Jeff Layton <jlayton@redhat.com>,
        Steve French <smfrench@gmail.com>
Subject: [PATCH 3.11 08/94] cifs: Fix inability to write files >2GB to SMB2/3 shares
Date: Fri,  8 Nov 2013 22:51:14 -0800
Message-Id: <20131109065204.851491884@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Klos <honza.klos@gmail.com>

commit 2f6c9479633780ba4a3484bba7eba5a721a5cf20 upstream.

When connecting to SMB2/3 shares, maximum file size is set to non-LFS maximum in superblock. This is due to cap_large_files bit being different for SMB1 and SMB2/3 (where it is just an internal flag that is not negotiated and the SMB1 one corresponds to multichannel capability, so maybe LFS works correctly if server sends 0x08 flag) while capabilities are checked always for the SMB1 bit in cifs_read_super().

The patch fixes this by checking for the correct bit according to the protocol version.

Signed-off-by: Jan Klos <honza.klos@gmail.com>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/cifsfs.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

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
@@ -147,7 +149,7 @@ cifs_read_super(struct super_block *sb)
 		goto out_no_root;
 	}
 
-	if (cifs_sb_master_tcon(cifs_sb)->nocase)
+	if (tcon->nocase)
 		sb->s_d_op = &cifs_ci_dentry_ops;
 	else
 		sb->s_d_op = &cifs_dentry_ops;



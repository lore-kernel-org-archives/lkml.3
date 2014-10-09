Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbaJIVQB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:16:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59697 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757952AbaJIVL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:11:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steve French <smfrench@gmail.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 156/163] Fix problem recognizing symlinks
Date: Thu,  9 Oct 2014 14:03:01 -0700
Message-Id: <1412888588-26755-157-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <smfrench@gmail.com>

commit 19e81573fca7b87ced7701e01ba164b968d929bd upstream.

Changeset eb85d94bd introduced a problem where if a cifs open
fails during query info of a file we
will still try to close the file (happens with certain types
of reparse points) even though the file handle is not valid.

In addition for SMB2/SMB3 we were not mapping the return code returned
by Windows when trying to open a file (like a Windows NFS symlink)
which is a reparse point.

Signed-off-by: Steve French <smfrench@gmail.com>
Reviewed-by: Pavel Shilovsky <pshilovsky@samba.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/cifs/smb1ops.c      | 2 +-
 fs/cifs/smb2maperror.c | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index c66a726..0503edf 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -579,7 +579,7 @@ cifs_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
 		if (tmprc == -EOPNOTSUPP)
 			*symlink = true;
-		else
+		else if (tmprc == 0)
 			CIFSSMBClose(xid, tcon, netfid);
 	}
 
diff --git a/fs/cifs/smb2maperror.c b/fs/cifs/smb2maperror.c
index a689514..a491814 100644
--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -256,6 +256,8 @@ static const struct status_to_posix_error smb2_error_map_table[] = {
 	{STATUS_DLL_MIGHT_BE_INCOMPATIBLE, -EIO,
 	"STATUS_DLL_MIGHT_BE_INCOMPATIBLE"},
 	{STATUS_STOPPED_ON_SYMLINK, -EOPNOTSUPP, "STATUS_STOPPED_ON_SYMLINK"},
+	{STATUS_IO_REPARSE_TAG_NOT_HANDLED, -EOPNOTSUPP,
+	"STATUS_REPARSE_NOT_HANDLED"},
 	{STATUS_DEVICE_REQUIRES_CLEANING, -EIO,
 	"STATUS_DEVICE_REQUIRES_CLEANING"},
 	{STATUS_DEVICE_DOOR_OPEN, -EIO, "STATUS_DEVICE_DOOR_OPEN"},
-- 
1.9.1


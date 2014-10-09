Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbaJIVER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:04:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58925 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbaJIVD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:03:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pavel Shilovsky <pshilovsky@samba.org>, Steve French <smfrench@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 007/163] CIFS: Fix directory rename error
Date: Thu,  9 Oct 2014 14:00:32 -0700
Message-Id: <1412888588-26755-8-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Shilovsky <pshilovsky@samba.org>

commit a07d322059db66b84c9eb4f98959df468e88b34b upstream.

CIFS servers process nlink counts differently for files and directories.
In cifs_rename() if we the request fails on the existing target, we
try to remove it through cifs_unlink() but this is not what we want
to do for directories. As the result the following sequence of commands

mkdir {1,2}; mv -T 1 2; rmdir {1,2}; mkdir {1,2}; echo foo > 2/bar

and XFS test generic/023 fail with -ENOENT error. That's why the second
mkdir reuses the existing inode (target inode of the mv -T command) with
S_DEAD flag.

Fix this by checking whether the target is directory or not and
calling cifs_rmdir() rather than cifs_unlink() for directories.

Signed-off-by: Pavel Shilovsky <pshilovsky@samba.org>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/cifs/inode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 36d2b1d..3be49dd 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1682,7 +1682,10 @@ cifs_rename(struct inode *source_dir, struct dentry *source_dentry,
 unlink_target:
 	/* Try unlinking the target dentry if it's not negative */
 	if (target_dentry->d_inode && (rc == -EACCES || rc == -EEXIST)) {
-		tmprc = cifs_unlink(target_dir, target_dentry);
+		if (d_is_dir(target_dentry))
+			tmprc = cifs_rmdir(target_dir, target_dentry);
+		else
+			tmprc = cifs_unlink(target_dir, target_dentry);
 		if (tmprc)
 			goto cifs_rename_exit;
 		rc = cifs_do_rename(xid, source_dentry, from_name,
-- 
1.9.1


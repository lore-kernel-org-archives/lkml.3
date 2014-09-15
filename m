Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbaIOUR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:17:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55604 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130AbaIOTq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:46:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pavel Shilovsky <pshilovsky@samba.org>,
        Steve French <smfrench@gmail.com>
Subject: [PATCH 3.14 103/114] CIFS: Fix directory rename error
Date: Mon, 15 Sep 2014 12:26:43 -0700
Message-Id: <20140915192644.639672453@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192641.428509513@linuxfoundation.org>
References: <20140915192641.428509513@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/inode.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1706,7 +1706,10 @@ cifs_rename(struct inode *source_dir, st
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



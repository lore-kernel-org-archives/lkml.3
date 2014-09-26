Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbaIZJ7E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:59:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33029 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755089AbaIZJqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:42 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pavel Shilovsky <pshilovsky@samba.org>,
        Steve French <smfrench@gmail.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 118/142] CIFS: Fix directory rename error
Date: Fri, 26 Sep 2014 11:45:29 +0200
Message-Id: <9d735a8a6cd554ca13907b01c199650852036497.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Shilovsky <pshilovsky@samba.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

Commit a07d322059db66b84c9eb4f98959df468e88b34b upstream.

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

Cc: <stable@vger.kernel.org>
Signed-off-by: Pavel Shilovsky <pshilovsky@samba.org>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/cifs/inode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 36d2b1d6d492..2a93255c0150 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1682,7 +1682,10 @@ cifs_rename(struct inode *source_dir, struct dentry *source_dentry,
 unlink_target:
 	/* Try unlinking the target dentry if it's not negative */
 	if (target_dentry->d_inode && (rc == -EACCES || rc == -EEXIST)) {
-		tmprc = cifs_unlink(target_dir, target_dentry);
+		if (S_ISDIR(target_dentry->d_inode->i_mode))
+			tmprc = cifs_rmdir(target_dir, target_dentry);
+		else
+			tmprc = cifs_unlink(target_dir, target_dentry);
 		if (tmprc)
 			goto cifs_rename_exit;
 		rc = cifs_do_rename(xid, source_dentry, from_name,
-- 
2.1.0


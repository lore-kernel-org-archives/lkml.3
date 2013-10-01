Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab3JAQAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 12:00:30 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:54453 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab3JAQAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 12:00:06 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org, hch@infradead.org,
        akpm@linux-foundation.org, dhowells@redhat.com, zab@redhat.com,
        jack@suse.cz, tytso@mit.edu, mszeredi@suse.cz
Subject: [PATCH 1/7] vfs: rename: move d_move() up
Date: Tue,  1 Oct 2013 18:00:33 +0200
Message-Id: <1380643239-16060-2-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380643239-16060-1-git-send-email-miklos@szeredi.hu>
References: <1380643239-16060-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Move the d_move() in vfs_rename_dir() up, similarly to how it's done in
vfs_rename_other().  The next patch will consolidate these two functions
and this is the only structural difference between them.

I'm not sure if doing the d_move() after the dput is even valid.  But there
may be a logical explanation for that.  But moving the d_move() before the
dput() (and the mutex_unlock()) should definitely not hurt.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 645268f..911aadc 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4007,13 +4007,12 @@ static int vfs_rename_dir(struct inode *old_dir, struct dentry *old_dentry,
 		target->i_flags |= S_DEAD;
 		dont_mount(new_dentry);
 	}
+	if (!(old_dir->i_sb->s_type->fs_flags & FS_RENAME_DOES_D_MOVE))
+		d_move(old_dentry, new_dentry);
 out:
 	if (target)
 		mutex_unlock(&target->i_mutex);
 	dput(new_dentry);
-	if (!error)
-		if (!(old_dir->i_sb->s_type->fs_flags & FS_RENAME_DOES_D_MOVE))
-			d_move(old_dentry,new_dentry);
 	return error;
 }
 
-- 
1.8.1.4


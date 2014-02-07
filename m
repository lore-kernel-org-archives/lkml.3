Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbaBGQsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 11:48:39 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:37487 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbaBGQsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 11:48:31 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        bfields@fieldses.org, hch@infradead.org, akpm@linux-foundation.org,
        dhowells@redhat.com, zab@redhat.com, jack@suse.cz, luto@amacapital.net,
        mszeredi@suse.cz
Subject: [PATCH 02/13] vfs: rename: move d_move() up
Date: Fri,  7 Feb 2014 17:49:00 +0100
Message-Id: <1391791751-2533-3-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
References: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
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
index 258c06ae26a7..1409090d0913 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4018,13 +4018,12 @@ static int vfs_rename_dir(struct inode *old_dir, struct dentry *old_dentry,
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


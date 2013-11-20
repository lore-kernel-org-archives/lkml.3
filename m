Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab3KTNFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 08:05:25 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:34090 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab3KTNCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 08:02:00 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, dhowells@redhat.com, zab@redhat.com,
        jack@suse.cz, luto@amacapital.net, mszeredi@suse.cz
Subject: [PATCH 02/11] vfs: rename: move d_move() up
Date: Wed, 20 Nov 2013 14:01:43 +0100
Message-Id: <1384952512-21600-3-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384952512-21600-1-git-send-email-miklos@szeredi.hu>
References: <1384952512-21600-1-git-send-email-miklos@szeredi.hu>
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
index 0f2a7f8febee..c0446b916af0 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4039,13 +4039,12 @@ static int vfs_rename_dir(struct inode *old_dir, struct dentry *old_dentry,
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


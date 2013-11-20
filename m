Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab3KTNCZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 08:02:25 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:40934 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab3KTNCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 08:02:13 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, dhowells@redhat.com, zab@redhat.com,
        jack@suse.cz, luto@amacapital.net, mszeredi@suse.cz
Subject: [PATCH 09/11] ext4: rename: move EMLINK check up
Date: Wed, 20 Nov 2013 14:01:50 +0100
Message-Id: <1384952512-21600-10-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384952512-21600-1-git-send-email-miklos@szeredi.hu>
References: <1384952512-21600-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Move checking i_nlink from after ext4_get_first_dir_block() to before.  The
check doesn't rely on the result of that function and the function only
fails on fs corruption, so the order shouldn't matter.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/namei.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index c9e38bd30e8b..94583a4bd875 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3089,6 +3089,10 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 			retval = -ENOTEMPTY;
 			if (!empty_dir(new.inode))
 				goto end_rename;
+		} else {
+			retval = -EMLINK;
+			if (new.dir != old.dir && EXT4_DIR_LINK_MAX(new.dir))
+				goto end_rename;
 		}
 		retval = -EIO;
 		old.dir_bh = ext4_get_first_dir_block(handle, old.inode,
@@ -3098,10 +3102,6 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 			goto end_rename;
 		if (le32_to_cpu(old.parent_de->inode) != old.dir->i_ino)
 			goto end_rename;
-		retval = -EMLINK;
-		if (!new.inode && new.dir != old.dir &&
-		    EXT4_DIR_LINK_MAX(new.dir))
-			goto end_rename;
 		BUFFER_TRACE(old.dir_bh, "get_write_access");
 		retval = ext4_journal_get_write_access(handle, old.dir_bh);
 		if (retval)
-- 
1.8.1.4


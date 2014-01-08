Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415AbaAHWKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 17:10:55 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:65271 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283AbaAHWJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 17:09:58 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, dhowells@redhat.com, zab@redhat.com,
        jack@suse.cz, luto@amacapital.net, mszeredi@suse.cz
Subject: [PATCH 09/11] ext4: rename: move EMLINK check up
Date: Wed,  8 Jan 2014 23:10:13 +0100
Message-Id: <1389219015-10980-10-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>
References: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>
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
index bb3e2b4614dc..7f40f2ea2f4a 100644
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


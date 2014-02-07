Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbaBGQxo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 11:53:44 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:57133 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbaBGQst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 11:48:49 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        bfields@fieldses.org, hch@infradead.org, akpm@linux-foundation.org,
        dhowells@redhat.com, zab@redhat.com, jack@suse.cz, luto@amacapital.net,
        mszeredi@suse.cz
Subject: [PATCH 10/13] ext4: rename: move EMLINK check up
Date: Fri,  7 Feb 2014 17:49:08 +0100
Message-Id: <1391791751-2533-11-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
References: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
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
index 7193cea805ff..87a8a6e613ba 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3084,6 +3084,10 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
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
@@ -3093,10 +3097,6 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
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


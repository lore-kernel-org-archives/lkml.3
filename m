Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab3JJOrh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 10:47:37 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:63539 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab3JJOrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 10:47:35 -0400
Date: Thu, 10 Oct 2013 16:48:19 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ext[34]: fix double put in tmpfile
Message-ID: <20131010144819.GA16642@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

d_tmpfile() already swallowed the inode ref.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: stable@vger.kernel.org
---
 fs/ext3/namei.c |    5 ++---
 fs/ext4/namei.c |    5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2319,7 +2319,7 @@ static int ext4_tmpfile(struct inode *di
 		d_tmpfile(dentry, inode);
 		err = ext4_orphan_add(handle, inode);
 		if (err)
-			goto err_drop_inode;
+			goto err_unlock_inode;
 		mark_inode_dirty(inode);
 		unlock_new_inode(inode);
 	}
@@ -2328,10 +2328,9 @@ static int ext4_tmpfile(struct inode *di
 	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
 	return err;
-err_drop_inode:
+err_unlock_inode:
 	ext4_journal_stop(handle);
 	unlock_new_inode(inode);
-	iput(inode);
 	return err;
 }
 
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1783,7 +1783,7 @@ static int ext3_tmpfile(struct inode *di
 		d_tmpfile(dentry, inode);
 		err = ext3_orphan_add(handle, inode);
 		if (err)
-			goto err_drop_inode;
+			goto err_unlock_inode;
 		mark_inode_dirty(inode);
 		unlock_new_inode(inode);
 	}
@@ -1791,10 +1791,9 @@ static int ext3_tmpfile(struct inode *di
 	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
 	return err;
-err_drop_inode:
+err_unlock_inode:
 	ext3_journal_stop(handle);
 	unlock_new_inode(inode);
-	iput(inode);
 	return err;
 }
 

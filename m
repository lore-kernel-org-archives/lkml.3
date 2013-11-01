Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474Ab3KAWIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:08:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55490 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391Ab3KAWI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:08:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Miklos Szeredi <mszeredi@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3.11 50/66] ext[34]: fix double put in tmpfile
Date: Fri,  1 Nov 2013 15:07:26 -0700
Message-Id: <20131101220648.546065533@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220634.605745564@linuxfoundation.org>
References: <20131101220634.605745564@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit 43ae9e3fc70ca0057ae0a24ef5eedff05e3fae06 upstream.

d_tmpfile() already swallowed the inode ref.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext3/namei.c |    5 ++---
 fs/ext4/namei.c |    5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1783,7 +1783,7 @@ retry:
 		d_tmpfile(dentry, inode);
 		err = ext3_orphan_add(handle, inode);
 		if (err)
-			goto err_drop_inode;
+			goto err_unlock_inode;
 		mark_inode_dirty(inode);
 		unlock_new_inode(inode);
 	}
@@ -1791,10 +1791,9 @@ retry:
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
 
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2319,7 +2319,7 @@ retry:
 		d_tmpfile(dentry, inode);
 		err = ext4_orphan_add(handle, inode);
 		if (err)
-			goto err_drop_inode;
+			goto err_unlock_inode;
 		mark_inode_dirty(inode);
 		unlock_new_inode(inode);
 	}
@@ -2328,10 +2328,9 @@ retry:
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
 



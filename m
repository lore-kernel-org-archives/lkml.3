Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965450Ab3GSFW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:22:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39408 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965415Ab3GSFWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:22:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [ 33/38] ext4: fix overflow when counting used blocks on 32-bit architectures
Date: Thu, 18 Jul 2013 22:21:49 -0700
Message-Id: <20130719052050.142708621@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052047.858393825@linuxfoundation.org>
References: <20130719052047.858393825@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 8af8eecc1331dbf5e8c662022272cf667e213da5 upstream.

The arithmetics adding delalloc blocks to the number of used blocks in
ext4_getattr() can easily overflow on 32-bit archs as we first multiply
number of blocks by blocksize and then divide back by 512. Make the
arithmetics more clever and also use proper type (unsigned long long
instead of unsigned long).

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4616,7 +4616,7 @@ int ext4_getattr(struct vfsmount *mnt, s
 		 struct kstat *stat)
 {
 	struct inode *inode;
-	unsigned long delalloc_blocks;
+	unsigned long long delalloc_blocks;
 
 	inode = dentry->d_inode;
 	generic_fillattr(inode, stat);
@@ -4634,7 +4634,7 @@ int ext4_getattr(struct vfsmount *mnt, s
 	delalloc_blocks = EXT4_C2B(EXT4_SB(inode->i_sb),
 				EXT4_I(inode)->i_reserved_data_blocks);
 
-	stat->blocks += (delalloc_blocks << inode->i_sb->s_blocksize_bits)>>9;
+	stat->blocks += delalloc_blocks << (inode->i_sb->s_blocksize_bits-9);
 	return 0;
 }
 



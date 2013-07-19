Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965501Ab3GSFWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:22:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39449 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965455Ab3GSFW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:22:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Maarten ter Huurne <maarten@treewalker.org>,
        "Theodore Tso" <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Subject: [ 07/38] ext4: fix corruption when online resizing a fs with 1K block size
Date: Thu, 18 Jul 2013 22:21:23 -0700
Message-Id: <20130719052048.381829873@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052047.858393825@linuxfoundation.org>
References: <20130719052047.858393825@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maarten ter Huurne <maarten@treewalker.org>

commit 6ca792edc13c409e8d4eb9001e048264c6a2eb64 upstream.

Subtracting the number of the first data block places the superblock
backups one block too early, corrupting the file system. When the block
size is larger than 1K, the first data block is 0, so the subtraction
has no effect and no corruption occurs.

Signed-off-by: Maarten ter Huurne <maarten@treewalker.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/resize.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1656,12 +1656,10 @@ errout:
 		err = err2;
 
 	if (!err) {
-		ext4_fsblk_t first_block;
-		first_block = ext4_group_first_block_no(sb, 0);
 		if (test_opt(sb, DEBUG))
 			printk(KERN_DEBUG "EXT4-fs: extended group to %llu "
 			       "blocks\n", ext4_blocks_count(es));
-		update_backups(sb, EXT4_SB(sb)->s_sbh->b_blocknr - first_block,
+		update_backups(sb, EXT4_SB(sb)->s_sbh->b_blocknr,
 			       (char *)es, sizeof(struct ext4_super_block), 0);
 	}
 	return err;



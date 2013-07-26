Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933547Ab3GZV3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:29:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50922 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759991Ab3GZUsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 71/79] ext4: fix error handling in ext4_ext_truncate()
Date: Fri, 26 Jul 2013 13:48:01 -0700
Message-Id: <20130726204730.256399621@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 8acd5e9b1217e58a57124d9e225afa12efeae20d upstream.

Previously ext4_ext_truncate() was ignoring potential error returns
from ext4_es_remove_extent() and ext4_ext_remove_space().  This can
lead to the on-diks extent tree and the extent status tree cache
getting out of sync, which is particuarlly bad, and can lead to file
system corruption and potential data loss.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/extents.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4386,9 +4386,20 @@ void ext4_ext_truncate(handle_t *handle,
 
 	last_block = (inode->i_size + sb->s_blocksize - 1)
 			>> EXT4_BLOCK_SIZE_BITS(sb);
+retry:
 	err = ext4_es_remove_extent(inode, last_block,
 				    EXT_MAX_BLOCKS - last_block);
+	if (err == ENOMEM) {
+		cond_resched();
+		congestion_wait(BLK_RW_ASYNC, HZ/50);
+		goto retry;
+	}
+	if (err) {
+		ext4_std_error(inode->i_sb, err);
+		return;
+	}
 	err = ext4_ext_remove_space(inode, last_block, EXT_MAX_BLOCKS - 1);
+	ext4_std_error(inode->i_sb, err);
 }
 
 static void ext4_falloc_update_inode(struct inode *inode,



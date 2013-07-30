Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab3G3PZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:25:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55319 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705Ab3G3PSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:18:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 19/75] ext4: fix error handling in ext4_ext_truncate()
Date: Tue, 30 Jul 2013 08:16:48 -0700
Message-Id: <1375197464-27962-20-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 8acd5e9b1217e58a57124d9e225afa12efeae20d upstream.

Previously ext4_ext_truncate() was ignoring potential error returns
from ext4_es_remove_extent() and ext4_ext_remove_space().  This can
lead to the on-diks extent tree and the extent status tree cache
getting out of sync, which is particuarlly bad, and can lead to file
system corruption and potential data loss.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/extents.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index a5ce6ce..728c8f6 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4326,9 +4326,20 @@ void ext4_ext_truncate(struct inode *inode)
 
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
 
 	/* In a multi-transaction truncate, we only make the final
 	 * transaction synchronous.
-- 
1.8.1.2


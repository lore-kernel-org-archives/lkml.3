Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933629AbaEMKLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:11:45 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933513AbaEMKLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:11:41 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Kazuya Mio <k-mio@sx.jp.nec.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 115/182] ext4: FIBMAP ioctl causes BUG_ON due to handle EXT_MAX_BLOCKS
Date: Tue, 13 May 2014 11:27:47 +0200
Message-Id: <ba6825df62da40b27bf5f28f9ef14051f3b0ff52.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kazuya Mio <k-mio@sx.jp.nec.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 4adb6ab3e0fa71363a5ef229544b2d17de6600d7 upstream.

When we try to get 2^32-1 block of the file which has the extent
(ee_block=2^32-2, ee_len=1) with FIBMAP ioctl, it causes BUG_ON
in ext4_ext_put_gap_in_cache().

To avoid the problem, ext4_map_blocks() needs to check the file logical block
number. ext4_ext_put_gap_in_cache() called via ext4_map_blocks() cannot
handle 2^32-1 because the maximum file logical block number is 2^32-2.

Note that ext4_ind_map_blocks() returns -EIO when the block number is invalid.
So ext4_map_blocks() should also return the same errno.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ext4/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f173ef12c97a..8fdf99bf18d6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -515,6 +515,10 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 		  "logical block %lu\n", inode->i_ino, flags, map->m_len,
 		  (unsigned long) map->m_lblk);
 
+	/* We can handle the block number less than EXT_MAX_BLOCKS */
+	if (unlikely(map->m_lblk >= EXT_MAX_BLOCKS))
+		return -EIO;
+
 	/* Lookup extent status tree firstly */
 	if (ext4_es_lookup_extent(inode, map->m_lblk, &es)) {
 		ext4_es_lru_add(inode);
-- 
1.9.3


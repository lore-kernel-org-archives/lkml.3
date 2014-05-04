Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbaEDQWj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:22:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36387 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446AbaEDPmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kazuya Mio <k-mio@sx.jp.nec.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [PATCH 3.14 148/158] ext4: FIBMAP ioctl causes BUG_ON due to handle EXT_MAX_BLOCKS
Date: Sun,  4 May 2014 11:40:57 -0400
Message-Id: <20140504154050.134260742@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kazuya Mio <k-mio@sx.jp.nec.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/inode.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -515,6 +515,10 @@ int ext4_map_blocks(handle_t *handle, st
 		  "logical block %lu\n", inode->i_ino, flags, map->m_len,
 		  (unsigned long) map->m_lblk);
 
+	/* We can handle the block number less than EXT_MAX_BLOCKS */
+	if (unlikely(map->m_lblk >= EXT_MAX_BLOCKS))
+		return -EIO;
+
 	/* Lookup extent status tree firstly */
 	if (ext4_es_lookup_extent(inode, map->m_lblk, &es)) {
 		ext4_es_lru_add(inode);



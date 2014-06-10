Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbaFJTx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:53:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35511 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932462AbaFJTxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:53:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kazuya Mio <k-mio@sx.jp.nec.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 058/160] ext4: FIBMAP ioctl causes BUG_ON due to handle EXT_MAX_BLOCKS
Date: Tue, 10 Jun 2014 12:44:58 -0700
Message-Id: <1402429600-20477-59-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 18e1871..8ccbe9a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -521,6 +521,10 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	if (unlikely(map->m_len > INT_MAX))
 		map->m_len = INT_MAX;
 
+	/* We can handle the block number less than EXT_MAX_BLOCKS */
+	if (unlikely(map->m_lblk >= EXT_MAX_BLOCKS))
+		return -EIO;
+
 	/* Lookup extent status tree firstly */
 	if (ext4_es_lookup_extent(inode, map->m_lblk, &es)) {
 		ext4_es_lru_add(inode);
-- 
1.9.1


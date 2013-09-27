Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab3I0PyH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 11:54:07 -0400
Received: from relay.parallels.com ([195.214.232.42]:51664 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab3I0PyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 11:54:05 -0400
Subject: [PATCH] ext4: avoid exposure of stale data in ext4_punch_hole() -v2
To: tytso@mit.edu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, jack@suse.cz,
        linux-kernel@vger.kernel.org
Date: Fri, 27 Sep 2013 19:54:03 +0400
Message-ID: <20130927155329.3272.64086.stgit@dhcp-10-30-17-2.sw.ru>
In-Reply-To: <20130926173113.23276.77451.stgit@dhcp-10-30-17-2.sw.ru>
References: <20130926173113.23276.77451.stgit@dhcp-10-30-17-2.sw.ru>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While handling punch-hole fallocate, it's useless to truncate page cache
before removing the range from extent tree (or block map in indirect case)
because page cache can be re-populated (by read-ahead or read(2) or mmap-ed
read) immediately after truncating page cache, but before updating extent
tree (or block map). In that case the user will see stale data even after
fallocate is completed.

Changed in v2 (Thanks to Jan Kara):
 - Until the problem of data corruption resulting from pages backed by
   already freed blocks is fully resolved, the simple thing we can do now
   is to add another truncation of pagecache after punch hole is done.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/ext4/inode.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0d424d7..2984ddf 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3621,6 +3621,12 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 	up_write(&EXT4_I(inode)->i_data_sem);
 	if (IS_SYNC(inode))
 		ext4_handle_sync(handle);
+
+	/* Now release the pages again to reduce race window */
+	if (last_block_offset > first_block_offset)
+		truncate_pagecache_range(inode, first_block_offset,
+					 last_block_offset);
+
 	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
 	ext4_mark_inode_dirty(handle, inode);
 out_stop:


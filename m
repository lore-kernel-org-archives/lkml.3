Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933775AbaEMKQC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:16:02 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933639AbaEMKLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:11:47 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 116/182] ext4: note the error in ext4_end_bio()
Date: Tue, 13 May 2014 11:27:48 +0200
Message-Id: <2c8b455bfb89a84a0195b72fffe6166532749c02.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Wilcox <willy@linux.intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 9503c67c93ed0b95ba62d12d1fd09da6245dbdd6 upstream.

ext4_end_bio() currently throws away the error that it receives.  Chances
are this is part of a spate of errors, one of which will end up getting
the error returned to userspace somehow, but we shouldn't take that risk.
Also print out the errno to aid in debug.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ext4/page-io.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index d7d0c7b46ed4..02e94ef1489b 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -307,13 +307,14 @@ static void ext4_end_bio(struct bio *bio, int error)
 	if (error) {
 		struct inode *inode = io_end->inode;
 
-		ext4_warning(inode->i_sb, "I/O error writing to inode %lu "
+		ext4_warning(inode->i_sb, "I/O error %d writing to inode %lu "
 			     "(offset %llu size %ld starting block %llu)",
-			     inode->i_ino,
+			     error, inode->i_ino,
 			     (unsigned long long) io_end->offset,
 			     (long) io_end->size,
 			     (unsigned long long)
 			     bi_sector >> (inode->i_blkbits - 9));
+		mapping_set_error(inode->i_mapping, error);
 	}
 
 	if (io_end->flag & EXT4_IO_END_UNWRITTEN) {
-- 
1.9.3


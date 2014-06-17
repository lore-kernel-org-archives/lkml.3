Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933760AbaFQQPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:15:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50430 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933633AbaFQQPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:15:45 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 025/121] ext4: note the error in ext4_end_bio()
Date: Tue, 17 Jun 2014 09:13:38 -0700
Message-Id: <1403021714-16320-26-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021714-16320-1-git-send-email-kamal@canonical.com>
References: <1403021714-16320-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox <willy@linux.intel.com>

commit 9503c67c93ed0b95ba62d12d1fd09da6245dbdd6 upstream.

ext4_end_bio() currently throws away the error that it receives.  Chances
are this is part of a spate of errors, one of which will end up getting
the error returned to userspace somehow, but we shouldn't take that risk.
Also print out the errno to aid in debug.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/page-io.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index b42d04f..311d1db 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -308,13 +308,14 @@ static void ext4_end_bio(struct bio *bio, int error)
 
 	if (error) {
 		io_end->flag |= EXT4_IO_END_ERROR;
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
 
 	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
-- 
1.9.1


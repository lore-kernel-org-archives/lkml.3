Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbaEDQWW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:22:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36352 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453AbaEDPmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Theodore Tso" <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Subject: [PATCH 3.14 149/158] ext4: note the error in ext4_end_bio()
Date: Sun,  4 May 2014 11:40:58 -0400
Message-Id: <20140504154050.265455525@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/page-io.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -308,13 +308,14 @@ static void ext4_end_bio(struct bio *bio
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



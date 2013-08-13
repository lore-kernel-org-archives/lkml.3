Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab3HMGdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:33:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60443 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594Ab3HMGdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:33:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 11/60] ext4: make sure group number is bumped after a inode allocation race
Date: Mon, 12 Aug 2013 23:33:38 -0700
Message-Id: <20130813063333.575915023@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063331.950321483@linuxfoundation.org>
References: <20130813063331.950321483@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit a34eb503742fd25155fd6cff6163daacead9fbc3 upstream.

When we try to allocate an inode, and there is a race between two
CPU's trying to grab the same inode, _and_ this inode is the last free
inode in the block group, make sure the group number is bumped before
we continue searching the rest of the block groups.  Otherwise, we end
up searching the current block group twice, and we end up skipping
searching the last block group.  So in the unlikely situation where
almost all of the inodes are allocated, it's possible that we will
return ENOSPC even though there might be free inodes in that last
block group.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ialloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -734,11 +734,8 @@ repeat_in_this_group:
 		ino = ext4_find_next_zero_bit((unsigned long *)
 					      inode_bitmap_bh->b_data,
 					      EXT4_INODES_PER_GROUP(sb), ino);
-		if (ino >= EXT4_INODES_PER_GROUP(sb)) {
-			if (++group == ngroups)
-				group = 0;
-			continue;
-		}
+		if (ino >= EXT4_INODES_PER_GROUP(sb))
+			goto next_group;
 		if (group == 0 && (ino+1) < EXT4_FIRST_INO(sb)) {
 			ext4_error(sb, "reserved inode found cleared - "
 				   "inode=%lu", ino + 1);
@@ -768,6 +765,9 @@ repeat_in_this_group:
 			goto got; /* we grabbed the inode! */
 		if (ino < EXT4_INODES_PER_GROUP(sb))
 			goto repeat_in_this_group;
+next_group:
+		if (++group == ngroups)
+			group = 0;
 	}
 	err = -ENOSPC;
 	goto out;



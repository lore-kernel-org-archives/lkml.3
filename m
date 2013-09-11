Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab3IKFmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:42:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5606 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab3IKE5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:13 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=SSGtTLglprAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=1V2W37h24bEA:10 a=VwQbUJbxAAAA:8 a=QHxGya_THJoqQMz--fQA:9 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042920.330420589@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Theodore Tso" <tytso@mit.edu>
Subject: [168/251] ext4: make sure group number is bumped after a inode allocation race
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0168-ext4-make-sure-group-number-is-bumped-after-a-inode-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit a34eb503742fd25155fd6cff6163daacead9fbc3 ]

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
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/ext4/ialloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index c690ff9..16481bd 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -706,11 +706,8 @@ repeat_in_this_group:
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
@@ -728,6 +725,9 @@ repeat_in_this_group:
 			goto got; /* we grabbed the inode! */
 		if (ino < EXT4_INODES_PER_GROUP(sb))
 			goto repeat_in_this_group;
+next_group:
+		if (++group == ngroups)
+			group = 0;
 	}
 	err = -ENOSPC;
 	goto out;
-- 
1.7.10.4



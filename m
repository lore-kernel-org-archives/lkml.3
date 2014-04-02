Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606AbaDBR2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 13:28:12 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:5961 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932501AbaDBR2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 13:28:09 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuMNACxIPFNbtAq4/2dsb2JhbABZgwa9RIcxAgKBHhd0gi0CJBMcIxhxESQTh30Bz0uOcIQ/AQOOWYcmglYBil6HW4MyOw
Date: Wed, 2 Apr 2014 19:29:50 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, jfs-discussion@lists.sourceforge.net
Subject: [PATCH 1/1] fs/jfs/jfs_inode.c: atomically set inode->i_flags
Message-Id: <20140402192950.82812a331cb154bbc0a4183c@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to commit 00a1a053ebe5f
("ext4: atomically set inode->i_flags in ext4_set_inode_flags()")

Inspired-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: jfs-discussion@lists.sourceforge.net
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/jfs/jfs_inode.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/jfs/jfs_inode.c b/fs/jfs/jfs_inode.c
index 7f464c5..3309074 100644
--- a/fs/jfs/jfs_inode.c
+++ b/fs/jfs/jfs_inode.c
@@ -29,20 +29,20 @@
 void jfs_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = JFS_IP(inode)->mode2;
-
-	inode->i_flags &= ~(S_IMMUTABLE | S_APPEND |
-		S_NOATIME | S_DIRSYNC | S_SYNC);
+	unsigned int new_fl = 0;
 
 	if (flags & JFS_IMMUTABLE_FL)
-		inode->i_flags |= S_IMMUTABLE;
+		new_fl |= S_IMMUTABLE;
 	if (flags & JFS_APPEND_FL)
-		inode->i_flags |= S_APPEND;
+		new_fl |= S_APPEND;
 	if (flags & JFS_NOATIME_FL)
-		inode->i_flags |= S_NOATIME;
+		new_fl |= S_NOATIME;
 	if (flags & JFS_DIRSYNC_FL)
-		inode->i_flags |= S_DIRSYNC;
+		new_fl |= S_DIRSYNC;
 	if (flags & JFS_SYNC_FL)
-		inode->i_flags |= S_SYNC;
+		new_fl |= S_SYNC;
+	set_mask_bits(&inode->i_flags, S_IMMUTABLE | S_APPEND | S_NOATIME |
+				       S_DIRSYNC | S_SYNC, new_fl);
 }
 
 void jfs_get_inode_flags(struct jfs_inode_info *jfs_ip)
-- 
1.8.4.5


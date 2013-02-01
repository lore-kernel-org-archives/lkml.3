Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab3BAGI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 01:08:29 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:38957 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab3BAGI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 01:08:27 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch] fs: inode: fix icache pruning locked inode spin protection
Date: Fri,  1 Feb 2013 01:08:14 -0500
Message-Id: <1359698894-7044-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inodes are added to the head of the superblock LRU list and reclaimed
from the tail.  If trylocking an inode during reclaim fails, it has to
be moved to the head of the list, not the tail, to prevent spinning on
it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 fs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 14084b7..852bcbf 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -722,10 +722,10 @@ void prune_icache_sb(struct super_block *sb, int nr_to_scan)
 		/*
 		 * we are inverting the sb->s_inode_lru_lock/inode->i_lock here,
 		 * so use a trylock. If we fail to get the lock, just move the
-		 * inode to the back of the list so we don't spin on it.
+		 * inode to the other end of the list so we don't spin on it.
 		 */
 		if (!spin_trylock(&inode->i_lock)) {
-			list_move_tail(&inode->i_lru, &sb->s_inode_lru);
+			list_move(&inode->i_lru, &sb->s_inode_lru);
 			continue;
 		}
 
-- 
1.7.11.7


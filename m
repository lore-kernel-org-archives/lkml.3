Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab3DMXDL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 19:03:11 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:48104 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab3DMXDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 19:03:09 -0400
Date: Sat, 13 Apr 2013 16:03:06 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Al Viro <viro@zeniv.linux.org.uk>
cc: Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Suleiman Souhlal <suleiman@google.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] vfs: Revert spurious fix to spinning prevention in
 prune_icache_sb
Message-ID: <alpine.LNX.2.00.1304131555300.2021@eggly.anvils>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suleiman Souhlal <suleiman@google.com>

Revert v3.2's 62a3dde ("vfs: fix spinning prevention in prune_icache_sb").

This commit doesn't look right:
Since we are looking at the tail of the list (sb->s_inode_lru.prev)
if we want to skip an inode, we should put it back at the head of
the list instead of the tail, otherwise we will keep spinning on it.

Discovered when investigating why prune_icache_sb came top in perf
reports of a swapping load.
 
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: stable@vger.kernel.org
---

 fs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
    
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -725,7 +725,7 @@ void prune_icache_sb(struct super_block *sb, int nr_to_scan, int priority)
 		 * inode to the back of the list so we don't spin on it.
 		 */
 		if (!spin_trylock(&inode->i_lock)) {
-			list_move_tail(&inode->i_lru, &sb->s_inode_lru);
+			list_move(&inode->i_lru, &sb->s_inode_lru);
 			continue;
 		}
 

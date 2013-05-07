Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933270Ab3EGD7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 23:59:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21552 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932978Ab3EGD7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:59:01 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=cnGIwuGMVSEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Pw45o5U4ifkA:10 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=pGLkceISAAAA:8 a=0vF5R7nFAAAA:8 a=1haGB4nQzVCtRAZ18OIA:9 a=u8vfFSLHYHoA:10 a=UTB_XpHje0EA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035849.285608737@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Suleiman Souhlal <suleiman@google.com>, Hugh Dickins <hughd@google.com>
Subject: [050/126] vfs: Revert spurious fix to spinning prevention in prune_icache_sb
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0050-vfs-Revert-spurious-fix-to-spinning-prevention-in-pr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Suleiman Souhlal <suleiman@google.com>

[ Upstream commit 5b55d708335a9e3e4f61f2dadf7511502205ccd1 ]

Revert commit 62a3ddef6181 ("vfs: fix spinning prevention in prune_icache_sb").

This commit doesn't look right: since we are looking at the tail of the
list (sb->s_inode_lru.prev) if we want to skip an inode, we should put
it back at the head of the list instead of the tail, otherwise we will
keep spinning on it.

Discovered when investigating why prune_icache_sb came top in perf
reports of a swapping load.

Signed-off-by: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: stable@vger.kernel.org # v3.2+
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/inode.c b/fs/inode.c
index 7c14897..d76b46f 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -725,7 +725,7 @@ void prune_icache_sb(struct super_block *sb, int nr_to_scan)
 		 * inode to the back of the list so we don't spin on it.
 		 */
 		if (!spin_trylock(&inode->i_lock)) {
-			list_move_tail(&inode->i_lru, &sb->s_inode_lru);
+			list_move(&inode->i_lru, &sb->s_inode_lru);
 			continue;
 		}
 
-- 
1.7.10.4



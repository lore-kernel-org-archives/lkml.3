Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934468Ab3DOCoH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:44:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36506 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934290Ab3DOCoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:44:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Suleiman Souhlal <suleiman@google.com>,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 17/27] vfs: Revert spurious fix to spinning prevention in prune_icache_sb
Date: Sun, 14 Apr 2013 19:43:16 -0700
Message-Id: <20130415024232.637986298@linuxfoundation.org>
X-Mailer: git-send-email 1.8.2.1.368.g99c2266
In-Reply-To: <20130415024231.351969241@linuxfoundation.org>
References: <20130415024231.351969241@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suleiman Souhlal <suleiman@google.com>

commit 5b55d708335a9e3e4f61f2dadf7511502205ccd1 upstream.

Revert commit 62a3ddef6181 ("vfs: fix spinning prevention in prune_icache_sb").

This commit doesn't look right: since we are looking at the tail of the
list (sb->s_inode_lru.prev) if we want to skip an inode, we should put
it back at the head of the list instead of the tail, otherwise we will
keep spinning on it.

Discovered when investigating why prune_icache_sb came top in perf
reports of a swapping load.

Signed-off-by: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/inode.c
+++ b/fs/inode.c
@@ -725,7 +725,7 @@ void prune_icache_sb(struct super_block
 		 * inode to the back of the list so we don't spin on it.
 		 */
 		if (!spin_trylock(&inode->i_lock)) {
-			list_move_tail(&inode->i_lru, &sb->s_inode_lru);
+			list_move(&inode->i_lru, &sb->s_inode_lru);
 			continue;
 		}
 



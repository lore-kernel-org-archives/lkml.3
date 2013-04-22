Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab3DVOlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:41:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51586 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754897Ab3DVOaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:30:12 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Hugh Dickins" <hughd@google.com>,
        "Suleiman Souhlal" <suleiman@google.com>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.574719193@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [42/75] vfs: Revert spurious fix to spinning prevention in
 prune_icache_sb
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/inode.c
+++ b/fs/inode.c
@@ -634,7 +634,7 @@ void prune_icache_sb(struct super_block
 		 * inode to the back of the list so we don't spin on it.
 		 */
 		if (!spin_trylock(&inode->i_lock)) {
-			list_move_tail(&inode->i_lru, &sb->s_inode_lru);
+			list_move(&inode->i_lru, &sb->s_inode_lru);
 			continue;
 		}
 


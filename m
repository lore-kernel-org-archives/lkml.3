Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab3KTTsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 14:48:37 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:41205 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867Ab3KTTsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 14:48:36 -0500
From: Dan Streetman <ddstreet@ieee.org>
To: Seth Jennings <sjennings@variantweb.net>
Cc: Dan Streetman <ddstreet@ieee.org>, linux-mm@kvack.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bob Liu <bob.liu@oracle.com>, Minchan Kim <minchan@kernel.org>,
        Weijie Yang <weijie.yang@samsung.com>
Subject: [PATCH] mm/zswap: don't allow entry eviction if in use by load
Date: Wed, 20 Nov 2013 14:48:29 -0500
Message-Id: <1384976909-32671-1-git-send-email-ddstreet@ieee.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The changes in commit 0ab0abcf511545d1fddbe72a36b3ca73388ac937
introduce a bug in writeback, if an entry is in use by load
it will be evicted anyway, which isn't correct (technically,
the code currently in zbud doesn't actually care much what the
zswap evict function returns, but that could change).

This changes the check in the writeback function to prevent eviction
if the entry is still in use (with a nonzero refcount).  The
refcount is used instead of searching the rb tree beacuse we're
holding the tree lock (which is required for any changes to refcount)
and it's faster than a tree search.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
---
 mm/zswap.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index e55bab9..e154f1e 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -600,14 +600,18 @@ static int zswap_writeback_entry(struct zbud_pool *pool, unsigned long handle)
 	zswap_entry_put(tree, entry);
 
 	/*
-	* There are two possible situations for entry here:
+	* There are three possible situations for entry here:
 	* (1) refcount is 1(normal case),  entry is valid and on the tree
 	* (2) refcount is 0, entry is freed and not on the tree
 	*     because invalidate happened during writeback
-	*  search the tree and free the entry if find entry
+	* (3) refcount is 2, entry is in use by load, prevent eviction
 	*/
-	if (entry == zswap_rb_search(&tree->rbroot, offset))
+	if (likely(entry->refcount > 0))
 		zswap_entry_put(tree, entry);
+	if (unlikely(entry->refcount > 0)) {
+		spin_unlock(&tree->lock);
+		return -EAGAIN;
+	}
 	spin_unlock(&tree->lock);
 
 	goto end;
-- 
1.8.3.1


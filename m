Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab3KTTsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 14:48:14 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:37375 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab3KTTsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 14:48:12 -0500
From: Dan Streetman <ddstreet@ieee.org>
To: Seth Jennings <sjennings@variantweb.net>
Cc: Dan Streetman <ddstreet@ieee.org>, linux-mm@kvack.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bob Liu <bob.liu@oracle.com>, Minchan Kim <minchan@kernel.org>,
        Weijie Yang <weijie.yang@samsung.com>
Subject: [PATCH] mm/zswap: remove unneeded zswap_rb_erase calls
Date: Wed, 20 Nov 2013 14:47:04 -0500
Message-Id: <1384976824-32624-1-git-send-email-ddstreet@ieee.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since zswap_rb_erase was added to the final (when refcount == 0)
zswap_put_entry, there is no need to call zswap_rb_erase before
calling zswap_put_entry.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
---
 mm/zswap.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index e154f1e..f4fbbd5 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -711,8 +711,6 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
 		ret = zswap_rb_insert(&tree->rbroot, entry, &dupentry);
 		if (ret == -EEXIST) {
 			zswap_duplicate_entry++;
-			/* remove from rbtree */
-			zswap_rb_erase(&tree->rbroot, dupentry);
 			zswap_entry_put(tree, dupentry);
 		}
 	} while (ret == -EEXIST);
@@ -787,9 +785,6 @@ static void zswap_frontswap_invalidate_page(unsigned type, pgoff_t offset)
 		return;
 	}
 
-	/* remove from rbtree */
-	zswap_rb_erase(&tree->rbroot, entry);
-
 	/* drop the initial reference from entry creation */
 	zswap_entry_put(tree, entry);
 
-- 
1.8.3.1


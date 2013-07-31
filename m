Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780Ab3GaERA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 00:17:00 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:34985 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750890Ab3GaEQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 00:16:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApgDAKOO+FF5LPxHgWdsb2JhbABbwz0XDgEBFiYogiQBAQUnLyMQCBgxOQMbGYgPuGqQG4NzA6IAilEq
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, davej@redhat.com,
        viro@zeniv.linux.org.uk, jack@suse.cz, glommer@parallels.com
Subject: [PATCH 10/11] list_lru: don't need node lock in list_lru_count_node
Date: Wed, 31 Jul 2013 14:15:49 +1000
Message-Id: <1375244150-27296-11-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375244150-27296-1-git-send-email-david@fromorbit.com>
References: <1375244150-27296-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The overall count of objects on a node might be accurate, but the
moment it is returned to the caller it is no longer perfectly
accurate. Hence we don't really need to hold the node lock to
protect the read of the object. The count is a long, so can be read
atomically on all platforms and so we don't need the lock there,
either. And the cost of the lock is not trivial, either, as it is
showing up in profiles on 16-way lookup workloads like so:

-  15.44%  [kernel]  [k] __ticket_spin_trylock
      - 46.59% _raw_spin_lock
         + 69.40% list_lru_add
           17.65% list_lru_del
           5.70% list_lru_count_node

IOWs, while the LRU locking scales, it is still costly. The locking
doesn't provide any real advantage for counting, so just kill the
locking in list_lru_count_node().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 mm/list_lru.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index 7246791..9aadb6c 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -51,15 +51,9 @@ EXPORT_SYMBOL_GPL(list_lru_del);
 unsigned long
 list_lru_count_node(struct list_lru *lru, int nid)
 {
-	unsigned long count = 0;
 	struct list_lru_node *nlru = &lru->node[nid];
-
-	spin_lock(&nlru->lock);
 	WARN_ON_ONCE(nlru->nr_items < 0);
-	count += nlru->nr_items;
-	spin_unlock(&nlru->lock);
-
-	return count;
+	return nlru->nr_items;
 }
 EXPORT_SYMBOL_GPL(list_lru_count_node);
 
-- 
1.8.3.2


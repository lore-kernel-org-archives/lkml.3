Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbaIQPde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 11:33:34 -0400
Received: from mx2.parallels.com ([199.115.105.18]:58367 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936AbaIQPdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 11:33:33 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Dave Chinner <david@fromorbit.com>, Glauber Costa <glommer@gmail.com>
Subject: [PATCH] list_lru: get rid of ->active_nodes
Date: Wed, 17 Sep 2014 19:33:18 +0400
Message-ID: <1410967998-29640-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The active_nodes mask allows us to skip empty nodes when walking over
list_lru items from all nodes in list_lru_count/walk. However, these
functions are never called from really hot paths, so it doesn't seem we
need such kind of optimization there.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Glauber Costa <glommer@gmail.com>
---
 include/linux/list_lru.h |    5 ++---
 mm/list_lru.c            |   10 +++-------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
index f3434533fbf8..447d39da1dc0 100644
--- a/include/linux/list_lru.h
+++ b/include/linux/list_lru.h
@@ -30,7 +30,6 @@ struct list_lru_node {
 
 struct list_lru {
 	struct list_lru_node	*node;
-	nodemask_t		active_nodes;
 };
 
 void list_lru_destroy(struct list_lru *lru);
@@ -86,7 +85,7 @@ static inline unsigned long list_lru_count(struct list_lru *lru)
 	long count = 0;
 	int nid;
 
-	for_each_node_mask(nid, lru->active_nodes)
+	for_each_node_state(nid, N_MEMORY)
 		count += list_lru_count_node(lru, nid);
 
 	return count;
@@ -126,7 +125,7 @@ list_lru_walk(struct list_lru *lru, list_lru_walk_cb isolate,
 	long isolated = 0;
 	int nid;
 
-	for_each_node_mask(nid, lru->active_nodes) {
+	for_each_node_state(nid, N_MEMORY) {
 		isolated += list_lru_walk_node(lru, nid, isolate,
 					       cb_arg, &nr_to_walk);
 		if (nr_to_walk <= 0)
diff --git a/mm/list_lru.c b/mm/list_lru.c
index f1a0db194173..07e198c77888 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -19,8 +19,7 @@ bool list_lru_add(struct list_lru *lru, struct list_head *item)
 	WARN_ON_ONCE(nlru->nr_items < 0);
 	if (list_empty(item)) {
 		list_add_tail(item, &nlru->list);
-		if (nlru->nr_items++ == 0)
-			node_set(nid, lru->active_nodes);
+		nlru->nr_items++;
 		spin_unlock(&nlru->lock);
 		return true;
 	}
@@ -37,8 +36,7 @@ bool list_lru_del(struct list_lru *lru, struct list_head *item)
 	spin_lock(&nlru->lock);
 	if (!list_empty(item)) {
 		list_del_init(item);
-		if (--nlru->nr_items == 0)
-			node_clear(nid, lru->active_nodes);
+		nlru->nr_items--;
 		WARN_ON_ONCE(nlru->nr_items < 0);
 		spin_unlock(&nlru->lock);
 		return true;
@@ -90,8 +88,7 @@ restart:
 		case LRU_REMOVED_RETRY:
 			assert_spin_locked(&nlru->lock);
 		case LRU_REMOVED:
-			if (--nlru->nr_items == 0)
-				node_clear(nid, lru->active_nodes);
+			nlru->nr_items--;
 			WARN_ON_ONCE(nlru->nr_items < 0);
 			isolated++;
 			/*
@@ -133,7 +130,6 @@ int list_lru_init_key(struct list_lru *lru, struct lock_class_key *key)
 	if (!lru->node)
 		return -ENOMEM;
 
-	nodes_clear(lru->active_nodes);
 	for (i = 0; i < nr_node_ids; i++) {
 		spin_lock_init(&lru->node[i].lock);
 		if (key)
-- 
1.7.10.4


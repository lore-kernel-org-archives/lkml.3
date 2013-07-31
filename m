Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157Ab3GaEQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 00:16:54 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:35001 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751582Ab3GaEQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 00:16:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApgDAKOO+FF5LPxHgWdsb2JhbABbwz0XDgEBFiYogiQBAQUnLyMQCBgxOQMbGYgPuGqQG4NzA6IAilEq
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, davej@redhat.com,
        viro@zeniv.linux.org.uk, jack@suse.cz, glommer@parallels.com
Subject: [PATCH 11/11] list_lru: don't lock during add/del if unnecessary
Date: Wed, 31 Jul 2013 14:15:50 +1000
Message-Id: <1375244150-27296-12-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375244150-27296-1-git-send-email-david@fromorbit.com>
References: <1375244150-27296-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We only add an item to the LRU is it is empty, and we only remove
them if they are on the LRU. We can check these conditions without
holding the node lock and avoid grabbing the lock if they evaluate
as not needing a list operation.

We can do this without concern, because we already have the
situation that two concurrent callers to list_lru_add/del() for the
same object will race on the node lock and so the result of the
concurrent operations on the same object has always been always
undefined.

We still do the check once we have the lock, so even if we are
racing and decide we need the node lock to do the operation, then
the behaviour under the lock will be unchanged.

This significantly reduces the per-node lock traffic on workloads
where we aren't lazy about adding and removing objects from the LRU
lists.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 mm/list_lru.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index 9aadb6c..5207ae2 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -15,6 +15,9 @@ bool list_lru_add(struct list_lru *lru, struct list_head *item)
 	int nid = page_to_nid(virt_to_page(item));
 	struct list_lru_node *nlru = &lru->node[nid];
 
+	if (!list_empty(item))
+		return false;
+
 	spin_lock(&nlru->lock);
 	WARN_ON_ONCE(nlru->nr_items < 0);
 	if (list_empty(item)) {
@@ -34,6 +37,9 @@ bool list_lru_del(struct list_lru *lru, struct list_head *item)
 	int nid = page_to_nid(virt_to_page(item));
 	struct list_lru_node *nlru = &lru->node[nid];
 
+	if (list_empty(item))
+		return false;
+
 	spin_lock(&nlru->lock);
 	if (!list_empty(item)) {
 		list_del_init(item);
-- 
1.8.3.2


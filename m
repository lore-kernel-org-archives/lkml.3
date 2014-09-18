Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636AbaIROtu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 10:49:50 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:60463 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888AbaIROtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 10:49:46 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Michel Lespinasse <walken@google.com>
Subject: [PATCH 2/2] drbd: use RB_DECLARE_CALLBACKS() to define augment callbacks
Date: Thu, 18 Sep 2014 16:49:42 +0200
Message-Id: <1411051782-23375-3-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411051782-23375-1-git-send-email-philipp.reisner@linbit.com>
References: <1411051782-23375-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The original code are the same as RB_DECLARE_CALLBACKS().

CC: Michel Lespinasse <walken@google.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_interval.c | 36 ++----------------------------------
 1 file changed, 2 insertions(+), 34 deletions(-)

diff --git a/drivers/block/drbd/drbd_interval.c b/drivers/block/drbd/drbd_interval.c
index 04a14e0..51b25ad 100644
--- a/drivers/block/drbd/drbd_interval.c
+++ b/drivers/block/drbd/drbd_interval.c
@@ -37,40 +37,8 @@ compute_subtree_last(struct drbd_interval *node)
 	return max;
 }
 
-static void augment_propagate(struct rb_node *rb, struct rb_node *stop)
-{
-	while (rb != stop) {
-		struct drbd_interval *node = rb_entry(rb, struct drbd_interval, rb);
-		sector_t subtree_last = compute_subtree_last(node);
-		if (node->end == subtree_last)
-			break;
-		node->end = subtree_last;
-		rb = rb_parent(&node->rb);
-	}
-}
-
-static void augment_copy(struct rb_node *rb_old, struct rb_node *rb_new)
-{
-	struct drbd_interval *old = rb_entry(rb_old, struct drbd_interval, rb);
-	struct drbd_interval *new = rb_entry(rb_new, struct drbd_interval, rb);
-
-	new->end = old->end;
-}
-
-static void augment_rotate(struct rb_node *rb_old, struct rb_node *rb_new)
-{
-	struct drbd_interval *old = rb_entry(rb_old, struct drbd_interval, rb);
-	struct drbd_interval *new = rb_entry(rb_new, struct drbd_interval, rb);
-
-	new->end = old->end;
-	old->end = compute_subtree_last(old);
-}
-
-static const struct rb_augment_callbacks augment_callbacks = {
-	augment_propagate,
-	augment_copy,
-	augment_rotate,
-};
+RB_DECLARE_CALLBACKS(static, augment_callbacks, struct drbd_interval, rb,
+		     sector_t, end, compute_subtree_last);
 
 /**
  * drbd_insert_interval  -  insert a new interval into a tree
-- 
1.9.1


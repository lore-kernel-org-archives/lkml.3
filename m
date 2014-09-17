Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbaIQC04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 22:26:56 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:20734 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755229AbaIQC0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 22:26:55 -0400
X-IronPort-AV: E=Sophos;i="5.04,537,1406563200"; 
   d="scan'208";a="36055904"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Michel Lespinasse <walken@google.com>,
        Lars Ellenberg <drbd-dev@lists.linbit.com>,
        <drbd-user@lists.linbit.com>
Subject: [PATCH] drbd: use RB_DECLARE_CALLBACKS() to define augment callbacks
Date: Wed, 17 Sep 2014 10:25:35 +0800
Message-ID: <1410920735-5767-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original code are the same as RB_DECLARE_CALLBACKS().

CC: Michel Lespinasse <walken@google.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 drivers/block/drbd/drbd_interval.c |   36 ++----------------------------------
 1 files changed, 2 insertions(+), 34 deletions(-)

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
1.7.4.4


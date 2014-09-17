Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbaIQC0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 22:26:16 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:55286 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753985AbaIQC0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 22:26:14 -0400
X-IronPort-AV: E=Sophos;i="5.04,537,1406563200"; 
   d="scan'208";a="36055900"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Michel Lespinasse <walken@google.com>,
        Lars Ellenberg <drbd-dev@lists.linbit.com>,
        <drbd-user@lists.linbit.com>
Subject: [PATCH bug-fix] drbd: compute the end before rb_insert_augmented()
Date: Wed, 17 Sep 2014 10:25:33 +0800
Message-ID: <1410920735-5767-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

986836503e49 ("Merge branch 'drbd-8.4_ed6' into for-3.8-drivers-drbd-8.4_ed6")
changes rb_augment_insert() to new augment API.  But the new API
rb_insert_augmented() requires the tree is augmennted before called.

Quote from Documentation/rbtree.txt:
"""
  On insertion, the user must update the augmented information on the path
  leading to the inserted node, then call rb_link_node() as usual and
  rb_augment_inserted() instead of the usual rb_insert_color() call.
  If rb_augment_inserted() rebalances the rbtree, it will callback into
  a user provided function to update the augmented information on the
  affected subtrees.
"""

So we add the augment-code to drbd_insert_interval() when it travels
the tree up to down before rb_insert_augmented().  See the example in
include/linux/interval_tree_generic.h or Documentation/rbtree.txt.

drbd_insert_interval() may cancel the insertion when traveling,
in this case, the just added augment-code does nothing before cancel
since the @this node is already in the subtrees in this case.

CC: Michel Lespinasse <walken@google.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 drivers/block/drbd/drbd_interval.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/block/drbd/drbd_interval.c b/drivers/block/drbd/drbd_interval.c
index 89c497c..04a14e0 100644
--- a/drivers/block/drbd/drbd_interval.c
+++ b/drivers/block/drbd/drbd_interval.c
@@ -79,6 +79,7 @@ bool
 drbd_insert_interval(struct rb_root *root, struct drbd_interval *this)
 {
 	struct rb_node **new = &root->rb_node, *parent = NULL;
+	sector_t this_end = this->sector + (this->size >> 9);
 
 	BUG_ON(!IS_ALIGNED(this->size, 512));
 
@@ -87,6 +88,8 @@ drbd_insert_interval(struct rb_root *root, struct drbd_interval *this)
 			rb_entry(*new, struct drbd_interval, rb);
 
 		parent = *new;
+		if (here->end < this_end)
+			here->end = this_end;
 		if (this->sector < here->sector)
 			new = &(*new)->rb_left;
 		else if (this->sector > here->sector)
@@ -99,6 +102,7 @@ drbd_insert_interval(struct rb_root *root, struct drbd_interval *this)
 			return false;
 	}
 
+	this->end = this_end;
 	rb_link_node(&this->rb, parent, new);
 	rb_insert_augmented(&this->rb, root, &augment_callbacks);
 	return true;
-- 
1.7.4.4


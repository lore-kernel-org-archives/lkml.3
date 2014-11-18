Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933527AbaKRO72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:59:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57203 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932134AbaKROJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:48 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Michel Lespinasse <walken@google.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Jens Axboe <axboe@fb.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 088/206] drbd: compute the end before rb_insert_augmented()
Date: Tue, 18 Nov 2014 15:07:23 +0100
Message-Id: <5fa353fffaae9794ac109d748e2c6a9808abbba0.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 82cfb90bc99d7b7e0ec62d0505b9d4f06805d5db upstream.

Commit 98683650 "Merge branch 'drbd-8.4_ed6' into
for-3.8-drivers-drbd-8.4_ed6" switches to the new augment API, but the
new API requires that the tree is augmented before rb_insert_augmented()
is called, which is missing.

So we add the augment-code to drbd_insert_interval() when it travels the
tree up to down before rb_insert_augmented().  See the example in
include/linux/interval_tree_generic.h or Documentation/rbtree.txt.

drbd_insert_interval() may cancel the insertion when traveling, in this
case, the just added augment-code does nothing before cancel since the
@this node is already in the subtrees in this case.

CC: Michel Lespinasse <walken@google.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/block/drbd/drbd_interval.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/block/drbd/drbd_interval.c b/drivers/block/drbd/drbd_interval.c
index 89c497c630b4..04a14e0f8878 100644
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
2.1.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947160Ab3BHVDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 16:03:40 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:51511 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947057Ab3BHVDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 16:03:39 -0500
Date: Fri, 8 Feb 2013 13:03:34 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 5/6] idr: add idr_layer->prefix
Message-ID: <20130208210334.GE26660@mtj.dyndns.org>
References: <20130208210050.GA26660@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130208210050.GA26660@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a field which carries the prefix of ID the idr_layer covers.  This
will be used to implement lookup hint.

This patch doesn't make use of the new field and doesn't introduce any
behavior difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/idr.h |    1 +
 lib/idr.c           |   13 +++++++++++++
 2 files changed, 14 insertions(+)

--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -28,6 +28,7 @@
 #define IDR_MASK ((1 << IDR_BITS)-1)
 
 struct idr_layer {
+	int			prefix;	/* the ID prefix of this idr_layer */
 	DECLARE_BITMAP(bitmap, IDR_SIZE); /* A zero bit means "space here" */
 	struct idr_layer __rcu	*ary[1<<IDR_BITS];
 	int			count;	/* When zero, we can release it */
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -60,6 +60,16 @@ static int idr_max(int layers)
 	return (1 << bits) - 1;
 }
 
+/*
+ * Prefix mask for an idr_layer at @layer.  For layer 0, the prefix mask is
+ * all bits except for the lower IDR_BITS.  For layer 1, 2 * IDR_BITS, and
+ * so on.
+ */
+static int idr_layer_prefix_mask(int layer)
+{
+	return ~idr_max(layer + 1);
+}
+
 static struct idr_layer *get_from_free_list(struct idr *idp)
 {
 	struct idr_layer *p;
@@ -272,6 +282,7 @@ static int sub_alloc(struct idr *idp, in
 			if (!new)
 				return -ENOMEM;
 			new->layer = l-1;
+			new->prefix = id & idr_layer_prefix_mask(new->layer);
 			rcu_assign_pointer(p->ary[m], new);
 			p->count++;
 		}
@@ -313,6 +324,7 @@ build_up:
 			 * upwards.
 			 */
 			p->layer++;
+			WARN_ON_ONCE(p->prefix);
 			continue;
 		}
 		if (!(new = idr_layer_alloc(gfp_mask, layer_idr))) {
@@ -334,6 +346,7 @@ build_up:
 		new->ary[0] = p;
 		new->count = 1;
 		new->layer = layers-1;
+		new->prefix = id & idr_layer_prefix_mask(new->layer);
 		if (bitmap_full(p->bitmap, IDR_SIZE))
 			__set_bit(0, new->bitmap);
 		p = new;

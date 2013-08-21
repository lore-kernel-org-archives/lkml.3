Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab3HUOVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:21:33 -0400
Received: from protonic.xs4all.nl ([213.84.116.84]:18708 "EHLO
	protonic.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab3HUOVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:21:32 -0400
Date: Wed, 21 Aug 2013 16:21:43 +0200
From: David Jander <david.jander@protonic.nl>
To: Mark Brown <broonie@kernel.org>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: regmap: bugfix in regcache-rbtree.c
Message-ID: <20130821162143.42ca91de@archvile>
In-Reply-To: <20130821133200.GB26118@sirena.org.uk>
References: <1377090155-3443-1-git-send-email-david@protonic.nl>
	<20130821133200.GB26118@sirena.org.uk>
Organization: Protonic Holland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Aug 2013 14:32:00 +0100
Mark Brown <broonie@kernel.org> wrote:

> On Wed, Aug 21, 2013 at 03:02:35PM +0200, David Jander wrote:
> 
> > rbnode register ranges can overlap, which is not a problem as long as
> 
> They can?  They aren't supposed to and I'd expect this to cause problems
> with the cache sync code too.  How does this happen?

Well, I am not an expert at rb-trees nor do I understand all of regmap, but I
think I can explain how it can happen.
The fact that it _does_ happen can be seen in my previous e-mail. Here's what
I get from mainline SGTL5000 driver:

# cat /sys/kernel/debug/regmap/1-000a/rbtree 
2-19 (24)
4-1b (24)
20-37 (24)
22-39 (24)
3c-53 (24)
100-117 (24)
104-11c (25)
11e-135 (24)
8 nodes, 193 registers, average 24 registers, used 626 bytes

Tracing all the calls to regcache-rbtree, I can see that the node "22-39 (24)"
is created first, and later on, the driver tries to write to register 20 for
the first time (the node 22-39 is still pointed to by
rbtree_ctx->cached_rbnode).
At that point the following code at line 358 is hit:

	rbnode = regcache_rbtree_lookup(map, reg);

(rbnode will be NULL, since the register isn't mapped to the cache yet)

	if (rbnode) {
		reg_tmp = (reg - rbnode->base_reg) / map->reg_stride;
		regcache_rbtree_set_register(map, rbnode, reg_tmp, value);
	} else {
		/* look for an adjacent register to the one we are about to add */

The following code will not find an adjacent register, becase map->reg_stride
is 1 and not 2 as it should be. This is due to a different unrelated bug in
sgtl5000.c which I will fix soon, but it doesn't matter for this case.

		for (node = rb_first(&rbtree_ctx->root); node;
		     node = rb_next(node)) {
			rbnode_tmp = rb_entry(node, struct regcache_rbtree_node,
					      node);
			for (i = 0; i < rbnode_tmp->blklen; i++) {
				reg_tmp = rbnode_tmp->base_reg +
						(i * map->reg_stride);
				if (abs(reg_tmp - reg) != map->reg_stride)
					continue;
				/* decide where in the block to place our register */
				if (reg_tmp + map->reg_stride == reg)
					pos = i + 1;
				else
					pos = i;
				ret = regcache_rbtree_insert_to_block(map,
								      rbnode_tmp,
								      pos, reg,
								      value);
				if (ret)
					return ret;
				return 0;
			}
		}

So we didn't find an adjacent register, we will create a new node.

		/* We did not manage to find a place to insert it in
		 * an existing block so create a new rbnode.
		 */
		rbnode = regcache_rbtree_node_alloc(map, reg);
		if (!rbnode)
			return -ENOMEM;
		regcache_rbtree_set_register(map, rbnode,
					     reg - rbnode->base_reg, value);
		regcache_rbtree_insert(map, &rbtree_ctx->root, rbnode);
	}

At this point the rbnode "20-37 (24)" is created.
I don't (yet) fully understand the code in regcache_rbtree_node_alloc(), but
it seems to ignore the fact that this new node will start at only slightly
lower base register than another existing rbnode.

I hope you can explain to me how regcache_rbtree_node_alloc() is supposed to
work, because I start to think that something in there is broken...
Specially the code at line 323 strikes me:

	if (!rbnode->blklen) {
		rbnode->blklen = sizeof(*rbnode);
		rbnode->base_reg = reg;
	}

Best regards,

-- 
David Jander
Protonic Holland.

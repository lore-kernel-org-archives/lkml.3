Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab3HUNlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 09:41:32 -0400
Received: from protonic.xs4all.nl ([213.84.116.84]:18002 "EHLO
	protonic.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab3HUNlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 09:41:31 -0400
X-Greylist: delayed 1638 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Aug 2013 09:41:30 EDT
Date: Wed, 21 Aug 2013 15:14:23 +0200
From: David Jander <david.jander@protonic.nl>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: regmap: bugfix in regcache-rbtree.c
Message-ID: <20130821151423.70c38fb3@archvile>
In-Reply-To: <1377090155-3443-1-git-send-email-david@protonic.nl>
References: <1377090155-3443-1-git-send-email-david@protonic.nl>
Organization: Protonic Holland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Dimitris,

On Wed, 21 Aug 2013 15:02:35 +0200
David Jander <david@protonic.nl> wrote:

> The functionality of rbtree_ctx->cached_rbnode is broken. Remove it to
> avoid hitting the wrong rbnode when locating a register.
> rbnode register ranges can overlap, which is not a problem as long as
> every lookup for a register returns the same rbnode. Therefor we need
> to start searching from the top of the rb-tree _always_.

Some clarification to this patch. I want to be careful in "attacking" such a
core function that is used in quite a lot of places around the kernel, and it
strikes me that this has been gone unnoticed so far.

Here's the explanation:

1. If a driver initializes a regmap with a RB-tree cache, and starts writing to
registers in some arbitrary order, you might get overlapping rbnodes:
Suppose I have this rb-tree (a real case I happen to have):

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

2. Suppose you just added node 20-37 by writing to previously uncached register
20. Now this node would be in rbtree_ctx->cached_rbnode, and would get search
first by the next access. Let's say that next access is register 30, then
rbtree_ctx->cached_rbnode would be a hit on the node 20-37.
Otherwise the hit would be in node 22-39 which is higher up the tree and
should be searched first. Two different possible hits for register 30 with
different contents! That cannot be right, right?

Therefor I dare to declare the rbtree_ctx->cached_rbnode functionality broken,
and removed it.

I stumbled upon this problem while debugging a non-functioning audio codec
(SGTL5000). This patch fixes the problem. Using a flat-cache in sgtl5000.c also
fixes it, so at least if I didn't fix this bug the right way, there sure is a
bug that needs to be fixed in regcache-rbtree.c.

Best regards,

-- 
David Jander
Protonic Holland.

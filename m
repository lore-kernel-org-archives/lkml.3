Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab3HUPIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 11:08:36 -0400
Received: from protonic.xs4all.nl ([213.84.116.84]:19672 "EHLO
	protonic.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab3HUPIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 11:08:35 -0400
Date: Wed, 21 Aug 2013 17:08:46 +0200
From: David Jander <david.jander@protonic.nl>
To: Mark Brown <broonie@kernel.org>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: regmap: bugfix in regcache-rbtree.c
Message-ID: <20130821170846.66b5b1d5@archvile>
In-Reply-To: <20130821144442.GD26118@sirena.org.uk>
References: <1377090155-3443-1-git-send-email-david@protonic.nl>
	<20130821133200.GB26118@sirena.org.uk>
	<20130821162143.42ca91de@archvile>
	<20130821144442.GD26118@sirena.org.uk>
Organization: Protonic Holland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Aug 2013 15:44:42 +0100
Mark Brown <broonie@kernel.org> wrote:

> On Wed, Aug 21, 2013 at 04:21:43PM +0200, David Jander wrote:
> 
> > I hope you can explain to me how regcache_rbtree_node_alloc() is supposed
> > to work, because I start to think that something in there is broken...
> > Specially the code at line 323 strikes me:
> 
> > 	if (!rbnode->blklen) {
> > 		rbnode->blklen = sizeof(*rbnode);
> > 		rbnode->base_reg = reg;
> > 	}
> 
> That's intended to avoid creating lots of tiny blocks.  I think this bit
> is actually OK but what should be happening here is that the collision
> gets noticed when we try to insert the block and we at least constrain
> the size of the new block if not merge it with the old one immediately
> after (which is obvioulsy better).
> 
> As a bug fix setting blklen to be a single register ought to avoid
> triggering problems though it will be less efficient - does that work
> for you?  Doing the merging is going to be too much for a fix.

Yes! This does indeed help, but it makes the other bug in sgtl5000.c much more
evident:

# cat /sys/kernel/debug/regmap/1-000a/rbtree 
2-2 (1)
4-4 (1)
6-6 (1)
a-a (1)
10-10 (1)
14-14 (1)
20-20 (1)
22-22 (1)
24-24 (1)
26-26 (1)
28-28 (1)
2a-2a (1)
2c-2c (1)
2e-2e (1)
30-30 (1)
32-32 (1)
34-34 (1)
3c-3c (1)
100-100 (1)
104-104 (1)
106-106 (1)
10a-10a (1)
116-116 (1)
118-118 (1)
11a-11a (1)
11c-11c (1)
11e-11e (1)
120-120 (1)
124-124 (1)
126-126 (1)
128-128 (1)
12a-12a (1)

Now all rbnodes are 1 register long, because the sgtl5000 driver does not set
regmap_config->reg_stride correctly (should be 2).

If I also correct that, I get:

# cat /sys/kernel/debug/regmap/1-000a/rbtree 
2-6 (3)
a-a (1)
10-10 (1)
14-14 (1)
20-2a (6)
2c-34 (5)
3c-3c (1)
100-100 (1)
104-106 (2)
10a-10a (1)
116-120 (6)
124-12a (4)
12 nodes, 32 registers, average 2 registers, used 400 bytes

This looks better. Not ideal still, but at least the codec works!

Should I re-send a patch with this fix?

Best Regards,

-- 
David Jander
Protonic Holland.

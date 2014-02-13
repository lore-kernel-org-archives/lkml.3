Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbaBMQ7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 11:59:19 -0500
Received: from top.free-electrons.com ([176.31.233.9]:51692 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751742AbaBMQ7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 11:59:17 -0500
Date: Thu, 13 Feb 2014 17:59:14 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/13] pinctrl: mvebu: restructure resource
 allocation
Message-ID: <20140213175914.205803a6@skate>
In-Reply-To: <52FCF59E.3090100@gmail.com>
References: <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1392220776-30851-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<20140213172620.76e760ba@skate>
	<52FCF59E.3090100@gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sebastian Hesselbarth,

On Thu, 13 Feb 2014 17:41:02 +0100, Sebastian Hesselbarth wrote:

> > Thanks again for working on this! I have boot tested this successfully
> > on an Armada XP platform, and it seems to behave normally, the debugfs
> > pinctrl contents make sense.
> 
> I guess this is a Tested-by ?

Yes. My tests were admittedly fairly light, but I believe good enough :)

> > I am not sure what you mean here in terms of the ordering for the
> > patches. I'm attaching several patches, and the first three patches
> > adapt your patch series to also cover 375 and 38x, assuming the pinctrl
> > support for 375 and 38x is merged before your patch series.
> 
> Right. If 375/38x pinctrl goes in first (what I expect), I'd have to add
> corresponding patches. You already sent them, I'll pick them up.

Ok, cool. Hopefully we can sort out the merging of those two patch
series for 3.15 with Linus Walleij.

> > I must say I dislike quite a bit this unnamed mpp controls mechanism.
> > Why isn't the name statically defined in the source code by the
> > MPP_MODE macro, which already takes as first argument the pin number?
> 
> Honestly, the unnamed mpp control thing is a bit odd. But if you tell
> me how to create ~60 statically defined one pin groups out of a
> single-line macro, we can change that easily.
> 
> Back when that unnamed mpp control thing was invented, I must have been
> to lazy to write e.g.
> 
> MPP_FUNC_CTRL(0, 0, "mpp0", armada_xp_mpp_ctrl),
> MPP_FUNC_CTRL(1, 1, "mpp1", armada_xp_mpp_ctrl),
> MPP_FUNC_CTRL(2, 2, "mpp2", armada_xp_mpp_ctrl),
> ...
> MPP_FUNC_CTRL(66, 66, "mpp66", armada_xp_mpp_ctrl),
> 
> instead of
> 
> MPP_FUNC_CTRL(0, 66, NULL, armada_xp_mpp_ctrl),
> 
> and generate the 66 names dynamically.

Right. But what I meant is that we already have a place where we have
one macro call for each pin: when defining the MPP modes. So I was
thinking of simplifying the whole stuff by "merging" the notion of MPP
control with the notion of MPP mode. This way, when you do:

	MPP_MODE(0,
		   MPP_FUNCTION(...),
		   MPP_FUNCTION(...)),
	MPP_MODE(1,
		   MPP_FUNCTION(...),
		   MPP_FUNCTION(...)),
	MPP_MODE(2,
		   MPP_FUNCTION(...),
		   MPP_FUNCTION(...)),
[...]
	MPP_MODE(65,
		   MPP_FUNCTION(...),
		   MPP_FUNCTION(...)),

You can take this opportunity to generate:

	{ "mpp0", ... },
	{ "mpp1", ... },
	{ "mpp2", ... },
	...
	{ "mpp65", ... },

> > This is definitely good, but I'm wondering why the core cannot provide
> > helper functions for the generic case where we have 4 bits per pin in
> > contiguous registers. This would avoid duplicating the helper function
> > six times (you have four in your patch series, and we'll need two more
> > for A375 and A38x).
> 
> I thought about it too, but we would need a soc specific callback
> anyway as you'll have to pass the base address somehow (and that is now
> known by soc specific stub only). My quick rule of thumb was that the
> amount of code replication would be almost the same.

In pinctrl-mvebu.h, we could have:

static inline int default_mpp_ctrl_get(void __iomem *base, unsigned int pid, unsigned long *config)
{
        unsigned off = (pid / MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
        unsigned shift = (pid % MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;

        *config = (readl(base + off) >> shift) & MVEBU_MPP_MASK;

        return 0;
}

static inline int default_mpp_ctrl_set(void __iomem *base, unsigned int pid, unsigned long config)
{
        unsigned off = (pid / MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
        unsigned shift = (pid % MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
        unsigned long reg;

        reg = readl(base + off) & ~(MVEBU_MPP_MASK << shift);
        writel(reg | (config << shift), base + off);

        return 0;
}

which would slightly reduce the per-SoC code to:

static int armada_370_mpp_ctrl_get(unsigned pid, unsigned long *config)
{
	return default_mpp_ctrl_get(mpp_base, pid, config);
}

static int armada_370_mpp_ctrl_set(unsigned pid, unsigned long config)
{
	return default_mpp_ctrl_set(mpp_base, pid, config);
}

but we admittedly cannot completely remove the per-SoC function, since
the mpp_base is now only known to each per-SoC driver.

> > Feel free to squash these patches into the appropriate patches.
> 
> Yep, thanks for these! I'll squash them in and send an updated v4 as
> soon as the discussion here stalls.

Thanks!

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

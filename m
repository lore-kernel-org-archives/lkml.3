Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbaBQSTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 13:19:12 -0500
Received: from top.free-electrons.com ([176.31.233.9]:40608 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753308AbaBQSTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 13:19:10 -0500
Date: Mon, 17 Feb 2014 15:19:03 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Jason Cooper <jason@lakedaemon.net>,
        Emilio =?utf-8?B?TMOzcGV6?= <emilio@elopez.com.ar>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Mike Turquette <mturquette@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/4] clk: mvebu: fix clk init order
Message-ID: <20140217181902.GG2765@localhost>
References: <1390673950-4521-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20140205183457.GW8533@titan.lakedaemon.net>
 <20140217141336.GA2765@localhost>
 <53021BD2.3090301@free-electrons.com>
 <20140217152147.GC2765@localhost>
 <53022AA9.8090606@free-electrons.com>
 <20140217154421.GD2765@localhost>
 <530231C5.8090905@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <530231C5.8090905@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 04:59:01PM +0100, Gregory CLEMENT wrote:
[..]
> > 
> > Right. If you think it adds a regression, then that's a perfectly valid reasons
> > for nacking.
> > 
> > However, I'd like to double-check we have such a regression. I guess you're
> > talking about the "tclk" name being hardcoded. IMHO, it's hardcoded in the
> > driver in the first place:
> > 
> > void __init mvebu_coreclk_setup(struct device_node *np,
> > 				const struct coreclk_soc_desc *desc)
> > {
> > 	const char *tclk_name = "tclk";
> > [..] 
> 
> 
> Here it is just about giving a name to a clock. As in the device tree
> we only refer to the clock by index, the name don't matter.
> 

Unless I'm really confused about what's the problem here, the *name* is
*all* that matters.

We're having a clock *registration* order issue (which is different from clock
enable). Let me try to explain the issue, in case it's still not clear.

I'll stick to the current specific problem but it can apply to any other
pair of parent/child.

Some of the mvebu clocks are registered as part of the "core" clock
group, modeled by the "marvell,armada-370-core-clock" compatible node.

Another group of mvebu clocks are registered as part of the "gating"
clock group, modeled by the "marvell,armada-370-gating-clock" compatible
node.

By default, all the gating clocks are child of the first registered core
clock. This clock is named "tclk" by default, and this name can be overloaded
in the devicetree.

So far, so good, right?

The issue we're trying to fix, arises from the mvebu_clk_gating_setup()
trying to get the name of this "tclk", as a registered clock.

In other words, the current code needs the tclk to be registered, for it
will ask his name like this:

	const char *default_parent = NULL;

	clk = of_clk_get(np, 0);
	if (!IS_ERR(clk)) {
		default_parent = __clk_get_name(clk);
		clk_put(clk);
	}

Once it gets the name, all goes smoothly. Notice how the clock is obtained
for the sole purpose of getting the name of it, which shows clearly it's the
*name* that matters.

The ordering issue happens when the gating clock group is probed, before
the core clock group. In that case, it's not possible to get the
"&coreclk 0" (which is wrongly assumed to be registered), and so it's
not possible to get the name.

So the root of the problem is that snippet above, which adds a
completely unneeded registration order requirement. Instead, we should
be looking for the names: we can hardcode the name or fetch it from the
devicetree (Emilio has posted patches for both).

I really don't see why we're not fixing this, instead of adding yet
another layer of complexity to the problem.
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com

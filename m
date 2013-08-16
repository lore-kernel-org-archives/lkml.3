Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab3HPBbW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 21:31:22 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34652 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab3HPBbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 21:31:20 -0400
Date: Thu, 15 Aug 2013 18:31:19 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v1 03/14] clk: Add of_clk_match() for device drivers
Message-ID: <20130816013118.GC27999@codeaurora.org>
References: <1374713022-6049-1-git-send-email-sboyd@codeaurora.org>
 <1374713022-6049-4-git-send-email-sboyd@codeaurora.org>
 <20130812202347.5348.76490@quantum>
 <20130813054839.GF14845@codeaurora.org>
 <20130815050226.4443.39100@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130815050226.4443.39100@quantum>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14, Mike Turquette wrote:
> Quoting Stephen Boyd (2013-08-12 22:48:39)
> > On 08/12, Mike Turquette wrote:
> > > Quoting Stephen Boyd (2013-07-24 17:43:31)
> > > > In similar fashion as of_regulator_match() add an of_clk_match()
> > > > function that finds an initializes clock init_data structs from
> > > > devicetree. Drivers should use this API to find clocks that their
> > > > device is providing and then iterate over their match table
> > > > registering the clocks with the init data parsed.
> > > > 
> > > > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> > > 
> > > Stephen,
> > > 
> > > In general I like this approach. Writing real device drivers for clock
> > > controllers is The Right Way and of_clk_match helps.
> > > 
> > > Am I reading this correctly that the base register addresses/offsets for
> > > the clock nodes still come from C files? For example I still see
> > > pll8_desc defining reg stuff in drivers/clk/msm/gcc-8960.c.
> > 
> > I think we may be able to put the registers in DT but I don't
> > know why we need to do that if we're already matching up nodes
> > with C structs.
> 
> The reason to do so is to remove the per-clock data from the kernel
> sources entirely. Separating logic and data.

Ok.

> 
> > It also made me want to introduce devm_of_iomap()
> > which just seemed wrong (if you have a dev struct why can't you
> > use devm_ioremap()).
> > 
[snip]
> > 
> > This is great for making the kernel DT-data-driven, but I
> > couldn't find any other driver that was describing register level
> > details in DT.
> 
> Yeah, this sucks. Building a binding from a C struct is a bad idea. How
> many permutations are there? Hopefully some clocks use the same bit
> shifts and have reliable register offsets, with the only difference
> being base address. If this is the case then a compatible string could
> be done for each permutation assuming that number is low and manageable.

In the multimedia controller almost every clock has a different
register layout. Making a compatible string for each clock is
pretty much what I've done if you consider that I match up the
name of the node to a struct instead of matching a compatible
string to a struct. In the global controller it's more sane,
following a single register layout per compatible string.
Remember though, all the single bit clocks (gates or what we call
branches) have a completely random location for their on/off bit
and status bit.

> 
> > 
> > The good news is that newer clock controllers follow a standard
> > and so we can specify one or two register properties and the type
> > of clock and we're pretty much done. The software interface
> > hasn't been randomized like on earlier controllers and bits
> > within registers are always the same.
> 
> This does not suck. Just for the sake of argument let's say that you
> only had to deal with this new and improved register layout and not the
> old (current) stuff. Do you still see a reason to match DT data up with
> C struct data objects in the kernel?

I would still need to match up frequency tables unless I figure
out a way to put that in DT too.

> 
> > We still have some clocks
> > that are just on/off switches though and so we'll have to put
> > register level details like which bit turns that clock on in DT
> > (which I believe is not preferred/allowed?). I don't see any way
> > to avoid that if we want it to be entirely DT driven.
> 
> This is what I'm doing for the generic clock bindings. No one has
> screamed over that stuff so I guess rules were meant to be broken.
> 
 

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

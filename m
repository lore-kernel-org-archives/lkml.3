Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbaAJHFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 02:05:24 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:60902 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbaAJHFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 02:05:19 -0500
Date: Thu, 9 Jan 2014 23:05:17 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v4 02/15] clk: Allow drivers to pass in a regmap
Message-ID: <20140110070517.GE14405@codeaurora.org>
References: <1387847559-18330-1-git-send-email-sboyd@codeaurora.org>
 <1387847559-18330-3-git-send-email-sboyd@codeaurora.org>
 <20140109015158.7168.60274@quantum>
 <52CE055C.5030103@codeaurora.org>
 <20140110054424.7168.46289@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140110054424.7168.46289@quantum>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09, Mike Turquette wrote:
> If we're going to use these wrappers, why make it regmap specific? The
> struct clk_desc patches[1][2] can achieve this, but in a more generic
> way.
> 

I think you're suggesting a way to avoid adding a
clk_register_regmap() function? But won't we need to write the
same code:

        if (dev && dev_get_regmap(dev, NULL))
                [clk_type]->regmap = dev_get_regmap(dev, NULL);
        else if (dev && dev->parent)
                [clk_type]->regmap = dev_get_regmap(dev->parent, NULL);

everytime we want to assign the regmap pointer to a different clock type?
A macro might work for this little snippet, but it wouldn't have
any type safety.

> > 
> > 
> > 2) Interfaces: Add a void *data in struct clk_hw that can point to
> > whatever I want and still have the same clk_regmap_register() and
> > devm_clk_regmap_register()
> > 
> > Example:
> > 
> > struct clk_hw {
> >         struct clk *clk;
> >         const struct clk_init_data *init;
> >         void *data;
> > };
> > 
> > struct clk_regmap {
> >         struct regmap *regmap;
> >         unsigned int enable_reg;
> >         unsigned int enable_mask;
> >         bool enable_is_inverted;
> > };
> > 
> > struct clk_branch {
> >         u32     hwcg_reg;
> >         u32     halt_reg;
> >         u8      hwcg_bit;
> >         u8      halt_bit;
> >         u8      halt_check;
> > 
> >         struct clk_hw;
> > };
> > 
> > static struct clk_branch gsbi1_uart_clk = {
> >         .halt_reg = 0x2fcc,
> >         .halt_bit = 10,
> >         .hw = {
> >                 .data = &(struct clk_regmap){
> >                         .enable_reg = 0x29d4,
> >                         .enable_mask = BIT(9),
> >                  };
> >                 .init = &(struct clk_init_data){
> >                         .name = "gsbi1_uart_clk",
> >                         .parent_names = (const char *[]){
> >                                 "gsbi1_uart_src",
> >                         },
> >                         .num_parents = 1,
> >                         .ops = &clk_branch_ops,
> >                         .flags = CLK_SET_RATE_PARENT,
> >                 },
> >         },
> > };
> > 
> > I guess option 2 is less likely given your comment about clk_hw being
> > nothing more than a traversal mechanism.
> 
> Instead of private data, how about a .register() callback function that
> can point to anything you like? The clk_desc patches implement this and
> it would suffice for registering regmap ops or anything else, without
> polluting struct clk_hw.
> 
> [1] http://www.spinics.net/lists/linux-omap/msg101822.html
> [2] http://www.spinics.net/lists/linux-omap/msg101698.html
> 
> So you could statically define gsbi1_uart_clk with:
> 
> static struct clk_branch_desc gsbi1_uart_clk_desc = {
> 	.halt_reg = 0x2fcc,
> 	.halt_bit = 10,
> 	.enable_reg = 0x29d4,
> 	.enable_mask = BIT(9),
> 	.desc = {
> 		.name = "gsbi1_uart_clk",
> 		.parent_names = (const char *[]){
> 			"gsbi1_uart_src",
> 		},
> 		.num_parents = 1,
> 		.ops = &clk_branch_ops,
> 		.flags = CLK_SET_RATE_PARENT,
> 	},
> };
> 
> And then register it with:
> 
> clk_register_desc(NULL, &gsbi1_uart_clk_desc.desc);
> 
> This is very analogous to the way that you use use &gsbi1_uart_clk.hw
> but it is more generic and also doesn't pollute clk_hw any further. I
> also think your static data is quite a bit prettier using this method.
> 
> Thoughts?

Is the plan to allocate a struct clk_branch at runtime and then
copy all the fields over one by one? I'm trying to avoid that
because it takes more time and more runtime memory. If I had to
go the descriptor route I would probably avoid copying any fields
and just point to the descriptor from struct clk_branch, i.e.

 struct clk_branch {
 	struct clk_branch_desc *desc;
	struct clk_hw;
 };

but that still seems wasteful to allocate a bunch of little
pointer wrappers when I could have just embedded the clk_hw
struct inside the clk_branch struct from the start.

It feels another key point is being missed though. The regmap
pointer and the enable_reg/enable_mask is embedded in clk_hw to
allow the same code to be used by different types of surrounding
structs. Each struct: clk_pll, clk_rcg, and clk_branch in this
series use the regmap interface to enable/disable the clock and
they can easily do so by passing something that's always
available from struct clk_hw (be it via a wrapper struct, private
data member, or addition of new fields to clk_hw). If the regmap
members move into each specific type of clock we can't just pass
a single pointer to the enable/disable regmap functions anymore.
This is the reason why I suggested a driver data pointer or
container struct so that everything regmap related is contained
within one type.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

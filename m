Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab3HCBG3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 21:06:29 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:44972 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab3HCBG1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 21:06:27 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Stephen Boyd <sboyd@codeaurora.org>, Tomasz Figa <tomasz.figa@gmail.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <20130725163656.GC29694@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org
References: <1374713022-6049-1-git-send-email-sboyd@codeaurora.org>
 <1374713022-6049-3-git-send-email-sboyd@codeaurora.org>
 <1714620.Z8J8zTxIRB@flatron> <20130725163656.GC29694@codeaurora.org>
Message-ID: <20130803010622.6450.37987@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH v1 02/14] clk: Add of_init_clk_data() to parse common clock
 bindings
Date: Fri, 02 Aug 2013 18:06:22 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Boyd (2013-07-25 09:36:56)
> On 07/25, Tomasz Figa wrote:
> > On Wednesday 24 of July 2013 17:43:30 Stephen Boyd wrote:
> > > Consolidate DT parsing for the common bits of a clock binding in
> > > one place to simplify clock drivers. This also has the added
> > > benefit of standardizing how the clock names used by the common
> > > clock framework are generated from the DT bindings. We always use
> > > the first clock-output-names string if it exists, otherwise we
> > > fall back to the node name.
> > > 
> > > To be slightly more efficient and make the caller's life easier,
> > > we introduce a shallow copy flag so that the clock core knows to
> > > just copy the pointers to the strings and not the string
> > > contents. Otherwise the callers of this function would have to
> > > free the strings allocated here which could be cumbersome.
> > > 
> > > Cc: Rob Herring <rob.herring@calxeda.com>
> > > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> > > ---
> > >  drivers/clk/clk.c            | 59
> > > +++++++++++++++++++++++++++++++++++++++++++-
> > > include/linux/clk-provider.h |  7 ++++++
> > >  2 files changed, 65 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> > > index 1ed9bdd..ea8e951b 100644
> > > --- a/drivers/clk/clk.c
> > > +++ b/drivers/clk/clk.c
> > > @@ -1809,6 +1809,10 @@ static int _clk_register(struct device *dev,
> > > struct clk_hw *hw, struct clk *clk) {
> > >     int i, ret;
> > > 
> > > +   hw->clk = clk;
> > > +   if (hw->init->flags & CLK_SHALLOW_COPY)
> > > +           return PTR_RET(__clk_register(dev, hw));
> > > +
> > >     clk->name = kstrdup(hw->init->name, GFP_KERNEL);
> > >     if (!clk->name) {
> > >             pr_err("%s: could not allocate clk->name\n", __func__);
> > > @@ -1819,7 +1823,6 @@ static int _clk_register(struct device *dev,
> > > struct clk_hw *hw, struct clk *clk) clk->hw = hw;
> > >     clk->flags = hw->init->flags;
> > >     clk->num_parents = hw->init->num_parents;
> > > -   hw->clk = clk;
> > > 
> > >     /* allocate local copy in case parent_names is __initdata */
> > >     clk->parent_names = kzalloc((sizeof(char*) * clk->num_parents),
> > > @@ -2232,4 +2235,58 @@ void __init of_clk_init(const struct of_device_id
> > > *matches) clk_init_cb(np);
> > >     }
> > >  }
> > > +
> > > +/**
> > > + * of_init_clk_data() - Initialize a clk_init_data struct from a DT
> > > node + * @np: node to initialize struct from
> > > + * @init: struct to initialize
> > > + *
> > > + * Populates the clk_init_data struct by parsing the device node for
> > > + * properties matching the common clock binding. Returns 0 on success
> > > + * and a negative error code on failure.
> > > + */
> > > +int of_init_clk_data(struct device_node *np, struct clk_init_data
> > > *init) +{
> > > +   struct of_phandle_args s;
> > > +   const char **names = NULL, **p;
> > > +   const char *name;
> > > +   int i;
> > > +
> > > +   if (of_property_read_string(np, "clock-output-names", &name) < 0)
> > > +           name = np->name;
> > > +   init->name = kstrdup(name, GFP_KERNEL);
> > > +   if (!init->name)
> > > +           return -ENOMEM;
> > > +
> > > +   for (i = 0; of_parse_phandle_with_args(np, "clocks", "#clock-
> > cells",
> > > +                           i, &s) == 0; i++) {
> > > +           p = krealloc(names, sizeof(*names) * (i + 1), GFP_KERNEL);
> > > +           if (!p)
> > > +                   goto err;
> > 
> > What about using of_count_phandle_with_args() first to get the parent 
> > count?
> 
> Sure that simplifies things.

I made a simple wrapper around of_count_phandle_with_args for the basic
DT bindings series:

http://lists.infradead.org/pipermail/linux-arm-kernel/2013-June/178836.html

I still need to make a couple of changes to that before I merge it. If
you want to base on top of the v3 version then you can use it, otherwise
just use of_count_phandle_with_args.

Regards,
Mike

> 
> > 
> > > +           names = p;
> > > +
> > > +           if (of_property_read_string(s.np, "clock-output-names",
> > > +                                   &name) < 0)
> > > +                   name = s.np->name;
> > 
> > You should be able to use of_clk_get_parent_name() here, instead of 
> > parsing the properties directly.
> 
> This must be new too. Will do in v2.
> 
> -- 
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation

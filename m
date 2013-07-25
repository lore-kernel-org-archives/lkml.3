Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479Ab3GYQkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 12:40:10 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:47358 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab3GYQkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 12:40:07 -0400
Date: Thu, 25 Jul 2013 09:40:05 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>, linux-arm-msm@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 08/14] clk: msm: Add MSM clock driver
Message-ID: <20130725164005.GE29694@codeaurora.org>
References: <1374713022-6049-1-git-send-email-sboyd@codeaurora.org>
 <1374713022-6049-9-git-send-email-sboyd@codeaurora.org>
 <2513717.VTXGvIpGv4@flatron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2513717.VTXGvIpGv4@flatron>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25, Tomasz Figa wrote:
> On Wednesday 24 of July 2013 17:43:36 Stephen Boyd wrote:
> > Add a clock driver that registers clocks from a DT node's
> > 'clocks' child. Each new SoC will add a file describing the
> > software interface and frequency plan to drivers/clk/msm/ and
> > then hook that into the msm_cc_match_table by means of a
> > compatible string and an msm_clk_match table.
> > 
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> > ---
> >  drivers/clk/msm/Makefile   |   2 +
> >  drivers/clk/msm/core.c     | 265
> > +++++++++++++++++++++++++++++++++++++++++++++
> > drivers/clk/msm/internal.h |  24 ++++
> >  3 files changed, 291 insertions(+)
> >  create mode 100644 drivers/clk/msm/core.c
> >  create mode 100644 drivers/clk/msm/internal.h
> > 
> > diff --git a/drivers/clk/msm/Makefile b/drivers/clk/msm/Makefile
> > index e1cee29..9cfd0d7 100644
> > --- a/drivers/clk/msm/Makefile
> > +++ b/drivers/clk/msm/Makefile
> > @@ -4,3 +4,5 @@ clk-msm-$(CONFIG_COMMON_CLK_MSM) += clk-pll.o
> >  clk-msm-$(CONFIG_COMMON_CLK_MSM) += clk-rcg.o
> >  clk-msm-$(CONFIG_COMMON_CLK_MSM) += clk-rcg2.o
> >  clk-msm-$(CONFIG_COMMON_CLK_MSM) += clk-branch.o
> > +
> > +clk-msm-$(CONFIG_COMMON_CLK_MSM) += core.o
> > diff --git a/drivers/clk/msm/core.c b/drivers/clk/msm/core.c
> > new file mode 100644
> > index 0000000..b1904c0
> > --- /dev/null
> > +++ b/drivers/clk/msm/core.c
> > @@ -0,0 +1,265 @@
> > +/*
> > + * Copyright (c) 2013, The Linux Foundation. All rights reserved.
> > + *
> > + * This software is licensed under the terms of the GNU General Public
> > + * License version 2, as published by the Free Software Foundation, and
> > + * may be copied, distributed, and modified under those terms. + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <linux/err.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/module.h>
> > +#include <linux/clk-provider.h>
> > +#include <linux/of.h>
> > +#include <linux/of_device.h>
> > +#include <linux/spinlock.h>
> > +
> > +#include "internal.h"
> > +#include "clk-pll.h"
> > +#include "clk-rcg.h"
> > +#include "clk-branch.h"
> > +
> > +struct cc_data {
> > +	void __iomem *base;
> > +	spinlock_t lock;
> > +};
> > +
> > +static struct clk *
> > +dispatch_fixed_clk(struct of_clk_match *m, struct device *dev,
> > +		struct cc_data *cc)
> > +{
> > +	u32 rate;
> > +	const char *name = m->init_data->name;
> > +
> > +	if (of_property_read_u32(m->of_node, "clock-frequency", &rate))
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	return clk_register_fixed_rate(dev, name, NULL, CLK_IS_ROOT, 
> rate);
> > +}
> > +
> > +static struct clk *
> > +dispatch_pll_clk(struct of_clk_match *m, struct device *dev,
> > +		struct cc_data *cc)
> > +{
> > +	struct pll_desc *desc = m->driver_data;
> > +
> > +	desc->base = cc->base;
> > +
> > +	return pll_clk_register(dev, desc, m->init_data);
> > +}
> > +
> > +static struct clk *
> > +dispatch_pll_vote_clk(struct of_clk_match *m, struct device *dev,
> > +		struct cc_data *cc)
> > +{
> > +	struct pll_vote_desc *desc = m->driver_data;
> > +
> > +	desc->base = cc->base;
> > +
> > +	return pll_vote_clk_register(dev, desc, m->init_data);
> > +}
> > +
> > +static struct clk *
> > +dispatch_rcg_p2mn16_clk(struct of_clk_match *m, struct device *dev,
> > +		struct cc_data *cc)
> > +{
> > +	struct rcg_desc *desc = m->driver_data;
> > +
> > +	desc->base = cc->base;
> > +
> > +	return rcg_p2mn16_clk_register(dev, desc, &cc->lock, m-
> >init_data);
> > +}
> > +
> > +static struct clk *
> > +dispatch_rcg_p2mn8_clk(struct of_clk_match *m, struct device *dev,
> > +		struct cc_data *cc)
> > +{
> > +	struct rcg_desc *desc = m->driver_data;
> > +
> > +	desc->base = cc->base;
> > +
> > +	return rcg_p2mn8_clk_register(dev, desc, &cc->lock, m->init_data);
> > +}
> > +
> > +static struct clk *
> > +dispatch_rcg_mn8_dyn_clk(struct of_clk_match *match, struct device
> > *dev, +		struct cc_data *cc)
> > +{
> > +	struct rcg_dyn_desc *desc = match->driver_data;
> > +
> > +	desc->base = cc->base;
> > +
> > +	return rcg_mn8_dyn_clk_register(dev, desc, &cc->lock,
> > +			match->init_data);
> > +}
> > +
> > +static struct clk *
> > +dispatch_rcg_p4_dyn_clk(struct of_clk_match *match, struct device *dev,
> > +		struct cc_data *cc)
> > +{
> > +	struct rcg_dyn_desc *desc = match->driver_data;
> > +
> > +	desc->base = cc->base;
> > +
> > +	return rcg_p4_dyn_clk_register(dev, desc, &cc->lock,
> > +			match->init_data);
> > +}
> > +
> > +static struct clk *
> > +dispatch_rcg_h5mn8_clk(struct of_clk_match *match, struct device *dev,
> > +		struct cc_data *cc)
> > +{
> > +	struct rcg2_desc *desc = match->driver_data;
> > +
> > +	desc->base = cc->base;
> > +
> > +	return rcg_h5mn8_clk_register(dev, desc, &cc->lock, match-
> >init_data);
> > +}
> > +
> > +static struct clk *
> > +dispatch_rcg_h5mn16_clk(struct of_clk_match *match, struct device *dev,
> > +		struct cc_data *cc)
> > +{
> > +	struct rcg2_desc *desc = match->driver_data;
> > +
> > +	desc->base = cc->base;
> > +
> > +	return rcg_h5mn16_clk_register(dev, desc, &cc->lock,
> > match->init_data); +}
> > +
> > +static struct clk *
> > +dispatch_branch_clk(struct of_clk_match *m, struct device *dev,
> > +		struct cc_data *cc)
> > +{
> > +	struct branch_desc *desc = m->driver_data;
> > +
> > +	desc->base = cc->base;
> > +
> > +	return branch_clk_register(dev, desc, &cc->lock, m->init_data);
> > +}
> > +
> > +static struct clk *
> > +dispatch_branch_hg_clk(struct of_clk_match *m, struct device *dev,
> > +		struct cc_data *cc)
> > +{
> > +	struct branch_desc *desc = m->driver_data;
> > +
> > +	desc->base = cc->base;
> > +
> > +	return branch_hg_clk_register(dev, desc, &cc->lock, m->init_data);
> > +}
> > +
> > +static const struct of_device_id dispatch_table[] = {
> > +	{ .compatible = "fixed-clock", .data = dispatch_fixed_clk },
> 
> This is already handled by the fixed-rate-clock driver and of_clk_init().

I don't plan to use of_clk_init() because I have actual device
drivers.

> 
> > +	{ .compatible = "qcom,pll", .data = dispatch_pll_clk },
> > +	{ .compatible = "qcom,pll-vote", .data = dispatch_pll_vote_clk },
> > +	{ .compatible = "qcom,p2-mn8-clock", .data = 
> dispatch_rcg_p2mn8_clk },
> > +	{ .compatible = "qcom,p2-mn16-clock", .data = 
> dispatch_rcg_p2mn16_clk
> > }, +	{ .compatible = "qcom,mn8-dyn-clock", .data =
> > dispatch_rcg_mn8_dyn_clk }, +	{ .compatible = "qcom,p4-dyn-clock",
> > .data = dispatch_rcg_p4_dyn_clk }, +	{ .compatible =
> > "qcom,h5-mn8-clock", .data = dispatch_rcg_h5mn8_clk }, +	{ 
> .compatible
> > = "qcom,h5-mn16-clock", .data = dispatch_rcg_h5mn16_clk }, +	{
> > .compatible = "qcom,cxc-clock", .data = dispatch_branch_clk }, +	{
> > .compatible = "qcom,cxc-hg-clock", .data = dispatch_branch_hg_clk },
> > +};
> 
> You can avoid all the code above by using OF_CLK_DECLARE() and 
> of_clk_init().

As stated earlier that won't work because I want a struct device.

> > +
> > +static int __init msm_cc_init(void)
> > +{
> > +	return platform_driver_register(&msm_cc_driver);
> > +}
> > +core_initcall(msm_cc_init);
> 
> I might be saying something stupid, but is it okay for a removable module 
> to have a core_initcall?
> 

If its compiled as a module the core_initcall becomes a
module_initcall(). It's here because I need the clocks before the
serial driver probes. If clocks supported deferred probing this
wouldn't be necessary and we could use module_platform_driver().

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

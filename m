Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab3BFKC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:02:26 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:33914 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab3BFKCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:02:21 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-03-51122a2bdc63
From: Tomasz Figa <t.figa@samsung.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Prashant Gaikwad <pgaikwad@nvidia.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V2] clk: Add composite clock type
Date: Wed, 06 Feb 2013 11:02:14 +0100
Message-id: <1540338.CtVIxUnnxQ@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.9.5 (Linux/3.7.4-gentoo; KDE/4.9.5; x86_64; ; )
In-reply-to: <511227F6.3050601@nvidia.com>
References: <5110C3E5.2010503@nvidia.com>
 <20130206.081048.71241785637713947.hdoyu@nvidia.com>
 <511227F6.3050601@nvidia.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFLMWRmVeSWpSXmKPExsVy+t9jQV1tLaFAg4OnTS0u75rDZtH5ZRab
	A5PH501yAYxRXDYpqTmZZalF+nYJXBkrH35nLVghX/F24gyWBsa7Il2MnBwSAiYSCyadZoaw
	xSQu3FvP1sXIxSEkMJ1R4sSmM2wgCSGBFiaJRy8cQGw2ATWJzw2PwOIiAhoSU7oes4PYzAKP
	mCTuv4sBsYUFTCWW39sONpRFQFVixoO/YPW8ApoSOz+9ZQSx+QXUJd5te8oEYosKOEss7H0N
	VMPBwSmgJXHzchjEDQ2MEs2tM1khegUlfky+xwKxS15i3/6prBC2lsT6nceZJjAKzkJSNgtJ
	2SwkZQsYmVcxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBIfoM+kdjKsaLA4xCnAwKvHw3tAT
	DBRiTSwrrsw9xCjBwawkwhurIBQoxJuSWFmVWpQfX1Sak1p8iFGag0VJnJfx1JMAIYH0xJLU
	7NTUgtQimCwTB6dUA+PS2a+3n/5o/u2uce5Cqz0mzpLLN509pPNt4oHHdxepTm+Q8jnouuvy
	J919lY3enht8d/5Oc0q9ErZMUCEmnsdi1YyUQgahN0uPW7w+N2elZZrOYbc3RbtUe+zkZi6o
	talPnOpaEhx55fzK3oDkXR/bL5UzXtu0lv+jQn9h8u3Aos18rDaVDD5KLMUZiYZazEXFiQAe
	NEUaTQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 of February 2013 15:22:54 Prashant Gaikwad wrote:
> On Wednesday 06 February 2013 11:40 AM, Hiroshi Doyu wrote:
> > Prashant Gaikwad <pgaikwad@nvidia.com> wrote @ Wed, 6 Feb 2013 
03:55:00 +0100:
> >>>> No, clk_ops depends on the clocks you are using. There could be a
> >>>> clock
> >>>> with mux and gate while another one with mux and div.
> >>> 
> >>> You are right. What about the following? We don't have to have
> >>> similar
> >>> copy of clk_composite_ops for each instances.
> >> 
> >> Clock framework takes decision depending on the ops availability and
> >> it
> >> does not know if the clock is mux or gate.
> >> 
> >> For example,
> >> 
> >>                   if (clk->ops->enable) {
> >>                   
> >>                           ret = clk->ops->enable(clk->hw);
> >>                           if (ret) {
> >>                           
> >>                                   __clk_disable(clk->parent);
> >>                                   return ret;
> >>                           
> >>                           }
> >>                   
> >>                   }
> >> 
> >> in above case if clk_composite does not have gate clock then as per
> >> your suggestion if it returns error value then it will fail and it
> >> is wrong.> 
> > Ok, now I understand. Thank you for explanation.
> > 
> > We always need to allocate clk_composite_ops for each clk_composite,
> > right? If so what about having "struct clk_ops ops" in "struct
> > clk_composite"?
> > 
> > diff --git a/drivers/clk/clk-composite.c b/drivers/clk/clk-composite.c
> > index f30fb4b..5240e24 100644
> > --- a/drivers/clk/clk-composite.c
> > +++ b/drivers/clk/clk-composite.c
> > @@ -129,20 +129,13 @@ struct clk *clk_register_composite(struct device
> > *dev, const char *name,> 
> >                  pr_err("%s: could not allocate composite clk\n",
> >                  __func__);
> >                  return ERR_PTR(-ENOMEM);
> >          
> >          }
> > 
> > +       clk_composite_ops = &composite->ops;
> > 
> >          init.name = name;
> >          init.flags = flags | CLK_IS_BASIC;
> >          init.parent_names = parent_names;
> >          init.num_parents = num_parents;
> > 
> > -       /* allocate the clock ops */
> > -       clk_composite_ops = kzalloc(sizeof(*clk_composite_ops),
> > GFP_KERNEL); -       if (!clk_composite_ops) {
> > -               pr_err("%s: could not allocate clk ops\n", __func__);
> > -               kfree(composite);
> > -               return ERR_PTR(-ENOMEM);
> > -       }
> > -
> > 
> >          if (mux_hw && mux_ops) {
> >          
> >                  if (!mux_ops->get_parent || !mux_ops->set_parent) {
> >                  
> >                          clk = ERR_PTR(-EINVAL);
> > 
> > @@ -202,7 +195,6 @@ struct clk *clk_register_composite(struct device
> > *dev, const char *name,> 
> >          return clk;
> >   
> >   err:
> > -       kfree(clk_composite_ops);
> > 
> >          kfree(composite);
> >          return clk;
> >   
> >   }
> > 
> > diff --git a/include/linux/clk-provider.h
> > b/include/linux/clk-provider.h index f0ac818..bb5d36a 100644
> > --- a/include/linux/clk-provider.h
> > +++ b/include/linux/clk-provider.h
> > @@ -346,6 +346,8 @@ struct clk_composite {
> > 
> >          const struct clk_ops    *mux_ops;
> >          const struct clk_ops    *div_ops;
> >          const struct clk_ops    *gate_ops;
> > 
> > +
> > +       const struct clk_ops    ops;
> > 
> >   };
> >   
> >   struct clk *clk_register_composite(struct device *dev, const char
> >   *name,
> This will work, but there is no harm in allocating dynamically. What is
> preferred?

IMHO it is always better to allocate one bigger structure than several 
smaller if they are always needed together and one cannot exist without 
others.

Best regards,
-- 
Tomasz Figa
Samsung Poland R&D Center
SW Solution Development, Linux Platform


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab3BFGLC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 01:11:02 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17253 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3BFGK7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 01:10:59 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 05 Feb 2013 22:07:51 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "t.figa@samsung.com" <t.figa@samsung.com>
Date: Wed, 6 Feb 2013 07:10:48 +0100
Subject: Re: [PATCH V2] clk: Add composite clock type
Thread-Topic: [PATCH V2] clk: Add composite clock type
Thread-Index: Ac4EMLXjOqp4UCOiSWGgf08YSnBDww==
Message-ID: <20130206.081048.71241785637713947.hdoyu@nvidia.com>
References: <5110C3E5.2010503@nvidia.com><20130205.122252.570646990867457667.hdoyu@nvidia.com><5111C604.8070104@nvidia.com>
In-Reply-To: <5111C604.8070104@nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prashant Gaikwad <pgaikwad@nvidia.com> wrote @ Wed, 6 Feb 2013 03:55:00 +0100:

> >> No, clk_ops depends on the clocks you are using. There could be a clock
> >> with mux and gate while another one with mux and div.
> > You are right. What about the following? We don't have to have similar
> > copy of clk_composite_ops for each instances.
> 
> Clock framework takes decision depending on the ops availability and it 
> does not know if the clock is mux or gate.
> 
> For example,
> 
>                  if (clk->ops->enable) {
>                          ret = clk->ops->enable(clk->hw);
>                          if (ret) {
>                                  __clk_disable(clk->parent);
>                                  return ret;
>                          }
>                  }
> 
> in above case if clk_composite does not have gate clock then as per your 
> suggestion if it returns error value then it will fail and it is wrong.

Ok, now I understand. Thank you for explanation.

We always need to allocate clk_composite_ops for each clk_composite,
right? If so what about having "struct clk_ops ops" in "struct
clk_composite"?

diff --git a/drivers/clk/clk-composite.c b/drivers/clk/clk-composite.c
index f30fb4b..5240e24 100644
--- a/drivers/clk/clk-composite.c
+++ b/drivers/clk/clk-composite.c
@@ -129,20 +129,13 @@ struct clk *clk_register_composite(struct device *dev, const char *name,
                pr_err("%s: could not allocate composite clk\n", __func__);
                return ERR_PTR(-ENOMEM);
        }
+       clk_composite_ops = &composite->ops;
 
        init.name = name;
        init.flags = flags | CLK_IS_BASIC;
        init.parent_names = parent_names;
        init.num_parents = num_parents;
 
-       /* allocate the clock ops */
-       clk_composite_ops = kzalloc(sizeof(*clk_composite_ops), GFP_KERNEL);
-       if (!clk_composite_ops) {
-               pr_err("%s: could not allocate clk ops\n", __func__);
-               kfree(composite);
-               return ERR_PTR(-ENOMEM);
-       }
-
        if (mux_hw && mux_ops) {
                if (!mux_ops->get_parent || !mux_ops->set_parent) {
                        clk = ERR_PTR(-EINVAL);
@@ -202,7 +195,6 @@ struct clk *clk_register_composite(struct device *dev, const char *name,
        return clk;
 
 err:
-       kfree(clk_composite_ops);
        kfree(composite);
        return clk;
 }
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index f0ac818..bb5d36a 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -346,6 +346,8 @@ struct clk_composite {
        const struct clk_ops    *mux_ops;
        const struct clk_ops    *div_ops;
        const struct clk_ops    *gate_ops;
+
+       const struct clk_ops    ops;
 };
 
 struct clk *clk_register_composite(struct device *dev, const char *name,


> > diff --git a/drivers/clk/clk-composite.c b/drivers/clk/clk-composite.c
> > index f30fb4b..8f88805 100644
> > --- a/drivers/clk/clk-composite.c
> > +++ b/drivers/clk/clk-composite.c
> > @@ -27,6 +27,9 @@ static u8 clk_composite_get_parent(struct clk_hw *hw)
> >          const struct clk_ops *mux_ops = composite->mux_ops;
> >          struct clk_hw *mux_hw = composite->mux_hw;
> >   
> > +       if (!mux_hw->clk)
> > +	       return -EINVAL;
> > +
> >          mux_hw->clk = hw->clk;
>
> It is wrong.

Will the above "mux_hw->clk = hw->clk" be removed from the original?

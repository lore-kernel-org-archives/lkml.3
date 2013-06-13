Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab3FMClo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 22:41:44 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:54929 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756730Ab3FMCln convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 22:41:43 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: =?utf-8?q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        linux-arm-kernel@lists.infradead.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <201306040018.33236.heiko@sntech.de>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
References: <1370281990-15090-1-git-send-email-mturquette@linaro.org>
 <1370281990-15090-4-git-send-email-mturquette@linaro.org>
 <201306040018.33236.heiko@sntech.de>
Message-ID: <20130613024138.26381.96286@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH RFC 3/3] clk: dt: binding for basic divider clock
Date: Wed, 12 Jun 2013 19:41:38 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Heiko Stübner (2013-06-03 15:18:32)
> Am Montag, 3. Juni 2013, 19:53:10 schrieb Mike Turquette:
> > Devicetree binding for the basic clock divider, plus the setup function
> > to register the clock.  Based on the existing fixed-clock binding.
> > 
> > Signed-off-by: Mike Turquette <mturquette@linaro.org>
> > ---
> 
> [...]
> 
> > +/**
> > + * of_div_clk_setup() - Setup function for simple div rate clock
> > + */
> > +void of_divider_clk_setup(struct device_node *node)
> > +{
> > +     struct clk *clk;
> > +     const char *clk_name = node->name;
> > +     void __iomem *reg;
> > +     const char *parent_name;
> > +     u8 clk_divider_flags = 0;
> > +     u8 mask = 0;
> > +     u8 shift = 0;
> 
> in the mux-clock these 3 are unsigned long and u32 types ... what is correct?
> 

Good catch.  Shifts should be u8, masks should be u32.  I've left the
flags as u8.  The binding doesn't dictate this and if we end up having
more flags (hopefully not!) then this value can be embiggened.

> 
> > +     struct clk_div_table *table;
> > +
> > +     of_property_read_string(node, "clock-output-names", &clk_name);
> > +
> > +     parent_name = of_clk_get_parent_name(node, 0);
> > +
> > +     reg = of_iomap(node, 0);
> > +
> > +     if (of_property_read_u8(node, "mask", &mask)) {
> > +             pr_err("%s: missing mask property for %s\n", __func__, node->name);
> > +             return;
> > +     }
> > +
> > +     if (of_property_read_u8(node, "shift", &shift))
> > +             pr_debug("%s: missing shift property defaults to zero for %s\n",
> > +                             __func__, node->name);
> 
> same here ... mux reads u32
> 
> > +     if (of_property_read_bool(node, "index_one"))
> > +             clk_divider_flags |= CLK_DIVIDER_ONE_BASED;
> > +
> > +     if (of_property_read_bool(node, "index_power_of_two"))
> > +             clk_divider_flags |= CLK_DIVIDER_POWER_OF_TWO;
> > +
> > +     if (of_property_read_bool(node, "index_allow_zero"))
> > +             clk_divider_flags |= CLK_DIVIDER_ALLOW_ZERO;
> > +
> > +     table = of_clk_get_div_table(node);
> > +     if (IS_ERR(table))
> > +             return;
> > +
> > +     clk = clk_register_divider_table(NULL, clk_name,
> > +                     parent_name, 0,
> > +                     reg, shift, mask,
> > +                     clk_divider_flags, table,
> > +                     NULL);
> 
> this causes trouble, as the divider clock code above still requires a width 
> instead of a mask. I remember talk about this going to change separately, but 
> couldn't find anything of the sort in linux-next.

Right.  I viewed creation of the DT bindings a bit separately from the
CCF code, which I think is the right approach.  A mask is definitely a
more useful structure than a width value, and the DT bindings need to be
at least a little future-proof, so I chose a mask.

I'll update the divider code to use a mask and post that as part of the
v2 series.

Regards,
Mike

> 
> 
> 
> > +
> > +     if (!IS_ERR(clk))
> > +             of_clk_add_provider(node, of_clk_src_simple_get, clk);
> > +}
> > +EXPORT_SYMBOL_GPL(of_divider_clk_setup);
> > +CLK_OF_DECLARE(divider_clk, "divider-clock", of_divider_clk_setup);
> > +#endif

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933229Ab3DJTTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 15:19:17 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:47823 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab3DJTTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 15:19:15 -0400
MIME-Version: 1.0
In-Reply-To: <20130410184919.GJ10155@atomide.com>
References: <20130404164137.GH10155@atomide.com>
	<515EA9E3.1010409@ti.com>
	<20130405155851.GA10155@atomide.com>
	<5163E589.1040809@ti.com>
	<20130409164928.GL10155@atomide.com>
	<20130409174319.GP10155@atomide.com>
	<20130409204900.GA8815@kahuna>
	<20130410080630.14359.68178@quantum>
	<5165453E.6090503@ti.com>
	<20130410173921.GA31017@kahuna>
	<20130410184919.GJ10155@atomide.com>
Date: Wed, 10 Apr 2013 14:19:13 -0500
X-Google-Sender-Auth: RODZ6IH1e-7bvjjAMOa6MfxRbw8
Message-ID: <CAGo_u6rqN6YFQ6vX87-Cg28RbiR9UU2JHgLecOU5Nd=B5XPUEA@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/2] ARM: OMAP4: clock: Add device tree support for AUXCLKs
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Roger Quadros <rogerq@ti.com>, Mike Turquette <mturquette@linaro.org>,
        linux-usb@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org,
        lkml <linux-kernel@vger.kernel.org>, balbi@ti.com,
        grygorii.strashko@ti.com, linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,
On Wed, Apr 10, 2013 at 1:49 PM, Tony Lindgren <tony@atomide.com> wrote:
> * Nishanth Menon <nm@ti.com> [130410 10:44]:
>> Details in the patch below (Tony, I have added you as collaborator for
>> helping in getting this working-clk_add_alias was'nt needed in the
>> internal patch discussion we had - I have taken a bit of freedom in
>> adding your contributions to the patch below)
>
> OK thanks. Noticed few minor things, see below.
Thanks on the checkup
>
>> Folks, this does seem to be the best compromise we can achieve at this
>> point in time. feedback on this approach is much appreciated - if folks
>> are ok, I can post this as an formal patch series.
>>
>> From 130a41821bf57081ca45ef654029175d173135e6 Mon Sep 17 00:00:00 2001
>> From: Nishanth Menon <nm@ti.com>
>> Date: Tue, 9 Apr 2013 19:26:40 -0500
>> Subject: [RFC PATCH] clk: OMAP: introduce device tree binding to kernel clock
>>  data
>>
>> OMAP clock data is located in arch/arm/mach-omap2/cclockXYZ_data.c.
>> However, this presents an obstacle for using these clock nodes in
>> Device Tree definitions. There are many possible approaches to this
>> problem as discussed in the following thread:
>> http://marc.info/?t=136370325600009&r=1&w=2
>
> It might be worth clarifying that this is especially for the board
> specific clocks initially. The fixed clocks are currently found via
> the clock aliases table.
Ack.
[...]
>
>> +Example #2: describing clock node for auxilary clock #3 on OMAP443x platform:
>> +Ref: arch/arm/mach-omap2/cclock44xx_data.c
>> +describes the auxclk3 clock to be as follows:
>> +     CLK(NULL,       "auxclk3_ck",   &auxclk3_ck,    CK_443X),
>> +Corresponding binding will be:
>> +     auxclk3: auxclk3 {
>> +             #clock-cells = <1>;
>> +             compatible = "ti,omap-clock";
>> +     };
>> +And it's usage will be:
>> +     clocks = <&auxclk3>;
>
> The #clock-cells in the auxclk3 example should also be 0 instead of 1
> AFAIK. We should only use #clock-cells = <1> when the same physical
> clock provides multiple outputs. I believe the auxclocks are all separate,
> but that needs to be verified.
Oops.. my bad. you are correct here - auxclk is single output. all of them.
will fix.
[...]
>> +static int omap_clk_probe(struct platform_device *pdev)
>> +{
>> +     struct clk *clk;
>> +     int res;
>> +
>> +     const struct of_device_id *match;
>> +     struct device_node *np = pdev->dev.of_node;
>> +     char clk_name[32];
>> +
>> +     match = of_match_device(omap_clk_of_match, &pdev->dev);
>> +
>> +     /* Set up things so consumer can call clk_get() with name */
>> +     snprintf(clk_name, 32, "%s_ck", np->name);
>> +     clk = clk_get(NULL, clk_name);
>> +     if (IS_ERR(clk)) {
>> +             res = PTR_ERR(clk);
>> +             dev_err(&pdev->dev, "could not get clock %s (%d)\n",
>> +                     clk_name, res);
>> +             goto out;
>> +     }
>
> It seems that at least for now we can assume the naming will stay
> that way, then if we need other rules for finding clocks, we can
> add omap_match_clock() function or something.
ack.
>
>> +     /* This allows the driver to of_clk_get() */
>> +     res = of_clk_add_provider(np, of_clk_src_simple_get, clk);
>> +     if (res)
>> +             dev_err(&pdev->dev, "could not add provider for %s (%d)\n",
>> +                     clk_name, res);
>> +
>> +     clk_put(clk);
>> +out:
>> +     return res;
>> +}
>
> We can avoid the concern of storing the struct clk * and do the
> look up lazily on consumer driver probe by setting a dummy struct
> clk * here. Then replace of_clk_src_simple_get() with a custom
> omap_clk_src_get() that does the lookup and replaces the struct
> clk * with the real one.
Hmm.. this is interesting. will give it a try. Thanks on the suggestion.

Regards,
Nishanth Menon

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab3DLSiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 14:38:19 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:40715 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab3DLSiS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 14:38:18 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Michal Bachraty <michal.bachraty@streamunlimited.com>,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1365495975-792-1-git-send-email-michal.bachraty@streamunlimited.com>
Cc: sebastian.hesselbarth@gmail.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Michal Bachraty <michal.bachraty@streamunlimited.com>
References: <1365495975-792-1-git-send-email-michal.bachraty@streamunlimited.com>
Message-ID: <20130412183809.6507.27844@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH] clk: si5351: Add gapless tuning for SI5351 PLL
Date: Fri, 12 Apr 2013 11:38:09 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Michal Bachraty (2013-04-09 01:26:15)
> For gapless tuning, there is no need for PLL reset and clkout power-down
> when tuning output. "silabs,gapless-tuning" parameter enables gapless tuning
> for specific clock output.
> 
> Signed-off-by: Michal Bachraty <michal.bachraty@streamunlimited.com>

Hi Michal,

This did not apply cleanly on the latest (v8) si5351 clk driver.  Can
you refresh it?  I do not plan on taking any more patches for 3.10 after
3.9-rc7 drops (likely on Sunday or Monday).  So this patch may need to
wait until after the merge window.

Regards,
Mike

> ---
>  .../devicetree/bindings/clock/silabs,si5351.txt    |    2 ++
>  drivers/clk/clk-si5351.c                           |   27 +++++++++++++++++---
>  2 files changed, 25 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/clock/silabs,si5351.txt b/Documentation/devicetree/bindings/clock/silabs,si5351.txt
> index cc37465..e16ab2b 100644
> --- a/Documentation/devicetree/bindings/clock/silabs,si5351.txt
> +++ b/Documentation/devicetree/bindings/clock/silabs,si5351.txt
> @@ -44,6 +44,8 @@ Optional child node properties:
>  - silabs,multisynth-source: source pll A(0) or B(1) of corresponding multisynth
>    divider.
>  - silabs,pll-master: boolean, multisynth can change pll frequency.
> +- silabs,gapless-tuning: boolean, enable gapless (glitch-free) tuning. Depends on
> +  "silabs,multisynth-source" parameter.
>  
>  ==Example==
>  
> diff --git a/drivers/clk/clk-si5351.c b/drivers/clk/clk-si5351.c
> index e259cec..d3933a9 100644
> --- a/drivers/clk/clk-si5351.c
> +++ b/drivers/clk/clk-si5351.c
> @@ -54,6 +54,7 @@ struct si5351_hw_data {
>         struct si5351_driver_data       *drvdata;
>         struct si5351_parameters        params;
>         unsigned char                   num;
> +       unsigned char                   gapless_tuning;
>  };
>  
>  struct si5351_driver_data {
> @@ -526,8 +527,10 @@ static int si5351_pll_set_rate(struct clk_hw *hw, unsigned long rate,
>                 (hwdata->params.p2 == 0) ? SI5351_CLK_INTEGER_MODE : 0);
>  
>         /* reset pll */
> -       val = (hwdata->num == 0) ? SI5351_PLL_RESET_A : SI5351_PLL_RESET_B;
> -       si5351_set_bits(hwdata->drvdata, SI5351_PLL_RESET, val, val);
> +       if (!hwdata->gapless_tuning) {
> +               val = (hwdata->num == 0) ? SI5351_PLL_RESET_A : SI5351_PLL_RESET_B;
> +               si5351_set_bits(hwdata->drvdata, SI5351_PLL_RESET, val, val);
> +       }
>  
>         dev_dbg(&hwdata->drvdata->client->dev,
>                 "%s - %s: p1 = %lu, p2 = %lu, p3 = %lu, parent_rate = %lu, rate = %lu\n",
> @@ -1064,8 +1067,9 @@ static int si5351_clkout_set_rate(struct clk_hw *hw, unsigned long rate,
>         } while (1);
>  
>         /* powerdown clkout */
> -       si5351_set_bits(hwdata->drvdata, SI5351_CLK0_CTRL + hwdata->num,
> -                       SI5351_CLK_POWERDOWN, SI5351_CLK_POWERDOWN);
> +       if (!hwdata->gapless_tuning)
> +               si5351_set_bits(hwdata->drvdata, SI5351_CLK0_CTRL + hwdata->num,
> +                               SI5351_CLK_POWERDOWN, SI5351_CLK_POWERDOWN);
>  
>         /* write output divider */
>         switch (hwdata->num) {
> @@ -1117,6 +1121,7 @@ static void si5351_dt_setup(
>         struct property *prop;
>         const __be32 *p;
>         unsigned int num, val;
> +       int pll = -1;
>  
>         if (np == NULL)
>                 return;
> @@ -1167,6 +1172,8 @@ static void si5351_dt_setup(
>                                 dev_warn(&client->dev,
>                                          "unable to reparent multisynth %d to %d\n",
>                                          num, val);
> +                       else
> +                               pll = val;
>                 }
>  
>                 if (!of_property_read_u32(np, "silabs,clock-source", &val)) {
> @@ -1178,6 +1185,15 @@ static void si5351_dt_setup(
>  
>                 if (!of_property_read_u32(np, "clock-frequency", &val))
>                         clk_set_rate(drvdata->onecell.clks[num], val);
> +
> +               if (of_property_read_bool(np, "silabs,gapless-tuning")) {
> +                       if (pll >= 0) {
> +                               drvdata->clkout[num].gapless_tuning = 1;
> +                               drvdata->pll[pll].gapless_tuning = 1;
> +                       } else
> +                               dev_warn(&client->dev,
> +                                       "unable to set gapless tuning");
> +               }
>         }
>  }
>  
> @@ -1294,6 +1310,7 @@ static int si5351_i2c_probe(struct i2c_client *client,
>         drvdata->pll[0].num = 0;
>         drvdata->pll[0].drvdata = drvdata;
>         drvdata->pll[0].hw.init = &init;
> +       drvdata->pll[0].gapless_tuning = 0;
>         memset(&init, 0, sizeof(init));
>         init.name = si5351_pll_names[0];
>         init.ops = &si5351_pll_ops;
> @@ -1310,6 +1327,7 @@ static int si5351_i2c_probe(struct i2c_client *client,
>         drvdata->pll[1].num = 1;
>         drvdata->pll[1].drvdata = drvdata;
>         drvdata->pll[1].hw.init = &init;
> +       drvdata->pll[1].gapless_tuning = 0;
>         memset(&init, 0, sizeof(init));
>         if (drvdata->variant == SI5351_VARIANT_B) {
>                 init.name = si5351_pll_names[2];
> @@ -1380,6 +1398,7 @@ static int si5351_i2c_probe(struct i2c_client *client,
>                 drvdata->clkout[n].num = n;
>                 drvdata->clkout[n].drvdata = drvdata;
>                 drvdata->clkout[n].hw.init = &init;
> +               drvdata->clkout[n].gapless_tuning = 0;
>                 memset(&init, 0, sizeof(init));
>                 init.name = si5351_clkout_names[n];
>                 init.ops = &si5351_clkout_ops;
> -- 
> 1.7.9.5

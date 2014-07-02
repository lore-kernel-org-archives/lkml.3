Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389AbaGBRBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 13:01:21 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:46891 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069AbaGBRBS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 13:01:18 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Karol Wrona <k.wrona@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1404234839-6005-1-git-send-email-k.wrona@samsung.com>
Cc: "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Marek Szyprowski" <m.szyprowski@samsung.com>,
        "Bartlomiej Zolnierkiewicz" <b.zolnierkie@samsung.com>,
        "Tomasz Figa" <t.figa@samsung.com>,
        "Karol Wrona" <k.wrona@samsung.com>
References: <1404234839-6005-1-git-send-email-k.wrona@samsung.com>
Message-ID: <20140702170104.7440.66617@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v2] clk: s2mps11: Fix clk_ops
Date: Wed, 02 Jul 2014 10:01:04 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Karol Wrona (2014-07-01 10:13:59)
> s2mps11 clocks had registered callbacks for prepare ,unprepare and is_enabled.
> During disabling unused clocks the lack of is_prepared caused that unused
> s2mps11 clocks were not unprepared and stayed active.
> 
> Regmap_read is cached so it can be called in is_prepare callback
> to achieve this information. Enabled field was removed from struct s2mps11_clk.
> 
> Signed-off-by: Karol Wrona <k.wrona@samsung.com>

Applied to clk-next. I didn't take it into clk-fixes since I don't think
the disable_unused bug was introduced any time recently.

Regards,
Mike

> ---
>  drivers/clk/clk-s2mps11.c |   33 +++++++++++----------------------
>  1 file changed, 11 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/clk/clk-s2mps11.c b/drivers/clk/clk-s2mps11.c
> index b5274a9..5df99a4 100644
> --- a/drivers/clk/clk-s2mps11.c
> +++ b/drivers/clk/clk-s2mps11.c
> @@ -45,7 +45,6 @@ struct s2mps11_clk {
>         struct clk *clk;
>         struct clk_lookup *lookup;
>         u32 mask;
> -       bool enabled;
>         unsigned int reg;
>  };
>  
> @@ -62,8 +61,6 @@ static int s2mps11_clk_prepare(struct clk_hw *hw)
>         ret = regmap_update_bits(s2mps11->iodev->regmap_pmic,
>                                  s2mps11->reg,
>                                  s2mps11->mask, s2mps11->mask);
> -       if (!ret)
> -               s2mps11->enabled = true;
>  
>         return ret;
>  }
> @@ -75,32 +72,32 @@ static void s2mps11_clk_unprepare(struct clk_hw *hw)
>  
>         ret = regmap_update_bits(s2mps11->iodev->regmap_pmic, s2mps11->reg,
>                            s2mps11->mask, ~s2mps11->mask);
> -
> -       if (!ret)
> -               s2mps11->enabled = false;
>  }
>  
> -static int s2mps11_clk_is_enabled(struct clk_hw *hw)
> +static int s2mps11_clk_is_prepared(struct clk_hw *hw)
>  {
> +       int ret;
> +       u32 val;
>         struct s2mps11_clk *s2mps11 = to_s2mps11_clk(hw);
>  
> -       return s2mps11->enabled;
> +       ret = regmap_read(s2mps11->iodev->regmap_pmic,
> +                               s2mps11->reg, &val);
> +       if (ret < 0)
> +               return -EINVAL;
> +
> +       return val & s2mps11->mask;
>  }
>  
>  static unsigned long s2mps11_clk_recalc_rate(struct clk_hw *hw,
>                                              unsigned long parent_rate)
>  {
> -       struct s2mps11_clk *s2mps11 = to_s2mps11_clk(hw);
> -       if (s2mps11->enabled)
> -               return 32768;
> -       else
> -               return 0;
> +       return 32768;
>  }
>  
>  static struct clk_ops s2mps11_clk_ops = {
>         .prepare        = s2mps11_clk_prepare,
>         .unprepare      = s2mps11_clk_unprepare,
> -       .is_enabled     = s2mps11_clk_is_enabled,
> +       .is_prepared    = s2mps11_clk_is_prepared,
>         .recalc_rate    = s2mps11_clk_recalc_rate,
>  };
>  
> @@ -174,7 +171,6 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
>         unsigned int s2mps11_reg;
>         struct clk_init_data *clks_init;
>         int i, ret = 0;
> -       u32 val;
>  
>         s2mps11_clks = devm_kzalloc(&pdev->dev, sizeof(*s2mps11_clk) *
>                                         S2MPS11_CLKS_NUM, GFP_KERNEL);
> @@ -213,13 +209,6 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
>                 s2mps11_clk->mask = 1 << i;
>                 s2mps11_clk->reg = s2mps11_reg;
>  
> -               ret = regmap_read(s2mps11_clk->iodev->regmap_pmic,
> -                                 s2mps11_clk->reg, &val);
> -               if (ret < 0)
> -                       goto err_reg;
> -
> -               s2mps11_clk->enabled = val & s2mps11_clk->mask;
> -
>                 s2mps11_clk->clk = devm_clk_register(&pdev->dev,
>                                                         &s2mps11_clk->hw);
>                 if (IS_ERR(s2mps11_clk->clk)) {
> -- 
> 1.7.9.5
> 

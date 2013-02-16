Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301Ab3BPCvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 21:51:53 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:44957 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab3BPCvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 21:51:52 -0500
MIME-Version: 1.0
In-Reply-To: <1360919961.23894.2.camel@phoenix>
References: <1360919961.23894.2.camel@phoenix>
Date: Sat, 16 Feb 2013 10:51:52 +0800
Message-ID: <CAN1soZw5k7DBrPOi4iMhsoiGJ_Z5EsYQuFLAjhUiCYsuGxa6ig@mail.gmail.com>
Subject: Re: [RFC/RFT][PATCH 1/3] regulator: core: Add enable_pulldown flag to
 indicate pulldown on EN input
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Jett.Zhou" <jtzhou@marvell.com>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 5:19 PM, Axel Lin <axel.lin@ingics.com> wrote:
> Add enable_pulldown flag to indicate pulldown on EN input when using
> regulator_enable_regmap and friends APIs.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/regulator/core.c         |   24 ++++++++++++++++++++----
>  include/linux/regulator/driver.h |    3 +++
>  2 files changed, 23 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index da9782b..aff977f 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -1794,7 +1794,10 @@ int regulator_is_enabled_regmap(struct regulator_dev *rdev)
>         if (ret != 0)
>                 return ret;
>
> -       return (val & rdev->desc->enable_mask) != 0;
> +       if (rdev->desc->enable_pulldown)
> +               return (val & rdev->desc->enable_mask) == 0;
> +       else
> +               return (val & rdev->desc->enable_mask) != 0;
>  }
>  EXPORT_SYMBOL_GPL(regulator_is_enabled_regmap);
>
> @@ -1809,9 +1812,15 @@ EXPORT_SYMBOL_GPL(regulator_is_enabled_regmap);
>   */
>  int regulator_enable_regmap(struct regulator_dev *rdev)
>  {
> +       unsigned int val;
> +
> +       if (rdev->desc->enable_pulldown)
> +               val = 0;
> +       else
> +               val = rdev->desc->enable_mask;
> +
I think that enable_pulldown is a little hard to understand. How about change
the name, like set_to_disable or something else?

>         return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
> -                                 rdev->desc->enable_mask,
> -                                 rdev->desc->enable_mask);
> +                                 rdev->desc->enable_mask, val);
>  }
>  EXPORT_SYMBOL_GPL(regulator_enable_regmap);
>
> @@ -1826,8 +1835,15 @@ EXPORT_SYMBOL_GPL(regulator_enable_regmap);
>   */
>  int regulator_disable_regmap(struct regulator_dev *rdev)
>  {
> +       unsigned int val;
> +
> +       if (rdev->desc->enable_pulldown)
> +               val = rdev->desc->enable_mask;
> +       else
> +               val = 0;
> +
>         return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
> -                                 rdev->desc->enable_mask, 0);
> +                                 rdev->desc->enable_mask, val);
>  }
>  EXPORT_SYMBOL_GPL(regulator_disable_regmap);
>
> diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
> index 23070fd..7ce1d0c 100644
> --- a/include/linux/regulator/driver.h
> +++ b/include/linux/regulator/driver.h
> @@ -199,6 +199,8 @@ enum regulator_type {
>   *                output when using regulator_set_voltage_sel_regmap
>   * @enable_reg: Register for control when using regmap enable/disable ops
>   * @enable_mask: Mask for control when using regmap enable/disable ops
> + * @enable_pulldown: A flag to indicate pulldown on EN input when using
> + *                   regulator_enable_regmap and friends APIs.
>   *
>   * @enable_time: Time taken for initial enable of regulator (in uS).
>   */
> @@ -226,6 +228,7 @@ struct regulator_desc {
>         unsigned int apply_bit;
>         unsigned int enable_reg;
>         unsigned int enable_mask;
> +       bool enable_pulldown;
>         unsigned int bypass_reg;
>         unsigned int bypass_mask;
>
> --
> 1.7.9.5
>
>
>

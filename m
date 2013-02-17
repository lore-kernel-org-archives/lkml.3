Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab3BQBi5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 20:38:57 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:33234 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245Ab3BQBiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 20:38:55 -0500
MIME-Version: 1.0
In-Reply-To: <1360996576.6116.1.camel@phoenix>
References: <1360996576.6116.1.camel@phoenix>
Date: Sun, 17 Feb 2013 09:38:54 +0800
Message-ID: <CAN1soZzezBXyF3QU6mHUUP=MZDbQPB+a-wruPZ0ZbQ0UxjACUQ@mail.gmail.com>
Subject: Re: [RFT][PATCH 1/3] regulator: core: Add enable_is_inverted flag to
 indicate set enable_mask bits to disable
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Jett.Zhou" <jtzhou@marvell.com>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2013 at 2:36 PM, Axel Lin <axel.lin@ingics.com> wrote:
> Add enable_is_inverted flag to indicate set enable_mask bits to disable
> when using regulator_enable_regmap and friends APIs.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/regulator/core.c         |   24 ++++++++++++++++++++----
>  include/linux/regulator/driver.h |    3 +++
>  2 files changed, 23 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index da9782b..142205b 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -1794,7 +1794,10 @@ int regulator_is_enabled_regmap(struct regulator_dev *rdev)
>         if (ret != 0)
>                 return ret;
>
> -       return (val & rdev->desc->enable_mask) != 0;
> +       if (rdev->desc->enable_is_inverted)
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
> +       if (rdev->desc->enable_is_inverted)
> +               val = 0;
> +       else
> +               val = rdev->desc->enable_mask;
> +
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
> +       if (rdev->desc->enable_is_inverted)
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
> index 23070fd..074b57e 100644
> --- a/include/linux/regulator/driver.h
> +++ b/include/linux/regulator/driver.h
> @@ -199,6 +199,8 @@ enum regulator_type {
>   *                output when using regulator_set_voltage_sel_regmap
>   * @enable_reg: Register for control when using regmap enable/disable ops
>   * @enable_mask: Mask for control when using regmap enable/disable ops
> + * @enable_is_inverted: A flag to indicate set enable_mask bits to disable
> + *                      when using regulator_enable_regmap and friends APIs.
>   *
>   * @enable_time: Time taken for initial enable of regulator (in uS).
>   */
> @@ -226,6 +228,7 @@ struct regulator_desc {
>         unsigned int apply_bit;
>         unsigned int enable_reg;
>         unsigned int enable_mask;
> +       bool enable_is_inverted;
>         unsigned int bypass_reg;
>         unsigned int bypass_mask;
>
> --
> 1.7.9.5
>
>
>

Reviewed-by: Haojian Zhuang <haojian.zhuang@gmail.com>

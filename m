Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbbASJv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 04:51:27 -0500
Received: from 7of9.schinagl.nl ([88.159.158.68]:39054 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbbASJv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 04:51:26 -0500
Message-ID: <54BCD39A.5040805@schinagl.nl>
Date: Mon, 19 Jan 2015 10:51:22 +0100
From: Olliver Schinagl <oliver@schinagl.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Chen-Yu Tsai <wens@csie.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: linux-pwm@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Simon <longsleep@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv10 1/2] pwm: Add Allwinner SoC support
References: <1418850940-30835-1-git-send-email-alexandre.belloni@free-electrons.com> <1418850940-30835-2-git-send-email-alexandre.belloni@free-electrons.com> <CAGb2v64pWFHNL18Fu-yYcUq8M8Xamf=+dmLF6iTB83TaxP65sw@mail.gmail.com>
In-Reply-To: <CAGb2v64pWFHNL18Fu-yYcUq8M8Xamf=+dmLF6iTB83TaxP65sw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Alexandre,

I'll pull your v10 and start testing that hopefully this week. I've been 
using an older version, v8 I think, without any trouble so far.

On 19-01-15 10:21, Chen-Yu Tsai wrote:
> On Thu, Dec 18, 2014 at 5:15 AM, Alexandre Belloni
> <alexandre.belloni@free-electrons.com> wrote:
>> This adds a generic PWM framework driver for the PWM controller
>> found on Allwinner SoCs.
> Hi,
>
> Any news on this series?
>
> ChenYu
>
>> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>> Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>> ---
>>   drivers/pwm/Kconfig     |  10 ++
>>   drivers/pwm/Makefile    |   1 +
>>   drivers/pwm/pwm-sun4i.c | 366 ++++++++++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 377 insertions(+)
>>   create mode 100644 drivers/pwm/pwm-sun4i.c
>>
>> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
>> index ef2dd2e4754b..07f533d2b5be 100644
>> --- a/drivers/pwm/Kconfig
>> +++ b/drivers/pwm/Kconfig
>> @@ -263,6 +263,16 @@ config PWM_STI
>>            To compile this driver as a module, choose M here: the module
>>            will be called pwm-sti.
>>
>> +config PWM_SUN4I
>> +       tristate "Allwinner PWM support"
>> +       depends on ARCH_SUNXI || COMPILE_TEST
>> +       depends on HAS_IOMEM && COMMON_CLK
>> +       help
>> +         Generic PWM framework driver for Allwinner SoCs.
>> +
>> +         To compile this driver as a module, choose M here: the module
>> +         will be called pwm-sun4i.
>> +
>>   config PWM_TEGRA
>>          tristate "NVIDIA Tegra PWM support"
>>          depends on ARCH_TEGRA
>> diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
>> index c458606c3755..d607804deea1 100644
>> --- a/drivers/pwm/Makefile
>> +++ b/drivers/pwm/Makefile
>> @@ -24,6 +24,7 @@ obj-$(CONFIG_PWM_ROCKCHIP)    += pwm-rockchip.o
>>   obj-$(CONFIG_PWM_SAMSUNG)      += pwm-samsung.o
>>   obj-$(CONFIG_PWM_SPEAR)                += pwm-spear.o
>>   obj-$(CONFIG_PWM_STI)          += pwm-sti.o
>> +obj-$(CONFIG_PWM_SUN4I)                += pwm-sun4i.o
>>   obj-$(CONFIG_PWM_TEGRA)                += pwm-tegra.o
>>   obj-$(CONFIG_PWM_TIECAP)       += pwm-tiecap.o
>>   obj-$(CONFIG_PWM_TIEHRPWM)     += pwm-tiehrpwm.o
>> diff --git a/drivers/pwm/pwm-sun4i.c b/drivers/pwm/pwm-sun4i.c
>> new file mode 100644
>> index 000000000000..cd9dde563018
>> --- /dev/null
>> +++ b/drivers/pwm/pwm-sun4i.c
>> @@ -0,0 +1,366 @@
>> +/*
>> + * Driver for Allwinner sun4i Pulse Width Modulation Controller
>> + *
>> + * Copyright (C) 2014 Alexandre Belloni <alexandre.belloni@free-electrons.com>
>> + *
>> + * Licensed under GPLv2.
>> + */
>> +
>> +#include <linux/bitops.h>
>> +#include <linux/clk.h>
>> +#include <linux/err.h>
>> +#include <linux/io.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/of_device.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/pwm.h>
>> +#include <linux/slab.h>
>> +#include <linux/spinlock.h>
>> +#include <linux/time.h>
>> +
>> +#define PWM_CTRL_REG           0x0
>> +
>> +#define PWM_CH_PRD_BASE                0x4
>> +#define PWM_CH_PRD_OFFSET      0x4
>> +#define PWM_CH_PRD(ch)         (PWM_CH_PRD_BASE + PWM_CH_PRD_OFFSET * (ch))
>> +
>> +#define PWMCH_OFFSET           15
>> +#define PWM_PRESCAL_MASK       GENMASK(3, 0)
>> +#define PWM_PRESCAL_OFF                0
>> +#define PWM_EN                 BIT(4)
>> +#define PWM_ACT_STATE          BIT(5)
>> +#define PWM_CLK_GATING         BIT(6)
>> +#define PWM_MODE               BIT(7)
>> +#define PWM_PULSE              BIT(8)
>> +#define PWM_BYPASS             BIT(9)
>> +
>> +#define PWM_RDY_BASE           28
>> +#define PWM_RDY_OFFSET         1
>> +#define PWM_RDY(ch)            BIT(PWM_RDY_BASE + PWM_RDY_OFFSET * (ch))
>> +
>> +#define PWM_PRD(prd)           (((prd) - 1) << 16)
>> +#define PWM_PRD_MASK           GENMASK(15, 0)
>> +
>> +#define PWM_DTY_MASK           GENMASK(15, 0)
>> +
>> +#define BIT_CH(bit, chan)      ((bit) << ((chan) * PWMCH_OFFSET))
>> +
>> +static const u32 prescaler_table[] = {
>> +       120,
>> +       180,
>> +       240,
>> +       360,
>> +       480,
>> +       0,
>> +       0,
>> +       0,
>> +       12000,
>> +       24000,
>> +       36000,
>> +       48000,
>> +       72000,
>> +       0,
>> +       0,
>> +       0, /* Actually 1 but tested separately */
>> +};
>> +
>> +struct sun4i_pwm_data {
>> +       bool has_prescaler_bypass;
>> +       bool has_rdy;
>> +};
>> +
>> +struct sun4i_pwm_chip {
>> +       struct pwm_chip chip;
>> +       struct clk *clk;
>> +       void __iomem *base;
>> +       spinlock_t ctrl_lock;
>> +       const struct sun4i_pwm_data *data;
>> +};
>> +
>> +static inline struct sun4i_pwm_chip *to_sun4i_pwm_chip(struct pwm_chip *chip)
>> +{
>> +       return container_of(chip, struct sun4i_pwm_chip, chip);
>> +}
>> +
>> +static inline u32 sun4i_pwm_readl(struct sun4i_pwm_chip *chip,
>> +                                 unsigned long offset)
>> +{
>> +       return readl(chip->base + offset);
>> +}
>> +
>> +static inline void sun4i_pwm_writel(struct sun4i_pwm_chip *chip,
>> +                                   u32 val, unsigned long offset)
>> +{
>> +       writel(val, chip->base + offset);
>> +}
>> +
>> +static int sun4i_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
>> +                           int duty_ns, int period_ns)
>> +{
>> +       struct sun4i_pwm_chip *sun4i_pwm = to_sun4i_pwm_chip(chip);
>> +       u32 prd, dty, val, clk_gate;
>> +       u64 clk_rate, div = 0;
>> +       unsigned int prescaler = 0;
>> +       int err;
>> +
>> +       clk_rate = clk_get_rate(sun4i_pwm->clk);
>> +
>> +       if (sun4i_pwm->data->has_prescaler_bypass) {
>> +               /* First, test without any prescaler when available */
>> +               prescaler = PWM_PRESCAL_MASK;
>> +               /*
>> +                * When not using any prescaler, the clock period in nanoseconds
>> +                * is not an integer so round it half up instead of
>> +                * truncating to get less surprising values.
>> +                */
>> +               div = clk_rate * period_ns + NSEC_PER_SEC/2;
>> +               do_div(div, NSEC_PER_SEC);
>> +               if (div - 1 > PWM_PRD_MASK)
>> +                       prescaler = 0;
>> +       }
>> +
>> +       if (prescaler == 0) {
>> +               /* Go up from the first divider */
>> +               for (prescaler = 0; prescaler < PWM_PRESCAL_MASK; prescaler++) {
>> +                       if (!prescaler_table[prescaler])
>> +                               continue;
>> +                       div = clk_rate;
>> +                       do_div(div, prescaler_table[prescaler]);
>> +                       div = div * period_ns;
>> +                       do_div(div, NSEC_PER_SEC);
>> +                       if (div - 1 <= PWM_PRD_MASK)
>> +                               break;
>> +               }
>> +
>> +               if (div - 1 > PWM_PRD_MASK) {
>> +                       dev_err(chip->dev, "period exceeds the maximum value\n");
>> +                       return -EINVAL;
>> +               }
>> +       }
>> +
>> +       prd = div;
>> +       div *= duty_ns;
>> +       do_div(div, period_ns);
>> +       dty = div;
>> +
>> +       err = clk_prepare_enable(sun4i_pwm->clk);
>> +       if (err) {
>> +               dev_err(chip->dev, "failed to enable PWM clock\n");
>> +               return err;
>> +       }
>> +
>> +       spin_lock(&sun4i_pwm->ctrl_lock);
>> +       val = sun4i_pwm_readl(sun4i_pwm, PWM_CTRL_REG);
>> +
>> +       if (sun4i_pwm->data->has_rdy && (val & PWM_RDY(pwm->hwpwm))) {
>> +               spin_unlock(&sun4i_pwm->ctrl_lock);
>> +               clk_disable_unprepare(sun4i_pwm->clk);
>> +               return -EBUSY;
>> +       }
>> +
>> +       clk_gate = val & BIT_CH(PWM_CLK_GATING, pwm->hwpwm);
>> +       if (clk_gate) {
>> +               val &= ~BIT_CH(PWM_CLK_GATING, pwm->hwpwm);
>> +               sun4i_pwm_writel(sun4i_pwm, val, PWM_CTRL_REG);
>> +       }
>> +
>> +       val = sun4i_pwm_readl(sun4i_pwm, PWM_CTRL_REG);
>> +       val &= ~BIT_CH(PWM_PRESCAL_MASK, pwm->hwpwm);
>> +       val |= BIT_CH(prescaler, pwm->hwpwm);
>> +       sun4i_pwm_writel(sun4i_pwm, val, PWM_CTRL_REG);
>> +
>> +       val = (dty & PWM_DTY_MASK) | PWM_PRD(prd);
>> +       sun4i_pwm_writel(sun4i_pwm, val, PWM_CH_PRD(pwm->hwpwm));
>> +
>> +       if (clk_gate) {
>> +               val = sun4i_pwm_readl(sun4i_pwm, PWM_CTRL_REG);
>> +               val |= clk_gate;
>> +               sun4i_pwm_writel(sun4i_pwm, val, PWM_CTRL_REG);
>> +       }
>> +
>> +       spin_unlock(&sun4i_pwm->ctrl_lock);
>> +       clk_disable_unprepare(sun4i_pwm->clk);
>> +
>> +       return 0;
>> +}
>> +
>> +static int sun4i_pwm_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
>> +                                 enum pwm_polarity polarity)
>> +{
>> +       struct sun4i_pwm_chip *sun4i_pwm = to_sun4i_pwm_chip(chip);
>> +       u32 val;
>> +       int ret;
>> +
>> +       ret = clk_prepare_enable(sun4i_pwm->clk);
>> +       if (ret) {
>> +               dev_err(chip->dev, "failed to enable PWM clock\n");
>> +               return ret;
>> +       }
>> +
>> +       spin_lock(&sun4i_pwm->ctrl_lock);
>> +       val = sun4i_pwm_readl(sun4i_pwm, PWM_CTRL_REG);
>> +
>> +       if (polarity != PWM_POLARITY_NORMAL)
>> +               val &= ~BIT_CH(PWM_ACT_STATE, pwm->hwpwm);
>> +       else
>> +               val |= BIT_CH(PWM_ACT_STATE, pwm->hwpwm);
>> +
>> +       sun4i_pwm_writel(sun4i_pwm, val, PWM_CTRL_REG);
>> +
>> +       spin_unlock(&sun4i_pwm->ctrl_lock);
>> +       clk_disable_unprepare(sun4i_pwm->clk);
>> +
>> +       return 0;
>> +}
>> +
>> +static int sun4i_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
>> +{
>> +       struct sun4i_pwm_chip *sun4i_pwm = to_sun4i_pwm_chip(chip);
>> +       u32 val;
>> +       int ret;
>> +
>> +       ret = clk_prepare_enable(sun4i_pwm->clk);
>> +       if (ret) {
>> +               dev_err(chip->dev, "failed to enable PWM clock\n");
>> +               return ret;
>> +       }
>> +
>> +       spin_lock(&sun4i_pwm->ctrl_lock);
>> +       val = sun4i_pwm_readl(sun4i_pwm, PWM_CTRL_REG);
>> +       val |= BIT_CH(PWM_EN, pwm->hwpwm);
>> +       val |= BIT_CH(PWM_CLK_GATING, pwm->hwpwm);
>> +       sun4i_pwm_writel(sun4i_pwm, val, PWM_CTRL_REG);
>> +       spin_unlock(&sun4i_pwm->ctrl_lock);
>> +
>> +       return 0;
>> +}
>> +
>> +static void sun4i_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
>> +{
>> +       struct sun4i_pwm_chip *sun4i_pwm = to_sun4i_pwm_chip(chip);
>> +       u32 val;
>> +
>> +       spin_lock(&sun4i_pwm->ctrl_lock);
>> +       val = sun4i_pwm_readl(sun4i_pwm, PWM_CTRL_REG);
>> +       val &= ~BIT_CH(PWM_EN, pwm->hwpwm);
>> +       val &= ~BIT_CH(PWM_CLK_GATING, pwm->hwpwm);
>> +       sun4i_pwm_writel(sun4i_pwm, val, PWM_CTRL_REG);
>> +       spin_unlock(&sun4i_pwm->ctrl_lock);
>> +
>> +       clk_disable_unprepare(sun4i_pwm->clk);
>> +}
>> +
>> +static const struct pwm_ops sun4i_pwm_ops = {
>> +       .config = sun4i_pwm_config,
>> +       .set_polarity = sun4i_pwm_set_polarity,
>> +       .enable = sun4i_pwm_enable,
>> +       .disable = sun4i_pwm_disable,
>> +       .owner = THIS_MODULE,
>> +};
>> +
>> +static const struct sun4i_pwm_data sun4i_pwm_data_a10 = {
>> +       .has_prescaler_bypass = false,
>> +       .has_rdy = false,
>> +};
>> +
>> +static const struct sun4i_pwm_data sun4i_pwm_data_a20 = {
>> +       .has_prescaler_bypass = true,
>> +       .has_rdy = true,
>> +};
>> +
>> +static const struct of_device_id sun4i_pwm_dt_ids[] = {
>> +       {
>> +               .compatible = "allwinner,sun4i-a10-pwm",
>> +               .data = &sun4i_pwm_data_a10,
>> +       }, {
>> +               .compatible = "allwinner,sun7i-a20-pwm",
>> +               .data = &sun4i_pwm_data_a20,
>> +       }, {
>> +               /* sentinel */
>> +       },
>> +};
>> +MODULE_DEVICE_TABLE(of, sun4i_pwm_dt_ids);
>> +
>> +static int sun4i_pwm_probe(struct platform_device *pdev)
>> +{
>> +       struct sun4i_pwm_chip *pwm;
>> +       struct resource *res;
>> +       u32 val;
>> +       int i, ret;
>> +       const struct of_device_id *match;
>> +
>> +       match = of_match_device(sun4i_pwm_dt_ids, &pdev->dev);
>> +
>> +       pwm = devm_kzalloc(&pdev->dev, sizeof(*pwm), GFP_KERNEL);
>> +       if (!pwm)
>> +               return -ENOMEM;
>> +
>> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +       pwm->base = devm_ioremap_resource(&pdev->dev, res);
>> +       if (IS_ERR(pwm->base))
>> +               return PTR_ERR(pwm->base);
>> +
>> +       pwm->clk = devm_clk_get(&pdev->dev, NULL);
>> +       if (IS_ERR(pwm->clk))
>> +               return PTR_ERR(pwm->clk);
>> +
>> +       pwm->chip.dev = &pdev->dev;
>> +       pwm->chip.ops = &sun4i_pwm_ops;
>> +       pwm->chip.base = -1;
>> +       pwm->chip.npwm = 2;
>> +       pwm->chip.can_sleep = true;
>> +       pwm->chip.of_xlate = of_pwm_xlate_with_flags;
>> +       pwm->chip.of_pwm_n_cells = 3;
>> +       pwm->data = match->data;
>> +
>> +       spin_lock_init(&pwm->ctrl_lock);
>> +
>> +       ret = pwmchip_add(&pwm->chip);
>> +       if (ret < 0) {
>> +               dev_err(&pdev->dev, "failed to add PWM chip: %d\n", ret);
>> +               return ret;
>> +       }
>> +
>> +       platform_set_drvdata(pdev, pwm);
>> +
>> +       ret = clk_prepare_enable(pwm->clk);
>> +       if (ret) {
>> +               dev_err(&pdev->dev, "failed to enable PWM clock\n");
>> +               goto clk_error;
>> +       }
>> +
>> +       val = sun4i_pwm_readl(pwm, PWM_CTRL_REG);
>> +       for (i = 0; i < pwm->chip.npwm; i++)
>> +               if (!(val & BIT_CH(PWM_ACT_STATE, i)))
>> +                       pwm->chip.pwms[i].polarity = PWM_POLARITY_INVERSED;
>> +       clk_disable_unprepare(pwm->clk);
>> +
>> +       return 0;
>> +
>> +clk_error:
>> +       pwmchip_remove(&pwm->chip);
>> +       return ret;
>> +}
>> +
>> +static int sun4i_pwm_remove(struct platform_device *pdev)
>> +{
>> +       struct sun4i_pwm_chip *pwm = platform_get_drvdata(pdev);
>> +
>> +       return pwmchip_remove(&pwm->chip);
>> +}
>> +
>> +static struct platform_driver sun4i_pwm_driver = {
>> +       .driver = {
>> +               .name = "sun4i-pwm",
>> +               .of_match_table = sun4i_pwm_dt_ids,
>> +       },
>> +       .probe = sun4i_pwm_probe,
>> +       .remove = sun4i_pwm_remove,
>> +};
>> +module_platform_driver(sun4i_pwm_driver);
>> +
>> +MODULE_ALIAS("platform:sun4i-pwm");
>> +MODULE_AUTHOR("Alexandre Belloni <alexandre.belloni@free-electrons.com>");
>> +MODULE_DESCRIPTION("Allwinner sun4i PWM driver");
>> +MODULE_LICENSE("GPL v2");
>> --
>> 2.1.0
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel


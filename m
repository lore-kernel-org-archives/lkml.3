Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab3LRX4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 18:56:18 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:42809 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab3LRX4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 18:56:16 -0500
X-IronPort-AV: E=Sophos;i="4.95,510,1384329600"; 
   d="scan'208";a="3898185"
Message-ID: <52B23618.2040508@broadcom.com>
Date: Wed, 18 Dec 2013 15:56:08 -0800
From: Sherman Yin <syin@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>, Mark Brown <broonie@kernel.org>
CC: Rob Herring <rob.herring@calxeda.com>,
        =?ISO-8859-1?Q?Heiko_St=FCbn?= =?ISO-8859-1?Q?er?= 
	<heiko@sntech.de>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 5/6] ARM: pinctrl: Add Broadcom Capri pinctrl driver
References: <1381174108-25168-1-git-send-email-syin@broadcom.com>	<1386787041-6035-1-git-send-email-syin@broadcom.com>	<1386787041-6035-6-git-send-email-syin@broadcom.com> <CACRpkdaeZCodKv6R+4ZS3o-5u=QQuV3JidEp7uaLsN9aYG7bqA@mail.gmail.com>
In-Reply-To: <CACRpkdaeZCodKv6R+4ZS3o-5u=QQuV3JidEp7uaLsN9aYG7bqA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-12-12 12:54 PM, Linus Walleij wrote:
>> +#define CAPRI_PIN_SHIFT(type, param) \
>> +       (CAPRI_ ## type ## _PIN_REG_ ## param ## _SHIFT)
>> +
>> +#define CAPRI_PIN_MASK(type, param) \
>> +       (CAPRI_ ## type ## _PIN_REG_ ## param ## _MASK)
>> +
>> +/* Macro to update reg with new pin config param */
>> +#define CAPRI_PIN_UPDATE(reg, type, param, val)                                \
>> +       (((reg) & ~CAPRI_PIN_MASK(type, param)) |                       \
>> +       (((val) << CAPRI_PIN_SHIFT(type, param)) & CAPRI_PIN_MASK(type, param)))
>
> Yuck! Are you sure you cannot convert these to static inlines and
> make them much simpler in the process?
>
> We do have an optimizing compiler, you don't need to do
> everything on one line... besides we're not on the hotpath.

If I were to convert the first 2 #defines to functions, it would either 
be a 2-level switch statement or a 2D lookup table.  IMO both of these 
options are more difficult to read than this simple concatenation, so I 
really rather keep them this way.

CAPRI_PIN_UPDATE, OTOH, doesn't require any concatenation so I can 
easily make that into an inline.

>
>> +/*
>> + * Write to the register using the value and mask if current value is different
>> + */
>> +static void capri_reg_write(struct pinctrl_dev *pctldev,
>> +                           void __iomem *reg,
>> +                           u32 val,
>> +                           u32 mask)
>> +{
>> +       u32 old_val;
>> +       u32 new_val;
>> +
>> +       old_val = readl(reg);
>> +       new_val = (old_val & ~mask) | (val & mask);
>> +
>> +       if (new_val == old_val) {
>> +               dev_dbg(pctldev->dev,
>> +                       "Reg 0x%p=0x%x (no change)\n",
>> +                       reg, old_val);
>> +               return;
>> +       }
>> +
>> +       dev_dbg(pctldev->dev,
>> +               "Reg 0x%p change from 0x%x to 0x%x\n",
>> +               reg, old_val, new_val);
>> +       writel(new_val, reg);
>> +}
>
> This is a reimplementation of regmap for MMIO.
> See drivers/base/regmap/regmap-mmio.c
> Notice how regmap_update_bits() is used throughout the
> kernel.
>
> If you want to do this, use regmap.

Ok.

>
>> +               case PIN_CONFIG_DRIVE_STRENGTH:
>> +                       /* Valid range is 2-16 mA, even numbers only */
>> +                       if ((arg < 2) || (arg > 16) || (arg % 2)) {
>> +                               dev_err(pctldev->dev,
>> +                                       "Invalid Drive Strength value (%d) for "
>> +                                       "pin %s (%d). Valid values are "
>> +                                       "(2..16) mA, even numbers only.\n",
>> +                                       arg, pdata->pins[pin].name, pin);
>> +                               return -EINVAL;
>> +                       }
>> +                       *val = CAPRI_PIN_UPDATE(*val, STD, DRV_STR, (arg/2)-1);
>> +                       *mask |= CAPRI_STD_PIN_REG_DRV_STR_MASK;
>> +                       break;
>
> Hm rather nice integer math...

Sorry, I can't tell if you are being sarcastic :)  Drive strength is 
represented by 3 bits in the register.  If the values were 2-14 I could 
have done some bit-checking instead of those 3 conditions in the if 
statement.  Or, if we use a enum of 0-7 then the check is much easier. 
But as we discussed re: pull-up resistance, we rather let users specify 
real numbers.  The (arg/2)-1 is just to convert the mA into the 3 bits.

>> +/* Goes through the configs and update register val/mask */
>> +static int capri_i2c_pin_update(struct pinctrl_dev *pctldev,
>> +                               unsigned pin,
>> +                               unsigned long *configs,
>> +                               unsigned num_configs,
>> +                               u32 *val,
>> +                               u32 *mask)
>> +{
>> +       struct capri_pinctrl_data *pdata = pinctrl_dev_get_drvdata(pctldev);
>> +       int i;
>> +       enum pin_config_param param;
>> +       u16 arg;
>> +
>> +       for (i = 0; i < num_configs; i++) {
>> +               param = pinconf_to_config_param(configs[i]);
>> +               arg = pinconf_to_config_argument(configs[i]);
>> +
>> +               switch (param) {
>> +               case PIN_CONFIG_BIAS_PULL_UP:
>> +                       if ((arg < 1) || (arg > 7)) {
>> +                               dev_err(pctldev->dev,
>> +                                       "Invalid Pull Up value (%d) for pin %s "
>> +                                       "(%d). Valid values are (1..7).\n",
>> +                                       arg, pdata->pins[pin].name, pin);
>> +                               return -EINVAL;
>> +                       }
>
> No don't do that as mentioned in the other patch. Pass pull up strength
> in Ohms.
>
> Then have a translation table here, and do some best-effort fuzzy match.

Sure.  I'm just going to error out if the user-supplied value is off, 
since it is very clear what is acceptable from the binding documentation.

>> +       /* Different pins have different configuration options */
>> +       switch (pin_type) {
>> +       case CAPRI_PIN_TYPE_STD:
>> +               rc = capri_std_pin_update(pctldev, pin, configs, num_configs,
>> +                       &cfg_val, &cfg_mask);
>> +               break;
>> +
>> +       case CAPRI_PIN_TYPE_I2C:
>> +               rc = capri_i2c_pin_update(pctldev, pin, configs, num_configs,
>> +                       &cfg_val, &cfg_mask);
>> +               break;
>> +
>> +       case CAPRI_PIN_TYPE_HDMI:
>> +               rc = capri_hdmi_pin_update(pctldev, pin, configs, num_configs,
>> +                       &cfg_val, &cfg_mask);
>> +               break;
>
> This is really nice and elegant.

Thanks. :)

Regards,
Sherman

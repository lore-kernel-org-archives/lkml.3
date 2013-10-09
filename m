Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970Ab3JIJK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 05:10:26 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:46017 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab3JIJKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 05:10:23 -0400
MIME-Version: 1.0
In-Reply-To: <1380846199-12829-4-git-send-email-syin@broadcom.com>
References: <1380846199-12829-1-git-send-email-syin@broadcom.com>
	<1380846199-12829-4-git-send-email-syin@broadcom.com>
Date: Wed, 9 Oct 2013 11:10:22 +0200
Message-ID: <CACRpkdZah4fFuJL2Vh5JmbBCgnekg8MKqMWHzeheOx3N1Kzwng@mail.gmail.com>
Subject: Re: [PATCH 3/4] ARM: pinctrl: Add Broadcom Capri pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Sherman Yin <syin@broadcom.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bcm-kernel-feedback-list@broadcom.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 4, 2013 at 2:23 AM, Sherman Yin <syin@broadcom.com> wrote:

> Adds pinctrl driver for Broadcom Capri (BCM281xx) SoCs.
>
> Signed-off-by: Sherman Yin <syin@broadcom.com>
> Reviewed-by: Christian Daudt <bcm@fixthebug.org>
> Reviewed-by: Matt Porter <matt.porter@linaro.org>
(...)

> +config PINCTRL_CAPRI
> +       bool "Broadcom Capri pinctrl driver"
> +       select PINMUX
> +       select PINCONF
> +       help
> +         Say Y here to support Broadcom Capri pinctrl driver, which is used for
> +         the BCM281xx SoC family, including BCM11130, BCM11140, BCM11351,
> +         BCM28145, and BCM28155 SoCs.  This driver requires the pinctrl
> +         framework.  GPIO is provided by a separate GPIO driver.

As mentioned this should be selecting and using GENERIC_PINCONF.
Basically I want that to happen before we look further at this code.

(But I'll take a quick glance anyway...)

> +#define CAPRI_PINCONF_PACK(val, mask)     (((val) << 16) | ((mask) & 0xffff))
> +#define CAPRI_PINCONF_UNPACK_VAL(conf)    ((conf) >> 16)
> +#define CAPRI_PINCONF_UNPACK_MASK(conf)   ((conf) & 0xffff)

This custom horror goes away by using the macros from genric pin config
<linux/pinctrl/pinconf-generic.h> instead.

> +static const struct capri_cfg_param capri_pinconf_params[] = {
> +       {"brcm,hysteresis",     CAPRI_PINCONF_PARAM_HYST},
> +       {"brcm,pull",           CAPRI_PINCONF_PARAM_PULL},
> +       {"brcm,slew",           CAPRI_PINCONF_PARAM_SLEW},
> +       {"brcm,input_dis",      CAPRI_PINCONF_PARAM_INPUT_DIS},
> +       {"brcm,drive_str",      CAPRI_PINCONF_PARAM_DRV_STR},
> +       {"brcm,pull_up_str",    CAPRI_PINCONF_PARAM_PULL_UP_STR},
> +       {"brcm,mode",           CAPRI_PINCONF_PARAM_MODE},
> +};

As well as all this stuff...

> +/* Standard pin register */

Add some more elaborate explanation here. I am half-guessing that
most of the registers are laid out like this and then there are
two exceptions, then write that right here in the comment.

(BTW: this is a HW/driver detail and should not be written in the
device tree doc as was done in patch 2)

> +/* Macro to update reg with new pin config param */
> +#define CAPRI_PIN_REG_SET(reg, type, param, val)                       \
> +       (((reg) & ~CAPRI_ ## type ## _PIN_REG_ ## param ## _MASK)       \
> +       | (((val) << CAPRI_ ## type ## _PIN_REG_ ## param ## _SHIFT)    \
> +       & CAPRI_ ## type ## _PIN_REG_ ## param ## _MASK))

No thanks.

Rewrite this into a static inline which has the same effect when
compiling, but produces *WAY* more readable code than this
horrid thing. Plus you can type the arguments.

> +#define _PIN(offset)                   (offset)

This macro isn't exactly useful.

> +/*
> + * Pin number definition.  The order here must be the same as defined in the
> + * PADCTRLREG block in the RDB.
> + */
> +#define CAPRI_PIN_ADCSYNC              _PIN(0)

If it's just going to be like that, then skip the _PIN() macro.

> +/* Process the pin configuration node */
> +static int capri_pinctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
> +                                       struct device_node *pnode,
> +                                       struct pinctrl_map **map,
> +                                       unsigned *nmaps)
> +{

Make use of these from pinctrl-utils.c:
pinctrl_utils_reserve_map()
pinctrl_utils_add_map_mux()
pinctrl_utils_add_map_configs()
pinctrl_utils_dt_free_map()

Then you get rid of another big chunk of boilerplate code.

After these changes the driver will be much smaller and
cleaner and we can take a closer look.

Yours,
Linus Walleij

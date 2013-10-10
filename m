Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab3JJXs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 19:48:28 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1223 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123Ab3JJXs0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 19:48:26 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
From: "Sherman Yin" <syin@broadcom.com>
To: "Linus Walleij" <linus.walleij@linaro.org>
cc: "Rob Herring" <rob.herring@calxeda.com>, "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Rob Landley" <rob@landley.net>, "Christian Daudt" <bcm@fixthebug.org>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Grant Likely" <grant.likely@linaro.org>,
        "Matt Porter" <matt.porter@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 3/4] ARM: pinctrl: Add Broadcom Capri pinctrl driver
Thread-Topic: [PATCH 3/4] ARM: pinctrl: Add Broadcom Capri pinctrl
 driver
Thread-Index: AQHOwJjvlt3ZyknjmUucDC303MwucJnskuoAgAHzuwA=
Date: Thu, 10 Oct 2013 23:48:15 +0000
Message-ID: <051069C10411E24D9749790C498526FA1BE027EA@SJEXCHMB12.corp.ad.broadcom.com>
References: <1380846199-12829-1-git-send-email-syin@broadcom.com>
 <1380846199-12829-4-git-send-email-syin@broadcom.com>
 <CACRpkdZah4fFuJL2Vh5JmbBCgnekg8MKqMWHzeheOx3N1Kzwng@mail.gmail.com>
In-Reply-To: <CACRpkdZah4fFuJL2Vh5JmbBCgnekg8MKqMWHzeheOx3N1Kzwng@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.203.100]
MIME-Version: 1.0
X-WSS-ID: 7E49E3371R099440978-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +config PINCTRL_CAPRI
>> +       bool "Broadcom Capri pinctrl driver"
>> +       select PINMUX
>> +       select PINCONF
>> +       help
>> +         Say Y here to support Broadcom Capri pinctrl driver, which is used for
>> +         the BCM281xx SoC family, including BCM11130, BCM11140, BCM11351,
>> +         BCM28145, and BCM28155 SoCs.  This driver requires the pinctrl
>> +         framework.  GPIO is provided by a separate GPIO driver.
>
>As mentioned this should be selecting and using GENERIC_PINCONF.
>Basically I want that to happen before we look further at this code.
>
>(But I'll take a quick glance anyway...)

Sure, working on it.

>> +#define CAPRI_PINCONF_PACK(val, mask)     (((val) << 16) | ((mask) & 0xffff))
>> +#define CAPRI_PINCONF_UNPACK_VAL(conf)    ((conf) >> 16)
>> +#define CAPRI_PINCONF_UNPACK_MASK(conf)   ((conf) & 0xffff)
>
>This custom horror goes away by using the macros from genric pin config
><linux/pinctrl/pinconf-generic.h> instead.

Actually these are used differently than the pack/unpack functions in the pinconf-
generic.h.  These pack the bit value and bit mask to be written to a register,
whereas the pinconf-generic ones pack the parameter id and value.  But I get what
you're saying and will try to reuse as much as possible from the pinconf generic
functions and utils.

>> +static const struct capri_cfg_param capri_pinconf_params[] = {
>> +       {"brcm,hysteresis",     CAPRI_PINCONF_PARAM_HYST},
>> +       {"brcm,pull",           CAPRI_PINCONF_PARAM_PULL},
>> +       {"brcm,slew",           CAPRI_PINCONF_PARAM_SLEW},
>> +       {"brcm,input_dis",      CAPRI_PINCONF_PARAM_INPUT_DIS},
>> +       {"brcm,drive_str",      CAPRI_PINCONF_PARAM_DRV_STR},
>> +       {"brcm,pull_up_str",    CAPRI_PINCONF_PARAM_PULL_UP_STR},
>> +       {"brcm,mode",           CAPRI_PINCONF_PARAM_MODE},
>> +};
>
>As well as all this stuff...

OK.  Will see if I can find something suitable for "input disable" and "mode"

>> +/* Standard pin register */
>
>Add some more elaborate explanation here. I am half-guessing that
>most of the registers are laid out like this and then there are
>two exceptions, then write that right here in the comment.
>
>(BTW: this is a HW/driver detail and should not be written in the
>device tree doc as was done in patch 2)

Yes you guessed correctly.  Most of the pin have bit-field definitions like
the "standard" or "std" pin register.  There are 12 pins that have the i2c
definitions, and 2 pins that have the hdmi definitions.  Will add
explanation to the code.

However, I wanted to explain this in the DT doc as well because, for example,
setting a slew rate for an hdmi pin would be invalid.

>> +/* Macro to update reg with new pin config param */
>> +#define CAPRI_PIN_REG_SET(reg, type, param, val)                       \
>> +       (((reg) & ~CAPRI_ ## type ## _PIN_REG_ ## param ## _MASK)       \
>> +       | (((val) << CAPRI_ ## type ## _PIN_REG_ ## param ## _SHIFT)    \
>> +       & CAPRI_ ## type ## _PIN_REG_ ## param ## _MASK))
>
>No thanks.
>
>Rewrite this into a static inline which has the same effect when
>compiling, but produces *WAY* more readable code than this
>horrid thing. Plus you can type the arguments.

Ok.  The reason I used a macro is to take shortcuts given how the SHIFT
and MASK #defines follow the format 

CAPRI_<pin type>_PIN_REG_<parameter name>_<mask or shift>

I'll try to simply this.

>> +#define _PIN(offset)                   (offset)
>
>This macro isn't exactly useful.
>
>> +/*
>> + * Pin number definition.  The order here must be the same as defined in the
>> + * PADCTRLREG block in the RDB.
>> + */
>> +#define CAPRI_PIN_ADCSYNC              _PIN(0)
>
>If it's just going to be like that, then skip the _PIN() macro.

Removed.  Was following pinctrl-tegra20.c where they have the _GPIO and _PIN
macros.  I guess it would be useful if we need to change the order of the enums
in the future, but that's not the case at the moment for capri. 

>> +/* Process the pin configuration node */
>> +static int capri_pinctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
>> +                                       struct device_node *pnode,
>> +                                       struct pinctrl_map **map,
>> +                                       unsigned *nmaps)
>> +{
>
>Make use of these from pinctrl-utils.c:
>pinctrl_utils_reserve_map()
>pinctrl_utils_add_map_mux()
>pinctrl_utils_add_map_configs()
>pinctrl_utils_dt_free_map()
>
>Then you get rid of another big chunk of boilerplate code.
>
>After these changes the driver will be much smaller and
>cleaner and we can take a closer look.

Yea actually the generic code is similar to what I have, there are some
differences in terms of pre-allocating / re-allocating the pinctrl_maps.
Seems like there are very few users of these functions at the moment.
Anyway I'll try to make use of them.

Thanks for the review.

Regards,
Sherman


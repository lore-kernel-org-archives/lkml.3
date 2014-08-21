Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbaHUGQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 02:16:18 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:9687 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750960AbaHUGQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 02:16:16 -0400
Date: Wed, 20 Aug 2014 23:16:09 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 4/6] pinctrl: Qualcomm SPMI PMIC pin controller driver
Message-ID: <20140821061607.GF16274@sonymobile.com>
References: <1407771634-14946-1-git-send-email-iivanov@mm-sol.com>
 <1407771634-14946-5-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1407771634-14946-5-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 11 Aug 08:40 PDT 2014, Ivan T. Ivanov wrote:

> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> This is the pinctrl, pinmux, pinconf and gpiolib driver for the
> Qualcomm GPIO and MPP sub-function blocks found in the PMIC chips.
> 

Hi Ivan,

I'm not very fond of the mixing of gpio and mpp in the same driver, there are
so many places where you have extra complexity to handle the fact that both are
handled in the same code paths.

Also, magic constans aren't good, but with all the shifts and maskes used
throughout this driver it's really difficult to follow the code. A lot of this
complexity comes from the fact that you're using regmap_update_bits(), so you
have to have those masks and shifts everywhere.

As you saw I solved this by keeping track of the various properties set by the
driver, another way could be to have a register shadow that you update and
flush - it would save you from the attrs-game in pinconf set/get.


Please find some detailed commends inline.

> diff --git a/drivers/pinctrl/qcom/pinctrl-spmi-pmic.c b/drivers/pinctrl/qcom/pinctrl-spmi-pmic.c

[...]

> +/*
> + * Voltage select (GPIO, MPP) - specifies the voltage level when the output
> + * is set to 1. For an input GPIO specifies the voltage level at which
> + * the input is interpreted as a logical 1
> + * To be used with "power-func = <>"
> + */

This comment doesn't really have anything to do with the two defines here.

> +#define QPNP_PIN_VIN_4CH_INVALID               5
> +#define QPNP_PIN_VIN_8CH_INVALID               8

So for a 8 channel gpio we can select 0-7 and for a 4 channel gpio we can use
selector 0-4? Please rename these QPNP_PIN_4CH_MAX_VIN or LAST_VIN.

> +
> +/*
> + * Analog Output - Set the analog output reference.
> + * See PM8XXX_MPP_AOUT_XXX. To be used with "qcom,aout = <>"
> + */

This comment is related to the define, but not really explaining anything. As
with the VIN I think this should be named to indicate that this is a max.

> +#define QPNP_MPP_AOUT_INVALID                  8
> +
> +/*
> + * Analog Input - Set the func for analog input.
> + * See PM8XXX_MPP_AIN_XXX. To be used with "qcom,ain = <>"
> + */
> +#define QPNP_MPP_AIN_INVALID                   8

Same thing here, comment is only somewhat related and the name should be changed.

> +
> +/*
> + * Output type - indicates pin should be configured as CMOS or
> + * open drain.
> + */

Please update the comment for match the defines.

> +#define QPNP_GPIO_OUT_BUF_CMOS                 0
> +#define QPNP_GPIO_OUT_BUF_OPEN_DRAIN_NMOS      1
> +#define QPNP_GPIO_OUT_BUF_OPEN_DRAIN_PMOS      2

[...]

> +/* Out Strength (GPIO) - the amount of current supplied for an output GPIO */
> +#define QPNP_GPIO_STRENGTH_LOW                 1
> +#define QPNP_GPIO_STRENGTH_MED                 2
> +#define QPNP_GPIO_STRENGTH_HIGH                        3

You could use these straight off qcom,pmic-gpio.h instead of duplicating them here.

> +
> +/*
> + * Master enable (GPIO, MPP) - Enable features within the pin block based on
> + * configurations. QPNP_PIN_MASTER_DISABLE = Completely disable the pin
> + * lock and let the pin float with high impedance regardless of other settings.
> + */
> +#define QPNP_PIN_MASTER_DISABLE                 0
> +#define QPNP_PIN_MASTER_ENABLE                 1

You only need one of these.

> +
> +/* revision registers base address offsets */
> +#define QPNP_REG_DIG_MINOR_REV                 0x0
> +#define QPNP_REG_DIG_MAJOR_REV                 0x1
> +#define QPNP_REG_ANA_MINOR_REV                 0x2

Only QPNP_REG_DIG_MAJOR_REV is used, please drop the others.

> +/* control register base address offsets */
> +#define QPNP_REG_MODE_CTL                      0x40
> +#define QPNP_REG_DIG_VIN_CTL                   0x41
> +#define QPNP_REG_DIG_PULL_CTL                  0x42
> +#define QPNP_REG_DIG_IN_CTL                    0x43

REG_DIG_IN is unused

> +#define QPNP_PIN_PHYSICAL_OFFSET               1

If you just assign the of_node to the gpio_chip and then call
gpiochip_add_pin_range(_, _, 1, 0, _) this will give you the off-by-one you're
looking for.

> +struct qpnp_padinfo {
> +       u16 offset;             /* address offset in SPMI device */

I would suggesting a rename to "base" or something, as this will not be an
offset but rather the absolute address in this spmi device's address space.

> +       int irq;
> +       const char *name;       /* pin name */

This is redundant, as you already have this in the pinctrl_pin_desc.

> +       unsigned int modes;     /* supported modes: DI, DO, DIO, AI, AO... */
> +       unsigned int type;      /* peripheral hardware type */
> +       unsigned int subtype;   /* peripheral hardware subtype */
> +       unsigned int major;     /* digital major version */
> +};
> +
> +#define QPNP_REG_ADDR(pad, reg) ((pad)->offset + reg)

This is always followed by either regmap_read() or regmap_update_bits(), create
two static functions abstracting that construct away.

> +#define QPNP_GET(buff, shift, mask) ((buff & mask) >> shift)

I don't like the name of this macro, it doesn't "get" anything, it simply hides
the shifting and masking.

> +
> +struct qpnp_pinctrl {
> +       struct device *dev;
> +       struct regmap *map;
> +       struct pinctrl_dev *ctrl;
> +       struct pinctrl_desc desc;
> +       struct gpio_chip chip;
> +
> +       struct qpnp_padinfo *pads;

As Linus commented on my code, you shouldn't have a list of pads here, you
should reference them via desc.pins[x].drv_data

> +       const struct qpnp_chipinfo *info;

'info' is only used during probe, no reason to keep a pointer around.

> +       const char *const *groups;
> +       const char *const *functions;
> +};
> +
> +static inline struct qpnp_pinctrl *to_qpnp_pinctrl(struct gpio_chip *chip)
> +{
> +       return container_of(chip, struct qpnp_pinctrl, chip);
> +};

I see little point in breaking out the container_of into its own function.

> +
> +struct qpnp_pinbindings {
> +       const char *property;
> +       unsigned param;
> +       u32 default_value;

Consider dropping default_value as it's not used in your code (always 0).

> +};
> +
> +struct qpnp_pinattrib {

Not really "pin attributes", rather "io tasks" or something.

> +       unsigned addr;
> +       unsigned shift;
> +       unsigned mask;
> +       unsigned val;
> +};
> +
> +static struct qpnp_pinbindings qpnp_pinbindings[] = {

The commends in this list doesn't really add any value.

> +       /* QCOM_BIAS_PULL_UP_30...  */
> +       {"qcom,pull-up-strength", QPNP_PINCONF_PULL_UP, 0},
> +       /* QCOM_DRIVE_STRENGTH_NO... */
> +       {"qcom,drive-strength", QPNP_PINCONF_STRENGTH, 0},
> +       /* PMIC_MPP_AMUX_ROUTE_CH5 ... */
> +       {"qcom,amux-route",     QPNP_PINCONF_AMUX_ROUTE, 0},
> +       /* PMIC_MPP_VREFERENCE_1V25 ... */
> +       {"qcom,vrefence",       QPNP_PINCONF_VREFENCE, 0},
> +       /* PMIC_MPP_MODE.. */
> +       {"qcom,mode",           QPNP_PINCONF_MODE, 0},
> +};
> +

[...]

> +
> +static inline struct qpnp_padinfo *qpnp_get_desc(struct qpnp_pinctrl *qctrl,
> +                                                unsigned pin)
> +{
> +       if (pin >= qctrl->desc.npins) {
> +               dev_warn(qctrl->dev, "invalid pin number %d", pin);
> +               return NULL;
> +       }
> +
> +       return &qctrl->pads[pin];
> +}

Unless you initialize the pinctrl incorrectly this should never fail. So I
think you can safely inline the &qctrl->pads[pin]; in the various places you
need it.

> +
> +static int qpnp_conv_to_pin(struct qpnp_pinctrl *qctrl,
> +                          struct qpnp_padinfo *pad, unsigned param,
> +                          unsigned val)

This is not a good name for a "setter" function.

> +{
> +       struct qpnp_pinattrib attr[3];
> +       unsigned int type, subtype;
> +       int nattrs = 1, idx, ret;

s/idx/i/

> +
> +       type = pad->type;
> +       subtype = pad->subtype;
> +
> +       switch (param) {
> +       case PIN_CONFIG_DRIVE_PUSH_PULL:
> +               if (type != QPNP_GPIO_TYPE)
> +                       return -ENXIO;

Why is this return code different? Shouldn't this just be -EINVAL as you get
for any other "invalid param"?

> +               attr[0].addr  = QPNP_REG_DIG_OUT_CTL;
> +               attr[0].shift = QPNP_REG_OUT_TYPE_SHIFT;
> +               attr[0].mask  = QPNP_REG_OUT_TYPE_MASK;
> +               attr[0].val   = QPNP_GPIO_OUT_BUF_CMOS;
> +               break;
> +       case PIN_CONFIG_DRIVE_OPEN_DRAIN:
> +               if (type != QPNP_GPIO_TYPE)
> +                       return -ENXIO;

dito

> +               if (subtype == QPNP_GPIO_SUBTYPE_GPIOC_4CH ||
> +                   subtype == QPNP_GPIO_SUBTYPE_GPIOC_8CH)
> +                       return -EINVAL;
> +               attr[0].addr  = QPNP_REG_DIG_OUT_CTL;
> +               attr[0].shift = QPNP_REG_OUT_TYPE_SHIFT;
> +               attr[0].mask  = QPNP_REG_OUT_TYPE_MASK;
> +               attr[0].val   = QPNP_GPIO_OUT_BUF_OPEN_DRAIN_NMOS;
> +               break;
> +       case PIN_CONFIG_DRIVE_OPEN_SOURCE:
> +               if (type != QPNP_GPIO_TYPE)
> +                       return -ENXIO;

dito

> +               if (subtype == QPNP_GPIO_SUBTYPE_GPIOC_4CH ||
> +                   subtype == QPNP_GPIO_SUBTYPE_GPIOC_8CH)
> +                       return -EINVAL;
> +               attr[0].addr  = QPNP_REG_DIG_OUT_CTL;
> +               attr[0].shift = QPNP_REG_OUT_TYPE_SHIFT;
> +               attr[0].mask  = QPNP_REG_OUT_TYPE_MASK;
> +               attr[0].val   = QPNP_GPIO_OUT_BUF_OPEN_DRAIN_PMOS;
> +               break;
> +       case PIN_CONFIG_BIAS_DISABLE:
> +               attr[0].addr  = QPNP_REG_DIG_PULL_CTL;
> +               attr[0].shift = QPNP_REG_PULL_SHIFT;
> +               attr[0].mask  = QPNP_REG_PULL_MASK;
> +               if (type == QPNP_GPIO_TYPE)
> +                       attr[0].val = QPNP_GPIO_PULL_NO;
> +               else
> +                       attr[0].val = QPNP_MPP_PULL_UP_OPEN;
> +               break;
> +       case PIN_CONFIG_BIAS_PULL_UP:
> +               if (type != QPNP_MPP_TYPE)
> +                       return -EINVAL;

The binding documentation says that it's okay to just state "bias-pull-up" and
it will be configured as 30uA pull up. I would like us to keep the binding
documentation as it is now, but then you need to handle that here.

> +               switch (val) {
> +               case 0:
> +                       val = QPNP_MPP_PULL_UP_OPEN;
> +                       break;
> +               case 600:
> +                       val = QPNP_MPP_PULL_UP_0P6KOHM;
> +                       break;
> +               case 10000:
> +                       val = QPNP_MPP_PULL_UP_10KOHM;
> +                       break;
> +               case 30000:
> +                       val = QPNP_MPP_PULL_UP_30KOHM;
> +                       break;
> +               default:
> +                       return -EINVAL;
> +               }
> +               attr[0].addr  = QPNP_REG_DIG_PULL_CTL;
> +               attr[0].shift = QPNP_REG_PULL_SHIFT;
> +               attr[0].mask  = QPNP_REG_PULL_MASK;
> +               attr[0].val   = val;
> +               break;
> +       case PIN_CONFIG_BIAS_PULL_DOWN:
> +               if (type != QPNP_GPIO_TYPE)
> +                       return -EINVAL;
> +               attr[0].addr  = QPNP_REG_DIG_PULL_CTL;
> +               attr[0].shift = QPNP_REG_PULL_SHIFT;
> +               attr[0].mask  = QPNP_REG_PULL_MASK;
> +               if (val)
> +                       attr[0].val = QPNP_GPIO_PULL_DN;
> +               else
> +                       attr[0].val = QPNP_GPIO_PULL_NO;
> +               break;
> +       case PIN_CONFIG_POWER_SOURCE:
> +               if (val >= QPNP_PIN_VIN_8CH_INVALID)
> +                       return -EINVAL;
> +               if (val >= QPNP_PIN_VIN_4CH_INVALID) {
> +                       if (type == QPNP_GPIO_TYPE &&
> +                          (subtype == QPNP_GPIO_SUBTYPE_GPIO_4CH ||
> +                           subtype == QPNP_GPIO_SUBTYPE_GPIOC_4CH))
> +                               return -EINVAL;
> +                       if (type == QPNP_MPP_TYPE &&
> +                          (subtype == QPNP_MPP_SUBTYPE_4CH_NO_ANA_OUT ||
> +                           subtype == QPNP_MPP_SUBTYPE_4CH_NO_SINK ||
> +                           subtype == QPNP_MPP_SUBTYPE_4CH_FULL_FUNC ||
> +                           subtype == QPNP_MPP_SUBTYPE_ULT_4CH_NO_ANA_OUT ||
> +                           subtype == QPNP_MPP_SUBTYPE_ULT_4CH_NO_SINK))
> +                               return -EINVAL;
> +               }

Maybe better to keep track of the number of channels a pad has, and compare
with that. Would replace all 4 if statements with 1 here.

> +               attr[0].addr  = QPNP_REG_DIG_VIN_CTL;
> +               attr[0].shift = QPNP_REG_VIN_SHIFT;
> +               attr[0].mask  = QPNP_REG_VIN_MASK;
> +               attr[0].val   = val;
> +               break;
> +       case PIN_CONFIG_DRIVE_STRENGTH:
> +               if (type != QPNP_MPP_TYPE)
> +                       return -EINVAL;
> +               if (subtype == QPNP_MPP_SUBTYPE_4CH_NO_SINK ||
> +                   subtype == QPNP_MPP_SUBTYPE_ULT_4CH_NO_SINK)

Maybe better to have a logical flag indicating if this pad has "sink support"
or not.

> +                       return -ENXIO;

-EINVAL?

> +               if (val > 50)   /* mA */
> +                       return -EINVAL;
> +               attr[0].addr  = QPNP_REG_SINK_CTL;
> +               attr[0].shift = QPNP_REG_CS_OUT_SHIFT;
> +               attr[0].mask  = QPNP_REG_CS_OUT_MASK;
> +               attr[0].val   = (val / 5) - 1;
> +               break;
> +       case PIN_CONFIG_INPUT_ENABLE:
> +               nattrs = 2;
> +               attr[0].addr  = QPNP_REG_MODE_CTL;
> +               attr[0].shift = QPNP_REG_MODE_SEL_SHIFT;
> +               attr[0].mask  = QPNP_REG_MODE_SEL_MASK;
> +               attr[0].val   = QPNP_PIN_MODE_DIG_IN;
> +               attr[1].addr  = QPNP_REG_EN_CTL;
> +               attr[1].shift = QPNP_REG_MASTER_EN_SHIFT;
> +               attr[1].mask  = QPNP_REG_MASTER_EN_MASK;
> +               attr[1].val   = 1;
> +               if (val)
> +                       break;

input-disable is not the same thing as setting the pin in high-Z; i.e.
disabling the pin.

> +       /* Fallthrough */
> +       case PIN_CONFIG_BIAS_HIGH_IMPEDANCE:
> +               attr[1].addr  = QPNP_REG_EN_CTL;
> +               attr[1].shift = QPNP_REG_MASTER_EN_SHIFT;
> +               attr[1].mask  = QPNP_REG_MASTER_EN_MASK;
> +               attr[1].val   = 0;

Setting bias-high-impedence will use uninitialized attr[0] only, as nattrs will
be 1 here.

> +               break;
> +       case PIN_CONFIG_OUTPUT:
> +               nattrs = 3;
> +               attr[0].addr  = QPNP_REG_MODE_CTL;
> +               attr[0].shift = QPNP_REG_MODE_INVERT_SHIFT;
> +               attr[0].mask  = QPNP_REG_MODE_INVERT_MASK;
> +               attr[0].val   = !!val;
> +               attr[1].addr  = QPNP_REG_MODE_CTL;
> +               attr[1].shift = QPNP_REG_MODE_SEL_SHIFT;
> +               attr[1].mask  = QPNP_REG_MODE_SEL_MASK;
> +               attr[1].val   = QPNP_PIN_MODE_DIG_OUT;
> +               attr[2].addr  = QPNP_REG_EN_CTL;
> +               attr[2].shift = QPNP_REG_MASTER_EN_SHIFT;
> +               attr[2].mask  = QPNP_REG_MASTER_EN_MASK;
> +               attr[2].val   = 1;

Why are you setting master enable here? You should either have it all over the
place, or probably more sanely in the various bias cases.

> +               break;
> +       case QPNP_PINCONF_PULL_UP:
> +               if (type != QPNP_GPIO_TYPE)
> +                       return -EINVAL;
> +               switch (val) {
> +               default:
> +                       return -EINVAL;
> +               case 0:
> +                       val = QPNP_GPIO_PULL_NO;
> +                       break;
> +               case PMIC_GPIO_PULL_UP_30:
> +                       val = QPNP_GPIO_PULL_UP_30;
> +                       break;
> +               case PMIC_GPIO_PULL_UP_1P5:
> +                       val = QPNP_GPIO_PULL_UP_1P5;
> +                       break;
> +               case PMIC_GPIO_PULL_UP_31P5:
> +                       val = QPNP_GPIO_PULL_UP_31P5;
> +                       break;
> +               case PMIC_GPIO_PULL_UP_1P5_30:
> +                       val = QPNP_GPIO_PULL_UP_1P5_30;
> +                       break;
> +               }
> +               attr[0].addr  = QPNP_REG_DIG_PULL_CTL;
> +               attr[0].shift = QPNP_REG_PULL_SHIFT;
> +               attr[0].mask  = QPNP_REG_PULL_MASK;
> +               attr[0].val   = val;
> +               break;
> +       case QPNP_PINCONF_STRENGTH:
> +               if (type != QPNP_GPIO_TYPE)
> +                       return -EINVAL;
> +               switch (val) {
> +               default:
> +               case PMIC_GPIO_STRENGTH_NO:
> +                       return -EINVAL;
> +               case PMIC_GPIO_STRENGTH_LOW:
> +                       attr[0].val = QPNP_GPIO_STRENGTH_LOW;
> +                       break;
> +               case PMIC_GPIO_STRENGTH_MED:
> +                       attr[0].val = QPNP_GPIO_STRENGTH_MED;
> +                       break;
> +               case PMIC_GPIO_STRENGTH_HIGH:
> +                       attr[0].val = QPNP_GPIO_STRENGTH_HIGH;
> +                       break;
> +               }

These are 1:1, you can do attr[0].val = val;

> +               attr[0].addr  = QPNP_REG_DIG_OUT_CTL;
> +               attr[0].shift = QPNP_REG_OUT_STRENGTH_SHIFT;
> +               attr[0].mask  = QPNP_REG_OUT_STRENGTH_MASK;
> +               break;
> +       case QPNP_PINCONF_VREFENCE:
> +               if (type != QPNP_MPP_TYPE)
> +                       return -ENXIO;
> +               if (val >= QPNP_MPP_AOUT_INVALID)
> +                       return -EINVAL;
> +               if (subtype == QPNP_MPP_SUBTYPE_4CH_NO_ANA_OUT ||
> +                   subtype == QPNP_MPP_SUBTYPE_ULT_4CH_NO_ANA_OUT)
> +                       return -ENXIO;

-EINVAL?

And maybe have a logical flag on the pad saying if we can do "analog output".

> +               attr[0].addr  = QPNP_REG_AOUT_CTL;
> +               attr[0].shift = QPNP_REG_AOUT_REF_SHIFT;
> +               attr[0].mask  = QPNP_REG_AOUT_REF_MASK;
> +               attr[0].val   = val;
> +               break;
> +       case QPNP_PINCONF_AMUX_ROUTE:
> +               if (type != QPNP_MPP_TYPE)
> +                       return -ENXIO;

-EINVAL?

> +               if (val >= QPNP_MPP_AIN_INVALID)
> +                       return -EINVAL;
> +               attr[0].addr  = QPNP_REG_AIN_CTL;
> +               attr[0].shift = QPNP_REG_AIN_ROUTE_SHIFT;
> +               attr[0].mask  = QPNP_REG_AIN_ROUTE_MASK;
> +               attr[0].val   = val;
> +               break;
> +       case QPNP_PINCONF_MODE:
> +               if ((pad->modes & BIT(val)) == 0)
> +                       return -ENXIO;

-EINVAL?

> +               attr[0].addr  = QPNP_REG_MODE_CTL;
> +               attr[0].shift = QPNP_REG_MODE_SEL_SHIFT;
> +               attr[0].mask  = QPNP_REG_MODE_SEL_MASK;
> +               attr[0].val   = val;

What happens here if I day output-high; qcom,mode = "digital-input"; ?

> +               break;
> +       default:
> +               return -EINVAL;
> +       }
> +
> +       for (idx = 0; idx < nattrs; idx++) {
> +               /* add base offset */

This comment is uneccessary...

> +               attr[idx].addr = QPNP_REG_ADDR(pad, attr[idx].addr);
> +               ret = regmap_update_bits(qctrl->map, attr[idx].addr,
> +                                        attr[idx].mask,
> +                                        attr[idx].val << attr[idx].shift);
> +               if (ret < 0)
> +                       return ret;
> +       }
> +
> +       return 0;
> +}
> +
> +
> +static int qpnp_conv_from_pin(struct qpnp_pinctrl *qctrl,
> +                            struct qpnp_padinfo *pad,
> +                            unsigned param, unsigned *val)

This is not a good name for a "getter" function.

> +{
> +       struct qpnp_pinattrib attr;
> +       unsigned int type, subtype, field;
> +       unsigned int addr, buff;
> +       int ret;
> +
> +       *val = 0;
> +       type = pad->type;
> +       subtype = pad->subtype;
> +
> +       switch (param) {
> +       case PIN_CONFIG_DRIVE_PUSH_PULL:
> +       case PIN_CONFIG_DRIVE_OPEN_DRAIN:
> +       case PIN_CONFIG_DRIVE_OPEN_SOURCE:
> +               if (type != QPNP_GPIO_TYPE)
> +                       return -ENXIO;

-EINVAL?

> +               attr.addr  = QPNP_REG_DIG_OUT_CTL;
> +               attr.shift = QPNP_REG_OUT_TYPE_SHIFT;
> +               attr.mask  = QPNP_REG_OUT_TYPE_MASK;
> +               break;
> +       case PIN_CONFIG_BIAS_PULL_DOWN:
> +               if (type != QPNP_GPIO_TYPE)
> +                       return -ENXIO;

-EINVAL?

> +       /* Fallthrough */
> +       case PIN_CONFIG_BIAS_DISABLE:
> +       case PIN_CONFIG_BIAS_PULL_UP:
> +               attr.addr  = QPNP_REG_DIG_PULL_CTL;
> +               attr.shift = QPNP_REG_PULL_SHIFT;
> +               attr.mask  = QPNP_REG_PULL_MASK;
> +               break;
> +       case PIN_CONFIG_BIAS_HIGH_IMPEDANCE:
> +               attr.addr  = QPNP_REG_EN_CTL;
> +               attr.shift = QPNP_REG_MASTER_EN_SHIFT;
> +               attr.mask  = QPNP_REG_MASTER_EN_MASK;
> +               break;
> +       case PIN_CONFIG_POWER_SOURCE:
> +               attr.addr  = QPNP_REG_DIG_VIN_CTL;
> +               attr.shift = QPNP_REG_VIN_SHIFT;
> +               attr.mask  = QPNP_REG_VIN_MASK;
> +               break;
> +       case PIN_CONFIG_DRIVE_STRENGTH:
> +               if (type != QPNP_MPP_TYPE)
> +                       return -ENXIO;

-EINVAL?

> +               attr.addr  = QPNP_REG_SINK_CTL;
> +               attr.shift = QPNP_REG_CS_OUT_SHIFT;
> +               attr.mask  = QPNP_REG_CS_OUT_MASK;
> +               break;
> +       case PIN_CONFIG_INPUT_ENABLE:
> +               attr.addr  = QPNP_REG_EN_CTL;
> +               attr.shift = QPNP_REG_MASTER_EN_SHIFT;
> +               attr.mask  = QPNP_REG_MASTER_EN_MASK;
> +               break;
> +       case PIN_CONFIG_OUTPUT:
> +               attr.addr  = QPNP_REG_MODE_CTL;
> +               attr.shift = QPNP_REG_MODE_INVERT_SHIFT;
> +               attr.mask  = QPNP_REG_MODE_INVERT_MASK;
> +               break;
> +       case QPNP_PINCONF_PULL_UP:
> +               if (type != QPNP_GPIO_TYPE)
> +                       return -ENXIO;

-EINVAL?

> +               attr.addr  = QPNP_REG_DIG_PULL_CTL;
> +               attr.shift = QPNP_REG_PULL_SHIFT;
> +               attr.mask  = QPNP_REG_PULL_MASK;
> +               break;
> +       case QPNP_PINCONF_STRENGTH:
> +               if (type != QPNP_GPIO_TYPE)
> +                       return -ENXIO;

-EINVAL?

> +               attr.addr  = QPNP_REG_DIG_OUT_CTL;
> +               attr.shift = QPNP_REG_OUT_STRENGTH_SHIFT;
> +               attr.mask  = QPNP_REG_OUT_STRENGTH_MASK;
> +               break;
> +       case QPNP_PINCONF_VREFENCE:
> +               if (type != QPNP_MPP_TYPE)
> +                       return -ENXIO;

-EINVAL?

> +               if (subtype == QPNP_MPP_SUBTYPE_4CH_NO_ANA_OUT ||
> +                   subtype == QPNP_MPP_SUBTYPE_ULT_4CH_NO_ANA_OUT)
> +                       return -ENXIO;

-EINVAL?

> +               attr.addr  = QPNP_REG_AOUT_CTL;
> +               attr.shift = QPNP_REG_AOUT_REF_SHIFT;
> +               attr.mask  = QPNP_REG_AOUT_REF_MASK;
> +               break;
> +       case QPNP_PINCONF_AMUX_ROUTE:
> +               if (type != QPNP_MPP_TYPE)
> +                       return -ENXIO;

-EINVAL?

> +               attr.addr  = QPNP_REG_AIN_CTL;
> +               attr.shift = QPNP_REG_AIN_ROUTE_SHIFT;
> +               attr.mask  = QPNP_REG_AIN_ROUTE_MASK;
> +               break;
> +       case QPNP_PINCONF_MODE:
> +               attr.addr  = QPNP_REG_MODE_CTL;
> +               attr.shift = QPNP_REG_MODE_SEL_SHIFT;
> +               attr.mask  = QPNP_REG_MODE_SEL_MASK;
> +               break;
> +       default:
> +               return -EINVAL;
> +       }
> +
> +       addr = QPNP_REG_ADDR(pad, attr.addr);
> +       ret = regmap_read(qctrl->map, addr, &buff);
> +       if (ret < 0)
> +               return ret;
> +
> +       field = QPNP_GET(buff, attr.shift, attr.mask);
> +
> +       switch (param) {
> +       case PIN_CONFIG_DRIVE_PUSH_PULL:
> +               if (field == QPNP_GPIO_OUT_BUF_CMOS)
> +                       *val = 1;
> +               break;
> +       case PIN_CONFIG_DRIVE_OPEN_DRAIN:
> +               if (field == QPNP_GPIO_OUT_BUF_OPEN_DRAIN_NMOS)
> +                       *val = 1;
> +               break;
> +       case PIN_CONFIG_DRIVE_OPEN_SOURCE:
> +               if (field == QPNP_GPIO_OUT_BUF_OPEN_DRAIN_PMOS)
> +                       *val = 1;
> +               break;
> +       case PIN_CONFIG_BIAS_DISABLE:
> +               if (type == QPNP_GPIO_TYPE) {
> +                       if (field == QPNP_GPIO_PULL_NO)
> +                               *val = 1;
> +               } else {
> +                       if (field == QPNP_MPP_PULL_UP_OPEN)
> +                               *val = 1;
> +               }
> +               break;
> +       case PIN_CONFIG_BIAS_PULL_UP:
> +               switch (field) {
> +               default:
> +               case QPNP_MPP_PULL_UP_OPEN:
> +                       *val = 0;
> +                       break;
> +               case QPNP_MPP_PULL_UP_0P6KOHM:
> +                       *val = 600;
> +                       break;
> +               case QPNP_MPP_PULL_UP_10KOHM:
> +                       *val = 10000;
> +                       break;
> +               case QPNP_MPP_PULL_UP_30KOHM:
> +                       *val = 30000;
> +                       break;
> +               }
> +               break;
> +       case PIN_CONFIG_BIAS_PULL_DOWN:
> +               if (field == QPNP_GPIO_PULL_DN)
> +                       *val = 1;
> +               break;
> +       case PIN_CONFIG_POWER_SOURCE:
> +               *val = field;
> +               break;
> +       case PIN_CONFIG_DRIVE_STRENGTH:
> +               *val = (field + 1) * 5;
> +               break;
> +       case PIN_CONFIG_INPUT_ENABLE:
> +               *val = field;
> +               break;
> +       case PIN_CONFIG_BIAS_HIGH_IMPEDANCE:
> +               if (field == QPNP_PIN_MASTER_DISABLE)
> +                       *val = 1;

Checking for if (!field) would seem more logical.

> +               break;
> +       case PIN_CONFIG_OUTPUT:
> +               *val = field;
> +               break;
> +       case QPNP_PINCONF_PULL_UP:
> +               switch (field) {
> +               case QPNP_GPIO_PULL_NO:
> +                       field = 0;
> +                       break;
> +               case QPNP_GPIO_PULL_UP_30:
> +                       field = PMIC_GPIO_PULL_UP_30;

Why don't you just assign *val directly here, like you do in the rest of the
cases?

> +                       break;
> +               case QPNP_GPIO_PULL_UP_1P5:
> +                       field = PMIC_GPIO_PULL_UP_1P5;
> +                       break;
> +               case QPNP_GPIO_PULL_UP_31P5:
> +                       field = PMIC_GPIO_PULL_UP_31P5;
> +                       break;
> +
> +               case QPNP_GPIO_PULL_UP_1P5_30:
> +                       field = PMIC_GPIO_PULL_UP_1P5_30;
> +                       break;
> +               }
> +               *val = field;
> +               break;
> +       case QPNP_PINCONF_STRENGTH:
> +               switch (field) {
> +               case QPNP_GPIO_STRENGTH_HIGH:
> +                       field = PMIC_GPIO_STRENGTH_HIGH;
> +                       break;
> +               case QPNP_GPIO_STRENGTH_MED:
> +                       field = PMIC_GPIO_STRENGTH_MED;
> +                       break;
> +               case QPNP_GPIO_STRENGTH_LOW:
> +                       field = PMIC_GPIO_STRENGTH_LOW;
> +                       break;
> +               }
> +               *val = field;
> +               break;
> +       case QPNP_PINCONF_MODE:
> +       case QPNP_PINCONF_VREFENCE:
> +       case QPNP_PINCONF_AMUX_ROUTE:
> +               *val = field;
> +               break;
> +       default:
> +               return -EINVAL;
> +       }
> +
> +       return 0;
> +}
> +

[...]

> +
> +static int qpnp_parse_dt_config(struct device_node *np,
> +                             struct pinctrl_dev *pctldev,
> +                             unsigned long **configs, unsigned int *nconfs)
> +{
> +       struct qpnp_pinbindings *par;
> +       unsigned long cfg;
> +       int ret, idx;
> +       u32 val;
> +
> +       for (idx = 0; idx < ARRAY_SIZE(qpnp_pinbindings); idx++) {
> +
> +               par = &qpnp_pinbindings[idx];
> +               ret = of_property_read_u32(np, par->property, &val);
> +
> +               /* property not found */
> +               if (ret == -EINVAL)
> +                       continue;
> +
> +               /* use default value, when no value is specified */
> +               if (ret)
> +                       val = par->default_value;

These are all 0 in your case.

> +
> +               dev_dbg(pctldev->dev, "found %s with value %u\n",
> +                       par->property, val);
> +
> +               cfg = pinconf_to_config_packed(par->param, val);
> +
> +               ret = pinctrl_utils_add_config(pctldev, configs, nconfs, cfg);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       return 0;
> +}
> +

[...]

> +
> +static int qpnp_get_functions_count(struct pinctrl_dev *pctldev)
> +{
> +       return ARRAY_SIZE(qpnp_gpio_functions);

What about the qpnp_mpp_functions?

> +}
> +

[...]

> +
> +static int qpnp_get(struct gpio_chip *chip, unsigned offset)
> +{
> +       struct qpnp_pinctrl *qctrl = to_qpnp_pinctrl(chip);
> +       struct qpnp_padinfo *pad;
> +       unsigned int val, en_mask, buff, addr;
> +       int ret;
> +
> +       pad = qpnp_get_desc(qctrl, offset);
> +       if (!pad)
> +               return -EINVAL;
> +
> +       addr = QPNP_REG_ADDR(pad, QPNP_REG_MODE_CTL);
> +       ret = regmap_read(qctrl->map, addr, &buff);
> +       if (ret < 0)
> +               return ret;
> +
> +       /* GPIO val is from RT status if input is enabled */
> +       if ((buff & QPNP_REG_MODE_SEL_MASK) ==
> +           (QPNP_PIN_MODE_DIG_IN << QPNP_REG_MODE_SEL_SHIFT)) {

Logic like this would be far cleaner if you keep track of the configured state,
such as if this is input or output.

> +
> +               addr = QPNP_REG_ADDR(pad, QPNP_REG_STATUS1);
> +               ret = regmap_read(qctrl->map, addr, &val);
> +               if (ret < 0)
> +                       return ret;
> +

>From here...

> +               if (pad->type == QPNP_GPIO_TYPE && pad->major == 0)
> +                       en_mask = QPNP_REG_STATUS1_GPIO_EN_REV0_MASK;
> +               else if (pad->type == QPNP_GPIO_TYPE &&
> +                        pad->major > 0)
> +                       en_mask = QPNP_REG_STATUS1_GPIO_EN_MASK;
> +               else            /* MPP */
> +                       en_mask = QPNP_REG_STATUS1_MPP_EN_MASK;
> +
> +               if (!(val & en_mask))
> +                       return -EPERM;

...to here, checks if the gpio is enabled. If you keep track of that you could
drop this chunk.

> +
> +               ret = val & QPNP_REG_STATUS1_VAL_MASK;

You should be able to ignore the above checks altogether and read the real time
status bit register (0x10) and use BIT(0) from it - but I haven't tested this.


If that doesn't fly we could simply drop "rev0" support and just have 1 mask
(as it's the same for gpio and mpp) and drop all the if block.

> +
> +       } else {
> +               ret = buff & QPNP_REG_MODE_INVERT_MASK;
> +               ret = ret >> QPNP_REG_MODE_INVERT_SHIFT;
> +       }
> +
> +       return !!ret;
> +}
> +

[...]

> +
> +static int qpnp_config_get(struct pinctrl_dev *pctldev,
> +                         unsigned int pin,
> +                         unsigned long *config)
> +{
> +       struct qpnp_pinctrl *qctrl = pinctrl_dev_get_drvdata(pctldev);
> +       unsigned param = pinconf_to_config_param(*config);
> +       struct qpnp_padinfo *pad;
> +       unsigned arg;
> +       int ret;
> +
> +       pad = qpnp_get_desc(qctrl, pin);
> +       if (!pad)
> +               return -EINVAL;
> +
> +       /* Convert pinconf values to register values */

Not only does it convert the values, it reads them too...

> +       ret = qpnp_conv_from_pin(qctrl, pad, param, &arg);
> +       if (ret)
> +               return ret;
> +
> +       /* Convert register value to pinconf value */
> +       *config = pinconf_to_config_packed(param, arg);
> +       return 0;
> +}
> +
> +static int qpnp_config_set(struct pinctrl_dev *pctldev, unsigned int pin,
> +                         unsigned long *configs, unsigned nconfs)
> +{
> +       struct qpnp_pinctrl *qctrl = pinctrl_dev_get_drvdata(pctldev);
> +       struct qpnp_padinfo *pad;
> +       unsigned param;
> +       unsigned arg;
> +       int idx, ret;
> +
> +       pad = qpnp_get_desc(qctrl, pin);
> +       if (!pad)
> +               return -EINVAL;
> +
> +       for (idx = 0; idx < nconfs; idx++) {
> +               param = pinconf_to_config_param(configs[idx]);
> +               arg = pinconf_to_config_argument(configs[idx]);
> +
> +               /* Convert pinconf values to register values */

...and update the registers...

> +               ret = qpnp_conv_to_pin(qctrl, pad, param, arg);
> +               if (ret < 0) {
> +                       dev_err(pctldev->dev, "config %u = %u failed\n",
> +                               param, arg);
> +                       return ret;
> +               }
> +       }
> +
> +       return 0;
> +}
> +

[...]

> +
> +static int qpnp_of_xlate(struct gpio_chip *chip,
> +                      const struct of_phandle_args *gpio_desc, u32 *flags)
> +{

Assign chip.of_node when registering the gpio_chip and remove this function.

> +       struct qpnp_pinctrl *qctrl = to_qpnp_pinctrl(chip);
> +       struct qpnp_padinfo *pad;
> +       unsigned pin = gpio_desc->args[0] - QPNP_PIN_PHYSICAL_OFFSET;
> +
> +       if (chip->of_gpio_n_cells < 2)
> +               return -EINVAL;
> +
> +       pad = qpnp_get_desc(qctrl, pin);
> +       if (!pad)
> +               return -EINVAL;
> +
> +       if (flags)
> +               *flags = gpio_desc->args[1];
> +
> +       return pin;
> +}
> +

[...]

> +
> +static int qpnp_control_init(struct qpnp_pinctrl *qctrl,
> +                         struct qpnp_padinfo *pad)

This is not "initializing any control", it's rather a
qpnp_get_available_modes(type, subtype) function.

> +{
> +       pad->modes = 0;
> +
> +       if (pad->type == QPNP_GPIO_TYPE) {
> +               switch (pad->subtype) {
> +               case QPNP_GPIO_SUBTYPE_GPIO_4CH:
> +               case QPNP_GPIO_SUBTYPE_GPIOC_4CH:
> +               case QPNP_GPIO_SUBTYPE_GPIO_8CH:
> +               case QPNP_GPIO_SUBTYPE_GPIOC_8CH:

Looks like this switch is not of much use, consider dropping it.

> +
> +                       /* only GPIO is supported*/
> +                       pad->modes |= BIT(QPNP_PIN_MODE_DIG_IN);
> +                       pad->modes |= BIT(QPNP_PIN_MODE_DIG_OUT);
> +                       pad->modes |= BIT(QPNP_PIN_MODE_DIG_IN_OUT);
> +                       break;
> +               default:
> +                       dev_err(qctrl->dev, "invalid GPIO subtype 0x%x\n",
> +                               pad->subtype);

Is this really going to happen? This would indicate that we have "compatible"
chips that suddenly have some new type of gpio/mpp block.

> +                       return -EINVAL;
> +               }
> +
> +       } else if (pad->type == QPNP_MPP_TYPE) {
> +
> +               switch (pad->subtype) {
> +               case QPNP_MPP_SUBTYPE_4CH_NO_SINK:
> +               case QPNP_MPP_SUBTYPE_ULT_4CH_NO_SINK:
> +
> +                       /* Current sink not supported*/
> +                       pad->modes |= BIT(QPNP_PIN_MODE_DIG_IN);
> +                       pad->modes |= BIT(QPNP_PIN_MODE_DIG_OUT);
> +                       pad->modes |= BIT(QPNP_PIN_MODE_DIG_IN_OUT);
> +                       pad->modes |= BIT(QPNP_PIN_MODE_BIDIR);
> +                       pad->modes |= BIT(QPNP_PIN_MODE_AIN);
> +                       pad->modes |= BIT(QPNP_PIN_MODE_AOUT);

It's hard to get a quick understanding of what is common and what is not. If
you move all the common modes to before the switch statement and then just add
the special ones in the three cases things would be easier to read.

> +                       break;
> +               case QPNP_MPP_SUBTYPE_4CH_NO_ANA_OUT:
> +               case QPNP_MPP_SUBTYPE_ULT_4CH_NO_ANA_OUT:
> +
> +                       /* Analog output not supported */
> +                       pad->modes |= BIT(QPNP_PIN_MODE_DIG_IN);
> +                       pad->modes |= BIT(QPNP_PIN_MODE_DIG_OUT);
> +                       pad->modes |= BIT(QPNP_PIN_MODE_DIG_IN_OUT);
> +                       pad->modes |= BIT(QPNP_PIN_MODE_BIDIR);
> +                       pad->modes |= BIT(QPNP_PIN_MODE_AIN);
> +                       pad->modes |= BIT(QPNP_PIN_MODE_SINK);
> +                       break;
> +               case QPNP_MPP_SUBTYPE_4CH_FULL_FUNC:
> +               case QPNP_MPP_SUBTYPE_8CH_FULL_FUNC:
> +
> +                       pad->modes |= BIT(QPNP_PIN_MODE_DIG_IN);
> +                       pad->modes |= BIT(QPNP_PIN_MODE_DIG_OUT);
> +                       pad->modes |= BIT(QPNP_PIN_MODE_DIG_IN_OUT);
> +                       pad->modes |= BIT(QPNP_PIN_MODE_BIDIR);
> +                       pad->modes |= BIT(QPNP_PIN_MODE_AIN);
> +                       pad->modes |= BIT(QPNP_PIN_MODE_AOUT);
> +                       pad->modes |= BIT(QPNP_PIN_MODE_SINK);
> +                       break;
> +               default:
> +                       dev_err(qctrl->dev, "invalid MPP subtype 0x%x\n",
> +                               pad->subtype);

Same as for gpios.

> +                       return -EINVAL;
> +               }
> +       } else {
> +               dev_err(qctrl->dev, "invalid type 0x%x\n", pad->type);
> +               return -EINVAL;

This is not possible, because you already checked type in discover.

> +       }
> +
> +       return 0;
> +}
> +
> +static int qpnp_discover(struct platform_device *pdev,
> +                       struct qpnp_pinctrl *qctrl)
> +{
> +       struct device *dev = qctrl->dev;
> +       struct pinctrl_pin_desc *desc, *descs;
> +       struct qpnp_padinfo *pad, *pads;
> +       unsigned int addr, npins;
> +       int idx, ret;
> +
> +       npins = qctrl->info->npins;
> +       pads = devm_kcalloc(dev, npins, sizeof(*pads), GFP_KERNEL);
> +       if (!pads)
> +               return -ENOMEM;
> +
> +       descs = devm_kcalloc(dev, npins, sizeof(*descs), GFP_KERNEL);
> +       if (!descs)
> +               return -ENOMEM;
> +
> +       for (idx = 0; idx < npins; idx++) {
> +
> +               pad = &pads[idx];
> +               desc = &descs[idx];
> +
> +               pad->irq = platform_get_irq(pdev, idx);
> +               if (pad->irq < 0)
> +                       return pad->irq;
> +
> +               pad->offset = qctrl->info->base + (idx * 0x100);
> +
> +               addr = QPNP_REG_ADDR(pad, QPNP_REG_DIG_MAJOR_REV);
> +               ret = regmap_read(qctrl->map, addr, &pad->major);
> +               if (ret < 0)
> +                       return ret;

The major is only used to figure out if the gpio is enabled to see if we can
trust the gpio value, if you rework that (or use rt status) then you can drop
this as well.

> +
> +               addr = QPNP_REG_ADDR(pad, QPNP_REG_TYPE);
> +               ret = regmap_read(qctrl->map, addr, &pad->type);
> +               if (ret < 0)
> +                       return ret;
> +
> +               if (pad->type != qctrl->info->type) {
> +                       dev_err(dev, "Expected %x, found %x\n",
> +                               qctrl->info->type, pad->type);

The only reason for this is if you end up here matching a gpio compatible on a
mpp block or vice versa. In the current implementation that's impossible, with
my suggestion of reading the reg from dt this will be possible; but I think you
should make the error message indicate what the problem actually is.

Like "Incorrect block type 0x%x" or so..

> +                       return -EINVAL;
> +               }
> +
> +               addr = QPNP_REG_ADDR(pad, QPNP_REG_SUBTYPE);
> +               ret = regmap_read(qctrl->map, addr, &pad->subtype);
> +               if (ret < 0)
> +                       return ret;
> +
> +               ret = qpnp_control_init(qctrl, pad);
> +               if (ret)
> +                       return ret;
> +
> +               pad->name = qctrl->groups[idx];

No need to keep this in the pad and desc, as stated before.

> +               desc->number = idx;
> +               desc->name = pad->name;
> +       }
> +
> +       qctrl->pads = pads;
> +
> +       qctrl->chip = qpnp_gpio_template;
> +       qctrl->chip.dev = dev;
> +       qctrl->chip.base = -1;
> +       qctrl->chip.ngpio = qctrl->info->npins;
> +       qctrl->chip.label = dev_name(dev);
> +       qctrl->chip.of_gpio_n_cells = 2;
> +       qctrl->chip.can_sleep = true;

Assign chip.of_node as well and it will give you the xlate stuff.

> +
> +       qctrl->desc.pctlops = &qpnp_pinctrl_ops,
> +       qctrl->desc.pmxops = &qpnp_pinmux_ops,
> +       qctrl->desc.confops = &qpnp_pinconf_ops,
> +       qctrl->desc.owner = THIS_MODULE,
> +       qctrl->desc.name = dev_name(dev);
> +       qctrl->desc.pins = descs;
> +       qctrl->desc.npins = npins;
> +
> +       qctrl->ctrl = pinctrl_register(&qctrl->desc, dev, qctrl);
> +       if (!qctrl->ctrl)
> +               return -ENODEV;
> +
> +       ret = gpiochip_add(&qctrl->chip);
> +       if (ret) {
> +               dev_err(qctrl->dev, "can't add gpio chip\n");
> +               goto err_chip;
> +       }
> +
> +       ret = gpiochip_add_pin_range(&qctrl->chip, dev_name(dev),
> +                                    0, 0, npins);
> +       if (ret) {
> +               dev_err(dev, "failed to add pin range\n");
> +               goto err_range;
> +       }
> +
> +       return 0;
> +

You got these in the wrong order, err_range should pop both, err_chip should
only pop the pinctrl.

> +err_chip:
> +       pinctrl_unregister(qctrl->ctrl);
> +
> +err_range:
> +       gpiochip_remove(&qctrl->chip);
> +
> +       return ret;
> +
> +}
> +
> +static const struct of_device_id qpnp_pinctrl_of_match[];
> +
> +static int qpnp_pinctrl_probe(struct platform_device *pdev)
> +{
> +       struct device *dev = &pdev->dev;
> +       const struct qpnp_chipinfo *qchip;
> +       struct qpnp_pinctrl *qctrl;
> +
> +       qctrl = devm_kzalloc(dev, sizeof(*qctrl), GFP_KERNEL);
> +       if (!qctrl)
> +               return -ENOMEM;
> +
> +       platform_set_drvdata(pdev, qctrl);
> +
> +       qchip = of_match_node(qpnp_pinctrl_of_match, dev->of_node)->data;
> +
> +       qctrl->info = qchip;

No need to keep track of the info after qpnp_discover().

> +       qctrl->dev = &pdev->dev;
> +       qctrl->map = dev_get_regmap(dev->parent, NULL);
> +
> +       if (qchip->type == QPNP_GPIO_TYPE) {
> +               if (WARN_ON(qchip->npins > ARRAY_SIZE(qpnp_gpio_groups)))

Either remove this, or make it a BUG_ON(), depending on you trusting future
developers.

> +                       return -EINVAL;
> +               qctrl->groups = qpnp_gpio_groups;
> +               qctrl->functions = qpnp_gpio_functions;
> +       } else {
> +               if (WARN_ON(qchip->npins > ARRAY_SIZE(qpnp_mpp_groups)))

dito

> +                       return -EINVAL;
> +               qctrl->groups = qpnp_mpp_groups;
> +               qctrl->functions = qpnp_mpp_functions;
> +       }
> +
> +       return qpnp_discover(pdev, qctrl);
> +}
> +
> +static int qpnp_pinctrl_remove(struct platform_device *pdev)
> +{
> +       struct qpnp_pinctrl *qctrl = platform_get_drvdata(pdev);
> +
> +       gpiochip_remove(&qctrl->chip);

I think Linus talked about removing the return value, but for now I think you
should abort if the gpiochip is busy.

> +       pinctrl_unregister(qctrl->ctrl);
> +
> +       return 0;
> +}
> +
> +static const struct qpnp_chipinfo qpnp_pm8841_mpp_info = {
> +       .npins  = 4,
> +       .base   = 0xa000,

Read this from the reg property instead.

> +       .type   = QPNP_MPP_TYPE,
> +};
> +
> +static const struct qpnp_chipinfo qpnp_pm8941_gpio_info = {
> +       .npins  = 36,
> +       .base   = 0xc000,

dito

> +       .type   = QPNP_GPIO_TYPE,
> +};
> +
> +static const struct qpnp_chipinfo qpnp_pm8941_mpp_info = {
> +       .npins  = 8,
> +       .base   = 0xa000,

dito

> +       .type   = QPNP_MPP_TYPE,
> +};
> +
> +static const struct qpnp_chipinfo qpnp_pma8084_mpp_info = {
> +       .npins  = 4,
> +       .base   = 0xa000,

dito

> +       .type   = QPNP_MPP_TYPE,
> +};
> +
> +static const struct qpnp_chipinfo qpnp_pma8084_gpio_info = {
> +       .npins  = 22,
> +       .base   = 0xc000,

dito

> +       .type   = QPNP_GPIO_TYPE,
> +};
> +

Regards,
Bjorn

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750871AbaIXESr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 00:18:47 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:15632 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750717AbaIXESp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 00:18:45 -0400
Date: Tue, 23 Sep 2014 21:18:53 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        David Collins <collinsd@codeaurora.org>,
        Wu Fenglin <fenglinw@qti.qualcomm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v4 3/4] pinctrl: Qualcomm SPMI PMIC GPIO pin controller
 driver
Message-ID: <20140924041852.GO10179@sonymobile.com>
References: <1410792254-24126-1-git-send-email-iivanov@mm-sol.com>
 <1410792254-24126-4-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1410792254-24126-4-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 15 Sep 07:44 PDT 2014, Ivan T. Ivanov wrote:

> This is the pinctrl, pinmux, pinconf and gpiolib driver for the
> Qualcomm GPIO sub-function blocks found in the PMIC chips.
> 
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>

I think this looks pretty good, just some minor comments. Mostly on the future
compatibility of the Kconfig and compatible.

It's much in line with what I hacked up for pm8xxx, I was just hoping to get
something from Thomas regarding irq_read_line() before pushing it again...

> ---
>  drivers/pinctrl/qcom/Kconfig                  |  12 +
>  drivers/pinctrl/qcom/Makefile                 |   1 +
>  drivers/pinctrl/qcom/pinctrl-spmi-pmic-gpio.c | 942 ++++++++++++++++++++++++++
>  3 files changed, 955 insertions(+)
>  create mode 100644 drivers/pinctrl/qcom/pinctrl-spmi-pmic-gpio.c
> 
> diff --git a/drivers/pinctrl/qcom/Kconfig b/drivers/pinctrl/qcom/Kconfig
> index d160a71..123248f 100644
> --- a/drivers/pinctrl/qcom/Kconfig
> +++ b/drivers/pinctrl/qcom/Kconfig
> @@ -39,4 +39,16 @@ config PINCTRL_MSM8X74
>           This is the pinctrl, pinmux, pinconf and gpiolib driver for the
>           Qualcomm TLMM block found in the Qualcomm 8974 platform.
> 
> +config PINCTRL_SPMI_PMIC

As SPMI is a MIPI specification for doing power management I think it's safe to
assume that this is not going to be the only "spmi pmic" pinctrl driver.
So please make this a little bit more specific by throwing in a QCOM here.

> +       tristate "Qualcomm SPMI PMIC pin controller driver"
> +       depends on GPIOLIB && OF
> +       select PINMUX
> +       select PINCONF
> +       select GENERIC_PINCONF
> +       help
> +         This is the pinctrl, pinmux, pinconf and gpiolib driver for the
> +         Qualcomm GPIO and MPP blocks found in the Qualcomm PMIC's chips,
> +         which are using SPMI for communication with SoC. Example PMIC's
> +         devices are pm8841, pm8941 and pma8084.
> +
>  endif
> diff --git a/drivers/pinctrl/qcom/Makefile b/drivers/pinctrl/qcom/Makefile
> index 2a02602..396130c 100644
> --- a/drivers/pinctrl/qcom/Makefile
> +++ b/drivers/pinctrl/qcom/Makefile
> @@ -4,3 +4,4 @@ obj-$(CONFIG_PINCTRL_APQ8064)   += pinctrl-apq8064.o
>  obj-$(CONFIG_PINCTRL_IPQ8064)  += pinctrl-ipq8064.o
>  obj-$(CONFIG_PINCTRL_MSM8960)  += pinctrl-msm8960.o
>  obj-$(CONFIG_PINCTRL_MSM8X74)  += pinctrl-msm8x74.o
> +obj-$(CONFIG_PINCTRL_SPMI_PMIC)        += pinctrl-spmi-pmic-gpio.o
> diff --git a/drivers/pinctrl/qcom/pinctrl-spmi-pmic-gpio.c b/drivers/pinctrl/qcom/pinctrl-spmi-pmic-gpio.c
> new file mode 100644
> index 0000000..493f0d3
> --- /dev/null
> +++ b/drivers/pinctrl/qcom/pinctrl-spmi-pmic-gpio.c

This is fine, no need to change as we have qcom in the path...

[..]
> +
> +/**
> + * struct pmic_gpio_pad - keep current GPIO settings

Some indentation in this table would be nice.
Content look sane though.

> + * @base: Address base in SPMI device.
> + * @irq: IRQ number which this GPIO generate.
> + * @is_enabled: Set to false when GPIO should be put in high Z state.
> + * @out_value: Cached pin output value
> + * @have_buffer: Set to true if GPIO output could be configured in push-pull,
> + *     open-drain or open-source mode.
> + * @output_enabled: Set to true if GPIO output logic is enabled.
> + * @input_enabled: Set to true if GPIO input buffer logic is enabled.
> + * @num_sources: Number of power-sources supported by this GPIO.
> + * @power_source: Current power-source used.
> + * @buffer_type: Push-pull, open-drain or open-source.
> + * @pullup: Constant current which flow trough GPIO output buffer.
> + * @strength: No, Low, Medium, High
> + * @function: See pmic_gpio_functions[]
> + */
> +struct pmic_gpio_pad {
> +       u16 base;
> +       int irq;
> +       bool is_enabled;
> +       bool out_value;
> +       bool have_buffer;
> +       bool output_enabled;
> +       bool input_enabled;
> +       unsigned int num_sources;
> +       unsigned int power_source;
> +       unsigned int buffer_type;
> +       unsigned int pullup;
> +       unsigned int strength;
> +       unsigned int function;
> +};
> +
[..]
> +
> +static int pmic_gpio_parse_dt_config(struct device_node *np,
> +                                    struct pinctrl_dev *pctldev,
> +                                    unsigned long **configs,
> +                                    unsigned int *nconfs)
> +{
> +       struct pmic_gpio_bindings *par;
> +       unsigned long cfg;
> +       int ret, i;
> +       u32 val;
> +
> +       for (i = 0; i < ARRAY_SIZE(pmic_gpio_bindings); i++) {
> +

Empty line

> +               par = &pmic_gpio_bindings[i];
> +               ret = of_property_read_u32(np, par->property, &val);
> +
> +               /* property not found */
> +               if (ret == -EINVAL)
> +                       continue;
> +
> +               /* use zero as default value */
> +               if (ret)
> +                       val = 0;
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
[..]
> +
> +static int pmic_gpio_dt_node_to_map(struct pinctrl_dev *pctldev,
> +                                   struct device_node *np_config,
> +                                   struct pinctrl_map **map, unsigned *nmaps)
> +{
> +       enum pinctrl_map_type type;
> +       struct device_node *np;
> +       unsigned reserv;
> +       int ret;
> +
> +       ret = 0;
> +       *map = NULL;
> +       *nmaps = 0;
> +       reserv = 0;
> +       type = PIN_MAP_TYPE_CONFIGS_GROUP;
> +
> +       for_each_child_of_node(np_config, np) {
> +

Empty line

> +               ret = pinconf_generic_dt_subnode_to_map(pctldev, np, map,
> +                                                       &reserv, nmaps, type);
> +               if (ret)
> +                       break;
> +
> +               ret = pmic_gpio_dt_subnode_to_map(pctldev, np, map, &reserv,
> +                                                 nmaps, type);
> +               if (ret)
> +                       break;
> +       }
> +
> +       if (ret < 0)
> +               pinctrl_utils_dt_free_map(pctldev, *map, *nmaps);
> +
> +       return ret;
> +}
> +
[..]
> +
> +static int pmic_gpio_config_get(struct pinctrl_dev *pctldev,
> +                               unsigned int pin, unsigned long *config)
> +{
> +       unsigned param = pinconf_to_config_param(*config);
> +       struct pmic_gpio_pad *pad;
> +       unsigned arg;
> +
> +       pad = pctldev->desc->pins[pin].drv_data;
> +
> +       switch (param) {
> +       case PIN_CONFIG_DRIVE_PUSH_PULL:
> +               arg = pad->buffer_type == PMIC_GPIO_OUT_BUF_CMOS;
> +               break;
> +       case PIN_CONFIG_DRIVE_OPEN_DRAIN:
> +               arg = pad->buffer_type == PMIC_GPIO_OUT_BUF_OPEN_DRAIN_NMOS;
> +               break;
> +       case PIN_CONFIG_DRIVE_OPEN_SOURCE:
> +               arg = pad->buffer_type == PMIC_GPIO_OUT_BUF_OPEN_DRAIN_PMOS;
> +               break;
> +       case PIN_CONFIG_BIAS_PULL_DOWN:
> +               arg = pad->pullup == PMIC_GPIO_PULL_DOWN;
> +               break;
> +       case PIN_CONFIG_BIAS_DISABLE:
> +               arg = pad->pullup = PMIC_GPIO_PULL_DISABLE;
> +               break;
> +       case PIN_CONFIG_BIAS_PULL_UP:
> +               arg = pad->pullup == PMIC_GPIO_PULL_UP_30;
> +               break;

Extra break;

> +               break;
> +       case PIN_CONFIG_BIAS_HIGH_IMPEDANCE:
> +               arg = !pad->is_enabled;
> +               break;
> +       case PIN_CONFIG_POWER_SOURCE:
> +               arg = pad->power_source;
> +               break;
> +       case PIN_CONFIG_INPUT_ENABLE:
> +               arg = pad->input_enabled;
> +               break;
> +       case PIN_CONFIG_OUTPUT:
> +               arg = pad->out_value;
> +               break;
> +       case PMIC_GPIO_CONF_PULL_UP:
> +               arg = pad->pullup;
> +               break;
> +       case PMIC_GPIO_CONF_STRENGTH:
> +               arg = pad->strength;
> +               break;
> +       default:
> +               return -EINVAL;
> +       }
> +
> +       *config = pinconf_to_config_packed(param, arg);
> +       return 0;
> +}
> +
[..]
> +static int pmic_gpio_direction_input(struct gpio_chip *chip, unsigned pin)
> +{
> +       struct pmic_gpio_state *state;
> +       unsigned long config;
> +
> +       state = container_of(chip, struct pmic_gpio_state, chip);

You use this container_of plenty of times, consider breaking it out to a
to_gpio_state() helper function and you can fit it on the declaration line.

> +       config = pinconf_to_config_packed(PIN_CONFIG_INPUT_ENABLE, 1);
> +
> +       return pmic_gpio_config_set(state->ctrl, pin, &config, 1);
> +}
> +
[..]
> +
> +static int pmic_gpio_of_xlate(struct gpio_chip *chip,
> +                             const struct of_phandle_args *gpio_desc,
> +                             u32 *flags)
> +{
> +       if (chip->of_gpio_n_cells < 2)
> +               return -EINVAL;
> +
> +       if (flags)
> +               *flags = gpio_desc->args[1];
> +
> +       return gpio_desc->args[0] - PMIC_GPIO_PHYSICAL_OFFSET;
> +}

If you change:
 gpiochip_add_pin_range(&state->chip, dev_name(dev), 0, 0, npins);
to:
 gpiochip_add_pin_range(&state->chip, dev_name(dev), 1, 0, npins);

And you treat the gpio functions as taking the gpio number instead of pinctrl
number (i.e. subtract 1 in those), then gpiolib will provide this function for
you.

[..]
> +
> +static const struct of_device_id pmic_gpio_of_match[] = {
> +       { .compatible = "qcom,spmi-pmic-gpio" },

I think this should be more specific, because hopefully the spmi specification
will outlive the current pmic gpio block.

So I think you need to list the pmic blocks here (e.g. "qcom,pm8941-gpio").

> +       { },
> +};
> +
> +MODULE_DEVICE_TABLE(of, pmic_gpio_of_match);
> +
> +static struct platform_driver pmic_gpio_driver = {
> +       .driver = {
> +                  .name = "spmi-pmic-gpio",

The name should include "qcom" as well, to make it less prone to collisions.

> +                  .owner = THIS_MODULE,

owner filled in for you by module_platform_driver()

> +                  .of_match_table = pmic_gpio_of_match,
> +       },
> +       .probe  = pmic_gpio_probe,
> +       .remove = pmic_gpio_remove,
> +};
> +
> +module_platform_driver(pmic_gpio_driver);
> +

Regards,
Bjorn

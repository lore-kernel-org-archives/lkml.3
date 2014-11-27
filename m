Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbaK0JPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 04:15:01 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:36296 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010AbaK0JOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 04:14:50 -0500
MIME-Version: 1.0
In-Reply-To: <1415709535-31515-2-git-send-email-hongzhou.yang@mediatek.com>
References: <1415709535-31515-1-git-send-email-hongzhou.yang@mediatek.com>
	<1415709535-31515-2-git-send-email-hongzhou.yang@mediatek.com>
Date: Thu, 27 Nov 2014 10:14:49 +0100
Message-ID: <CACRpkdY5cen-GicF6tuDaXzJXGD3DZUYODQEgpKCWoLP-MDBsA@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] ARM: mediatek: Add Pinctrl/GPIO driver for mt8135.
From: Linus Walleij <linus.walleij@linaro.org>
To: Hongzhou Yang <hongzhou.yang@mediatek.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sascha Hauer <kernel@pengutronix.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        huang eddie <eddie.huang@mediatek.com>, dandan.he@mediatek.com,
        alan.cheng@mediatek.com, toby.liu@mediatek.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

()On Tue, Nov 11, 2014 at 1:38 PM, Hongzhou Yang
<hongzhou.yang@mediatek.com> wrote:

> From: Hongzhou Yang <hongzhou.yang@mediatek.com>
>
> The mediatek SoCs have GPIO controller that handle both the muxing and GPIOs.
>
> The GPIO controller have pinmux, pull enable, pull select, direction and output high/low control.
>
> This driver include common driver and mt8135 part.
> The common driver include the pinctrl driver and GPIO driver.
> The mt8135 part contain its special device data.
>
> Signed-off-by: Hongzhou Yang <hongzhou.yang@mediatek.com>
(...)
>  menuconfig ARCH_MEDIATEK
>         bool "Mediatek MT65xx & MT81xx SoC" if ARCH_MULTI_V7
>         select ARM_GIC
> +       select PINCTRL

Should it not also select PINCTRL_MTK8135 for the right SoC?

(...)
> +++ b/drivers/pinctrl/mediatek/Kconfig
> @@ -0,0 +1,12 @@
> +if ARCH_MEDIATEK
> +
> +config PINCTRL_MTK_COMMON
> +       bool
> +       select PINMUX
> +       select GENERIC_PINCONF

This is also a GPIO driver but it fails to select GPIOLIB,
OF_GPIO and also possibly GPIOLIB_IRQCHIP.

(...)
> +static int mtk_pctrl_dt_node_to_map_config(struct mtk_pinctrl *pctl, u32 pin,
> +               unsigned long *configs, unsigned num_configs,
> +               struct pinctrl_map **map, unsigned *cnt_maps,
> +               unsigned *num_maps)
> +{
> +       struct mtk_pinctrl_group *grp;
> +       unsigned long *cfgs;
> +
> +       if (*num_maps == *cnt_maps)
> +               return -ENOSPC;
> +
> +       cfgs = kmemdup(configs, num_configs * sizeof(*cfgs),
> +                      GFP_KERNEL);
> +       if (cfgs == NULL)
> +               return -ENOMEM;
> +
> +       grp = mtk_pctrl_find_group_by_pin(pctl, pin);
> +       if (!grp) {
> +               dev_err(pctl->dev, "unable to match pin %d to group\n", pin);
> +               return -EINVAL;
> +       }
> +
> +       (*map)[*num_maps].type = PIN_MAP_TYPE_CONFIGS_GROUP;
> +       (*map)[*num_maps].data.configs.group_or_pin = grp->name;
> +       (*map)[*num_maps].data.configs.configs = cfgs;
> +       (*map)[*num_maps].data.configs.num_configs = num_configs;
> +       (*num_maps)++;
> +
> +       return 0;
> +}

Can't this use pinctrl_utils_add_map_configs()?

> +static void mtk_pctrl_dt_free_map(struct pinctrl_dev *pctldev,
> +                                   struct pinctrl_map *map,
> +                                   unsigned num_maps)
> +{
> +       int i;
> +
> +       for (i = 0; i < num_maps; i++) {
> +               if (map[i].type == PIN_MAP_TYPE_CONFIGS_GROUP)
> +                       kfree(map[i].data.configs.configs);
> +       }
> +
> +       kfree(map);
> +}

Use pinctrl_utils_dt_free_map() instead.

> +static int mtk_dt_cnt_map(struct pinctrl_map **map, unsigned *cnt_maps,
> +               unsigned *num_maps, unsigned cnt)
> +{
> +       unsigned old_num = *cnt_maps;
> +       unsigned new_num = *num_maps + cnt;
> +       struct pinctrl_map *new_map;
> +
> +       if (old_num >= new_num)
> +               return 0;
> +
> +       new_map = krealloc(*map, sizeof(*new_map) * new_num, GFP_KERNEL);
> +       if (!new_map)
> +               return -ENOMEM;
> +
> +       memset(new_map + old_num, 0, (new_num - old_num) * sizeof(*new_map));
> +
> +       *map = new_map;
> +       *cnt_maps = new_num;
> +
> +       return 0;
> +}

Use pinctrl_utils_reserve_map() instead.

> +static int mtk_pctrl_dt_subnode_to_map(struct pinctrl_dev *pctldev,
> +                                     struct device_node *node,
> +                                     struct pinctrl_map **map,
> +                                     unsigned *num_maps, unsigned *cnt_maps)
> +{
> +       struct property *pins;
> +       u32 pinfunc, pin, func;
> +       int num_pins, num_funcs, maps_per_pin;
> +       unsigned long *configs;
> +       unsigned int num_configs;
> +       bool has_config = 0;
> +       int i, err;
> +       unsigned cnt = 0;
> +       struct mtk_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
> +
> +       pins = of_find_property(node, "mediatek,pins", NULL);
> +       if (!pins) {
> +               dev_err(pctl->dev, "missing mediatek,pins property in node %s .\n",
> +                               node->name);
> +               return -EINVAL;
> +       }
> +
> +       err = pinconf_generic_parse_dt_config(node, &configs, &num_configs);
> +       if (num_configs)
> +               has_config = 1;

I'd prefer we first identify if it's a config or mux subnode, then go on to
parse it as mux or config. See comments on patch 2/3.

> +
> +       num_pins = pins->length / sizeof(u32);
> +       num_funcs = num_pins;
> +       maps_per_pin = 0;
> +       if (num_funcs)
> +               maps_per_pin++;
> +       if (has_config && num_pins >= 1)
> +               maps_per_pin++;
> +
> +       if (!num_pins || !maps_per_pin)
> +               return -EINVAL;
> +
> +       cnt = num_pins * maps_per_pin;
> +
> +       err = mtk_dt_cnt_map(map, cnt_maps, num_maps, cnt);
> +       if (err < 0)
> +               goto fail;
> +
> +       for (i = 0; i < num_pins; i++) {
> +               err = of_property_read_u32_index(node, "mediatek,pins",
> +                               i, &pinfunc);

As mentioned use just "pins" and let's figure out how to handle
this in a generic way.

> +static int mtk_gpio_request(struct gpio_chip *chip, unsigned offset)
> +{
> +       return pinctrl_request_gpio(chip->base + offset);
> +}
> +
> +static void mtk_gpio_free(struct gpio_chip *chip, unsigned offset)
> +{
> +       pinctrl_free_gpio(chip->base + offset);
> +}
> +
> +static int mtk_gpio_direction_input(struct gpio_chip *chip,
> +                                       unsigned offset)
> +{
> +       return pinctrl_gpio_direction_input(chip->base + offset);
> +}
> +
> +static int mtk_gpio_direction_output(struct gpio_chip *chip,
> +                                       unsigned offset, int value)
> +{
> +       mtk_gpio_set(chip, offset, value);
> +       return pinctrl_gpio_direction_output(chip->base + offset);
> +}

This is kinda nice!

> +static int mtk_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
> +{
> +       struct mtk_pinctrl *pctl = dev_get_drvdata(chip->dev);
> +       struct mtk_pinctrl_group *g = pctl->groups + offset;
> +       struct mtk_desc_function *desc =
> +                       mtk_pctrl_desc_find_irq_function_from_name(
> +                                       pctl, g->name);
> +       if (!desc)
> +               return -EINVAL;
> +
> +       return desc->irqnum;
> +}

I don't quite get this still. Does this mean every single GPIO line
potentially has it's own unique IRQ line?

Yours,
Linus Walleij

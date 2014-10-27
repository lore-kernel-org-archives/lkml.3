Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802AbaJ0QUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:20:54 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35255 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbaJ0QUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:20:52 -0400
MIME-Version: 1.0
In-Reply-To: <1412823327-10296-3-git-send-email-blogic@openwrt.org>
References: <1412823327-10296-1-git-send-email-blogic@openwrt.org>
	<1412823327-10296-3-git-send-email-blogic@openwrt.org>
Date: Mon, 27 Oct 2014 17:20:51 +0100
Message-ID: <CACRpkdbF-tvMV7iXdy9EMJbSWu6SmihJN+B7=6pAAVgiymPUtg@mail.gmail.com>
Subject: Re: [PATCH 2/4] pinctrl: ralink: add a pinctrl driver for the rt2880
 family of SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: John Crispin <blogic@openwrt.org>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MIPS <linux-mips@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 9, 2014 at 4:55 AM, John Crispin <blogic@openwrt.org> wrote:

> These Socs have 1-3 banks of 8-32 gpios. Rather then setting the muxing of each
> pin individually, these socs have mux groups that when set will effect 1-N pins.
> Pin groups have a 2, 4 or 8 different muxes.
>
> Signed-off-by: John Crispin <blogic@openwrt.org>

Overall this looks nice, some minor things....

> +struct rt2880_priv {
> +       struct device *dev;
> +
> +       struct pinctrl_pin_desc *pads;
> +       struct pinctrl_desc *desc;
> +
> +       struct rt2880_pmx_func **func;
> +       int func_count;
> +
> +       struct rt2880_pmx_group *groups;
> +       const char **group_names;
> +       int group_count;
> +
> +       uint8_t *gpio;

Just use u8

> +       int max_pins;
> +};

Some of this would need some kerneldoc, don't you think?

> +static void rt2880_pinctrl_dt_free_map(struct pinctrl_dev *pctrldev,
> +                                   struct pinctrl_map *map, unsigned num_maps)
> +{
> +       int i;
> +
> +       for (i = 0; i < num_maps; i++)
> +               if (map[i].type == PIN_MAP_TYPE_CONFIGS_PIN ||
> +                   map[i].type == PIN_MAP_TYPE_CONFIGS_GROUP)
> +                       kfree(map[i].data.configs.configs);
> +       kfree(map);
> +}

Can you use pinctrl_utils_dt_free_map()
from
#include "pinctrl-utils.h"
for this?

> +static void rt2880_pinctrl_pin_dbg_show(struct pinctrl_dev *pctrldev,
> +                                       struct seq_file *s,
> +                                       unsigned offset)
> +{
> +       seq_puts(s, "ralink pio");
> +}

Hmmm rather terse debug info don't you think... ;)

> +static void rt2880_pinctrl_dt_subnode_to_map(struct pinctrl_dev *pctrldev,
> +                               struct device_node *np,
> +                               struct pinctrl_map **map)
> +{
> +       const char *function;
> +       int func = of_property_read_string(np, "ralink,function", &function);
> +       int grps = of_property_count_strings(np, "ralink,group");

There are now standard bindings for "function" and "group" so please
if you can, just use "function" and "group".

See:
Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
"Generic pin multiplexing node content"

I also wanted to provide a generic parsing function for it actually,
since so many drivers look alike.

> +static int rt2880_pinctrl_dt_node_to_map(struct pinctrl_dev *pctrldev,
> +                               struct device_node *np_config,
> +                               struct pinctrl_map **map,
> +                               unsigned *num_maps)
> +{
> +       int max_maps = 0;
> +       struct pinctrl_map *tmp;
> +       struct device_node *np;
> +
> +       for_each_child_of_node(np_config, np) {
> +               int ret = of_property_count_strings(np, "ralink,group");
> +
> +               if (ret >= 0)
> +                       max_maps += ret;
> +       }
> +
> +       if (!max_maps)
> +               return max_maps;
> +
> +       *map = kzalloc(max_maps * sizeof(struct pinctrl_map),
> +                                       GFP_KERNEL);

Can you use pinctrl_utils_reserve_map() here?

> +static int rt2880_pmx_group_enable(struct pinctrl_dev *pctrldev,
> +                               unsigned func,
> +                               unsigned group)


We don't have an "enable" callback anymore.
Rename this rt2880_pmx_set_mux().

> +static const struct pinmux_ops rt2880_pmx_group_ops = {
> +       .get_functions_count    = rt2880_pmx_func_count,
> +       .get_function_name      = rt2880_pmx_func_name,
> +       .get_function_groups    = rt2880_pmx_group_get_groups,
> +       .enable                 = rt2880_pmx_group_enable,

.set_mux rather than .enable

And make sure you test this on say v3.18-rc2.

> +static struct rt2880_pmx_func gpio_func = {
> +       .name = "gpio",
> +};

Hmmmmmm

> +static int rt2880_pinmux_index(struct rt2880_priv *p)
> +{
> +       struct rt2880_pmx_func **f;
> +       struct rt2880_pmx_group *mux = p->groups;
> +       int i, j, c = 0;
> +
> +       /* count the mux functions */
> +       while (mux->name) {
> +               p->group_count++;
> +               mux++;
> +       }
> +
> +       /* allocate the group names array needed by the gpio function */
> +       p->group_names = devm_kzalloc(p->dev,
> +               sizeof(char *) * p->group_count, GFP_KERNEL);
> +       if (!p->group_names)
> +               return -1;
> +
> +       for (i = 0; i < p->group_count; i++) {
> +               p->group_names[i] = p->groups[i].name;
> +               p->func_count += p->groups[i].func_count;
> +       }
> +
> +       /* we have a dummy function[0] for gpio */
> +       p->func_count++;
> +
> +       /* allocate our function and group mapping index buffers */
> +       f = p->func = devm_kzalloc(p->dev,
> +               sizeof(struct rt2880_pmx_func) * p->func_count, GFP_KERNEL);
> +       gpio_func.groups = devm_kzalloc(p->dev, sizeof(int) * p->group_count,
> +               GFP_KERNEL);
> +       if (!f || !gpio_func.groups)
> +               return -1;

Can you explain what this code is doing a bit more.

Are you avoiding to use gpio ranges by instead providing that
"gpio" function on each and every pin?

> +static int rt2880_pinmux_probe(struct platform_device *pdev)
> +{
> +       struct rt2880_priv *p;
> +       struct pinctrl_dev *dev;
> +       struct device_node *np;
> +
> +       if (!rt2880_pinmux_data)
> +               return -ENOSYS;
> +
> +       /* setup the private data */
> +       p = devm_kzalloc(&pdev->dev, sizeof(struct rt2880_priv), GFP_KERNEL);
> +       if (!p)
> +               return -ENOMEM;
> +
> +       p->dev = &pdev->dev;
> +       p->desc = &rt2880_pctrl_desc;
> +       p->groups = rt2880_pinmux_data;
> +       platform_set_drvdata(pdev, p);
> +
> +       /* init the device */
> +       if (rt2880_pinmux_index(p)) {
> +               dev_err(&pdev->dev, "failed to load index\n");
> +               return -EINVAL;
> +       }
> +       if (rt2880_pinmux_pins(p)) {
> +               dev_err(&pdev->dev, "failed to load pins\n");
> +               return -EINVAL;
> +       }

What is this "loading" that is happening here?

> +       dev = pinctrl_register(p->desc, &pdev->dev, p);
> +       if (IS_ERR(dev))
> +               return PTR_ERR(dev);
> +
> +       /* finalize by adding gpio ranges for enables gpio controllers */
> +       for_each_compatible_node(np, NULL, "ralink,rt2880-gpio") {
> +               const __be32 *ngpio, *gpiobase;
> +               struct pinctrl_gpio_range *range;
> +               char *name;
> +
> +               if (!of_device_is_available(np))
> +                       continue;
> +
> +               ngpio = of_get_property(np, "ralink,num-gpios", NULL);
> +               gpiobase = of_get_property(np, "ralink,gpio-base", NULL);

NO GPIO BASE in the device tree.

We have NACKed this so many times that I don't know it anymore.

The gpiobase is a linux-internal thing and not OS neutral at all.

So it has nothing to do in the device tree.

(If it was allowed it would atleast be linux,gpio-base)

Several other ways to handle this is available, the best being...
(see below)

> +               if (!ngpio || !gpiobase) {
> +                       dev_err(&pdev->dev, "failed to load chip info\n");
> +                       return -EINVAL;
> +               }
> +
> +               range = devm_kzalloc(p->dev,
> +                       sizeof(struct pinctrl_gpio_range) + 4, GFP_KERNEL);
> +               range->name = name = (char *) &range[1];
> +               sprintf(name, "pio");
> +               range->npins = __be32_to_cpu(*ngpio);
> +               range->base = __be32_to_cpu(*gpiobase);
> +               range->pin_base = range->base;
> +               pinctrl_add_gpio_range(dev, range);

...to NOT do this but instead use
gpiochip_add_pin_range() or gpiochip_add_pingroup_range()
from the gpiochip side.

The gpiochip has the ability to add ranges completely dynamically
as it can get a relative offset from the pin control subsystem.
It doesn't work the other way around unfortunately.

So I'd suggest you look at ways to modify your GPIO driver
to do this.

> +core_initcall_sync(rt2880_pinmux_init);

Do you really need it this early?

Yours,
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbaKKOyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:54:03 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:48832 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbaKKOyA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:54:00 -0500
MIME-Version: 1.0
In-Reply-To: <1415041531-15520-4-git-send-email-soren.brinkmann@xilinx.com>
References: <1415041531-15520-1-git-send-email-soren.brinkmann@xilinx.com>
	<1415041531-15520-4-git-send-email-soren.brinkmann@xilinx.com>
Date: Tue, 11 Nov 2014 15:53:59 +0100
Message-ID: <CACRpkdYfj2ydLQ4q_FKwXo73jzNsvj9u2Aem9EiuEw-OCvurrg@mail.gmail.com>
Subject: Re: [PATCH 3/7] pinctrl: pinconf-generic: Allow driver to specify DT params
From: Linus Walleij <linus.walleij@linaro.org>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Bjorn Andersson <Bjorn.Andersson@sonymobile.com>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-rockchip@lists.infradead.org,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 8:05 PM, Soren Brinkmann
<soren.brinkmann@xilinx.com> wrote:

> Additionally to the generic DT parameters, allow drivers to provide
> driver-specific DT parameters to be used with the generic parser
> infrastructure.
>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

I like the looks of this, but the patch description is a bit terse.
I'd like it to describe some of the refactorings being done
to the intrinsics, because I have a hard time following the patch.

First please rebase onto the "devel" branch in the pin control
tree, and notice that drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
which is merged there is actually doing this already:


        for_each_child_of_node(np_config, np) {
                ret = pinconf_generic_dt_subnode_to_map(pctldev, np, map,
                                                        &reserv, nmaps, type);
                if (ret)
                        break;

                ret = pmic_gpio_dt_subnode_to_map(pctldev, np, map, &reserv,
                                                  nmaps, type);
                if (ret)
                        break;
        }

So it should be patched to illustrate the point of this code.

I'd like feedback from Ivan+Björn on the code too if possible.

> -       ret = pinconf_generic_parse_dt_config(np, &configs, &nconfigs);
> +       ret = pinconf_generic_parse_dt_config(np, pctldev, &configs, &nconfigs);
>         if (nconfigs)
>                 has_config = 1;
>         np_config = of_parse_phandle(np, "ste,config", 0);
>         if (np_config) {
> -               ret = pinconf_generic_parse_dt_config(np_config, &configs,
> -                               &nconfigs);
> +               ret = pinconf_generic_parse_dt_config(np_config, pctldev,
> +                               &configs, &nconfigs);

This code is patched upstream so that ABx500 only uses generic config.
Again rebase on "devel"

> -void pinconf_generic_dump_pin(struct pinctrl_dev *pctldev,
> -                             struct seq_file *s, unsigned pin)
> +static void _pinconf_generic_dump(struct pinctrl_dev *pctldev,
> +                                 struct seq_file *s, const char *gname,
> +                                 unsigned pin,
> +                                 const struct pin_config_item *items,
> +                                 int nitems)

Don't use functions named _foo, actually the underscore is for
preprocessor and compiler things in my book, just give it an intuitive
name instead. Like pinconf_generic_dump_one() if that is suitable
or whatever.

This changes the function signature from something quite intuitively
understood to something pretty hard to understand, so you need to
add kerneldoc to it. (That also enhance my understanding of the
patch.)

> -void pinconf_generic_dump_group(struct pinctrl_dev *pctldev,
> -                             struct seq_file *s, const char *gname)
> +static void pinconf_generic_dump(struct pinctrl_dev *pctldev,
> +                                struct seq_file *s, const char *gname,
> +                                unsigned pin)

This looks intuitive and nice.

> +       _pinconf_generic_dump(pctldev, s, gname, pin,
> +                             conf_items, ARRAY_SIZE(conf_items));
> +       if (pctldev->desc->num_dt_params) {
> +               BUG_ON(!pctldev->desc->conf_items);

Don't use BUG_ON() like that, it's nasty. Always try to
recover and bail out instead.

> +void pinconf_generic_dump_pin(struct pinctrl_dev *pctldev,
> +                             struct seq_file *s, unsigned pin)
> +{
> +       pinconf_generic_dump(pctldev, s, NULL, pin);
> +}
> +
> +void pinconf_generic_dump_group(struct pinctrl_dev *pctldev,
> +                             struct seq_file *s, const char *gname)
> +{
> +       pinconf_generic_dump(pctldev, s, gname, 0);
> +}

Do you really need these helpers? Isn't it simpler just
to call the generic function with the different arguments?

> @@ -148,17 +132,22 @@ void pinconf_generic_dump_config(struct pinctrl_dev *pctldev,
>                 seq_printf(s, "%s: 0x%x", conf_items[i].display,
>                            pinconf_to_config_argument(config));
>         }
> +
> +       if (!pctldev->desc->num_dt_params)
> +               return;
> +
> +       BUG_ON(!pctldev->desc->conf_items);

No BUG_ON() dev_err() and exit.

> +static void _parse_dt_cfg(struct device_node *np,
> +                         const struct pinconf_generic_dt_params *params,
> +                         unsigned int count,
> +                         unsigned long *cfg,
> +                         unsigned int *ncfg)

Should return an error code right? Kerneldoc doesn't hurt either.

> +{
> +       int i;
> +
> +       for (i = 0; i < count; i++) {
> +               u32 val;
> +               int ret;
> +               const struct pinconf_generic_dt_params *par = &params[i];
> +
> +               ret = of_property_read_u32(np, par->property, &val);

Not checking this return value. Alter the function to return an
int value on success.

> +
> +               /* property not found */
> +               if (ret == -EINVAL)
> +                       continue;
> +
> +               /* use default value, when no value is specified */
> +               if (ret)
> +                       val = par->default_value;
> +
> +               pr_debug("found %s with value %u\n", par->property, val);
> +               cfg[*ncfg] = pinconf_to_config_packed(par->param, val);
> +               (*ncfg)++;
> +       }
> +}

There is something very unintuitive about this loop. You pass two
counter indexes (count, ncfg) in basically, that is looking weird,
does it have to look like that? Especially since there is no
bounds check on ncfg!

Just use one index in the loop please. Assign  *ncfg = ... after
the loop has *successfully* iterated.

>  int pinconf_generic_parse_dt_config(struct device_node *np,
> +                                   struct pinctrl_dev *pctldev,
>                                     unsigned long **configs,
>                                     unsigned int *nconfigs)

This is a good refactoring, but no _foo naming!

>  {
>         unsigned long *cfg;
> -       unsigned int ncfg = 0;
> +       unsigned int max_cfg, ncfg = 0;
>         int ret;
> -       int i;
> -       u32 val;
>
>         if (!np)
>                 return -EINVAL;
>
>         /* allocate a temporary array big enough to hold one of each option */
> -       cfg = kzalloc(sizeof(*cfg) * ARRAY_SIZE(dt_params), GFP_KERNEL);
> +       max_cfg = ARRAY_SIZE(dt_params);
> +       if (pctldev)
> +               max_cfg += pctldev->desc->num_dt_params;
> +       cfg = kcalloc(max_cfg, sizeof(*cfg), GFP_KERNEL);

Aha this looks good...

> +       _parse_dt_cfg(np, dt_params, ARRAY_SIZE(dt_params), cfg, &ncfg);
> +       if (pctldev && pctldev->desc->num_dt_params) {
> +               BUG_ON(!pctldev->desc->params);

No BUG_ON()

> +               _parse_dt_cfg(np, pctldev->desc->params,
> +                             pctldev->desc->num_dt_params, cfg, &ncfg);

This looks similar to what Qualcomm's driver is doing.

Yours,
Linus Walleij

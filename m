Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbaJ1Pkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 11:40:42 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:33469 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaJ1Pkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 11:40:41 -0400
MIME-Version: 1.0
In-Reply-To: <1413792260-4265-4-git-send-email-antoine.tenart@free-electrons.com>
References: <1413792260-4265-1-git-send-email-antoine.tenart@free-electrons.com>
	<1413792260-4265-4-git-send-email-antoine.tenart@free-electrons.com>
Date: Tue, 28 Oct 2014 16:40:40 +0100
Message-ID: <CACRpkdZ7H=yApLia7-OeM4RMPdM0Upk3wohGHgMYfhe3DiaPgg@mail.gmail.com>
Subject: Re: [PATCH 3/4] pinctrl: add a generic way to map node to map for
 group based drivers
From: Linus Walleij <linus.walleij@linaro.org>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 10:04 AM, Antoine Tenart
<antoine.tenart@free-electrons.com> wrote:

> This patch add a generic function to use a standard callback to
> .dt_node_to_map for group based pinctrl drivers.
>
> It parses nodes of the form:
>
>         foo_pmux: foo-pmux {
>                 function = "foo";
>                 groups = "g0", "g1", "g2";
>         }
>
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>

Really nice! :)

> +int pinconf_generic_function_groups_dt_node_to_map(struct pinctrl_dev *pctldev,
> +               struct device_node *node, struct pinctrl_map **map,
> +               unsigned *num_maps)
> +{
> +       struct property *prop;
> +       unsigned reserved_maps = 0;
> +       const char *function_name, *group_name;
> +       int ngroups, ret;
> +
> +       *map = NULL;
> +       *num_maps = 0;
> +
> +       ret = of_pinctrl_utils_read_function(pctldev, node, &function_name,
> +                                            &ngroups);
> +       if (ret)
> +               return ret;

So maybe you want this not to print errors as I said in the first patch.

Or add a function of_pinctrl_utils_is_mux()?

> +       ret = pinctrl_utils_reserve_map(pctldev, map, &reserved_maps, num_maps,
> +                                       ngroups);
> +       if (ret)
> +               return ret;
> +
> +       of_pinctrl_for_each_function_group(node, prop, group_name) {
> +               ret = pinctrl_utils_add_map_mux(pctldev, map, &reserved_maps,
> +                                               num_maps, group_name,
> +                                               function_name);
> +               if (ret) {
> +                       dev_err(pctldev->dev, "cannot add map: %d\n", ret);
> +                       return ret;
> +               }
> +       }
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(pinconf_generic_function_groups_dt_node_to_map);

The rest looks really good.

Yours,
Linus Walleij

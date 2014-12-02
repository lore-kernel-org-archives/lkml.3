Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbaLBPBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 10:01:39 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:50089 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057AbaLBPBg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 10:01:36 -0500
MIME-Version: 1.0
In-Reply-To: <1417137993-8337-2-git-send-email-soren.brinkmann@xilinx.com>
References: <1417137993-8337-1-git-send-email-soren.brinkmann@xilinx.com>
	<1417137993-8337-2-git-send-email-soren.brinkmann@xilinx.com>
Date: Tue, 2 Dec 2014 16:01:35 +0100
Message-ID: <CACRpkdbd2cAD5osYnwKTg4d1MwSjNF9i3Y+6ryjc_qLsg46Wtg@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] pinctrl: pinconf-generic: Infer map type from DT property
From: Linus Walleij <linus.walleij@linaro.org>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 2:26 AM, Soren Brinkmann
<soren.brinkmann@xilinx.com> wrote:

> With the new 'groups' property, the DT parser can infer the map type
> from the fact whether 'pins' or 'groups' is used to specify the pin
> group to work on.
> To maintain backwards compatibitliy with current usage of the DT
> binding, this is only done when an invalid map type is passed to the
> parsing function.
>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Tested-by: Andreas Färber <afaerber@suse.de>
> ---
> Changes since RFC v2:
>  - none

OK there are problems with this.

> @@ -264,6 +264,7 @@ int pinconf_generic_dt_subnode_to_map(struct pinctrl_dev *pctldev,
>         unsigned reserve;
>         struct property *prop;
>         const char *group;
> +       const char *dt_pin_specifier = "pins";

Something called "dt_pin_specifier" contains the string "pins"...

>
>         ret = of_property_read_string(np, "function", &function);
>         if (ret < 0) {
> @@ -284,10 +285,20 @@ int pinconf_generic_dt_subnode_to_map(struct pinctrl_dev *pctldev,
>                 reserve++;
>         if (num_configs)
>                 reserve++;
> +
>         ret = of_property_count_strings(np, "pins");
>         if (ret < 0) {
> -               dev_err(dev, "could not parse property pins\n");
> -               goto exit;
> +               ret = of_property_count_strings(np, "groups");
> +               if (ret < 0) {
> +                       dev_err(dev, "could not parse property pins/groups\n");
> +                       goto exit;
> +               }
> +               if (type == PIN_MAP_TYPE_INVALID)
> +                       type = PIN_MAP_TYPE_CONFIGS_GROUP;
> +               dt_pin_specifier = "groups";

Then suddenly "groups".

The pointer variable should be named something like "subnode_target_type"
or so.

> +++ b/include/linux/pinctrl/pinconf-generic.h
> @@ -174,6 +174,13 @@ static inline int pinconf_generic_dt_node_to_map_pin(
>                         PIN_MAP_TYPE_CONFIGS_PIN);
>  }
>
> +static inline int pinconf_generic_dt_node_to_map_all(
> +               struct pinctrl_dev *pctldev, struct device_node *np_config,
> +               struct pinctrl_map **map, unsigned *num_maps)
> +{
> +       return pinconf_generic_dt_node_to_map(pctldev, np_config, map, num_maps,
> +                       PIN_MAP_TYPE_INVALID);
> +}

First add some comment describing what happens here and why
INVALID is specified.

Then what does this have to do with the $subject?

Atleast mention in the commit text that a new helper is added, though unused.

Yours,
Linus Walleij

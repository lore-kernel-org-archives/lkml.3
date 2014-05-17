Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337AbaEQKIc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 06:08:32 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:35066 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114AbaEQKIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 06:08:30 -0400
Message-ID: <5377351A.6000609@gmail.com>
Date: Sat, 17 May 2014 12:08:26 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>,
        linus.walleij@linaro.org
CC: alexandre.belloni@free-electrons.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/7] pinctrl: berlin: add the core pinctrl driver for
 Marvell Berlin SoCs
References: <1399267649-20218-1-git-send-email-antoine.tenart@free-electrons.com> <1399267649-20218-2-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1399267649-20218-2-git-send-email-antoine.tenart@free-electrons.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2014 07:27 AM, Antoine Ténart wrote:
> The Marvell Berlin boards have a group based pinmuxing mechanism. This
> adds the core driver support. We actually do not need any information
> about the pins here and only have the definition of the groups.
> 
> Let's take the example of the uart0 pinmuxing on the BG2Q. Balls BK4 and
> BH6 are muxed to respectively UART0 RX and TX if the group GSM12 is set
> to mode 0:
> 
> Group	Modes	Offset Base	Offset	LSB	Bit Width
> GSM12	3	sm_base		0x40	0x10	0x2
> 
> Ball	Group	Mode 0		Mode 1		Mode 2
> BK4	GSM12	UART0_RX	IrDA0_RX	GPIO9
> BH6	GSM12	UART0_TX	IrDA0_TX	GPIO10
> 
> So in order to configure BK4 -> UART0_TX and BH6 -> UART0_RX, we need
> to set (sm_base + 0x40 + 0x10) &= ff3fffff.
> 
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
[...]
> +static int berlin_pinctrl_dt_node_to_map(struct pinctrl_dev *pctrl_dev,
> +					 struct device_node *node,
> +					 struct pinctrl_map **map,
> +					 unsigned *num_maps)
> +{

Linus,

thinking of your request to make "function"/"groups" standard
properties, I guess you also had some corresponding helpers in
mind.

Looking at the map and free functions here, I can see no Berlin
specific code at all. One option would be to make those functions
a standard callback for .dt_node_to_map and .dt_free_map, i.e.
pinctrl_utils_function_group_dt_node_to_map.

IMHO, the more flexible option would be to rather have

of_pinctrl_utils_read_function(node, &function_name, &ngroups)
and
of_pinctrl_for_each_function_group(node, group_name)
swallowing the property names and reuse it like below.

The simple option would be to just remove the marvell, prefix
now and have a closer look at other pinctrl drivers to see what
will be required, of course.

Do you have any preference?

Sebastian

> +	struct berlin_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctrl_dev);
> +	struct property *prop;
> +	const char *function_name, *group_name;
> +	unsigned reserved_maps = 0;
> +	int ret, ngroups;
> +
> +	*map = NULL;
> +	*num_maps = 0;
> +
> +	ret = of_property_read_string(node, "marvell,function", &function_name);
> +	if (ret) {
> +		dev_err(pctrl->dev,
> +			"missing 'marvell,function' property in node %s\n",
> +			node->name);
> +		return -EINVAL;
> +	}
> +
> +	ngroups = of_property_count_strings(node, "marvell,groups");
> +	if (ngroups < 0) {
> +		dev_err(pctrl->dev,
> +			"missing 'marvell,groups' property in node %s\n",
> +			node->name);
> +		return -EINVAL;
> +	}
> +
> +	ret = pinctrl_utils_reserve_map(pctrl_dev, map, &reserved_maps,
> +					num_maps, ngroups);
> +	if (ret) {
> +		dev_err(pctrl->dev, "can't reserve map: %d\n", ret);
> +		return ret;
> +	}
> +
> +	of_property_for_each_string(node, "marvell,groups", prop, group_name) {
> +		ret = pinctrl_utils_add_map_mux(pctrl_dev, map, &reserved_maps,
> +						num_maps, group_name,
> +						function_name);
> +		if (ret) {
> +			dev_err(pctrl->dev, "can't add map: %d\n", ret);
> +			return ret;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static void berlin_pinctrl_dt_free_map(struct pinctrl_dev *pctrl_dev,
> +				       struct pinctrl_map *map,
> +				       unsigned nmaps)
> +{
> +	int i;
> +
> +	for (i = 0; i < nmaps; i++) {
> +		if (map[i].type == PIN_MAP_TYPE_MUX_GROUP) {
> +			kfree(map[i].data.mux.group);
> +
> +			/* a function can be applied to multiple groups */
> +			if (i == 0)
> +				kfree(map[i].data.mux.function);
> +		}
> +	}
> +
> +	kfree(map);
> +}
> +
> +static const struct pinctrl_ops berlin_pinctrl_ops = {
> +	.get_groups_count	= &berlin_pinctrl_get_group_count,
> +	.get_group_name		= &berlin_pinctrl_get_group_name,
> +	.dt_node_to_map		= &berlin_pinctrl_dt_node_to_map,
> +	.dt_free_map		= &berlin_pinctrl_dt_free_map,
> +};


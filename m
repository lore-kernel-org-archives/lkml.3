Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbaDKMh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 08:37:58 -0400
Received: from top.free-electrons.com ([176.31.233.9]:45897 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755733AbaDKMhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 08:37:52 -0400
Date: Fri, 11 Apr 2014 14:37:37 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: linus.walleij@linaro.org, alexandre.belloni@free-electrons.com,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 2/5] pinctrl: berlin: add a pinctrl driver for
 Marvell Berlin SoCs
Message-ID: <20140411123737.GA5903@kwain>
References: <1397135274-10764-1-git-send-email-antoine.tenart@free-electrons.com>
 <1397135274-10764-3-git-send-email-antoine.tenart@free-electrons.com>
 <5347AFF4.3050607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5347AFF4.3050607@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian,

On Fri, Apr 11, 2014 at 11:03:48AM +0200, Sebastian Hesselbarth wrote:
> On 04/10/2014 03:07 PM, Antoine Ténart wrote:
> >The Marvell Berlin boards have a group based pinmuxing mechanism. This
> >driver adds the support for the BG2CD, BG2 and BG2Q. We actually do not
> >need any information about the pins here and only have the definition
> >of the groups.
> 
> Antoine,
> 
> as always, thanks for providing this :)
> 
> >Let's take the example of the uart0 pinmuxing on the BG2Q. Balls BK4 and
> >BH6 are muxed to respectively UART0 RX and TX if the group GSM12 is set
> >to mode 0:
> >
> >Group	Modes	Offset Base	Offset	LSB	Bit Width
> >GSM12	3	sm_base		0x40	0x10	0x2
> >
> >Ball	Group	Mode 0		Mode 1		Mode 2
> >BK4	GSM12	UART0_RX	IrDA0_RX	GPIO9
> >BH6	GSM12	UART0_TX	IrDA0_TX	GPIO10
> 
> Actually, I consider above mode table a very vital information
> that is missing from the driver below. Especially, I expect bg2 and
> bg2cd different in some modes and there is no way to look it up.

They are.

> It doesn't matter if we know all mode names now, but we should
> have a placeholder at least.
> 
> Also, I know gpio<>pingroup relationship is very broken by design
> on berlin, but how are you planing to exploit that information?
> We will have some straight numbered gpios and need to determine
> what pingroup has to be switched.

I need to think about that.

> >So in order to configure BK4 -> UART0_TX and BH6 -> UART0_RX, we need
> >to set (sm_base + 0x40 + 0x10) &= ff3fffff.
> >
> >Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> >---
> >  drivers/pinctrl/Kconfig          |   4 +
> >  drivers/pinctrl/Makefile         |   1 +
> >  drivers/pinctrl/pinctrl-berlin.c | 498 +++++++++++++++++++++++++++++++++++++++
> >  drivers/pinctrl/pinctrl-berlin.h |  72 ++++++
> >  4 files changed, 575 insertions(+)
> >  create mode 100644 drivers/pinctrl/pinctrl-berlin.c
> >  create mode 100644 drivers/pinctrl/pinctrl-berlin.h
> >
> >diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
> >index e49324032611..2d9339a7bd05 100644
> >--- a/drivers/pinctrl/Kconfig
> >+++ b/drivers/pinctrl/Kconfig
> >@@ -104,6 +104,10 @@ config PINCTRL_BCM2835
> >  	select PINMUX
> >  	select PINCONF
> >
> >+config PINCTRL_BERLIN
> >+	bool
> >+	select PINMUX
> 
> select PINCTRL too and drop it from the individual SoC configs
> later on.

Will do.

> >  config PINCTRL_CAPRI
> >  	bool "Broadcom Capri pinctrl driver"
> >  	depends on OF
> >diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
> >index 4b835880cf80..fd5a01d4475f 100644
> >--- a/drivers/pinctrl/Makefile
> >+++ b/drivers/pinctrl/Makefile
> >@@ -21,6 +21,7 @@ obj-$(CONFIG_PINCTRL_BF60x)	+= pinctrl-adi2-bf60x.o
> >  obj-$(CONFIG_PINCTRL_AT91)	+= pinctrl-at91.o
> >  obj-$(CONFIG_PINCTRL_BCM2835)	+= pinctrl-bcm2835.o
> >  obj-$(CONFIG_PINCTRL_BAYTRAIL)	+= pinctrl-baytrail.o
> >+obj-$(CONFIG_PINCTRL_BERLIN)	+= pinctrl-berlin.o
> 
> Please split the driver into common and soc-specific parts, and if
> you do please put it into a subfolder berlin, too.

The only SoC specific part is the group structure. I'll need to have
functions in each SoC specific part calling ... only the common ones.
Do you have a better solution in mind ?

> >  obj-$(CONFIG_PINCTRL_CAPRI)	+= pinctrl-capri.o
> >  obj-$(CONFIG_PINCTRL_IMX)	+= pinctrl-imx.o
> >  obj-$(CONFIG_PINCTRL_IMX1_CORE)	+= pinctrl-imx1-core.o
> >diff --git a/drivers/pinctrl/pinctrl-berlin.c b/drivers/pinctrl/pinctrl-berlin.c
> >new file mode 100644
> >index 000000000000..a377d6fbb127
> >--- /dev/null
> >+++ b/drivers/pinctrl/pinctrl-berlin.c
> >@@ -0,0 +1,498 @@
> >+/*
> >+ * Marvell Berlin SoC pinctrl driver.
> >+ *
> >+ * Copyright (C) 2014 Marvell Technology Group Ltd.
> >+ *
> >+ * Antoine Ténart <antoine.tenart@free-electrons.com>
> >+ *
> >+ * This file is licensed under the terms of the GNU General Public
> >+ * License version 2. This program is licensed "as is" without any
> >+ * warranty of any kind, whether express or implied.
> >+ */
> >+
> >+#include <linux/io.h>
> >+#include <linux/module.h>
> >+#include <linux/of.h>
> >+#include <linux/of_address.h>
> >+#include <linux/of_device.h>
> >+#include <linux/pinctrl/pinctrl.h>
> >+#include <linux/pinctrl/pinmux.h>
> >+#include <linux/platform_device.h>
> >+#include <linux/slab.h>
> >+
> >+#include "core.h"
> >+#include "pinctrl-utils.h"
> >+#include "pinctrl-berlin.h"
> >+
> >+#define NFCTS(bit_width)	(1 << ((bit_width) + 1))
> 
> Number-of-FunCTionS ? You use that define twice, but maybe it is

Yes :)

> more clear to write it out where you use it. Otherwise it is
> kind of hard to get the idea.

OK, with a comment describing what's happening.

> >+static const struct berlin_desc_group berlin2cd_pinctrl_groups[] = {
> 
> First SoC in bg2 and bg2cd is possibly bg2. Use that one for the
> names please.

Will do.

> 
> >+	/* GSM */
> >+	BERLIN_PINCTRL_GROUP("GSM0",  "apb_base",    0x40, 0x2, 0x00),
> 
> I'd love to see the mode/function tables in here.
> 
> >+	BERLIN_PINCTRL_GROUP("GSM1",  "apb_base",    0x40, 0x2, 0x02),
> >+	BERLIN_PINCTRL_GROUP("GSM2",  "apb_base",    0x40, 0x2, 0x04),
> >+	BERLIN_PINCTRL_GROUP("GSM3",  "apb_base",    0x40, 0x2, 0x06),
> >+	BERLIN_PINCTRL_GROUP("GSM4",  "apb_base",    0x40, 0x2, 0x08),
> >+	BERLIN_PINCTRL_GROUP("GSM5",  "apb_base",    0x40, 0x2, 0x0a),
> >+	BERLIN_PINCTRL_GROUP("GSM6",  "apb_base",    0x40, 0x2, 0x0c),
> >+	BERLIN_PINCTRL_GROUP("GSM7",  "apb_base",    0x40, 0x1, 0x0e),
> >+	BERLIN_PINCTRL_GROUP("GSM8",  "apb_base",    0x40, 0x1, 0x0f),
> >+	BERLIN_PINCTRL_GROUP("GSM9",  "apb_base",    0x40, 0x1, 0x10),
> >+	BERLIN_PINCTRL_GROUP("GSM10", "apb_base",    0x40, 0x1, 0x11),
> >+	BERLIN_PINCTRL_GROUP("GSM11", "apb_base",    0x40, 0x1, 0x12),
> [...]
> >+static int berlin_pinctrl_get_group_count(struct pinctrl_dev *pctrl_dev)
> >+{
> >+	struct berlin_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctrl_dev);
> >+
> >+	return pctrl->ngroups;
> >+}
> >+
> >+static const char *berlin_pinctrl_get_group_name(struct pinctrl_dev *pctrl_dev,
> >+						 unsigned group)
> >+{
> >+	struct berlin_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctrl_dev);
> >+
> >+	return pctrl->groups[group].name;
> >+}
> >+
> >+static int berlin_pinctrl_dt_node_to_map(struct pinctrl_dev *pctrl_dev,
> >+					 struct device_node *node,
> >+					 struct pinctrl_map **map,
> >+					 unsigned *num_maps)
> >+{
> >+	struct berlin_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctrl_dev);
> >+	const char *group_name;
> >+	char *function_name;
> >+	unsigned reserved_maps = 0;
> >+	u32 function;
> >+	int ret;
> >+
> >+	*map = NULL;
> >+	*num_maps = 0;
> >+
> >+	ret = pinctrl_utils_reserve_map(pctrl_dev, map, &reserved_maps,
> >+					num_maps, 1);
> >+	if (ret) {
> >+		dev_err(pctrl->dev, "can't reserve map: %d\n", ret);
> >+		return ret;
> >+	}
> >+
> >+	ret = of_property_read_u32(node, "berlin,function", &function);
> 
> Properties should be _vendor_ prefixed, i.e. "marvell,function".

Right.

> >+	if (ret) {
> >+		dev_err(pctrl->dev,
> >+			"missing 'berlin,function' property in node %s\n",
> >+			node->name);
> >+		return -EINVAL;
> >+	}
> >+
> >+	ret = of_property_read_string(node, "berlin,group", &group_name);
> 
> ditto.
> 
> >+	if (ret) {
> >+		dev_err(pctrl->dev,
> >+			"missing 'berlin,group' property in node %s\n",
> >+			node->name);
> >+		return -EINVAL;
> >+	}
> >+
> >+	function_name = kzalloc(strlen(group_name) + 7, GFP_KERNEL);
> >+	if (!function_name)
> >+		return -ENOMEM;
> >+	snprintf(function_name, strlen(group_name) + 7, "%s_mode%d", group_name,
> >+			function);
> 
> With proper mode tables above, this can refer to a const char* and you
> can get rid of allocation here. Also, below you already allocated
> function_names, how is this one different from the below?

The one below is used to describe the available functions for a given group
while this one describe a function found in the device tree. It is used to check
the function we want to use in the device is provided by the driver. The
function name used here may not actually exist. We could check the function
actually exists here (and find the previously allocated function name), but this
check is handled by the pinctrl framework. This would end up in a different
behaviour than the expected one, imho.

[…]

> >+static int berlin_pinctrl_build_state(struct platform_device *pdev,
> >+			      struct berlin_pinctrl_reg_base *bases,
> >+			      unsigned nbases)
> >+{
> >+	struct berlin_pinctrl *pctrl = platform_get_drvdata(pdev);
> >+	int i, j, cur_fct = 0;
> >+
> >+	pctrl->ngroups = pctrl->desc->ngroups;
> >+	pctrl->nfunctions = 0;
> >+
> >+	for (i = 0; i < pctrl->ngroups; i++) {
> >+		struct berlin_desc_group const *desc = pctrl->desc->groups + i;
> >+		pctrl->nfunctions += NFCTS(desc->bit_width);
> >+	}
> 
> As you need desc later on, make it global to this function. Then you
> can also walk through it with desc++
> 
> desc = pctrl->desc->groups;
> for (i = 0; i < pctl->ngroups; i++, desc++)
> 	pctrl->nfunctions = ...
> 
> Having said that, the above assumes that each function is unique
> but IIRC the idea of the function table was to group pins/groups
> with the same function, e.g. function "gpio", groups 1,7,25,...

Most of the functions you can use on the Berlin they will be unique and would
only be used in one group, except for the 'gpio' one.

> >+	pctrl->groups = devm_kzalloc(&pdev->dev,
> >+				     pctrl->ngroups * sizeof(struct berlin_pinctrl_group),
> >+				     GFP_KERNEL);
> >+	if (!pctrl->groups)
> >+		return -ENOMEM;
> >+
> >+	pctrl->functions = devm_kzalloc(&pdev->dev,
> >+					pctrl->ngroups * pctrl->nfunctions *
> >+						sizeof(struct berlin_pinctrl_function),
> >+					GFP_KERNEL);
> >+	if (!pctrl->functions)
> >+		return -ENOMEM;
> >+
> >+	for (i = 0; i < pctrl->ngroups; i++) {
> >+		struct berlin_desc_group const *desc = pctrl->desc->groups + i;
> >+		struct berlin_pinctrl_group *group = pctrl->groups + i;
> >+
> >+		group->name = desc->name;
> >+		group->mask = GENMASK(desc->lsb + desc->bit_width - 1,
> >+				      desc->lsb);
> >+		group->lsb = desc->lsb;
> >+
> >+		for (j = 0; j < nbases; j++) {
> >+			if (!strcmp(desc->base_name, bases[j].name)) {
> >+				group->reg = bases[j].base + desc->offset;
> >+				break;
> >+			}
> >+		}
> >+
> >+		if (j == nbases) {
> >+			dev_err(pctrl->dev, "cannot find base address for %s\n",
> >+					desc->base_name);
> >+			return -EINVAL;
> >+		}
> 
> TBH, I am not so happy with this name<>reg relationship. What about
> having two separate pin controllers instead?

I'm OK with having separate pin controllers.

> >+		for (j = 0; j < NFCTS(desc->bit_width); j++) {
> >+			struct berlin_pinctrl_function *function =
> >+				pctrl->functions + cur_fct;
> >+			char *function_name = devm_kzalloc(&pdev->dev,
> >+							   (strlen(desc->name) + 7) * sizeof(char),
> >+							   GFP_KERNEL);
> >+			if (!function_name)
> >+				return -ENOMEM;
> 
> Allocating function_names again?
> 
> >+
> >+			snprintf(function_name, strlen(desc->name) + 7,
> >+				 "%s_mode%d", desc->name, j);
> >+
> >+			function->name = function_name;
> >+			function->group = desc->name;
> >+			function->muxval = j;
> >+
> >+			cur_fct++;
> >+		}
> >+	}
> >+
> >+	return 0;
> >+}
> >+
> >+static struct pinctrl_desc berlin_pctrl_desc = {
> >+	.name		= "berlin-pinctrl",
> >+	.pctlops	= &berlin_pinctrl_ops,
> >+	.pmxops		= &berlin_pinmux_ops,
> >+	.owner		= THIS_MODULE,
> >+};
> >+
> >+static const struct berlin_pinctrl_desc berlin2cd_pinctrl_data = {
> >+	.groups = berlin2cd_pinctrl_groups,
> >+	.ngroups = ARRAY_SIZE(berlin2cd_pinctrl_groups),
> >+};
> >+
> >+static const struct berlin_pinctrl_desc berlin2q_pinctrl_data = {
> >+	.groups = berlin2q_pinctrl_groups,
> >+	.ngroups = ARRAY_SIZE(berlin2q_pinctrl_groups),
> >+};
> >+
> >+static struct of_device_id berlin_pinctrl_match[] = {
> >+	{
> >+		.compatible = "marvell,berlin2cd-pinctrl",
> >+		.data = &berlin2cd_pinctrl_data
> >+	},
> >+	{
> >+		.compatible = "marvell,berlin2-pinctrl",
> >+		.data = &berlin2cd_pinctrl_data
> >+	},
> >+	{
> >+		.compatible = "marvell,berlin2q-pinctrl",
> >+		.data = &berlin2q_pinctrl_data
> >+	},
> >+	{}
> >+};
> >+MODULE_DEVICE_TABLE(of, berlin_pinctrl_match);
> 
> Please sort alphabetically.

Sure.

> >+
> >+static int berlin_pinctrl_probe(struct platform_device *pdev)
> >+{
> >+	struct device *dev = &pdev->dev;
> >+	struct device_node *node;
> >+	struct property *prop;
> >+	struct berlin_pinctrl *pctrl;
> >+	struct berlin_pinctrl_reg_base *bases;
> >+	const struct of_device_id *device;
> >+	const char *reg_name;
> >+	int ret, i = 0;
> >+	unsigned nbases;
> >+
> >+	if (!dev->of_node) {
> >+		dev_err(dev, "device node not found\n");
> 
> There is no way you will see this driver being called without
> .of_node set. I'll really have an eye on anybody who will try
> to introduce non-DT platform_device registration ;)
> 
> >+		return -ENODEV;
> >+	}
> >+	node = dev->of_node;
> >+
> >+	pctrl = devm_kzalloc(dev, sizeof(struct berlin_pinctrl), GFP_KERNEL);
> >+	if (!pctrl)
> >+		return -ENOMEM;
> >+
> >+	platform_set_drvdata(pdev, pctrl);
> >+
> >+	spin_lock_init(&pctrl->lock);
> >+
> >+	device = of_match_device(berlin_pinctrl_match, dev);
> 
> With the comment above, you can move the assignment right to the
> declaration. Also, it will always match.
> 
> >+	if (!device) {
> >+		dev_err(dev, "pinctrl didn't match\n");
> >+		return -ENODEV;
> >+	}
> >+
> >+	nbases = of_property_count_strings(node, "reg-names");
> >+	if (nbases < 0) {
> >+		dev_err(dev, "missing 'reg-names' property in node %s\n",
> >+				node->name);
> >+		return -EINVAL;
> >+	}
> 
> See my comment about names<>reg relation.
> 
> >+	bases = devm_kzalloc(dev,
> >+			     nbases * sizeof(struct berlin_pinctrl_reg_base),
> >+			     GFP_KERNEL);
> >+	if (!bases)
> >+		return -ENOMEM;
> > +
> >+	of_property_for_each_string(node, "reg-names", prop, reg_name) {
> >+		struct resource *r =
> >+			platform_get_resource_byname(pdev, IORESOURCE_MEM,
> >+						     reg_name);
> >+		bases[i].base = devm_ioremap_resource(&pdev->dev, r);
> >+		if (IS_ERR(bases[i].base))
> >+			return PTR_ERR(bases[i].base);
> >+
> >+		bases[i].name = reg_name;
> >+		i++;
> >+	}
> >+
> >+	pctrl->desc = (struct berlin_pinctrl_desc *)device->data;
> >+
> >+	ret = berlin_pinctrl_build_state(pdev, bases, nbases);
> >+	kfree(bases);
> >+	if (ret) {
> >+		dev_err(dev, "cannot build driver state: %d\n", ret);
> >+		return ret;
> >+	}
> >+
> >+	pctrl->dev = &pdev->dev;
> >+
> >+	pctrl->pctrl_dev = pinctrl_register(&berlin_pctrl_desc, dev, pctrl);
> >+	if (!pctrl->pctrl_dev) {
> >+		dev_err(dev, "failed to register pinctrl driver\n");
> >+		return -EINVAL;
> >+	}
> >+
> >+	return 0;
> >+}
> >+
> >+static struct platform_driver berlin_pinctrl_driver = {
> >+	.probe	= berlin_pinctrl_probe,
> >+	.driver	= {
> >+		.name = "berlin-pinctrl",
> >+		.owner = THIS_MODULE,
> >+		.of_match_table = berlin_pinctrl_match,
> >+	},
> >+};
> >+module_platform_driver(berlin_pinctrl_driver);
> >+
> >+MODULE_AUTHOR("Antoine Ténart <antoine.tenart@free-electrons.com>");
> >+MODULE_DESCRIPTION("Marvell Berlin pinctrl driver");
> >+MODULE_LICENSE("GPL");
> >diff --git a/drivers/pinctrl/pinctrl-berlin.h b/drivers/pinctrl/pinctrl-berlin.h
> >new file mode 100644
> >index 000000000000..db3e8a379e84
> >--- /dev/null
> >+++ b/drivers/pinctrl/pinctrl-berlin.h
> >@@ -0,0 +1,72 @@
> >+/*
> >+ * Marvell Berlin SoC pinctrl driver.
> >+ *
> >+ * Copyright (C) 2014 Marvell Technology Group Ltd.
> >+ *
> >+ * Antoine Ténart <antoine.tenart@free-electrons.com>
> >+ *
> >+ * This file is licensed under the terms of the GNU General Public
> >+ * License version 2. This program is licensed "as is" without any
> >+ * warranty of any kind, whether express or implied.
> >+ */
> >+
> >+#ifndef __PINCTRL_BERLIN_H
> >+#define __PINCTRL_BERLIN_H
> >+
> >+struct berlin_desc_group {
> >+	const char	*name;
> >+	const char	*base_name;
> >+	u32		offset;
> >+	u32		bit_width;
> >+	u32		lsb;
> 
> You expect any offsets, bit_widths or lsbs at 2^32-1 ? ;)

Sure :) I'll update.


Thanks for the review !

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

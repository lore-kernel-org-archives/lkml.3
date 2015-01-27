Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759899AbbA0UbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 15:31:07 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:37887 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759876AbbA0UbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 15:31:03 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niso@kth.se>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>
Subject: [RFC/PATCH] pinctrl: sh-pfc: Accept standard function, pins and groups properties
Date: Tue, 27 Jan 2015 22:31:34 +0200
Message-Id: <1422390694-12389-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.0.5
In-Reply-To: <CACRpkda4SBof0EaZVWtEYaeb6j_BGAVj39kje+mBz90eB3qAwQ@mail.gmail.com>
References: <CACRpkda4SBof0EaZVWtEYaeb6j_BGAVj39kje+mBz90eB3qAwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "function", "pins" and "groups" pinmux and pinctrl properties have
been standardized. Support them in addition to the custom "renesas,*"
properties. New-style and old-style properties can't be mixed in DT.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 .../bindings/pinctrl/renesas,pfc-pinctrl.txt       | 20 +++++------
 drivers/pinctrl/sh-pfc/pinctrl.c                   | 41 +++++++++++++++++-----
 2 files changed, 43 insertions(+), 18 deletions(-)

Hi Linus,

On Tuesday 27 January 2015 08:55:20 Linus Walleij wrote:
> On Sun, Jan 18, 2015 at 1:20 PM, Niklas Söderlund <niso@kth.se> wrote:
> > Configure the pinmux on kzm9d to use the serial connector for uart1.
> > 
> > Signed-off-by: Niklas Söderlund <niso@kth.se>
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> > +&pfc {
> > +       uart1_pins: uart@e1030000 {
> > +               renesas,groups = "uart1_ctrl", "uart1_data";
> > +               renesas,function = "uart1";
> > +       };
> > +};
> 
> Would be nice if the PFC driver could be augmented to also accept the
> now standard bindings "groups" and "function" simply :) we're adding parse
> functions for those to the core.

Something like this ?

Please note two differences between the Renesas PFC bindings and the standard
bindings:

- The standard bindings state that a pinctrl node must contain either a "pins"
  property or a "groups" property, while the Renesas bindings allows for both
  to coexist in the same node.

- The standard bindings don't allow a pinmux node to contain a "pins" property,
  while the Renesas bindings do.

This patch implements the Renesas behaviour with the standard properties. The
difference in behaviour might not be desired. Please let me know what you
think.

diff --git a/Documentation/devicetree/bindings/pinctrl/renesas,pfc-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/renesas,pfc-pinctrl.txt
index bfe72ec055e3..60d191911e80 100644
--- a/Documentation/devicetree/bindings/pinctrl/renesas,pfc-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/renesas,pfc-pinctrl.txt
@@ -56,12 +56,12 @@ are parsed through phandles and processed purely based on their content.
 
 Pin Configuration Node Properties:
 
-- renesas,pins : An array of strings, each string containing the name of a pin.
-- renesas,groups : An array of strings, each string containing the name of a pin
+- pins : An array of strings, each string containing the name of a pin.
+- groups : An array of strings, each string containing the name of a pin
   group.
 
-- renesas,function: A string containing the name of the function to mux to the
-  pin group(s) specified by the renesas,groups property
+- function: A string containing the name of the function to mux to the pin
+  group(s) specified by the groups property.
 
   Valid values for pin, group and function names can be found in the group and
   function arrays of the PFC data file corresponding to the SoC
@@ -139,19 +139,19 @@ Example 3: KZM-A9-GT (SH-Mobile AG5) default pin state hog and pin control maps
 
 		mmcif_pins: mmcif {
 			mux {
-				renesas,groups = "mmc0_data8_0", "mmc0_ctrl_0";
-				renesas,function = "mmc0";
+				groups = "mmc0_data8_0", "mmc0_ctrl_0";
+				function = "mmc0";
 			};
 			cfg {
-				renesas,groups = "mmc0_data8_0";
-				renesas,pins = "PORT279";
+				groups = "mmc0_data8_0";
+				pins = "PORT279";
 				bias-pull-up;
 			};
 		};
 
 		scifa4_pins: scifa4 {
-			renesas,groups = "scifa4_data", "scifa4_ctrl";
-			renesas,function = "scifa4";
+			groups = "scifa4_data", "scifa4_ctrl";
+			function = "scifa4";
 		};
 	};
 
diff --git a/drivers/pinctrl/sh-pfc/pinctrl.c b/drivers/pinctrl/sh-pfc/pinctrl.c
index 072e7c62cab7..522909e74b2e 100644
--- a/drivers/pinctrl/sh-pfc/pinctrl.c
+++ b/drivers/pinctrl/sh-pfc/pinctrl.c
@@ -40,6 +40,10 @@ struct sh_pfc_pinctrl {
 
 	struct pinctrl_pin_desc *pins;
 	struct sh_pfc_pin_config *configs;
+
+	const char *func_prop_name;
+	const char *groups_prop_name;
+	const char *pins_prop_name;
 };
 
 static int sh_pfc_get_groups_count(struct pinctrl_dev *pctldev)
@@ -96,10 +100,13 @@ static int sh_pfc_map_add_config(struct pinctrl_map *map,
 	return 0;
 }
 
-static int sh_pfc_dt_subnode_to_map(struct device *dev, struct device_node *np,
+static int sh_pfc_dt_subnode_to_map(struct pinctrl_dev *pctldev,
+				    struct device_node *np,
 				    struct pinctrl_map **map,
 				    unsigned int *num_maps, unsigned int *index)
 {
+	struct sh_pfc_pinctrl *pmx = pinctrl_dev_get_drvdata(pctldev);
+	struct device *dev = pmx->pfc->dev;
 	struct pinctrl_map *maps = *map;
 	unsigned int nmaps = *num_maps;
 	unsigned int idx = *index;
@@ -113,10 +120,27 @@ static int sh_pfc_dt_subnode_to_map(struct device *dev, struct device_node *np,
 	const char *pin;
 	int ret;
 
+	/* Support both the old Renesas-specific properties and the new standard
+	 * properties. Mixing old and new properties isn't allowed, neither
+	 * inside a subnode nor across subnodes.
+	 */
+	if (!pmx->func_prop_name) {
+		if (of_find_property(np, "groups", NULL) ||
+		    of_find_property(np, "pins", NULL)) {
+			pmx->func_prop_name = "function";
+			pmx->groups_prop_name = "groups";
+			pmx->pins_prop_name = "pins";
+		} else {
+			pmx->func_prop_name = "renesas,function";
+			pmx->groups_prop_name = "renesas,groups";
+			pmx->pins_prop_name = "renesas,pins";
+		}
+	}
+
 	/* Parse the function and configuration properties. At least a function
 	 * or one configuration must be specified.
 	 */
-	ret = of_property_read_string(np, "renesas,function", &function);
+	ret = of_property_read_string(np, pmx->func_prop_name, &function);
 	if (ret < 0 && ret != -EINVAL) {
 		dev_err(dev, "Invalid function in DT\n");
 		return ret;
@@ -129,11 +153,12 @@ static int sh_pfc_dt_subnode_to_map(struct device *dev, struct device_node *np,
 	if (!function && num_configs == 0) {
 		dev_err(dev,
 			"DT node must contain at least a function or config\n");
+		ret = -ENODEV;
 		goto done;
 	}
 
 	/* Count the number of pins and groups and reallocate mappings. */
-	ret = of_property_count_strings(np, "renesas,pins");
+	ret = of_property_count_strings(np, pmx->pins_prop_name);
 	if (ret == -EINVAL) {
 		num_pins = 0;
 	} else if (ret < 0) {
@@ -143,7 +168,7 @@ static int sh_pfc_dt_subnode_to_map(struct device *dev, struct device_node *np,
 		num_pins = ret;
 	}
 
-	ret = of_property_count_strings(np, "renesas,groups");
+	ret = of_property_count_strings(np, pmx->groups_prop_name);
 	if (ret == -EINVAL) {
 		num_groups = 0;
 	} else if (ret < 0) {
@@ -174,7 +199,7 @@ static int sh_pfc_dt_subnode_to_map(struct device *dev, struct device_node *np,
 	*num_maps = nmaps;
 
 	/* Iterate over pins and groups and create the mappings. */
-	of_property_for_each_string(np, "renesas,groups", prop, group) {
+	of_property_for_each_string(np, pmx->groups_prop_name, prop, group) {
 		if (function) {
 			maps[idx].type = PIN_MAP_TYPE_MUX_GROUP;
 			maps[idx].data.mux.group = group;
@@ -198,7 +223,7 @@ static int sh_pfc_dt_subnode_to_map(struct device *dev, struct device_node *np,
 		goto done;
 	}
 
-	of_property_for_each_string(np, "renesas,pins", prop, pin) {
+	of_property_for_each_string(np, pmx->pins_prop_name, prop, pin) {
 		ret = sh_pfc_map_add_config(&maps[idx], pin,
 					    PIN_MAP_TYPE_CONFIGS_PIN,
 					    configs, num_configs);
@@ -246,7 +271,7 @@ static int sh_pfc_dt_node_to_map(struct pinctrl_dev *pctldev,
 	index = 0;
 
 	for_each_child_of_node(np, child) {
-		ret = sh_pfc_dt_subnode_to_map(dev, child, map, num_maps,
+		ret = sh_pfc_dt_subnode_to_map(pctldev, child, map, num_maps,
 					       &index);
 		if (ret < 0)
 			goto done;
@@ -254,7 +279,7 @@ static int sh_pfc_dt_node_to_map(struct pinctrl_dev *pctldev,
 
 	/* If no mapping has been found in child nodes try the config node. */
 	if (*num_maps == 0) {
-		ret = sh_pfc_dt_subnode_to_map(dev, np, map, num_maps, &index);
+		ret = sh_pfc_dt_subnode_to_map(pctldev, np, map, num_maps, &index);
 		if (ret < 0)
 			goto done;
 	}
-- 
Regards,

Laurent Pinchart


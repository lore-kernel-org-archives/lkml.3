Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbaJPRMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 13:12:53 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:49410 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbaJPRMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 13:12:15 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: [PATCH RFC v2 6/8] pinctrl: pinconf-generic: Infer map type from DT property
Date: Thu, 16 Oct 2014 10:11:33 -0700
Message-Id: <1413479495-14206-7-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.1.2.1.g5e69ed6
In-Reply-To: <1413479495-14206-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1413479495-14206-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the new 'groups' property, the DT parser can infer the map type
from the fact whether 'pins' or 'groups' is used to specify the pin
group to work on.
To maintain backwards compatibitliy with current usage of the DT
binding, this is only done when an invalid map type is passed to the
parsing function.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/pinctrl/pinconf-generic.c       | 17 ++++++++++++++---
 include/linux/pinctrl/pinconf-generic.h |  7 +++++++
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index 17ac8f00e16b..38b21e6a36a8 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -266,6 +266,7 @@ int pinconf_generic_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 	unsigned reserve;
 	struct property *prop;
 	const char *group;
+	const char *dt_pin_specifier = "pins";
 
 	ret = of_property_read_string(np, "function", &function);
 	if (ret < 0) {
@@ -286,10 +287,20 @@ int pinconf_generic_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 		reserve++;
 	if (num_configs)
 		reserve++;
+
 	ret = of_property_count_strings(np, "pins");
 	if (ret < 0) {
-		dev_err(dev, "could not parse property pins\n");
-		goto exit;
+		ret = of_property_count_strings(np, "groups");
+		if (ret < 0) {
+			dev_err(dev, "could not parse property pins/groups\n");
+			goto exit;
+		}
+		if (type == PIN_MAP_TYPE_INVALID)
+			type = PIN_MAP_TYPE_CONFIGS_GROUP;
+		dt_pin_specifier = "groups";
+	} else {
+		if (type == PIN_MAP_TYPE_INVALID)
+			type = PIN_MAP_TYPE_CONFIGS_PIN;
 	}
 	reserve *= ret;
 
@@ -298,7 +309,7 @@ int pinconf_generic_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 	if (ret < 0)
 		goto exit;
 
-	of_property_for_each_string(np, "pins", prop, group) {
+	of_property_for_each_string(np, dt_pin_specifier, prop, group) {
 		if (function) {
 			ret = pinctrl_utils_add_map_mux(pctldev, map,
 					reserved_maps, num_maps, group,
diff --git a/include/linux/pinctrl/pinconf-generic.h b/include/linux/pinctrl/pinconf-generic.h
index dd1d3251fb93..5a13bdf9dfc7 100644
--- a/include/linux/pinctrl/pinconf-generic.h
+++ b/include/linux/pinctrl/pinconf-generic.h
@@ -178,6 +178,13 @@ static inline int pinconf_generic_dt_node_to_map_pin(
 			PIN_MAP_TYPE_CONFIGS_PIN);
 }
 
+static inline int pinconf_generic_dt_node_to_map_all(
+		struct pinctrl_dev *pctldev, struct device_node *np_config,
+		struct pinctrl_map **map, unsigned *num_maps)
+{
+	return pinconf_generic_dt_node_to_map(pctldev, np_config, map, num_maps,
+			PIN_MAP_TYPE_INVALID);
+}
 #endif
 
 #endif /* CONFIG_GENERIC_PINCONF */
-- 
2.1.2.1.g5e69ed6


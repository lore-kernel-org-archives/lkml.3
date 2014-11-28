Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512AbaK1B1K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 20:27:10 -0500
Received: from mail-oi0-f43.google.com ([209.85.218.43]:60461 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaK1B1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 20:27:06 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-rockchip@lists.infradead.org, linux-sh@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH v2 1/7] pinctrl: pinconf-generic: Infer map type from DT property
Date: Thu, 27 Nov 2014 17:26:27 -0800
Message-Id: <1417137993-8337-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.1.3.1.ge241007
In-Reply-To: <1417137993-8337-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1417137993-8337-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Tested-by: Andreas Färber <afaerber@suse.de>
---
Changes since RFC v2:
 - none
---
 drivers/pinctrl/pinconf-generic.c       | 17 ++++++++++++++---
 include/linux/pinctrl/pinconf-generic.h |  7 +++++++
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index f78b416d7984..1e782a0d6e48 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -264,6 +264,7 @@ int pinconf_generic_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 	unsigned reserve;
 	struct property *prop;
 	const char *group;
+	const char *dt_pin_specifier = "pins";
 
 	ret = of_property_read_string(np, "function", &function);
 	if (ret < 0) {
@@ -284,10 +285,20 @@ int pinconf_generic_dt_subnode_to_map(struct pinctrl_dev *pctldev,
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
 
@@ -296,7 +307,7 @@ int pinconf_generic_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 	if (ret < 0)
 		goto exit;
 
-	of_property_for_each_string(np, "pins", prop, group) {
+	of_property_for_each_string(np, dt_pin_specifier, prop, group) {
 		if (function) {
 			ret = pinctrl_utils_add_map_mux(pctldev, map,
 					reserved_maps, num_maps, group,
diff --git a/include/linux/pinctrl/pinconf-generic.h b/include/linux/pinctrl/pinconf-generic.h
index d578a60eff23..b6dedfbfce69 100644
--- a/include/linux/pinctrl/pinconf-generic.h
+++ b/include/linux/pinctrl/pinconf-generic.h
@@ -174,6 +174,13 @@ static inline int pinconf_generic_dt_node_to_map_pin(
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
2.1.3.1.ge241007


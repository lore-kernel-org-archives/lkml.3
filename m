Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688Ab3HNQZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:25:41 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:35723 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760024Ab3HNQZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:25:40 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH] pinctrl: improve warning messages
Date: Wed, 14 Aug 2013 18:25:33 +0200
Message-Id: <1376497533-32303-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print out the affected group name on activation of pin mux
settings, and warn if you cannot free a pin that should have
been part of a certain setting.

Cc: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinmux.c | 35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 5f51588..008f965 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -400,10 +400,14 @@ int pinmux_enable_setting(struct pinctrl_setting const *setting)
 	ret = pctlops->get_group_pins(pctldev, setting->data.mux.group,
 				      &pins, &num_pins);
 	if (ret) {
+		const char *gname;
+
 		/* errors only affect debug data, so just warn */
+		gname = pctlops->get_group_name(pctldev,
+						setting->data.mux.group);
 		dev_warn(pctldev->dev,
-			 "could not get pins for group selector %d\n",
-			 setting->data.mux.group);
+			 "could not get pins for group %s\n",
+			 gname);
 		num_pins = 0;
 	}
 
@@ -411,9 +415,14 @@ int pinmux_enable_setting(struct pinctrl_setting const *setting)
 	for (i = 0; i < num_pins; i++) {
 		ret = pin_request(pctldev, pins[i], setting->dev_name, NULL);
 		if (ret) {
+			const char *gname;
+
+			gname = pctlops->get_group_name(pctldev,
+						setting->data.mux.group);
 			dev_err(pctldev->dev,
-				"could not request pin %d on device %s\n",
-				pins[i], pinctrl_dev_get_name(pctldev));
+				"could not request pin %d from group %s on "
+				"device %s\n",
+				pins[i], gname, pinctrl_dev_get_name(pctldev));
 			goto err_pin_request;
 		}
 	}
@@ -466,10 +475,14 @@ void pinmux_disable_setting(struct pinctrl_setting const *setting)
 	ret = pctlops->get_group_pins(pctldev, setting->data.mux.group,
 				      &pins, &num_pins);
 	if (ret) {
+		const char *gname;
+
 		/* errors only affect debug data, so just warn */
+		gname = pctlops->get_group_name(pctldev,
+						setting->data.mux.group);
 		dev_warn(pctldev->dev,
-			 "could not get pins for group selector %d\n",
-			 setting->data.mux.group);
+			 "could not get pins for group %s\n",
+			 gname);
 		num_pins = 0;
 	}
 
@@ -486,6 +499,16 @@ void pinmux_disable_setting(struct pinctrl_setting const *setting)
 			desc->mux_setting = NULL;
 			/* And release the pin */
 			pin_free(pctldev, pins[i], NULL);
+		} else {
+			const char *gname;
+
+			gname = pctlops->get_group_name(pctldev,
+						setting->data.mux.group);
+			dev_warn(pctldev->dev,
+				 "not freeing pin %d as part of deactivating "
+				 "group %s - it is already used for some other "
+				 "setting",
+				 pins[i], gname);
 		}
 	}
 
-- 
1.8.1.4


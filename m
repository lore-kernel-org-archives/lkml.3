Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaAQGrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 01:47:49 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:33720 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaAQGrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 01:47:37 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc: Chen-Yu Tsai <wens@csie.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH RFC 5/6] net: rfkill: gpio: add clock-frequency device tree property
Date: Fri, 17 Jan 2014 14:47:30 +0800
Message-Id: <1389941251-32692-6-git-send-email-wens@csie.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389941251-32692-1-git-send-email-wens@csie.org>
References: <1389941251-32692-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices, such as Broadcom Bluetooth devices, require a specific
clock rate for the clock tied to the rfkill device. Add clock-frequency
property so we can specify this from the device tree.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 Documentation/devicetree/bindings/rfkill/rfkill-gpio.txt | 2 ++
 net/rfkill/rfkill-gpio.c                                 | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/rfkill/rfkill-gpio.txt b/Documentation/devicetree/bindings/rfkill/rfkill-gpio.txt
index 8a07ea4..8b8db0a 100644
--- a/Documentation/devicetree/bindings/rfkill/rfkill-gpio.txt
+++ b/Documentation/devicetree/bindings/rfkill/rfkill-gpio.txt
@@ -13,6 +13,7 @@ NAME_reset-gpios, or both, must be defined.
 
 Optional properties:
 - clocks		: phandle to clock to enable/disable
+- clock-frequency	: clock rate to set for the given clock
 
 Example:
 
@@ -23,4 +24,5 @@ Example:
 		bluetooth_shutdown-gpios = <0>, <&pio 7 18 0>;
 		bluetooth_reset-gpios = <&pio 7 24 0>;
 		clocks = <&clk_out_a>;
+		clock-frequency = <32678>;
 	};
diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index 48381a8..3092681 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -40,6 +40,7 @@ struct rfkill_gpio_data {
 	char			*reset_name;
 	char			*shutdown_name;
 	struct clk		*clk;
+	int			clk_frequency;
 
 	bool			clk_enabled;
 };
@@ -92,6 +93,7 @@ static int rfkill_gpio_dt_probe(struct device *dev,
 	rfkill->name = np->name;
 	of_property_read_string(np, "rfkill-name", &rfkill->name);
 	of_property_read_u32(np, "rfkill-type", &rfkill->type);
+	of_property_read_u32(np, "clock-frequency", &rfkill->clk_frequency);
 
 	return 0;
 }
@@ -138,6 +140,8 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
 	snprintf(rfkill->shutdown_name, len + 10, "%s_shutdown", rfkill->name);
 
 	rfkill->clk = devm_clk_get(&pdev->dev, clk_name);
+	if (!IS_ERR(rfkill->clk) && rfkill->clk_frequency > 0)
+		clk_set_rate(rfkill->clk, rfkill->clk_frequency);
 
 	gpio = devm_gpiod_get_index(&pdev->dev, rfkill->reset_name, 0);
 	if (!IS_ERR(gpio)) {
-- 
1.8.5.2


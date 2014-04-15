Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304AbaDOHW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 03:22:27 -0400
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:36240 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaDOHWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 03:22:23 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, Arnd Bergmann <arnd@arndb.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-gpio@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: [PATCH 5/7] net: rfkill: gpio: add device tree support
Date: Tue, 15 Apr 2014 14:41:39 +0800
Message-Id: <1397544101-18135-6-git-send-email-wens@csie.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397544101-18135-1-git-send-email-wens@csie.org>
References: <1397544101-18135-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 .../devicetree/bindings/rfkill/rfkill-gpio.txt     | 24 ++++++++++++++++++++++
 net/rfkill/rfkill-gpio.c                           | 23 +++++++++++++++++++++
 2 files changed, 47 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rfkill/rfkill-gpio.txt

diff --git a/Documentation/devicetree/bindings/rfkill/rfkill-gpio.txt b/Documentation/devicetree/bindings/rfkill/rfkill-gpio.txt
new file mode 100644
index 0000000..a23da65
--- /dev/null
+++ b/Documentation/devicetree/bindings/rfkill/rfkill-gpio.txt
@@ -0,0 +1,24 @@
+GPIO controlled RFKILL devices
+
+Required properties:
+- compatible	: Must be "rfkill-gpio".
+- rfkill-name	: Name of RFKILL device
+- rfkill-type	: Type of RFKILL device: 1 for WiFi, 2 for BlueTooth, etc.
+		  See include/uapi/linux/rfkill.h for all valid values
+- gpios		: At most two GPIO phandles
+- gpio-names	: Shall be "reset" or "shutdown", matching gpios.
+		  If both are provided, the "reset" GPIO is toggled first.
+
+Optional properties:
+- clocks		: phandle to clock to enable/disable
+
+Example:
+
+	rfkill_bt {
+		compatible = "rfkill-gpio";
+		rfkill-name = "bluetooth";
+		rfkill-type = <2>;
+		gpios = <&pio 7 18 0>;
+		gpio-names = "reset";
+		clocks = <&clk_out_a>;
+	};
diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index f46ddf7..a174359 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -26,6 +26,7 @@
 #include <linux/slab.h>
 #include <linux/acpi.h>
 #include <linux/gpio/consumer.h>
+#include <linux/of_gpio.h>
 
 #include <linux/rfkill-gpio.h>
 
@@ -81,6 +82,18 @@ static int rfkill_gpio_acpi_probe(struct device *dev,
 	return 0;
 }
 
+static int rfkill_gpio_dt_probe(struct device *dev,
+				struct rfkill_gpio_data *rfkill)
+{
+	struct device_node * np = dev->of_node;
+
+	rfkill->name = np->name;
+	of_property_read_string(np, "rfkill-name", &rfkill->name);
+	of_property_read_u32(np, "rfkill-type", &rfkill->type);
+
+	return 0;
+}
+
 static int rfkill_gpio_probe(struct platform_device *pdev)
 {
 	struct rfkill_gpio_platform_data *pdata = pdev->dev.platform_data;
@@ -96,6 +109,10 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
 		ret = rfkill_gpio_acpi_probe(&pdev->dev, rfkill);
 		if (ret)
 			return ret;
+	} else if (&pdev->dev.of_node) {
+		ret = rfkill_gpio_dt_probe(&pdev->dev, rfkill);
+		if (ret)
+			return ret;
 	} else if (pdata) {
 		rfkill->name = pdata->name;
 		rfkill->type = pdata->type;
@@ -167,6 +184,11 @@ static const struct acpi_device_id rfkill_acpi_match[] = {
 };
 #endif
 
+static const struct of_device_id rfkill_of_match[] = {
+	{ .compatible = "rfkill-gpio", },
+	{},
+};
+
 static struct platform_driver rfkill_gpio_driver = {
 	.probe = rfkill_gpio_probe,
 	.remove = rfkill_gpio_remove,
@@ -174,6 +196,7 @@ static struct platform_driver rfkill_gpio_driver = {
 		.name = "rfkill_gpio",
 		.owner = THIS_MODULE,
 		.acpi_match_table = ACPI_PTR(rfkill_acpi_match),
+		.of_match_table = of_match_ptr(rfkill_of_match),
 	},
 };
 
-- 
1.9.1


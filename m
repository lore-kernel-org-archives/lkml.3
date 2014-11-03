Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbaKCQdw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:33:52 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:43451 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279AbaKCQdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:33:06 -0500
From: Felipe Balbi <balbi@ti.com>
To: <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>, <nsekhar@ti.com>,
        <grant.likely@linaro.org>, George Cherian <george.cherian@ti.com>
Subject: [PATCH 4/4] extcon: gpio: Add support for using cable names
Date: Mon, 3 Nov 2014 10:32:30 -0600
Message-ID: <1415032350-8459-5-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.1.0.GIT
In-Reply-To: <1415032350-8459-1-git-send-email-balbi@ti.com>
References: <1415032350-8459-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: George Cherian <george.cherian@ti.com>

Add support for using cable names. Enables other drivers to register interest
and get notified using extcon provided notifier call backs.

Signed-off-by: George Cherian <george.cherian@ti.com>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
---
 Documentation/devicetree/bindings/extcon/extcon-gpio.txt | 2 ++
 drivers/extcon/extcon-gpio.c                             | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/extcon/extcon-gpio.txt b/Documentation/devicetree/bindings/extcon/extcon-gpio.txt
index 5fe6846..f19aeb4 100644
--- a/Documentation/devicetree/bindings/extcon/extcon-gpio.txt
+++ b/Documentation/devicetree/bindings/extcon/extcon-gpio.txt
@@ -7,6 +7,7 @@ Required Properties:
  - compatible: should be:
    * "linux,extcon-gpio"
  - gpios: specifies the gpio pin used.
+ - cable-name: Name of the cable used.
 
 Optional Properties:
  - debounce: Debounce time for GPIO IRQ in ms
@@ -18,4 +19,5 @@ Eg:
 		compatible = "linux,extcon-gpio";
 		gpios = <&gpio3 12 GPIO_ACTIVE_HIGH>;
 		debounce = <20>;
+		cable-name = "USB-HOST";
 	};
diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
index 7191d28..cbe35af 100644
--- a/drivers/extcon/extcon-gpio.c
+++ b/drivers/extcon/extcon-gpio.c
@@ -42,6 +42,7 @@ struct gpio_extcon_data {
 	struct delayed_work work;
 	unsigned long debounce_jiffies;
 	bool check_on_resume;
+	const char *cable_name[1];
 };
 
 static void gpio_extcon_work(struct work_struct *work)
@@ -112,6 +113,9 @@ static int gpio_extcon_probe(struct platform_device *pdev)
 		of_property_read_u32(np, "debounce", &debounce);
 		irq = gpiod_to_irq(extcon_data->gpiod);
 		irq_flags = irq_get_trigger_type(irq);
+		of_property_read_string_index(np, "cable-name", 0,
+					      extcon_data->cable_name);
+		extcon_data->edev->supported_cable = extcon_data->cable_name;
 	} else {
 		if (!pdata)
 			return -EBUSY;
-- 
2.1.0.GIT


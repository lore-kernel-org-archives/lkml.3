Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781AbaIIESY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 00:18:24 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50163 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755709AbaIIESV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 00:18:21 -0400
From: George Cherian <george.cherian@ti.com>
To: <cw00.choi@samsung.com>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <myungjoo.ham@samsung.com>,
        <grant.likely@linaro.org>, <rongjun.ying@csr.com>,
        <linux@roeck-us.net>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH 5/5] extcon: gpio: Add support for using cable names
Date: Tue, 9 Sep 2014 09:44:38 +0530
Message-ID: <1410236078-11713-6-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1410236078-11713-1-git-send-email-george.cherian@ti.com>
References: <1410236078-11713-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for using cable names. Enables other drivers to register interest
and get notified using extcon provided notifier call backs.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 Documentation/devicetree/bindings/extcon/extcon-gpio.txt | 2 ++
 drivers/extcon/extcon-gpio.c                             | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/extcon/extcon-gpio.txt b/Documentation/devicetree/bindings/extcon/extcon-gpio.txt
index 30aa2e1..2c9d29f 100644
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
index 3839749..c0ab8e7 100644
--- a/drivers/extcon/extcon-gpio.c
+++ b/drivers/extcon/extcon-gpio.c
@@ -42,6 +42,7 @@ struct gpio_extcon_data {
 	struct delayed_work work;
 	unsigned long debounce_jiffies;
 	bool check_on_resume;
+	const char *cable_name[1];
 };
 
 static void gpio_extcon_work(struct work_struct *work)
@@ -111,6 +112,9 @@ static int gpio_extcon_probe(struct platform_device *pdev)
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
1.8.3.1


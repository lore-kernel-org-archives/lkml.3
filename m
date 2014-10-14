Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510AbaJNOmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:42:11 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54849 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932276AbaJNOlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:41:52 -0400
From: George Cherian <george.cherian@ti.com>
To: <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <Baohua.Song@csr.com>, <rongjun.ying@csr.com>, <galak@codeaurora.org>,
        <ijc+devicetree@hellion.org.uk>, <mark.rutland@arm.com>,
        <pawel.moll@arm.com>, <robh+dt@kernel.org>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH 2/2] extcon: gpio: Add support for using cable names
Date: Tue, 14 Oct 2014 20:09:05 +0530
Message-ID: <1413297545-26521-3-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1413297545-26521-1-git-send-email-george.cherian@ti.com>
References: <1413297545-26521-1-git-send-email-george.cherian@ti.com>
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
index 85795de..0e1b3e8 100644
--- a/drivers/extcon/extcon-gpio.c
+++ b/drivers/extcon/extcon-gpio.c
@@ -38,6 +38,7 @@ struct gpio_extcon_data {
 	int irq;
 	struct delayed_work work;
 	unsigned long debounce_jiffies;
+	const char *cable_name[1];
 };
 
 static void gpio_extcon_work(struct work_struct *work)
@@ -100,6 +101,9 @@ static int gpio_extcon_probe(struct platform_device *pdev)
 				msecs_to_jiffies(debounce);
 	}
 
+	of_property_read_string_index(np, "cable-name", 0,
+				      extcon_data->cable_name);
+	extcon_data->edev->supported_cable = extcon_data->cable_name;
 	ret = devm_extcon_dev_register(&pdev->dev, extcon_data->edev);
 	if (ret < 0)
 		return ret;
-- 
1.8.3.1


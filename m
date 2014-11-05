Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbaKEPcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:32:47 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:47398 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755247AbaKEPcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:32:45 -0500
From: George Cherian <george.cherian@ti.com>
To: <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rongjun.ying@csr.com>, <Baohua.Song@csr.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, George Cherian <george.cherian@ti.com>
Subject: [RESEND PATCH 2/2] extcon: gpio: Add support for using cable names
Date: Wed, 5 Nov 2014 20:59:48 +0530
Message-ID: <1415201388-32060-3-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1415201388-32060-1-git-send-email-george.cherian@ti.com>
References: <1415201388-32060-1-git-send-email-george.cherian@ti.com>
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbaHSJZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 05:25:09 -0400
Received: from mail1.g1.pair.com ([66.39.3.162]:35868 "EHLO mail1.g1.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbaHSJZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 05:25:08 -0400
From: Sean Cross <xobs@kosagi.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: bunnie@kosagi.com, Sean Cross <xobs@kosagi.com>
Subject: [PATCH] mfd: stmpe: add OF support for irq-over-gpio
Date: Tue, 19 Aug 2014 17:24:48 +0800
Message-Id: <1408440288-27323-1-git-send-email-xobs@kosagi.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using the STMPE610 or STMPE811 as a platform device, the platform data
struct allows for irq_over_gpio to be set.  This patch allows for using a
GPIO as an IRQ source when using device tree by specifying an irq-gpio
property.

Signed-off-by: Sean Cross <xobs@kosagi.com>
---
 Documentation/devicetree/bindings/mfd/stmpe.txt | 1 +
 drivers/mfd/stmpe.c                             | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/mfd/stmpe.txt b/Documentation/devicetree/bindings/mfd/stmpe.txt
index 56edb55..3fb68bf 100644
--- a/Documentation/devicetree/bindings/mfd/stmpe.txt
+++ b/Documentation/devicetree/bindings/mfd/stmpe.txt
@@ -13,6 +13,7 @@ Optional properties:
  - interrupt-parent             : Specifies which IRQ controller we're connected to
  - wakeup-source                : Marks the input device as wakable
  - st,autosleep-timeout         : Valid entries (ms); 4, 16, 32, 64, 128, 256, 512 and 1024
+ - irq-gpio                     : If present, which GPIO to use for event IRQ
 
 Example:
 
diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index 3b6bfa7..4c42b05 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -1122,7 +1122,12 @@ static void stmpe_of_probe(struct stmpe_platform_data *pdata,
 	if (pdata->id < 0)
 		pdata->id = -1;
 
-	pdata->irq_trigger = IRQF_TRIGGER_NONE;
+	pdata->irq_gpio = of_get_named_gpio_flags(np, "irq-gpio", 0,
+				&pdata->irq_trigger);
+	if (gpio_is_valid(pdata->irq_gpio))
+		pdata->irq_over_gpio = 1;
+	else
+		pdata->irq_trigger = IRQF_TRIGGER_NONE;
 
 	of_property_read_u32(np, "st,autosleep-timeout",
 			&pdata->autosleep_timeout);
-- 
2.0.0


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591Ab3EWIjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 04:39:35 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:34854 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab3EWIj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 04:39:29 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Nelson <Robert.Nelson@digikey.com>,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH v3 5/5] rtc-at91rm9200: use shadow IMR on at91sam9x5
Date: Thu, 23 May 2013 10:38:55 +0200
Message-Id: <1369298335-24597-6-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1369298335-24597-1-git-send-email-jhovold@gmail.com>
References: <1364983415-20298-1-git-send-email-jhovold@gmail.com>
 <1369298335-24597-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the at91sam9x5-family which must use the shadow
interrupt mask due to a hardware issue (causing RTC_IMR to always be
zero).

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 Documentation/devicetree/bindings/rtc/atmel,at91rm9200-rtc.txt | 2 +-
 arch/arm/boot/dts/at91sam9x5.dtsi                              | 2 +-
 drivers/rtc/rtc-at91rm9200.c                                   | 7 +++++++
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/rtc/atmel,at91rm9200-rtc.txt b/Documentation/devicetree/bindings/rtc/atmel,at91rm9200-rtc.txt
index 2a3feab..34c1505 100644
--- a/Documentation/devicetree/bindings/rtc/atmel,at91rm9200-rtc.txt
+++ b/Documentation/devicetree/bindings/rtc/atmel,at91rm9200-rtc.txt
@@ -1,7 +1,7 @@
 Atmel AT91RM9200 Real Time Clock
 
 Required properties:
-- compatible: should be: "atmel,at91rm9200-rtc"
+- compatible: should be: "atmel,at91rm9200-rtc" or "atmel,at91sam9x5-rtc"
 - reg: physical base address of the controller and length of memory mapped
   region.
 - interrupts: rtc alarm/event interrupt
diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
index 1145ac3..b5833d1f 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -643,7 +643,7 @@
 			};
 
 			rtc@fffffeb0 {
-				compatible = "atmel,at91rm9200-rtc";
+				compatible = "atmel,at91sam9x5-rtc";
 				reg = <0xfffffeb0 0x40>;
 				interrupts = <1 4 7>;
 				status = "disabled";
diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index 205701e..47416e9 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -309,12 +309,19 @@ static irqreturn_t at91_rtc_interrupt(int irq, void *dev_id)
 static const struct at91_rtc_config at91rm9200_config = {
 };
 
+static const struct at91_rtc_config at91sam9x5_config = {
+	.use_shadow_imr	= true,
+};
+
 #ifdef CONFIG_OF
 static const struct of_device_id at91_rtc_dt_ids[] = {
 	{
 		.compatible = "atmel,at91rm9200-rtc",
 		.data = &at91rm9200_config,
 	}, {
+		.compatible = "atmel,at91sam9x5-rtc",
+		.data = &at91sam9x5_config,
+	}, {
 		/* sentinel */
 	}
 };
-- 
1.8.2.1


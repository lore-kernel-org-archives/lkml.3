Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640Ab3LWSLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 13:11:21 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:61430 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757477Ab3LWSKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 13:10:54 -0500
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: Tony Lindgren <tony@atomide.com>
Cc: patches@linaro.org, linaro-networking@linaro.org,
        linaro-kernel@lists.linaro.org,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] ARM: OMAP: debug-leds: raw read and write endian fix
Date: Mon, 23 Dec 2013 20:10:34 +0200
Message-Id: <1387822234-11167-5-git-send-email-taras.kondratiuk@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387822234-11167-1-git-send-email-taras.kondratiuk@linaro.org>
References: <1387822234-11167-1-git-send-email-taras.kondratiuk@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Victor Kamensky <victor.kamensky@linaro.org>

All OMAP IP blocks expect LE data, but CPU may operate in BE mode.
Need to use endian neutral functions to read/write h/w registers.
I.e instead of __raw_read[lw] and __raw_write[lw] functions code
need to use read[lw]_relaxed and write[lw]_relaxed functions.
If the first simply reads/writes register, the second will byteswap
it if host operates in BE mode.

Changes are trivial sed like replacement of __raw_xxx functions
with xxx_relaxed variant.

Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
---
 arch/arm/plat-omap/debug-leds.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/plat-omap/debug-leds.c b/arch/arm/plat-omap/debug-leds.c
index aa7ebc6..48b69de 100644
--- a/arch/arm/plat-omap/debug-leds.c
+++ b/arch/arm/plat-omap/debug-leds.c
@@ -85,12 +85,12 @@ static void dbg_led_set(struct led_classdev *cdev,
 	struct dbg_led *led = container_of(cdev, struct dbg_led, cdev);
 	u16 reg;
 
-	reg = __raw_readw(&fpga->leds);
+	reg = readw_relaxed(&fpga->leds);
 	if (b != LED_OFF)
 		reg |= led->mask;
 	else
 		reg &= ~led->mask;
-	__raw_writew(reg, &fpga->leds);
+	writew_relaxed(reg, &fpga->leds);
 }
 
 static enum led_brightness dbg_led_get(struct led_classdev *cdev)
@@ -98,7 +98,7 @@ static enum led_brightness dbg_led_get(struct led_classdev *cdev)
 	struct dbg_led *led = container_of(cdev, struct dbg_led, cdev);
 	u16 reg;
 
-	reg = __raw_readw(&fpga->leds);
+	reg = readw_relaxed(&fpga->leds);
 	return (reg & led->mask) ? LED_FULL : LED_OFF;
 }
 
@@ -112,7 +112,7 @@ static int fpga_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	fpga = ioremap(iomem->start, resource_size(iomem));
-	__raw_writew(0xff, &fpga->leds);
+	writew_relaxed(0xff, &fpga->leds);
 
 	for (i = 0; i < ARRAY_SIZE(dbg_leds); i++) {
 		struct dbg_led *led;
@@ -138,15 +138,15 @@ static int fpga_probe(struct platform_device *pdev)
 
 static int fpga_suspend_noirq(struct device *dev)
 {
-	fpga_led_state = __raw_readw(&fpga->leds);
-	__raw_writew(0xff, &fpga->leds);
+	fpga_led_state = readw_relaxed(&fpga->leds);
+	writew_relaxed(0xff, &fpga->leds);
 
 	return 0;
 }
 
 static int fpga_resume_noirq(struct device *dev)
 {
-	__raw_writew(~fpga_led_state, &fpga->leds);
+	writew_relaxed(~fpga_led_state, &fpga->leds);
 	return 0;
 }
 
-- 
1.7.9.5


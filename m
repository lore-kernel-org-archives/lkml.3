Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab3KPADn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:03:43 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:60911 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab3KPAB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:01:58 -0500
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: linux-omap@vger.kernel.org
Cc: linaro-networking@linaro.org, Victor Kamensky <victor.kamensky@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC 20/23] ARM: OMAP: debug-leds: raw read and write endian fix
Date: Sat, 16 Nov 2013 02:01:23 +0200
Message-Id: <1384560086-11994-21-git-send-email-taras.kondratiuk@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384560086-11994-1-git-send-email-taras.kondratiuk@linaro.org>
References: <1384560086-11994-1-git-send-email-taras.kondratiuk@linaro.org>
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


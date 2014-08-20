Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbaHTMlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:41:11 -0400
Received: from smarthost01d.mail.zen.net.uk ([212.23.1.7]:54065 "EHLO
	smarthost01d.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752193AbaHTMlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:41:09 -0400
Message-ID: <1408538464.3858.43.camel@linaro1.home>
Subject: [PATCH v2] video: ARM CLCD: Fix calculation of bits-per-pixel
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: linux-fbdev@vger.kernel.org, Pawel Moll <Pawel.Moll@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Wed, 20 Aug 2014 13:41:04 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01d-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the device-tree specifies a max-memory-bandwidth property then the
CLCD driver uses that to calculate the bits-per-pixel supported,
however, this calculation is faulty for two reasons.

1. It doesn't ensure that the result is a sane value, i.e. a power of 2
   and <= 32 as the rest of the code assumes.

2. It uses the displayed resolution and calculates the average bandwidth
   across the whole frame. It should instead calculate the peak
   bandwidth based on the pixel clock.

This patch fixes both the above.

Signed-off-by: Jon Medhurst <tixy@linaro.org>
---

Changes since v1:
- Changed formula for calculating bits per pixel
- Changed commit message and subject, was:
  "video: ARM CLCD: Ensure bits-per-pixel is a power of 2 and <= 32"

 drivers/video/fbdev/amba-clcd.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/video/fbdev/amba-clcd.c b/drivers/video/fbdev/amba-clcd.c
index beadd3e..a7b6217 100644
--- a/drivers/video/fbdev/amba-clcd.c
+++ b/drivers/video/fbdev/amba-clcd.c
@@ -24,6 +24,7 @@
 #include <linux/list.h>
 #include <linux/amba/bus.h>
 #include <linux/amba/clcd.h>
+#include <linux/bitops.h>
 #include <linux/clk.h>
 #include <linux/hardirq.h>
 #include <linux/dma-mapping.h>
@@ -650,6 +651,7 @@ static int clcdfb_of_init_display(struct clcd_fb *fb)
 {
 	struct device_node *endpoint;
 	int err;
+	unsigned int bpp;
 	u32 max_bandwidth;
 	u32 tft_r0b0g0[3];
 
@@ -667,11 +669,22 @@ static int clcdfb_of_init_display(struct clcd_fb *fb)
 
 	err = of_property_read_u32(fb->dev->dev.of_node, "max-memory-bandwidth",
 			&max_bandwidth);
-	if (!err)
-		fb->panel->bpp = 8 * max_bandwidth / (fb->panel->mode.xres *
-				fb->panel->mode.yres * fb->panel->mode.refresh);
-	else
-		fb->panel->bpp = 32;
+	if (!err) {
+		/*
+		 * max_bandwidth is in bytes per second and pixclock in
+		 * pico-seconds, so the maximum allowed bits per pixel is
+		 *   8 * max_bandwidth / (PICOS2KHZ(pixclock) * 1000)
+		 * Rearrange this calculation to avoid overflow and then ensure
+		 * result is a valid format.
+		 */
+		bpp = max_bandwidth / (1000 / 8)
+			/ PICOS2KHZ(fb->panel->mode.pixclock);
+		bpp = rounddown_pow_of_two(bpp);
+		if (bpp > 32)
+			bpp = 32;
+	} else
+		bpp = 32;
+	fb->panel->bpp = bpp;
 
 #ifdef CONFIG_CPU_BIG_ENDIAN
 	fb->panel->cntl |= CNTL_BEBO;
-- 
2.1.0.rc1




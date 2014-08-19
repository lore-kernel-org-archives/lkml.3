Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbaHSNHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 09:07:37 -0400
Received: from smarthost01c.mail.zen.net.uk ([212.23.1.5]:52210 "EHLO
	smarthost01c.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752610AbaHSNHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 09:07:35 -0400
Message-ID: <1408453651.3746.41.camel@linaro1.home>
Subject: [PATCH] video: ARM CLCD: Ensure bits-per-pixel is a power of 2 and
 <= 32
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Moll <Pawel.Moll@arm.com>, linux-arm-kernel@lists.infradead.org
Date: Tue, 19 Aug 2014 14:07:31 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01c-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the device-tree specifies a max-memory-bandwidth property then
the CLCD driver uses that to calculate the bits-per-pixel supported,
however, it doesn't ensure that the result is a sane value, i.e. a
power of 2 and <= 32 as the rest of the code assumes.

Acked-by: Pawel Moll <pawel.moll@arm.com>
Signed-off-by: Jon Medhurst <tixy@linaro.org>
---

This fixes code which is new in 3.17 (commit d10715be03) and so I assume
is a candidate for adding to a coming -rc ? Without the fix, people can
be left (as I was) with a blank non-functioning screen even if they
create a valid device-tree for the new driver functionality.

 drivers/video/fbdev/amba-clcd.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/video/fbdev/amba-clcd.c b/drivers/video/fbdev/amba-clcd.c
index beadd3e..98b66b7 100644
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
+	int bpp;
 	u32 max_bandwidth;
 	u32 tft_r0b0g0[3];
 
@@ -667,11 +669,15 @@ static int clcdfb_of_init_display(struct clcd_fb *fb)
 
 	err = of_property_read_u32(fb->dev->dev.of_node, "max-memory-bandwidth",
 			&max_bandwidth);
-	if (!err)
-		fb->panel->bpp = 8 * max_bandwidth / (fb->panel->mode.xres *
+	if (!err) {
+		bpp = 8 * max_bandwidth / (fb->panel->mode.xres *
 				fb->panel->mode.yres * fb->panel->mode.refresh);
-	else
-		fb->panel->bpp = 32;
+		bpp = rounddown_pow_of_two(bpp);
+		if (bpp > 32)
+			bpp = 32;
+	} else
+		bpp = 32;
+	fb->panel->bpp = bpp;
 
 #ifdef CONFIG_CPU_BIG_ENDIAN
 	fb->panel->cntl |= CNTL_BEBO;
-- 
2.0.1



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab3IRHdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 03:33:50 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58393 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab3IRHdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 03:33:45 -0400
Date: Wed, 18 Sep 2013 09:33:08 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: "Koul, Vinod" <vinod.koul@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] DMA: ste_dma40: use a power of 2 check
Message-ID: <Pine.LNX.4.64.1309180919470.30215@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:yraSnf0W9zYtNbEjtqG2EiUYHctzyHsbIPBkfKYQ0c/
 +JtHPU1UnpQvM4y3FBgvTp1zKQJmvh6LLCqBUTFi2NsVII0OsZ
 DxP38xfwEqeUskhUxouyefSzqyaqMBJX424/wAd1SRSpvnjBWY
 P3GkNN3d875ixLpCwDzer+utqwE/zJBahVun72/3vRrkCn1ANX
 OJnjPnw8SP4O8x0TWMQ3eqWNDyiW42eP55+ggzVRfV6GNPt948
 A6r+gE6FR1u0RHKVaobJDsY/BGIr9SHJtvWggeoLu8r3mpd7hl
 qfcdN6pz+pdo3Tc9yhu/5km5E0x90i/g1G+bnK1t2fkMYk+tna
 o3ibO/VHoKYI3dXm8kLUjUjYQ4KIVEHaR2j9Tm0MKwKo8y+Ejy
 tfrgeYSX8lEzg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dst_addr_width and src_addr_width should be a power of 2. Currently the 
driver checks, that they both lie between 1 and 8 and that they are eqal 
to 1 or even. This however leaves an invalid value of 6 uncaught. Use an 
explicit power of 2 check instead.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---

Compile tested only. I think 6 is an invalid value in this case, and since 
you check for odd calues, it seems to me that any value can be supplied 
here, so, looks like a power of 2 test is a better match for this.

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 82d2b97..3d5e4ee 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -14,6 +14,7 @@
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
+#include <linux/log2.h>
 #include <linux/pm.h>
 #include <linux/pm_runtime.h>
 #include <linux/err.h>
@@ -2796,8 +2797,8 @@ static int d40_set_runtime_config(struct dma_chan *chan,
 	    src_addr_width >  DMA_SLAVE_BUSWIDTH_8_BYTES   ||
 	    dst_addr_width <= DMA_SLAVE_BUSWIDTH_UNDEFINED ||
 	    dst_addr_width >  DMA_SLAVE_BUSWIDTH_8_BYTES   ||
-	    ((src_addr_width > 1) && (src_addr_width & 1)) ||
-	    ((dst_addr_width > 1) && (dst_addr_width & 1)))
+	    !is_power_of_2(src_addr_width) ||
+	    !is_power_of_2(dst_addr_width))
 		return -EINVAL;
 
 	cfg->src_info.data_width = src_addr_width;

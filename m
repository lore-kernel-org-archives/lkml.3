Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbaJTQp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 12:45:26 -0400
Received: from mga03.intel.com ([134.134.136.65]:13961 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbaJTQpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 12:45:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,757,1406617200"; 
   d="scan'208";a="592512155"
From: Vinod Koul <vinod.koul@intel.com>
To: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Josh Wu <Josh.wu@atmel.com>, Jingoo Han <jg1.han@samsung.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Mark Brown <broonie@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Herve Codina <Herve.CODINA@celad.com>, Bo Shen <voice.shen@atmel.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Huang Shijie <shijie8@gmail.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 1/2] mtd: atmel_nand: use __iowrite32_copy for 32 bit copy
Date: Mon, 20 Oct 2014 21:36:12 +0530
Message-Id: <1413821173-18347-1-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver was also using own method to do 32bit copy, turns out
we have a kernel API so use that instead

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/mtd/nand/atmel_nand.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index e321c56..b03e80d 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -265,14 +265,10 @@ static void memcpy32_fromio(void *trg, const void __iomem  *src, size_t size)
 		*t++ = readl_relaxed(s++);
 }
 
-static void memcpy32_toio(void __iomem *trg, const void *src, int size)
+static inline void memcpy32_toio(void __iomem *trg, const void *src, int size)
 {
-	int i;
-	u32 __iomem *t = trg;
-	const u32 *s = src;
-
-	for (i = 0; i < (size >> 2); i++)
-		writel_relaxed(*s++, t++);
+	/* __iowrite32_copy use 32bit size values so divide by 4 */
+	__iowrite32_copy(trg, src, size/4);
 }
 
 /*
-- 
1.7.0.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbaJTQpH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 12:45:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:37467 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbaJTQpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 12:45:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,757,1406617200"; 
   d="scan'208";a="592512204"
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
Subject: [PATCH 2/2] mtd: mxc_nand: use __iowrite32_copy for 32 bit copy
Date: Mon, 20 Oct 2014 21:36:13 +0530
Message-Id: <1413821173-18347-2-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1413821173-18347-1-git-send-email-vinod.koul@intel.com>
References: <1413821173-18347-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver was also using own method to do 32bit copy, turns out
we have a kernel API so use that instead

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/mtd/nand/mxc_nand.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
index dba262b..3794cd7 100644
--- a/drivers/mtd/nand/mxc_nand.c
+++ b/drivers/mtd/nand/mxc_nand.c
@@ -280,14 +280,10 @@ static void memcpy32_fromio(void *trg, const void __iomem  *src, size_t size)
 		*t++ = __raw_readl(s++);
 }
 
-static void memcpy32_toio(void __iomem *trg, const void *src, int size)
+static inline void memcpy32_toio(void __iomem *trg, const void *src, int size)
 {
-	int i;
-	u32 __iomem *t = trg;
-	const u32 *s = src;
-
-	for (i = 0; i < (size >> 2); i++)
-		__raw_writel(*s++, t++);
+	/* __iowrite32_copy use 32bit size values so divide by 4 */
+	__iowrite32_copy(trg, src, size/4);
 }
 
 static int check_int_v3(struct mxc_nand_host *host)
-- 
1.7.0.4


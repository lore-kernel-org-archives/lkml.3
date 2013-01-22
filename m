Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab3AVKZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 05:25:50 -0500
Received: from mga14.intel.com ([143.182.124.37]:25668 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754241Ab3AVKZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 05:25:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,513,1355126400"; 
   d="scan'208";a="246947103"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, chao.bi@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>, cxie4@marvell.com,
        ytang5@marvell.com, Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v3 02/10] spi/pxa2xx: fix warnings when compiling a 64-bit kernel
Date: Tue, 22 Jan 2013 12:26:25 +0200
Message-Id: <1358850393-23111-3-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358850393-23111-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1358850393-23111-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warnings seen when compiling 64-bit:

drivers/spi/spi-pxa2xx.c: In function ‘map_dma_buffers’: drivers/spi/spi-pxa2xx.c:384:7: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/spi/spi-pxa2xx.c:384:40: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/spi/spi-pxa2xx.c: In function ‘pxa2xx_spi_probe’:
drivers/spi/spi-pxa2xx.c:1572:34: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/spi/spi-pxa2xx.c:1572:34: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/spi/spi-pxa2xx.c:1572:34: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/spi/spi-pxa2xx.c:1572:27: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/spi/spi-pxa2xx.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index 54097ad..ef0a786 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -47,7 +47,7 @@ MODULE_ALIAS("platform:pxa2xx-spi");
 
 #define DMA_INT_MASK		(DCSR_ENDINTR | DCSR_STARTINTR | DCSR_BUSERR)
 #define RESET_DMA_CHANNEL	(DCSR_NODESC | DMA_INT_MASK)
-#define IS_DMA_ALIGNED(x)	((((u32)(x)) & 0x07) == 0)
+#define IS_DMA_ALIGNED(x)	IS_ALIGNED((unsigned long)(x), DMA_ALIGNMENT)
 #define MAX_DMA_LEN		8191
 #define DMA_ALIGNMENT		8
 
@@ -1576,8 +1576,7 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 	master->transfer = transfer;
 
 	drv_data->ssp_type = ssp->type;
-	drv_data->null_dma_buf = (u32 *)ALIGN((u32)(drv_data +
-						sizeof(struct driver_data)), 8);
+	drv_data->null_dma_buf = (u32 *)PTR_ALIGN(&drv_data[1], DMA_ALIGNMENT);
 
 	drv_data->ioaddr = ssp->mmio_base;
 	drv_data->ssdr_physical = ssp->phys_base + SSDR;
-- 
1.7.10.4


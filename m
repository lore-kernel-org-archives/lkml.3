Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab3CEKDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 05:03:46 -0500
Received: from mga14.intel.com ([143.182.124.37]:42706 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755882Ab3CEKDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 05:03:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,786,1355126400"; 
   d="scan'208";a="264510453"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 2/2] spi/pxa2xx: enable multiblock DMA transfers for LPSS devices
Date: Tue,  5 Mar 2013 12:05:17 +0200
Message-Id: <1362477917-24904-2-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362477917-24904-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1362477917-24904-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel LPSS SPI controllers need to have bit 0 (disable_ssp_dma_finish) set
in SSP_REG in order to properly perform DMA transfers spanning over
multiple blocks.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/spi/spi-pxa2xx.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index 90b27a3..c6d5b97 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -68,6 +68,7 @@ MODULE_ALIAS("platform:pxa2xx-spi");
 #define LPSS_TX_HITHRESH_DFLT	224
 
 /* Offset from drv_data->lpss_base */
+#define SSP_REG			0x0c
 #define SPI_CS_CONTROL		0x18
 #define SPI_CS_CONTROL_SW_MODE	BIT(0)
 #define SPI_CS_CONTROL_CS_HIGH	BIT(1)
@@ -138,6 +139,10 @@ detection_done:
 	/* Enable software chip select control */
 	value = SPI_CS_CONTROL_SW_MODE | SPI_CS_CONTROL_CS_HIGH;
 	__lpss_ssp_write_priv(drv_data, SPI_CS_CONTROL, value);
+
+	/* Enable multiblock DMA transfers */
+	if (drv_data->master_info->enable_dma)
+		__lpss_ssp_write_priv(drv_data, SSP_REG, 1);
 }
 
 static void lpss_ssp_cs_control(struct driver_data *drv_data, bool enable)
-- 
1.7.10.4


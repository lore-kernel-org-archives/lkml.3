Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729Ab3GCKW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 06:22:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:13167 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932352Ab3GCKW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 06:22:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,987,1363158000"; 
   d="scan'208";a="339827327"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-spi@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] spi/pxa2xx: enable DMA on newer Intel LPSS silicon
Date: Wed,  3 Jul 2013 13:25:06 +0300
Message-Id: <1372847106-32698-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is an additional bit in the Intel LPSS SPI private registers that
needs to be set in order to be able to use DMA with the SPI controller.
Enable this as well.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/spi/spi-pxa2xx.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index 97e23c9..9196962 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -69,6 +69,8 @@ MODULE_ALIAS("platform:pxa2xx-spi");
 #define LPSS_TX_HITHRESH_DFLT	224
 
 /* Offset from drv_data->lpss_base */
+#define GENERAL_REG		0x08
+#define GENERAL_REG_RXTO_HOLDOFF_DISABLE BIT(24)
 #define SSP_REG			0x0c
 #define SPI_CS_CONTROL		0x18
 #define SPI_CS_CONTROL_SW_MODE	BIT(0)
@@ -142,8 +144,13 @@ detection_done:
 	__lpss_ssp_write_priv(drv_data, SPI_CS_CONTROL, value);
 
 	/* Enable multiblock DMA transfers */
-	if (drv_data->master_info->enable_dma)
+	if (drv_data->master_info->enable_dma) {
 		__lpss_ssp_write_priv(drv_data, SSP_REG, 1);
+
+		value = __lpss_ssp_read_priv(drv_data, GENERAL_REG);
+		value |= GENERAL_REG_RXTO_HOLDOFF_DISABLE;
+		__lpss_ssp_write_priv(drv_data, GENERAL_REG, value);
+	}
 }
 
 static void lpss_ssp_cs_control(struct driver_data *drv_data, bool enable)
-- 
1.8.3.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbaFMHxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 03:53:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:60567 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbaFMHxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 03:53:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,470,1400050800"; 
   d="scan'208";a="527884479"
From: Chew Chiau Ee <chiau.ee.chew@intel.com>
To: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>
Cc: Chew Chiau Ee <chiau.ee.chew@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] spi/pxa2xx: fix incorrect SW mode chipselect setting for BayTrail LPSS SPI
Date: Fri, 13 Jun 2014 23:57:25 +0800
Message-Id: <1402675045-22460-1-git-send-email-chiau.ee.chew@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chew, Chiau Ee <chiau.ee.chew@intel.com>

It was observed that after module removal followed by insertion,
the SW mode chipselect is not properly set. Thus causing transfer
failure due to incorrect CS toggling.

Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
---
 drivers/spi/spi-pxa2xx.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index a98df7e..fe79210 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -118,6 +118,7 @@ static void lpss_ssp_setup(struct driver_data *drv_data)
 	 */
 	orig = readl(drv_data->ioaddr + offset + SPI_CS_CONTROL);
 
+	/* Test SPI_CS_CONTROL_SW_MODE bit enabling */
 	value = orig | SPI_CS_CONTROL_SW_MODE;
 	writel(value, drv_data->ioaddr + offset + SPI_CS_CONTROL);
 	value = readl(drv_data->ioaddr + offset + SPI_CS_CONTROL);
@@ -126,10 +127,13 @@ static void lpss_ssp_setup(struct driver_data *drv_data)
 		goto detection_done;
 	}
 
-	value &= ~SPI_CS_CONTROL_SW_MODE;
+	orig = readl(drv_data->ioaddr + offset + SPI_CS_CONTROL);
+
+	/* Test SPI_CS_CONTROL_SW_MODE bit disabling */
+	value = orig & ~SPI_CS_CONTROL_SW_MODE;
 	writel(value, drv_data->ioaddr + offset + SPI_CS_CONTROL);
 	value = readl(drv_data->ioaddr + offset + SPI_CS_CONTROL);
-	if (value != orig) {
+	if (value != (orig & ~SPI_CS_CONTROL_SW_MODE)) {
 		offset = 0x800;
 		goto detection_done;
 	}
-- 
1.7.4.4


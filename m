Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab3CUMIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 08:08:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:55767 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754912Ab3CUMIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 08:08:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,884,1355126400"; 
   d="scan'208";a="282699987"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        ben-linux@fluff.org, Jean Delvare <khali@linux-fr.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 4/7] i2c-designware: use dynamic adapter numbering on Lynxpoint
Date: Thu, 21 Mar 2013 14:09:57 +0200
Message-Id: <1363867800-23861-4-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363867800-23861-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1363867800-23861-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not good idea to mix static and dynamic I2C adapter numbering. In
this particular case on Lynxpoint we had graphics I2C adapter which took
the first numbers preventing the designware I2C driver from using the
adapter numbers it preferred.

Fix this by switching to use dynamic adapter numbering on Intel Lynxpoint.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/i2c/busses/i2c-designware-platdrv.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index c19c4ce..a22a852 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -56,20 +56,11 @@ static u32 i2c_dw_get_clk_rate_khz(struct dw_i2c_dev *dev)
 static int dw_i2c_acpi_configure(struct platform_device *pdev)
 {
 	struct dw_i2c_dev *dev = platform_get_drvdata(pdev);
-	struct acpi_device *adev;
-	int busno, ret;
 
 	if (!ACPI_HANDLE(&pdev->dev))
 		return -ENODEV;
 
-	ret = acpi_bus_get_device(ACPI_HANDLE(&pdev->dev), &adev);
-	if (ret)
-		return -ENODEV;
-
 	dev->adapter.nr = -1;
-	if (adev->pnp.unique_id && !kstrtoint(adev->pnp.unique_id, 0, &busno))
-		dev->adapter.nr = busno;
-
 	dev->tx_fifo_depth = 32;
 	dev->rx_fifo_depth = 32;
 	return 0;
-- 
1.7.10.4


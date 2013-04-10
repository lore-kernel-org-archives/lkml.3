Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937159Ab3DJKer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 06:34:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:6099 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586Ab3DJKeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 06:34:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,445,1363158000"; 
   d="scan'208";a="225466243"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        ben-linux@fluff.org, Jean Delvare <khali@linux-fr.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 4/7] i2c-designware: use dynamic adapter numbering on Lynxpoint
Date: Wed, 10 Apr 2013 13:36:39 +0300
Message-Id: <1365590202-1623-4-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365590202-1623-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1365590202-1623-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not good idea to mix static and dynamic I2C adapter numbering. In
this particular case on Lynxpoint we had graphics I2C adapter which took
the first numbers preventing the designware I2C driver from using the
adapter numbers it preferred.

Since Lynxpoint support was just introduced and there is no hardware available
outside Intel we can fix this by switching to use dynamic adapter numbering
instead of static.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
Changes to v1:
	- Updated commit message to mention that this change should not
	  cause regressions as there are no real users for Lynxpoint
	  I2C controller driver yet.

 drivers/i2c/busses/i2c-designware-platdrv.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 94b3a4d..0735ccf 100644
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


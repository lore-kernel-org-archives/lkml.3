Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551AbaI3KFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:05:00 -0400
Received: from mga03.intel.com ([134.134.136.65]:64213 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbaI3KE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:04:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,625,1406617200"; 
   d="scan'208";a="610784151"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Carl Peng <carlpeng008@gmail.com>, Huang Rui <ray.huang@amd.com>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Romain Baeriswyl <Romain.Baeriswyl@abilis.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 1/3] i2c: designware: Default to fast mode in case of ACPI
Date: Tue, 30 Sep 2014 13:04:53 +0300
Message-Id: <1412071495-15323-2-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412071495-15323-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1412071495-15323-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no way in ACPI to tell in which speed the host controller is
supposed to run, so we default to fast mode (400KHz). Since this has been
the default all the time there should be no functional changes with this
change.

This is the first step required to refactor the driver probe so that we can
supply source clock from ACPI part of the driver to the core.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/i2c/busses/i2c-designware-platdrv.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 4d6a6b94e2fa..353adc4dc583 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -80,7 +80,6 @@ static void dw_i2c_acpi_params(struct platform_device *pdev, char method[],
 static int dw_i2c_acpi_configure(struct platform_device *pdev)
 {
 	struct dw_i2c_dev *dev = platform_get_drvdata(pdev);
-	bool fs_mode = dev->master_cfg & DW_IC_CON_SPEED_FAST;
 
 	if (!ACPI_HANDLE(&pdev->dev))
 		return -ENODEV;
@@ -93,10 +92,9 @@ static int dw_i2c_acpi_configure(struct platform_device *pdev)
 	 * Try to get SDA hold time and *CNT values from an ACPI method if
 	 * it exists for both supported speed modes.
 	 */
-	dw_i2c_acpi_params(pdev, "SSCN", &dev->ss_hcnt, &dev->ss_lcnt,
-			   fs_mode ? NULL : &dev->sda_hold_time);
+	dw_i2c_acpi_params(pdev, "SSCN", &dev->ss_hcnt, &dev->ss_lcnt, NULL);
 	dw_i2c_acpi_params(pdev, "FMCN", &dev->fs_hcnt, &dev->fs_lcnt,
-			   fs_mode ? &dev->sda_hold_time : NULL);
+			   &dev->sda_hold_time);
 
 	return 0;
 }
-- 
2.1.0


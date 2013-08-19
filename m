Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab3HSMIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 08:08:19 -0400
Received: from mga14.intel.com ([143.182.124.37]:25372 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab3HSMH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 08:07:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,913,1367996400"; 
   d="scan'208";a="383046542"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Shinya Kuribayashi <skuribay@pobox.com>, linux-i2c@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 2/2] i2c-designware: get SDA hold time, HCNT and LCNT configuration from ACPI
Date: Mon, 19 Aug 2013 15:07:54 +0300
Message-Id: <1376914074-31103-2-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1376914074-31103-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1376914074-31103-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some Intel LPSS I2C devices make the SDA hold time and *CNT parameters
available via SSCN (standard mode) and FMCN (fast mode) ACPI methods.

Implement support for this so that we check whether an ACPI method exists
and if it does, fill in the SDA hold time and *CNT values to the device
private structure for core to use.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
Changes to the previous version:
 * Combined SDA hold time and *CNT value setting to be in a single patch

 drivers/i2c/busses/i2c-designware-platdrv.c | 34 +++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 4c5fada..0d8b946 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -54,9 +54,33 @@ static u32 i2c_dw_get_clk_rate_khz(struct dw_i2c_dev *dev)
 }
 
 #ifdef CONFIG_ACPI
+static void dw_i2c_acpi_params(struct platform_device *pdev, char method[],
+			       u16 *hcnt, u16 *lcnt, u32 *sda_hold)
+{
+	struct acpi_buffer buf = { ACPI_ALLOCATE_BUFFER };
+	acpi_handle handle = ACPI_HANDLE(&pdev->dev);
+	union acpi_object *obj;
+
+	if (ACPI_FAILURE(acpi_evaluate_object(handle, method, NULL, &buf)))
+		return;
+
+	obj = (union acpi_object *)buf.pointer;
+	if (obj->type == ACPI_TYPE_PACKAGE && obj->package.count == 3) {
+		const union acpi_object *objs = obj->package.elements;
+
+		*hcnt = (u16)objs[0].integer.value;
+		*lcnt = (u16)objs[1].integer.value;
+		if (sda_hold)
+			*sda_hold = (u32)objs[2].integer.value;
+	}
+
+	kfree(buf.pointer);
+}
+
 static int dw_i2c_acpi_configure(struct platform_device *pdev)
 {
 	struct dw_i2c_dev *dev = platform_get_drvdata(pdev);
+	bool fs_mode = dev->master_cfg & DW_IC_CON_SPEED_FAST;
 
 	if (!ACPI_HANDLE(&pdev->dev))
 		return -ENODEV;
@@ -64,6 +88,16 @@ static int dw_i2c_acpi_configure(struct platform_device *pdev)
 	dev->adapter.nr = -1;
 	dev->tx_fifo_depth = 32;
 	dev->rx_fifo_depth = 32;
+
+	/*
+	 * Try to get SDA hold time and *CNT values from an ACPI method if
+	 * it exists for both supported speed modes.
+	 */
+	dw_i2c_acpi_params(pdev, "SSCN", &dev->ss_hcnt, &dev->ss_lcnt,
+			   fs_mode ? NULL : &dev->sda_hold_time);
+	dw_i2c_acpi_params(pdev, "FMCN", &dev->fs_hcnt, &dev->fs_lcnt,
+			   fs_mode ? &dev->sda_hold_time : NULL);
+
 	return 0;
 }
 
-- 
1.8.4.rc2


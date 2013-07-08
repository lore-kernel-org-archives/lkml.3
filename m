Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab3GHLmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 07:42:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:34930 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073Ab3GHLma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 07:42:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1020,1363158000"; 
   d="scan'208";a="265373113"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] i2c-designware: configure *CNT values from ACPI
Date: Mon,  8 Jul 2013 14:45:27 +0300
Message-Id: <1373283927-21677-2-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373283927-21677-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1373283927-21677-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some Intel LPSS I2C devices make the *CNT values available from ACPI
namespace in similar way than the SDA hold value. These values allow
platform/BIOS to specify the most accurate *CNT values for the device
driver to use.

So change the ACPI part of the driver to use these values if they exists
and otherwise use the default method based solely on the input clock speed.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
This applies on top of following patch which is not yet in i2c tree:

http://permalink.gmane.org/gmane.linux.drivers.i2c/15754

 drivers/i2c/busses/i2c-designware-platdrv.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index c7cfdac..a1488df 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -59,7 +59,6 @@ static int dw_i2c_acpi_configure(struct platform_device *pdev)
 	struct dw_i2c_dev *dev = platform_get_drvdata(pdev);
 	struct acpi_buffer buf = { ACPI_ALLOCATE_BUFFER };
 	acpi_handle handle = ACPI_HANDLE(&pdev->dev);
-	acpi_string name;
 
 	if (!handle)
 		return -ENODEV;
@@ -68,14 +67,32 @@ static int dw_i2c_acpi_configure(struct platform_device *pdev)
 	dev->tx_fifo_depth = 32;
 	dev->rx_fifo_depth = 32;
 
-	name = dev->master_cfg & DW_IC_CON_SPEED_FAST ? "FMCN" : "SSCN";
-	if (ACPI_SUCCESS(acpi_evaluate_object(handle, name, NULL, &buf))) {
+	/* Standard speed configuration */
+	if (ACPI_SUCCESS(acpi_evaluate_object(handle, "SSCN", NULL, &buf))) {
 		union acpi_object *obj = (union acpi_object *)buf.pointer;
 
 		if (obj->type == ACPI_TYPE_PACKAGE && obj->package.count == 3) {
 			const union acpi_object *objs = obj->package.elements;
 
-			dev->sda_hold_time = (u32)objs[2].integer.value;
+			dev->ss_hcnt = (u16)objs[0].integer.value;
+			dev->ss_lcnt = (u16)objs[1].integer.value;
+			if (!(dev->master_cfg & DW_IC_CON_SPEED_FAST))
+				dev->sda_hold_time = (u32)objs[2].integer.value;
+		}
+
+		kfree(buf.pointer);
+	}
+	/* Fast speed configuration */
+	if (ACPI_SUCCESS(acpi_evaluate_object(handle, "FMCN", NULL, &buf))) {
+		union acpi_object *obj = (union acpi_object *)buf.pointer;
+
+		if (obj->type == ACPI_TYPE_PACKAGE && obj->package.count == 3) {
+			const union acpi_object *objs = obj->package.elements;
+
+			dev->fs_hcnt = (u16)objs[0].integer.value;
+			dev->fs_lcnt = (u16)objs[1].integer.value;
+			if (dev->master_cfg & DW_IC_CON_SPEED_FAST)
+				dev->sda_hold_time = (u32)objs[2].integer.value;
 		}
 
 		kfree(buf.pointer);
-- 
1.8.3.2


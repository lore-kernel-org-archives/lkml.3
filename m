Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab3GCJtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 05:49:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:7854 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628Ab3GCJtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 05:49:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,987,1363158000"; 
   d="scan'208";a="364087329"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] i2c-designware: configure SDA hold time from ACPI
Date: Wed,  3 Jul 2013 12:52:40 +0300
Message-Id: <1372845160-32625-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some Intel LPSS I2C devices make the SDA hold time parameter available via
SSCN (standard mode) and FMCN (fast mode) ACPI methods. If we find that
such method exist, we evaluate it and pass the returned SDA hold value to
the i2c-designware core analogous to Device Tree.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/i2c/busses/i2c-designware-platdrv.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 8b9d3f1..c7cfdac 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -57,13 +57,30 @@ static u32 i2c_dw_get_clk_rate_khz(struct dw_i2c_dev *dev)
 static int dw_i2c_acpi_configure(struct platform_device *pdev)
 {
 	struct dw_i2c_dev *dev = platform_get_drvdata(pdev);
+	struct acpi_buffer buf = { ACPI_ALLOCATE_BUFFER };
+	acpi_handle handle = ACPI_HANDLE(&pdev->dev);
+	acpi_string name;
 
-	if (!ACPI_HANDLE(&pdev->dev))
+	if (!handle)
 		return -ENODEV;
 
 	dev->adapter.nr = -1;
 	dev->tx_fifo_depth = 32;
 	dev->rx_fifo_depth = 32;
+
+	name = dev->master_cfg & DW_IC_CON_SPEED_FAST ? "FMCN" : "SSCN";
+	if (ACPI_SUCCESS(acpi_evaluate_object(handle, name, NULL, &buf))) {
+		union acpi_object *obj = (union acpi_object *)buf.pointer;
+
+		if (obj->type == ACPI_TYPE_PACKAGE && obj->package.count == 3) {
+			const union acpi_object *objs = obj->package.elements;
+
+			dev->sda_hold_time = (u32)objs[2].integer.value;
+		}
+
+		kfree(buf.pointer);
+	}
+
 	return 0;
 }
 
-- 
1.8.3.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbaICCnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 22:43:43 -0400
Received: from mga14.intel.com ([192.55.52.115]:52799 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667AbaICCnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 22:43:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="380612126"
From: Raymond Tan <raymond.tan@intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Romain Baeriswyl <romainba@abilis.com>
Subject: [PATCH 1/1] i2c: designware: add support of platform data to set I2C mode
Date: Wed,  3 Sep 2014 10:41:38 +0800
Message-Id: <1409712098-13997-2-git-send-email-raymond.tan@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409712098-13997-1-git-send-email-raymond.tan@intel.com>
References: <1409712098-13997-1-git-send-email-raymond.tan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Tan, Raymond" <raymond.tan@intel.com>

Use the platform data to set the clk_freq when there is no DT configuration
available. The clk_freq in turn will determine the I2C speed mode.

In Quark, there is currently no other configuration mechanism other than
board files.

Signed-off-by: Raymond Tan <raymond.tan@intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Hock Leong Kweh <hock.leong.kweh@intel.com>
---
 drivers/i2c/busses/i2c-designware-platdrv.c  |    6 ++++++
 include/linux/platform_data/i2c-designware.h |   21 +++++++++++++++++++++
 2 files changed, 27 insertions(+)
 create mode 100644 include/linux/platform_data/i2c-designware.h

diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index b543fe1..ce3f779 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -41,6 +41,7 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 #include <linux/acpi.h>
+#include <linux/platform_data/i2c-designware.h>
 #include "i2c-designware-core.h"
 
 static struct i2c_algorithm i2c_dw_algo = {
@@ -121,6 +122,7 @@ static int dw_i2c_probe(struct platform_device *pdev)
 	struct dw_i2c_dev *dev;
 	struct i2c_adapter *adap;
 	struct resource *mem;
+	struct dw_i2c_platform_data *pdata;
 	int irq, r;
 	u32 clk_freq;
 
@@ -181,6 +183,10 @@ static int dw_i2c_probe(struct platform_device *pdev)
 			dev_err(&pdev->dev, "Only 100kHz and 400kHz supported");
 			return -EINVAL;
 		}
+	} else {
+		pdata = dev_get_platdata(&pdev->dev);
+		if (pdata)
+			clk_freq = pdata->i2c_scl_freq;
 	}
 
 	dev->functionality =
diff --git a/include/linux/platform_data/i2c-designware.h b/include/linux/platform_data/i2c-designware.h
new file mode 100644
index 0000000..7a61fb2
--- /dev/null
+++ b/include/linux/platform_data/i2c-designware.h
@@ -0,0 +1,21 @@
+/*
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#ifndef I2C_DESIGNWARE_H
+#define I2C_DESIGNWARE_H
+
+struct dw_i2c_platform_data {
+	unsigned int i2c_scl_freq;
+};
+
+#endif
-- 
1.7.9.5


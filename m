Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547Ab3AQKbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 05:31:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:4364 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759527Ab3AQKaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 05:30:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,484,1355126400"; 
   d="scan'208";a="273184814"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Jean Delvare <khali@linux-fr.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        dirk.brandewie@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] i2c-designware: add minimal support for runtime PM
Date: Thu, 17 Jan 2013 12:31:06 +0200
Message-Id: <1358418667-4533-4-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358418667-4533-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1358418667-4533-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to save power the device should be put to low power states
whenever it is not being used. We implement this by enabling minimal
runtime PM support.

There isn't much to do for the device itself as it is disabled once the
last transfer is completed but subsystem/domain runtime PM hooks can save
more power by power gating the device etc.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/i2c/busses/i2c-designware-platdrv.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 343357a..d8afc85 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -37,6 +37,7 @@
 #include <linux/of_i2c.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
+#include <linux/pm_runtime.h>
 #include <linux/io.h>
 #include <linux/slab.h>
 #include "i2c-designware-core.h"
@@ -149,6 +150,10 @@ static int dw_i2c_probe(struct platform_device *pdev)
 	}
 	of_i2c_register_devices(adap);
 
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_put(&pdev->dev);
+
 	return 0;
 
 err_free_irq:
@@ -175,6 +180,8 @@ static int dw_i2c_remove(struct platform_device *pdev)
 	struct resource *mem;
 
 	platform_set_drvdata(pdev, NULL);
+	pm_runtime_get_sync(&pdev->dev);
+
 	i2c_del_adapter(&dev->adapter);
 	put_device(&pdev->dev);
 
@@ -186,6 +193,9 @@ static int dw_i2c_remove(struct platform_device *pdev)
 	free_irq(dev->irq, dev);
 	kfree(dev);
 
+	pm_runtime_put(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(mem->start, resource_size(mem));
 	return 0;
-- 
1.7.10.4


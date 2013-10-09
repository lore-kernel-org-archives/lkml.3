Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab3JIOFJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 10:05:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:5841 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487Ab3JIOE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 10:04:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1063,1371106800"; 
   d="scan'208";a="408297990"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-acpi@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Mark Brown <broonie@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Aaron Lu <aaron.lu@intel.com>,
        Lv Zheng <lv.zheng@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] spi: attach/detach SPI device to the ACPI power domain
Date: Wed,  9 Oct 2013 17:04:21 +0300
Message-Id: <1381327461-10562-4-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381327461-10562-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1381327461-10562-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the SPI device is enumerated from ACPI namespace (it has an ACPI handle)
it might have ACPI methods that needs to be called in order to transition
the device to different power states (such as _PSx).

We follow what has been done for platform and I2C buses here and attach the
SPI device to the ACPI power domain if the device has an ACPI handle. This
makes sure that the device is powered on when its ->probe() is called.

For non-ACPI devices this patch is a no-op.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/spi/spi.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 9e039c6..c522aa1 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -240,15 +240,29 @@ EXPORT_SYMBOL_GPL(spi_bus_type);
 static int spi_drv_probe(struct device *dev)
 {
 	const struct spi_driver		*sdrv = to_spi_driver(dev->driver);
+	struct spi_device		*spi = to_spi_device(dev);
+	int ret;
+
+	if (ACPI_HANDLE(&spi->dev))
+		acpi_dev_pm_attach(&spi->dev, true);
+	ret = sdrv->probe(spi);
+	if (ret && ACPI_HANDLE(&spi->dev))
+		acpi_dev_pm_detach(&spi->dev, true);
 
-	return sdrv->probe(to_spi_device(dev));
+	return ret;
 }
 
 static int spi_drv_remove(struct device *dev)
 {
 	const struct spi_driver		*sdrv = to_spi_driver(dev->driver);
+	struct spi_device		*spi = to_spi_device(dev);
+	int ret;
+
+	ret = sdrv->remove(spi);
+	if (ACPI_HANDLE(&spi->dev))
+		acpi_dev_pm_detach(&spi->dev, true);
 
-	return sdrv->remove(to_spi_device(dev));
+	return ret;
 }
 
 static void spi_drv_shutdown(struct device *dev)
@@ -1025,8 +1039,10 @@ static acpi_status acpi_spi_add_device(acpi_handle handle, u32 level,
 		return AE_OK;
 	}
 
+	adev->power.flags.ignore_parent = true;
 	strlcpy(spi->modalias, dev_name(&adev->dev), sizeof(spi->modalias));
 	if (spi_add_device(spi)) {
+		adev->power.flags.ignore_parent = false;
 		dev_err(&master->dev, "failed to add SPI device %s from ACPI\n",
 			dev_name(&adev->dev));
 		spi_dev_put(spi);
-- 
1.8.4.rc3


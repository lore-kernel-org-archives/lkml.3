Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab3IKPdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 11:33:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:46505 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755093Ab3IKPcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 11:32:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,885,1371106800"; 
   d="scan'208";a="376662253"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel@lists.infradead.org, Mark Brown <broonie@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 9/9] spi: attach/detach SPI device to the ACPI power domain
Date: Wed, 11 Sep 2013 18:32:40 +0300
Message-Id: <1378913560-2752-10-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
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
 drivers/spi/spi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 94ebab9..cac0ca2 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -246,6 +246,9 @@ static int spi_drv_probe(struct device *dev)
 	/* Make sure that the master is powered on */
 	pm_runtime_get_sync(&spi->master->dev);
 
+	if (ACPI_HANDLE(&spi->dev))
+		acpi_dev_pm_attach(&spi->dev, true);
+
 	/*
 	 * Enable runtime PM for the SPI device. The SPI device driver can
 	 * participate in runtime PM by calling pm_runtime_put() in its
@@ -260,6 +263,9 @@ static int spi_drv_probe(struct device *dev)
 		pm_runtime_disable(&spi->dev);
 		pm_runtime_set_suspended(&spi->dev);
 		pm_runtime_put_noidle(&spi->dev);
+
+		if (ACPI_HANDLE(&spi->dev))
+			acpi_dev_pm_detach(&spi->dev, true);
 	}
 
 	pm_runtime_put(&spi->master->dev);
@@ -282,6 +288,9 @@ static int spi_drv_remove(struct device *dev)
 	pm_runtime_set_suspended(&spi->dev);
 	pm_runtime_put_noidle(&spi->dev);
 
+	if (ACPI_HANDLE(&spi->dev))
+		acpi_dev_pm_detach(&spi->dev, true);
+
 	pm_runtime_put(&spi->master->dev);
 
 	return ret;
-- 
1.8.4.rc3


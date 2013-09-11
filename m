Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab3IKPeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 11:34:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:9323 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493Ab3IKPdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 11:33:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,885,1371106800"; 
   d="scan'208";a="399998727"
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
Subject: [PATCH v2 8/9] spi: prepare runtime PM support for SPI devices
Date: Wed, 11 Sep 2013 18:32:39 +0300
Message-Id: <1378913560-2752-9-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds runtime PM support for the SPI bus analogous to what has
been done for the I2C bus. This means that the SPI core prepares runtime PM
for a client device just before a driver is about to be bound to it.
Devices that are not bound to any driver are not prepared for runtime PM.

In order to participate the runtime PM of the SPI bus a device driver needs
to drop the device runtime PM reference count by calling pm_runtime_put()
in its ->probe() callback and possibly implement rest of the runtime PM
callbacks.

If the driver doesn't support runtime PM, the device in question is
regarded as being runtime PM active and powered on.

This patch adds also runtime PM support for the SPI master device because
it is needed to be able to runtime power manage the SPI controller device.
The SPI master device is handled along with the SPI controller device.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/spi/spi.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 47 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 978dda2..94ebab9 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -240,22 +240,61 @@ EXPORT_SYMBOL_GPL(spi_bus_type);
 static int spi_drv_probe(struct device *dev)
 {
 	const struct spi_driver		*sdrv = to_spi_driver(dev->driver);
+	struct spi_device		*spi = to_spi_device(dev);
+	int				ret;
 
-	return sdrv->probe(to_spi_device(dev));
+	/* Make sure that the master is powered on */
+	pm_runtime_get_sync(&spi->master->dev);
+
+	/*
+	 * Enable runtime PM for the SPI device. The SPI device driver can
+	 * participate in runtime PM by calling pm_runtime_put() in its
+	 * probe() callback.
+	 */
+	pm_runtime_get_noresume(&spi->dev);
+	pm_runtime_set_active(&spi->dev);
+	pm_runtime_enable(&spi->dev);
+
+	ret = sdrv->probe(spi);
+	if (ret) {
+		pm_runtime_disable(&spi->dev);
+		pm_runtime_set_suspended(&spi->dev);
+		pm_runtime_put_noidle(&spi->dev);
+	}
+
+	pm_runtime_put(&spi->master->dev);
+
+	return ret;
 }
 
 static int spi_drv_remove(struct device *dev)
 {
 	const struct spi_driver		*sdrv = to_spi_driver(dev->driver);
+	struct spi_device		*spi = to_spi_device(dev);
+	int				ret;
+
+	pm_runtime_get_sync(&spi->master->dev);
+
+	ret = sdrv->remove(spi);
+
+	/* Undo the runtime PM done in spi_drv_probe() */
+	pm_runtime_disable(&spi->dev);
+	pm_runtime_set_suspended(&spi->dev);
+	pm_runtime_put_noidle(&spi->dev);
 
-	return sdrv->remove(to_spi_device(dev));
+	pm_runtime_put(&spi->master->dev);
+
+	return ret;
 }
 
 static void spi_drv_shutdown(struct device *dev)
 {
 	const struct spi_driver		*sdrv = to_spi_driver(dev->driver);
+	struct spi_device		*spi = to_spi_device(dev);
 
+	pm_runtime_get_sync(&spi->master->dev);
 	sdrv->shutdown(to_spi_device(dev));
+	pm_runtime_put(&spi->master->dev);
 }
 
 /**
@@ -1174,6 +1213,10 @@ int spi_register_master(struct spi_master *master)
 		}
 	}
 
+	pm_runtime_set_active(&master->dev);
+	pm_runtime_no_callbacks(&master->dev);
+	pm_runtime_enable(&master->dev);
+
 	mutex_lock(&board_lock);
 	list_add_tail(&master->list, &spi_master_list);
 	list_for_each_entry(bi, &board_list, list)
@@ -1217,6 +1260,8 @@ void spi_unregister_master(struct spi_master *master)
 	list_del(&master->list);
 	mutex_unlock(&board_lock);
 
+	pm_runtime_disable(&master->dev);
+
 	dummy = device_for_each_child(&master->dev, NULL, __unregister);
 	device_unregister(&master->dev);
 }
-- 
1.8.4.rc3


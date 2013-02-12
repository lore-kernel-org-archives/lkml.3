Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933796Ab3BLSjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:39:13 -0500
Received: from mga03.intel.com ([143.182.124.21]:52524 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933779Ab3BLSiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:38:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,650,1355126400"; 
   d="scan'208";a="256019997"
From: Samuel Ortiz <sameo@linux.intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, tomas.winkler@intel.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [char-misc-next 03/12 v3] mei: bus: Implement driver registration
Date: Tue, 12 Feb 2013 19:36:53 +0100
Message-Id: <1360694222-27632-4-git-send-email-sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360694222-27632-1-git-send-email-sameo@linux.intel.com>
References: <1360694222-27632-1-git-send-email-sameo@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/bus.c  |   26 ++++++++++++++++++++++++++
 include/linux/mei_bus.h |    6 ++++++
 2 files changed, 32 insertions(+)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 485fcf3c..04e7ada 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -149,3 +149,29 @@ void mei_remove_device(struct mei_device *device)
 	device_unregister(&device->dev);
 }
 EXPORT_SYMBOL_GPL(mei_remove_device);
+
+int __mei_driver_register(struct mei_driver *driver, struct module *owner)
+{
+	int err;
+
+	driver->driver.name = driver->name;
+	driver->driver.owner = owner;
+	driver->driver.bus = &mei_bus_type;
+
+	err = driver_register(&driver->driver);
+	if (err)
+		return err;
+
+	pr_debug("mei: driver [%s] registered\n", driver->driver.name);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__mei_driver_register);
+
+void mei_driver_unregister(struct mei_driver *driver)
+{
+	driver_unregister(&driver->driver);
+
+	pr_debug("mei: driver [%s] unregistered\n", driver->driver.name);
+}
+EXPORT_SYMBOL_GPL(mei_driver_unregister);
diff --git a/include/linux/mei_bus.h b/include/linux/mei_bus.h
index 6506cb7..28be556 100644
--- a/include/linux/mei_bus.h
+++ b/include/linux/mei_bus.h
@@ -89,4 +89,10 @@ struct mei_driver {
 	int (*remove)(struct mei_device *dev);
 };
 
+int __mei_driver_register(struct mei_driver *driver, struct module *owner);
+#define mei_driver_register(driver)             \
+	__mei_driver_register(driver, THIS_MODULE)
+
+void mei_driver_unregister(struct mei_driver *driver);
+
 #endif /* _LINUX_MEI_BUS_H */
-- 
1.7.10.4


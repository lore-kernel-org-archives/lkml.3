Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab3CTWox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 18:44:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:34695 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038Ab3CTWol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 18:44:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,880,1355126400"; 
   d="scan'208";a="282469744"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 02/11 V4] mei: bus: Implement driver registration
Date: Thu, 21 Mar 2013 00:44:20 +0200
Message-Id: <1363819469-696-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363819469-696-1-git-send-email-tomas.winkler@intel.com>
References: <1363819469-696-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/bus.c     | 26 ++++++++++++++++++++++++++
 include/linux/mei_cl_bus.h |  7 +++++++
 2 files changed, 33 insertions(+)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 24a25db..9283dd6 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -149,3 +149,29 @@ void mei_cl_remove_device(struct mei_cl_device *device)
 	device_unregister(&device->dev);
 }
 EXPORT_SYMBOL_GPL(mei_cl_remove_device);
+
+int __mei_cl_driver_register(struct mei_cl_driver *driver, struct module *owner)
+{
+	int err;
+
+	driver->driver.name = driver->name;
+	driver->driver.owner = owner;
+	driver->driver.bus = &mei_cl_bus_type;
+
+	err = driver_register(&driver->driver);
+	if (err)
+		return err;
+
+	pr_debug("mei: driver [%s] registered\n", driver->driver.name);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__mei_cl_driver_register);
+
+void mei_cl_driver_unregister(struct mei_cl_driver *driver)
+{
+	driver_unregister(&driver->driver);
+
+	pr_debug("mei: driver [%s] unregistered\n", driver->driver.name);
+}
+EXPORT_SYMBOL_GPL(mei_cl_driver_unregister);
diff --git a/include/linux/mei_cl_bus.h b/include/linux/mei_cl_bus.h
index ed4199b..92c30a8 100644
--- a/include/linux/mei_cl_bus.h
+++ b/include/linux/mei_cl_bus.h
@@ -89,4 +89,11 @@ struct mei_cl_driver {
 	int (*remove)(struct mei_cl_device *dev);
 };
 
+int __mei_cl_driver_register(struct mei_cl_driver *driver,
+				struct module *owner);
+#define mei_cl_driver_register(driver)             \
+	__mei_cl_driver_register(driver, THIS_MODULE)
+
+void mei_cl_driver_unregister(struct mei_cl_driver *driver);
+
 #endif /* _LINUX_MEI_CL_BUS_H */
-- 
1.8.1.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946486Ab3BHMbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 07:31:25 -0500
Received: from mga11.intel.com ([192.55.52.93]:64689 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946355Ab3BHM2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 07:28:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,629,1355126400"; 
   d="scan'208";a="284477741"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org, sameo@linux.intel.com
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 02/11 V2] mei: bus: Implement driver registration
Date: Fri,  8 Feb 2013 14:28:15 +0200
Message-Id: <1360326504-17041-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1360326504-17041-1-git-send-email-tomas.winkler@intel.com>
References: <1360326504-17041-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/bus.c  |   29 +++++++++++++++++++++++++++++
 include/linux/mei_bus.h |    3 +++
 2 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index bb96423c..0a5e624 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -153,3 +153,32 @@ void mei_remove_device(struct mei_bus_client *client)
 	device_unregister(&client->dev);
 }
 EXPORT_SYMBOL(mei_remove_device);
+
+int mei_driver_register(struct mei_bus_driver *driver)
+{
+	int err;
+
+	/* Can't register until after driver model init */
+	if (unlikely(WARN_ON(!mei_bus_type.p)))
+		return -EAGAIN;
+
+	driver->driver.owner = THIS_MODULE;
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
+EXPORT_SYMBOL(mei_driver_register);
+
+void mei_driver_unregister(struct mei_bus_driver *driver)
+{
+	driver_unregister(&driver->driver);
+
+	pr_debug("mei: driver [%s] unregistered\n", driver->driver.name);
+}
+EXPORT_SYMBOL(mei_driver_unregister);
diff --git a/include/linux/mei_bus.h b/include/linux/mei_bus.h
index 3a53f9e..0bd1189c 100644
--- a/include/linux/mei_bus.h
+++ b/include/linux/mei_bus.h
@@ -88,4 +88,7 @@ struct mei_bus_driver {
 	int (*remove)(struct mei_bus_client *client);
 };
 
+int mei_driver_register(struct mei_bus_driver *driver);
+void mei_driver_unregister(struct mei_bus_driver *driver);
+
 #endif /* _LINUX_MEI_BUS_H */
-- 
1.7.4.4


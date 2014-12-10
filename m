Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933126AbaLJTt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 14:49:28 -0500
Received: from mga02.intel.com ([134.134.136.20]:33536 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932906AbaLJTtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 14:49:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,553,1413270000"; 
   d="scan'208";a="621770540"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
Subject: [PATCH char-misc-next 04/13] misc: mic: SCIF Peer Bus
Date: Wed, 10 Dec 2014 11:47:44 -0800
Message-Id: <a6cd58c4c752a4848d078af397ecf341158c2725.1418237176.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1418237176.git.sudeep.dutt@intel.com>
References: <cover.1418237176.git.sudeep.dutt@intel.com>
In-Reply-To: <cover.1418237176.git.sudeep.dutt@intel.com>
References: <cover.1418237176.git.sudeep.dutt@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SCIF peer bus is used to register and unregister SCIF peer devices
internally by the SCIF driver to signify the addition and removal of
peer nodes respectively from the SCIF network. This simplifies remote node
handling within SCIF and will also be used to support device probe/remove
for SCIF client drivers (e.g. netdev over SCIF)

Reviewed-by: Nikhil Rao <nikhil.rao@intel.com>
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
---
 drivers/misc/mic/scif/scif_peer_bus.h |  63 +++++++++++++++++
 drivers/misc/mic/scif/scif_peer_bus.c | 124 ++++++++++++++++++++++++++++++++++
 2 files changed, 187 insertions(+)
 create mode 100644 drivers/misc/mic/scif/scif_peer_bus.h
 create mode 100644 drivers/misc/mic/scif/scif_peer_bus.c

diff --git a/drivers/misc/mic/scif/scif_peer_bus.h b/drivers/misc/mic/scif/scif_peer_bus.h
new file mode 100644
index 0000000..27ed508
--- /dev/null
+++ b/drivers/misc/mic/scif/scif_peer_bus.h
@@ -0,0 +1,63 @@
+/*
+ * Intel MIC Platform Software Stack (MPSS)
+ *
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * Intel SCIF driver.
+ */
+#ifndef _SCIF_PEER_BUS_H_
+#define _SCIF_PEER_BUS_H_
+
+#include <linux/device.h>
+#include <linux/mic_common.h>
+
+/*
+ * Peer devices show up as PCIe devices for the mgmt node but not the cards.
+ * The mgmt node discovers all the cards on the PCIe bus and informs the other
+ * cards about their peers. Upon notification of a peer a node adds a peer
+ * device to the peer bus to maintain symmetry in the way devices are
+ * discovered across all nodes in the SCIF network.
+ */
+/**
+ * scif_peer_dev - representation of a peer SCIF device
+ * @dev: underlying device
+ * @dnode - The destination node which this device will communicate with.
+ */
+struct scif_peer_dev {
+	struct device dev;
+	u8 dnode;
+};
+
+/**
+ * scif_peer_driver - operations for a scif_peer I/O driver
+ * @driver: underlying device driver (populate name and owner).
+ * @id_table: the ids serviced by this driver.
+ * @probe: the function to call when a device is found.  Returns 0 or -errno.
+ * @remove: the function to call when a device is removed.
+ */
+struct scif_peer_driver {
+	struct device_driver driver;
+	const struct scif_peer_dev_id *id_table;
+
+	int (*probe)(struct scif_peer_dev *dev);
+	void (*remove)(struct scif_peer_dev *dev);
+};
+
+int scif_peer_register_driver(struct scif_peer_driver *driver);
+void scif_peer_unregister_driver(struct scif_peer_driver *driver);
+struct scif_dev;
+struct scif_peer_dev *
+scif_peer_register_device(struct scif_dev *sdev);
+void scif_peer_unregister_device(struct scif_peer_dev *sdev);
+int scif_peer_bus_init(void);
+void scif_peer_bus_exit(void);
+#endif /* _SCIF_PEER_BUS_H */
diff --git a/drivers/misc/mic/scif/scif_peer_bus.c b/drivers/misc/mic/scif/scif_peer_bus.c
new file mode 100644
index 0000000..589ae9a
--- /dev/null
+++ b/drivers/misc/mic/scif/scif_peer_bus.c
@@ -0,0 +1,124 @@
+/*
+ * Intel MIC Platform Software Stack (MPSS)
+ *
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * Intel SCIF driver.
+ */
+#include "scif_main.h"
+#include "../bus/scif_bus.h"
+#include "scif_peer_bus.h"
+
+static inline struct scif_peer_dev *
+dev_to_scif_peer(struct device *dev)
+{
+	return container_of(dev, struct scif_peer_dev, dev);
+}
+
+static inline struct scif_peer_driver *
+drv_to_scif_peer(struct device_driver *drv)
+{
+	return container_of(drv, struct scif_peer_driver, driver);
+}
+
+static int scif_peer_dev_match(struct device *dv, struct device_driver *dr)
+{
+	return !strncmp(dev_name(dv), dr->name, 4);
+}
+
+static int scif_peer_dev_probe(struct device *d)
+{
+	struct scif_peer_dev *dev = dev_to_scif_peer(d);
+	struct scif_peer_driver *drv = drv_to_scif_peer(dev->dev.driver);
+
+	return drv->probe(dev);
+}
+
+static int scif_peer_dev_remove(struct device *d)
+{
+	struct scif_peer_dev *dev = dev_to_scif_peer(d);
+	struct scif_peer_driver *drv = drv_to_scif_peer(dev->dev.driver);
+
+	drv->remove(dev);
+	return 0;
+}
+
+static struct bus_type scif_peer_bus = {
+	.name  = "scif_peer_bus",
+	.match = scif_peer_dev_match,
+	.probe = scif_peer_dev_probe,
+	.remove = scif_peer_dev_remove,
+};
+
+int scif_peer_register_driver(struct scif_peer_driver *driver)
+{
+	driver->driver.bus = &scif_peer_bus;
+	return driver_register(&driver->driver);
+}
+
+void scif_peer_unregister_driver(struct scif_peer_driver *driver)
+{
+	driver_unregister(&driver->driver);
+}
+
+static void scif_peer_release_dev(struct device *d)
+{
+	struct scif_peer_dev *sdev = dev_to_scif_peer(d);
+	struct scif_dev *scifdev = &scif_dev[sdev->dnode];
+
+	scif_cleanup_scifdev(scifdev);
+	kfree(sdev);
+}
+
+struct scif_peer_dev *
+scif_peer_register_device(struct scif_dev *scifdev)
+{
+	int ret;
+	struct scif_peer_dev *spdev;
+
+	spdev = kzalloc(sizeof(*spdev), GFP_KERNEL);
+	if (!spdev)
+		return ERR_PTR(-ENOMEM);
+
+	spdev->dev.parent = scifdev->sdev->dev.parent;
+	spdev->dev.release = scif_peer_release_dev;
+	spdev->dnode = scifdev->node;
+	spdev->dev.bus = &scif_peer_bus;
+
+	dev_set_name(&spdev->dev, "scif_peer-dev%u", spdev->dnode);
+	/*
+	 * device_register() causes the bus infrastructure to look for a
+	 * matching driver.
+	 */
+	ret = device_register(&spdev->dev);
+	if (ret)
+		goto free_spdev;
+	return spdev;
+free_spdev:
+	kfree(spdev);
+	return ERR_PTR(ret);
+}
+
+void scif_peer_unregister_device(struct scif_peer_dev *sdev)
+{
+	device_unregister(&sdev->dev);
+}
+
+int scif_peer_bus_init(void)
+{
+	return bus_register(&scif_peer_bus);
+}
+
+void scif_peer_bus_exit(void)
+{
+	bus_unregister(&scif_peer_bus);
+}
-- 
1.8.2.1


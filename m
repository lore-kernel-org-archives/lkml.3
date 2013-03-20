Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab3CTWo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 18:44:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:34695 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779Ab3CTWos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 18:44:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,880,1355126400"; 
   d="scan'208";a="282469798"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 05/11 V4] mei: bus: Call bus routines from the core code
Date: Thu, 21 Mar 2013 00:44:23 +0200
Message-Id: <1363819469-696-6-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363819469-696-1-git-send-email-tomas.winkler@intel.com>
References: <1363819469-696-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

Register the MEI bus type against the kernel core bus APIs and
call the bus Rx handler from interrupt.c

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/bus.c       | 22 ++++++++++++++++++++++
 drivers/misc/mei/interrupt.c |  2 ++
 drivers/misc/mei/mei_dev.h   |  6 +++++-
 drivers/misc/mei/pci-me.c    | 21 +++++++++++++++++++--
 4 files changed, 48 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 5691f83..d55f6d8 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -419,3 +419,25 @@ int mei_cl_register_event_cb(struct mei_cl_device *device,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mei_cl_register_event_cb);
+
+void mei_cl_bus_rx_event(struct mei_cl *cl)
+{
+	struct mei_cl_device *device = cl->device;
+
+	if (!device || !device->event_cb)
+		return;
+
+	set_bit(MEI_CL_EVENT_RX, &device->events);
+
+	schedule_work(&device->event_work);
+}
+
+int __init mei_cl_bus_init(struct pci_dev *pdev)
+{
+	return bus_register(&mei_cl_bus_type);
+}
+
+void __exit mei_cl_bus_exit(void)
+{
+	bus_unregister(&mei_cl_bus_type);
+}
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 73fbce3..c478332 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -49,6 +49,8 @@ static void mei_cl_complete_handler(struct mei_cl *cl, struct mei_cl_cb *cb)
 		cl->reading_state = MEI_READ_COMPLETE;
 		if (waitqueue_active(&cl->rx_wait))
 			wake_up_interruptible(&cl->rx_wait);
+		else
+			mei_cl_bus_rx_event(cl);
 
 	}
 }
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index d9da1fb..0391dc9 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -292,6 +292,11 @@ struct mei_cl_transport_ops {
 	int (*recv)(struct mei_cl_device *device, u8 *buf, size_t length);
 };
 
+void mei_cl_bus_rx_event(struct mei_cl *cl);
+int mei_cl_bus_init(struct pci_dev *pdev);
+void mei_cl_bus_exit(void);
+
+
 /**
  * struct mei_cl_device - MEI device handle
  * An mei_cl_device pointer is returned from mei_add_device()
@@ -452,7 +457,6 @@ static inline u32 mei_data2slots(size_t length)
 	return DIV_ROUND_UP(sizeof(struct mei_msg_hdr) + length, 4);
 }
 
-
 /*
  * mei init function prototypes
  */
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index b8b5c9c..badc0bd 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -197,7 +197,6 @@ static int mei_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	mei_pdev = pdev;
 	pci_set_drvdata(pdev, dev);
 
-
 	schedule_delayed_work(&dev->timer_work, HZ);
 
 	mutex_unlock(&mei_mutex);
@@ -351,7 +350,25 @@ static struct pci_driver mei_driver = {
 	.driver.pm = MEI_PM_OPS,
 };
 
-module_pci_driver(mei_driver);
+static int __init mei_init(void)
+{
+	int err;
+
+	err = mei_cl_bus_init(mei_pdev);
+	if (err)
+		return err;
+
+	return pci_register_driver(&mei_driver);
+}
+
+static void __exit mei_exit(void)
+{
+	pci_unregister_driver(&mei_driver);
+	mei_cl_bus_exit();
+}
+
+module_init(mei_init);
+module_exit(mei_exit);
 
 MODULE_AUTHOR("Intel Corporation");
 MODULE_DESCRIPTION("Intel(R) Management Engine Interface");
-- 
1.8.1.3


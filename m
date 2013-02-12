Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933773Ab3BLShv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:37:51 -0500
Received: from mga01.intel.com ([192.55.52.88]:31853 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933597Ab3BLSht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:37:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,650,1355126400"; 
   d="scan'208";a="290196094"
From: Samuel Ortiz <sameo@linux.intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, tomas.winkler@intel.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [char-misc-next 06/12 v3] mei: bus: Call bus routines from the core code
Date: Tue, 12 Feb 2013 19:36:56 +0100
Message-Id: <1360694222-27632-7-git-send-email-sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360694222-27632-1-git-send-email-sameo@linux.intel.com>
References: <1360694222-27632-1-git-send-email-sameo@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register the MEI bus type against the kernel core bus APIs and
call the bus Rx handler from interrupt.c

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/bus.c       |   22 ++++++++++++++++++++++
 drivers/misc/mei/interrupt.c |    2 ++
 drivers/misc/mei/mei_dev.h   |    4 ++++
 drivers/misc/mei/pci-me.c    |   21 +++++++++++++++++++--
 4 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 0d8caec..4565e9a 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -421,3 +421,25 @@ int mei_register_event_cb(struct mei_device *device,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mei_register_event_cb);
+
+void mei_bus_rx_event(struct mei_cl *cl)
+{
+	struct mei_device *device = cl->device;
+
+	if (!device || !device->event_cb)
+		return;
+
+	set_bit(MEI_EVENT_RX, &device->events);
+
+	schedule_work(&device->event_work);
+}
+
+int __init mei_bus_init(struct pci_dev *pdev)
+{
+	return bus_register(&mei_bus_type);
+}
+
+void __exit mei_bus_exit(void)
+{
+	bus_unregister(&mei_bus_type);
+}
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 30cc864..9acfcaf 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -49,6 +49,8 @@ void mei_irq_complete_handler(struct mei_cl *cl, struct mei_cl_cb *cb_pos)
 		cl->reading_state = MEI_READ_COMPLETE;
 		if (waitqueue_active(&cl->rx_wait))
 			wake_up_interruptible(&cl->rx_wait);
+		else
+			mei_bus_rx_event(cl);
 
 	}
 }
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 45d008b..546cd87 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -437,6 +437,10 @@ static inline unsigned long mei_secs_to_jiffies(unsigned long sec)
 	return msecs_to_jiffies(sec * MSEC_PER_SEC);
 }
 
+void mei_bus_rx_event(struct mei_cl *cl);
+int mei_bus_init(struct pci_dev *pdev);
+void mei_bus_exit(void);
+
 
 /*
  * mei init function prototypes
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 8e88ec0..e31090f 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -197,7 +197,6 @@ static int mei_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	mei_pdev = pdev;
 	pci_set_drvdata(pdev, dev);
 
-
 	schedule_delayed_work(&dev->timer_work, HZ);
 
 	mutex_unlock(&mei_mutex);
@@ -389,7 +388,25 @@ static struct pci_driver mei_driver = {
 	.driver.pm = MEI_PM_OPS,
 };
 
-module_pci_driver(mei_driver);
+static int __init mei_init(void)
+{
+	int err;
+
+	err = mei_bus_init(mei_pdev);
+	if (err)
+		return err;
+
+	return pci_register_driver(&mei_driver);
+}
+
+static void __exit mei_exit(void)
+{
+	pci_unregister_driver(&mei_driver);
+	mei_bus_exit();
+}
+
+module_init(mei_init);
+module_exit(mei_exit);
 
 MODULE_AUTHOR("Intel Corporation");
 MODULE_DESCRIPTION("Intel(R) Management Engine Interface");
-- 
1.7.10.4


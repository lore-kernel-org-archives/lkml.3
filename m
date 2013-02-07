Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469Ab3BGVGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 16:06:09 -0500
Received: from mga14.intel.com ([143.182.124.37]:15699 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759361Ab3BGVDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 16:03:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,623,1355126400"; 
   d="scan'208";a="253970110"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org, sameo@linux.intel.com
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 05/11] mei: bus: Call bus routines from the core code
Date: Thu,  7 Feb 2013 23:03:11 +0200
Message-Id: <1360270997-7639-6-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1360270997-7639-1-git-send-email-tomas.winkler@intel.com>
References: <1360270997-7639-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

Register the MEI bus type against the kernel core bus APIs and
call the bus Rx handler from interrupt.c

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/bus.c       |   22 ++++++++++++++++++++++
 drivers/misc/mei/interrupt.c |    2 ++
 drivers/misc/mei/mei_dev.h   |    4 ++++
 drivers/misc/mei/pci-me.c    |    6 ++++++
 4 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 97afec6..e2e15d1 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -429,3 +429,25 @@ int mei_bus_register_event_cb(struct mei_bus_client *client,
 	return 0;
 }
 EXPORT_SYMBOL(mei_bus_register_event_cb);
+
+void mei_bus_rx_event(struct mei_cl *cl)
+{
+	struct mei_bus_client *client = cl->client;
+
+	if (!client || !client->event_cb)
+		return;
+
+	set_bit(MEI_BUS_EVENT_RX, &client->events);
+
+	schedule_work(&client->event_work);
+}
+
+int mei_bus_init(struct pci_dev *pdev)
+{
+	return bus_register(&mei_bus_type);
+}
+
+void mei_bus_exit(void)
+{
+	bus_unregister(&mei_bus_type);
+}
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 3535b26..d0dea50 100644
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
index d9adad6..cb1bac0 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -420,6 +420,10 @@ static inline unsigned long mei_secs_to_jiffies(unsigned long sec)
 	return msecs_to_jiffies(sec * MSEC_PER_SEC);
 }
 
+void mei_bus_rx_event(struct mei_cl *cl);
+int mei_bus_init(struct pci_dev *pdev);
+void mei_bus_exit(void);
+
 
 /*
  * mei init function prototypes
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index b40ec06..f736531 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -197,6 +197,9 @@ static int mei_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	mei_pdev = pdev;
 	pci_set_drvdata(pdev, dev);
 
+	err = mei_bus_init(mei_pdev);
+	if (err)
+		goto deregister_mei;
 
 	schedule_delayed_work(&dev->timer_work, HZ);
 
@@ -206,6 +209,8 @@ static int mei_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	return 0;
 
+deregister_mei:
+	mei_deregister();
 release_irq:
 	mei_disable_interrupts(dev);
 	flush_scheduled_work();
@@ -300,6 +305,7 @@ static void mei_remove(struct pci_dev *pdev)
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 
+	mei_bus_exit();
 	mei_deregister();
 
 }
-- 
1.7.4.4


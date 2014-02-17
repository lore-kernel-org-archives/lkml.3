Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbaBQNO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 08:14:58 -0500
Received: from mga02.intel.com ([134.134.136.20]:9253 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322AbaBQNO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 08:14:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,860,1384329600"; 
   d="scan'208";a="456852893"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 03/11] mei: Remove all bus devices from the mei_dev list when stopping the MEI
Date: Mon, 17 Feb 2014 15:13:19 +0200
Message-Id: <1392642807-8878-4-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392642807-8878-1-git-send-email-tomas.winkler@intel.com>
References: <1392642807-8878-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When stopping the MEI, we should remove and potentially unregister
all bus devices queued on the mei_dev linked list.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/bus.c     | 16 ++++++++++++++++
 drivers/misc/mei/init.c    |  2 ++
 drivers/misc/mei/mei_dev.h |  1 +
 drivers/misc/mei/nfc.c     |  8 +-------
 4 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 4bc7d62..cf4cc0b 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -524,6 +524,22 @@ void mei_cl_bus_rx_event(struct mei_cl *cl)
 	schedule_work(&device->event_work);
 }
 
+void mei_cl_bus_remove_devices(struct mei_device *dev)
+{
+	struct mei_cl *cl, *next;
+
+	mutex_lock(&dev->device_lock);
+	list_for_each_entry_safe(cl, next, &dev->device_list, device_link) {
+		if (cl->device)
+			mei_cl_remove_device(cl->device);
+
+		list_del(&cl->device_link);
+		mei_cl_unlink(cl);
+		kfree(cl);
+	}
+	mutex_unlock(&dev->device_lock);
+}
+
 int __init mei_cl_bus_init(void)
 {
 	return bus_register(&mei_cl_bus_type);
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 214dcef..4460975 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -288,6 +288,8 @@ void mei_stop(struct mei_device *dev)
 
 	mei_nfc_host_exit(dev);
 
+	mei_cl_bus_remove_devices(dev);
+
 	mutex_lock(&dev->device_lock);
 
 	mei_wd_stop(dev);
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 49bf2cf..c59c56b 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -296,6 +296,7 @@ int __mei_cl_async_send(struct mei_cl *cl, u8 *buf, size_t length);
 int __mei_cl_send(struct mei_cl *cl, u8 *buf, size_t length);
 int __mei_cl_recv(struct mei_cl *cl, u8 *buf, size_t length);
 void mei_cl_bus_rx_event(struct mei_cl *cl);
+void mei_cl_bus_remove_devices(struct mei_device *dev);
 int mei_cl_bus_init(void);
 void mei_cl_bus_exit(void);
 
diff --git a/drivers/misc/mei/nfc.c b/drivers/misc/mei/nfc.c
index a58320c..7626dde 100644
--- a/drivers/misc/mei/nfc.c
+++ b/drivers/misc/mei/nfc.c
@@ -552,13 +552,7 @@ err:
 void mei_nfc_host_exit(struct mei_device *dev)
 {
 	struct mei_nfc_dev *ndev = &nfc_dev;
-
 	cancel_work_sync(&ndev->init_work);
+}
 
-	mutex_lock(&dev->device_lock);
-	if (ndev->cl && ndev->cl->device)
-		mei_cl_remove_device(ndev->cl->device);
 
-	mei_nfc_free(ndev);
-	mutex_unlock(&dev->device_lock);
-}
-- 
1.8.5.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab3CTWo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 18:44:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:34695 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605Ab3CTWoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 18:44:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,880,1355126400"; 
   d="scan'208";a="282469773"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 04/11 V4] mei: bus: Add bus related structures to mei_cl
Date: Thu, 21 Mar 2013 00:44:22 +0200
Message-Id: <1363819469-696-5-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363819469-696-1-git-send-email-tomas.winkler@intel.com>
References: <1363819469-696-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

We keep track of all MEI devices on the bus through a specific linked list.
We also have a mei_device instance in the mei_cl structure.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/bus.c     | 48 +++++++++++++++++++++++++++++++---------------
 drivers/misc/mei/client.c  |  1 +
 drivers/misc/mei/init.c    |  1 +
 drivers/misc/mei/mei_dev.h |  8 ++++++++
 4 files changed, 43 insertions(+), 15 deletions(-)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 43f77b8..5691f83 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -117,38 +117,54 @@ static struct device_type mei_cl_device_type = {
 	.release	= mei_cl_dev_release,
 };
 
-struct mei_cl_device *mei_cl_add_device(struct mei_device *mei_device,
+static struct mei_cl *mei_bus_find_mei_cl_by_uuid(struct mei_device *dev,
+						uuid_le uuid)
+{
+	struct mei_cl *cl, *next;
+
+	list_for_each_entry_safe(cl, next, &dev->device_list, device_link) {
+		if (!uuid_le_cmp(uuid, cl->device_uuid))
+			return cl;
+	}
+
+	return NULL;
+}
+struct mei_cl_device *mei_cl_add_device(struct mei_device *dev,
 				  uuid_le uuid, char *name)
 {
 	struct mei_cl_device *device;
+	struct mei_cl *cl;
 	int status;
 
+	cl = mei_bus_find_mei_cl_by_uuid(dev, uuid);
+	if (cl == NULL)
+		return NULL;
+
 	device = kzalloc(sizeof(struct mei_cl_device), GFP_KERNEL);
 	if (!device)
 		return NULL;
 
 	device->uuid = uuid;
+	device->cl = cl;
 
-	device->dev.parent = &mei_device->pdev->dev;
+	device->dev.parent = &dev->pdev->dev;
 	device->dev.bus = &mei_cl_bus_type;
 	device->dev.type = &mei_cl_device_type;
 
 	dev_set_name(&device->dev, "%s", name);
 
 	status = device_register(&device->dev);
-	if (status)
-		goto out_err;
+	if (status) {
+		dev_err(&dev->pdev->dev, "Failed to register MEI device\n");
+		kfree(device);
+		return NULL;
+	}
+
+	cl->device = device;
 
 	dev_dbg(&device->dev, "client %s registered\n", name);
 
 	return device;
-
-out_err:
-	dev_err(device->dev.parent, "Failed to register MEI client\n");
-
-	kfree(device);
-
-	return NULL;
 }
 EXPORT_SYMBOL_GPL(mei_cl_add_device);
 
@@ -346,9 +362,10 @@ out:
 
 int mei_cl_send(struct mei_cl_device *device, u8 *buf, size_t length)
 {
-	struct mei_cl *cl = NULL;
+	struct mei_cl *cl = device->cl;
 
-	/* TODO: hook between mei_bus_client and mei_cl */
+	if (cl == NULL)
+		return -ENODEV;
 
 	if (device->ops && device->ops->send)
 		return device->ops->send(device, buf, length);
@@ -359,9 +376,10 @@ EXPORT_SYMBOL_GPL(mei_cl_send);
 
 int mei_cl_recv(struct mei_cl_device *device, u8 *buf, size_t length)
 {
-	struct mei_cl *cl = NULL;
+	struct mei_cl *cl =  device->cl;
 
-	/* TODO: hook between mei_bus_client and mei_cl */
+	if (cl == NULL)
+		return -ENODEV;
 
 	if (device->ops && device->ops->recv)
 		return device->ops->recv(device, buf, length);
diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 1569afe..e14397b 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -216,6 +216,7 @@ void mei_cl_init(struct mei_cl *cl, struct mei_device *dev)
 	init_waitqueue_head(&cl->rx_wait);
 	init_waitqueue_head(&cl->tx_wait);
 	INIT_LIST_HEAD(&cl->link);
+	INIT_LIST_HEAD(&cl->device_link);
 	cl->reading_state = MEI_IDLE;
 	cl->writing_state = MEI_IDLE;
 	cl->dev = dev;
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 09a9980..27df330 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -46,6 +46,7 @@ void mei_device_init(struct mei_device *dev)
 {
 	/* setup our list array */
 	INIT_LIST_HEAD(&dev->file_list);
+	INIT_LIST_HEAD(&dev->device_list);
 	mutex_init(&dev->device_lock);
 	init_waitqueue_head(&dev->wait_hw_ready);
 	init_waitqueue_head(&dev->wait_recvd_msg);
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 800ac2b..d9da1fb 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -209,6 +209,11 @@ struct mei_cl {
 	enum mei_file_transaction_states writing_state;
 	int sm_state;
 	struct mei_cl_cb *read_cb;
+
+	/* MEI CL bus data */
+	struct mei_cl_device *device;
+	struct list_head device_link;
+	uuid_le device_uuid;
 };
 
 /** struct mei_hw_ops
@@ -424,6 +429,9 @@ struct mei_device {
 
 	struct work_struct init_work;
 
+	/* List of bus devices */
+	struct list_head device_list;
+
 	const struct mei_hw_ops *ops;
 	char hw[0] __aligned(sizeof(void *));
 };
-- 
1.8.1.3


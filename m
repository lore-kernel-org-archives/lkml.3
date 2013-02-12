Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933783Ab3BLSkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:40:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:62145 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933749Ab3BLShq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:37:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,650,1355126400"; 
   d="scan'208";a="284807477"
From: Samuel Ortiz <sameo@linux.intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, tomas.winkler@intel.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [char-misc-next 05/12 v3] mei: bus: Add bus related structures to mei_cl
Date: Tue, 12 Feb 2013 19:36:55 +0100
Message-Id: <1360694222-27632-6-git-send-email-sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360694222-27632-1-git-send-email-sameo@linux.intel.com>
References: <1360694222-27632-1-git-send-email-sameo@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We keep track of all MEI devices on the bus through a specific linked list.
We also have a mei_device instance in the mei_cl structure.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/bus.c     |   46 +++++++++++++++++++++++++++++++-------------
 drivers/misc/mei/client.c  |    1 +
 drivers/misc/mei/init.c    |    1 +
 drivers/misc/mei/mei_dev.h |    8 ++++++++
 4 files changed, 43 insertions(+), 13 deletions(-)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 7229d3e..0d8caec 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -117,17 +117,37 @@ static struct device_type mei_client_type = {
 	.release	= mei_client_dev_release,
 };
 
+static struct mei_cl *mei_bus_find_mei_cl_by_uuid(struct mei_host *mei_dev,
+						  uuid_le uuid)
+{
+	struct mei_cl *cl, *next;
+
+	list_for_each_entry_safe(cl, next,
+				 &mei_dev->device_list, device_link) {
+		if (!uuid_le_cmp(uuid, cl->device_uuid))
+			return cl;
+	}
+
+	return NULL;
+}
+
 struct mei_device *mei_add_device(struct mei_host *mei_host,
 				  uuid_le uuid, char *name)
 {
 	struct mei_device *device;
+	struct mei_cl *cl;
 	int status;
 
+	cl = mei_bus_find_mei_cl_by_uuid(mei_host, uuid);
+	if (cl == NULL)
+		return NULL;
+
 	device = kzalloc(sizeof(struct mei_device), GFP_KERNEL);
 	if (!device)
 		return NULL;
 
 	device->uuid = uuid;
+	device->cl = cl;
 
 	device->dev.parent = &mei_host->pdev->dev;
 	device->dev.bus = &mei_bus_type;
@@ -136,19 +156,17 @@ struct mei_device *mei_add_device(struct mei_host *mei_host,
 	dev_set_name(&device->dev, "%s", name);
 
 	status = device_register(&device->dev);
-	if (status)
-		goto out_err;
+	if (status) {
+		kfree(device);
+		dev_err(device->dev.parent, "Failed to register MEI device\n");
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
 EXPORT_SYMBOL_GPL(mei_add_device);
 
@@ -346,9 +364,10 @@ out:
 
 int mei_send(struct mei_device *device, u8 *buf, size_t length)
 {
-	struct mei_cl *cl = NULL;
+	struct mei_cl *cl = device->cl;
 
-	/* TODO: hook between mei_bus_client and mei_cl */
+	if (cl == NULL)
+		return -ENODEV;
 
 	if (device->ops && device->ops->send)
 		return device->ops->send(device, buf, length);
@@ -359,9 +378,10 @@ EXPORT_SYMBOL_GPL(mei_send);
 
 int mei_recv(struct mei_device *device, u8 *buf, size_t length)
 {
-	struct mei_cl *cl = NULL;
+	struct mei_cl *cl =  device->cl;
 
-	/* TODO: hook between mei_bus_client and mei_cl */
+	if (cl == NULL)
+		return -ENODEV;
 
 	if (device->ops && device->ops->recv)
 		return device->ops->recv(device, buf, length);
diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 79eda18..ef5300a 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -216,6 +216,7 @@ void mei_cl_init(struct mei_cl *cl, struct mei_host *dev)
 	init_waitqueue_head(&cl->rx_wait);
 	init_waitqueue_head(&cl->tx_wait);
 	INIT_LIST_HEAD(&cl->link);
+	INIT_LIST_HEAD(&cl->device_link);
 	cl->reading_state = MEI_IDLE;
 	cl->writing_state = MEI_IDLE;
 	cl->dev = dev;
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index d4b48a7..6fb4a9e 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -46,6 +46,7 @@ void mei_device_init(struct mei_host *dev)
 {
 	/* setup our list array */
 	INIT_LIST_HEAD(&dev->file_list);
+	INIT_LIST_HEAD(&dev->device_list);
 	mutex_init(&dev->device_lock);
 	init_waitqueue_head(&dev->wait_recvd_msg);
 	init_waitqueue_head(&dev->wait_stop_wd);
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index ee75343..45d008b 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -210,6 +210,11 @@ struct mei_cl {
 	enum mei_file_transaction_states writing_state;
 	int sm_state;
 	struct mei_cl_cb *read_cb;
+
+	/* MEI bus data */
+	struct mei_device *device;
+	struct list_head device_link;
+	uuid_le device_uuid;
 };
 
 /** struct mei_hw_ops
@@ -420,6 +425,9 @@ struct mei_host {
 
 	struct work_struct init_work;
 
+	/* List of bus devices */
+	struct list_head device_list;
+
 	const struct mei_hw_ops *ops;
 	char hw[0] __aligned(sizeof(void *));
 };
-- 
1.7.10.4


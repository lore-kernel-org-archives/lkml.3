Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946455Ab3BHMbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 07:31:23 -0500
Received: from mga11.intel.com ([192.55.52.93]:5359 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946393Ab3BHM2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 07:28:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,629,1355126400"; 
   d="scan'208";a="284477762"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org, sameo@linux.intel.com
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 04/11 V2] mei: bus: Add bus related structures to mei_cl
Date: Fri,  8 Feb 2013 14:28:17 +0200
Message-Id: <1360326504-17041-5-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1360326504-17041-1-git-send-email-tomas.winkler@intel.com>
References: <1360326504-17041-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

We keep track of all MEI bus clients through a specific linked list.
We also have a mei_bus_client instance in the mei_cl structure.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/bus.c     |   47 +++++++++++++++++++++++++++++++------------
 drivers/misc/mei/client.c  |    1 +
 drivers/misc/mei/init.c    |    1 +
 drivers/misc/mei/mei_dev.h |    8 +++++++
 4 files changed, 44 insertions(+), 13 deletions(-)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 97e1988..2e12928 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -119,16 +119,37 @@ static struct device_type mei_client_type = {
 	.release	= mei_client_dev_release,
 };
 
+static struct mei_cl *mei_bus_find_mei_cl_by_uuid(struct mei_device *mei_dev,
+						uuid_le uuid)
+{
+	struct mei_cl *cl, *next;
+
+	list_for_each_entry_safe(cl, next,
+				 &mei_dev->bus_client_list, bus_client_link) {
+		if (!uuid_le_cmp(uuid, cl->bus_client_uuid))
+			return cl;
+	}
+
+	return NULL;
+}
+
 struct mei_bus_client *mei_add_device(struct mei_device *mei_dev,
 				      uuid_le uuid, char *name)
 {
 	struct mei_bus_client *client;
+	struct mei_cl *cl;
 	int status;
 
+	cl = mei_bus_find_mei_cl_by_uuid(mei_dev, uuid);
+	if (cl == NULL)
+		return NULL;
+
 	client = kzalloc(sizeof(struct mei_bus_client), GFP_KERNEL);
 	if (!client)
 		return NULL;
 
+	client->cl = cl;
+
 	client->mei_dev = mei_dev;
 	client->uuid = uuid;
 	strlcpy(client->name, name, sizeof(client->name));
@@ -140,19 +161,17 @@ struct mei_bus_client *mei_add_device(struct mei_device *mei_dev,
 	dev_set_name(&client->dev, "%s", client->name);
 
 	status = device_register(&client->dev);
-	if (status)
-		goto out_err;
+	if (status) {
+		kfree(client);
+		dev_err(client->dev.parent, "Failed to register MEI client\n");
+		return NULL;
+	}
+
+	cl->client = client;
 
 	dev_dbg(&client->dev, "client %s registered\n", client->name);
 
 	return client;
-
-out_err:
-	dev_err(client->dev.parent, "Failed to register MEI client\n");
-
-	kfree(client);
-
-	return NULL;
 }
 EXPORT_SYMBOL(mei_add_device);
 
@@ -353,9 +372,10 @@ out:
 
 int mei_bus_send(struct mei_bus_client *client, u8 *buf, size_t length)
 {
-	struct mei_cl *cl = NULL;
+	struct mei_cl *cl = client->cl;
 
-	/* TODO: hook between mei_bus_client and mei_cl */
+	if (cl == NULL)
+		return -ENODEV;
 
 	if (client->send)
 		return client->send(client, buf, length);
@@ -366,9 +386,10 @@ EXPORT_SYMBOL(mei_bus_send);
 
 int mei_bus_recv(struct mei_bus_client *client, u8 *buf, size_t length)
 {
-	struct mei_cl *cl = NULL;
+	struct mei_cl *cl =  client->cl;
 
-	/* TODO: hook between mei_bus_client and mei_cl */
+	if (cl == NULL)
+		return -ENODEV;
 
 	if (client->recv)
 		return client->recv(client, buf, length);
diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 1569afe..5724499 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -216,6 +216,7 @@ void mei_cl_init(struct mei_cl *cl, struct mei_device *dev)
 	init_waitqueue_head(&cl->rx_wait);
 	init_waitqueue_head(&cl->tx_wait);
 	INIT_LIST_HEAD(&cl->link);
+	INIT_LIST_HEAD(&cl->bus_client_link);
 	cl->reading_state = MEI_IDLE;
 	cl->writing_state = MEI_IDLE;
 	cl->dev = dev;
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 6ec5301..b812d56 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -46,6 +46,7 @@ void mei_device_init(struct mei_device *dev)
 {
 	/* setup our list array */
 	INIT_LIST_HEAD(&dev->file_list);
+	INIT_LIST_HEAD(&dev->bus_client_list);
 	mutex_init(&dev->device_lock);
 	init_waitqueue_head(&dev->wait_recvd_msg);
 	init_waitqueue_head(&dev->wait_stop_wd);
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index e95d6e1..4e1daf2 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -210,6 +210,11 @@ struct mei_cl {
 	enum mei_file_transaction_states writing_state;
 	int sm_state;
 	struct mei_cl_cb *read_cb;
+
+	/* MEI bus data */
+	struct mei_bus_client *client;
+	struct list_head bus_client_link;
+	uuid_le bus_client_uuid;
 };
 
 /** struct mei_hw_ops
@@ -404,6 +409,9 @@ struct mei_device {
 
 	struct work_struct init_work;
 
+	/* List of bus clients */
+	struct list_head bus_client_list;
+
 	const struct mei_hw_ops *ops;
 	char hw[0] __aligned(sizeof(void *));
 };
-- 
1.7.4.4


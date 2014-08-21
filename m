Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbaHULh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:37:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:4850 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547AbaHULbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:31:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,908,1400050800"; 
   d="scan'208";a="587969480"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 04/14] mei: use list for me clients book keeping
Date: Thu, 21 Aug 2014 14:29:13 +0300
Message-Id: <1408620563-25834-4-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408620563-25834-1-git-send-email-tomas.winkler@intel.com>
References: <1408620563-25834-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To support dynamic addition/remove of clients
it is more convenient to use list instead of
static array

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/client.c  |  34 ++++++-------
 drivers/misc/mei/debugfs.c |  19 ++++----
 drivers/misc/mei/hbm.c     | 116 +++++++++++++++++----------------------------
 drivers/misc/mei/init.c    |   1 +
 drivers/misc/mei/mei_dev.h |   4 +-
 5 files changed, 71 insertions(+), 103 deletions(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 2d5f305..b1d72e6 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -38,12 +38,11 @@
 struct mei_me_client *mei_me_cl_by_uuid(const struct mei_device *dev,
 					const uuid_le *uuid)
 {
-	int i;
+	struct mei_me_client *me_cl;
 
-	for (i = 0; i < dev->me_clients_num; ++i)
-		if (uuid_le_cmp(*uuid,
-				dev->me_clients[i].props.protocol_name) == 0)
-			return &dev->me_clients[i];
+	list_for_each_entry(me_cl, &dev->me_clients, list)
+		if (uuid_le_cmp(*uuid, me_cl->props.protocol_name) == 0)
+			return me_cl;
 
 	return NULL;
 }
@@ -62,12 +61,12 @@ struct mei_me_client *mei_me_cl_by_uuid(const struct mei_device *dev,
 
 struct mei_me_client *mei_me_cl_by_id(struct mei_device *dev, u8 client_id)
 {
-	int i;
 
-	for (i = 0; i < dev->me_clients_num; i++)
-		if (dev->me_clients[i].client_id == client_id)
-			return &dev->me_clients[i];
+	struct mei_me_client *me_cl;
 
+	list_for_each_entry(me_cl, &dev->me_clients, list)
+		if (me_cl->client_id == client_id)
+			return me_cl;
 	return NULL;
 }
 
@@ -396,19 +395,19 @@ void mei_host_client_init(struct work_struct *work)
 {
 	struct mei_device *dev = container_of(work,
 					      struct mei_device, init_work);
-	struct mei_client_properties *client_props;
-	int i;
+	struct mei_me_client *me_cl;
+	struct mei_client_properties *props;
 
 	mutex_lock(&dev->device_lock);
 
-	for (i = 0; i < dev->me_clients_num; i++) {
-		client_props = &dev->me_clients[i].props;
+	list_for_each_entry(me_cl, &dev->me_clients, list) {
+		props = &me_cl->props;
 
-		if (!uuid_le_cmp(client_props->protocol_name, mei_amthif_guid))
+		if (!uuid_le_cmp(props->protocol_name, mei_amthif_guid))
 			mei_amthif_host_init(dev);
-		else if (!uuid_le_cmp(client_props->protocol_name, mei_wd_guid))
+		else if (!uuid_le_cmp(props->protocol_name, mei_wd_guid))
 			mei_wd_host_init(dev);
-		else if (!uuid_le_cmp(client_props->protocol_name, mei_nfc_guid))
+		else if (!uuid_le_cmp(props->protocol_name, mei_nfc_guid))
 			mei_nfc_host_init(dev);
 
 	}
@@ -653,9 +652,6 @@ int mei_cl_flow_ctrl_creds(struct mei_cl *cl)
 
 	dev = cl->dev;
 
-	if (!dev->me_clients_num)
-		return 0;
-
 	if (cl->mei_flow_ctrl_creds > 0)
 		return 1;
 
diff --git a/drivers/misc/mei/debugfs.c b/drivers/misc/mei/debugfs.c
index ced5b77..3b03288 100644
--- a/drivers/misc/mei/debugfs.c
+++ b/drivers/misc/mei/debugfs.c
@@ -28,10 +28,10 @@ static ssize_t mei_dbgfs_read_meclients(struct file *fp, char __user *ubuf,
 					size_t cnt, loff_t *ppos)
 {
 	struct mei_device *dev = fp->private_data;
-	struct mei_me_client *cl;
+	struct mei_me_client *me_cl;
 	const size_t bufsz = 1024;
 	char *buf = kzalloc(bufsz, GFP_KERNEL);
-	int i;
+	int i = 0;
 	int pos = 0;
 	int ret;
 
@@ -47,20 +47,19 @@ static ssize_t mei_dbgfs_read_meclients(struct file *fp, char __user *ubuf,
 	if (dev->dev_state != MEI_DEV_ENABLED)
 		goto out;
 
-	for (i = 0; i < dev->me_clients_num; i++) {
-		cl = &dev->me_clients[i];
+	list_for_each_entry(me_cl, &dev->me_clients, list) {
 
 		/* skip me clients that cannot be connected */
-		if (cl->props.max_number_of_connections == 0)
+		if (me_cl->props.max_number_of_connections == 0)
 			continue;
 
 		pos += scnprintf(buf + pos, bufsz - pos,
 			"%2d|%2d|%4d|%pUl|%3d|%7d|\n",
-			i, cl->client_id,
-			cl->props.fixed_address,
-			&cl->props.protocol_name,
-			cl->props.max_number_of_connections,
-			cl->props.max_msg_length);
+			i++, me_cl->client_id,
+			me_cl->props.fixed_address,
+			&me_cl->props.protocol_name,
+			me_cl->props.max_number_of_connections,
+			me_cl->props.max_msg_length);
 	}
 out:
 	mutex_unlock(&dev->device_lock);
diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 0b21675..45659de 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -77,51 +77,20 @@ void mei_hbm_idle(struct mei_device *dev)
  */
 void mei_hbm_reset(struct mei_device *dev)
 {
-	dev->me_clients_num = 0;
+	struct mei_me_client *me_cl, *next;
+
 	dev->me_client_presentation_num = 0;
 	dev->me_client_index = 0;
 
-	kfree(dev->me_clients);
-	dev->me_clients = NULL;
+	list_for_each_entry_safe(me_cl, next, &dev->me_clients, list) {
+		list_del(&me_cl->list);
+		kfree(me_cl);
+	}
 
 	mei_hbm_idle(dev);
 }
 
 /**
- * mei_hbm_me_cl_allocate - allocates storage for me clients
- *
- * @dev: the device structure
- *
- * returns 0 on success -ENOMEM on allocation failure
- */
-static int mei_hbm_me_cl_allocate(struct mei_device *dev)
-{
-	struct mei_me_client *clients;
-	int b;
-
-	mei_hbm_reset(dev);
-
-	/* count how many ME clients we have */
-	for_each_set_bit(b, dev->me_clients_map, MEI_CLIENTS_MAX)
-		dev->me_clients_num++;
-
-	if (dev->me_clients_num == 0)
-		return 0;
-
-	dev_dbg(&dev->pdev->dev, "memory allocation for ME clients size=%ld.\n",
-		dev->me_clients_num * sizeof(struct mei_me_client));
-	/* allocate storage for ME clients representation */
-	clients = kcalloc(dev->me_clients_num,
-			sizeof(struct mei_me_client), GFP_KERNEL);
-	if (!clients) {
-		dev_err(&dev->pdev->dev, "memory allocation for ME clients failed.\n");
-		return -ENOMEM;
-	}
-	dev->me_clients = clients;
-	return 0;
-}
-
-/**
  * mei_hbm_cl_hdr - construct client hbm header
  *
  * @cl: client
@@ -213,6 +182,8 @@ int mei_hbm_start_req(struct mei_device *dev)
 	const size_t len = sizeof(struct hbm_host_version_request);
 	int ret;
 
+	mei_hbm_reset(dev);
+
 	mei_hbm_hdr(mei_hdr, len);
 
 	/* host start message */
@@ -267,6 +238,32 @@ static int mei_hbm_enum_clients_req(struct mei_device *dev)
 	return 0;
 }
 
+/*
+ * mei_hbm_me_cl_add - add new me client to the list
+ *
+ * @dev: the device structure
+ * @res: hbm property response
+ *
+ * returns 0 on success and -ENOMEM on allocation failure
+ */
+
+static int mei_hbm_me_cl_add(struct mei_device *dev,
+			     struct hbm_props_response *res)
+{
+	struct mei_me_client *me_cl;
+
+	me_cl = kzalloc(sizeof(struct mei_me_client), GFP_KERNEL);
+	if (!me_cl)
+		return -ENOMEM;
+
+	me_cl->props = res->client_properties;
+	me_cl->client_id = res->me_addr;
+	me_cl->mei_flow_ctrl_creds = 0;
+
+	list_add(&me_cl->list, &dev->me_clients);
+	return 0;
+}
+
 /**
  * mei_hbm_prop_req - request property for a single client
  *
@@ -282,11 +279,8 @@ static int mei_hbm_prop_req(struct mei_device *dev)
 	struct hbm_props_request *prop_req;
 	const size_t len = sizeof(struct hbm_props_request);
 	unsigned long next_client_index;
-	unsigned long client_num;
 	int ret;
 
-	client_num = dev->me_client_presentation_num;
-
 	next_client_index = find_next_bit(dev->me_clients_map, MEI_CLIENTS_MAX,
 					  dev->me_client_index);
 
@@ -298,15 +292,11 @@ static int mei_hbm_prop_req(struct mei_device *dev)
 		return 0;
 	}
 
-	dev->me_clients[client_num].client_id = next_client_index;
-	dev->me_clients[client_num].mei_flow_ctrl_creds = 0;
-
 	mei_hbm_hdr(mei_hdr, len);
 	prop_req = (struct hbm_props_request *)dev->wr_msg.data;
 
 	memset(prop_req, 0, sizeof(struct hbm_props_request));
 
-
 	prop_req->hbm_cmd = HOST_CLIENT_PROPERTIES_REQ_CMD;
 	prop_req->me_addr = next_client_index;
 
@@ -441,11 +431,10 @@ static void mei_hbm_cl_flow_control_res(struct mei_device *dev,
 	list_for_each_entry(cl, &dev->file_list, link) {
 		if (mei_hbm_cl_addr_equal(cl, flow_control)) {
 			cl->mei_flow_ctrl_creds++;
-			dev_dbg(&dev->pdev->dev, "flow ctrl msg for host %d ME %d.\n",
-				flow_control->host_addr, flow_control->me_addr);
-			dev_dbg(&dev->pdev->dev, "flow control credentials = %d.\n",
-				    cl->mei_flow_ctrl_creds);
-				break;
+			dev_dbg(&dev->pdev->dev, "flow ctrl msg for host %d ME %d creds %d.\n",
+				flow_control->host_addr, flow_control->me_addr,
+				cl->mei_flow_ctrl_creds);
+			break;
 		}
 	}
 }
@@ -641,7 +630,6 @@ bool mei_hbm_version_is_supported(struct mei_device *dev)
 int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 {
 	struct mei_bus_message *mei_msg;
-	struct mei_me_client *me_client;
 	struct hbm_host_version_response *version_res;
 	struct hbm_client_connect_response *connect_res;
 	struct hbm_client_connect_response *disconnect_res;
@@ -763,13 +751,14 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 
 		dev->init_clients_timer = 0;
 
-		if (dev->me_clients == NULL) {
-			dev_err(&dev->pdev->dev, "hbm: properties response: mei_clients not allocated\n");
+		if (dev->dev_state != MEI_DEV_INIT_CLIENTS ||
+		    dev->hbm_state != MEI_HBM_CLIENT_PROPERTIES) {
+			dev_err(&dev->pdev->dev, "hbm: properties response: state mismatch, [%d, %d]\n",
+				dev->dev_state, dev->hbm_state);
 			return -EPROTO;
 		}
 
 		props_res = (struct hbm_props_response *)mei_msg;
-		me_client = &dev->me_clients[dev->me_client_presentation_num];
 
 		if (props_res->status) {
 			dev_err(&dev->pdev->dev, "hbm: properties response: wrong status = %d\n",
@@ -777,20 +766,8 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 			return -EPROTO;
 		}
 
-		if (me_client->client_id != props_res->me_addr) {
-			dev_err(&dev->pdev->dev, "hbm: properties response: address mismatch %d ?= %d\n",
-				me_client->client_id, props_res->me_addr);
-			return -EPROTO;
-		}
+		mei_hbm_me_cl_add(dev, props_res);
 
-		if (dev->dev_state != MEI_DEV_INIT_CLIENTS ||
-		    dev->hbm_state != MEI_HBM_CLIENT_PROPERTIES) {
-			dev_err(&dev->pdev->dev, "hbm: properties response: state mismatch, [%d, %d]\n",
-				dev->dev_state, dev->hbm_state);
-			return -EPROTO;
-		}
-
-		me_client->props = props_res->client_properties;
 		dev->me_client_index++;
 		dev->me_client_presentation_num++;
 
@@ -809,7 +786,7 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 		BUILD_BUG_ON(sizeof(dev->me_clients_map)
 				< sizeof(enum_res->valid_addresses));
 		memcpy(dev->me_clients_map, enum_res->valid_addresses,
-			sizeof(enum_res->valid_addresses));
+				sizeof(enum_res->valid_addresses));
 
 		if (dev->dev_state != MEI_DEV_INIT_CLIENTS ||
 		    dev->hbm_state != MEI_HBM_ENUM_CLIENTS) {
@@ -818,11 +795,6 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 			return -EPROTO;
 		}
 
-		if (mei_hbm_me_cl_allocate(dev)) {
-			dev_err(&dev->pdev->dev, "hbm: enumeration response: cannot allocate clients array\n");
-			return -ENOMEM;
-		}
-
 		dev->hbm_state = MEI_HBM_CLIENT_PROPERTIES;
 
 		/* first property request */
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 0069292..73ccbb6 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -356,6 +356,7 @@ void mei_device_init(struct mei_device *dev, const struct mei_cfg *cfg)
 	/* setup our list array */
 	INIT_LIST_HEAD(&dev->file_list);
 	INIT_LIST_HEAD(&dev->device_list);
+	INIT_LIST_HEAD(&dev->me_clients);
 	mutex_init(&dev->device_lock);
 	init_waitqueue_head(&dev->wait_hw_ready);
 	init_waitqueue_head(&dev->wait_pg);
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 0b0d613..76d8aa3 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -175,6 +175,7 @@ struct mei_fw_status {
  * @mei_flow_ctrl_creds - flow control credits
  */
 struct mei_me_client {
+	struct list_head list;
 	struct mei_client_properties props;
 	u8 client_id;
 	u8 mei_flow_ctrl_creds;
@@ -478,10 +479,9 @@ struct mei_device {
 
 	struct hbm_version version;
 
-	struct mei_me_client *me_clients; /* Note: memory has to be allocated */
+	struct list_head me_clients;
 	DECLARE_BITMAP(me_clients_map, MEI_CLIENTS_MAX);
 	DECLARE_BITMAP(host_clients_map, MEI_CLIENTS_MAX);
-	unsigned long me_clients_num;
 	unsigned long me_client_presentation_num;
 	unsigned long me_client_index;
 
-- 
1.9.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbaHULh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:37:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:4829 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640AbaHULa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:30:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,908,1400050800"; 
   d="scan'208";a="587969472"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 03/14] mei: me_client lookup function to return me_client object
Date: Thu, 21 Aug 2014 14:29:12 +0300
Message-Id: <1408620563-25834-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408620563-25834-1-git-send-email-tomas.winkler@intel.com>
References: <1408620563-25834-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to support dynamic addition/removal of me clients we cannot
It is incontinent to use static array and we can use list.
As the first step we change the lookup function to return
me client address instead of the index.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c | 29 +++++++++++------------------
 drivers/misc/mei/bus.c    | 10 +++++-----
 drivers/misc/mei/client.c | 43 ++++++++++++++++++++-----------------------
 drivers/misc/mei/client.h |  5 +++--
 drivers/misc/mei/hbm.c    | 23 +++++++++--------------
 drivers/misc/mei/main.c   | 30 ++++++++++++++----------------
 drivers/misc/mei/nfc.c    | 15 ++++++++-------
 drivers/misc/mei/wd.c     |  8 ++++----
 8 files changed, 74 insertions(+), 89 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index ab60959..c1fc6dd 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -68,27 +68,26 @@ void mei_amthif_reset_params(struct mei_device *dev)
 int mei_amthif_host_init(struct mei_device *dev)
 {
 	struct mei_cl *cl = &dev->iamthif_cl;
+	struct mei_me_client *me_cl;
 	unsigned char *msg_buf;
-	int ret, i;
+	int ret;
 
 	dev->iamthif_state = MEI_IAMTHIF_IDLE;
 
 	mei_cl_init(cl, dev);
 
-	i = mei_me_cl_by_uuid(dev, &mei_amthif_guid);
-	if (i < 0) {
-		dev_info(&dev->pdev->dev,
-			"amthif: failed to find the client %d\n", i);
+	me_cl = mei_me_cl_by_uuid(dev, &mei_amthif_guid);
+	if (!me_cl) {
+		dev_info(&dev->pdev->dev, "amthif: failed to find the client");
 		return -ENOTTY;
 	}
 
-	cl->me_client_id = dev->me_clients[i].client_id;
+	cl->me_client_id = me_cl->client_id;
 
 	/* Assign iamthif_mtu to the value received from ME  */
 
-	dev->iamthif_mtu = dev->me_clients[i].props.max_msg_length;
-	dev_dbg(&dev->pdev->dev, "IAMTHIF_MTU = %d\n",
-			dev->me_clients[i].props.max_msg_length);
+	dev->iamthif_mtu = me_cl->props.max_msg_length;
+	dev_dbg(&dev->pdev->dev, "IAMTHIF_MTU = %d\n", dev->iamthif_mtu);
 
 	kfree(dev->iamthif_msg_buf);
 	dev->iamthif_msg_buf = NULL;
@@ -157,12 +156,11 @@ struct mei_cl_cb *mei_amthif_find_read_list_entry(struct mei_device *dev,
 int mei_amthif_read(struct mei_device *dev, struct file *file,
 	       char __user *ubuf, size_t length, loff_t *offset)
 {
-	int rets;
-	int wait_ret;
-	struct mei_cl_cb *cb = NULL;
 	struct mei_cl *cl = file->private_data;
+	struct mei_cl_cb *cb;
 	unsigned long timeout;
-	int i;
+	int rets;
+	int wait_ret;
 
 	/* Only possible if we are in timeout */
 	if (!cl) {
@@ -170,11 +168,6 @@ int mei_amthif_read(struct mei_device *dev, struct file *file,
 		return -ETIME;
 	}
 
-	i = mei_me_cl_by_id(dev, dev->iamthif_cl.me_client_id);
-	if (i < 0) {
-		dev_dbg(&dev->pdev->dev, "amthif client not found.\n");
-		return -ENOTTY;
-	}
 	dev_dbg(&dev->pdev->dev, "checking amthif data\n");
 	cb = mei_amthif_find_read_list_entry(dev, file);
 
diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 0e993ef..c829676 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -229,8 +229,8 @@ static int ___mei_cl_send(struct mei_cl *cl, u8 *buf, size_t length,
 			bool blocking)
 {
 	struct mei_device *dev;
+	struct mei_me_client *me_cl;
 	struct mei_cl_cb *cb;
-	int id;
 	int rets;
 
 	if (WARN_ON(!cl || !cl->dev))
@@ -242,11 +242,11 @@ static int ___mei_cl_send(struct mei_cl *cl, u8 *buf, size_t length,
 		return -ENODEV;
 
 	/* Check if we have an ME client device */
-	id = mei_me_cl_by_id(dev, cl->me_client_id);
-	if (id < 0)
-		return id;
+	me_cl = mei_me_cl_by_id(dev, cl->me_client_id);
+	if (!me_cl)
+		return -ENOTTY;
 
-	if (length > dev->me_clients[id].props.max_msg_length)
+	if (length > me_cl->props.max_msg_length)
 		return -EFBIG;
 
 	cb = mei_io_cb_init(cl, NULL);
diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index a90052e..2d5f305 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -33,18 +33,19 @@
  *
  * Locking: called under "dev->device_lock" lock
  *
- * returns me client index or -ENOENT if not found
+ * returns me client or NULL if not found
  */
-int mei_me_cl_by_uuid(const struct mei_device *dev, const uuid_le *uuid)
+struct mei_me_client *mei_me_cl_by_uuid(const struct mei_device *dev,
+					const uuid_le *uuid)
 {
 	int i;
 
 	for (i = 0; i < dev->me_clients_num; ++i)
 		if (uuid_le_cmp(*uuid,
 				dev->me_clients[i].props.protocol_name) == 0)
-			return i;
+			return &dev->me_clients[i];
 
-	return -ENOENT;
+	return NULL;
 }
 
 
@@ -56,18 +57,18 @@ int mei_me_cl_by_uuid(const struct mei_device *dev, const uuid_le *uuid)
  *
  * Locking: called under "dev->device_lock" lock
  *
- * returns index on success, -ENOENT on failure.
+ * returns me client or NULL if not found
  */
 
-int mei_me_cl_by_id(struct mei_device *dev, u8 client_id)
+struct mei_me_client *mei_me_cl_by_id(struct mei_device *dev, u8 client_id)
 {
 	int i;
 
 	for (i = 0; i < dev->me_clients_num; i++)
 		if (dev->me_clients[i].client_id == client_id)
-			return i;
+			return &dev->me_clients[i];
 
-	return -ENOENT;
+	return NULL;
 }
 
 
@@ -646,7 +647,6 @@ int mei_cl_flow_ctrl_creds(struct mei_cl *cl)
 {
 	struct mei_device *dev;
 	struct mei_me_client *me_cl;
-	int id;
 
 	if (WARN_ON(!cl || !cl->dev))
 		return -EINVAL;
@@ -659,13 +659,12 @@ int mei_cl_flow_ctrl_creds(struct mei_cl *cl)
 	if (cl->mei_flow_ctrl_creds > 0)
 		return 1;
 
-	id = mei_me_cl_by_id(dev, cl->me_client_id);
-	if (id < 0) {
+	me_cl = mei_me_cl_by_id(dev, cl->me_client_id);
+	if (!me_cl) {
 		cl_err(dev, cl, "no such me client %d\n", cl->me_client_id);
-		return id;
+		return -ENOENT;
 	}
 
-	me_cl = &dev->me_clients[id];
 	if (me_cl->mei_flow_ctrl_creds) {
 		if (WARN_ON(me_cl->props.single_recv_buf == 0))
 			return -EINVAL;
@@ -688,21 +687,19 @@ int mei_cl_flow_ctrl_reduce(struct mei_cl *cl)
 {
 	struct mei_device *dev;
 	struct mei_me_client *me_cl;
-	int id;
 
 	if (WARN_ON(!cl || !cl->dev))
 		return -EINVAL;
 
 	dev = cl->dev;
 
-	id = mei_me_cl_by_id(dev, cl->me_client_id);
-	if (id < 0) {
+	me_cl = mei_me_cl_by_id(dev, cl->me_client_id);
+	if (!me_cl) {
 		cl_err(dev, cl, "no such me client %d\n", cl->me_client_id);
-		return id;
+		return -ENOENT;
 	}
 
-	me_cl = &dev->me_clients[id];
-	if (me_cl->props.single_recv_buf != 0) {
+	if (me_cl->props.single_recv_buf) {
 		if (WARN_ON(me_cl->mei_flow_ctrl_creds <= 0))
 			return -EINVAL;
 		me_cl->mei_flow_ctrl_creds--;
@@ -725,8 +722,8 @@ int mei_cl_read_start(struct mei_cl *cl, size_t length)
 {
 	struct mei_device *dev;
 	struct mei_cl_cb *cb;
+	struct mei_me_client *me_cl;
 	int rets;
-	int i;
 
 	if (WARN_ON(!cl || !cl->dev))
 		return -ENODEV;
@@ -740,8 +737,8 @@ int mei_cl_read_start(struct mei_cl *cl, size_t length)
 		cl_dbg(dev, cl, "read is pending.\n");
 		return -EBUSY;
 	}
-	i = mei_me_cl_by_id(dev, cl->me_client_id);
-	if (i < 0) {
+	me_cl = mei_me_cl_by_id(dev, cl->me_client_id);
+	if (!me_cl) {
 		cl_err(dev, cl, "no such me client %d\n", cl->me_client_id);
 		return  -ENOTTY;
 	}
@@ -760,7 +757,7 @@ int mei_cl_read_start(struct mei_cl *cl, size_t length)
 	}
 
 	/* always allocate at least client max message */
-	length = max_t(size_t, length, dev->me_clients[i].props.max_msg_length);
+	length = max_t(size_t, length, me_cl->props.max_msg_length);
 	rets = mei_io_cb_alloc_resp_buf(cb, length);
 	if (rets)
 		goto out;
diff --git a/drivers/misc/mei/client.h b/drivers/misc/mei/client.h
index bf2b0b1..ddb95b2 100644
--- a/drivers/misc/mei/client.h
+++ b/drivers/misc/mei/client.h
@@ -24,8 +24,9 @@
 
 #include "mei_dev.h"
 
-int mei_me_cl_by_uuid(const struct mei_device *dev, const uuid_le *cuuid);
-int mei_me_cl_by_id(struct mei_device *dev, u8 client_id);
+struct mei_me_client *mei_me_cl_by_uuid(const struct mei_device *dev,
+					const uuid_le *cuuid);
+struct mei_me_client *mei_me_cl_by_id(struct mei_device *dev, u8 client_id);
 
 /*
  * MEI IO Functions
diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 2b4ea16..0b21675 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -402,25 +402,20 @@ static int mei_hbm_add_single_flow_creds(struct mei_device *dev,
 				  struct hbm_flow_control *flow)
 {
 	struct mei_me_client *me_cl;
-	int id;
 
-	id = mei_me_cl_by_id(dev, flow->me_addr);
-	if (id < 0) {
+	me_cl = mei_me_cl_by_id(dev, flow->me_addr);
+	if (!me_cl) {
 		dev_err(&dev->pdev->dev, "no such me client %d\n",
 			flow->me_addr);
-		return id;
+		return -ENOENT;
 	}
 
-	me_cl = &dev->me_clients[id];
-	if (me_cl->props.single_recv_buf) {
-		me_cl->mei_flow_ctrl_creds++;
-		dev_dbg(&dev->pdev->dev, "recv flow ctrl msg ME %d (single).\n",
-		    flow->me_addr);
-		dev_dbg(&dev->pdev->dev, "flow control credentials =%d.\n",
-		    me_cl->mei_flow_ctrl_creds);
-	} else {
-		BUG();	/* error in flow control */
-	}
+	if (WARN_ON(me_cl->props.single_recv_buf == 0))
+		return -EINVAL;
+
+	me_cl->mei_flow_ctrl_creds++;
+	dev_dbg(&dev->pdev->dev, "recv flow ctrl msg ME %d (single) creds = %d.\n",
+	    flow->me_addr, me_cl->mei_flow_ctrl_creds);
 
 	return 0;
 }
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 401a3d5..a65b7cc 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -303,11 +303,11 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 			 size_t length, loff_t *offset)
 {
 	struct mei_cl *cl = file->private_data;
+	struct mei_me_client *me_cl;
 	struct mei_cl_cb *write_cb = NULL;
 	struct mei_device *dev;
 	unsigned long timeout = 0;
 	int rets;
-	int id;
 
 	if (WARN_ON(!cl || !cl->dev))
 		return -ENODEV;
@@ -321,8 +321,8 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 		goto out;
 	}
 
-	id = mei_me_cl_by_id(dev, cl->me_client_id);
-	if (id < 0) {
+	me_cl = mei_me_cl_by_id(dev, cl->me_client_id);
+	if (!me_cl) {
 		rets = -ENOTTY;
 		goto out;
 	}
@@ -332,7 +332,7 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 		goto out;
 	}
 
-	if (length > dev->me_clients[id].props.max_msg_length) {
+	if (length > me_cl->props.max_msg_length) {
 		rets = -EFBIG;
 		goto out;
 	}
@@ -428,8 +428,8 @@ static int mei_ioctl_connect_client(struct file *file,
 {
 	struct mei_device *dev;
 	struct mei_client *client;
+	struct mei_me_client *me_cl;
 	struct mei_cl *cl;
-	int i;
 	int rets;
 
 	cl = file->private_data;
@@ -450,22 +450,22 @@ static int mei_ioctl_connect_client(struct file *file,
 	}
 
 	/* find ME client we're trying to connect to */
-	i = mei_me_cl_by_uuid(dev, &data->in_client_uuid);
-	if (i < 0 || dev->me_clients[i].props.fixed_address) {
+	me_cl = mei_me_cl_by_uuid(dev, &data->in_client_uuid);
+	if (!me_cl || me_cl->props.fixed_address) {
 		dev_dbg(&dev->pdev->dev, "Cannot connect to FW Client UUID = %pUl\n",
 				&data->in_client_uuid);
 		rets = -ENOTTY;
 		goto end;
 	}
 
-	cl->me_client_id = dev->me_clients[i].client_id;
+	cl->me_client_id = me_cl->client_id;
 
 	dev_dbg(&dev->pdev->dev, "Connect to FW Client ID = %d\n",
 			cl->me_client_id);
 	dev_dbg(&dev->pdev->dev, "FW Client - Protocol Version = %d\n",
-			dev->me_clients[i].props.protocol_version);
+			me_cl->props.protocol_version);
 	dev_dbg(&dev->pdev->dev, "FW Client - Max Msg Len = %d\n",
-			dev->me_clients[i].props.max_msg_length);
+			me_cl->props.max_msg_length);
 
 	/* if we're connecting to amthif client then we will use the
 	 * existing connection
@@ -484,10 +484,8 @@ static int mei_ioctl_connect_client(struct file *file,
 		file->private_data = &dev->iamthif_cl;
 
 		client = &data->out_client_properties;
-		client->max_msg_length =
-			dev->me_clients[i].props.max_msg_length;
-		client->protocol_version =
-			dev->me_clients[i].props.protocol_version;
+		client->max_msg_length = me_cl->props.max_msg_length;
+		client->protocol_version = me_cl->props.protocol_version;
 		rets = dev->iamthif_cl.status;
 
 		goto end;
@@ -496,8 +494,8 @@ static int mei_ioctl_connect_client(struct file *file,
 
 	/* prepare the output buffer */
 	client = &data->out_client_properties;
-	client->max_msg_length = dev->me_clients[i].props.max_msg_length;
-	client->protocol_version = dev->me_clients[i].props.protocol_version;
+	client->max_msg_length = me_cl->props.max_msg_length;
+	client->protocol_version = me_cl->props.protocol_version;
 	dev_dbg(&dev->pdev->dev, "Can connect?\n");
 
 
diff --git a/drivers/misc/mei/nfc.c b/drivers/misc/mei/nfc.c
index 5ccc23b..964b4c6 100644
--- a/drivers/misc/mei/nfc.c
+++ b/drivers/misc/mei/nfc.c
@@ -480,7 +480,8 @@ int mei_nfc_host_init(struct mei_device *dev)
 {
 	struct mei_nfc_dev *ndev = &nfc_dev;
 	struct mei_cl *cl_info, *cl = NULL;
-	int i, ret;
+	struct mei_me_client *me_cl;
+	int ret;
 
 	/* already initialized */
 	if (ndev->cl_info)
@@ -498,14 +499,14 @@ int mei_nfc_host_init(struct mei_device *dev)
 	}
 
 	/* check for valid client id */
-	i = mei_me_cl_by_uuid(dev, &mei_nfc_info_guid);
-	if (i < 0) {
+	me_cl = mei_me_cl_by_uuid(dev, &mei_nfc_info_guid);
+	if (!me_cl) {
 		dev_info(&dev->pdev->dev, "nfc: failed to find the client\n");
 		ret = -ENOTTY;
 		goto err;
 	}
 
-	cl_info->me_client_id = dev->me_clients[i].client_id;
+	cl_info->me_client_id = me_cl->client_id;
 
 	ret = mei_cl_link(cl_info, MEI_HOST_CLIENT_ID_ANY);
 	if (ret)
@@ -516,14 +517,14 @@ int mei_nfc_host_init(struct mei_device *dev)
 	list_add_tail(&cl_info->device_link, &dev->device_list);
 
 	/* check for valid client id */
-	i = mei_me_cl_by_uuid(dev, &mei_nfc_guid);
-	if (i < 0) {
+	me_cl = mei_me_cl_by_uuid(dev, &mei_nfc_guid);
+	if (!me_cl) {
 		dev_info(&dev->pdev->dev, "nfc: failed to find the client\n");
 		ret = -ENOTTY;
 		goto err;
 	}
 
-	cl->me_client_id = dev->me_clients[i].client_id;
+	cl->me_client_id = me_cl->client_id;
 
 	ret = mei_cl_link(cl, MEI_HOST_CLIENT_ID_ANY);
 	if (ret)
diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index a84a664..8b241ee 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -59,7 +59,7 @@ static void mei_wd_set_start_timeout(struct mei_device *dev, u16 timeout)
 int mei_wd_host_init(struct mei_device *dev)
 {
 	struct mei_cl *cl = &dev->wd_cl;
-	int id;
+	struct mei_me_client *me_cl;
 	int ret;
 
 	mei_cl_init(cl, dev);
@@ -69,13 +69,13 @@ int mei_wd_host_init(struct mei_device *dev)
 
 
 	/* check for valid client id */
-	id = mei_me_cl_by_uuid(dev, &mei_wd_guid);
-	if (id < 0) {
+	me_cl = mei_me_cl_by_uuid(dev, &mei_wd_guid);
+	if (!me_cl) {
 		dev_info(&dev->pdev->dev, "wd: failed to find the client\n");
 		return -ENOTTY;
 	}
 
-	cl->me_client_id = dev->me_clients[id].client_id;
+	cl->me_client_id = me_cl->client_id;
 
 	ret = mei_cl_link(cl, MEI_WD_HOST_CLIENT_ID);
 
-- 
1.9.3


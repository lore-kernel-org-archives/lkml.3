Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbaK0MIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 07:08:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:5536 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910AbaK0MIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 07:08:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,469,1413270000"; 
   d="scan'208";a="629151502"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 3/3 V2] mei: add reference counting for me clients
Date: Thu, 27 Nov 2014 14:07:29 +0200
Message-Id: <1417090049-23219-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417090049-23219-1-git-send-email-tomas.winkler@intel.com>
References: <1417090049-23219-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To support dynamic addition and removal of
me clients we add reference counter.

Update kdoc with locking requirements.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
V2: add locking requirements to kdoc 
 drivers/misc/mei/amthif.c  |  14 +++--
 drivers/misc/mei/bus.c     |  35 ++++++-----
 drivers/misc/mei/client.c  | 152 ++++++++++++++++++++++++++++++++++++++-------
 drivers/misc/mei/client.h  |  17 +++--
 drivers/misc/mei/debugfs.c |  32 ++++++----
 drivers/misc/mei/hbm.c     |  34 +++++-----
 drivers/misc/mei/main.c    |  22 +++----
 drivers/misc/mei/mei_dev.h |   2 +
 drivers/misc/mei/nfc.c     |   2 +
 drivers/misc/mei/wd.c      |   1 +
 10 files changed, 219 insertions(+), 92 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index 79f53941779d..c4cb9a984a5f 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -97,23 +97,25 @@ int mei_amthif_host_init(struct mei_device *dev)
 	/* allocate storage for ME message buffer */
 	msg_buf = kcalloc(dev->iamthif_mtu,
 			sizeof(unsigned char), GFP_KERNEL);
-	if (!msg_buf)
-		return -ENOMEM;
+	if (!msg_buf) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	dev->iamthif_msg_buf = msg_buf;
 
 	ret = mei_cl_link(cl, MEI_IAMTHIF_HOST_CLIENT_ID);
-
 	if (ret < 0) {
-		dev_err(dev->dev,
-			"amthif: failed link client %d\n", ret);
-		return ret;
+		dev_err(dev->dev, "amthif: failed cl_link %d\n", ret);
+		goto out;
 	}
 
 	ret = mei_cl_connect(cl, NULL);
 
 	dev->iamthif_state = MEI_IAMTHIF_IDLE;
 
+out:
+	mei_me_cl_put(me_cl);
 	return ret;
 }
 
diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 31164dd14bd0..0a6d067dd1d9 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -237,33 +237,40 @@ static ssize_t ___mei_cl_send(struct mei_cl *cl, u8 *buf, size_t length,
 
 	dev = cl->dev;
 
-	if (cl->state != MEI_FILE_CONNECTED)
-		return -ENODEV;
+	mutex_lock(&dev->device_lock);
+	if (cl->state != MEI_FILE_CONNECTED) {
+		rets = -ENODEV;
+		goto out;
+	}
 
 	/* Check if we have an ME client device */
 	me_cl = mei_me_cl_by_uuid_id(dev, &cl->cl_uuid, cl->me_client_id);
-	if (!me_cl)
-		return -ENOTTY;
+	if (!me_cl) {
+		rets = -ENOTTY;
+		goto out;
+	}
 
-	if (length > me_cl->props.max_msg_length)
-		return -EFBIG;
+	if (length > me_cl->props.max_msg_length) {
+		rets = -EFBIG;
+		goto out;
+	}
 
 	cb = mei_io_cb_init(cl, NULL);
-	if (!cb)
-		return -ENOMEM;
+	if (!cb) {
+		rets = -ENOMEM;
+		goto out;
+	}
 
 	rets = mei_io_cb_alloc_req_buf(cb, length);
-	if (rets < 0) {
-		mei_io_cb_free(cb);
-		return rets;
-	}
+	if (rets < 0)
+		goto out;
 
 	memcpy(cb->request_buffer.data, buf, length);
 
-	mutex_lock(&dev->device_lock);
-
 	rets = mei_cl_write(cl, cb, blocking);
 
+out:
+	mei_me_cl_put(me_cl);
 	mutex_unlock(&dev->device_lock);
 	if (rets < 0)
 		mei_io_cb_free(cb);
diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 3e55d2aab69d..fb04bfbef9fe 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -27,7 +27,63 @@
 #include "client.h"
 
 /**
+ * mei_me_cl_init - initialize me client
+ *
+ * @me_cl: me client
+ */
+void mei_me_cl_init(struct mei_me_client *me_cl)
+{
+	INIT_LIST_HEAD(&me_cl->list);
+	kref_init(&me_cl->refcnt);
+}
+
+/**
+ * mei_me_cl_get - increases me client refcount
+ *
+ * @me_cl: me client
+ *
+ * Locking: called under "dev->device_lock" lock
+ *
+ * Return: me client or NULL
+ */
+struct mei_me_client *mei_me_cl_get(struct mei_me_client *me_cl)
+{
+	if (me_cl)
+		kref_get(&me_cl->refcnt);
+
+	return me_cl;
+}
+
+/**
+ * mei_me_cl_release - unlink and free me client
+ *
+ * Locking: called under "dev->device_lock" lock
+ *
+ * @ref: me_client refcount
+ */
+static void mei_me_cl_release(struct kref *ref)
+{
+	struct mei_me_client *me_cl =
+		container_of(ref, struct mei_me_client, refcnt);
+	list_del(&me_cl->list);
+	kfree(me_cl);
+}
+/**
+ * mei_me_cl_put - decrease me client refcount and free client if necessary
+ *
+ * Locking: called under "dev->device_lock" lock
+ *
+ * @me_cl: me client
+ */
+void mei_me_cl_put(struct mei_me_client *me_cl)
+{
+	if (me_cl)
+		kref_put(&me_cl->refcnt, mei_me_cl_release);
+}
+
+/**
  * mei_me_cl_by_uuid - locate me client by uuid
+ *	increases ref count
  *
  * @dev: mei device
  * @uuid: me client uuid
@@ -43,13 +99,14 @@ struct mei_me_client *mei_me_cl_by_uuid(const struct mei_device *dev,
 
 	list_for_each_entry(me_cl, &dev->me_clients, list)
 		if (uuid_le_cmp(*uuid, me_cl->props.protocol_name) == 0)
-			return me_cl;
+			return mei_me_cl_get(me_cl);
 
 	return NULL;
 }
 
 /**
  * mei_me_cl_by_id - locate me client by client id
+ *	increases ref count
  *
  * @dev: the device structure
  * @client_id: me client id
@@ -65,12 +122,14 @@ struct mei_me_client *mei_me_cl_by_id(struct mei_device *dev, u8 client_id)
 
 	list_for_each_entry(me_cl, &dev->me_clients, list)
 		if (me_cl->client_id == client_id)
-			return me_cl;
+			return mei_me_cl_get(me_cl);
+
 	return NULL;
 }
 
 /**
  * mei_me_cl_by_uuid_id - locate me client by client id and uuid
+ *	increases ref count
  *
  * @dev: the device structure
  * @uuid: me client uuid
@@ -88,31 +147,67 @@ struct mei_me_client *mei_me_cl_by_uuid_id(struct mei_device *dev,
 	list_for_each_entry(me_cl, &dev->me_clients, list)
 		if (uuid_le_cmp(*uuid, me_cl->props.protocol_name) == 0 &&
 		    me_cl->client_id == client_id)
-			return me_cl;
+			return mei_me_cl_get(me_cl);
+
 	return NULL;
 }
 
 /**
- * mei_me_cl_remove - remove me client matching uuid and client_id
+ * mei_me_cl_rm_by_uuid - remove all me clients matching uuid
  *
  * @dev: the device structure
  * @uuid: me client uuid
- * @client_id: me client address
+ *
+ * Locking: called under "dev->device_lock" lock
  */
-void mei_me_cl_remove(struct mei_device *dev, const uuid_le *uuid, u8 client_id)
+void mei_me_cl_rm_by_uuid(struct mei_device *dev, const uuid_le *uuid)
 {
 	struct mei_me_client *me_cl, *next;
 
+	dev_dbg(dev->dev, "remove %pUl\n", uuid);
+	list_for_each_entry_safe(me_cl, next, &dev->me_clients, list)
+		if (uuid_le_cmp(*uuid, me_cl->props.protocol_name) == 0)
+			mei_me_cl_put(me_cl);
+}
+
+/**
+ * mei_me_cl_rm_by_uuid_id - remove all me clients matching client id
+ *
+ * @dev: the device structure
+ * @uuid: me client uuid
+ * @id: me client id
+ *
+ * Locking: called under "dev->device_lock" lock
+ */
+void mei_me_cl_rm_by_uuid_id(struct mei_device *dev, const uuid_le *uuid, u8 id)
+{
+	struct mei_me_client *me_cl, *next;
+	const uuid_le *pn;
+
+	dev_dbg(dev->dev, "remove %pUl %d\n", uuid, id);
 	list_for_each_entry_safe(me_cl, next, &dev->me_clients, list) {
-		if (uuid_le_cmp(*uuid, me_cl->props.protocol_name) == 0 &&
-		    me_cl->client_id == client_id) {
-			list_del(&me_cl->list);
-			kfree(me_cl);
-			break;
-		}
+		pn =  &me_cl->props.protocol_name;
+		if (me_cl->client_id == id && uuid_le_cmp(*uuid, *pn) == 0)
+			mei_me_cl_put(me_cl);
 	}
 }
 
+/**
+ * mei_me_cl_rm_all - remove all me clients
+ *
+ * @dev: the device structure
+ *
+ * Locking: called under "dev->device_lock" lock
+ */
+void mei_me_cl_rm_all(struct mei_device *dev)
+{
+	struct mei_me_client *me_cl, *next;
+
+	list_for_each_entry_safe(me_cl, next, &dev->me_clients, list)
+			mei_me_cl_put(me_cl);
+}
+
+
 
 /**
  * mei_cl_cmp_id - tells if the clients are the same
@@ -695,6 +790,7 @@ int mei_cl_flow_ctrl_creds(struct mei_cl *cl)
 {
 	struct mei_device *dev;
 	struct mei_me_client *me_cl;
+	int rets = 0;
 
 	if (WARN_ON(!cl || !cl->dev))
 		return -EINVAL;
@@ -710,12 +806,13 @@ int mei_cl_flow_ctrl_creds(struct mei_cl *cl)
 		return -ENOENT;
 	}
 
-	if (me_cl->mei_flow_ctrl_creds) {
+	if (me_cl->mei_flow_ctrl_creds > 0) {
+		rets = 1;
 		if (WARN_ON(me_cl->props.single_recv_buf == 0))
-			return -EINVAL;
-		return 1;
+			rets = -EINVAL;
 	}
-	return 0;
+	mei_me_cl_put(me_cl);
+	return rets;
 }
 
 /**
@@ -732,6 +829,7 @@ int mei_cl_flow_ctrl_reduce(struct mei_cl *cl)
 {
 	struct mei_device *dev;
 	struct mei_me_client *me_cl;
+	int rets;
 
 	if (WARN_ON(!cl || !cl->dev))
 		return -EINVAL;
@@ -745,15 +843,22 @@ int mei_cl_flow_ctrl_reduce(struct mei_cl *cl)
 	}
 
 	if (me_cl->props.single_recv_buf) {
-		if (WARN_ON(me_cl->mei_flow_ctrl_creds <= 0))
-			return -EINVAL;
+		if (WARN_ON(me_cl->mei_flow_ctrl_creds <= 0)) {
+			rets = -EINVAL;
+			goto out;
+		}
 		me_cl->mei_flow_ctrl_creds--;
 	} else {
-		if (WARN_ON(cl->mei_flow_ctrl_creds <= 0))
-			return -EINVAL;
+		if (WARN_ON(cl->mei_flow_ctrl_creds <= 0)) {
+			rets = -EINVAL;
+			goto out;
+		}
 		cl->mei_flow_ctrl_creds--;
 	}
-	return 0;
+	rets = 0;
+out:
+	mei_me_cl_put(me_cl);
+	return rets;
 }
 
 /**
@@ -788,6 +893,9 @@ int mei_cl_read_start(struct mei_cl *cl, size_t length)
 		cl_err(dev, cl, "no such me client %d\n", cl->me_client_id);
 		return  -ENOTTY;
 	}
+	/* always allocate at least client max message */
+	length = max_t(size_t, length, me_cl->props.max_msg_length);
+	mei_me_cl_put(me_cl);
 
 	rets = pm_runtime_get(dev->dev);
 	if (rets < 0 && rets != -EINPROGRESS) {
@@ -802,8 +910,6 @@ int mei_cl_read_start(struct mei_cl *cl, size_t length)
 		goto out;
 	}
 
-	/* always allocate at least client max message */
-	length = max_t(size_t, length, me_cl->props.max_msg_length);
 	rets = mei_io_cb_alloc_resp_buf(cb, length);
 	if (rets)
 		goto out;
diff --git a/drivers/misc/mei/client.h b/drivers/misc/mei/client.h
index d9d0c1525259..cfcde8e97fc4 100644
--- a/drivers/misc/mei/client.h
+++ b/drivers/misc/mei/client.h
@@ -24,15 +24,22 @@
 
 #include "mei_dev.h"
 
+/*
+ * reference counting base function
+ */
+void mei_me_cl_init(struct mei_me_client *me_cl);
+void mei_me_cl_put(struct mei_me_client *me_cl);
+struct mei_me_client *mei_me_cl_get(struct mei_me_client *me_cl);
+
 struct mei_me_client *mei_me_cl_by_uuid(const struct mei_device *dev,
-					const uuid_le *cuuid);
+					const uuid_le *uuid);
 struct mei_me_client *mei_me_cl_by_id(struct mei_device *dev, u8 client_id);
-
 struct mei_me_client *mei_me_cl_by_uuid_id(struct mei_device *dev,
 					   const uuid_le *uuid, u8 client_id);
-
-void mei_me_cl_remove(struct mei_device *dev,
-		      const uuid_le *uuid, u8 client_id);
+void mei_me_cl_rm_by_uuid(struct mei_device *dev, const uuid_le *uuid);
+void mei_me_cl_rm_by_uuid_id(struct mei_device *dev,
+			     const uuid_le *uuid, u8 id);
+void mei_me_cl_rm_all(struct mei_device *dev);
 
 /*
  * MEI IO Functions
diff --git a/drivers/misc/mei/debugfs.c b/drivers/misc/mei/debugfs.c
index b60b4263cf0f..b125380ee871 100644
--- a/drivers/misc/mei/debugfs.c
+++ b/drivers/misc/mei/debugfs.c
@@ -21,20 +21,22 @@
 #include <linux/mei.h>
 
 #include "mei_dev.h"
+#include "client.h"
 #include "hw.h"
 
 static ssize_t mei_dbgfs_read_meclients(struct file *fp, char __user *ubuf,
 					size_t cnt, loff_t *ppos)
 {
 	struct mei_device *dev = fp->private_data;
-	struct mei_me_client *me_cl;
+	struct mei_me_client *me_cl, *n;
 	size_t bufsz = 1;
 	char *buf;
 	int i = 0;
 	int pos = 0;
 	int ret;
 
-#define HDR "  |id|fix|         UUID                       |con|msg len|sb|\n"
+#define HDR \
+"  |id|fix|         UUID                       |con|msg len|sb|refc|\n"
 
 	mutex_lock(&dev->device_lock);
 
@@ -54,16 +56,22 @@ static ssize_t mei_dbgfs_read_meclients(struct file *fp, char __user *ubuf,
 	if (dev->dev_state != MEI_DEV_ENABLED)
 		goto out;
 
-	list_for_each_entry(me_cl, &dev->me_clients, list) {
-
-		pos += scnprintf(buf + pos, bufsz - pos,
-			"%2d|%2d|%3d|%pUl|%3d|%7d|%2d|\n",
-			i++, me_cl->client_id,
-			me_cl->props.fixed_address,
-			&me_cl->props.protocol_name,
-			me_cl->props.max_number_of_connections,
-			me_cl->props.max_msg_length,
-			me_cl->props.single_recv_buf);
+	list_for_each_entry_safe(me_cl, n, &dev->me_clients, list) {
+
+		me_cl = mei_me_cl_get(me_cl);
+		if (me_cl) {
+			pos += scnprintf(buf + pos, bufsz - pos,
+				"%2d|%2d|%3d|%pUl|%3d|%7d|%2d|%4d|\n",
+				i++, me_cl->client_id,
+				me_cl->props.fixed_address,
+				&me_cl->props.protocol_name,
+				me_cl->props.max_number_of_connections,
+				me_cl->props.max_msg_length,
+				me_cl->props.single_recv_buf,
+				atomic_read(&me_cl->refcnt.refcount));
+		}
+
+		mei_me_cl_put(me_cl);
 	}
 out:
 	mutex_unlock(&dev->device_lock);
diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 239d7f5d6a92..c8412d41e4f1 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -105,21 +105,6 @@ void mei_hbm_idle(struct mei_device *dev)
 }
 
 /**
- * mei_me_cl_remove_all - remove all me clients
- *
- * @dev: the device structure
- */
-static void mei_me_cl_remove_all(struct mei_device *dev)
-{
-	struct mei_me_client *me_cl, *next;
-
-	list_for_each_entry_safe(me_cl, next, &dev->me_clients, list) {
-			list_del(&me_cl->list);
-			kfree(me_cl);
-	}
-}
-
-/**
  * mei_hbm_reset - reset hbm counters and book keeping data structurs
  *
  * @dev: the device structure
@@ -128,7 +113,7 @@ void mei_hbm_reset(struct mei_device *dev)
 {
 	dev->me_client_index = 0;
 
-	mei_me_cl_remove_all(dev);
+	mei_me_cl_rm_all(dev);
 
 	mei_hbm_idle(dev);
 }
@@ -339,11 +324,16 @@ static int mei_hbm_me_cl_add(struct mei_device *dev,
 			     struct hbm_props_response *res)
 {
 	struct mei_me_client *me_cl;
+	const uuid_le *uuid = &res->client_properties.protocol_name;
+
+	mei_me_cl_rm_by_uuid(dev, uuid);
 
 	me_cl = kzalloc(sizeof(struct mei_me_client), GFP_KERNEL);
 	if (!me_cl)
 		return -ENOMEM;
 
+	mei_me_cl_init(me_cl);
+
 	me_cl->props = res->client_properties;
 	me_cl->client_id = res->me_addr;
 	me_cl->mei_flow_ctrl_creds = 0;
@@ -484,6 +474,7 @@ static int mei_hbm_add_single_flow_creds(struct mei_device *dev,
 				  struct hbm_flow_control *flow)
 {
 	struct mei_me_client *me_cl;
+	int rets;
 
 	me_cl = mei_me_cl_by_id(dev, flow->me_addr);
 	if (!me_cl) {
@@ -492,14 +483,19 @@ static int mei_hbm_add_single_flow_creds(struct mei_device *dev,
 		return -ENOENT;
 	}
 
-	if (WARN_ON(me_cl->props.single_recv_buf == 0))
-		return -EINVAL;
+	if (WARN_ON(me_cl->props.single_recv_buf == 0)) {
+		rets = -EINVAL;
+		goto out;
+	}
 
 	me_cl->mei_flow_ctrl_creds++;
 	dev_dbg(dev->dev, "recv flow ctrl msg ME %d (single) creds = %d.\n",
 	    flow->me_addr, me_cl->mei_flow_ctrl_creds);
 
-	return 0;
+	rets = 0;
+out:
+	mei_me_cl_put(me_cl);
+	return rets;
 }
 
 /**
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index ae56ba6ca0e3..3c019c0e60eb 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -303,7 +303,7 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 			 size_t length, loff_t *offset)
 {
 	struct mei_cl *cl = file->private_data;
-	struct mei_me_client *me_cl;
+	struct mei_me_client *me_cl = NULL;
 	struct mei_cl_cb *write_cb = NULL;
 	struct mei_device *dev;
 	unsigned long timeout = 0;
@@ -399,12 +399,14 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 				"amthif write failed with status = %d\n", rets);
 			goto out;
 		}
+		mei_me_cl_put(me_cl);
 		mutex_unlock(&dev->device_lock);
 		return length;
 	}
 
 	rets = mei_cl_write(cl, write_cb, false);
 out:
+	mei_me_cl_put(me_cl);
 	mutex_unlock(&dev->device_lock);
 	if (rets < 0)
 		mei_io_cb_free(write_cb);
@@ -433,24 +435,19 @@ static int mei_ioctl_connect_client(struct file *file,
 	cl = file->private_data;
 	dev = cl->dev;
 
-	if (dev->dev_state != MEI_DEV_ENABLED) {
-		rets = -ENODEV;
-		goto end;
-	}
+	if (dev->dev_state != MEI_DEV_ENABLED)
+		return -ENODEV;
 
 	if (cl->state != MEI_FILE_INITIALIZING &&
-	    cl->state != MEI_FILE_DISCONNECTED) {
-		rets = -EBUSY;
-		goto end;
-	}
+	    cl->state != MEI_FILE_DISCONNECTED)
+		return  -EBUSY;
 
 	/* find ME client we're trying to connect to */
 	me_cl = mei_me_cl_by_uuid(dev, &data->in_client_uuid);
 	if (!me_cl || me_cl->props.fixed_address) {
 		dev_dbg(dev->dev, "Cannot connect to FW Client UUID = %pUl\n",
 				&data->in_client_uuid);
-		rets = -ENOTTY;
-		goto end;
+		return  -ENOTTY;
 	}
 
 	cl->me_client_id = me_cl->client_id;
@@ -487,17 +484,16 @@ static int mei_ioctl_connect_client(struct file *file,
 		goto end;
 	}
 
-
 	/* prepare the output buffer */
 	client = &data->out_client_properties;
 	client->max_msg_length = me_cl->props.max_msg_length;
 	client->protocol_version = me_cl->props.protocol_version;
 	dev_dbg(dev->dev, "Can connect?\n");
 
-
 	rets = mei_cl_connect(cl, file);
 
 end:
+	mei_me_cl_put(me_cl);
 	return rets;
 }
 
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 1ead5c3cda6c..363c093a7772 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -172,12 +172,14 @@ struct mei_fw_status {
  * struct mei_me_client - representation of me (fw) client
  *
  * @list: link in me client list
+ * @refcnt: struct reference count
  * @props: client properties
  * @client_id: me client id
  * @mei_flow_ctrl_creds: flow control credits
  */
 struct mei_me_client {
 	struct list_head list;
+	struct kref refcnt;
 	struct mei_client_properties props;
 	u8 client_id;
 	u8 mei_flow_ctrl_creds;
diff --git a/drivers/misc/mei/nfc.c b/drivers/misc/mei/nfc.c
index 60ca9240368e..bb61a119b8bb 100644
--- a/drivers/misc/mei/nfc.c
+++ b/drivers/misc/mei/nfc.c
@@ -521,6 +521,7 @@ int mei_nfc_host_init(struct mei_device *dev)
 
 	cl_info->me_client_id = me_cl->client_id;
 	cl_info->cl_uuid = me_cl->props.protocol_name;
+	mei_me_cl_put(me_cl);
 
 	ret = mei_cl_link(cl_info, MEI_HOST_CLIENT_ID_ANY);
 	if (ret)
@@ -539,6 +540,7 @@ int mei_nfc_host_init(struct mei_device *dev)
 
 	cl->me_client_id = me_cl->client_id;
 	cl->cl_uuid = me_cl->props.protocol_name;
+	mei_me_cl_put(me_cl);
 
 	ret = mei_cl_link(cl, MEI_HOST_CLIENT_ID_ANY);
 	if (ret)
diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index b1d892cea94d..475f1dea45bf 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -76,6 +76,7 @@ int mei_wd_host_init(struct mei_device *dev)
 
 	cl->me_client_id = me_cl->client_id;
 	cl->cl_uuid = me_cl->props.protocol_name;
+	mei_me_cl_put(me_cl);
 
 	ret = mei_cl_link(cl, MEI_WD_HOST_CLIENT_ID);
 
-- 
1.9.3


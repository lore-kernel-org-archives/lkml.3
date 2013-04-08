Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935649Ab3DHS5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:57:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:55282 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935175Ab3DHS5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:57:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,432,1363158000"; 
   d="scan'208";a="224698898"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/2] mei: add mei_cl_write function
Date: Mon,  8 Apr 2013 21:56:37 +0300
Message-Id: <1365447398-15537-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365447398-15537-1-git-send-email-tomas.winkler@intel.com>
References: <1365447398-15537-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

consolidate write code to a specific me client in mei_cl_write function
the function is called from mei device write handler and from
mei_cl bus send function

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/bus.c     | 103 ++++++++------------------------------------
 drivers/misc/mei/client.c  | 105 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/misc/mei/client.h  |   7 ++-
 drivers/misc/mei/main.c    |  83 +++++++----------------------------
 drivers/misc/mei/mei_dev.h |   6 +--
 5 files changed, 146 insertions(+), 158 deletions(-)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 8dbcb15..6badfa1 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -226,112 +226,47 @@ static int ___mei_cl_send(struct mei_cl *cl, u8 *buf, size_t length,
 			bool blocking)
 {
 	struct mei_device *dev;
-	struct mei_msg_hdr mei_hdr;
 	struct mei_cl_cb *cb;
-	int me_cl_id, err;
+	int id;
+	int rets;
 
 	if (WARN_ON(!cl || !cl->dev))
 		return -ENODEV;
 
+	dev = cl->dev;
+
 	if (cl->state != MEI_FILE_CONNECTED)
 		return -ENODEV;
 
+	/* Check if we have an ME client device */
+	id = mei_me_cl_by_id(dev, cl->me_client_id);
+	if (id < 0)
+		return -ENODEV;
+
+	if (length > dev->me_clients[id].props.max_msg_length)
+		return -EINVAL;
+
 	cb = mei_io_cb_init(cl, NULL);
 	if (!cb)
 		return -ENOMEM;
 
-	err = mei_io_cb_alloc_req_buf(cb, length);
-	if (err < 0) {
+	rets = mei_io_cb_alloc_req_buf(cb, length);
+	if (rets < 0) {
 		mei_io_cb_free(cb);
-		return err;
+		return rets;
 	}
 
 	memcpy(cb->request_buffer.data, buf, length);
-	cb->fop_type = MEI_FOP_WRITE;
-
-	dev = cl->dev;
 
 	mutex_lock(&dev->device_lock);
 
-	/* Check if we have an ME client device */
-	me_cl_id = mei_me_cl_by_id(dev, cl->me_client_id);
-	if (me_cl_id == dev->me_clients_num) {
-		err = -ENODEV;
-		goto out_err;
-	}
-
-	if (length > dev->me_clients[me_cl_id].props.max_msg_length) {
-		err = -EINVAL;
-		goto out_err;
-	}
-
-	err = mei_cl_flow_ctrl_creds(cl);
-	if (err < 0)
-		goto out_err;
-
-	/* Host buffer is not ready, we queue the request */
-	if (err == 0 || !dev->hbuf_is_ready) {
-		cb->buf_idx = 0;
-		mei_hdr.msg_complete = 0;
-		cl->writing_state = MEI_WRITING;
-
-		goto out;
-	}
-
-	dev->hbuf_is_ready = false;
-
-	/* Check for a maximum length */
-	if (length > mei_hbuf_max_len(dev)) {
-		mei_hdr.length = mei_hbuf_max_len(dev);
-		mei_hdr.msg_complete = 0;
-	} else {
-		mei_hdr.length = length;
-		mei_hdr.msg_complete = 1;
-	}
-
-	mei_hdr.host_addr = cl->host_client_id;
-	mei_hdr.me_addr = cl->me_client_id;
-	mei_hdr.reserved = 0;
-
-	if (mei_write_message(dev, &mei_hdr, buf)) {
-		err = -EIO;
-		goto out_err;
-	}
-
-	cl->writing_state = MEI_WRITING;
-	cb->buf_idx = mei_hdr.length;
-
-out:
-	if (mei_hdr.msg_complete) {
-		if (mei_cl_flow_ctrl_reduce(cl)) {
-			err = -ENODEV;
-			goto out_err;
-		}
-		list_add_tail(&cb->list, &dev->write_waiting_list.list);
-	} else {
-		list_add_tail(&cb->list, &dev->write_list.list);
-	}
+	rets = mei_cl_write(cl, cb, blocking);
 
 	mutex_unlock(&dev->device_lock);
+	if (rets < 0)
+		mei_io_cb_free(cb);
 
-	if (blocking && cl->writing_state != MEI_WRITE_COMPLETE) {
-		if (wait_event_interruptible(cl->tx_wait,
-			cl->writing_state == MEI_WRITE_COMPLETE)) {
-				if (signal_pending(current))
-					err = -EINTR;
-			err = -ERESTARTSYS;
-			mutex_lock(&dev->device_lock);
-			goto out_err;
-		}
-	}
-
-	return mei_hdr.length;
-
-out_err:
-	mutex_unlock(&dev->device_lock);
-	mei_io_cb_free(cb);
-
-	return err;
+	return rets;
 }
 
 int __mei_cl_recv(struct mei_cl *cl, u8 *buf, size_t length)
diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index e14397b..ecadd00 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -678,6 +678,111 @@ err:
 }
 
 /**
+ * mei_cl_write - submit a write cb to mei device
+	assumes device_lock is locked
+ *
+ * @cl: host client
+ * @cl: write callback with filled data
+ *
+ * returns numbe of bytes sent on success, <0 on failure.
+ */
+int mei_cl_write(struct mei_cl *cl, struct mei_cl_cb *cb, bool blocking)
+{
+	struct mei_device *dev;
+	struct mei_msg_data *buf;
+	struct mei_msg_hdr mei_hdr;
+	int rets;
+
+
+	if (WARN_ON(!cl || !cl->dev))
+		return -ENODEV;
+
+	if (WARN_ON(!cb))
+		return -EINVAL;
+
+	dev = cl->dev;
+
+
+	buf = &cb->request_buffer;
+
+	dev_dbg(&dev->pdev->dev, "mei_cl_write %d\n", buf->size);
+
+
+	cb->fop_type = MEI_FOP_WRITE;
+
+	rets = mei_cl_flow_ctrl_creds(cl);
+	if (rets < 0)
+		goto err;
+
+	/* Host buffer is not ready, we queue the request */
+	if (rets == 0 || !dev->hbuf_is_ready) {
+		cb->buf_idx = 0;
+		/* unseting complete will enqueue the cb for write */
+		mei_hdr.msg_complete = 0;
+		cl->writing_state = MEI_WRITING;
+		rets = buf->size;
+		goto out;
+	}
+
+	dev->hbuf_is_ready = false;
+
+	/* Check for a maximum length */
+	if (buf->size > mei_hbuf_max_len(dev)) {
+		mei_hdr.length = mei_hbuf_max_len(dev);
+		mei_hdr.msg_complete = 0;
+	} else {
+		mei_hdr.length = buf->size;
+		mei_hdr.msg_complete = 1;
+	}
+
+	mei_hdr.host_addr = cl->host_client_id;
+	mei_hdr.me_addr = cl->me_client_id;
+	mei_hdr.reserved = 0;
+
+	dev_dbg(&dev->pdev->dev, "write " MEI_HDR_FMT "\n",
+		MEI_HDR_PRM(&mei_hdr));
+
+
+	if (mei_write_message(dev, &mei_hdr, buf->data)) {
+		rets = -EIO;
+		goto err;
+	}
+
+	cl->writing_state = MEI_WRITING;
+	cb->buf_idx = mei_hdr.length;
+
+	rets = buf->size;
+out:
+	if (mei_hdr.msg_complete) {
+		if (mei_cl_flow_ctrl_reduce(cl)) {
+			rets = -ENODEV;
+			goto err;
+		}
+		list_add_tail(&cb->list, &dev->write_waiting_list.list);
+	} else {
+		list_add_tail(&cb->list, &dev->write_list.list);
+	}
+
+
+	if (blocking && cl->writing_state != MEI_WRITE_COMPLETE) {
+
+		mutex_unlock(&dev->device_lock);
+		if (wait_event_interruptible(cl->tx_wait,
+			cl->writing_state == MEI_WRITE_COMPLETE)) {
+				if (signal_pending(current))
+					rets = -EINTR;
+				else
+					rets = -ERESTARTSYS;
+		}
+		mutex_lock(&dev->device_lock);
+	}
+err:
+	return rets;
+}
+
+
+
+/**
  * mei_cl_all_disconnect - disconnect forcefully all connected clients
  *
  * @dev - mei device
diff --git a/drivers/misc/mei/client.h b/drivers/misc/mei/client.h
index 214b239..e890c8b 100644
--- a/drivers/misc/mei/client.h
+++ b/drivers/misc/mei/client.h
@@ -86,17 +86,16 @@ int mei_cl_flow_ctrl_reduce(struct mei_cl *cl);
  */
 bool mei_cl_is_other_connecting(struct mei_cl *cl);
 int mei_cl_disconnect(struct mei_cl *cl);
-
-int mei_cl_read_start(struct mei_cl *cl);
-
 int mei_cl_connect(struct mei_cl *cl, struct file *file);
+int mei_cl_read_start(struct mei_cl *cl);
+int mei_cl_write(struct mei_cl *cl, struct mei_cl_cb *cb, bool blocking);
 
 void mei_host_client_init(struct work_struct *work);
 
 
+
 void mei_cl_all_disconnect(struct mei_device *dev);
 void mei_cl_all_read_wakeup(struct mei_device *dev);
 void mei_cl_all_write_clear(struct mei_device *dev);
 
-
 #endif /* _MEI_CLIENT_H_ */
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 329fb86..cb11b36 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -342,11 +342,10 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 {
 	struct mei_cl *cl = file->private_data;
 	struct mei_cl_cb *write_cb = NULL;
-	struct mei_msg_hdr mei_hdr;
 	struct mei_device *dev;
 	unsigned long timeout = 0;
 	int rets;
-	int i;
+	int id;
 
 	if (WARN_ON(!cl || !cl->dev))
 		return -ENODEV;
@@ -357,24 +356,24 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 
 	if (dev->dev_state != MEI_DEV_ENABLED) {
 		rets = -ENODEV;
-		goto err;
+		goto out;
 	}
 
-	i = mei_me_cl_by_id(dev, cl->me_client_id);
-	if (i < 0) {
+	id = mei_me_cl_by_id(dev, cl->me_client_id);
+	if (id < 0) {
 		rets = -ENODEV;
-		goto err;
+		goto out;
 	}
-	if (length > dev->me_clients[i].props.max_msg_length || length <= 0) {
+	if (length > dev->me_clients[id].props.max_msg_length || length <= 0) {
 		rets = -EMSGSIZE;
-		goto err;
+		goto out;
 	}
 
 	if (cl->state != MEI_FILE_CONNECTED) {
-		rets = -ENODEV;
 		dev_err(&dev->pdev->dev, "host client = %d,  is not connected to ME client = %d",
 			cl->host_client_id, cl->me_client_id);
-		goto err;
+		rets = -ENODEV;
+		goto out;
 	}
 	if (cl == &dev->iamthif_cl) {
 		write_cb = mei_amthif_find_read_list_entry(dev, file);
@@ -412,17 +411,15 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 	if (!write_cb) {
 		dev_err(&dev->pdev->dev, "write cb allocation failed\n");
 		rets = -ENOMEM;
-		goto err;
+		goto out;
 	}
 	rets = mei_io_cb_alloc_req_buf(write_cb, length);
 	if (rets)
-		goto err;
-
-	dev_dbg(&dev->pdev->dev, "cb request size = %zd\n", length);
+		goto out;
 
 	rets = copy_from_user(write_cb->request_buffer.data, ubuf, length);
 	if (rets)
-		goto err;
+		goto out;
 
 	cl->sm_state = 0;
 	if (length == 4 &&
@@ -440,65 +437,17 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 		if (rets) {
 			dev_err(&dev->pdev->dev,
 				"amthif write failed with status = %d\n", rets);
-			goto err;
+			goto out;
 		}
 		mutex_unlock(&dev->device_lock);
 		return length;
 	}
 
-	write_cb->fop_type = MEI_FOP_WRITE;
-
-	dev_dbg(&dev->pdev->dev, "host client = %d, ME client = %d\n",
-	    cl->host_client_id, cl->me_client_id);
-	rets = mei_cl_flow_ctrl_creds(cl);
-	if (rets < 0)
-		goto err;
-
-	if (rets == 0 || !dev->hbuf_is_ready) {
-		write_cb->buf_idx = 0;
-		mei_hdr.msg_complete = 0;
-		cl->writing_state = MEI_WRITING;
-		goto out;
-	}
-
-	dev->hbuf_is_ready = false;
-	if (length >  mei_hbuf_max_len(dev)) {
-		mei_hdr.length = mei_hbuf_max_len(dev);
-		mei_hdr.msg_complete = 0;
-	} else {
-		mei_hdr.length = length;
-		mei_hdr.msg_complete = 1;
-	}
-	mei_hdr.host_addr = cl->host_client_id;
-	mei_hdr.me_addr = cl->me_client_id;
-	mei_hdr.reserved = 0;
-
-	dev_dbg(&dev->pdev->dev, "write " MEI_HDR_FMT "\n",
-		MEI_HDR_PRM(&mei_hdr));
-	if (mei_write_message(dev, &mei_hdr, write_cb->request_buffer.data)) {
-		rets = -ENODEV;
-		goto err;
-	}
-	cl->writing_state = MEI_WRITING;
-	write_cb->buf_idx = mei_hdr.length;
-
+	rets = mei_cl_write(cl, write_cb, false);
 out:
-	if (mei_hdr.msg_complete) {
-		if (mei_cl_flow_ctrl_reduce(cl)) {
-			rets = -ENODEV;
-			goto err;
-		}
-		list_add_tail(&write_cb->list, &dev->write_waiting_list.list);
-	} else {
-		list_add_tail(&write_cb->list, &dev->write_list.list);
-	}
-
-	mutex_unlock(&dev->device_lock);
-	return length;
-
-err:
 	mutex_unlock(&dev->device_lock);
-	mei_io_cb_free(write_cb);
+	if (rets < 0)
+		mei_io_cb_free(write_cb);
 	return rets;
 }
 
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 8806be4..d786da6 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -153,7 +153,7 @@ enum mei_cb_file_ops {
 /*
  * Intel MEI message data struct
  */
-struct mei_message_data {
+struct mei_msg_data {
 	u32 size;
 	unsigned char *data;
 };
@@ -184,8 +184,8 @@ struct mei_cl_cb {
 	struct list_head list;
 	struct mei_cl *cl;
 	enum mei_cb_file_ops fop_type;
-	struct mei_message_data request_buffer;
-	struct mei_message_data response_buffer;
+	struct mei_msg_data request_buffer;
+	struct mei_msg_data response_buffer;
 	unsigned long buf_idx;
 	unsigned long read_time;
 	struct file *file_object;
-- 
1.8.1.2


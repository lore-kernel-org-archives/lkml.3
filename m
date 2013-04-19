Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306Ab3DSTDE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 15:03:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:47770 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933014Ab3DSTDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 15:03:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,510,1363158000"; 
   d="scan'208";a="288738788"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/3 RESEND] mei: fix reading large reposnes
Date: Fri, 19 Apr 2013 22:01:35 +0300
Message-Id: <1366398096-14756-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366398096-14756-1-git-send-email-tomas.winkler@intel.com>
References: <1366398096-14756-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While writting to device is limitted to max_msg_length advertized
in client properites the read can be much longer delivered consequiting chunks.

We use krealloc to enlarge the buffer when needed.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/bus.c       |  8 ++++----
 drivers/misc/mei/client.c    |  7 ++++---
 drivers/misc/mei/client.h    |  2 +-
 drivers/misc/mei/interrupt.c | 18 +++++++++++++++---
 drivers/misc/mei/main.c      |  7 +++----
 5 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 834ceeb..1e935ea 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -286,7 +286,7 @@ int __mei_cl_recv(struct mei_cl *cl, u8 *buf, size_t length)
 	mutex_lock(&dev->device_lock);
 
 	if (!cl->read_cb) {
-		err = mei_cl_read_start(cl);
+		err = mei_cl_read_start(cl, length);
 		if (err < 0) {
 			mutex_unlock(&dev->device_lock);
 			return err;
@@ -378,7 +378,7 @@ static void mei_bus_event_work(struct work_struct *work)
 	device->events = 0;
 
 	/* Prepare for the next read */
-	mei_cl_read_start(device->cl);
+	mei_cl_read_start(device->cl, 0);
 }
 
 int mei_cl_register_event_cb(struct mei_cl_device *device,
@@ -392,7 +392,7 @@ int mei_cl_register_event_cb(struct mei_cl_device *device,
 	device->event_context = context;
 	INIT_WORK(&device->event_work, mei_bus_event_work);
 
-	mei_cl_read_start(device->cl);
+	mei_cl_read_start(device->cl, 0);
 
 	return 0;
 }
@@ -436,7 +436,7 @@ int mei_cl_enable_device(struct mei_cl_device *device)
 	mutex_unlock(&dev->device_lock);
 
 	if (device->event_cb && !cl->read_cb)
-		mei_cl_read_start(device->cl);
+		mei_cl_read_start(device->cl, 0);
 
 	if (!device->ops || !device->ops->enable)
 		return 0;
diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 9541aa9..7189274 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -624,7 +624,7 @@ int mei_cl_flow_ctrl_reduce(struct mei_cl *cl)
  *
  * returns 0 on success, <0 on failure.
  */
-int mei_cl_read_start(struct mei_cl *cl)
+int mei_cl_read_start(struct mei_cl *cl, size_t length)
 {
 	struct mei_device *dev;
 	struct mei_cl_cb *cb;
@@ -657,8 +657,9 @@ int mei_cl_read_start(struct mei_cl *cl)
 	if (!cb)
 		return -ENOMEM;
 
-	rets = mei_io_cb_alloc_resp_buf(cb,
-			dev->me_clients[i].props.max_msg_length);
+	/* always allocate at least client max message */
+	length = max_t(size_t, length, dev->me_clients[i].props.max_msg_length);
+	rets = mei_io_cb_alloc_resp_buf(cb, length);
 	if (rets)
 		goto err;
 
diff --git a/drivers/misc/mei/client.h b/drivers/misc/mei/client.h
index e890c8b..cfdb144 100644
--- a/drivers/misc/mei/client.h
+++ b/drivers/misc/mei/client.h
@@ -87,7 +87,7 @@ int mei_cl_flow_ctrl_reduce(struct mei_cl *cl);
 bool mei_cl_is_other_connecting(struct mei_cl *cl);
 int mei_cl_disconnect(struct mei_cl *cl);
 int mei_cl_connect(struct mei_cl *cl, struct file *file);
-int mei_cl_read_start(struct mei_cl *cl);
+int mei_cl_read_start(struct mei_cl *cl, size_t length);
 int mei_cl_write(struct mei_cl *cl, struct mei_cl_cb *cb, bool blocking);
 
 void mei_host_client_init(struct work_struct *work);
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 9bf64c0..7473071 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -145,9 +145,21 @@ static int mei_cl_irq_read_msg(struct mei_device *dev,
 		}
 
 		if (cb->response_buffer.size < mei_hdr->length + cb->buf_idx) {
-			dev_warn(&dev->pdev->dev, "message overflow.\n");
-			list_del(&cb->list);
-			return -ENOMEM;
+			dev_dbg(&dev->pdev->dev, "message overflow. size %d len %d idx %ld\n",
+				cb->response_buffer.size,
+				mei_hdr->length, cb->buf_idx);
+			cb->response_buffer.data =
+					krealloc(cb->response_buffer.data,
+					mei_hdr->length + cb->buf_idx,
+					GFP_KERNEL);
+
+			if (!cb->response_buffer.data) {
+				dev_err(&dev->pdev->dev, "allocation failed.\n");
+				list_del(&cb->list);
+				return -ENOMEM;
+			}
+			cb->response_buffer.size =
+				mei_hdr->length + cb->buf_idx;
 		}
 
 		buffer = cb->response_buffer.data + cb->buf_idx;
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 78b4da5..7c44c8d 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -244,7 +244,7 @@ static ssize_t mei_read(struct file *file, char __user *ubuf,
 		goto out;
 	}
 
-	err = mei_cl_read_start(cl);
+	err = mei_cl_read_start(cl, length);
 	if (err && err != -EBUSY) {
 		dev_dbg(&dev->pdev->dev,
 			"mei start read failure with status = %d\n", err);
@@ -292,9 +292,8 @@ static ssize_t mei_read(struct file *file, char __user *ubuf,
 	}
 	/* now copy the data to user space */
 copy_buffer:
-	dev_dbg(&dev->pdev->dev, "cb->response_buffer size - %d\n",
-	    cb->response_buffer.size);
-	dev_dbg(&dev->pdev->dev, "cb->buf_idx - %lu\n", cb->buf_idx);
+	dev_dbg(&dev->pdev->dev, "buf.size = %d buf.idx= %ld\n",
+	    cb->response_buffer.size, cb->buf_idx);
 	if (length == 0 || ubuf == NULL || *offset > cb->buf_idx) {
 		rets = -EMSGSIZE;
 		goto free;
-- 
1.8.1.2


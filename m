Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408Ab3BGVGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 16:06:05 -0500
Received: from mga14.intel.com ([143.182.124.37]:20205 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759357Ab3BGVDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 16:03:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,623,1355126400"; 
   d="scan'208";a="253970067"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org, sameo@linux.intel.com
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 03/11] mei: bus: Initial implementation for I/O routines
Date: Thu,  7 Feb 2013 23:03:09 +0200
Message-Id: <1360270997-7639-4-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1360270997-7639-1-git-send-email-tomas.winkler@intel.com>
References: <1360270997-7639-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/bus.c     |  226 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/misc/mei/bus.h     |    3 +
 drivers/misc/mei/mei_dev.h |   14 +++
 include/linux/mei_bus.h    |   11 ++
 4 files changed, 254 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index ea24e7c..9689b95 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
@@ -25,6 +26,8 @@
 #include <linux/mei_bus.h>
 
 #include "mei_dev.h"
+#include "hw-me.h"
+#include "client.h"
 #include "bus.h"
 
 static int mei_device_match(struct device *dev, struct device_driver *drv)
@@ -73,6 +76,11 @@ static int mei_device_remove(struct device *dev)
 	if (!client || !dev->driver)
 		return 0;
 
+	if (client->event_cb) {
+		client->event_cb = NULL;
+		cancel_work_sync(&client->event_work);
+	}
+
 	driver = to_mei_driver(dev->driver);
 	if (!driver->remove) {
 		dev->driver = NULL;
@@ -182,3 +190,221 @@ void mei_del_driver(struct mei_bus_driver *driver)
 	pr_debug("mei: driver [%s] unregistered\n", driver->driver.name);
 }
 EXPORT_SYMBOL(mei_del_driver);
+
+int mei_send(struct mei_cl *cl, u8 *buf, size_t length)
+{
+	struct mei_device *dev;
+	struct mei_msg_hdr mei_hdr;
+	struct mei_cl_cb *cb;
+	int me_cl_id, err;
+
+	if (WARN_ON(!cl || !cl->dev))
+		return -ENODEV;
+
+	if (cl->state != MEI_FILE_CONNECTED)
+		return -ENODEV;
+
+	cb = mei_io_cb_init(cl, NULL);
+	if (!cb)
+		return -ENOMEM;
+
+	err = mei_io_cb_alloc_req_buf(cb, length);
+	if (err < 0) {
+		mei_io_cb_free(cb);
+		return err;
+	}
+
+	memcpy(cb->request_buffer.data, buf, length);
+	cb->fop_type = MEI_FOP_WRITE;
+
+	dev = cl->dev;
+
+	mutex_lock(&dev->device_lock);
+
+	/* Check if we have an ME client device */
+	me_cl_id = mei_me_cl_by_id(dev, cl->me_client_id);
+	if (me_cl_id == dev->me_clients_num) {
+		err = -ENODEV;
+		goto out_err;
+	}
+
+	if (length > dev->me_clients[me_cl_id].props.max_msg_length) {
+		err = -EINVAL;
+		goto out_err;
+	}
+
+	err = mei_cl_flow_ctrl_creds(cl);
+	if (err < 0)
+		goto out_err;
+
+	/* Host buffer is not ready, we queue the request */
+	if (err == 0 || !dev->hbuf_is_ready) {
+		cb->buf_idx = 0;
+		mei_hdr.msg_complete = 0;
+		cl->writing_state = MEI_WRITING;
+		list_add_tail(&cb->list, &dev->write_list.list);
+
+		mutex_unlock(&dev->device_lock);
+
+		return length;
+	}
+
+	dev->hbuf_is_ready = false;
+
+	/* Check for a maximum length */
+	if (length > mei_hbuf_max_len(dev)) {
+		mei_hdr.length = mei_hbuf_max_len(dev);
+		mei_hdr.msg_complete = 0;
+	} else {
+		mei_hdr.length = length;
+		mei_hdr.msg_complete = 1;
+	}
+
+	mei_hdr.host_addr = cl->host_client_id;
+	mei_hdr.me_addr = cl->me_client_id;
+	mei_hdr.reserved = 0;
+
+	if (mei_write_message(dev, &mei_hdr, buf)) {
+		err = -EIO;
+		goto out_err;
+	}
+
+	cl->writing_state = MEI_WRITING;
+	cb->buf_idx = mei_hdr.length;
+
+	if (!mei_hdr.msg_complete) {
+		list_add_tail(&cb->list, &dev->write_list.list);
+	} else {
+		if (mei_cl_flow_ctrl_reduce(cl)) {
+			err = -EIO;
+			goto out_err;
+		}
+
+		list_add_tail(&cb->list, &dev->write_waiting_list.list);
+	}
+
+	mutex_unlock(&dev->device_lock);
+
+	return mei_hdr.length;
+
+out_err:
+	mutex_unlock(&dev->device_lock);
+	mei_io_cb_free(cb);
+
+	return err;
+}
+
+int mei_recv(struct mei_cl *cl, u8 *buf, size_t length)
+{
+	struct mei_device *dev;
+	struct mei_cl_cb *cb;
+	size_t r_length;
+	int err;
+
+	if (WARN_ON(!cl || !cl->dev))
+		return -ENODEV;
+
+	dev = cl->dev;
+
+	mutex_lock(&dev->device_lock);
+
+	if (!cl->read_cb) {
+		err = mei_cl_read_start(cl);
+		if (err < 0) {
+			mutex_unlock(&dev->device_lock);
+			return err;
+		}
+	}
+
+	if (cl->reading_state != MEI_READ_COMPLETE &&
+	    !waitqueue_active(&cl->rx_wait)) {
+		mutex_unlock(&dev->device_lock);
+
+		if (wait_event_interruptible(cl->rx_wait,
+				(MEI_READ_COMPLETE == cl->reading_state))) {
+			if (signal_pending(current))
+				return -EINTR;
+			return -ERESTARTSYS;
+		}
+
+		mutex_lock(&dev->device_lock);
+	}
+
+	cb = cl->read_cb;
+
+	if (cl->reading_state != MEI_READ_COMPLETE) {
+		r_length = 0;
+		goto out;
+	}
+
+	r_length = min_t(size_t, length, cb->buf_idx);
+
+	memcpy(buf, cb->response_buffer.data, r_length);
+
+	mei_io_cb_free(cb);
+	cl->reading_state = MEI_IDLE;
+	cl->read_cb = NULL;
+
+out:
+	mutex_unlock(&dev->device_lock);
+
+	return r_length;
+}
+
+int mei_bus_send(struct mei_bus_client *client, u8 *buf, size_t length)
+{
+	struct mei_cl *cl = NULL;
+
+	/* TODO: hook between mei_bus_client and mei_cl */
+
+	if (client->ops && client->ops->send)
+		return client->ops->send(client, buf, length);
+
+	return mei_send(cl, buf, length);
+}
+EXPORT_SYMBOL(mei_bus_send);
+
+int mei_bus_recv(struct mei_bus_client *client, u8 *buf, size_t length)
+{
+	struct mei_cl *cl = NULL;
+
+	/* TODO: hook between mei_bus_client and mei_cl */
+
+	if (client->ops && client->ops->recv)
+		return client->ops->recv(client, buf, length);
+
+	return mei_recv(cl, buf, length);
+}
+EXPORT_SYMBOL(mei_bus_recv);
+
+static void mei_bus_event_work(struct work_struct *work)
+{
+	struct mei_bus_client *client;
+
+	client = container_of(work, struct mei_bus_client, event_work);
+
+	if (client->event_cb)
+		client->event_cb(client, client->events, client->event_context);
+
+	client->events = 0;
+
+	/* Prepare for the next read */
+	mei_cl_read_start(client->cl);
+}
+
+int mei_bus_register_event_cb(struct mei_bus_client *client,
+			      mei_bus_event_cb_t event_cb, void *context)
+{
+	if (client->event_cb)
+		return -EALREADY;
+
+	client->events = 0;
+	client->event_cb = event_cb;
+	client->event_context = context;
+	INIT_WORK(&client->event_work, mei_bus_event_work);
+
+	mei_cl_read_start(client->cl);
+
+	return 0;
+}
+EXPORT_SYMBOL(mei_bus_register_event_cb);
diff --git a/drivers/misc/mei/bus.h b/drivers/misc/mei/bus.h
index 7130b67..81789f6 100644
--- a/drivers/misc/mei/bus.h
+++ b/drivers/misc/mei/bus.h
@@ -24,4 +24,7 @@ struct mei_bus_client *mei_add_device(struct mei_device *mei_dev,
 					uuid_le uuid, char *name);
 void mei_remove_device(struct mei_bus_client *client);
 
+int mei_send(struct mei_cl *cl, u8 *buf, size_t length);
+int mei_recv(struct mei_cl *cl, u8 *buf, size_t length);
+
 #endif /* _MEI_BUS_H_ */
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index ce19b26..948f791 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -264,6 +264,13 @@ struct mei_hw_ops {
 		     unsigned char *buf, unsigned long len);
 };
 
+struct mei_bus_client;
+
+struct mei_bus_ops {
+	int (*send)(struct mei_bus_client *client, u8 *buf, size_t length);
+	int (*recv)(struct mei_bus_client *client, u8 *buf, size_t length);
+};
+
 /**
  * mei_bus_client
  *
@@ -284,6 +291,13 @@ struct mei_bus_client {
 	struct mei_bus_driver *driver;
 	struct device dev;
 
+	struct mei_bus_ops *ops;
+
+	struct work_struct event_work;
+	mei_bus_event_cb_t event_cb;
+	void *event_context;
+	unsigned long events;
+
 	void *priv_data;
 };
 
diff --git a/include/linux/mei_bus.h b/include/linux/mei_bus.h
index 395f573..241325f 100644
--- a/include/linux/mei_bus.h
+++ b/include/linux/mei_bus.h
@@ -88,7 +88,18 @@ struct mei_bus_driver {
 	int (*remove)(struct mei_bus_client *client);
 };
 
+#define MEI_BUS_EVENT_RX 0
+#define MEI_BUS_EVENT_TX 1
+
 int mei_add_driver(struct mei_bus_driver *driver);
 void mei_del_driver(struct mei_bus_driver *driver);
 
+int mei_bus_send(struct mei_bus_client *client, u8 *buf, size_t length);
+int mei_bus_recv(struct mei_bus_client *client, u8 *buf, size_t length);
+
+typedef void (*mei_bus_event_cb_t)(struct mei_bus_client *client,
+				   u32 events, void *context);
+int mei_bus_register_event_cb(struct mei_bus_client *client,
+			      mei_bus_event_cb_t read_cb, void *context);
+
 #endif /* _LINUX_MEI_BUS_H */
-- 
1.7.4.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab3CTWrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 18:47:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:34695 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071Ab3CTWon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 18:44:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,880,1355126400"; 
   d="scan'208";a="282469759"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 03/11 V4] mei: bus: Initial implementation for I/O routines
Date: Thu, 21 Mar 2013 00:44:21 +0200
Message-Id: <1363819469-696-4-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363819469-696-1-git-send-email-tomas.winkler@intel.com>
References: <1363819469-696-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/bus.c     | 226 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/misc/mei/mei_dev.h |  30 ++++++
 include/linux/mei_cl_bus.h |  11 +++
 3 files changed, 267 insertions(+)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 9283dd6..43f77b8 100644
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
 #include <linux/mei_cl_bus.h>
 
 #include "mei_dev.h"
+#include "hw-me.h"
+#include "client.h"
 
 #define to_mei_cl_driver(d) container_of(d, struct mei_cl_driver, driver)
 #define to_mei_cl_device(d) container_of(d, struct mei_cl_device, dev)
@@ -83,6 +86,11 @@ static int mei_cl_device_remove(struct device *dev)
 	if (!device || !dev->driver)
 		return 0;
 
+	if (device->event_cb) {
+		device->event_cb = NULL;
+		cancel_work_sync(&device->event_work);
+	}
+
 	driver = to_mei_cl_driver(dev->driver);
 	if (!driver->remove) {
 		dev->driver = NULL;
@@ -175,3 +183,221 @@ void mei_cl_driver_unregister(struct mei_cl_driver *driver)
 	pr_debug("mei: driver [%s] unregistered\n", driver->driver.name);
 }
 EXPORT_SYMBOL_GPL(mei_cl_driver_unregister);
+
+int __mei_cl_send(struct mei_cl *cl, u8 *buf, size_t length)
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
+int __mei_cl_recv(struct mei_cl *cl, u8 *buf, size_t length)
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
+int mei_cl_send(struct mei_cl_device *device, u8 *buf, size_t length)
+{
+	struct mei_cl *cl = NULL;
+
+	/* TODO: hook between mei_bus_client and mei_cl */
+
+	if (device->ops && device->ops->send)
+		return device->ops->send(device, buf, length);
+
+	return __mei_cl_send(cl, buf, length);
+}
+EXPORT_SYMBOL_GPL(mei_cl_send);
+
+int mei_cl_recv(struct mei_cl_device *device, u8 *buf, size_t length)
+{
+	struct mei_cl *cl = NULL;
+
+	/* TODO: hook between mei_bus_client and mei_cl */
+
+	if (device->ops && device->ops->recv)
+		return device->ops->recv(device, buf, length);
+
+	return __mei_cl_recv(cl, buf, length);
+}
+EXPORT_SYMBOL_GPL(mei_cl_recv);
+
+static void mei_bus_event_work(struct work_struct *work)
+{
+	struct mei_cl_device *device;
+
+	device = container_of(work, struct mei_cl_device, event_work);
+
+	if (device->event_cb)
+		device->event_cb(device, device->events, device->event_context);
+
+	device->events = 0;
+
+	/* Prepare for the next read */
+	mei_cl_read_start(device->cl);
+}
+
+int mei_cl_register_event_cb(struct mei_cl_device *device,
+			  mei_cl_event_cb_t event_cb, void *context)
+{
+	if (device->event_cb)
+		return -EALREADY;
+
+	device->events = 0;
+	device->event_cb = event_cb;
+	device->event_context = context;
+	INIT_WORK(&device->event_work, mei_bus_event_work);
+
+	mei_cl_read_start(device->cl);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mei_cl_register_event_cb);
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index db8245e..800ac2b 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -268,6 +268,25 @@ struct mei_cl_device *mei_cl_add_device(struct mei_device *dev,
 				  uuid_le uuid, char *name);
 void mei_cl_remove_device(struct mei_cl_device *device);
 
+int __mei_cl_send(struct mei_cl *cl, u8 *buf, size_t length);
+int __mei_cl_recv(struct mei_cl *cl, u8 *buf, size_t length);
+
+/**
+ * struct mei_cl_transport_ops - MEI CL device transport ops
+ * This structure allows ME host clients to implement technology
+ * specific transport layers.
+ *
+ * @send: Tx hook for the device. This allows ME host clients to trap
+ *	the device driver buffers before actually physically
+ *	pushing it to the ME.
+ * @recv: Rx hook for the device. This allows ME host clients to trap the
+ *	ME buffers before forwarding them to the device driver.
+ */
+struct mei_cl_transport_ops {
+	int (*send)(struct mei_cl_device *device, u8 *buf, size_t length);
+	int (*recv)(struct mei_cl_device *device, u8 *buf, size_t length);
+};
+
 /**
  * struct mei_cl_device - MEI device handle
  * An mei_cl_device pointer is returned from mei_add_device()
@@ -278,6 +297,10 @@ void mei_cl_remove_device(struct mei_cl_device *device);
  * @dev: linux driver model device pointer
  * @uuid: me client uuid
  * @cl: mei client
+ * @ops: ME transport ops
+ * @event_cb: Drivers register this callback to get asynchronous ME
+ *	events (e.g. Rx buffer pending) notifications.
+ * @events: Events bitmask sent to the driver.
  * @priv_data: client private data
  */
 struct mei_cl_device {
@@ -286,6 +309,13 @@ struct mei_cl_device {
 	uuid_le uuid;
 	struct mei_cl *cl;
 
+	const struct mei_cl_transport_ops *ops;
+
+	struct work_struct event_work;
+	mei_cl_event_cb_t event_cb;
+	void *event_context;
+	unsigned long events;
+
 	void *priv_data;
 };
 
diff --git a/include/linux/mei_cl_bus.h b/include/linux/mei_cl_bus.h
index 92c30a8..054e7e3 100644
--- a/include/linux/mei_cl_bus.h
+++ b/include/linux/mei_cl_bus.h
@@ -96,4 +96,15 @@ int __mei_cl_driver_register(struct mei_cl_driver *driver,
 
 void mei_cl_driver_unregister(struct mei_cl_driver *driver);
 
+int mei_cl_send(struct mei_cl_device *device, u8 *buf, size_t length);
+int mei_cl_recv(struct mei_cl_device *device, u8 *buf, size_t length);
+
+typedef void (*mei_cl_event_cb_t)(struct mei_cl_device *device,
+			       u32 events, void *context);
+int mei_cl_register_event_cb(struct mei_cl_device *device,
+			  mei_cl_event_cb_t read_cb, void *context);
+
+#define MEI_CL_EVENT_RX 0
+#define MEI_CL_EVENT_TX 1
+
 #endif /* _LINUX_MEI_CL_BUS_H */
-- 
1.8.1.3


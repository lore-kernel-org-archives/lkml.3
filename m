Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933761Ab3BLShr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:37:47 -0500
Received: from mga01.intel.com ([192.55.52.88]:31853 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933731Ab3BLShn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:37:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,650,1355126400"; 
   d="scan'208";a="286287778"
From: Samuel Ortiz <sameo@linux.intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, tomas.winkler@intel.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [char-misc-next 04/12 v3] mei: bus: Initial implementation for I/O routines
Date: Tue, 12 Feb 2013 19:36:54 +0100
Message-Id: <1360694222-27632-5-git-send-email-sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360694222-27632-1-git-send-email-sameo@linux.intel.com>
References: <1360694222-27632-1-git-send-email-sameo@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/bus.c     |  226 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/misc/mei/mei_dev.h |   28 ++++++
 include/linux/mei_bus.h    |   11 +++
 3 files changed, 265 insertions(+)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 04e7ada..7229d3e 100644
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
 
 #define to_mei_driver(d) container_of(d, struct mei_driver, driver)
 #define to_mei_device(d) container_of(d, struct mei_device, dev)
@@ -83,6 +86,11 @@ static int mei_device_remove(struct device *dev)
 	if (!device || !dev->driver)
 		return 0;
 
+	if (device->event_cb) {
+		device->event_cb = NULL;
+		cancel_work_sync(&device->event_work);
+	}
+
 	driver = to_mei_driver(dev->driver);
 	if (!driver->remove) {
 		dev->driver = NULL;
@@ -175,3 +183,221 @@ void mei_driver_unregister(struct mei_driver *driver)
 	pr_debug("mei: driver [%s] unregistered\n", driver->driver.name);
 }
 EXPORT_SYMBOL_GPL(mei_driver_unregister);
+
+int __mei_send(struct mei_cl *cl, u8 *buf, size_t length)
+{
+	struct mei_host *dev;
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
+int __mei_recv(struct mei_cl *cl, u8 *buf, size_t length)
+{
+	struct mei_host *dev;
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
+int mei_send(struct mei_device *device, u8 *buf, size_t length)
+{
+	struct mei_cl *cl = NULL;
+
+	/* TODO: hook between mei_bus_client and mei_cl */
+
+	if (device->ops && device->ops->send)
+		return device->ops->send(device, buf, length);
+
+	return __mei_send(cl, buf, length);
+}
+EXPORT_SYMBOL_GPL(mei_send);
+
+int mei_recv(struct mei_device *device, u8 *buf, size_t length)
+{
+	struct mei_cl *cl = NULL;
+
+	/* TODO: hook between mei_bus_client and mei_cl */
+
+	if (device->ops && device->ops->recv)
+		return device->ops->recv(device, buf, length);
+
+	return __mei_recv(cl, buf, length);
+}
+EXPORT_SYMBOL_GPL(mei_recv);
+
+static void mei_bus_event_work(struct work_struct *work)
+{
+	struct mei_device *device;
+
+	device = container_of(work, struct mei_device, event_work);
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
+int mei_register_event_cb(struct mei_device *device,
+			  mei_event_cb_t event_cb, void *context)
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
+EXPORT_SYMBOL_GPL(mei_register_event_cb);
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 5f65617..ee75343 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -268,6 +268,23 @@ struct mei_hw_ops {
 struct mei_device *mei_add_device(struct mei_host *mei_host,
 				  uuid_le uuid, char *name);
 void mei_remove_device(struct mei_device *device);
+int __mei_send(struct mei_cl *cl, u8 *buf, size_t length);
+int __mei_recv(struct mei_cl *cl, u8 *buf, size_t length);
+
+/**
+ * struct mei_transport_ops - MEI device transport ops
+ * This structure allows ME host clients to implement technology
+ * specific transport layers.
+ *
+ * @send: Tx hook for the device. This allows ME host clients to trap
+ *	the device driver buffers before actually physically pushing it to the ME.
+ * @recv: Rx hook for the device. This allows ME host clients to trap the
+ *	ME buffers before forwarding them to the device driver.
+ */
+struct mei_transport_ops {
+	int (*send)(struct mei_device *device, u8 *buf, size_t length);
+	int (*recv)(struct mei_device *device, u8 *buf, size_t length);
+};
 
 /**
  * struct mei_device - MEI device handle
@@ -279,6 +296,10 @@ void mei_remove_device(struct mei_device *device);
  * @dev: linux driver model device pointer
  * @uuid: me client uuid
  * @cl: mei client
+ * @ops: ME transport ops
+ * @event_cb: Drivers register this callback to get asynchronous ME
+ *	events (e.g. Rx buffer pending) notifications.
+ * @events: Events bitmask sent to the driver.
  * @priv_data: client private data
  */
 struct mei_device {
@@ -287,6 +308,13 @@ struct mei_device {
 	uuid_le uuid;
 	struct mei_cl *cl;
 
+	const struct mei_transport_ops *ops;
+
+	struct work_struct event_work;
+	mei_event_cb_t event_cb;
+	void *event_context;
+	unsigned long events;
+
 	void *priv_data;
 };
 
diff --git a/include/linux/mei_bus.h b/include/linux/mei_bus.h
index 28be556..4ce6301 100644
--- a/include/linux/mei_bus.h
+++ b/include/linux/mei_bus.h
@@ -89,10 +89,21 @@ struct mei_driver {
 	int (*remove)(struct mei_device *dev);
 };
 
+#define MEI_EVENT_RX 0
+#define MEI_EVENT_TX 1
+
 int __mei_driver_register(struct mei_driver *driver, struct module *owner);
 #define mei_driver_register(driver)             \
 	__mei_driver_register(driver, THIS_MODULE)
 
 void mei_driver_unregister(struct mei_driver *driver);
 
+int mei_send(struct mei_device *device, u8 *buf, size_t length);
+int mei_recv(struct mei_device *device, u8 *buf, size_t length);
+
+typedef void (*mei_event_cb_t)(struct mei_device *device,
+			       u32 events, void *context);
+int mei_register_event_cb(struct mei_device *device,
+			  mei_event_cb_t read_cb, void *context);
+
 #endif /* _LINUX_MEI_BUS_H */
-- 
1.7.10.4


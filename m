Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936543Ab3DHWxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 18:53:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:16267 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936593Ab3DHWwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 18:52:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,434,1363158000"; 
   d="scan'208";a="314995535"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next] mei: bus: Add device enabling and disabling API
Date: Tue,  9 Apr 2013 01:51:38 +0300
Message-Id: <1365461498-16580-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

It should be left to the drivers to enable and disable the device on the
MEI bus when e.g getting probed.
For drivers to be able to safely call the enable and disable hooks, the
mei_cl_ops must be set before it's probed and thus this should happen
before registering the device on the MEI bus. Hence the mei_cl_add_device()
prototype change.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 Documentation/misc-devices/mei/mei-client-bus.txt |  7 +-
 drivers/misc/mei/bus.c                            | 99 ++++++++++++++++++++++-
 drivers/misc/mei/mei_dev.h                        | 28 ++++---
 include/linux/mei_cl_bus.h                        |  3 +
 4 files changed, 123 insertions(+), 14 deletions(-)

diff --git a/Documentation/misc-devices/mei/mei-client-bus.txt b/Documentation/misc-devices/mei/mei-client-bus.txt
index 9dc5ebf..f83910a 100644
--- a/Documentation/misc-devices/mei/mei-client-bus.txt
+++ b/Documentation/misc-devices/mei/mei-client-bus.txt
@@ -104,13 +104,16 @@ int contact_probe(struct mei_cl_device *dev, struct mei_cl_device_id *id)
 	struct contact_driver *contact;
 
 	[...]
+	mei_cl_enable_device(dev);
+
 	mei_cl_register_event_cb(dev, contact_event_cb, contact);
 
 	return 0;
  }
 
-In the probe routine the driver basically registers an ME bus event handler
-which is as close as it can get to registering a threaded IRQ handler.
+In the probe routine the driver first enable the MEI device and then registers
+an ME bus event handler which is as close as it can get to registering a
+threaded IRQ handler.
 The handler implementation will typically call some I/O routine depending on
 the pending events:
 
diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 6badfa1..834ceeb 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -153,7 +153,8 @@ static struct mei_cl *mei_bus_find_mei_cl_by_uuid(struct mei_device *dev,
 	return NULL;
 }
 struct mei_cl_device *mei_cl_add_device(struct mei_device *dev,
-				  uuid_le uuid, char *name)
+					uuid_le uuid, char *name,
+					struct mei_cl_ops *ops)
 {
 	struct mei_cl_device *device;
 	struct mei_cl *cl;
@@ -168,6 +169,7 @@ struct mei_cl_device *mei_cl_add_device(struct mei_device *dev,
 		return NULL;
 
 	device->cl = cl;
+	device->ops = ops;
 
 	device->dev.parent = &dev->pdev->dev;
 	device->dev.bus = &mei_cl_bus_type;
@@ -408,6 +410,101 @@ void mei_cl_set_drvdata(struct mei_cl_device *device, void *data)
 }
 EXPORT_SYMBOL_GPL(mei_cl_set_drvdata);
 
+int mei_cl_enable_device(struct mei_cl_device *device)
+{
+	int err;
+	struct mei_device *dev;
+	struct mei_cl *cl = device->cl;
+
+	if (cl == NULL)
+		return -ENODEV;
+
+	dev = cl->dev;
+
+	mutex_lock(&dev->device_lock);
+
+	cl->state = MEI_FILE_CONNECTING;
+
+	err = mei_cl_connect(cl, NULL);
+	if (err < 0) {
+		mutex_unlock(&dev->device_lock);
+		dev_err(&dev->pdev->dev, "Could not connect to the ME client");
+
+		return err;
+	}
+
+	mutex_unlock(&dev->device_lock);
+
+	if (device->event_cb && !cl->read_cb)
+		mei_cl_read_start(device->cl);
+
+	if (!device->ops || !device->ops->enable)
+		return 0;
+
+	return device->ops->enable(device);
+}
+EXPORT_SYMBOL_GPL(mei_cl_enable_device);
+
+int mei_cl_disable_device(struct mei_cl_device *device)
+{
+	int err;
+	struct mei_device *dev;
+	struct mei_cl *cl = device->cl;
+
+	if (cl == NULL)
+		return -ENODEV;
+
+	dev = cl->dev;
+
+	mutex_lock(&dev->device_lock);
+
+	if (cl->state != MEI_FILE_CONNECTED) {
+		mutex_unlock(&dev->device_lock);
+		dev_err(&dev->pdev->dev, "Already disconnected");
+
+		return 0;
+	}
+
+	cl->state = MEI_FILE_DISCONNECTING;
+
+	err = mei_cl_disconnect(cl);
+	if (err < 0) {
+		mutex_unlock(&dev->device_lock);
+		dev_err(&dev->pdev->dev,
+			"Could not disconnect from the ME client");
+
+		return err;
+	}
+
+	/* Flush queues and remove any pending read */
+	mei_cl_flush_queues(cl);
+
+	if (cl->read_cb) {
+		struct mei_cl_cb *cb = NULL;
+
+		cb = mei_cl_find_read_cb(cl);
+		/* Remove entry from read list */
+		if (cb)
+			list_del(&cb->list);
+
+		cb = cl->read_cb;
+		cl->read_cb = NULL;
+
+		if (cb) {
+			mei_io_cb_free(cb);
+			cb = NULL;
+		}
+	}
+
+	mutex_unlock(&dev->device_lock);
+
+	if (!device->ops || !device->ops->disable)
+		return 0;
+
+	return device->ops->disable(device);
+}
+EXPORT_SYMBOL_GPL(mei_cl_disable_device);
+
 void mei_cl_bus_rx_event(struct mei_cl *cl)
 {
 	struct mei_cl_device *device = cl->device;
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index d786da6..c02967d 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -269,30 +269,36 @@ struct mei_hw_ops {
 };
 
 /* MEI bus API*/
-struct mei_cl_device *mei_cl_add_device(struct mei_device *dev,
-				  uuid_le uuid, char *name);
-void mei_cl_remove_device(struct mei_cl_device *device);
-
-int __mei_cl_async_send(struct mei_cl *cl, u8 *buf, size_t length);
-int __mei_cl_send(struct mei_cl *cl, u8 *buf, size_t length);
-int __mei_cl_recv(struct mei_cl *cl, u8 *buf, size_t length);
 
 /**
- * struct mei_cl_transport_ops - MEI CL device transport ops
+ * struct mei_cl_ops - MEI CL device ops
  * This structure allows ME host clients to implement technology
- * specific transport layers.
+ * specific operations.
  *
+ * @enable: Enable an MEI CL device. Some devices require specific
+ *	HECI commands to initialize completely.
+ * @disable: Disable an MEI CL device.
  * @send: Tx hook for the device. This allows ME host clients to trap
  *	the device driver buffers before actually physically
  *	pushing it to the ME.
  * @recv: Rx hook for the device. This allows ME host clients to trap the
  *	ME buffers before forwarding them to the device driver.
  */
-struct mei_cl_transport_ops {
+struct mei_cl_ops {
+	int (*enable)(struct mei_cl_device *device);
+	int (*disable)(struct mei_cl_device *device);
 	int (*send)(struct mei_cl_device *device, u8 *buf, size_t length);
 	int (*recv)(struct mei_cl_device *device, u8 *buf, size_t length);
 };
 
+struct mei_cl_device *mei_cl_add_device(struct mei_device *dev,
+					uuid_le uuid, char *name,
+					struct mei_cl_ops *ops);
+void mei_cl_remove_device(struct mei_cl_device *device);
+
+int __mei_cl_async_send(struct mei_cl *cl, u8 *buf, size_t length);
+int __mei_cl_send(struct mei_cl *cl, u8 *buf, size_t length);
+int __mei_cl_recv(struct mei_cl *cl, u8 *buf, size_t length);
 void mei_cl_bus_rx_event(struct mei_cl *cl);
 int mei_cl_bus_init(void);
 void mei_cl_bus_exit(void);
@@ -319,7 +325,7 @@ struct mei_cl_device {
 
 	struct mei_cl *cl;
 
-	const struct mei_cl_transport_ops *ops;
+	const struct mei_cl_ops *ops;
 
 	struct work_struct event_work;
 	mei_cl_event_cb_t event_cb;
diff --git a/include/linux/mei_cl_bus.h b/include/linux/mei_cl_bus.h
index 1bece18..d14af7b 100644
--- a/include/linux/mei_cl_bus.h
+++ b/include/linux/mei_cl_bus.h
@@ -38,4 +38,7 @@ int mei_cl_register_event_cb(struct mei_cl_device *device,
 void *mei_cl_get_drvdata(const struct mei_cl_device *device);
 void mei_cl_set_drvdata(struct mei_cl_device *device, void *data);
 
+int mei_cl_enable_device(struct mei_cl_device *device);
+int mei_cl_disable_device(struct mei_cl_device *device);
+
 #endif /* _LINUX_MEI_CL_BUS_H */
-- 
1.8.1.2


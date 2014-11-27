Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbaK0MIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 07:08:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:5536 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760AbaK0MIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 07:08:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,469,1413270000"; 
   d="scan'208";a="629151492"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/3 V2] mei: bus: use ssize_t as the return type for send and receive
Date: Thu, 27 Nov 2014 14:07:28 +0200
Message-Id: <1417090049-23219-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417090049-23219-1-git-send-email-tomas.winkler@intel.com>
References: <1417090049-23219-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mei bus receive and send function may return either number
of transmitted bytes or errno.  It is better to use ssize_t
type for that purpose that mixing size_t with int.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
V2: rebase
 drivers/misc/mei/bus.c     | 30 ++++++++++++++----------------
 drivers/misc/mei/mei_dev.h |  6 +++---
 include/linux/mei_cl_bus.h |  4 ++--
 3 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index b3a72bca5242..31164dd14bd0 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -224,13 +224,13 @@ void mei_cl_driver_unregister(struct mei_cl_driver *driver)
 }
 EXPORT_SYMBOL_GPL(mei_cl_driver_unregister);
 
-static int ___mei_cl_send(struct mei_cl *cl, u8 *buf, size_t length,
+static ssize_t ___mei_cl_send(struct mei_cl *cl, u8 *buf, size_t length,
 			bool blocking)
 {
 	struct mei_device *dev;
 	struct mei_me_client *me_cl;
 	struct mei_cl_cb *cb;
-	int rets;
+	ssize_t rets;
 
 	if (WARN_ON(!cl || !cl->dev))
 		return -ENODEV;
@@ -271,12 +271,12 @@ static int ___mei_cl_send(struct mei_cl *cl, u8 *buf, size_t length,
 	return rets;
 }
 
-int __mei_cl_recv(struct mei_cl *cl, u8 *buf, size_t length)
+ssize_t __mei_cl_recv(struct mei_cl *cl, u8 *buf, size_t length)
 {
 	struct mei_device *dev;
 	struct mei_cl_cb *cb;
 	size_t r_length;
-	int err;
+	ssize_t rets;
 
 	if (WARN_ON(!cl || !cl->dev))
 		return -ENODEV;
@@ -286,11 +286,9 @@ int __mei_cl_recv(struct mei_cl *cl, u8 *buf, size_t length)
 	mutex_lock(&dev->device_lock);
 
 	if (!cl->read_cb) {
-		err = mei_cl_read_start(cl, length);
-		if (err < 0) {
-			mutex_unlock(&dev->device_lock);
-			return err;
-		}
+		rets = mei_cl_read_start(cl, length);
+		if (rets < 0)
+			goto out;
 	}
 
 	if (cl->reading_state != MEI_READ_COMPLETE &&
@@ -313,13 +311,13 @@ int __mei_cl_recv(struct mei_cl *cl, u8 *buf, size_t length)
 	cb = cl->read_cb;
 
 	if (cl->reading_state != MEI_READ_COMPLETE) {
-		r_length = 0;
+		rets = 0;
 		goto out;
 	}
 
 	r_length = min_t(size_t, length, cb->buf_idx);
-
 	memcpy(buf, cb->response_buffer.data, r_length);
+	rets = r_length;
 
 	mei_io_cb_free(cb);
 	cl->reading_state = MEI_IDLE;
@@ -328,20 +326,20 @@ int __mei_cl_recv(struct mei_cl *cl, u8 *buf, size_t length)
 out:
 	mutex_unlock(&dev->device_lock);
 
-	return r_length;
+	return rets;
 }
 
-inline int __mei_cl_async_send(struct mei_cl *cl, u8 *buf, size_t length)
+inline ssize_t __mei_cl_async_send(struct mei_cl *cl, u8 *buf, size_t length)
 {
 	return ___mei_cl_send(cl, buf, length, 0);
 }
 
-inline int __mei_cl_send(struct mei_cl *cl, u8 *buf, size_t length)
+inline ssize_t __mei_cl_send(struct mei_cl *cl, u8 *buf, size_t length)
 {
 	return ___mei_cl_send(cl, buf, length, 1);
 }
 
-int mei_cl_send(struct mei_cl_device *device, u8 *buf, size_t length)
+ssize_t mei_cl_send(struct mei_cl_device *device, u8 *buf, size_t length)
 {
 	struct mei_cl *cl = device->cl;
 
@@ -355,7 +353,7 @@ int mei_cl_send(struct mei_cl_device *device, u8 *buf, size_t length)
 }
 EXPORT_SYMBOL_GPL(mei_cl_send);
 
-int mei_cl_recv(struct mei_cl_device *device, u8 *buf, size_t length)
+ssize_t mei_cl_recv(struct mei_cl_device *device, u8 *buf, size_t length)
 {
 	struct mei_cl *cl =  device->cl;
 
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index c90c16b29c08..1ead5c3cda6c 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -345,9 +345,9 @@ struct mei_cl_device *mei_cl_add_device(struct mei_device *dev,
 					struct mei_cl_ops *ops);
 void mei_cl_remove_device(struct mei_cl_device *device);
 
-int __mei_cl_async_send(struct mei_cl *cl, u8 *buf, size_t length);
-int __mei_cl_send(struct mei_cl *cl, u8 *buf, size_t length);
-int __mei_cl_recv(struct mei_cl *cl, u8 *buf, size_t length);
+ssize_t __mei_cl_async_send(struct mei_cl *cl, u8 *buf, size_t length);
+ssize_t __mei_cl_send(struct mei_cl *cl, u8 *buf, size_t length);
+ssize_t __mei_cl_recv(struct mei_cl *cl, u8 *buf, size_t length);
 void mei_cl_bus_rx_event(struct mei_cl *cl);
 void mei_cl_bus_remove_devices(struct mei_device *dev);
 int mei_cl_bus_init(void);
diff --git a/include/linux/mei_cl_bus.h b/include/linux/mei_cl_bus.h
index 164aad1f9f12..0819d36a3a74 100644
--- a/include/linux/mei_cl_bus.h
+++ b/include/linux/mei_cl_bus.h
@@ -25,8 +25,8 @@ int __mei_cl_driver_register(struct mei_cl_driver *driver,
 
 void mei_cl_driver_unregister(struct mei_cl_driver *driver);
 
-int mei_cl_send(struct mei_cl_device *device, u8 *buf, size_t length);
-int mei_cl_recv(struct mei_cl_device *device, u8 *buf, size_t length);
+ssize_t mei_cl_send(struct mei_cl_device *device, u8 *buf, size_t length);
+ssize_t  mei_cl_recv(struct mei_cl_device *device, u8 *buf, size_t length);
 
 typedef void (*mei_cl_event_cb_t)(struct mei_cl_device *device,
 			       u32 events, void *context);
-- 
1.9.3


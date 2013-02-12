Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933803Ab3BLSiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:38:10 -0500
Received: from mga03.intel.com ([143.182.124.21]:52524 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933719Ab3BLSiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:38:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,650,1355126400"; 
   d="scan'208";a="201566598"
From: Samuel Ortiz <sameo@linux.intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, tomas.winkler@intel.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [char-misc-next 07/12 v3] mei: bus: Synchronous API for the data transmission
Date: Tue, 12 Feb 2013 19:36:57 +0100
Message-Id: <1360694222-27632-8-git-send-email-sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360694222-27632-1-git-send-email-sameo@linux.intel.com>
References: <1360694222-27632-1-git-send-email-sameo@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define a truly synchronous API for the bus Tx path by putting all pending
request to the write list and wait for the interrupt tx handler to wake
us up.
The ___mei_send() out path is also slightly reworked to make it look more
like main.c:mei_write().

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/bus.c     |   38 ++++++++++++++++++++++++++++----------
 drivers/misc/mei/mei_dev.h |    1 +
 2 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 4565e9a..85ca872 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -202,7 +202,7 @@ void mei_driver_unregister(struct mei_driver *driver)
 }
 EXPORT_SYMBOL_GPL(mei_driver_unregister);
 
-int __mei_send(struct mei_cl *cl, u8 *buf, size_t length)
+static int ___mei_send(struct mei_cl *cl, u8 *buf, size_t length, bool blocking)
 {
 	struct mei_host *dev;
 	struct mei_msg_hdr mei_hdr;
@@ -253,11 +253,8 @@ int __mei_send(struct mei_cl *cl, u8 *buf, size_t length)
 		cb->buf_idx = 0;
 		mei_hdr.msg_complete = 0;
 		cl->writing_state = MEI_WRITING;
-		list_add_tail(&cb->list, &dev->write_list.list);
-
-		mutex_unlock(&dev->device_lock);
 
-		return length;
+		goto out;
 	}
 
 	dev->hbuf_is_ready = false;
@@ -283,19 +280,30 @@ int __mei_send(struct mei_cl *cl, u8 *buf, size_t length)
 	cl->writing_state = MEI_WRITING;
 	cb->buf_idx = mei_hdr.length;
 
-	if (!mei_hdr.msg_complete) {
-		list_add_tail(&cb->list, &dev->write_list.list);
-	} else {
+out:
+	if (mei_hdr.msg_complete) {
 		if (mei_cl_flow_ctrl_reduce(cl)) {
-			err = -EIO;
+			err = -ENODEV;
 			goto out_err;
 		}
-
 		list_add_tail(&cb->list, &dev->write_waiting_list.list);
+	} else {
+		list_add_tail(&cb->list, &dev->write_list.list);
 	}
 
 	mutex_unlock(&dev->device_lock);
 
+	if (blocking && cl->writing_state != MEI_WRITE_COMPLETE) {
+		if (wait_event_interruptible(cl->tx_wait,
+			cl->writing_state == MEI_WRITE_COMPLETE)) {
+				if (signal_pending(current))
+					err = -EINTR;
+			err = -ERESTARTSYS;
+			mutex_lock(&dev->device_lock);
+			goto out_err;
+		}
+	}
+
 	return mei_hdr.length;
 
 out_err:
@@ -362,6 +370,16 @@ out:
 	return r_length;
 }
 
+inline int __mei_async_send(struct mei_cl *cl, u8 *buf, size_t length)
+{
+	return ___mei_send(cl, buf, length, 0);
+}
+
+inline int __mei_send(struct mei_cl *cl, u8 *buf, size_t length)
+{
+	return ___mei_send(cl, buf, length, 1);
+}
+
 int mei_send(struct mei_device *device, u8 *buf, size_t length)
 {
 	struct mei_cl *cl = device->cl;
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 546cd87..fc485d4 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -273,6 +273,7 @@ struct mei_hw_ops {
 struct mei_device *mei_add_device(struct mei_host *mei_host,
 				  uuid_le uuid, char *name);
 void mei_remove_device(struct mei_device *device);
+int __mei_async_send(struct mei_cl *cl, u8 *buf, size_t length);
 int __mei_send(struct mei_cl *cl, u8 *buf, size_t length);
 int __mei_recv(struct mei_cl *cl, u8 *buf, size_t length);
 
-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab3C0PbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:31:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:13482 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937Ab3C0PbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:31:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,920,1355126400"; 
   d="scan'208";a="308170163"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 06/11 V5] mei: bus: Synchronous API for the data transmission
Date: Wed, 27 Mar 2013 17:29:58 +0200
Message-Id: <1364398203-11159-7-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1364398203-11159-1-git-send-email-tomas.winkler@intel.com>
References: <1364398203-11159-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

Define a truly synchronous API for the bus Tx path by putting all pending
request to the write list and wait for the interrupt tx handler to wake
us up.
The ___mei_cl_send() out path is also slightly reworked to make it look more
like main.c:mei_write().

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/bus.c     | 39 +++++++++++++++++++++++++++++----------
 drivers/misc/mei/mei_dev.h |  1 +
 2 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index c626dc9..2b4b5b3 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -222,7 +222,8 @@ void mei_cl_driver_unregister(struct mei_cl_driver *driver)
 }
 EXPORT_SYMBOL_GPL(mei_cl_driver_unregister);
 
-int __mei_cl_send(struct mei_cl *cl, u8 *buf, size_t length)
+static int ___mei_cl_send(struct mei_cl *cl, u8 *buf, size_t length,
+			bool blocking)
 {
 	struct mei_device *dev;
 	struct mei_msg_hdr mei_hdr;
@@ -273,11 +274,8 @@ int __mei_cl_send(struct mei_cl *cl, u8 *buf, size_t length)
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
@@ -303,19 +301,30 @@ int __mei_cl_send(struct mei_cl *cl, u8 *buf, size_t length)
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
@@ -382,6 +391,16 @@ out:
 	return r_length;
 }
 
+inline int __mei_cl_async_send(struct mei_cl *cl, u8 *buf, size_t length)
+{
+	return ___mei_cl_send(cl, buf, length, 0);
+}
+
+inline int __mei_cl_send(struct mei_cl *cl, u8 *buf, size_t length)
+{
+	return ___mei_cl_send(cl, buf, length, 1);
+}
+
 int mei_cl_send(struct mei_cl_device *device, u8 *buf, size_t length)
 {
 	struct mei_cl *cl = device->cl;
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 7d594be..325f71a 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -273,6 +273,7 @@ struct mei_cl_device *mei_cl_add_device(struct mei_device *dev,
 				  uuid_le uuid, char *name);
 void mei_cl_remove_device(struct mei_cl_device *device);
 
+int __mei_cl_async_send(struct mei_cl *cl, u8 *buf, size_t length);
 int __mei_cl_send(struct mei_cl *cl, u8 *buf, size_t length);
 int __mei_cl_recv(struct mei_cl *cl, u8 *buf, size_t length);
 
-- 
1.7.11.7


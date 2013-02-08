Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946445Ab3BHM2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 07:28:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:5359 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946427Ab3BHM2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 07:28:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,629,1355126400"; 
   d="scan'208";a="284477792"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org, sameo@linux.intel.com
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 06/11 V2] mei: bus: Synchronous API for the data transmission
Date: Fri,  8 Feb 2013 14:28:19 +0200
Message-Id: <1360326504-17041-7-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1360326504-17041-1-git-send-email-tomas.winkler@intel.com>
References: <1360326504-17041-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

Define a truly synchronous API for the bus Tx path by putting all pending
request to the write list and wait for the interrupt tx handler to wake
us up.
The __mei_send() out path is also slightly reworked to make it look more
like main.c:mei_write().

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/bus.c |   38 ++++++++++++++++++++++++++++----------
 drivers/misc/mei/bus.h |    2 ++
 2 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 1048cd4..5a700cd 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -210,7 +210,7 @@ void mei_driver_unregister(struct mei_bus_driver *driver)
 }
 EXPORT_SYMBOL(mei_driver_unregister);
 
-int mei_send(struct mei_cl *cl, u8 *buf, size_t length)
+static int __mei_send(struct mei_cl *cl, u8 *buf, size_t length, bool blocking)
 {
 	struct mei_device *dev;
 	struct mei_msg_hdr mei_hdr;
@@ -261,11 +261,8 @@ int mei_send(struct mei_cl *cl, u8 *buf, size_t length)
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
@@ -291,19 +288,30 @@ int mei_send(struct mei_cl *cl, u8 *buf, size_t length)
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
@@ -370,6 +378,16 @@ out:
 	return r_length;
 }
 
+inline int mei_async_send(struct mei_cl *cl, u8 *buf, size_t length)
+{
+	return __mei_send(cl, buf, length, 0);
+}
+
+inline int mei_send(struct mei_cl *cl, u8 *buf, size_t length)
+{
+	return __mei_send(cl, buf, length, 1);
+}
+
 int mei_bus_send(struct mei_bus_client *client, u8 *buf, size_t length)
 {
 	struct mei_cl *cl = client->cl;
diff --git a/drivers/misc/mei/bus.h b/drivers/misc/mei/bus.h
index 81789f6..d7bf3b5 100644
--- a/drivers/misc/mei/bus.h
+++ b/drivers/misc/mei/bus.h
@@ -24,7 +24,9 @@ struct mei_bus_client *mei_add_device(struct mei_device *mei_dev,
 					uuid_le uuid, char *name);
 void mei_remove_device(struct mei_bus_client *client);
 
+int mei_async_send(struct mei_cl *cl, u8 *buf, size_t length);
 int mei_send(struct mei_cl *cl, u8 *buf, size_t length);
 int mei_recv(struct mei_cl *cl, u8 *buf, size_t length);
 
+
 #endif /* _MEI_BUS_H_ */
-- 
1.7.4.4


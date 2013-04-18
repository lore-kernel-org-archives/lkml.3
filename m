Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936556Ab3DRUFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 16:05:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:33775 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754125Ab3DRUFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 16:05:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,503,1363158000"; 
   d="scan'208";a="320499631"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next] mei: revamp hbm state machine
Date: Thu, 18 Apr 2013 23:03:48 +0300
Message-Id: <1366315428-31826-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Rename init_clients_state to hbm_state and use
MEI_HBM_ prefix for HBM states

2. Remove recvd_msg and use hbm state for synchronizing
hbm protocol has successful start.
We can wake up the hbm event from start response handler
and remove the hack from the interrupt thread

3. mei_hbm_start_wait function encapsulate start completion
waiting

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hbm.c       | 53 +++++++++++++++++++++++++++++++++-----------
 drivers/misc/mei/hbm.h       | 25 +++++++++++++++++++--
 drivers/misc/mei/hw-me.c     | 12 ----------
 drivers/misc/mei/init.c      | 22 +++---------------
 drivers/misc/mei/interrupt.c |  4 ++--
 drivers/misc/mei/main.c      |  2 +-
 drivers/misc/mei/mei_dev.h   | 13 +++--------
 7 files changed, 72 insertions(+), 59 deletions(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index de7f5ba..4de80d9 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -123,12 +123,33 @@ static bool is_treat_specially_client(struct mei_cl *cl,
 	return false;
 }
 
+int mei_hbm_start_wait(struct mei_device *dev)
+{
+	int ret;
+	if (dev->hbm_state > MEI_HBM_START)
+		return 0;
+
+	mutex_unlock(&dev->device_lock);
+	ret = wait_event_interruptible_timeout(dev->wait_recvd_msg,
+			dev->hbm_state == MEI_HBM_IDLE ||
+			dev->hbm_state > MEI_HBM_START,
+			mei_secs_to_jiffies(MEI_INTEROP_TIMEOUT));
+	mutex_lock(&dev->device_lock);
+
+	if (ret <= 0 && (dev->hbm_state <= MEI_HBM_START)) {
+		dev->hbm_state = MEI_HBM_IDLE;
+		dev_err(&dev->pdev->dev, "wating for mei start failed\n");
+		return -ETIMEDOUT;
+	}
+	return 0;
+}
+
 /**
  * mei_hbm_start_req - sends start request message.
  *
  * @dev: the device structure
  */
-void mei_hbm_start_req(struct mei_device *dev)
+int mei_hbm_start_req(struct mei_device *dev)
 {
 	struct mei_msg_hdr *mei_hdr = &dev->wr_msg.hdr;
 	struct hbm_host_version_request *start_req;
@@ -143,18 +164,19 @@ void mei_hbm_start_req(struct mei_device *dev)
 	start_req->host_version.major_version = HBM_MAJOR_VERSION;
 	start_req->host_version.minor_version = HBM_MINOR_VERSION;
 
-	dev->recvd_msg = false;
+	dev->hbm_state = MEI_HBM_IDLE;
 	if (mei_write_message(dev, mei_hdr, dev->wr_msg.data)) {
 		dev_err(&dev->pdev->dev, "version message writet failed\n");
 		dev->dev_state = MEI_DEV_RESETING;
 		mei_reset(dev, 1);
+		return -ENODEV;
 	}
-	dev->init_clients_state = MEI_START_MESSAGE;
+	dev->hbm_state = MEI_HBM_START;
 	dev->init_clients_timer = MEI_CLIENTS_INIT_TIMEOUT;
-	return ;
+	return 0;
 }
 
-/**
+/*
  * mei_hbm_enum_clients_req - sends enumeration client request message.
  *
  * @dev: the device structure
@@ -178,7 +200,7 @@ static void mei_hbm_enum_clients_req(struct mei_device *dev)
 		dev_err(&dev->pdev->dev, "enumeration request write failed.\n");
 		mei_reset(dev, 1);
 	}
-	dev->init_clients_state = MEI_ENUM_CLIENTS_MESSAGE;
+	dev->hbm_state = MEI_HBM_ENUM_CLIENTS;
 	dev->init_clients_timer = MEI_CLIENTS_INIT_TIMEOUT;
 	return;
 }
@@ -208,6 +230,7 @@ static int mei_hbm_prop_req(struct mei_device *dev)
 
 	/* We got all client properties */
 	if (next_client_index == MEI_CLIENTS_MAX) {
+		dev->hbm_state = MEI_HBM_STARTED;
 		schedule_work(&dev->init_work);
 
 		return 0;
@@ -542,27 +565,28 @@ void mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 			dev->version = version_res->me_max_version;
 			dev_dbg(&dev->pdev->dev, "version mismatch.\n");
 
+			dev->hbm_state = MEI_HBM_STOP;
 			mei_hbm_stop_req_prepare(dev, &dev->wr_msg.hdr,
 						dev->wr_msg.data);
 			mei_write_message(dev, &dev->wr_msg.hdr,
 					dev->wr_msg.data);
+
 			return;
 		}
 
 		dev->version.major_version = HBM_MAJOR_VERSION;
 		dev->version.minor_version = HBM_MINOR_VERSION;
 		if (dev->dev_state == MEI_DEV_INIT_CLIENTS &&
-		    dev->init_clients_state == MEI_START_MESSAGE) {
+		    dev->hbm_state == MEI_HBM_START) {
 			dev->init_clients_timer = 0;
 			mei_hbm_enum_clients_req(dev);
 		} else {
-			dev->recvd_msg = false;
 			dev_err(&dev->pdev->dev, "reset: wrong host start response\n");
 			mei_reset(dev, 1);
 			return;
 		}
 
-		dev->recvd_msg = true;
+		wake_up_interruptible(&dev->wait_recvd_msg);
 		dev_dbg(&dev->pdev->dev, "host start response message received.\n");
 		break;
 
@@ -603,7 +627,7 @@ void mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 		}
 
 		if (dev->dev_state != MEI_DEV_INIT_CLIENTS ||
-		    dev->init_clients_state != MEI_CLIENT_PROPERTIES_MESSAGE) {
+		    dev->hbm_state != MEI_HBM_CLIENT_PROPERTIES) {
 			dev_err(&dev->pdev->dev, "reset: unexpected properties response\n");
 			mei_reset(dev, 1);
 
@@ -623,13 +647,12 @@ void mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 		enum_res = (struct hbm_host_enum_response *) mei_msg;
 		memcpy(dev->me_clients_map, enum_res->valid_addresses, 32);
 		if (dev->dev_state == MEI_DEV_INIT_CLIENTS &&
-		    dev->init_clients_state == MEI_ENUM_CLIENTS_MESSAGE) {
+		    dev->hbm_state == MEI_HBM_ENUM_CLIENTS) {
 				dev->init_clients_timer = 0;
 				dev->me_client_presentation_num = 0;
 				dev->me_client_index = 0;
 				mei_hbm_me_cl_allocate(dev);
-				dev->init_clients_state =
-					MEI_CLIENT_PROPERTIES_MESSAGE;
+				dev->hbm_state = MEI_HBM_CLIENT_PROPERTIES;
 
 				/* first property reqeust */
 				mei_hbm_prop_req(dev);
@@ -641,6 +664,9 @@ void mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 		break;
 
 	case HOST_STOP_RES_CMD:
+
+		if (dev->hbm_state != MEI_HBM_STOP)
+			dev_err(&dev->pdev->dev, "unexpected stop response hbm.\n");
 		dev->dev_state = MEI_DEV_DISABLED;
 		dev_info(&dev->pdev->dev, "reset: FW stop response.\n");
 		mei_reset(dev, 1);
@@ -654,6 +680,7 @@ void mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 
 	case ME_STOP_REQ_CMD:
 
+		dev->hbm_state = MEI_HBM_STOP;
 		mei_hbm_stop_req_prepare(dev, &dev->wr_ext_msg.hdr,
 					dev->wr_ext_msg.data);
 		break;
diff --git a/drivers/misc/mei/hbm.h b/drivers/misc/mei/hbm.h
index b552afb..e80dc24 100644
--- a/drivers/misc/mei/hbm.h
+++ b/drivers/misc/mei/hbm.h
@@ -17,6 +17,27 @@
 #ifndef _MEI_HBM_H_
 #define _MEI_HBM_H_
 
+struct mei_device;
+struct mei_msg_hdr;
+struct mei_cl;
+
+/**
+ * enum mei_hbm_state - host bus message protocol state
+ *
+ * @MEI_HBM_IDLE : protocol not started
+ * @MEI_HBM_START : start request message was sent
+ * @MEI_HBM_ENUM_CLIENTS : enumeration request was sent
+ * @MEI_HBM_CLIENT_PROPERTIES : acquiring clients properties
+ */
+enum mei_hbm_state {
+	MEI_HBM_IDLE = 0,
+	MEI_HBM_START,
+	MEI_HBM_ENUM_CLIENTS,
+	MEI_HBM_CLIENT_PROPERTIES,
+	MEI_HBM_STARTED,
+	MEI_HBM_STOP,
+};
+
 void mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr);
 
 static inline void mei_hbm_hdr(struct mei_msg_hdr *hdr, size_t length)
@@ -28,8 +49,8 @@ static inline void mei_hbm_hdr(struct mei_msg_hdr *hdr, size_t length)
 	hdr->reserved = 0;
 }
 
-void mei_hbm_start_req(struct mei_device *dev);
-
+int mei_hbm_start_req(struct mei_device *dev);
+int mei_hbm_start_wait(struct mei_device *dev);
 int mei_hbm_cl_flow_control_req(struct mei_device *dev, struct mei_cl *cl);
 int mei_hbm_cl_disconnect_req(struct mei_device *dev, struct mei_cl *cl);
 int mei_hbm_cl_connect_req(struct mei_device *dev, struct mei_cl *cl);
diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 5ad53eb..3d6dfa3 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -468,8 +468,6 @@ irqreturn_t mei_me_irq_thread_handler(int irq, void *dev_id)
 	struct mei_cl_cb complete_list;
 	s32 slots;
 	int rets;
-	bool  bus_message_received;
-
 
 	dev_dbg(&dev->pdev->dev, "function called after ISR to handle the interrupt processing.\n");
 	/* initialize our complete list */
@@ -525,17 +523,7 @@ end:
 	dev_dbg(&dev->pdev->dev, "end of bottom half function.\n");
 	dev->hbuf_is_ready = mei_hbuf_is_ready(dev);
 
-	bus_message_received = false;
-	if (dev->recvd_msg && waitqueue_active(&dev->wait_recvd_msg)) {
-		dev_dbg(&dev->pdev->dev, "received waiting bus message\n");
-		bus_message_received = true;
-	}
 	mutex_unlock(&dev->device_lock);
-	if (bus_message_received) {
-		dev_dbg(&dev->pdev->dev, "wake up dev->wait_recvd_msg\n");
-		wake_up_interruptible(&dev->wait_recvd_msg);
-		bus_message_received = false;
-	}
 
 	mei_irq_compl_handler(dev, &complete_list);
 
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 4e102ad..59159e0 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -80,8 +80,6 @@ EXPORT_SYMBOL_GPL(mei_device_init);
  */
 int mei_start(struct mei_device *dev)
 {
-	int ret = 0;
-
 	mutex_lock(&dev->device_lock);
 
 	/* acknowledge interrupt and stop interupts */
@@ -89,29 +87,15 @@ int mei_start(struct mei_device *dev)
 
 	mei_hw_config(dev);
 
-	dev->recvd_msg = false;
 	dev_dbg(&dev->pdev->dev, "reset in start the mei device.\n");
 
 	mei_reset(dev, 1);
 
-	/* wait for ME to turn on ME_RDY */
-	if (!dev->recvd_msg) {
-		mutex_unlock(&dev->device_lock);
-		ret = wait_event_interruptible_timeout(dev->wait_recvd_msg,
-			dev->recvd_msg,
-			mei_secs_to_jiffies(MEI_INTEROP_TIMEOUT));
-		mutex_lock(&dev->device_lock);
-	}
-
-	if (ret <= 0 && !dev->recvd_msg) {
-		dev->dev_state = MEI_DEV_DISABLED;
-		dev_dbg(&dev->pdev->dev,
-			"wait_event_interruptible_timeout failed"
-			"on wait for ME to turn on ME_RDY.\n");
+	if (mei_hbm_start_wait(dev)) {
+		dev_err(&dev->pdev->dev, "HBM haven't started");
 		goto err;
 	}
 
-
 	if (!mei_host_is_ready(dev)) {
 		dev_err(&dev->pdev->dev, "host is not ready.\n");
 		goto err;
@@ -128,7 +112,6 @@ int mei_start(struct mei_device *dev)
 		goto err;
 	}
 
-	dev->recvd_msg = false;
 	dev_dbg(&dev->pdev->dev, "link layer has been established.\n");
 
 	mutex_unlock(&dev->device_lock);
@@ -158,6 +141,7 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 
 	mei_hw_reset(dev, interrupts_enabled);
 
+	dev->hbm_state = MEI_HBM_IDLE;
 
 	if (dev->dev_state != MEI_DEV_INITIALIZING) {
 		if (dev->dev_state != MEI_DEV_DISABLED &&
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 9ff8c61..c1cc462 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -623,8 +623,8 @@ void mei_timer(struct work_struct *work)
 		if (dev->dev_state == MEI_DEV_INIT_CLIENTS) {
 			if (dev->init_clients_timer) {
 				if (--dev->init_clients_timer == 0) {
-					dev_err(&dev->pdev->dev, "reset: init clients timeout ,init clients state = %d.\n",
-						dev->init_clients_state);
+					dev_err(&dev->pdev->dev, "reset: init clients timeout hbm_state = %d.\n",
+						dev->hbm_state);
 					mei_reset(dev, 1);
 				}
 			}
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index cb11b36..78b4da5 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -48,7 +48,7 @@
  *
  * @inode: pointer to inode structure
  * @file: pointer to file structure
- *
+ e
  * returns 0 on success, <0 on error
  */
 static int mei_open(struct inode *inode, struct file *file)
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index cd5b6d4..56dee56 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -25,6 +25,7 @@
 
 #include "hw.h"
 #include "hw-me-regs.h"
+#include "hbm.h"
 
 /*
  * watch dog definition
@@ -104,13 +105,6 @@ enum mei_dev_state {
 
 const char *mei_dev_state_str(int state);
 
-/* init clients states*/
-enum mei_init_clients_states {
-	MEI_START_MESSAGE = 0,
-	MEI_ENUM_CLIENTS_MESSAGE,
-	MEI_CLIENT_PROPERTIES_MESSAGE
-};
-
 enum iamthif_states {
 	MEI_IAMTHIF_IDLE,
 	MEI_IAMTHIF_WRITING,
@@ -338,6 +332,7 @@ struct mei_cl_device {
 /**
  * struct mei_device -  MEI private device struct
 
+ * @hbm_state - state of host bus message protocol
  * @mem_addr - mem mapped base register address
 
  * @hbuf_depth - depth of hardware host/write buffer is slots
@@ -370,8 +365,6 @@ struct mei_device {
 	struct delayed_work timer_work;	/* MEI timer delayed work (timeouts) */
 
 	bool recvd_hw_ready;
-	bool recvd_msg;
-
 	/*
 	 * waiting queue for receive message from FW
 	 */
@@ -383,7 +376,7 @@ struct mei_device {
 	 * mei device  states
 	 */
 	enum mei_dev_state dev_state;
-	enum mei_init_clients_states init_clients_state;
+	enum mei_hbm_state hbm_state;
 	u16 init_clients_timer;
 
 	unsigned char rd_msg_buf[MEI_RD_MSG_BUF_SIZE];	/* control messages */
-- 
1.8.1.2


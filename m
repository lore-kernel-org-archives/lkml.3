Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbaBQNTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 08:19:04 -0500
Received: from mga02.intel.com ([134.134.136.20]:4049 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752537AbaBQNOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 08:14:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,860,1384329600"; 
   d="scan'208";a="456852881"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 01/11 RESEND] mei: add mei_hbuf_acquire wrapper
Date: Mon, 17 Feb 2014 15:13:17 +0200
Message-Id: <1392642807-8878-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392642807-8878-1-git-send-email-tomas.winkler@intel.com>
References: <1392642807-8878-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A client has to acquire host buffer
before writing, we add lock like wrapper
to replace the code snippet

if (dev->hbuf_is_ready)
        dev->hbuf_is_ready = false;

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c    |  7 +-----
 drivers/misc/mei/client.c    | 56 ++++++++++++++++++++++++++++----------------
 drivers/misc/mei/hw-me.c     |  2 ++
 drivers/misc/mei/hw-txe.c    | 17 +++++---------
 drivers/misc/mei/interrupt.c |  6 ++---
 drivers/misc/mei/mei_dev.h   |  2 ++
 drivers/misc/mei/wd.c        | 14 +++++------
 7 files changed, 57 insertions(+), 47 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index f88cb26..71af677 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -301,9 +301,8 @@ static int mei_amthif_send_cmd(struct mei_device *dev, struct mei_cl_cb *cb)
 	if (ret < 0)
 		return ret;
 
-	if (ret && dev->hbuf_is_ready) {
+	if (ret && mei_hbuf_acquire(dev)) {
 		ret = 0;
-		dev->hbuf_is_ready = false;
 		if (cb->request_buffer.size > mei_hbuf_max_len(dev)) {
 			mei_hdr.length = mei_hbuf_max_len(dev);
 			mei_hdr.msg_complete = 0;
@@ -335,10 +334,6 @@ static int mei_amthif_send_cmd(struct mei_device *dev, struct mei_cl_cb *cb)
 			list_add_tail(&cb->list, &dev->write_list.list);
 		}
 	} else {
-		if (!dev->hbuf_is_ready)
-			dev_dbg(&dev->pdev->dev, "host buffer is not empty");
-
-		dev_dbg(&dev->pdev->dev, "No flow control credentials, so add iamthif cb to write list.\n");
 		list_add_tail(&cb->list, &dev->write_list.list);
 	}
 	return 0;
diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 9c840ef..24fa85e 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -375,6 +375,23 @@ void mei_host_client_init(struct work_struct *work)
 	mutex_unlock(&dev->device_lock);
 }
 
+/**
+ * mei_hbuf_acquire: try to acquire host buffer
+ *
+ * @dev: the device structure
+ * returns true if host buffer was acquired
+ */
+bool mei_hbuf_acquire(struct mei_device *dev)
+{
+	if (!dev->hbuf_is_ready) {
+		dev_dbg(&dev->pdev->dev, "hbuf is not ready\n");
+		return false;
+	}
+
+	dev->hbuf_is_ready = false;
+
+	return true;
+}
 
 /**
  * mei_cl_disconnect - disconnect host client from the me one
@@ -406,8 +423,7 @@ int mei_cl_disconnect(struct mei_cl *cl)
 		return -ENOMEM;
 
 	cb->fop_type = MEI_FOP_CLOSE;
-	if (dev->hbuf_is_ready) {
-		dev->hbuf_is_ready = false;
+	if (mei_hbuf_acquire(dev)) {
 		if (mei_hbm_cl_disconnect_req(dev, cl)) {
 			rets = -ENODEV;
 			cl_err(dev, cl, "failed to disconnect.\n");
@@ -507,9 +523,8 @@ int mei_cl_connect(struct mei_cl *cl, struct file *file)
 
 	cb->fop_type = MEI_FOP_CONNECT;
 
-	if (dev->hbuf_is_ready && !mei_cl_is_other_connecting(cl)) {
-		dev->hbuf_is_ready = false;
-
+	/* run hbuf acquire last so we don't have to undo */
+	if (!mei_cl_is_other_connecting(cl) && mei_hbuf_acquire(dev)) {
 		if (mei_hbm_cl_connect_req(dev, cl)) {
 			rets = -ENODEV;
 			goto out;
@@ -666,8 +681,7 @@ int mei_cl_read_start(struct mei_cl *cl, size_t length)
 		goto err;
 
 	cb->fop_type = MEI_FOP_READ;
-	if (dev->hbuf_is_ready) {
-		dev->hbuf_is_ready = false;
+	if (mei_hbuf_acquire(dev)) {
 		if (mei_hbm_cl_flow_control_req(dev, cl)) {
 			cl_err(dev, cl, "flow control send failed\n");
 			rets = -ENODEV;
@@ -802,21 +816,29 @@ int mei_cl_write(struct mei_cl *cl, struct mei_cl_cb *cb, bool blocking)
 
 
 	cb->fop_type = MEI_FOP_WRITE;
+	cb->buf_idx = 0;
+	cl->writing_state = MEI_IDLE;
+
+	mei_hdr.host_addr = cl->host_client_id;
+	mei_hdr.me_addr = cl->me_client_id;
+	mei_hdr.reserved = 0;
+	mei_hdr.msg_complete = 0;
+	mei_hdr.internal = cb->internal;
 
 	rets = mei_cl_flow_ctrl_creds(cl);
 	if (rets < 0)
 		goto err;
 
-	/* Host buffer is not ready, we queue the request */
-	if (rets == 0 || !dev->hbuf_is_ready) {
-		cb->buf_idx = 0;
-		/* unseting complete will enqueue the cb for write */
-		mei_hdr.msg_complete = 0;
+	if (rets == 0) {
+		cl_dbg(dev, cl, "No flow control credentials: not sending.\n");
+		rets = buf->size;
+		goto out;
+	}
+	if (!mei_hbuf_acquire(dev)) {
+		cl_dbg(dev, cl, "Cannot acquire the host buffer: not sending.\n");
 		rets = buf->size;
 		goto out;
 	}
-
-	dev->hbuf_is_ready = false;
 
 	/* Check for a maximum length */
 	if (buf->size > mei_hbuf_max_len(dev)) {
@@ -827,12 +849,6 @@ int mei_cl_write(struct mei_cl *cl, struct mei_cl_cb *cb, bool blocking)
 		mei_hdr.msg_complete = 1;
 	}
 
-	mei_hdr.host_addr = cl->host_client_id;
-	mei_hdr.me_addr = cl->me_client_id;
-	mei_hdr.reserved = 0;
-	mei_hdr.internal = cb->internal;
-
-
 	rets = mei_write_message(dev, &mei_hdr, buf->data);
 	if (rets)
 		goto err;
diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 847c9e5..b0c42d6 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -513,6 +513,8 @@ irqreturn_t mei_me_irq_thread_handler(int irq, void *dev_id)
 		}
 	}
 
+	dev->hbuf_is_ready = mei_hbuf_is_ready(dev);
+
 	rets = mei_irq_write_handler(dev, &complete_list);
 
 	dev->hbuf_is_ready = mei_hbuf_is_ready(dev);
diff --git a/drivers/misc/mei/hw-txe.c b/drivers/misc/mei/hw-txe.c
index 19579e5..ab0442e 100644
--- a/drivers/misc/mei/hw-txe.c
+++ b/drivers/misc/mei/hw-txe.c
@@ -604,7 +604,6 @@ static int mei_txe_write(struct mei_device *dev,
 		mei_txe_input_payload_write(dev, i + 1, reg);
 	}
 
-	dev->hbuf_is_ready = false;
 	/* Set Input-Doorbell */
 	mei_txe_input_doorbell_set(hw);
 
@@ -982,20 +981,16 @@ irqreturn_t mei_txe_irq_thread_handler(int irq, void *dev_id)
 		dev->hbuf_is_ready = true;
 
 	if (hw->aliveness && dev->hbuf_is_ready) {
-		/* if SeC did not complete reading the written data by host */
-		if (!mei_txe_is_input_ready(dev)) {
-			dev_dbg(&dev->pdev->dev, "got Input Ready Int, but SEC_IPC_INPUT_STATUS_RDY is 0.\n");
-			goto end;
-		}
 
+		/* get the real register value */
+		dev->hbuf_is_ready = mei_hbuf_is_ready(dev);
 		rets = mei_irq_write_handler(dev, &complete_list);
-		if (rets)
-			dev_err(&dev->pdev->dev,
-				"mei_irq_write_handler ret = %d.\n", rets);
+		if (rets && rets != -EMSGSIZE)
+			dev_err(&dev->pdev->dev, "mei_irq_write_handler ret = %d.\n",
+				rets);
+		dev->hbuf_is_ready = mei_hbuf_is_ready(dev);
 	}
 
-
-
 	mei_irq_compl_handler(dev, &complete_list);
 
 end:
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 75ff409..8f8ab08 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -446,10 +446,10 @@ int mei_irq_write_handler(struct mei_device *dev, struct mei_cl_cb *cmpl_list)
 	s32 slots;
 	int ret;
 
-	if (!mei_hbuf_is_ready(dev)) {
-		dev_dbg(&dev->pdev->dev, "host buffer is not empty.\n");
+
+	if (!mei_hbuf_acquire(dev))
 		return 0;
-	}
+
 	slots = mei_hbuf_empty_slots(dev);
 	if (slots <= 0)
 		return -EMSGSIZE;
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 21e5249..c77b747 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -629,6 +629,8 @@ static inline int mei_count_full_read_slots(struct mei_device *dev)
 	return dev->ops->rdbuf_full_slots(dev);
 }
 
+bool mei_hbuf_acquire(struct mei_device *dev);
+
 #if IS_ENABLED(CONFIG_DEBUG_FS)
 int mei_dbgfs_register(struct mei_device *dev, const char *name);
 void mei_dbgfs_deregister(struct mei_device *dev);
diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index f70945e..a769fb1 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -153,9 +153,8 @@ int mei_wd_stop(struct mei_device *dev)
 	if (ret < 0)
 		goto out;
 
-	if (ret && dev->hbuf_is_ready) {
+	if (ret && mei_hbuf_acquire(dev)) {
 		ret = 0;
-		dev->hbuf_is_ready = false;
 
 		if (!mei_wd_send(dev)) {
 			ret = mei_cl_flow_ctrl_reduce(&dev->wd_cl);
@@ -260,8 +259,8 @@ static int mei_wd_ops_stop(struct watchdog_device *wd_dev)
  */
 static int mei_wd_ops_ping(struct watchdog_device *wd_dev)
 {
-	int ret = 0;
 	struct mei_device *dev;
+	int ret;
 
 	dev = watchdog_get_drvdata(wd_dev);
 	if (!dev)
@@ -277,10 +276,12 @@ static int mei_wd_ops_ping(struct watchdog_device *wd_dev)
 
 	dev->wd_state = MEI_WD_RUNNING;
 
+	ret = mei_cl_flow_ctrl_creds(&dev->wd_cl);
+	if (ret < 0)
+		goto end;
 	/* Check if we can send the ping to HW*/
-	if (dev->hbuf_is_ready && mei_cl_flow_ctrl_creds(&dev->wd_cl) > 0) {
+	if (ret && mei_hbuf_acquire(dev)) {
 
-		dev->hbuf_is_ready = false;
 		dev_dbg(&dev->pdev->dev, "wd: sending ping\n");
 
 		if (mei_wd_send(dev)) {
@@ -290,8 +291,7 @@ static int mei_wd_ops_ping(struct watchdog_device *wd_dev)
 		}
 
 		if (mei_cl_flow_ctrl_reduce(&dev->wd_cl)) {
-			dev_err(&dev->pdev->dev,
-				"wd: mei_cl_flow_ctrl_reduce() failed.\n");
+			dev_err(&dev->pdev->dev, "wd: mei_cl_flow_ctrl_reduce() failed.\n");
 			ret = -EIO;
 			goto end;
 		}
-- 
1.8.5.3


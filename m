Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbaI2Ngw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:36:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:32039 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbaI2NdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:33:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="393030042"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [RESEND char-misc-next 10/18] mei: get rid of most of the pci dependencies in mei
Date: Mon, 29 Sep 2014 16:31:42 +0300
Message-Id: <1411997510-29094-11-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411997510-29094-1-git-send-email-tomas.winkler@intel.com>
References: <1411997510-29094-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For purpose of adding testing HW we would like
to get rid of pci dependency in generic mei code
This patch provides only straight forward changes
FW status and prob quirks need to be handled separately

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c    | 68 ++++++++++++++++++++++----------------------
 drivers/misc/mei/bus.c       | 10 +++----
 drivers/misc/mei/client.c    | 46 +++++++++++++++---------------
 drivers/misc/mei/client.h    |  4 +--
 drivers/misc/mei/debugfs.c   |  6 ++--
 drivers/misc/mei/hbm.c       | 66 +++++++++++++++++++++---------------------
 drivers/misc/mei/hw-me.c     | 30 +++++++++----------
 drivers/misc/mei/hw-txe.c    | 53 ++++++++++++++++------------------
 drivers/misc/mei/init.c      | 42 +++++++++++++--------------
 drivers/misc/mei/interrupt.c | 44 ++++++++++++++--------------
 drivers/misc/mei/main.c      | 40 +++++++++++++-------------
 drivers/misc/mei/nfc.c       | 43 +++++++++++++---------------
 drivers/misc/mei/pci-me.c    |  2 +-
 drivers/misc/mei/pci-txe.c   |  2 +-
 drivers/misc/mei/wd.c        | 34 ++++++++++------------
 15 files changed, 239 insertions(+), 251 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index 1f80873..5d47d1b 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -78,7 +78,7 @@ int mei_amthif_host_init(struct mei_device *dev)
 
 	me_cl = mei_me_cl_by_uuid(dev, &mei_amthif_guid);
 	if (!me_cl) {
-		dev_info(&dev->pdev->dev, "amthif: failed to find the client");
+		dev_info(dev->dev, "amthif: failed to find the client");
 		return -ENOTTY;
 	}
 
@@ -88,7 +88,7 @@ int mei_amthif_host_init(struct mei_device *dev)
 	/* Assign iamthif_mtu to the value received from ME  */
 
 	dev->iamthif_mtu = me_cl->props.max_msg_length;
-	dev_dbg(&dev->pdev->dev, "IAMTHIF_MTU = %d\n", dev->iamthif_mtu);
+	dev_dbg(dev->dev, "IAMTHIF_MTU = %d\n", dev->iamthif_mtu);
 
 	kfree(dev->iamthif_msg_buf);
 	dev->iamthif_msg_buf = NULL;
@@ -104,7 +104,7 @@ int mei_amthif_host_init(struct mei_device *dev)
 	ret = mei_cl_link(cl, MEI_IAMTHIF_HOST_CLIENT_ID);
 
 	if (ret < 0) {
-		dev_err(&dev->pdev->dev,
+		dev_err(dev->dev,
 			"amthif: failed link client %d\n", ret);
 		return ret;
 	}
@@ -164,11 +164,11 @@ int mei_amthif_read(struct mei_device *dev, struct file *file,
 
 	/* Only possible if we are in timeout */
 	if (!cl) {
-		dev_err(&dev->pdev->dev, "bad file ext.\n");
+		dev_err(dev->dev, "bad file ext.\n");
 		return -ETIME;
 	}
 
-	dev_dbg(&dev->pdev->dev, "checking amthif data\n");
+	dev_dbg(dev->dev, "checking amthif data\n");
 	cb = mei_amthif_find_read_list_entry(dev, file);
 
 	/* Check for if we can block or not*/
@@ -176,7 +176,7 @@ int mei_amthif_read(struct mei_device *dev, struct file *file,
 		return -EAGAIN;
 
 
-	dev_dbg(&dev->pdev->dev, "waiting for amthif data\n");
+	dev_dbg(dev->dev, "waiting for amthif data\n");
 	while (cb == NULL) {
 		/* unlock the Mutex */
 		mutex_unlock(&dev->device_lock);
@@ -190,21 +190,21 @@ int mei_amthif_read(struct mei_device *dev, struct file *file,
 		if (wait_ret)
 			return -ERESTARTSYS;
 
-		dev_dbg(&dev->pdev->dev, "woke up from sleep\n");
+		dev_dbg(dev->dev, "woke up from sleep\n");
 	}
 
 
-	dev_dbg(&dev->pdev->dev, "Got amthif data\n");
+	dev_dbg(dev->dev, "Got amthif data\n");
 	dev->iamthif_timer = 0;
 
 	if (cb) {
 		timeout = cb->read_time +
 			mei_secs_to_jiffies(MEI_IAMTHIF_READ_TIMER);
-		dev_dbg(&dev->pdev->dev, "amthif timeout = %lud\n",
+		dev_dbg(dev->dev, "amthif timeout = %lud\n",
 				timeout);
 
 		if  (time_after(jiffies, timeout)) {
-			dev_dbg(&dev->pdev->dev, "amthif Time out\n");
+			dev_dbg(dev->dev, "amthif Time out\n");
 			/* 15 sec for the message has expired */
 			list_del(&cb->list);
 			rets = -ETIME;
@@ -224,16 +224,16 @@ int mei_amthif_read(struct mei_device *dev, struct file *file,
 		 * remove message from deletion list
 		 */
 
-	dev_dbg(&dev->pdev->dev, "amthif cb->response_buffer size - %d\n",
+	dev_dbg(dev->dev, "amthif cb->response_buffer size - %d\n",
 	    cb->response_buffer.size);
-	dev_dbg(&dev->pdev->dev, "amthif cb->buf_idx - %lu\n", cb->buf_idx);
+	dev_dbg(dev->dev, "amthif cb->buf_idx - %lu\n", cb->buf_idx);
 
 	/* length is being truncated to PAGE_SIZE, however,
 	 * the buf_idx may point beyond */
 	length = min_t(size_t, length, (cb->buf_idx - *offset));
 
 	if (copy_to_user(ubuf, cb->response_buffer.data + *offset, length)) {
-		dev_dbg(&dev->pdev->dev, "failed to copy data to userland\n");
+		dev_dbg(dev->dev, "failed to copy data to userland\n");
 		rets = -EFAULT;
 	} else {
 		rets = length;
@@ -243,7 +243,7 @@ int mei_amthif_read(struct mei_device *dev, struct file *file,
 		}
 	}
 free:
-	dev_dbg(&dev->pdev->dev, "free amthif cb memory.\n");
+	dev_dbg(dev->dev, "free amthif cb memory.\n");
 	*offset = 0;
 	mei_io_cb_free(cb);
 out:
@@ -267,7 +267,7 @@ static int mei_amthif_send_cmd(struct mei_device *dev, struct mei_cl_cb *cb)
 	if (!dev || !cb)
 		return -ENODEV;
 
-	dev_dbg(&dev->pdev->dev, "write data to amthif client.\n");
+	dev_dbg(dev->dev, "write data to amthif client.\n");
 
 	dev->iamthif_state = MEI_IAMTHIF_WRITING;
 	dev->iamthif_current_cb = cb;
@@ -306,12 +306,12 @@ static int mei_amthif_send_cmd(struct mei_device *dev, struct mei_cl_cb *cb)
 				return -EIO;
 			dev->iamthif_flow_control_pending = true;
 			dev->iamthif_state = MEI_IAMTHIF_FLOW_CONTROL;
-			dev_dbg(&dev->pdev->dev, "add amthif cb to write waiting list\n");
+			dev_dbg(dev->dev, "add amthif cb to write waiting list\n");
 			dev->iamthif_current_cb = cb;
 			dev->iamthif_file_object = cb->file_object;
 			list_add_tail(&cb->list, &dev->write_waiting_list.list);
 		} else {
-			dev_dbg(&dev->pdev->dev, "message does not complete, so add amthif cb to write list.\n");
+			dev_dbg(dev->dev, "message does not complete, so add amthif cb to write list.\n");
 			list_add_tail(&cb->list, &dev->write_list.list);
 		}
 	} else {
@@ -344,9 +344,9 @@ int mei_amthif_write(struct mei_device *dev, struct mei_cl_cb *cb)
 
 	if (!list_empty(&dev->amthif_cmd_list.list) ||
 	    dev->iamthif_state != MEI_IAMTHIF_IDLE) {
-		dev_dbg(&dev->pdev->dev,
+		dev_dbg(dev->dev,
 			"amthif state = %d\n", dev->iamthif_state);
-		dev_dbg(&dev->pdev->dev, "AMTHIF: add cb to the wait list\n");
+		dev_dbg(dev->dev, "AMTHIF: add cb to the wait list\n");
 		list_add_tail(&cb->list, &dev->amthif_cmd_list.list);
 		return 0;
 	}
@@ -376,7 +376,7 @@ void mei_amthif_run_next_cmd(struct mei_device *dev)
 	dev->iamthif_timer = 0;
 	dev->iamthif_file_object = NULL;
 
-	dev_dbg(&dev->pdev->dev, "complete amthif cmd_list cb.\n");
+	dev_dbg(dev->dev, "complete amthif cmd_list cb.\n");
 
 	list_for_each_entry_safe(cb, next, &dev->amthif_cmd_list.list, list) {
 		list_del(&cb->list);
@@ -384,7 +384,7 @@ void mei_amthif_run_next_cmd(struct mei_device *dev)
 			continue;
 		status = mei_amthif_send_cmd(dev, cb);
 		if (status)
-			dev_warn(&dev->pdev->dev, "amthif write failed status = %d\n",
+			dev_warn(dev->dev, "amthif write failed status = %d\n",
 						status);
 		break;
 	}
@@ -407,7 +407,7 @@ unsigned int mei_amthif_poll(struct mei_device *dev,
 		   dev->iamthif_file_object == file) {
 
 		mask |= (POLLIN | POLLRDNORM);
-		dev_dbg(&dev->pdev->dev, "run next amthif cb\n");
+		dev_dbg(dev->dev, "run next amthif cb\n");
 		mei_amthif_run_next_cmd(dev);
 	}
 	mutex_unlock(&dev->device_lock);
@@ -467,7 +467,7 @@ int mei_amthif_irq_write(struct mei_cl *cl, struct mei_cl_cb *cb,
 		return 0;
 	}
 
-	dev_dbg(&dev->pdev->dev, MEI_HDR_FMT,  MEI_HDR_PRM(&mei_hdr));
+	dev_dbg(dev->dev, MEI_HDR_FMT,  MEI_HDR_PRM(&mei_hdr));
 
 	rets = mei_write_message(dev, &mei_hdr,
 			dev->iamthif_msg_buf + dev->iamthif_msg_buf_index);
@@ -529,10 +529,10 @@ int mei_amthif_irq_read_msg(struct mei_device *dev,
 	if (!mei_hdr->msg_complete)
 		return 0;
 
-	dev_dbg(&dev->pdev->dev, "amthif_message_buffer_index =%d\n",
+	dev_dbg(dev->dev, "amthif_message_buffer_index =%d\n",
 			mei_hdr->length);
 
-	dev_dbg(&dev->pdev->dev, "completed amthif read.\n ");
+	dev_dbg(dev->dev, "completed amthif read.\n ");
 	if (!dev->iamthif_current_cb)
 		return -ENODEV;
 
@@ -547,8 +547,8 @@ int mei_amthif_irq_read_msg(struct mei_device *dev,
 	cb->read_time = jiffies;
 	if (dev->iamthif_ioctl) {
 		/* found the iamthif cb */
-		dev_dbg(&dev->pdev->dev, "complete the amthif read cb.\n ");
-		dev_dbg(&dev->pdev->dev, "add the amthif read cb to complete.\n ");
+		dev_dbg(dev->dev, "complete the amthif read cb.\n ");
+		dev_dbg(dev->dev, "add the amthif read cb to complete.\n ");
 		list_add_tail(&cb->list, &complete_list->list);
 	}
 	return 0;
@@ -572,11 +572,11 @@ int mei_amthif_irq_read(struct mei_device *dev, s32 *slots)
 	*slots -= msg_slots;
 
 	if (mei_hbm_cl_flow_control_req(dev, &dev->iamthif_cl)) {
-		dev_dbg(&dev->pdev->dev, "iamthif flow control failed\n");
+		dev_dbg(dev->dev, "iamthif flow control failed\n");
 		return -EIO;
 	}
 
-	dev_dbg(&dev->pdev->dev, "iamthif flow control success\n");
+	dev_dbg(dev->dev, "iamthif flow control success\n");
 	dev->iamthif_state = MEI_IAMTHIF_READING;
 	dev->iamthif_flow_control_pending = false;
 	dev->iamthif_msg_buf_index = 0;
@@ -601,15 +601,15 @@ void mei_amthif_complete(struct mei_device *dev, struct mei_cl_cb *cb)
 				dev->iamthif_msg_buf,
 				dev->iamthif_msg_buf_index);
 		list_add_tail(&cb->list, &dev->amthif_rd_complete_list.list);
-		dev_dbg(&dev->pdev->dev, "amthif read completed\n");
+		dev_dbg(dev->dev, "amthif read completed\n");
 		dev->iamthif_timer = jiffies;
-		dev_dbg(&dev->pdev->dev, "dev->iamthif_timer = %ld\n",
+		dev_dbg(dev->dev, "dev->iamthif_timer = %ld\n",
 				dev->iamthif_timer);
 	} else {
 		mei_amthif_run_next_cmd(dev);
 	}
 
-	dev_dbg(&dev->pdev->dev, "completing amthif call back.\n");
+	dev_dbg(dev->dev, "completing amthif call back.\n");
 	wake_up_interruptible(&dev->iamthif_cl.wait);
 }
 
@@ -715,11 +715,11 @@ int mei_amthif_release(struct mei_device *dev, struct file *file)
 	if (dev->iamthif_file_object == file &&
 	    dev->iamthif_state != MEI_IAMTHIF_IDLE) {
 
-		dev_dbg(&dev->pdev->dev, "amthif canceled iamthif state %d\n",
+		dev_dbg(dev->dev, "amthif canceled iamthif state %d\n",
 		    dev->iamthif_state);
 		dev->iamthif_canceled = true;
 		if (dev->iamthif_state == MEI_IAMTHIF_READ_COMPLETE) {
-			dev_dbg(&dev->pdev->dev, "run next amthif iamthif cb\n");
+			dev_dbg(dev->dev, "run next amthif iamthif cb\n");
 			mei_amthif_run_next_cmd(dev);
 		}
 	}
diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 1cf3a72..4cc1a66 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -172,7 +172,7 @@ struct mei_cl_device *mei_cl_add_device(struct mei_device *dev,
 	device->cl = cl;
 	device->ops = ops;
 
-	device->dev.parent = &dev->pdev->dev;
+	device->dev.parent = dev->dev;
 	device->dev.bus = &mei_cl_bus_type;
 	device->dev.type = &mei_cl_device_type;
 
@@ -180,7 +180,7 @@ struct mei_cl_device *mei_cl_add_device(struct mei_device *dev,
 
 	status = device_register(&device->dev);
 	if (status) {
-		dev_err(&dev->pdev->dev, "Failed to register MEI device\n");
+		dev_err(dev->dev, "Failed to register MEI device\n");
 		kfree(device);
 		return NULL;
 	}
@@ -430,7 +430,7 @@ int mei_cl_enable_device(struct mei_cl_device *device)
 	err = mei_cl_connect(cl, NULL);
 	if (err < 0) {
 		mutex_unlock(&dev->device_lock);
-		dev_err(&dev->pdev->dev, "Could not connect to the ME client");
+		dev_err(dev->dev, "Could not connect to the ME client");
 
 		return err;
 	}
@@ -462,7 +462,7 @@ int mei_cl_disable_device(struct mei_cl_device *device)
 
 	if (cl->state != MEI_FILE_CONNECTED) {
 		mutex_unlock(&dev->device_lock);
-		dev_err(&dev->pdev->dev, "Already disconnected");
+		dev_err(dev->dev, "Already disconnected");
 
 		return 0;
 	}
@@ -472,7 +472,7 @@ int mei_cl_disable_device(struct mei_cl_device *device)
 	err = mei_cl_disconnect(cl);
 	if (err < 0) {
 		mutex_unlock(&dev->device_lock);
-		dev_err(&dev->pdev->dev,
+		dev_err(dev->dev,
 			"Could not disconnect from the ME client");
 
 		return err;
diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index b7f21d4..bfc3ad2 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -363,13 +363,13 @@ int mei_cl_link(struct mei_cl *cl, int id)
 					MEI_CLIENTS_MAX);
 
 	if (id >= MEI_CLIENTS_MAX) {
-		dev_err(&dev->pdev->dev, "id exceeded %d", MEI_CLIENTS_MAX);
+		dev_err(dev->dev, "id exceeded %d", MEI_CLIENTS_MAX);
 		return -EMFILE;
 	}
 
 	open_handle_count = dev->open_handle_count + dev->iamthif_open_count;
 	if (open_handle_count >= MEI_MAX_OPEN_HANDLE_COUNT) {
-		dev_err(&dev->pdev->dev, "open_handle_count exceeded %d",
+		dev_err(dev->dev, "open_handle_count exceeded %d",
 			MEI_MAX_OPEN_HANDLE_COUNT);
 		return -EMFILE;
 	}
@@ -449,9 +449,9 @@ void mei_host_client_init(struct work_struct *work)
 
 	mutex_unlock(&dev->device_lock);
 
-	pm_runtime_mark_last_busy(&dev->pdev->dev);
-	dev_dbg(&dev->pdev->dev, "rpm: autosuspend\n");
-	pm_runtime_autosuspend(&dev->pdev->dev);
+	pm_runtime_mark_last_busy(dev->dev);
+	dev_dbg(dev->dev, "rpm: autosuspend\n");
+	pm_runtime_autosuspend(dev->dev);
 }
 
 /**
@@ -464,12 +464,12 @@ bool mei_hbuf_acquire(struct mei_device *dev)
 {
 	if (mei_pg_state(dev) == MEI_PG_ON ||
 	    dev->pg_event == MEI_PG_EVENT_WAIT) {
-		dev_dbg(&dev->pdev->dev, "device is in pg\n");
+		dev_dbg(dev->dev, "device is in pg\n");
 		return false;
 	}
 
 	if (!dev->hbuf_is_ready) {
-		dev_dbg(&dev->pdev->dev, "hbuf is not ready\n");
+		dev_dbg(dev->dev, "hbuf is not ready\n");
 		return false;
 	}
 
@@ -503,9 +503,9 @@ int mei_cl_disconnect(struct mei_cl *cl)
 	if (cl->state != MEI_FILE_DISCONNECTING)
 		return 0;
 
-	rets = pm_runtime_get(&dev->pdev->dev);
+	rets = pm_runtime_get(dev->dev);
 	if (rets < 0 && rets != -EINPROGRESS) {
-		pm_runtime_put_noidle(&dev->pdev->dev);
+		pm_runtime_put_noidle(dev->dev);
 		cl_err(dev, cl, "rpm: get failed %d\n", rets);
 		return rets;
 	}
@@ -552,8 +552,8 @@ int mei_cl_disconnect(struct mei_cl *cl)
 	mei_io_list_flush(&dev->ctrl_wr_list, cl);
 free:
 	cl_dbg(dev, cl, "rpm: autosuspend\n");
-	pm_runtime_mark_last_busy(&dev->pdev->dev);
-	pm_runtime_put_autosuspend(&dev->pdev->dev);
+	pm_runtime_mark_last_busy(dev->dev);
+	pm_runtime_put_autosuspend(dev->dev);
 
 	mei_io_cb_free(cb);
 	return rets;
@@ -609,9 +609,9 @@ int mei_cl_connect(struct mei_cl *cl, struct file *file)
 
 	dev = cl->dev;
 
-	rets = pm_runtime_get(&dev->pdev->dev);
+	rets = pm_runtime_get(dev->dev);
 	if (rets < 0 && rets != -EINPROGRESS) {
-		pm_runtime_put_noidle(&dev->pdev->dev);
+		pm_runtime_put_noidle(dev->dev);
 		cl_err(dev, cl, "rpm: get failed %d\n", rets);
 		return rets;
 	}
@@ -659,8 +659,8 @@ int mei_cl_connect(struct mei_cl *cl, struct file *file)
 
 out:
 	cl_dbg(dev, cl, "rpm: autosuspend\n");
-	pm_runtime_mark_last_busy(&dev->pdev->dev);
-	pm_runtime_put_autosuspend(&dev->pdev->dev);
+	pm_runtime_mark_last_busy(dev->dev);
+	pm_runtime_put_autosuspend(dev->dev);
 
 	mei_io_cb_free(cb);
 	return rets;
@@ -772,9 +772,9 @@ int mei_cl_read_start(struct mei_cl *cl, size_t length)
 		return  -ENOTTY;
 	}
 
-	rets = pm_runtime_get(&dev->pdev->dev);
+	rets = pm_runtime_get(dev->dev);
 	if (rets < 0 && rets != -EINPROGRESS) {
-		pm_runtime_put_noidle(&dev->pdev->dev);
+		pm_runtime_put_noidle(dev->dev);
 		cl_err(dev, cl, "rpm: get failed %d\n", rets);
 		return rets;
 	}
@@ -806,8 +806,8 @@ int mei_cl_read_start(struct mei_cl *cl, size_t length)
 
 out:
 	cl_dbg(dev, cl, "rpm: autosuspend\n");
-	pm_runtime_mark_last_busy(&dev->pdev->dev);
-	pm_runtime_put_autosuspend(&dev->pdev->dev);
+	pm_runtime_mark_last_busy(dev->dev);
+	pm_runtime_put_autosuspend(dev->dev);
 
 	if (rets)
 		mei_io_cb_free(cb);
@@ -928,9 +928,9 @@ int mei_cl_write(struct mei_cl *cl, struct mei_cl_cb *cb, bool blocking)
 
 	cl_dbg(dev, cl, "mei_cl_write %d\n", buf->size);
 
-	rets = pm_runtime_get(&dev->pdev->dev);
+	rets = pm_runtime_get(dev->dev);
 	if (rets < 0 && rets != -EINPROGRESS) {
-		pm_runtime_put_noidle(&dev->pdev->dev);
+		pm_runtime_put_noidle(dev->dev);
 		cl_err(dev, cl, "rpm: get failed %d\n", rets);
 		return rets;
 	}
@@ -1005,8 +1005,8 @@ out:
 	rets = buf->size;
 err:
 	cl_dbg(dev, cl, "rpm: autosuspend\n");
-	pm_runtime_mark_last_busy(&dev->pdev->dev);
-	pm_runtime_put_autosuspend(&dev->pdev->dev);
+	pm_runtime_mark_last_busy(dev->dev);
+	pm_runtime_put_autosuspend(dev->dev);
 
 	return rets;
 }
diff --git a/drivers/misc/mei/client.h b/drivers/misc/mei/client.h
index f5d03d6..d9d0c15 100644
--- a/drivers/misc/mei/client.h
+++ b/drivers/misc/mei/client.h
@@ -110,9 +110,9 @@ void mei_cl_all_write_clear(struct mei_device *dev);
 #define MEI_CL_PRM(cl) (cl)->host_client_id, (cl)->me_client_id
 
 #define cl_dbg(dev, cl, format, arg...) \
-	dev_dbg(&(dev)->pdev->dev, MEI_CL_FMT format, MEI_CL_PRM(cl), ##arg)
+	dev_dbg((dev)->dev, MEI_CL_FMT format, MEI_CL_PRM(cl), ##arg)
 
 #define cl_err(dev, cl, format, arg...) \
-	dev_err(&(dev)->pdev->dev, MEI_CL_FMT format, MEI_CL_PRM(cl), ##arg)
+	dev_err((dev)->dev, MEI_CL_FMT format, MEI_CL_PRM(cl), ##arg)
 
 #endif /* _MEI_CLIENT_H_ */
diff --git a/drivers/misc/mei/debugfs.c b/drivers/misc/mei/debugfs.c
index f15139d..e14a7db 100644
--- a/drivers/misc/mei/debugfs.c
+++ b/drivers/misc/mei/debugfs.c
@@ -187,19 +187,19 @@ int mei_dbgfs_register(struct mei_device *dev, const char *name)
 	f = debugfs_create_file("meclients", S_IRUSR, dir,
 				dev, &mei_dbgfs_fops_meclients);
 	if (!f) {
-		dev_err(&dev->pdev->dev, "meclients: registration failed\n");
+		dev_err(dev->dev, "meclients: registration failed\n");
 		goto err;
 	}
 	f = debugfs_create_file("active", S_IRUSR, dir,
 				dev, &mei_dbgfs_fops_active);
 	if (!f) {
-		dev_err(&dev->pdev->dev, "meclients: registration failed\n");
+		dev_err(dev->dev, "meclients: registration failed\n");
 		goto err;
 	}
 	f = debugfs_create_file("devstate", S_IRUSR, dir,
 				dev, &mei_dbgfs_fops_devstate);
 	if (!f) {
-		dev_err(&dev->pdev->dev, "devstate: registration failed\n");
+		dev_err(dev->dev, "devstate: registration failed\n");
 		goto err;
 	}
 	dev->dbgfs_dir = dir;
diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 271c240..209650b 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -248,7 +248,7 @@ int mei_hbm_start_wait(struct mei_device *dev)
 
 	if (ret == 0 && (dev->hbm_state <= MEI_HBM_STARTING)) {
 		dev->hbm_state = MEI_HBM_IDLE;
-		dev_err(&dev->pdev->dev, "waiting for mei start failed\n");
+		dev_err(dev->dev, "waiting for mei start failed\n");
 		return -ETIME;
 	}
 	return 0;
@@ -282,7 +282,7 @@ int mei_hbm_start_req(struct mei_device *dev)
 	dev->hbm_state = MEI_HBM_IDLE;
 	ret = mei_write_message(dev, mei_hdr, dev->wr_msg.data);
 	if (ret) {
-		dev_err(&dev->pdev->dev, "version message write failed: ret = %d\n",
+		dev_err(dev->dev, "version message write failed: ret = %d\n",
 			ret);
 		return ret;
 	}
@@ -315,7 +315,7 @@ static int mei_hbm_enum_clients_req(struct mei_device *dev)
 
 	ret = mei_write_message(dev, mei_hdr, dev->wr_msg.data);
 	if (ret) {
-		dev_err(&dev->pdev->dev, "enumeration request write failed: ret = %d.\n",
+		dev_err(dev->dev, "enumeration request write failed: ret = %d.\n",
 			ret);
 		return ret;
 	}
@@ -388,7 +388,7 @@ static int mei_hbm_prop_req(struct mei_device *dev)
 
 	ret = mei_write_message(dev, mei_hdr, dev->wr_msg.data);
 	if (ret) {
-		dev_err(&dev->pdev->dev, "properties request write failed: ret = %d\n",
+		dev_err(dev->dev, "properties request write failed: ret = %d\n",
 			ret);
 		return ret;
 	}
@@ -426,7 +426,7 @@ int mei_hbm_pg(struct mei_device *dev, u8 pg_cmd)
 
 	ret = mei_write_message(dev, mei_hdr, dev->wr_msg.data);
 	if (ret)
-		dev_err(&dev->pdev->dev, "power gate command write failed.\n");
+		dev_err(dev->dev, "power gate command write failed.\n");
 	return ret;
 }
 EXPORT_SYMBOL_GPL(mei_hbm_pg);
@@ -486,7 +486,7 @@ static int mei_hbm_add_single_flow_creds(struct mei_device *dev,
 
 	me_cl = mei_me_cl_by_id(dev, flow->me_addr);
 	if (!me_cl) {
-		dev_err(&dev->pdev->dev, "no such me client %d\n",
+		dev_err(dev->dev, "no such me client %d\n",
 			flow->me_addr);
 		return -ENOENT;
 	}
@@ -495,7 +495,7 @@ static int mei_hbm_add_single_flow_creds(struct mei_device *dev,
 		return -EINVAL;
 
 	me_cl->mei_flow_ctrl_creds++;
-	dev_dbg(&dev->pdev->dev, "recv flow ctrl msg ME %d (single) creds = %d.\n",
+	dev_dbg(dev->dev, "recv flow ctrl msg ME %d (single) creds = %d.\n",
 	    flow->me_addr, me_cl->mei_flow_ctrl_creds);
 
 	return 0;
@@ -570,7 +570,7 @@ static void mei_hbm_cl_disconnect_res(struct mei_cl *cl,
 	struct hbm_client_connect_response *rs =
 		(struct hbm_client_connect_response *)cmd;
 
-	dev_dbg(&cl->dev->pdev->dev, "hbm: disconnect response cl:host=%02d me=%02d status=%d\n",
+	dev_dbg(cl->dev->dev, "hbm: disconnect response cl:host=%02d me=%02d status=%d\n",
 			rs->me_addr, rs->host_addr, rs->status);
 
 	if (rs->status == MEI_CL_DISCONN_SUCCESS)
@@ -606,7 +606,7 @@ static void mei_hbm_cl_connect_res(struct mei_cl *cl,
 	struct hbm_client_connect_response *rs =
 		(struct hbm_client_connect_response *)cmd;
 
-	dev_dbg(&cl->dev->pdev->dev, "hbm: connect response cl:host=%02d me=%02d status=%s\n",
+	dev_dbg(cl->dev->dev, "hbm: connect response cl:host=%02d me=%02d status=%s\n",
 			rs->me_addr, rs->host_addr,
 			mei_cl_conn_status_str(rs->status));
 
@@ -763,19 +763,19 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 	 * hbm is put to idle during system reset
 	 */
 	if (dev->hbm_state == MEI_HBM_IDLE) {
-		dev_dbg(&dev->pdev->dev, "hbm: state is idle ignore spurious messages\n");
+		dev_dbg(dev->dev, "hbm: state is idle ignore spurious messages\n");
 		return 0;
 	}
 
 	switch (mei_msg->hbm_cmd) {
 	case HOST_START_RES_CMD:
-		dev_dbg(&dev->pdev->dev, "hbm: start: response message received.\n");
+		dev_dbg(dev->dev, "hbm: start: response message received.\n");
 
 		dev->init_clients_timer = 0;
 
 		version_res = (struct hbm_host_version_response *)mei_msg;
 
-		dev_dbg(&dev->pdev->dev, "HBM VERSION: DRIVER=%02d:%02d DEVICE=%02d:%02d\n",
+		dev_dbg(dev->dev, "HBM VERSION: DRIVER=%02d:%02d DEVICE=%02d:%02d\n",
 				HBM_MAJOR_VERSION, HBM_MINOR_VERSION,
 				version_res->me_max_version.major_version,
 				version_res->me_max_version.minor_version);
@@ -791,11 +791,11 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 		}
 
 		if (!mei_hbm_version_is_supported(dev)) {
-			dev_warn(&dev->pdev->dev, "hbm: start: version mismatch - stopping the driver.\n");
+			dev_warn(dev->dev, "hbm: start: version mismatch - stopping the driver.\n");
 
 			dev->hbm_state = MEI_HBM_STOPPED;
 			if (mei_hbm_stop_req(dev)) {
-				dev_err(&dev->pdev->dev, "hbm: start: failed to send stop request\n");
+				dev_err(dev->dev, "hbm: start: failed to send stop request\n");
 				return -EIO;
 			}
 			break;
@@ -805,7 +805,7 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 
 		if (dev->dev_state != MEI_DEV_INIT_CLIENTS ||
 		    dev->hbm_state != MEI_HBM_STARTING) {
-			dev_err(&dev->pdev->dev, "hbm: start: state mismatch, [%d, %d]\n",
+			dev_err(dev->dev, "hbm: start: state mismatch, [%d, %d]\n",
 				dev->dev_state, dev->hbm_state);
 			return -EPROTO;
 		}
@@ -813,7 +813,7 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 		dev->hbm_state = MEI_HBM_STARTED;
 
 		if (mei_hbm_enum_clients_req(dev)) {
-			dev_err(&dev->pdev->dev, "hbm: start: failed to send enumeration request\n");
+			dev_err(dev->dev, "hbm: start: failed to send enumeration request\n");
 			return -EIO;
 		}
 
@@ -821,31 +821,31 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 		break;
 
 	case CLIENT_CONNECT_RES_CMD:
-		dev_dbg(&dev->pdev->dev, "hbm: client connect response: message received.\n");
+		dev_dbg(dev->dev, "hbm: client connect response: message received.\n");
 		mei_hbm_cl_res(dev, cl_cmd, MEI_FOP_CONNECT);
 		break;
 
 	case CLIENT_DISCONNECT_RES_CMD:
-		dev_dbg(&dev->pdev->dev, "hbm: client disconnect response: message received.\n");
+		dev_dbg(dev->dev, "hbm: client disconnect response: message received.\n");
 		mei_hbm_cl_res(dev, cl_cmd, MEI_FOP_DISCONNECT);
 		break;
 
 	case MEI_FLOW_CONTROL_CMD:
-		dev_dbg(&dev->pdev->dev, "hbm: client flow control response: message received.\n");
+		dev_dbg(dev->dev, "hbm: client flow control response: message received.\n");
 
 		flow_control = (struct hbm_flow_control *) mei_msg;
 		mei_hbm_cl_flow_control_res(dev, flow_control);
 		break;
 
 	case MEI_PG_ISOLATION_ENTRY_RES_CMD:
-		dev_dbg(&dev->pdev->dev, "power gate isolation entry response received\n");
+		dev_dbg(dev->dev, "power gate isolation entry response received\n");
 		dev->pg_event = MEI_PG_EVENT_RECEIVED;
 		if (waitqueue_active(&dev->wait_pg))
 			wake_up(&dev->wait_pg);
 		break;
 
 	case MEI_PG_ISOLATION_EXIT_REQ_CMD:
-		dev_dbg(&dev->pdev->dev, "power gate isolation exit request received\n");
+		dev_dbg(dev->dev, "power gate isolation exit request received\n");
 		dev->pg_event = MEI_PG_EVENT_RECEIVED;
 		if (waitqueue_active(&dev->wait_pg))
 			wake_up(&dev->wait_pg);
@@ -855,17 +855,17 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 			* this is HW initiated exit from PG.
 			* Start runtime pm resume sequence to exit from PG.
 			*/
-			pm_request_resume(&dev->pdev->dev);
+			pm_request_resume(dev->dev);
 		break;
 
 	case HOST_CLIENT_PROPERTIES_RES_CMD:
-		dev_dbg(&dev->pdev->dev, "hbm: properties response: message received.\n");
+		dev_dbg(dev->dev, "hbm: properties response: message received.\n");
 
 		dev->init_clients_timer = 0;
 
 		if (dev->dev_state != MEI_DEV_INIT_CLIENTS ||
 		    dev->hbm_state != MEI_HBM_CLIENT_PROPERTIES) {
-			dev_err(&dev->pdev->dev, "hbm: properties response: state mismatch, [%d, %d]\n",
+			dev_err(dev->dev, "hbm: properties response: state mismatch, [%d, %d]\n",
 				dev->dev_state, dev->hbm_state);
 			return -EPROTO;
 		}
@@ -873,7 +873,7 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 		props_res = (struct hbm_props_response *)mei_msg;
 
 		if (props_res->status) {
-			dev_err(&dev->pdev->dev, "hbm: properties response: wrong status = %d %s\n",
+			dev_err(dev->dev, "hbm: properties response: wrong status = %d %s\n",
 				props_res->status,
 				mei_hbm_status_str(props_res->status));
 			return -EPROTO;
@@ -891,7 +891,7 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 		break;
 
 	case HOST_ENUM_RES_CMD:
-		dev_dbg(&dev->pdev->dev, "hbm: enumeration response: message received\n");
+		dev_dbg(dev->dev, "hbm: enumeration response: message received\n");
 
 		dev->init_clients_timer = 0;
 
@@ -903,7 +903,7 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 
 		if (dev->dev_state != MEI_DEV_INIT_CLIENTS ||
 		    dev->hbm_state != MEI_HBM_ENUM_CLIENTS) {
-			dev_err(&dev->pdev->dev, "hbm: enumeration response: state mismatch, [%d, %d]\n",
+			dev_err(dev->dev, "hbm: enumeration response: state mismatch, [%d, %d]\n",
 				dev->dev_state, dev->hbm_state);
 			return -EPROTO;
 		}
@@ -917,34 +917,34 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 		break;
 
 	case HOST_STOP_RES_CMD:
-		dev_dbg(&dev->pdev->dev, "hbm: stop response: message received\n");
+		dev_dbg(dev->dev, "hbm: stop response: message received\n");
 
 		dev->init_clients_timer = 0;
 
 		if (dev->hbm_state != MEI_HBM_STOPPED) {
-			dev_err(&dev->pdev->dev, "hbm: stop response: state mismatch, [%d, %d]\n",
+			dev_err(dev->dev, "hbm: stop response: state mismatch, [%d, %d]\n",
 				dev->dev_state, dev->hbm_state);
 			return -EPROTO;
 		}
 
 		dev->dev_state = MEI_DEV_POWER_DOWN;
-		dev_info(&dev->pdev->dev, "hbm: stop response: resetting.\n");
+		dev_info(dev->dev, "hbm: stop response: resetting.\n");
 		/* force the reset */
 		return -EPROTO;
 		break;
 
 	case CLIENT_DISCONNECT_REQ_CMD:
-		dev_dbg(&dev->pdev->dev, "hbm: disconnect request: message received\n");
+		dev_dbg(dev->dev, "hbm: disconnect request: message received\n");
 
 		disconnect_req = (struct hbm_client_connect_request *)mei_msg;
 		mei_hbm_fw_disconnect_req(dev, disconnect_req);
 		break;
 
 	case ME_STOP_REQ_CMD:
-		dev_dbg(&dev->pdev->dev, "hbm: stop request: message received\n");
+		dev_dbg(dev->dev, "hbm: stop request: message received\n");
 		dev->hbm_state = MEI_HBM_STOPPED;
 		if (mei_hbm_stop_req(dev)) {
-			dev_err(&dev->pdev->dev, "hbm: stop request: failed to send stop request\n");
+			dev_err(dev->dev, "hbm: stop request: failed to send stop request\n");
 			return -EIO;
 		}
 		break;
diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index df42b6f..1247be7 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -217,10 +217,10 @@ static int mei_me_hw_reset(struct mei_device *dev, bool intr_enable)
 	hcsr = mei_hcsr_read(hw);
 
 	if ((hcsr & H_RST) == 0)
-		dev_warn(&dev->pdev->dev, "H_RST is not set = 0x%08X", hcsr);
+		dev_warn(dev->dev, "H_RST is not set = 0x%08X", hcsr);
 
 	if ((hcsr & H_RDY) == H_RDY)
-		dev_warn(&dev->pdev->dev, "H_RDY is not cleared 0x%08X", hcsr);
+		dev_warn(dev->dev, "H_RDY is not cleared 0x%08X", hcsr);
 
 	if (intr_enable == false)
 		mei_me_hw_reset_release(dev);
@@ -279,7 +279,7 @@ static int mei_me_hw_ready_wait(struct mei_device *dev)
 			mei_secs_to_jiffies(MEI_HW_READY_TIMEOUT));
 	mutex_lock(&dev->device_lock);
 	if (!dev->recvd_hw_ready) {
-		dev_err(&dev->pdev->dev, "wait hw ready failed\n");
+		dev_err(dev->dev, "wait hw ready failed\n");
 		return -ETIME;
 	}
 
@@ -293,7 +293,7 @@ static int mei_me_hw_start(struct mei_device *dev)
 
 	if (ret)
 		return ret;
-	dev_dbg(&dev->pdev->dev, "hw is ready\n");
+	dev_dbg(dev->dev, "hw is ready\n");
 
 	mei_me_host_set_ready(dev);
 	return ret;
@@ -381,10 +381,10 @@ static int mei_me_write_message(struct mei_device *dev,
 	int i;
 	int empty_slots;
 
-	dev_dbg(&dev->pdev->dev, MEI_HDR_FMT, MEI_HDR_PRM(header));
+	dev_dbg(dev->dev, MEI_HDR_FMT, MEI_HDR_PRM(header));
 
 	empty_slots = mei_hbuf_empty_slots(dev);
-	dev_dbg(&dev->pdev->dev, "empty slots = %hu.\n", empty_slots);
+	dev_dbg(dev->dev, "empty slots = %hu.\n", empty_slots);
 
 	dw_cnt = mei_data2slots(length);
 	if (empty_slots < 0 || dw_cnt > empty_slots)
@@ -434,7 +434,7 @@ static int mei_me_count_full_read_slots(struct mei_device *dev)
 	if (filled_slots > buffer_depth)
 		return -EOVERFLOW;
 
-	dev_dbg(&dev->pdev->dev, "filled_slots =%08x\n", filled_slots);
+	dev_dbg(dev->dev, "filled_slots =%08x\n", filled_slots);
 	return (int)filled_slots;
 }
 
@@ -591,7 +591,7 @@ static bool mei_me_pg_is_enabled(struct mei_device *dev)
 	return true;
 
 notsupported:
-	dev_dbg(&dev->pdev->dev, "pg: not supported: HGP = %d hbm version %d.%d ?= %d.%d\n",
+	dev_dbg(dev->dev, "pg: not supported: HGP = %d hbm version %d.%d ?= %d.%d\n",
 		!!(reg & ME_PGIC_HRA),
 		dev->version.major_version,
 		dev->version.minor_version,
@@ -642,7 +642,7 @@ irqreturn_t mei_me_irq_thread_handler(int irq, void *dev_id)
 	s32 slots;
 	int rets = 0;
 
-	dev_dbg(&dev->pdev->dev, "function called after ISR to handle the interrupt processing.\n");
+	dev_dbg(dev->dev, "function called after ISR to handle the interrupt processing.\n");
 	/* initialize our complete list */
 	mutex_lock(&dev->device_lock);
 	mei_io_list_init(&complete_list);
@@ -654,7 +654,7 @@ irqreturn_t mei_me_irq_thread_handler(int irq, void *dev_id)
 
 	/* check if ME wants a reset */
 	if (!mei_hw_is_ready(dev) && dev->dev_state != MEI_DEV_RESETTING) {
-		dev_warn(&dev->pdev->dev, "FW not ready: resetting.\n");
+		dev_warn(dev->dev, "FW not ready: resetting.\n");
 		schedule_work(&dev->reset_work);
 		goto end;
 	}
@@ -663,19 +663,19 @@ irqreturn_t mei_me_irq_thread_handler(int irq, void *dev_id)
 	if (!mei_host_is_ready(dev)) {
 		if (mei_hw_is_ready(dev)) {
 			mei_me_hw_reset_release(dev);
-			dev_dbg(&dev->pdev->dev, "we need to start the dev.\n");
+			dev_dbg(dev->dev, "we need to start the dev.\n");
 
 			dev->recvd_hw_ready = true;
 			wake_up(&dev->wait_hw_ready);
 		} else {
-			dev_dbg(&dev->pdev->dev, "Spurious Interrupt\n");
+			dev_dbg(dev->dev, "Spurious Interrupt\n");
 		}
 		goto end;
 	}
 	/* check slots available for reading */
 	slots = mei_count_full_read_slots(dev);
 	while (slots > 0) {
-		dev_dbg(&dev->pdev->dev, "slots to read = %08x\n", slots);
+		dev_dbg(dev->dev, "slots to read = %08x\n", slots);
 		rets = mei_irq_read_handler(dev, &complete_list, &slots);
 		/* There is a race between ME write and interrupt delivery:
 		 * Not all data is always available immediately after the
@@ -685,7 +685,7 @@ irqreturn_t mei_me_irq_thread_handler(int irq, void *dev_id)
 			break;
 
 		if (rets && dev->dev_state != MEI_DEV_RESETTING) {
-			dev_err(&dev->pdev->dev, "mei_irq_read_handler ret = %d.\n",
+			dev_err(dev->dev, "mei_irq_read_handler ret = %d.\n",
 						rets);
 			schedule_work(&dev->reset_work);
 			goto end;
@@ -707,7 +707,7 @@ irqreturn_t mei_me_irq_thread_handler(int irq, void *dev_id)
 	mei_irq_compl_handler(dev, &complete_list);
 
 end:
-	dev_dbg(&dev->pdev->dev, "interrupt thread end ret = %d\n", rets);
+	dev_dbg(dev->dev, "interrupt thread end ret = %d\n", rets);
 	mutex_unlock(&dev->device_lock);
 	return IRQ_HANDLED;
 }
diff --git a/drivers/misc/mei/hw-txe.c b/drivers/misc/mei/hw-txe.c
index fc1a51f..acc475e 100644
--- a/drivers/misc/mei/hw-txe.c
+++ b/drivers/misc/mei/hw-txe.c
@@ -155,7 +155,7 @@ static bool mei_txe_aliveness_set(struct mei_device *dev, u32 req)
 	struct mei_txe_hw *hw = to_txe_hw(dev);
 	bool do_req = hw->aliveness != req;
 
-	dev_dbg(&dev->pdev->dev, "Aliveness current=%d request=%d\n",
+	dev_dbg(dev->dev, "Aliveness current=%d request=%d\n",
 				hw->aliveness, req);
 	if (do_req) {
 		dev->pg_event = MEI_PG_EVENT_WAIT;
@@ -216,7 +216,7 @@ static int mei_txe_aliveness_poll(struct mei_device *dev, u32 expected)
 		hw->aliveness = mei_txe_aliveness_get(dev);
 		if (hw->aliveness == expected) {
 			dev->pg_event = MEI_PG_EVENT_IDLE;
-			dev_dbg(&dev->pdev->dev,
+			dev_dbg(dev->dev,
 				"aliveness settled after %d msecs\n", t);
 			return t;
 		}
@@ -227,7 +227,7 @@ static int mei_txe_aliveness_poll(struct mei_device *dev, u32 expected)
 	} while (t < SEC_ALIVENESS_WAIT_TIMEOUT);
 
 	dev->pg_event = MEI_PG_EVENT_IDLE;
-	dev_err(&dev->pdev->dev, "aliveness timed out\n");
+	dev_err(dev->dev, "aliveness timed out\n");
 	return -ETIME;
 }
 
@@ -261,10 +261,10 @@ static int mei_txe_aliveness_wait(struct mei_device *dev, u32 expected)
 	ret = hw->aliveness == expected ? 0 : -ETIME;
 
 	if (ret)
-		dev_warn(&dev->pdev->dev, "aliveness timed out = %ld aliveness = %d event = %d\n",
+		dev_warn(dev->dev, "aliveness timed out = %ld aliveness = %d event = %d\n",
 			err, hw->aliveness, dev->pg_event);
 	else
-		dev_dbg(&dev->pdev->dev, "aliveness settled after = %d msec aliveness = %d event = %d\n",
+		dev_dbg(dev->dev, "aliveness settled after = %d msec aliveness = %d event = %d\n",
 			jiffies_to_msecs(timeout - err),
 			hw->aliveness, dev->pg_event);
 
@@ -425,7 +425,7 @@ static bool mei_txe_pending_interrupts(struct mei_device *dev)
 				      TXE_INTR_OUT_DB));
 
 	if (ret) {
-		dev_dbg(&dev->pdev->dev,
+		dev_dbg(dev->dev,
 			"Pending Interrupts InReady=%01d Readiness=%01d, Aliveness=%01d, OutDoor=%01d\n",
 			!!(hw->intr_cause & TXE_INTR_IN_READY),
 			!!(hw->intr_cause & TXE_INTR_READINESS),
@@ -565,7 +565,7 @@ static int mei_txe_readiness_wait(struct mei_device *dev)
 			msecs_to_jiffies(SEC_RESET_WAIT_TIMEOUT));
 	mutex_lock(&dev->device_lock);
 	if (!dev->recvd_hw_ready) {
-		dev_err(&dev->pdev->dev, "wait for readiness failed\n");
+		dev_err(dev->dev, "wait for readiness failed\n");
 		return -ETIME;
 	}
 
@@ -592,7 +592,7 @@ static void mei_txe_hw_config(struct mei_device *dev)
 	hw->aliveness = mei_txe_aliveness_get(dev);
 	hw->readiness = mei_txe_readiness_get(dev);
 
-	dev_dbg(&dev->pdev->dev, "aliveness_resp = 0x%08x, readiness = 0x%08x.\n",
+	dev_dbg(dev->dev, "aliveness_resp = 0x%08x, readiness = 0x%08x.\n",
 		hw->aliveness, hw->readiness);
 }
 
@@ -622,7 +622,7 @@ static int mei_txe_write(struct mei_device *dev,
 
 	length = header->length;
 
-	dev_dbg(&dev->pdev->dev, MEI_HDR_FMT, MEI_HDR_PRM(header));
+	dev_dbg(dev->dev, MEI_HDR_FMT, MEI_HDR_PRM(header));
 
 	dw_cnt = mei_data2slots(length);
 	if (dw_cnt > slots)
@@ -638,7 +638,7 @@ static int mei_txe_write(struct mei_device *dev,
 		struct mei_fw_status fw_status;
 
 		mei_fw_status(dev, &fw_status);
-		dev_err(&dev->pdev->dev, "Input is not ready " FW_STS_FMT "\n",
+		dev_err(dev->dev, "Input is not ready " FW_STS_FMT "\n",
 			FW_STS_PRM(fw_status));
 		return -EAGAIN;
 	}
@@ -740,14 +740,13 @@ static int mei_txe_read(struct mei_device *dev,
 	reg_buf = (u32 *)buf;
 	rem = len & 0x3;
 
-	dev_dbg(&dev->pdev->dev,
-		"buffer-length = %lu buf[0]0x%08X\n",
+	dev_dbg(dev->dev, "buffer-length = %lu buf[0]0x%08X\n",
 		len, mei_txe_out_data_read(dev, 0));
 
 	for (i = 0; i < len / 4; i++) {
 		/* skip header: index starts from 1 */
 		reg = mei_txe_out_data_read(dev, i + 1);
-		dev_dbg(&dev->pdev->dev, "buf[%d] = 0x%08X\n", i, reg);
+		dev_dbg(dev->dev, "buf[%d] = 0x%08X\n", i, reg);
 		*reg_buf++ = reg;
 	}
 
@@ -792,8 +791,7 @@ static int mei_txe_hw_reset(struct mei_device *dev, bool intr_enable)
 	 */
 	if (aliveness_req != hw->aliveness)
 		if (mei_txe_aliveness_poll(dev, aliveness_req) < 0) {
-			dev_err(&dev->pdev->dev,
-				"wait for aliveness settle failed ... bailing out\n");
+			dev_err(dev->dev, "wait for aliveness settle failed ... bailing out\n");
 			return -EIO;
 		}
 
@@ -803,8 +801,7 @@ static int mei_txe_hw_reset(struct mei_device *dev, bool intr_enable)
 	if (aliveness_req) {
 		mei_txe_aliveness_set(dev, 0);
 		if (mei_txe_aliveness_poll(dev, 0) < 0) {
-			dev_err(&dev->pdev->dev,
-				"wait for aliveness failed ... bailing out\n");
+			dev_err(dev->dev, "wait for aliveness failed ... bailing out\n");
 			return -EIO;
 		}
 	}
@@ -836,7 +833,7 @@ static int mei_txe_hw_start(struct mei_device *dev)
 
 	ret = mei_txe_readiness_wait(dev);
 	if (ret < 0) {
-		dev_err(&dev->pdev->dev, "wating for readiness failed\n");
+		dev_err(dev->dev, "wating for readiness failed\n");
 		return ret;
 	}
 
@@ -852,7 +849,7 @@ static int mei_txe_hw_start(struct mei_device *dev)
 
 	ret = mei_txe_aliveness_set_sync(dev, 1);
 	if (ret < 0) {
-		dev_err(&dev->pdev->dev, "wait for aliveness failed ... bailing out\n");
+		dev_err(dev->dev, "wait for aliveness failed ... bailing out\n");
 		return ret;
 	}
 
@@ -962,7 +959,7 @@ irqreturn_t mei_txe_irq_thread_handler(int irq, void *dev_id)
 	s32 slots;
 	int rets = 0;
 
-	dev_dbg(&dev->pdev->dev, "irq thread: Interrupt Registers HHISR|HISR|SEC=%02X|%04X|%02X\n",
+	dev_dbg(dev->dev, "irq thread: Interrupt Registers HHISR|HISR|SEC=%02X|%04X|%02X\n",
 		mei_txe_br_reg_read(hw, HHISR_REG),
 		mei_txe_br_reg_read(hw, HISR_REG),
 		mei_txe_sec_reg_read_silent(hw, SEC_IPC_HOST_INT_STATUS_REG));
@@ -986,17 +983,17 @@ irqreturn_t mei_txe_irq_thread_handler(int irq, void *dev_id)
 	 * or TXE driver resetting the HECI interface.
 	 */
 	if (test_and_clear_bit(TXE_INTR_READINESS_BIT, &hw->intr_cause)) {
-		dev_dbg(&dev->pdev->dev, "Readiness Interrupt was received...\n");
+		dev_dbg(dev->dev, "Readiness Interrupt was received...\n");
 
 		/* Check if SeC is going through reset */
 		if (mei_txe_readiness_is_sec_rdy(hw->readiness)) {
-			dev_dbg(&dev->pdev->dev, "we need to start the dev.\n");
+			dev_dbg(dev->dev, "we need to start the dev.\n");
 			dev->recvd_hw_ready = true;
 		} else {
 			dev->recvd_hw_ready = false;
 			if (dev->dev_state != MEI_DEV_RESETTING) {
 
-				dev_warn(&dev->pdev->dev, "FW not ready: resetting.\n");
+				dev_warn(dev->dev, "FW not ready: resetting.\n");
 				schedule_work(&dev->reset_work);
 				goto end;
 
@@ -1013,7 +1010,7 @@ irqreturn_t mei_txe_irq_thread_handler(int irq, void *dev_id)
 
 	if (test_and_clear_bit(TXE_INTR_ALIVENESS_BIT, &hw->intr_cause)) {
 		/* Clear the interrupt cause */
-		dev_dbg(&dev->pdev->dev,
+		dev_dbg(dev->dev,
 			"Aliveness Interrupt: Status: %d\n", hw->aliveness);
 		dev->pg_event = MEI_PG_EVENT_RECEIVED;
 		if (waitqueue_active(&hw->wait_aliveness_resp))
@@ -1029,7 +1026,7 @@ irqreturn_t mei_txe_irq_thread_handler(int irq, void *dev_id)
 		/* Read from TXE */
 		rets = mei_irq_read_handler(dev, &complete_list, &slots);
 		if (rets && dev->dev_state != MEI_DEV_RESETTING) {
-			dev_err(&dev->pdev->dev,
+			dev_err(dev->dev,
 				"mei_irq_read_handler ret = %d.\n", rets);
 
 			schedule_work(&dev->reset_work);
@@ -1047,7 +1044,7 @@ irqreturn_t mei_txe_irq_thread_handler(int irq, void *dev_id)
 		dev->hbuf_is_ready = mei_hbuf_is_ready(dev);
 		rets = mei_irq_write_handler(dev, &complete_list);
 		if (rets && rets != -EMSGSIZE)
-			dev_err(&dev->pdev->dev, "mei_irq_write_handler ret = %d.\n",
+			dev_err(dev->dev, "mei_irq_write_handler ret = %d.\n",
 				rets);
 		dev->hbuf_is_ready = mei_hbuf_is_ready(dev);
 	}
@@ -1055,7 +1052,7 @@ irqreturn_t mei_txe_irq_thread_handler(int irq, void *dev_id)
 	mei_irq_compl_handler(dev, &complete_list);
 
 end:
-	dev_dbg(&dev->pdev->dev, "interrupt thread end ret = %d\n", rets);
+	dev_dbg(dev->dev, "interrupt thread end ret = %d\n", rets);
 
 	mutex_unlock(&dev->device_lock);
 
@@ -1171,7 +1168,7 @@ int mei_txe_setup_satt2(struct mei_device *dev, phys_addr_t addr, u32 range)
 	mei_txe_br_reg_write(hw, SATT2_SAP_SIZE_REG, range);
 	mei_txe_br_reg_write(hw, SATT2_BRG_BA_LSB_REG, lo32);
 	mei_txe_br_reg_write(hw, SATT2_CTRL_REG, ctrl);
-	dev_dbg(&dev->pdev->dev, "SATT2: SAP_SIZE_OFFSET=0x%08X, BRG_BA_LSB_OFFSET=0x%08X, CTRL_OFFSET=0x%08X\n",
+	dev_dbg(dev->dev, "SATT2: SAP_SIZE_OFFSET=0x%08X, BRG_BA_LSB_OFFSET=0x%08X, CTRL_OFFSET=0x%08X\n",
 		range, lo32, ctrl);
 
 	return 0;
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index ac65976..29aae7b 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -90,7 +90,7 @@ int mei_reset(struct mei_device *dev)
 		struct mei_fw_status fw_status;
 
 		mei_fw_status(dev, &fw_status);
-		dev_warn(&dev->pdev->dev,
+		dev_warn(dev->dev,
 			"unexpected reset: dev_state = %s " FW_STS_FMT "\n",
 			mei_dev_state_str(state), FW_STS_PRM(fw_status));
 	}
@@ -108,7 +108,7 @@ int mei_reset(struct mei_device *dev)
 
 	dev->reset_count++;
 	if (dev->reset_count > MEI_MAX_CONSEC_RESET) {
-		dev_err(&dev->pdev->dev, "reset: reached maximal consecutive resets: disabling the device\n");
+		dev_err(dev->dev, "reset: reached maximal consecutive resets: disabling the device\n");
 		dev->dev_state = MEI_DEV_DISABLED;
 		return -ENODEV;
 	}
@@ -129,7 +129,7 @@ int mei_reset(struct mei_device *dev)
 		mei_cl_all_wakeup(dev);
 
 		/* remove entry if already in list */
-		dev_dbg(&dev->pdev->dev, "remove iamthif and wd from the file list.\n");
+		dev_dbg(dev->dev, "remove iamthif and wd from the file list.\n");
 		mei_cl_unlink(&dev->wd_cl);
 		mei_cl_unlink(&dev->iamthif_cl);
 		mei_amthif_reset_params(dev);
@@ -141,28 +141,28 @@ int mei_reset(struct mei_device *dev)
 	dev->wd_pending = false;
 
 	if (ret) {
-		dev_err(&dev->pdev->dev, "hw_reset failed ret = %d\n", ret);
+		dev_err(dev->dev, "hw_reset failed ret = %d\n", ret);
 		return ret;
 	}
 
 	if (state == MEI_DEV_POWER_DOWN) {
-		dev_dbg(&dev->pdev->dev, "powering down: end of reset\n");
+		dev_dbg(dev->dev, "powering down: end of reset\n");
 		dev->dev_state = MEI_DEV_DISABLED;
 		return 0;
 	}
 
 	ret = mei_hw_start(dev);
 	if (ret) {
-		dev_err(&dev->pdev->dev, "hw_start failed ret = %d\n", ret);
+		dev_err(dev->dev, "hw_start failed ret = %d\n", ret);
 		return ret;
 	}
 
-	dev_dbg(&dev->pdev->dev, "link is established start sending messages.\n");
+	dev_dbg(dev->dev, "link is established start sending messages.\n");
 
 	dev->dev_state = MEI_DEV_INIT_CLIENTS;
 	ret = mei_hbm_start_req(dev);
 	if (ret) {
-		dev_err(&dev->pdev->dev, "hbm_start failed ret = %d\n", ret);
+		dev_err(dev->dev, "hbm_start failed ret = %d\n", ret);
 		dev->dev_state = MEI_DEV_RESETTING;
 		return ret;
 	}
@@ -189,7 +189,7 @@ int mei_start(struct mei_device *dev)
 
 	mei_hw_config(dev);
 
-	dev_dbg(&dev->pdev->dev, "reset in start the mei device.\n");
+	dev_dbg(dev->dev, "reset in start the mei device.\n");
 
 	dev->reset_count = 0;
 	do {
@@ -197,43 +197,43 @@ int mei_start(struct mei_device *dev)
 		ret = mei_reset(dev);
 
 		if (ret == -ENODEV || dev->dev_state == MEI_DEV_DISABLED) {
-			dev_err(&dev->pdev->dev, "reset failed ret = %d", ret);
+			dev_err(dev->dev, "reset failed ret = %d", ret);
 			goto err;
 		}
 	} while (ret);
 
 	/* we cannot start the device w/o hbm start message completed */
 	if (dev->dev_state == MEI_DEV_DISABLED) {
-		dev_err(&dev->pdev->dev, "reset failed");
+		dev_err(dev->dev, "reset failed");
 		goto err;
 	}
 
 	if (mei_hbm_start_wait(dev)) {
-		dev_err(&dev->pdev->dev, "HBM haven't started");
+		dev_err(dev->dev, "HBM haven't started");
 		goto err;
 	}
 
 	if (!mei_host_is_ready(dev)) {
-		dev_err(&dev->pdev->dev, "host is not ready.\n");
+		dev_err(dev->dev, "host is not ready.\n");
 		goto err;
 	}
 
 	if (!mei_hw_is_ready(dev)) {
-		dev_err(&dev->pdev->dev, "ME is not ready.\n");
+		dev_err(dev->dev, "ME is not ready.\n");
 		goto err;
 	}
 
 	if (!mei_hbm_version_is_supported(dev)) {
-		dev_dbg(&dev->pdev->dev, "MEI start failed.\n");
+		dev_dbg(dev->dev, "MEI start failed.\n");
 		goto err;
 	}
 
-	dev_dbg(&dev->pdev->dev, "link layer has been established.\n");
+	dev_dbg(dev->dev, "link layer has been established.\n");
 
 	mutex_unlock(&dev->device_lock);
 	return 0;
 err:
-	dev_err(&dev->pdev->dev, "link layer initialization failed.\n");
+	dev_err(dev->dev, "link layer initialization failed.\n");
 	dev->dev_state = MEI_DEV_DISABLED;
 	mutex_unlock(&dev->device_lock);
 	return -ENODEV;
@@ -263,7 +263,7 @@ int mei_restart(struct mei_device *dev)
 	mutex_unlock(&dev->device_lock);
 
 	if (err == -ENODEV || dev->dev_state == MEI_DEV_DISABLED) {
-		dev_err(&dev->pdev->dev, "device disabled = %d\n", err);
+		dev_err(dev->dev, "device disabled = %d\n", err);
 		return -ENODEV;
 	}
 
@@ -289,7 +289,7 @@ static void mei_reset_work(struct work_struct *work)
 	mutex_unlock(&dev->device_lock);
 
 	if (dev->dev_state == MEI_DEV_DISABLED) {
-		dev_err(&dev->pdev->dev, "device disabled = %d\n", ret);
+		dev_err(dev->dev, "device disabled = %d\n", ret);
 		return;
 	}
 
@@ -300,7 +300,7 @@ static void mei_reset_work(struct work_struct *work)
 
 void mei_stop(struct mei_device *dev)
 {
-	dev_dbg(&dev->pdev->dev, "stopping the device.\n");
+	dev_dbg(dev->dev, "stopping the device.\n");
 
 	mei_cancel_work(dev);
 
@@ -334,7 +334,7 @@ bool mei_write_is_idle(struct mei_device *dev)
 		list_empty(&dev->ctrl_wr_list.list) &&
 		list_empty(&dev->write_list.list));
 
-	dev_dbg(&dev->pdev->dev, "write pg: is idle[%d] state=%s ctrl=%d write=%d\n",
+	dev_dbg(dev->dev, "write pg: is idle[%d] state=%s ctrl=%d write=%d\n",
 		idle,
 		mei_dev_state_str(dev->dev_state),
 		list_empty(&dev->ctrl_wr_list.list),
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index b8d9cfe..8dac769 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -47,7 +47,7 @@ void mei_irq_compl_handler(struct mei_device *dev, struct mei_cl_cb *compl_list)
 		if (!cl)
 			continue;
 
-		dev_dbg(&dev->pdev->dev, "completing call back.\n");
+		dev_dbg(dev->dev, "completing call back.\n");
 		if (cl == &dev->iamthif_cl)
 			mei_amthif_complete(dev, cb);
 		else
@@ -148,10 +148,10 @@ static int mei_cl_irq_read_msg(struct mei_device *dev,
 		break;
 	}
 
-	dev_dbg(&dev->pdev->dev, "message read\n");
+	dev_dbg(dev->dev, "message read\n");
 	if (!buffer) {
 		mei_read_slots(dev, dev->rd_msg_buf, mei_hdr->length);
-		dev_dbg(&dev->pdev->dev, "discarding message " MEI_HDR_FMT "\n",
+		dev_dbg(dev->dev, "discarding message " MEI_HDR_FMT "\n",
 				MEI_HDR_PRM(mei_hdr));
 	}
 
@@ -333,20 +333,20 @@ int mei_irq_read_handler(struct mei_device *dev,
 	if (!dev->rd_msg_hdr) {
 		dev->rd_msg_hdr = mei_read_hdr(dev);
 		(*slots)--;
-		dev_dbg(&dev->pdev->dev, "slots =%08x.\n", *slots);
+		dev_dbg(dev->dev, "slots =%08x.\n", *slots);
 	}
 	mei_hdr = (struct mei_msg_hdr *) &dev->rd_msg_hdr;
-	dev_dbg(&dev->pdev->dev, MEI_HDR_FMT, MEI_HDR_PRM(mei_hdr));
+	dev_dbg(dev->dev, MEI_HDR_FMT, MEI_HDR_PRM(mei_hdr));
 
 	if (mei_hdr->reserved || !dev->rd_msg_hdr) {
-		dev_err(&dev->pdev->dev, "corrupted message header 0x%08X\n",
+		dev_err(dev->dev, "corrupted message header 0x%08X\n",
 				dev->rd_msg_hdr);
 		ret = -EBADMSG;
 		goto end;
 	}
 
 	if (mei_slots2data(*slots) < mei_hdr->length) {
-		dev_err(&dev->pdev->dev, "less data available than length=%08x.\n",
+		dev_err(dev->dev, "less data available than length=%08x.\n",
 				*slots);
 		/* we can't read the message */
 		ret = -ENODATA;
@@ -357,7 +357,7 @@ int mei_irq_read_handler(struct mei_device *dev,
 	if (mei_hdr->host_addr == 0 && mei_hdr->me_addr == 0) {
 		ret = mei_hbm_dispatch(dev, mei_hdr);
 		if (ret) {
-			dev_dbg(&dev->pdev->dev, "mei_hbm_dispatch failed ret = %d\n",
+			dev_dbg(dev->dev, "mei_hbm_dispatch failed ret = %d\n",
 					ret);
 			goto end;
 		}
@@ -374,7 +374,7 @@ int mei_irq_read_handler(struct mei_device *dev,
 
 	/* if no recipient cl was found we assume corrupted header */
 	if (&cl->link == &dev->file_list) {
-		dev_err(&dev->pdev->dev, "no destination client found 0x%08X\n",
+		dev_err(dev->dev, "no destination client found 0x%08X\n",
 				dev->rd_msg_hdr);
 		ret = -EBADMSG;
 		goto end;
@@ -386,14 +386,14 @@ int mei_irq_read_handler(struct mei_device *dev,
 
 		ret = mei_amthif_irq_read_msg(dev, mei_hdr, cmpl_list);
 		if (ret) {
-			dev_err(&dev->pdev->dev, "mei_amthif_irq_read_msg failed = %d\n",
+			dev_err(dev->dev, "mei_amthif_irq_read_msg failed = %d\n",
 					ret);
 			goto end;
 		}
 	} else {
 		ret = mei_cl_irq_read_msg(dev, mei_hdr, cmpl_list);
 		if (ret) {
-			dev_err(&dev->pdev->dev, "mei_cl_irq_read_msg failed = %d\n",
+			dev_err(dev->dev, "mei_cl_irq_read_msg failed = %d\n",
 					ret);
 			goto end;
 		}
@@ -406,7 +406,7 @@ reset_slots:
 
 	if (*slots == -EOVERFLOW) {
 		/* overflow - reset */
-		dev_err(&dev->pdev->dev, "resetting due to slots overflow.\n");
+		dev_err(dev->dev, "resetting due to slots overflow.\n");
 		/* set the event since message has been read */
 		ret = -ERANGE;
 		goto end;
@@ -444,7 +444,7 @@ int mei_irq_write_handler(struct mei_device *dev, struct mei_cl_cb *cmpl_list)
 		return -EMSGSIZE;
 
 	/* complete all waiting for write CB */
-	dev_dbg(&dev->pdev->dev, "complete all waiting for write cb.\n");
+	dev_dbg(dev->dev, "complete all waiting for write cb.\n");
 
 	list = &dev->write_waiting_list;
 	list_for_each_entry_safe(cb, next, &list->list, list) {
@@ -486,7 +486,7 @@ int mei_irq_write_handler(struct mei_device *dev, struct mei_cl_cb *cmpl_list)
 	}
 
 	/* complete control write list CB */
-	dev_dbg(&dev->pdev->dev, "complete control write list cb.\n");
+	dev_dbg(dev->dev, "complete control write list cb.\n");
 	list_for_each_entry_safe(cb, next, &dev->ctrl_wr_list.list, list) {
 		cl = cb->cl;
 		if (!cl) {
@@ -527,7 +527,7 @@ int mei_irq_write_handler(struct mei_device *dev, struct mei_cl_cb *cmpl_list)
 
 	}
 	/* complete  write list CB */
-	dev_dbg(&dev->pdev->dev, "complete write list cb.\n");
+	dev_dbg(dev->dev, "complete write list cb.\n");
 	list_for_each_entry_safe(cb, next, &dev->write_list.list, list) {
 		cl = cb->cl;
 		if (cl == NULL)
@@ -568,7 +568,7 @@ void mei_timer(struct work_struct *work)
 
 		if (dev->init_clients_timer) {
 			if (--dev->init_clients_timer == 0) {
-				dev_err(&dev->pdev->dev, "timer: init clients timeout hbm_state = %d.\n",
+				dev_err(dev->dev, "timer: init clients timeout hbm_state = %d.\n",
 					dev->hbm_state);
 				mei_reset(dev);
 				goto out;
@@ -583,7 +583,7 @@ void mei_timer(struct work_struct *work)
 	list_for_each_entry(cl, &dev->file_list, link) {
 		if (cl->timer_count) {
 			if (--cl->timer_count == 0) {
-				dev_err(&dev->pdev->dev, "timer: connect/disconnect timeout.\n");
+				dev_err(dev->dev, "timer: connect/disconnect timeout.\n");
 				mei_reset(dev);
 				goto out;
 			}
@@ -595,7 +595,7 @@ void mei_timer(struct work_struct *work)
 
 	if (dev->iamthif_stall_timer) {
 		if (--dev->iamthif_stall_timer == 0) {
-			dev_err(&dev->pdev->dev, "timer: amthif  hanged.\n");
+			dev_err(dev->dev, "timer: amthif  hanged.\n");
 			mei_reset(dev);
 			dev->iamthif_msg_buf_size = 0;
 			dev->iamthif_msg_buf_index = 0;
@@ -617,17 +617,17 @@ void mei_timer(struct work_struct *work)
 		timeout = dev->iamthif_timer +
 			mei_secs_to_jiffies(MEI_IAMTHIF_READ_TIMER);
 
-		dev_dbg(&dev->pdev->dev, "dev->iamthif_timer = %ld\n",
+		dev_dbg(dev->dev, "dev->iamthif_timer = %ld\n",
 				dev->iamthif_timer);
-		dev_dbg(&dev->pdev->dev, "timeout = %ld\n", timeout);
-		dev_dbg(&dev->pdev->dev, "jiffies = %ld\n", jiffies);
+		dev_dbg(dev->dev, "timeout = %ld\n", timeout);
+		dev_dbg(dev->dev, "jiffies = %ld\n", jiffies);
 		if (time_after(jiffies, timeout)) {
 			/*
 			 * User didn't read the AMTHI data on time (15sec)
 			 * freeing AMTHI for other requests
 			 */
 
-			dev_dbg(&dev->pdev->dev, "freeing AMTHI for other requests\n");
+			dev_dbg(dev->dev, "freeing AMTHI for other requests\n");
 
 			mei_io_list_flush(&dev->amthif_rd_complete_list,
 				&dev->iamthif_cl);
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 244fb6b..4d738c8 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -63,7 +63,7 @@ static int mei_open(struct inode *inode, struct file *file)
 
 	err = -ENODEV;
 	if (dev->dev_state != MEI_DEV_ENABLED) {
-		dev_dbg(&dev->pdev->dev, "dev_state != MEI_ENABLED  dev_state = %s\n",
+		dev_dbg(dev->dev, "dev_state != MEI_ENABLED  dev_state = %s\n",
 		    mei_dev_state_str(dev->dev_state));
 		goto err_unlock;
 	}
@@ -211,7 +211,7 @@ static ssize_t mei_read(struct file *file, char __user *ubuf,
 
 	err = mei_cl_read_start(cl, length);
 	if (err && err != -EBUSY) {
-		dev_dbg(&dev->pdev->dev,
+		dev_dbg(dev->dev,
 			"mei start read failure with status = %d\n", err);
 		rets = err;
 		goto out;
@@ -254,7 +254,7 @@ static ssize_t mei_read(struct file *file, char __user *ubuf,
 	}
 	/* now copy the data to user space */
 copy_buffer:
-	dev_dbg(&dev->pdev->dev, "buf.size = %d buf.idx= %ld\n",
+	dev_dbg(dev->dev, "buf.size = %d buf.idx= %ld\n",
 	    cb->response_buffer.size, cb->buf_idx);
 	if (length == 0 || ubuf == NULL || *offset > cb->buf_idx) {
 		rets = -EMSGSIZE;
@@ -266,7 +266,7 @@ copy_buffer:
 	length = min_t(size_t, length, cb->buf_idx - *offset);
 
 	if (copy_to_user(ubuf, cb->response_buffer.data + *offset, length)) {
-		dev_dbg(&dev->pdev->dev, "failed to copy data to userland\n");
+		dev_dbg(dev->dev, "failed to copy data to userland\n");
 		rets = -EFAULT;
 		goto free;
 	}
@@ -285,7 +285,7 @@ free:
 	cl->reading_state = MEI_IDLE;
 	cl->read_cb = NULL;
 out:
-	dev_dbg(&dev->pdev->dev, "end mei read rets= %d\n", rets);
+	dev_dbg(dev->dev, "end mei read rets= %d\n", rets);
 	mutex_unlock(&dev->device_lock);
 	return rets;
 }
@@ -338,7 +338,7 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 	}
 
 	if (cl->state != MEI_FILE_CONNECTED) {
-		dev_err(&dev->pdev->dev, "host client = %d,  is not connected to ME client = %d",
+		dev_err(dev->dev, "host client = %d,  is not connected to ME client = %d",
 			cl->host_client_id, cl->me_client_id);
 		rets = -ENODEV;
 		goto out;
@@ -386,7 +386,7 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 
 	rets = copy_from_user(write_cb->request_buffer.data, ubuf, length);
 	if (rets) {
-		dev_dbg(&dev->pdev->dev, "failed to copy data from userland\n");
+		dev_dbg(dev->dev, "failed to copy data from userland\n");
 		rets = -EFAULT;
 		goto out;
 	}
@@ -395,7 +395,7 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 		rets = mei_amthif_write(dev, write_cb);
 
 		if (rets) {
-			dev_err(&dev->pdev->dev,
+			dev_err(dev->dev,
 				"amthif write failed with status = %d\n", rets);
 			goto out;
 		}
@@ -448,7 +448,7 @@ static int mei_ioctl_connect_client(struct file *file,
 	/* find ME client we're trying to connect to */
 	me_cl = mei_me_cl_by_uuid(dev, &data->in_client_uuid);
 	if (!me_cl || me_cl->props.fixed_address) {
-		dev_dbg(&dev->pdev->dev, "Cannot connect to FW Client UUID = %pUl\n",
+		dev_dbg(dev->dev, "Cannot connect to FW Client UUID = %pUl\n",
 				&data->in_client_uuid);
 		rets = -ENOTTY;
 		goto end;
@@ -457,18 +457,18 @@ static int mei_ioctl_connect_client(struct file *file,
 	cl->me_client_id = me_cl->client_id;
 	cl->cl_uuid = me_cl->props.protocol_name;
 
-	dev_dbg(&dev->pdev->dev, "Connect to FW Client ID = %d\n",
+	dev_dbg(dev->dev, "Connect to FW Client ID = %d\n",
 			cl->me_client_id);
-	dev_dbg(&dev->pdev->dev, "FW Client - Protocol Version = %d\n",
+	dev_dbg(dev->dev, "FW Client - Protocol Version = %d\n",
 			me_cl->props.protocol_version);
-	dev_dbg(&dev->pdev->dev, "FW Client - Max Msg Len = %d\n",
+	dev_dbg(dev->dev, "FW Client - Max Msg Len = %d\n",
 			me_cl->props.max_msg_length);
 
 	/* if we're connecting to amthif client then we will use the
 	 * existing connection
 	 */
 	if (uuid_le_cmp(data->in_client_uuid, mei_amthif_guid) == 0) {
-		dev_dbg(&dev->pdev->dev, "FW Client is amthi\n");
+		dev_dbg(dev->dev, "FW Client is amthi\n");
 		if (dev->iamthif_cl.state != MEI_FILE_CONNECTED) {
 			rets = -ENODEV;
 			goto end;
@@ -493,7 +493,7 @@ static int mei_ioctl_connect_client(struct file *file,
 	client = &data->out_client_properties;
 	client->max_msg_length = me_cl->props.max_msg_length;
 	client->protocol_version = me_cl->props.protocol_version;
-	dev_dbg(&dev->pdev->dev, "Can connect?\n");
+	dev_dbg(dev->dev, "Can connect?\n");
 
 
 	rets = mei_cl_connect(cl, file);
@@ -524,7 +524,7 @@ static long mei_ioctl(struct file *file, unsigned int cmd, unsigned long data)
 
 	dev = cl->dev;
 
-	dev_dbg(&dev->pdev->dev, "IOCTL cmd = 0x%x", cmd);
+	dev_dbg(dev->dev, "IOCTL cmd = 0x%x", cmd);
 
 	mutex_lock(&dev->device_lock);
 	if (dev->dev_state != MEI_DEV_ENABLED) {
@@ -534,10 +534,10 @@ static long mei_ioctl(struct file *file, unsigned int cmd, unsigned long data)
 
 	switch (cmd) {
 	case IOCTL_MEI_CONNECT_CLIENT:
-		dev_dbg(&dev->pdev->dev, ": IOCTL_MEI_CONNECT_CLIENT.\n");
+		dev_dbg(dev->dev, ": IOCTL_MEI_CONNECT_CLIENT.\n");
 		if (copy_from_user(&connect_data, (char __user *)data,
 				sizeof(struct mei_connect_client_data))) {
-			dev_dbg(&dev->pdev->dev, "failed to copy data from userland\n");
+			dev_dbg(dev->dev, "failed to copy data from userland\n");
 			rets = -EFAULT;
 			goto out;
 		}
@@ -549,7 +549,7 @@ static long mei_ioctl(struct file *file, unsigned int cmd, unsigned long data)
 		/* if all is ok, copying the data back to user. */
 		if (copy_to_user((char __user *)data, &connect_data,
 				sizeof(struct mei_connect_client_data))) {
-			dev_dbg(&dev->pdev->dev, "failed to copy data to userland\n");
+			dev_dbg(dev->dev, "failed to copy data to userland\n");
 			rets = -EFAULT;
 			goto out;
 		}
@@ -557,7 +557,7 @@ static long mei_ioctl(struct file *file, unsigned int cmd, unsigned long data)
 		break;
 
 	default:
-		dev_err(&dev->pdev->dev, ": unsupported ioctl %d.\n", cmd);
+		dev_err(dev->dev, ": unsupported ioctl %d.\n", cmd);
 		rets = -ENOIOCTLCMD;
 	}
 
@@ -671,7 +671,7 @@ static int mei_minor_get(struct mei_device *dev)
 	if (ret >= 0)
 		dev->minor = ret;
 	else if (ret == -ENOSPC)
-		dev_err(&dev->pdev->dev, "too many mei devices\n");
+		dev_err(dev->dev, "too many mei devices\n");
 
 	mutex_unlock(&mei_minor_lock);
 	return ret;
diff --git a/drivers/misc/mei/nfc.c b/drivers/misc/mei/nfc.c
index 8cc93e4..9f32fd6 100644
--- a/drivers/misc/mei/nfc.c
+++ b/drivers/misc/mei/nfc.c
@@ -163,7 +163,7 @@ static int mei_nfc_build_bus_name(struct mei_nfc_dev *ndev)
 			return 0;
 
 		default:
-			dev_err(&dev->pdev->dev, "Unknown radio type 0x%x\n",
+			dev_err(dev->dev, "Unknown radio type 0x%x\n",
 				ndev->radio_type);
 
 			return -EINVAL;
@@ -175,14 +175,14 @@ static int mei_nfc_build_bus_name(struct mei_nfc_dev *ndev)
 			ndev->bus_name = "pn544";
 			return 0;
 		default:
-			dev_err(&dev->pdev->dev, "Unknown radio type 0x%x\n",
+			dev_err(dev->dev, "Unknown radio type 0x%x\n",
 				ndev->radio_type);
 
 			return -EINVAL;
 		}
 
 	default:
-		dev_err(&dev->pdev->dev, "Unknown vendor ID 0x%x\n",
+		dev_err(dev->dev, "Unknown vendor ID 0x%x\n",
 			ndev->vendor_id);
 
 		return -EINVAL;
@@ -231,21 +231,21 @@ static int mei_nfc_connect(struct mei_nfc_dev *ndev)
 
 	ret = __mei_cl_send(cl, (u8 *)cmd, connect_length);
 	if (ret < 0) {
-		dev_err(&dev->pdev->dev, "Could not send connect cmd\n");
+		dev_err(dev->dev, "Could not send connect cmd\n");
 		goto err;
 	}
 
 	bytes_recv = __mei_cl_recv(cl, (u8 *)reply, connect_resp_length);
 	if (bytes_recv < 0) {
-		dev_err(&dev->pdev->dev, "Could not read connect response\n");
+		dev_err(dev->dev, "Could not read connect response\n");
 		ret = bytes_recv;
 		goto err;
 	}
 
-	dev_info(&dev->pdev->dev, "IVN 0x%x Vendor ID 0x%x\n",
+	dev_info(dev->dev, "IVN 0x%x Vendor ID 0x%x\n",
 		 connect_resp->fw_ivn, connect_resp->vendor_id);
 
-	dev_info(&dev->pdev->dev, "ME FW %d.%d.%d.%d\n",
+	dev_info(dev->dev, "ME FW %d.%d.%d.%d\n",
 		connect_resp->me_major, connect_resp->me_minor,
 		connect_resp->me_hotfix, connect_resp->me_build);
 
@@ -279,7 +279,7 @@ static int mei_nfc_if_version(struct mei_nfc_dev *ndev)
 
 	ret = __mei_cl_send(cl, (u8 *)&cmd, sizeof(struct mei_nfc_cmd));
 	if (ret < 0) {
-		dev_err(&dev->pdev->dev, "Could not send IF version cmd\n");
+		dev_err(dev->dev, "Could not send IF version cmd\n");
 		return ret;
 	}
 
@@ -293,7 +293,7 @@ static int mei_nfc_if_version(struct mei_nfc_dev *ndev)
 
 	bytes_recv = __mei_cl_recv(cl, (u8 *)reply, if_version_length);
 	if (bytes_recv < 0 || bytes_recv < sizeof(struct mei_nfc_reply)) {
-		dev_err(&dev->pdev->dev, "Could not read IF version\n");
+		dev_err(dev->dev, "Could not read IF version\n");
 		ret = -EIO;
 		goto err;
 	}
@@ -319,7 +319,7 @@ static int mei_nfc_enable(struct mei_cl_device *cldev)
 
 	ret = mei_nfc_connect(ndev);
 	if (ret < 0) {
-		dev_err(&dev->pdev->dev, "Could not connect to NFC");
+		dev_err(dev->dev, "Could not connect to NFC");
 		return ret;
 	}
 
@@ -361,7 +361,7 @@ static int mei_nfc_send(struct mei_cl_device *cldev, u8 *buf, size_t length)
 
 	if (!wait_event_interruptible_timeout(ndev->send_wq,
 				ndev->recv_req_id == ndev->req_id, HZ)) {
-		dev_err(&dev->pdev->dev, "NFC MEI command timeout\n");
+		dev_err(dev->dev, "NFC MEI command timeout\n");
 		err = -ETIME;
 	} else {
 		ndev->req_id++;
@@ -418,8 +418,7 @@ static void mei_nfc_init(struct work_struct *work)
 
 	if (mei_cl_connect(cl_info, NULL) < 0) {
 		mutex_unlock(&dev->device_lock);
-		dev_err(&dev->pdev->dev,
-			"Could not connect to the NFC INFO ME client");
+		dev_err(dev->dev, "Could not connect to the NFC INFO ME client");
 
 		goto err;
 	}
@@ -427,21 +426,19 @@ static void mei_nfc_init(struct work_struct *work)
 	mutex_unlock(&dev->device_lock);
 
 	if (mei_nfc_if_version(ndev) < 0) {
-		dev_err(&dev->pdev->dev, "Could not get the NFC interface version");
+		dev_err(dev->dev, "Could not get the NFC interface version");
 
 		goto err;
 	}
 
-	dev_info(&dev->pdev->dev,
-		"NFC MEI VERSION: IVN 0x%x Vendor ID 0x%x Type 0x%x\n",
+	dev_info(dev->dev, "NFC MEI VERSION: IVN 0x%x Vendor ID 0x%x Type 0x%x\n",
 		ndev->fw_ivn, ndev->vendor_id, ndev->radio_type);
 
 	mutex_lock(&dev->device_lock);
 
 	if (mei_cl_disconnect(cl_info) < 0) {
 		mutex_unlock(&dev->device_lock);
-		dev_err(&dev->pdev->dev,
-			"Could not disconnect the NFC INFO ME client");
+		dev_err(dev->dev, "Could not disconnect the NFC INFO ME client");
 
 		goto err;
 	}
@@ -449,15 +446,13 @@ static void mei_nfc_init(struct work_struct *work)
 	mutex_unlock(&dev->device_lock);
 
 	if (mei_nfc_build_bus_name(ndev) < 0) {
-		dev_err(&dev->pdev->dev,
-			"Could not build the bus ID name\n");
+		dev_err(dev->dev, "Could not build the bus ID name\n");
 		return;
 	}
 
 	cldev = mei_cl_add_device(dev, mei_nfc_guid, ndev->bus_name, &nfc_ops);
 	if (!cldev) {
-		dev_err(&dev->pdev->dev,
-			"Could not add the NFC device to the MEI bus\n");
+		dev_err(dev->dev, "Could not add the NFC device to the MEI bus\n");
 
 		goto err;
 	}
@@ -500,7 +495,7 @@ int mei_nfc_host_init(struct mei_device *dev)
 	/* check for valid client id */
 	me_cl = mei_me_cl_by_uuid(dev, &mei_nfc_info_guid);
 	if (!me_cl) {
-		dev_info(&dev->pdev->dev, "nfc: failed to find the client\n");
+		dev_info(dev->dev, "nfc: failed to find the client\n");
 		ret = -ENOTTY;
 		goto err;
 	}
@@ -518,7 +513,7 @@ int mei_nfc_host_init(struct mei_device *dev)
 	/* check for valid client id */
 	me_cl = mei_me_cl_by_uuid(dev, &mei_nfc_guid);
 	if (!me_cl) {
-		dev_info(&dev->pdev->dev, "nfc: failed to find the client\n");
+		dev_info(dev->dev, "nfc: failed to find the client\n");
 		ret = -ENOTTY;
 		goto err;
 	}
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index a0e9422..83e8892 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -451,7 +451,7 @@ static inline void mei_me_set_pm_domain(struct mei_device *dev)
 static inline void mei_me_unset_pm_domain(struct mei_device *dev)
 {
 	/* stop using pm callbacks if any */
-	dev->pdev->dev.pm_domain = NULL;
+	dev->dev->pm_domain = NULL;
 }
 #endif /* CONFIG_PM_RUNTIME */
 
diff --git a/drivers/misc/mei/pci-txe.c b/drivers/misc/mei/pci-txe.c
index a5ce2ab..a1f60be 100644
--- a/drivers/misc/mei/pci-txe.c
+++ b/drivers/misc/mei/pci-txe.c
@@ -399,7 +399,7 @@ static inline void mei_txe_set_pm_domain(struct mei_device *dev)
 static inline void mei_txe_unset_pm_domain(struct mei_device *dev)
 {
 	/* stop using pm callbacks if any */
-	dev->pdev->dev.pm_domain = NULL;
+	dev->dev->pm_domain = NULL;
 }
 #endif /* CONFIG_PM_RUNTIME */
 
diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index 40f46e4..d28511b 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -42,7 +42,7 @@ const uuid_le mei_wd_guid = UUID_LE(0x05B79A6F, 0x4628, 0x4D7F, 0x89,
 
 static void mei_wd_set_start_timeout(struct mei_device *dev, u16 timeout)
 {
-	dev_dbg(&dev->pdev->dev, "wd: set timeout=%d.\n", timeout);
+	dev_dbg(dev->dev, "wd: set timeout=%d.\n", timeout);
 	memcpy(dev->wd_data, mei_start_wd_params, MEI_WD_HDR_SIZE);
 	memcpy(dev->wd_data + MEI_WD_HDR_SIZE, &timeout, sizeof(u16));
 }
@@ -71,7 +71,7 @@ int mei_wd_host_init(struct mei_device *dev)
 	/* check for valid client id */
 	me_cl = mei_me_cl_by_uuid(dev, &mei_wd_guid);
 	if (!me_cl) {
-		dev_info(&dev->pdev->dev, "wd: failed to find the client\n");
+		dev_info(dev->dev, "wd: failed to find the client\n");
 		return -ENOTTY;
 	}
 
@@ -81,14 +81,14 @@ int mei_wd_host_init(struct mei_device *dev)
 	ret = mei_cl_link(cl, MEI_WD_HOST_CLIENT_ID);
 
 	if (ret < 0) {
-		dev_info(&dev->pdev->dev, "wd: failed link client\n");
+		dev_info(dev->dev, "wd: failed link client\n");
 		return ret;
 	}
 
 	ret = mei_cl_connect(cl, NULL);
 
 	if (ret) {
-		dev_err(&dev->pdev->dev, "wd: failed to connect = %d\n", ret);
+		dev_err(dev->dev, "wd: failed to connect = %d\n", ret);
 		mei_cl_unlink(cl);
 		return ret;
 	}
@@ -128,19 +128,19 @@ int mei_wd_send(struct mei_device *dev)
 	else if (!memcmp(dev->wd_data, mei_stop_wd_params, MEI_WD_HDR_SIZE))
 		hdr.length = MEI_WD_STOP_MSG_SIZE;
 	else {
-		dev_err(&dev->pdev->dev, "wd: invalid message is to be sent, aborting\n");
+		dev_err(dev->dev, "wd: invalid message is to be sent, aborting\n");
 		return -EINVAL;
 	}
 
 	ret = mei_write_message(dev, &hdr, dev->wd_data);
 	if (ret) {
-		dev_err(&dev->pdev->dev, "wd: write message failed\n");
+		dev_err(dev->dev, "wd: write message failed\n");
 		return ret;
 	}
 
 	ret = mei_cl_flow_ctrl_reduce(cl);
 	if (ret) {
-		dev_err(&dev->pdev->dev, "wd: flow_ctrl_reduce failed.\n");
+		dev_err(dev->dev, "wd: flow_ctrl_reduce failed.\n");
 		return ret;
 	}
 
@@ -193,11 +193,10 @@ int mei_wd_stop(struct mei_device *dev)
 	if (dev->wd_state != MEI_WD_IDLE) {
 		/* timeout */
 		ret = -ETIME;
-		dev_warn(&dev->pdev->dev,
-			"wd: stop failed to complete ret=%d.\n", ret);
+		dev_warn(dev->dev, "wd: stop failed to complete ret=%d\n", ret);
 		goto err;
 	}
-	dev_dbg(&dev->pdev->dev, "wd: stop completed after %u msec\n",
+	dev_dbg(dev->dev, "wd: stop completed after %u msec\n",
 			MEI_WD_STOP_TIMEOUT - jiffies_to_msecs(ret));
 	return 0;
 err:
@@ -223,15 +222,13 @@ static int mei_wd_ops_start(struct watchdog_device *wd_dev)
 	mutex_lock(&dev->device_lock);
 
 	if (dev->dev_state != MEI_DEV_ENABLED) {
-		dev_dbg(&dev->pdev->dev,
-			"wd: dev_state != MEI_DEV_ENABLED  dev_state = %s\n",
+		dev_dbg(dev->dev, "wd: dev_state != MEI_DEV_ENABLED  dev_state = %s\n",
 			mei_dev_state_str(dev->dev_state));
 		goto end_unlock;
 	}
 
 	if (dev->wd_cl.state != MEI_FILE_CONNECTED)	{
-		dev_dbg(&dev->pdev->dev,
-			"MEI Driver is not connected to Watchdog Client\n");
+		dev_dbg(dev->dev, "MEI Driver is not connected to Watchdog Client\n");
 		goto end_unlock;
 	}
 
@@ -284,7 +281,7 @@ static int mei_wd_ops_ping(struct watchdog_device *wd_dev)
 	mutex_lock(&dev->device_lock);
 
 	if (dev->wd_cl.state != MEI_FILE_CONNECTED) {
-		dev_err(&dev->pdev->dev, "wd: not connected.\n");
+		dev_err(dev->dev, "wd: not connected.\n");
 		ret = -ENODEV;
 		goto end;
 	}
@@ -297,7 +294,7 @@ static int mei_wd_ops_ping(struct watchdog_device *wd_dev)
 	/* Check if we can send the ping to HW*/
 	if (ret && mei_hbuf_acquire(dev)) {
 
-		dev_dbg(&dev->pdev->dev, "wd: sending ping\n");
+		dev_dbg(dev->dev, "wd: sending ping\n");
 
 		ret = mei_wd_send(dev);
 		if (ret)
@@ -380,13 +377,12 @@ int mei_watchdog_register(struct mei_device *dev)
 	ret = watchdog_register_device(&amt_wd_dev);
 	mutex_lock(&dev->device_lock);
 	if (ret) {
-		dev_err(&dev->pdev->dev, "wd: unable to register watchdog device = %d.\n",
+		dev_err(dev->dev, "wd: unable to register watchdog device = %d.\n",
 			ret);
 		return ret;
 	}
 
-	dev_dbg(&dev->pdev->dev,
-		"wd: successfully register watchdog interface.\n");
+	dev_dbg(dev->dev, "wd: successfully register watchdog interface.\n");
 	watchdog_set_drvdata(&amt_wd_dev, dev);
 	return 0;
 }
-- 
1.9.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab3BFMH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 07:07:57 -0500
Received: from mga11.intel.com ([192.55.52.93]:58289 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001Ab3BFMHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 07:07:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,615,1355126400"; 
   d="scan'208";a="287310874"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 5/6] mei: rename to mei_host_buffer_is_empty to hbuf_is_ready
Date: Wed,  6 Feb 2013 14:06:43 +0200
Message-Id: <1360152404-5769-6-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1360152404-5769-1-git-send-email-tomas.winkler@intel.com>
References: <1360152404-5769-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we rename the mei_host_buffer_is_empty to keep naming
convention of hbuf and also make the query more generic
to be correct also for other under laying hardware

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c  |    8 ++++----
 drivers/misc/mei/client.c  |   13 ++++++-------
 drivers/misc/mei/hw-me.c   |    2 +-
 drivers/misc/mei/main.c    |    4 ++--
 drivers/misc/mei/mei_dev.h |   14 ++++++++++----
 drivers/misc/mei/wd.c      |    9 ++++-----
 6 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index a7c4838..c86d7e3 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -297,9 +297,9 @@ static int mei_amthif_send_cmd(struct mei_device *dev, struct mei_cl_cb *cb)
 	if (ret < 0)
 		return ret;
 
-	if (ret && dev->mei_host_buffer_is_empty) {
+	if (ret && dev->hbuf_is_ready) {
 		ret = 0;
-		dev->mei_host_buffer_is_empty = false;
+		dev->hbuf_is_ready = false;
 		if (cb->request_buffer.size > mei_hbuf_max_len(dev)) {
 			mei_hdr.length = mei_hbuf_max_len(dev);
 			mei_hdr.msg_complete = 0;
@@ -330,7 +330,7 @@ static int mei_amthif_send_cmd(struct mei_device *dev, struct mei_cl_cb *cb)
 			list_add_tail(&cb->list, &dev->write_list.list);
 		}
 	} else {
-		if (!(dev->mei_host_buffer_is_empty))
+		if (!dev->hbuf_is_ready)
 			dev_dbg(&dev->pdev->dev, "host buffer is not empty");
 
 		dev_dbg(&dev->pdev->dev, "No flow control credentials, so add iamthif cb to write list.\n");
@@ -583,7 +583,7 @@ int mei_amthif_irq_read(struct mei_device *dev, s32 *slots)
 	dev->iamthif_msg_buf_index = 0;
 	dev->iamthif_msg_buf_size = 0;
 	dev->iamthif_stall_timer = MEI_IAMTHIF_STALL_TIMER;
-	dev->mei_host_buffer_is_empty = mei_hbuf_is_ready(dev);
+	dev->hbuf_is_ready = mei_hbuf_is_ready(dev);
 	return 0;
 }
 
diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index a921001..e46663e 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -393,8 +393,8 @@ int mei_cl_disconnect(struct mei_cl *cl)
 		return -ENOMEM;
 
 	cb->fop_type = MEI_FOP_CLOSE;
-	if (dev->mei_host_buffer_is_empty) {
-		dev->mei_host_buffer_is_empty = false;
+	if (dev->hbuf_is_ready) {
+		dev->hbuf_is_ready = false;
 		if (mei_hbm_cl_disconnect_req(dev, cl)) {
 			rets = -ENODEV;
 			dev_err(&dev->pdev->dev, "failed to disconnect.\n");
@@ -496,9 +496,8 @@ int mei_cl_connect(struct mei_cl *cl, struct file *file)
 
 	cb->fop_type = MEI_FOP_IOCTL;
 
-	if (dev->mei_host_buffer_is_empty &&
-	    !mei_cl_is_other_connecting(cl)) {
-		dev->mei_host_buffer_is_empty = false;
+	if (dev->hbuf_is_ready && !mei_cl_is_other_connecting(cl)) {
+		dev->hbuf_is_ready = false;
 
 		if (mei_hbm_cl_connect_req(dev, cl)) {
 			rets = -ENODEV;
@@ -661,8 +660,8 @@ int mei_cl_read_start(struct mei_cl *cl)
 
 	cb->fop_type = MEI_FOP_READ;
 	cl->read_cb = cb;
-	if (dev->mei_host_buffer_is_empty) {
-		dev->mei_host_buffer_is_empty = false;
+	if (dev->hbuf_is_ready) {
+		dev->hbuf_is_ready = false;
 		if (mei_hbm_cl_flow_control_req(dev, cl)) {
 			rets = -ENODEV;
 			goto err;
diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 3bebf8d..45ea718 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -486,7 +486,7 @@ irqreturn_t mei_me_irq_thread_handler(int irq, void *dev_id)
 	rets = mei_irq_write_handler(dev, &complete_list);
 end:
 	dev_dbg(&dev->pdev->dev, "end of bottom half function.\n");
-	dev->mei_host_buffer_is_empty = mei_hbuf_is_ready(dev);
+	dev->hbuf_is_ready = mei_hbuf_is_ready(dev);
 
 	bus_message_received = false;
 	if (dev->recvd_msg && waitqueue_active(&dev->wait_recvd_msg)) {
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 843ae2f..903f809 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -454,14 +454,14 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 	if (rets < 0)
 		goto err;
 
-	if (rets == 0 || dev->mei_host_buffer_is_empty == false) {
+	if (rets == 0 || !dev->hbuf_is_ready) {
 		write_cb->buf_idx = 0;
 		mei_hdr.msg_complete = 0;
 		cl->writing_state = MEI_WRITING;
 		goto out;
 	}
 
-	dev->mei_host_buffer_is_empty = false;
+	dev->hbuf_is_ready = false;
 	if (length >  mei_hbuf_max_len(dev)) {
 		mei_hdr.length = mei_hbuf_max_len(dev);
 		mei_hdr.msg_complete = 0;
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 7d07cef..cb80166 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -265,9 +265,13 @@ struct mei_hw_ops {
 
 /**
  * struct mei_device -  MEI private device struct
+
  * @mem_addr - mem mapped base register address
- * @hbuf_depth - depth of host(write) buffer
- * @wr_ext_msg - buffer for hbm control responses (set in read cycle)
+
+ * @hbuf_depth - depth of hardware host/write buffer is slots
+ * @hbuf_is_ready - query if the host host/write buffer is ready
+ * @wr_msg - the buffer for hbm control messages
+ * @wr_ext_msg - the buffer for hbm control responses (set in read cycle)
  */
 struct mei_device {
 	struct pci_dev *pdev;	/* pointer to pci device struct */
@@ -294,7 +298,6 @@ struct mei_device {
 	struct delayed_work timer_work;	/* MEI timer delayed work (timeouts) */
 	bool recvd_msg;
 
-	u8  hbuf_depth;
 	/*
 	 * waiting queue for receive message from FW
 	 */
@@ -311,6 +314,10 @@ struct mei_device {
 	unsigned char rd_msg_buf[MEI_RD_MSG_BUF_SIZE];	/* control messages */
 	u32 rd_msg_hdr;
 
+	/* write buffer */
+	u8 hbuf_depth;
+	bool hbuf_is_ready;
+
 	/* used for control messages */
 	struct {
 		struct mei_msg_hdr hdr;
@@ -330,7 +337,6 @@ struct mei_device {
 	u8 me_clients_num;
 	u8 me_client_presentation_num;
 	u8 me_client_index;
-	bool mei_host_buffer_is_empty;
 
 	struct mei_cl wd_cl;
 	enum mei_wd_states wd_state;
diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index 77b3820..2413247 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -157,9 +157,9 @@ int mei_wd_stop(struct mei_device *dev)
 	if (ret < 0)
 		goto out;
 
-	if (ret && dev->mei_host_buffer_is_empty) {
+	if (ret && dev->hbuf_is_ready) {
 		ret = 0;
-		dev->mei_host_buffer_is_empty = false;
+		dev->hbuf_is_ready = false;
 
 		if (!mei_wd_send(dev)) {
 			ret = mei_cl_flow_ctrl_reduce(&dev->wd_cl);
@@ -282,10 +282,9 @@ static int mei_wd_ops_ping(struct watchdog_device *wd_dev)
 	dev->wd_state = MEI_WD_RUNNING;
 
 	/* Check if we can send the ping to HW*/
-	if (dev->mei_host_buffer_is_empty &&
-	    mei_cl_flow_ctrl_creds(&dev->wd_cl) > 0) {
+	if (dev->hbuf_is_ready && mei_cl_flow_ctrl_creds(&dev->wd_cl) > 0) {
 
-		dev->mei_host_buffer_is_empty = false;
+		dev->hbuf_is_ready = false;
 		dev_dbg(&dev->pdev->dev, "wd: sending ping\n");
 
 		if (mei_wd_send(dev)) {
-- 
1.7.4.4


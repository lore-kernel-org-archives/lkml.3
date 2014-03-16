Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167AbaCPXJY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 19:09:24 -0400
Received: from smtprelay0210.hostedemail.com ([216.40.44.210]:40591 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755790AbaCPXJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 19:09:23 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:1:41:69:355:379:541:599:800:960:966:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:2194:2196:2199:2200:2393:2553:2559:2562:2639:2828:2902:2904:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3871:3872:3874:4037:4250:4321:4385:4419:4605:5007:7558:7576:7652:7809:7903:8603:9010:9040:9545:9592:10004:10026:10848:10967:11026:11232:11473:11657:11658:11914:12043:12262:12296:12438:12517:12519:12555:12663:12679:12683:12740:13019:13153:13228:13868,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: lake88_348232695984a
X-Filterd-Recvd-Size: 14419
Message-ID: <1395011359.31843.5.camel@joe-AO722>
Subject: Re: [char-misc-next 2/5] mei: use cl_dbg where appropriate
From: Joe Perches <joe@perches.com>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 16 Mar 2014 16:09:19 -0700
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B1AFA02E5@HASMSX106.ger.corp.intel.com>
References: <1394973358-21690-1-git-send-email-tomas.winkler@intel.com>
	 <1394973358-21690-3-git-send-email-tomas.winkler@intel.com>
	 <1394987781.5689.23.camel@joe-AO722>
	 <5B8DA87D05A7694D9FA63FD143655C1B1AFA02E5@HASMSX106.ger.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-03-16 at 22:19 +0000, Winkler, Tomas wrote:
> > #define cl_dbg(dev, cl, format, arg...) \
> > 	dev_dbg(&(dev)->pdev->dev, MEI_CL_FMT format, MEI_CL_PRM(cl),
> > ##arg)
[]
> > #define cl_dbg(cl, format, ...) \
> > 	dev_dbg(&(cl)->dev)->pdev->dev, MEI_CL_FMT format, MEI_CL_PRM(cl),
> > ##__VA_ARGS__)
[]
> Yes, I'm aware of this, at the time I've preferred consistently passing dev as a first argument. 
> It can be changed I just  personally  don't feel some big gain.

I do wonder about the mixture of dev_dbg and cl_dbg.
Was there any rationale about this mixture?

Here's a potential cleanup

From: Joe Perches <joe@perches.com>
Date: Sun, 16 Mar 2014 15:55:06 -0700
Subject: [PATCH] mei: Remove unnecessary dev arg from cl_<level> logging

dev is a member of cl so use that instead.

Add missing newlines.
Neaten logging messages and alignment.
Remove now unnecessary declaration too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/misc/mei/amthif.c    |  2 +-
 drivers/misc/mei/client.c    | 53 +++++++++++++++++++-------------------------
 drivers/misc/mei/client.h    | 16 ++++++++-----
 drivers/misc/mei/hbm.c       |  4 ++--
 drivers/misc/mei/interrupt.c | 20 ++++++++---------
 drivers/misc/mei/main.c      |  4 ++--
 drivers/misc/mei/pci-me.c    |  2 +-
 7 files changed, 50 insertions(+), 51 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index f05d54d..7bb66c7 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -458,7 +458,7 @@ int mei_amthif_irq_write(struct mei_cl *cl, struct mei_cl_cb *cb,
 		return rets;
 
 	if (rets == 0) {
-		cl_dbg(dev, cl, "No flow control credentials: not sending.\n");
+		cl_dbg(cl, "No flow control credentials: not sending\n");
 		return 0;
 	}
 
diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 7536081..a095afa 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -184,14 +184,10 @@ int mei_io_cb_alloc_resp_buf(struct mei_cl_cb *cb, size_t length)
  */
 int mei_cl_flush_queues(struct mei_cl *cl)
 {
-	struct mei_device *dev;
-
 	if (WARN_ON(!cl || !cl->dev))
 		return -EINVAL;
 
-	dev = cl->dev;
-
-	cl_dbg(dev, cl, "remove list entry belonging to cl\n");
+	cl_dbg(cl, "remove list entry belonging to cl\n");
 	mei_io_list_flush(&cl->dev->read_list, cl);
 	mei_io_list_flush(&cl->dev->write_list, cl);
 	mei_io_list_flush(&cl->dev->write_waiting_list, cl);
@@ -304,7 +300,7 @@ int mei_cl_link(struct mei_cl *cl, int id)
 
 	cl->state = MEI_FILE_INITIALIZING;
 
-	cl_dbg(dev, cl, "link cl\n");
+	cl_dbg(cl, "link cl\n");
 	return 0;
 }
 
@@ -327,7 +323,7 @@ int mei_cl_unlink(struct mei_cl *cl)
 
 	dev = cl->dev;
 
-	cl_dbg(dev, cl, "unlink client");
+	cl_dbg(cl, "unlink client\n");
 
 	if (dev->open_handle_count > 0)
 		dev->open_handle_count--;
@@ -409,7 +405,7 @@ int mei_cl_disconnect(struct mei_cl *cl)
 
 	dev = cl->dev;
 
-	cl_dbg(dev, cl, "disconnecting");
+	cl_dbg(cl, "disconnecting\n");
 
 	if (cl->state != MEI_FILE_DISCONNECTING)
 		return 0;
@@ -422,13 +418,13 @@ int mei_cl_disconnect(struct mei_cl *cl)
 	if (mei_hbuf_acquire(dev)) {
 		if (mei_hbm_cl_disconnect_req(dev, cl)) {
 			rets = -ENODEV;
-			cl_err(dev, cl, "failed to disconnect.\n");
+			cl_err(cl, "failed to disconnect\n");
 			goto free;
 		}
 		mdelay(10); /* Wait for hardware disconnection ready */
 		list_add_tail(&cb->list, &dev->ctrl_rd_list.list);
 	} else {
-		cl_dbg(dev, cl, "add disconnect cb to control write list\n");
+		cl_dbg(cl, "add disconnect cb to control write list\n");
 		list_add_tail(&cb->list, &dev->ctrl_wr_list.list);
 
 	}
@@ -441,17 +437,16 @@ int mei_cl_disconnect(struct mei_cl *cl)
 	mutex_lock(&dev->device_lock);
 	if (MEI_FILE_DISCONNECTED == cl->state) {
 		rets = 0;
-		cl_dbg(dev, cl, "successfully disconnected from FW client.\n");
+		cl_dbg(cl, "successfully disconnected from FW client\n");
 	} else {
 		rets = -ENODEV;
 		if (MEI_FILE_DISCONNECTED != cl->state)
-			cl_err(dev, cl, "wrong status client disconnect.\n");
+			cl_err(cl, "wrong status client disconnect\n");
 
 		if (err)
-			cl_dbg(dev, cl, "wait failed disconnect err=%08x\n",
-					err);
+			cl_dbg(cl, "wait failed disconnect err=%08x\n", err);
 
-		cl_err(dev, cl, "failed to disconnect from FW client.\n");
+		cl_err(cl, "failed to disconnect from FW client\n");
 	}
 
 	mei_io_list_flush(&dev->ctrl_rd_list, cl);
@@ -582,7 +577,7 @@ int mei_cl_flow_ctrl_creds(struct mei_cl *cl)
 
 	id = mei_me_cl_by_id(dev, cl->me_client_id);
 	if (id < 0) {
-		cl_err(dev, cl, "no such me client %d\n", cl->me_client_id);
+		cl_err(cl, "no such me client %d\n", cl->me_client_id);
 		return id;
 	}
 
@@ -618,7 +613,7 @@ int mei_cl_flow_ctrl_reduce(struct mei_cl *cl)
 
 	id = mei_me_cl_by_id(dev, cl->me_client_id);
 	if (id < 0) {
-		cl_err(dev, cl, "no such me client %d\n", cl->me_client_id);
+		cl_err(cl, "no such me client %d\n", cl->me_client_id);
 		return id;
 	}
 
@@ -658,12 +653,12 @@ int mei_cl_read_start(struct mei_cl *cl, size_t length)
 		return -ENODEV;
 
 	if (cl->read_cb) {
-		cl_dbg(dev, cl, "read is pending.\n");
+		cl_dbg(cl, "read is pending\n");
 		return -EBUSY;
 	}
 	i = mei_me_cl_by_id(dev, cl->me_client_id);
 	if (i < 0) {
-		cl_err(dev, cl, "no such me client %d\n", cl->me_client_id);
+		cl_err(cl, "no such me client %d\n", cl->me_client_id);
 		return  -ENOTTY;
 	}
 
@@ -680,7 +675,7 @@ int mei_cl_read_start(struct mei_cl *cl, size_t length)
 	cb->fop_type = MEI_FOP_READ;
 	if (mei_hbuf_acquire(dev)) {
 		if (mei_hbm_cl_flow_control_req(dev, cl)) {
-			cl_err(dev, cl, "flow control send failed\n");
+			cl_err(cl, "flow control send failed\n");
 			rets = -ENODEV;
 			goto err;
 		}
@@ -730,7 +725,7 @@ int mei_cl_irq_write(struct mei_cl *cl, struct mei_cl_cb *cb,
 		return rets;
 
 	if (rets == 0) {
-		cl_dbg(dev, cl,	"No flow control credentials: not sending.\n");
+		cl_dbg(cl, "No flow control credentials: not sending\n");
 		return 0;
 	}
 
@@ -757,8 +752,8 @@ int mei_cl_irq_write(struct mei_cl *cl, struct mei_cl_cb *cb,
 		return 0;
 	}
 
-	cl_dbg(dev, cl, "buf: size = %d idx = %lu\n",
-			cb->request_buffer.size, cb->buf_idx);
+	cl_dbg(cl, "buf: size = %d idx = %lu\n",
+	       cb->request_buffer.size, cb->buf_idx);
 
 	rets = mei_write_message(dev, &mei_hdr, buf->data + cb->buf_idx);
 	if (rets) {
@@ -805,11 +800,9 @@ int mei_cl_write(struct mei_cl *cl, struct mei_cl_cb *cb, bool blocking)
 
 	dev = cl->dev;
 
-
 	buf = &cb->request_buffer;
 
-	cl_dbg(dev, cl, "mei_cl_write %d\n", buf->size);
-
+	cl_dbg(cl, "mei_cl_write %d\n", buf->size);
 
 	cb->fop_type = MEI_FOP_WRITE;
 	cb->buf_idx = 0;
@@ -826,12 +819,12 @@ int mei_cl_write(struct mei_cl *cl, struct mei_cl_cb *cb, bool blocking)
 		goto err;
 
 	if (rets == 0) {
-		cl_dbg(dev, cl, "No flow control credentials: not sending.\n");
+		cl_dbg(cl, "No flow control credentials: not sending\n");
 		rets = buf->size;
 		goto out;
 	}
 	if (!mei_hbuf_acquire(dev)) {
-		cl_dbg(dev, cl, "Cannot acquire the host buffer: not sending.\n");
+		cl_dbg(cl, "Cannot acquire the host buffer: not sending\n");
 		rets = buf->size;
 		goto out;
 	}
@@ -939,11 +932,11 @@ void mei_cl_all_wakeup(struct mei_device *dev)
 	struct mei_cl *cl;
 	list_for_each_entry(cl, &dev->file_list, link) {
 		if (waitqueue_active(&cl->rx_wait)) {
-			cl_dbg(dev, cl, "Waking up reading client!\n");
+			cl_dbg(cl, "Waking up reading client!\n");
 			wake_up_interruptible(&cl->rx_wait);
 		}
 		if (waitqueue_active(&cl->tx_wait)) {
-			cl_dbg(dev, cl, "Waking up writing client!\n");
+			cl_dbg(cl, "Waking up writing client!\n");
 			wake_up_interruptible(&cl->tx_wait);
 		}
 	}
diff --git a/drivers/misc/mei/client.h b/drivers/misc/mei/client.h
index 257aa5f..ddc9979 100644
--- a/drivers/misc/mei/client.h
+++ b/drivers/misc/mei/client.h
@@ -118,10 +118,16 @@ void mei_cl_all_write_clear(struct mei_device *dev);
 #define MEI_CL_FMT "cl:host=%02d me=%02d "
 #define MEI_CL_PRM(cl) (cl)->host_client_id, (cl)->me_client_id
 
-#define cl_dbg(dev, cl, format, arg...) \
-	dev_dbg(&(dev)->pdev->dev, MEI_CL_FMT format, MEI_CL_PRM(cl), ##arg)
-
-#define cl_err(dev, cl, format, arg...) \
-	dev_err(&(dev)->pdev->dev, MEI_CL_FMT format, MEI_CL_PRM(cl), ##arg)
+#define cl_dbg(cl, fmt, ...)						\
+	dev_dbg(&(cl)->dev->pdev->dev,					\
+		"cl:host=%02d me=%02d " fmt,				\
+		(cl)->host_client_id, (cl)->me_client_id,		\
+		##__VA_ARGS__)
+
+#define cl_err(cl, fmt, ...)						\
+	dev_err(&(cl)->dev->pdev->dev,					\
+		"cl:host=%02d me=%02d " fmt,				\
+		(cl)->host_client_id, (cl)->me_client_id,		\
+		##__VA_ARGS__)
 
 #endif /* _MEI_CLIENT_H_ */
diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index dd7a788..a063bb4 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -330,7 +330,7 @@ int mei_hbm_cl_flow_control_req(struct mei_device *dev, struct mei_cl *cl)
 	mei_hbm_hdr(mei_hdr, len);
 	mei_hbm_cl_hdr(cl, MEI_FLOW_CONTROL_CMD, dev->wr_msg.data, len);
 
-	cl_dbg(dev, cl, "sending flow control\n");
+	cl_dbg(cl, "sending flow control\n");
 
 	return mei_write_message(dev, mei_hdr, dev->wr_msg.data);
 }
@@ -570,7 +570,7 @@ static int mei_hbm_fw_disconnect_req(struct mei_device *dev,
 			if (!cb)
 				return -ENOMEM;
 			cb->fop_type = MEI_FOP_DISCONNECT_RSP;
-			cl_dbg(dev, cl, "add disconnect response as first\n");
+			cl_dbg(cl, "add disconnect response as first\n");
 			list_add(&cb->list, &dev->ctrl_wr_list.list);
 
 			break;
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 2fbf0c0..351e568 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -113,21 +113,21 @@ static int mei_cl_irq_read_msg(struct mei_device *dev,
 
 		if (cb->response_buffer.size == 0 ||
 		    cb->response_buffer.data == NULL) {
-			cl_err(dev, cl, "response buffer is not allocated.\n");
+			cl_err(cl, "response buffer is not allocated\n");
 			list_del(&cb->list);
 			return -ENOMEM;
 		}
 
 		if (cb->response_buffer.size < mei_hdr->length + cb->buf_idx) {
-			cl_dbg(dev, cl, "message overflow. size %d len %d idx %ld\n",
-				cb->response_buffer.size,
-				mei_hdr->length, cb->buf_idx);
+			cl_dbg(cl, "message overflow. size %d len %d idx %ld\n",
+			       cb->response_buffer.size,
+			       mei_hdr->length, cb->buf_idx);
 			buffer = krealloc(cb->response_buffer.data,
 					  mei_hdr->length + cb->buf_idx,
 					  GFP_KERNEL);
 
 			if (!buffer) {
-				cl_err(dev, cl, "allocation failed.\n");
+				cl_err(cl, "allocation failed\n");
 				list_del(&cb->list);
 				return -ENOMEM;
 			}
@@ -143,8 +143,8 @@ static int mei_cl_irq_read_msg(struct mei_device *dev,
 		if (mei_hdr->msg_complete) {
 			cl->status = 0;
 			list_del(&cb->list);
-			cl_dbg(dev, cl, "completed read length = %lu\n",
-				cb->buf_idx);
+			cl_dbg(cl, "completed read length = %lu\n",
+			       cb->buf_idx);
 			list_add_tail(&cb->list, &complete_list->list);
 		}
 		break;
@@ -369,7 +369,7 @@ int mei_irq_read_handler(struct mei_device *dev,
 	/* find recipient cl */
 	list_for_each_entry(cl, &dev->file_list, link) {
 		if (mei_cl_hbm_equal(cl, mei_hdr)) {
-			cl_dbg(dev, cl, "got a message\n");
+			cl_dbg(cl, "got a message\n");
 			break;
 		}
 	}
@@ -459,12 +459,12 @@ int mei_irq_write_handler(struct mei_device *dev, struct mei_cl_cb *cmpl_list)
 		if (MEI_WRITING == cl->writing_state &&
 		    cb->fop_type == MEI_FOP_WRITE &&
 		    cl != &dev->iamthif_cl) {
-			cl_dbg(dev, cl, "MEI WRITE COMPLETE\n");
+			cl_dbg(cl, "MEI WRITE COMPLETE\n");
 			cl->writing_state = MEI_WRITE_COMPLETE;
 			list_add_tail(&cb->list, &cmpl_list->list);
 		}
 		if (cl == &dev->iamthif_cl) {
-			cl_dbg(dev, cl, "check iamthif flow control.\n");
+			cl_dbg(cl, "check iamthif flow control\n");
 			if (dev->iamthif_flow_control_pending) {
 				ret = mei_amthif_irq_read(dev, &slots);
 				if (ret)
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 51c737f5..15c1ac2 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -129,11 +129,11 @@ static int mei_release(struct inode *inode, struct file *file)
 	}
 	if (cl->state == MEI_FILE_CONNECTED) {
 		cl->state = MEI_FILE_DISCONNECTING;
-		cl_dbg(dev, cl, "disconnecting\n");
+		cl_dbg(cl, "disconnecting\n");
 		rets = mei_cl_disconnect(cl);
 	}
 	mei_cl_flush_queues(cl);
-	cl_dbg(dev, cl, "removing\n");
+	cl_dbg(cl, "removing\n");
 
 	mei_cl_unlink(cl);
 
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 50d9cb5..bd7bf00 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -43,7 +43,7 @@
 #include "client.h"
 
 /* mei_pci_tbl - PCI Device ID Table */
-static DEFINE_PCI_DEVICE_TABLE(mei_me_pci_tbl) = {
+static const struct pci_device_id mei_me_pci_tbl[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82946GZ)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82G35)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82Q965)},
-- 
1.8.1.2.459.gbcd45b4.dirty




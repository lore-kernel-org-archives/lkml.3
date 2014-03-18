Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933211AbaCRUxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:53:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:18752 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932956AbaCRUxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:53:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,680,1389772800"; 
   d="scan'208";a="475172500"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [char-misc-next 10/13] mei: use runtime pm in write and read flow
Date: Tue, 18 Mar 2014 22:52:04 +0200
Message-Id: <1395175927-10562-11-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395175927-10562-1-git-send-email-tomas.winkler@intel.com>
References: <1395175927-10562-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Take rpm token on operation start to initiate rpm resume if needed.
Mark last busy time, release token and advice rpm framework
to try to autosuspend on operation end.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
---
 drivers/misc/mei/client.c | 84 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 71 insertions(+), 13 deletions(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 36eca54..0c70459 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -18,6 +18,7 @@
 #include <linux/sched.h>
 #include <linux/wait.h>
 #include <linux/delay.h>
+#include <linux/pm_runtime.h>
 
 #include <linux/mei.h>
 
@@ -415,6 +416,10 @@ void mei_host_client_init(struct work_struct *work)
 	dev->reset_count = 0;
 
 	mutex_unlock(&dev->device_lock);
+
+	pm_runtime_mark_last_busy(&dev->pdev->dev);
+	dev_dbg(&dev->pdev->dev, "rpm: autosuspend\n");
+	pm_runtime_autosuspend(&dev->pdev->dev);
 }
 
 /**
@@ -425,6 +430,12 @@ void mei_host_client_init(struct work_struct *work)
  */
 bool mei_hbuf_acquire(struct mei_device *dev)
 {
+	if (mei_pg_state(dev) == MEI_PG_ON ||
+	    dev->pg_event == MEI_PG_EVENT_WAIT) {
+		dev_dbg(&dev->pdev->dev, "device is in pg\n");
+		return false;
+	}
+
 	if (!dev->hbuf_is_ready) {
 		dev_dbg(&dev->pdev->dev, "hbuf is not ready\n");
 		return false;
@@ -460,9 +471,18 @@ int mei_cl_disconnect(struct mei_cl *cl)
 	if (cl->state != MEI_FILE_DISCONNECTING)
 		return 0;
 
+	rets = pm_runtime_get(&dev->pdev->dev);
+	if (rets < 0 && rets != -EINPROGRESS) {
+		pm_runtime_put_noidle(&dev->pdev->dev);
+		cl_err(dev, cl, "rpm: get failed %d\n", rets);
+		return rets;
+	}
+
 	cb = mei_io_cb_init(cl, NULL);
-	if (!cb)
-		return -ENOMEM;
+	if (!cb) {
+		rets = -ENOMEM;
+		goto free;
+	}
 
 	cb->fop_type = MEI_FOP_CLOSE;
 	if (mei_hbuf_acquire(dev)) {
@@ -494,8 +514,7 @@ int mei_cl_disconnect(struct mei_cl *cl)
 			cl_err(dev, cl, "wrong status client disconnect.\n");
 
 		if (err)
-			cl_dbg(dev, cl, "wait failed disconnect err=%08x\n",
-					err);
+			cl_dbg(dev, cl, "wait failed disconnect err=%d\n", err);
 
 		cl_err(dev, cl, "failed to disconnect from FW client.\n");
 	}
@@ -503,6 +522,10 @@ int mei_cl_disconnect(struct mei_cl *cl)
 	mei_io_list_flush(&dev->ctrl_rd_list, cl);
 	mei_io_list_flush(&dev->ctrl_wr_list, cl);
 free:
+	cl_dbg(dev, cl, "rpm: autosuspend\n");
+	pm_runtime_mark_last_busy(&dev->pdev->dev);
+	pm_runtime_put_autosuspend(&dev->pdev->dev);
+
 	mei_io_cb_free(cb);
 	return rets;
 }
@@ -557,6 +580,13 @@ int mei_cl_connect(struct mei_cl *cl, struct file *file)
 
 	dev = cl->dev;
 
+	rets = pm_runtime_get(&dev->pdev->dev);
+	if (rets < 0 && rets != -EINPROGRESS) {
+		pm_runtime_put_noidle(&dev->pdev->dev);
+		cl_err(dev, cl, "rpm: get failed %d\n", rets);
+		return rets;
+	}
+
 	cb = mei_io_cb_init(cl, file);
 	if (!cb) {
 		rets = -ENOMEM;
@@ -596,6 +626,10 @@ int mei_cl_connect(struct mei_cl *cl, struct file *file)
 	rets = cl->status;
 
 out:
+	cl_dbg(dev, cl, "rpm: autosuspend\n");
+	pm_runtime_mark_last_busy(&dev->pdev->dev);
+	pm_runtime_put_autosuspend(&dev->pdev->dev);
+
 	mei_io_cb_free(cb);
 	return rets;
 }
@@ -713,23 +747,32 @@ int mei_cl_read_start(struct mei_cl *cl, size_t length)
 		return  -ENOTTY;
 	}
 
+	rets = pm_runtime_get(&dev->pdev->dev);
+	if (rets < 0 && rets != -EINPROGRESS) {
+		pm_runtime_put_noidle(&dev->pdev->dev);
+		cl_err(dev, cl, "rpm: get failed %d\n", rets);
+		return rets;
+	}
+
 	cb = mei_io_cb_init(cl, NULL);
-	if (!cb)
-		return -ENOMEM;
+	if (!cb) {
+		rets = -ENOMEM;
+		goto out;
+	}
 
 	/* always allocate at least client max message */
 	length = max_t(size_t, length, dev->me_clients[i].props.max_msg_length);
 	rets = mei_io_cb_alloc_resp_buf(cb, length);
 	if (rets)
-		goto err;
+		goto out;
 
 	cb->fop_type = MEI_FOP_READ;
 	if (mei_hbuf_acquire(dev)) {
 		if (mei_hbm_cl_flow_control_req(dev, cl)) {
-			cl_err(dev, cl, "flow control send failed\n");
 			rets = -ENODEV;
-			goto err;
+			goto out;
 		}
+
 		list_add_tail(&cb->list, &dev->read_list.list);
 	} else {
 		list_add_tail(&cb->list, &dev->ctrl_wr_list.list);
@@ -737,9 +780,14 @@ int mei_cl_read_start(struct mei_cl *cl, size_t length)
 
 	cl->read_cb = cb;
 
-	return rets;
-err:
-	mei_io_cb_free(cb);
+out:
+	cl_dbg(dev, cl, "rpm: autosuspend\n");
+	pm_runtime_mark_last_busy(&dev->pdev->dev);
+	pm_runtime_put_autosuspend(&dev->pdev->dev);
+
+	if (rets)
+		mei_io_cb_free(cb);
+
 	return rets;
 }
 
@@ -776,7 +824,7 @@ int mei_cl_irq_write(struct mei_cl *cl, struct mei_cl_cb *cb,
 		return rets;
 
 	if (rets == 0) {
-		cl_dbg(dev, cl,	"No flow control credentials: not sending.\n");
+		cl_dbg(dev, cl, "No flow control credentials: not sending.\n");
 		return 0;
 	}
 
@@ -856,6 +904,12 @@ int mei_cl_write(struct mei_cl *cl, struct mei_cl_cb *cb, bool blocking)
 
 	cl_dbg(dev, cl, "mei_cl_write %d\n", buf->size);
 
+	rets = pm_runtime_get(&dev->pdev->dev);
+	if (rets < 0 && rets != -EINPROGRESS) {
+		pm_runtime_put_noidle(&dev->pdev->dev);
+		cl_err(dev, cl, "rpm: get failed %d\n", rets);
+		return rets;
+	}
 
 	cb->fop_type = MEI_FOP_WRITE;
 	cb->buf_idx = 0;
@@ -926,6 +980,10 @@ out:
 
 	rets = buf->size;
 err:
+	cl_dbg(dev, cl, "rpm: autosuspend\n");
+	pm_runtime_mark_last_busy(&dev->pdev->dev);
+	pm_runtime_put_autosuspend(&dev->pdev->dev);
+
 	return rets;
 }
 
-- 
1.8.5.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbaDNUR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 16:17:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:51847 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010AbaDNUPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 16:15:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,859,1389772800"; 
   d="scan'208";a="520341987"
From: Siva Yerramreddy <siva.krishna.kumar.reddy.yerramreddy@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>
Cc: Siva Yerramreddy <siva.krishna.kumar.reddy.yerramreddy@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [PATCH 4/8] misc: mic: add threaded irq support in host driver
Date: Mon, 14 Apr 2014 13:15:01 -0700
Message-Id: <622af43a53cf61b3c61c43194610b6787f45df3a.1397504824.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <cover.1397504824.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
References: <cover.1397504824.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
In-Reply-To: <cover.1397504824.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
References: <cover.1397504824.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert mic_request_irq to mic_request_threaded_irq to support threaded
irq for virtual devices on mic bus.

Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Reviewed-by: Nikhil Rao <nikhil.rao@intel.com>
Reviewed-by: Sudeep Dutt <sudeep.dutt@intel.com>
Signed-off-by: Siva Yerramreddy <siva.krishna.kumar.reddy.yerramreddy@intel.com>
---
 drivers/misc/mic/host/mic_intr.c   | 116 ++++++++++++++++++++++---------------
 drivers/misc/mic/host/mic_intr.h   |  18 ++++--
 drivers/misc/mic/host/mic_main.c   |   5 +-
 drivers/misc/mic/host/mic_virtio.c |   6 +-
 4 files changed, 90 insertions(+), 55 deletions(-)

diff --git a/drivers/misc/mic/host/mic_intr.c b/drivers/misc/mic/host/mic_intr.c
index dbc5afd..e53b150 100644
--- a/drivers/misc/mic/host/mic_intr.c
+++ b/drivers/misc/mic/host/mic_intr.c
@@ -24,28 +24,29 @@
 #include "../common/mic_dev.h"
 #include "mic_device.h"
 
-/*
- * mic_invoke_callback - Invoke callback functions registered for
- * the corresponding source id.
- *
- * @mdev: pointer to the mic_device instance
- * @idx: The interrupt source id.
- *
- * Returns none.
- */
-static inline void mic_invoke_callback(struct mic_device *mdev, int idx)
+static irqreturn_t mic_thread_fn(int irq, void *dev)
 {
+	struct mic_device *mdev = dev;
+	struct mic_intr_info *intr_info = mdev->intr_info;
+	struct mic_irq_info *irq_info = &mdev->irq_info;
 	struct mic_intr_cb *intr_cb;
 	struct pci_dev *pdev = container_of(mdev->sdev->parent,
-		struct pci_dev, dev);
+					    struct pci_dev, dev);
+	int i;
 
-	spin_lock(&mdev->irq_info.mic_intr_lock);
-	list_for_each_entry(intr_cb, &mdev->irq_info.cb_list[idx], list)
-		if (intr_cb->func)
-			intr_cb->func(pdev->irq, intr_cb->data);
-	spin_unlock(&mdev->irq_info.mic_intr_lock);
+	spin_lock(&irq_info->mic_thread_lock);
+	for (i = intr_info->intr_start_idx[MIC_INTR_DB];
+			i < intr_info->intr_len[MIC_INTR_DB]; i++)
+		if (test_and_clear_bit(i, &irq_info->mask)) {
+			list_for_each_entry(intr_cb, &irq_info->cb_list[i],
+					    list)
+				if (intr_cb->thread_fn)
+					intr_cb->thread_fn(pdev->irq,
+							 intr_cb->data);
+		}
+	spin_unlock(&irq_info->mic_thread_lock);
+	return IRQ_HANDLED;
 }
-
 /**
  * mic_interrupt - Generic interrupt handler for
  * MSI and INTx based interrupts.
@@ -53,7 +54,11 @@ static inline void mic_invoke_callback(struct mic_device *mdev, int idx)
 static irqreturn_t mic_interrupt(int irq, void *dev)
 {
 	struct mic_device *mdev = dev;
-	struct mic_intr_info *info = mdev->intr_info;
+	struct mic_intr_info *intr_info = mdev->intr_info;
+	struct mic_irq_info *irq_info = &mdev->irq_info;
+	struct mic_intr_cb *intr_cb;
+	struct pci_dev *pdev = container_of(mdev->sdev->parent,
+					    struct pci_dev, dev);
 	u32 mask;
 	int i;
 
@@ -61,12 +66,19 @@ static irqreturn_t mic_interrupt(int irq, void *dev)
 	if (!mask)
 		return IRQ_NONE;
 
-	for (i = info->intr_start_idx[MIC_INTR_DB];
-			i < info->intr_len[MIC_INTR_DB]; i++)
-		if (mask & BIT(i))
-			mic_invoke_callback(mdev, i);
-
-	return IRQ_HANDLED;
+	spin_lock(&irq_info->mic_intr_lock);
+	for (i = intr_info->intr_start_idx[MIC_INTR_DB];
+			i < intr_info->intr_len[MIC_INTR_DB]; i++)
+		if (mask & BIT(i)) {
+			list_for_each_entry(intr_cb, &irq_info->cb_list[i],
+					    list)
+				if (intr_cb->handler)
+					intr_cb->handler(pdev->irq,
+							 intr_cb->data);
+			set_bit(i, &irq_info->mask);
+		}
+	spin_unlock(&irq_info->mic_intr_lock);
+	return IRQ_WAKE_THREAD;
 }
 
 /* Return the interrupt offset from the index. Index is 0 based. */
@@ -99,14 +111,15 @@ static struct msix_entry *mic_get_available_vector(struct mic_device *mdev)
  *
  * @mdev: pointer to the mic_device instance
  * @idx: The source id to be registered.
- * @func: The function to be called when the source id receives
+ * @handler: The function to be called when the source id receives
  * the interrupt.
+ * @thread_fn: thread fn. corresponding to the handler
  * @data: Private data of the requester.
  * Return the callback structure that was registered or an
  * appropriate error on failure.
  */
 static struct mic_intr_cb *mic_register_intr_callback(struct mic_device *mdev,
-			u8 idx, irqreturn_t (*func) (int irq, void *dev),
+			u8 idx, irq_handler_t handler, irq_handler_t thread_fn,
 			void *data)
 {
 	struct mic_intr_cb *intr_cb;
@@ -117,7 +130,8 @@ static struct mic_intr_cb *mic_register_intr_callback(struct mic_device *mdev,
 	if (!intr_cb)
 		return ERR_PTR(-ENOMEM);
 
-	intr_cb->func = func;
+	intr_cb->handler = handler;
+	intr_cb->thread_fn = thread_fn;
 	intr_cb->data = data;
 	intr_cb->cb_id = ida_simple_get(&mdev->irq_info.cb_ida,
 		0, 0, GFP_KERNEL);
@@ -126,9 +140,11 @@ static struct mic_intr_cb *mic_register_intr_callback(struct mic_device *mdev,
 		goto ida_fail;
 	}
 
+	spin_lock(&mdev->irq_info.mic_thread_lock);
 	spin_lock_irqsave(&mdev->irq_info.mic_intr_lock, flags);
 	list_add_tail(&intr_cb->list, &mdev->irq_info.cb_list[idx]);
 	spin_unlock_irqrestore(&mdev->irq_info.mic_intr_lock, flags);
+	spin_unlock(&mdev->irq_info.mic_thread_lock);
 
 	return intr_cb;
 ida_fail:
@@ -152,8 +168,9 @@ static u8 mic_unregister_intr_callback(struct mic_device *mdev, u32 idx)
 	unsigned long flags;
 	int i;
 
+	spin_lock(&mdev->irq_info.mic_thread_lock);
+	spin_lock_irqsave(&mdev->irq_info.mic_intr_lock, flags);
 	for (i = 0;  i < MIC_NUM_OFFSETS; i++) {
-		spin_lock_irqsave(&mdev->irq_info.mic_intr_lock, flags);
 		list_for_each_safe(pos, tmp, &mdev->irq_info.cb_list[i]) {
 			intr_cb = list_entry(pos, struct mic_intr_cb, list);
 			if (intr_cb->cb_id == idx) {
@@ -163,11 +180,13 @@ static u8 mic_unregister_intr_callback(struct mic_device *mdev, u32 idx)
 				kfree(intr_cb);
 				spin_unlock_irqrestore(
 					&mdev->irq_info.mic_intr_lock, flags);
+				spin_unlock(&mdev->irq_info.mic_thread_lock);
 				return i;
 			}
 		}
-		spin_unlock_irqrestore(&mdev->irq_info.mic_intr_lock, flags);
 	}
+	spin_unlock_irqrestore(&mdev->irq_info.mic_intr_lock, flags);
+	spin_unlock(&mdev->irq_info.mic_thread_lock);
 	return MIC_NUM_OFFSETS;
 }
 
@@ -242,6 +261,7 @@ static int mic_setup_callbacks(struct mic_device *mdev)
 		INIT_LIST_HEAD(&mdev->irq_info.cb_list[i]);
 	ida_init(&mdev->irq_info.cb_ida);
 	spin_lock_init(&mdev->irq_info.mic_intr_lock);
+	spin_lock_init(&mdev->irq_info.mic_thread_lock);
 	return 0;
 }
 
@@ -258,14 +278,12 @@ static void mic_release_callbacks(struct mic_device *mdev)
 	struct mic_intr_cb *intr_cb;
 	int i;
 
+	spin_lock(&mdev->irq_info.mic_thread_lock);
+	spin_lock_irqsave(&mdev->irq_info.mic_intr_lock, flags);
 	for (i = 0; i < MIC_NUM_OFFSETS; i++) {
-		spin_lock_irqsave(&mdev->irq_info.mic_intr_lock, flags);
 
-		if (list_empty(&mdev->irq_info.cb_list[i])) {
-			spin_unlock_irqrestore(&mdev->irq_info.mic_intr_lock,
-					       flags);
+		if (list_empty(&mdev->irq_info.cb_list[i]))
 			break;
-		}
 
 		list_for_each_safe(pos, tmp, &mdev->irq_info.cb_list[i]) {
 			intr_cb = list_entry(pos, struct mic_intr_cb, list);
@@ -274,8 +292,9 @@ static void mic_release_callbacks(struct mic_device *mdev)
 					  intr_cb->cb_id);
 			kfree(intr_cb);
 		}
-		spin_unlock_irqrestore(&mdev->irq_info.mic_intr_lock, flags);
 	}
+	spin_unlock_irqrestore(&mdev->irq_info.mic_intr_lock, flags);
+	spin_unlock(&mdev->irq_info.mic_thread_lock);
 	ida_destroy(&mdev->irq_info.cb_ida);
 	kfree(mdev->irq_info.cb_list);
 }
@@ -313,7 +332,8 @@ static int mic_setup_msi(struct mic_device *mdev, struct pci_dev *pdev)
 		goto err_nomem2;
 	}
 
-	rc = request_irq(pdev->irq, mic_interrupt, 0 , "mic-msi", mdev);
+	rc = request_threaded_irq(pdev->irq, mic_interrupt, mic_thread_fn,
+				  0, "mic-msi", mdev);
 	if (rc) {
 		dev_err(&pdev->dev, "Error allocating MSI interrupt\n");
 		goto err_irq_req_fail;
@@ -353,8 +373,8 @@ static int mic_setup_intx(struct mic_device *mdev, struct pci_dev *pdev)
 		goto err_nomem;
 	}
 
-	rc = request_irq(pdev->irq, mic_interrupt,
-		IRQF_SHARED, "mic-intx", mdev);
+	rc = request_threaded_irq(pdev->irq, mic_interrupt, mic_thread_fn,
+				  IRQF_SHARED, "mic-intx", mdev);
 	if (rc)
 		goto err;
 
@@ -391,13 +411,14 @@ int mic_next_db(struct mic_device *mdev)
 #define MK_COOKIE(x, y) ((x) | (y) << COOKIE_ID_SHIFT)
 
 /**
- * mic_request_irq - request an irq. mic_mutex needs
+ * mic_request_threaded_irq - request an irq. mic_mutex needs
  * to be held before calling this function.
  *
  * @mdev: pointer to mic_device instance
- * @func: The callback function that handles the interrupt.
+ * @handler: The callback function that handles the interrupt.
  * The function needs to call ack_interrupts
  * (mdev->ops->ack_interrupt(mdev)) when handling the interrupts.
+ * @thread_fn: thread fn required by request_threaded_irq.
  * @name: The ASCII name of the callee requesting the irq.
  * @data: private data that is returned back when calling the
  * function handler.
@@ -412,8 +433,8 @@ int mic_next_db(struct mic_device *mdev)
  * error code.
  *
  */
-struct mic_irq *mic_request_irq(struct mic_device *mdev,
-	irqreturn_t (*func)(int irq, void *dev),
+struct mic_irq *mic_request_threaded_irq(struct mic_device *mdev,
+	irq_handler_t handler, irq_handler_t thread_fn,
 	const char *name, void *data, int intr_src,
 	enum mic_intr_type type)
 {
@@ -444,7 +465,8 @@ struct mic_irq *mic_request_irq(struct mic_device *mdev,
 			goto err;
 		}
 
-		rc = request_irq(msix->vector, func, 0, name, data);
+		rc = request_threaded_irq(msix->vector, handler, thread_fn,
+					  0, name, data);
 		if (rc) {
 			dev_dbg(mdev->sdev->parent,
 				"request irq failed rc = %d\n", rc);
@@ -458,8 +480,8 @@ struct mic_irq *mic_request_irq(struct mic_device *mdev,
 		dev_dbg(mdev->sdev->parent, "irq: %d assigned for src: %d\n",
 			msix->vector, intr_src);
 	} else {
-		intr_cb = mic_register_intr_callback(mdev,
-				offset, func, data);
+		intr_cb = mic_register_intr_callback(mdev, offset, handler,
+						     thread_fn, data);
 		if (IS_ERR(intr_cb)) {
 			dev_err(mdev->sdev->parent,
 				"No available callback entries for use\n");
@@ -487,9 +509,9 @@ err:
  *  needs to be held before calling this function.
  *
  * @mdev: pointer to mic_device instance
- * @cookie: cookie obtained during a successful call to mic_request_irq
+ * @cookie: cookie obtained during a successful call to mic_request_threaded_irq
  * @data: private data specified by the calling function during the
- * mic_request_irq
+ * mic_request_threaded_irq
  *
  * returns: none.
  */
diff --git a/drivers/misc/mic/host/mic_intr.h b/drivers/misc/mic/host/mic_intr.h
index 6091aa9..6b03f84 100644
--- a/drivers/misc/mic/host/mic_intr.h
+++ b/drivers/misc/mic/host/mic_intr.h
@@ -21,6 +21,8 @@
 #ifndef _MIC_INTR_H_
 #define _MIC_INTR_H_
 
+#include <linux/bitops.h>
+#include <linux/interrupt.h>
 /*
  * The minimum number of msix vectors required for normal operation.
  * 3 for virtio network, console and block devices.
@@ -68,7 +70,11 @@ struct mic_intr_info {
  * @num_vectors: The number of MSI/MSI-x vectors that have been allocated.
  * @cb_ida: callback ID allocator to track the callbacks registered.
  * @mic_intr_lock: spinlock to protect the interrupt callback list.
+ * @mic_thread_lock: spinlock to protect the thread callback list.
+ *		   This lock is used to protect against thread_fn while
+ *		   mic_intr_lock is used to protect against interrupt handler.
  * @cb_list: Array of callback lists one for each source.
+ * @mask: Mask used by the main thread fn to call the underlying thread fns.
  */
 struct mic_irq_info {
 	int next_avail_src;
@@ -77,19 +83,23 @@ struct mic_irq_info {
 	u16 num_vectors;
 	struct ida cb_ida;
 	spinlock_t mic_intr_lock;
+	spinlock_t mic_thread_lock;
 	struct list_head *cb_list;
+	unsigned long mask;
 };
 
 /**
  * struct mic_intr_cb - Interrupt callback structure.
  *
- * @func: The callback function
+ * @handler: The callback function
+ * @thread_fn: The thread_fn.
  * @data: Private data of the requester.
  * @cb_id: The callback id. Identifies this callback.
  * @list: list head pointing to the next callback structure.
  */
 struct mic_intr_cb {
-	irqreturn_t (*func) (int irq, void *data);
+	irq_handler_t handler;
+	irq_handler_t thread_fn;
 	void *data;
 	int cb_id;
 	struct list_head list;
@@ -124,8 +134,8 @@ struct mic_hw_intr_ops {
 };
 
 int mic_next_db(struct mic_device *mdev);
-struct mic_irq *mic_request_irq(struct mic_device *mdev,
-	irqreturn_t (*func)(int irq, void *data),
+struct mic_irq *mic_request_threaded_irq(struct mic_device *mdev,
+	irq_handler_t handler, irq_handler_t thread_fn,
 	const char *name, void *data, int intr_src,
 	enum mic_intr_type type);
 
diff --git a/drivers/misc/mic/host/mic_main.c b/drivers/misc/mic/host/mic_main.c
index c04a021..fdc9c13 100644
--- a/drivers/misc/mic/host/mic_main.c
+++ b/drivers/misc/mic/host/mic_main.c
@@ -389,8 +389,9 @@ static int mic_probe(struct pci_dev *pdev,
 	mutex_lock(&mdev->mic_mutex);
 
 	mdev->shutdown_db = mic_next_db(mdev);
-	mdev->shutdown_cookie = mic_request_irq(mdev, mic_shutdown_db,
-		"shutdown-interrupt", mdev, mdev->shutdown_db, MIC_INTR_DB);
+	mdev->shutdown_cookie = mic_request_threaded_irq(mdev, mic_shutdown_db,
+					NULL, "shutdown-interrupt", mdev,
+					mdev->shutdown_db, MIC_INTR_DB);
 	if (IS_ERR(mdev->shutdown_cookie)) {
 		rc = PTR_ERR(mdev->shutdown_cookie);
 		mutex_unlock(&mdev->mic_mutex);
diff --git a/drivers/misc/mic/host/mic_virtio.c b/drivers/misc/mic/host/mic_virtio.c
index 7e1ef0e..aba3e83 100644
--- a/drivers/misc/mic/host/mic_virtio.c
+++ b/drivers/misc/mic/host/mic_virtio.c
@@ -594,8 +594,10 @@ int mic_virtio_add_device(struct mic_vdev *mvdev,
 	snprintf(irqname, sizeof(irqname), "mic%dvirtio%d", mdev->id,
 		 mvdev->virtio_id);
 	mvdev->virtio_db = mic_next_db(mdev);
-	mvdev->virtio_cookie = mic_request_irq(mdev, mic_virtio_intr_handler,
-			irqname, mvdev, mvdev->virtio_db, MIC_INTR_DB);
+	mvdev->virtio_cookie = mic_request_threaded_irq(mdev,
+					       mic_virtio_intr_handler,
+					       NULL, irqname, mvdev,
+					       mvdev->virtio_db, MIC_INTR_DB);
 	if (IS_ERR(mvdev->virtio_cookie)) {
 		ret = PTR_ERR(mvdev->virtio_cookie);
 		dev_dbg(mdev->sdev->parent, "request irq failed\n");
-- 
1.8.2.2


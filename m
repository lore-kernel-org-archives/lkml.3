Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238Ab3BFMH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 07:07:27 -0500
Received: from mga11.intel.com ([192.55.52.93]:63458 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296Ab3BFMHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 07:07:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,615,1355126400"; 
   d="scan'208";a="287310859"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 4/6] mei: move interrupt handlers to be me hw specific
Date: Wed,  6 Feb 2013 14:06:42 +0200
Message-Id: <1360152404-5769-5-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1360152404-5769-1-git-send-email-tomas.winkler@intel.com>
References: <1360152404-5769-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

interrupt handler are  platform specifics so we move
them to hw-mei.c. For sake of that we need to export
write, read, and complete handlers from the interrupt.c

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me.c     |  164 +++++++++++++++++++++++++++++++++++------
 drivers/misc/mei/hw-me.h     |    3 +
 drivers/misc/mei/interrupt.c |  126 ++------------------------------
 drivers/misc/mei/mei_dev.h   |    9 ++-
 drivers/misc/mei/pci-me.c    |   12 ++--
 5 files changed, 164 insertions(+), 150 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 6300943..3bebf8d 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -15,11 +15,16 @@
  */
 
 #include <linux/pci.h>
-#include <linux/mei.h>
+
+#include <linux/kthread.h>
+#include <linux/interrupt.h>
 
 #include "mei_dev.h"
 #include "hw-me.h"
 
+#include "hbm.h"
+
+
 /**
  * mei_reg_read - Reads 32bit data from the mei device
  *
@@ -218,29 +223,6 @@ static bool mei_me_hw_is_ready(struct mei_device *dev)
 }
 
 /**
- * mei_interrupt_quick_handler - The ISR of the MEI device
- *
- * @irq: The irq number
- * @dev_id: pointer to the device structure
- *
- * returns irqreturn_t
- */
-irqreturn_t mei_interrupt_quick_handler(int irq, void *dev_id)
-{
-	struct mei_device *dev = (struct mei_device *) dev_id;
-	struct mei_me_hw *hw = to_me_hw(dev);
-	u32 csr_reg = mei_hcsr_read(hw);
-
-	if ((csr_reg & H_IS) != H_IS)
-		return IRQ_NONE;
-
-	/* clear H_IS bit in H_CSR */
-	mei_reg_write(hw, H_CSR, csr_reg);
-
-	return IRQ_WAKE_THREAD;
-}
-
-/**
  * mei_hbuf_filled_slots - gets number of device filled buffer slots
  *
  * @dev: the device structure
@@ -403,6 +385,139 @@ static int mei_me_read_slots(struct mei_device *dev, unsigned char *buffer,
 	return 0;
 }
 
+/**
+ * mei_me_irq_quick_handler - The ISR of the MEI device
+ *
+ * @irq: The irq number
+ * @dev_id: pointer to the device structure
+ *
+ * returns irqreturn_t
+ */
+
+irqreturn_t mei_me_irq_quick_handler(int irq, void *dev_id)
+{
+	struct mei_device *dev = (struct mei_device *) dev_id;
+	struct mei_me_hw *hw = to_me_hw(dev);
+	u32 csr_reg = mei_hcsr_read(hw);
+
+	if ((csr_reg & H_IS) != H_IS)
+		return IRQ_NONE;
+
+	/* clear H_IS bit in H_CSR */
+	mei_reg_write(hw, H_CSR, csr_reg);
+
+	return IRQ_WAKE_THREAD;
+}
+
+/**
+ * mei_me_irq_thread_handler - function called after ISR to handle the interrupt
+ * processing.
+ *
+ * @irq: The irq number
+ * @dev_id: pointer to the device structure
+ *
+ * returns irqreturn_t
+ *
+ */
+irqreturn_t mei_me_irq_thread_handler(int irq, void *dev_id)
+{
+	struct mei_device *dev = (struct mei_device *) dev_id;
+	struct mei_cl_cb complete_list;
+	struct mei_cl_cb *cb_pos = NULL, *cb_next = NULL;
+	struct mei_cl *cl;
+	s32 slots;
+	int rets;
+	bool  bus_message_received;
+
+
+	dev_dbg(&dev->pdev->dev, "function called after ISR to handle the interrupt processing.\n");
+	/* initialize our complete list */
+	mutex_lock(&dev->device_lock);
+	mei_io_list_init(&complete_list);
+
+	/* Ack the interrupt here
+	 * In case of MSI we don't go through the quick handler */
+	if (pci_dev_msi_enabled(dev->pdev))
+		mei_clear_interrupts(dev);
+
+	/* check if ME wants a reset */
+	if (!mei_hw_is_ready(dev) &&
+	    dev->dev_state != MEI_DEV_RESETING &&
+	    dev->dev_state != MEI_DEV_INITIALIZING) {
+		dev_dbg(&dev->pdev->dev, "FW not ready.\n");
+		mei_reset(dev, 1);
+		mutex_unlock(&dev->device_lock);
+		return IRQ_HANDLED;
+	}
+
+	/*  check if we need to start the dev */
+	if (!mei_host_is_ready(dev)) {
+		if (mei_hw_is_ready(dev)) {
+			dev_dbg(&dev->pdev->dev, "we need to start the dev.\n");
+
+			mei_host_set_ready(dev);
+
+			dev_dbg(&dev->pdev->dev, "link is established start sending messages.\n");
+			/* link is established * start sending messages.  */
+
+			dev->dev_state = MEI_DEV_INIT_CLIENTS;
+
+			mei_hbm_start_req(dev);
+			mutex_unlock(&dev->device_lock);
+			return IRQ_HANDLED;
+		} else {
+			dev_dbg(&dev->pdev->dev, "FW not ready.\n");
+			mutex_unlock(&dev->device_lock);
+			return IRQ_HANDLED;
+		}
+	}
+	/* check slots available for reading */
+	slots = mei_count_full_read_slots(dev);
+	while (slots > 0) {
+		/* we have urgent data to send so break the read */
+		if (dev->wr_ext_msg.hdr.length)
+			break;
+		dev_dbg(&dev->pdev->dev, "slots =%08x\n", slots);
+		dev_dbg(&dev->pdev->dev, "call mei_irq_read_handler.\n");
+		rets = mei_irq_read_handler(dev, &complete_list, &slots);
+		if (rets)
+			goto end;
+	}
+	rets = mei_irq_write_handler(dev, &complete_list);
+end:
+	dev_dbg(&dev->pdev->dev, "end of bottom half function.\n");
+	dev->mei_host_buffer_is_empty = mei_hbuf_is_ready(dev);
+
+	bus_message_received = false;
+	if (dev->recvd_msg && waitqueue_active(&dev->wait_recvd_msg)) {
+		dev_dbg(&dev->pdev->dev, "received waiting bus message\n");
+		bus_message_received = true;
+	}
+	mutex_unlock(&dev->device_lock);
+	if (bus_message_received) {
+		dev_dbg(&dev->pdev->dev, "wake up dev->wait_recvd_msg\n");
+		wake_up_interruptible(&dev->wait_recvd_msg);
+		bus_message_received = false;
+	}
+	if (list_empty(&complete_list.list))
+		return IRQ_HANDLED;
+
+
+	list_for_each_entry_safe(cb_pos, cb_next, &complete_list.list, list) {
+		cl = cb_pos->cl;
+		list_del(&cb_pos->list);
+		if (cl) {
+			if (cl != &dev->iamthif_cl) {
+				dev_dbg(&dev->pdev->dev, "completing call back.\n");
+				mei_irq_complete_handler(cl, cb_pos);
+				cb_pos = NULL;
+			} else if (cl == &dev->iamthif_cl) {
+				mei_amthif_complete(dev, cb_pos);
+			}
+		}
+	}
+	return IRQ_HANDLED;
+}
 static const struct mei_hw_ops mei_me_hw_ops = {
 
 	.host_set_ready = mei_me_host_set_ready,
@@ -458,3 +573,4 @@ struct mei_device *mei_me_dev_init(struct pci_dev *pdev)
 	dev->pdev = pdev;
 	return dev;
 }
+
diff --git a/drivers/misc/mei/hw-me.h b/drivers/misc/mei/hw-me.h
index 9a3aaab..8518d3e 100644
--- a/drivers/misc/mei/hw-me.h
+++ b/drivers/misc/mei/hw-me.h
@@ -42,4 +42,7 @@ static inline unsigned char mei_data2slots(size_t length)
 	return DIV_ROUND_UP(sizeof(struct mei_msg_hdr) + length, 4);
 }
 
+irqreturn_t mei_me_irq_quick_handler(int irq, void *dev_id);
+irqreturn_t mei_me_irq_thread_handler(int irq, void *dev_id);
+
 #endif /* _MEI_INTERFACE_H_ */
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 431aa91..3535b26 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -30,12 +30,12 @@
 
 
 /**
- * _mei_cmpl - processes completed operation.
+ * mei_complete_handler - processes completed operation.
  *
  * @cl: private data of the file object.
  * @cb_pos: callback block.
  */
-static void _mei_cmpl(struct mei_cl *cl, struct mei_cl_cb *cb_pos)
+void mei_irq_complete_handler(struct mei_cl *cl, struct mei_cl_cb *cb_pos)
 {
 	if (cb_pos->fop_type == MEI_FOP_WRITE) {
 		mei_io_cb_free(cb_pos);
@@ -313,15 +313,14 @@ static int mei_irq_thread_write_complete(struct mei_device *dev, s32 *slots,
  * mei_irq_thread_read_handler - bottom half read routine after ISR to
  * handle the read processing.
  *
- * @cmpl_list: An instance of our list structure
  * @dev: the device structure
+ * @cmpl_list: An instance of our list structure
  * @slots: slots to read.
  *
  * returns 0 on success, <0 on failure.
  */
-static int mei_irq_thread_read_handler(struct mei_cl_cb *cmpl_list,
-		struct mei_device *dev,
-		s32 *slots)
+int mei_irq_read_handler(struct mei_device *dev,
+		struct mei_cl_cb *cmpl_list, s32 *slots)
 {
 	struct mei_msg_hdr *mei_hdr;
 	struct mei_cl *cl_pos = NULL;
@@ -412,15 +411,15 @@ end:
 
 
 /**
- * mei_irq_thread_write_handler - bottom half write routine after
- * ISR to handle the write processing.
+ * mei_irq_write_handler -  dispatch write requests
+ *  after irq received
  *
  * @dev: the device structure
  * @cmpl_list: An instance of our list structure
  *
  * returns 0 on success, <0 on failure.
  */
-static int mei_irq_thread_write_handler(struct mei_device *dev,
+int mei_irq_write_handler(struct mei_device *dev,
 				struct mei_cl_cb *cmpl_list)
 {
 
@@ -666,112 +665,3 @@ out:
 	mutex_unlock(&dev->device_lock);
 }
 
-/**
- *  mei_interrupt_thread_handler - function called after ISR to handle the interrupt
- * processing.
- *
- * @irq: The irq number
- * @dev_id: pointer to the device structure
- *
- * returns irqreturn_t
- *
- */
-irqreturn_t mei_interrupt_thread_handler(int irq, void *dev_id)
-{
-	struct mei_device *dev = (struct mei_device *) dev_id;
-	struct mei_cl_cb complete_list;
-	struct mei_cl_cb *cb_pos = NULL, *cb_next = NULL;
-	struct mei_cl *cl;
-	s32 slots;
-	int rets;
-	bool  bus_message_received;
-
-
-	dev_dbg(&dev->pdev->dev, "function called after ISR to handle the interrupt processing.\n");
-	/* initialize our complete list */
-	mutex_lock(&dev->device_lock);
-	mei_io_list_init(&complete_list);
-
-	/* Ack the interrupt here
-	 * In case of MSI we don't go through the quick handler */
-	if (pci_dev_msi_enabled(dev->pdev))
-		mei_clear_interrupts(dev);
-
-	/* check if ME wants a reset */
-	if (!mei_hw_is_ready(dev) &&
-	    dev->dev_state != MEI_DEV_RESETING &&
-	    dev->dev_state != MEI_DEV_INITIALIZING) {
-		dev_dbg(&dev->pdev->dev, "FW not ready.\n");
-		mei_reset(dev, 1);
-		mutex_unlock(&dev->device_lock);
-		return IRQ_HANDLED;
-	}
-
-	/*  check if we need to start the dev */
-	if (!mei_host_is_ready(dev)) {
-		if (mei_hw_is_ready(dev)) {
-			dev_dbg(&dev->pdev->dev, "we need to start the dev.\n");
-
-			mei_host_set_ready(dev);
-
-			dev_dbg(&dev->pdev->dev, "link is established start sending messages.\n");
-			/* link is established * start sending messages.  */
-
-			dev->dev_state = MEI_DEV_INIT_CLIENTS;
-
-			mei_hbm_start_req(dev);
-			mutex_unlock(&dev->device_lock);
-			return IRQ_HANDLED;
-		} else {
-			dev_dbg(&dev->pdev->dev, "FW not ready.\n");
-			mutex_unlock(&dev->device_lock);
-			return IRQ_HANDLED;
-		}
-	}
-	/* check slots available for reading */
-	slots = mei_count_full_read_slots(dev);
-	while (slots > 0) {
-		/* we have urgent data to send so break the read */
-		if (dev->wr_ext_msg.hdr.length)
-			break;
-		dev_dbg(&dev->pdev->dev, "slots =%08x\n", slots);
-		dev_dbg(&dev->pdev->dev, "call mei_irq_thread_read_handler.\n");
-		rets = mei_irq_thread_read_handler(&complete_list, dev, &slots);
-		if (rets)
-			goto end;
-	}
-	rets = mei_irq_thread_write_handler(dev, &complete_list);
-end:
-	dev_dbg(&dev->pdev->dev, "end of bottom half function.\n");
-	dev->mei_host_buffer_is_empty = mei_hbuf_is_ready(dev);
-
-	bus_message_received = false;
-	if (dev->recvd_msg && waitqueue_active(&dev->wait_recvd_msg)) {
-		dev_dbg(&dev->pdev->dev, "received waiting bus message\n");
-		bus_message_received = true;
-	}
-	mutex_unlock(&dev->device_lock);
-	if (bus_message_received) {
-		dev_dbg(&dev->pdev->dev, "wake up dev->wait_recvd_msg\n");
-		wake_up_interruptible(&dev->wait_recvd_msg);
-		bus_message_received = false;
-	}
-	if (list_empty(&complete_list.list))
-		return IRQ_HANDLED;
-
-
-	list_for_each_entry_safe(cb_pos, cb_next, &complete_list.list, list) {
-		cl = cb_pos->cl;
-		list_del(&cb_pos->list);
-		if (cl) {
-			if (cl != &dev->iamthif_cl) {
-				dev_dbg(&dev->pdev->dev, "completing call back.\n");
-				_mei_cmpl(cl, cb_pos);
-				cb_pos = NULL;
-			} else if (cl == &dev->iamthif_cl) {
-				mei_amthif_complete(dev, cb_pos);
-			}
-		}
-	}
-	return IRQ_HANDLED;
-}
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index c974292..7d07cef 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -379,9 +379,14 @@ int mei_hw_init(struct mei_device *dev);
 /*
  *  MEI interrupt functions prototype
  */
-irqreturn_t mei_interrupt_quick_handler(int irq, void *dev_id);
-irqreturn_t mei_interrupt_thread_handler(int irq, void *dev_id);
+
 void mei_timer(struct work_struct *work);
+int mei_irq_read_handler(struct mei_device *dev,
+		struct mei_cl_cb *cmpl_list, s32 *slots);
+
+int mei_irq_write_handler(struct mei_device *dev, struct mei_cl_cb *cmpl_list);
+
+void mei_irq_complete_handler(struct mei_cl *cl, struct mei_cl_cb *cb_pos);
 
 /*
  * AMTHIF - AMT Host Interface Functions
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 27ac717..b40ec06 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -170,12 +170,12 @@ static int mei_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (pci_dev_msi_enabled(pdev))
 		err = request_threaded_irq(pdev->irq,
 			NULL,
-			mei_interrupt_thread_handler,
+			mei_me_irq_thread_handler,
 			IRQF_ONESHOT, KBUILD_MODNAME, dev);
 	else
 		err = request_threaded_irq(pdev->irq,
-			mei_interrupt_quick_handler,
-			mei_interrupt_thread_handler,
+			mei_me_irq_quick_handler,
+			mei_me_irq_thread_handler,
 			IRQF_SHARED, KBUILD_MODNAME, dev);
 
 	if (err) {
@@ -348,12 +348,12 @@ static int mei_pci_resume(struct device *device)
 	if (pci_dev_msi_enabled(pdev))
 		err = request_threaded_irq(pdev->irq,
 			NULL,
-			mei_interrupt_thread_handler,
+			mei_me_irq_thread_handler,
 			IRQF_ONESHOT, KBUILD_MODNAME, dev);
 	else
 		err = request_threaded_irq(pdev->irq,
-			mei_interrupt_quick_handler,
-			mei_interrupt_thread_handler,
+			mei_me_irq_quick_handler,
+			mei_me_irq_thread_handler,
 			IRQF_SHARED, KBUILD_MODNAME, dev);
 
 	if (err) {
-- 
1.7.4.4


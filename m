Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab3COTYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:24:15 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:55608 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093Ab3COTYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:24:13 -0400
Date: Fri, 15 Mar 2013 14:24:04 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com,
        josh.h.morris@us.ibm.com, klebers@linux.vnet.ibm.com
Subject: [Patch 01/02v2] block: IBM FlashSystem 70/80 EEH Support.
Message-ID: <20130315192404.GF5833@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031519-5806-0000-0000-0000205BC7B2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

Adding in EEH support to the IBM FlashSystem 70/80 device driver.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------
Changes in v2 include:
o Fixed spelling of guarantee.
o Fixed potential memory leak if slot reset fails out.
o Changed list_for_each_entry_safe with list_for_each_entry.


diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/core.c linux-block/drivers/block/rsxx/core.c
--- linux-block-vanilla/drivers/block/rsxx/core.c	2013-03-15 11:47:48.505456256 -0500
+++ linux-block/drivers/block/rsxx/core.c	2013-03-15 11:56:47.131044799 -0500
@@ -30,6 +30,7 @@
 #include <linux/reboot.h>
 #include <linux/slab.h>
 #include <linux/bitops.h>
+#include <linux/delay.h>
 
 #include <linux/genhd.h>
 #include <linux/idr.h>
@@ -52,6 +53,13 @@ static DEFINE_IDA(rsxx_disk_ida);
 static DEFINE_SPINLOCK(rsxx_ida_lock);
 
 /*----------------- Interrupt Control & Handling -------------------*/
+
+static void rsxx_mask_interrupts(struct rsxx_cardinfo *card)
+{
+	card->isr_mask = 0;
+	card->ier_mask = 0;
+}
+
 static void __enable_intr(unsigned int *mask, unsigned int intr)
 {
 	*mask |= intr;
@@ -71,7 +79,8 @@ static void __disable_intr(unsigned int 
  */
 void rsxx_enable_ier(struct rsxx_cardinfo *card, unsigned int intr)
 {
-	if (unlikely(card->halt))
+	if (unlikely(card->halt) ||
+	    unlikely(card->eeh_state))
 		return;
 
 	__enable_intr(&card->ier_mask, intr);
@@ -80,6 +89,9 @@ void rsxx_enable_ier(struct rsxx_cardinf
 
 void rsxx_disable_ier(struct rsxx_cardinfo *card, unsigned int intr)
 {
+	if (unlikely(card->eeh_state))
+		return;
+
 	__disable_intr(&card->ier_mask, intr);
 	iowrite32(card->ier_mask, card->regmap + IER);
 }
@@ -87,7 +99,8 @@ void rsxx_disable_ier(struct rsxx_cardin
 void rsxx_enable_ier_and_isr(struct rsxx_cardinfo *card,
 				 unsigned int intr)
 {
-	if (unlikely(card->halt))
+	if (unlikely(card->halt) ||
+	    unlikely(card->eeh_state))
 		return;
 
 	__enable_intr(&card->isr_mask, intr);
@@ -97,6 +110,9 @@ void rsxx_enable_ier_and_isr(struct rsxx
 void rsxx_disable_ier_and_isr(struct rsxx_cardinfo *card,
 				  unsigned int intr)
 {
+	if (unlikely(card->eeh_state))
+		return;
+
 	__disable_intr(&card->isr_mask, intr);
 	__disable_intr(&card->ier_mask, intr);
 	iowrite32(card->ier_mask, card->regmap + IER);
@@ -115,6 +131,9 @@ static irqreturn_t rsxx_isr(int irq, voi
 	do {
 		reread_isr = 0;
 
+		if (unlikely(card->eeh_state))
+			break;
+
 		isr = ioread32(card->regmap + ISR);
 		if (isr == 0xffffffff) {
 			/*
@@ -304,6 +323,179 @@ static int card_shutdown(struct rsxx_car
 	return 0;
 }
 
+static void rsxx_eeh_frozen(struct pci_dev *dev)
+{
+	struct rsxx_cardinfo *card = pci_get_drvdata(dev);
+	int i;
+
+	dev_warn(&dev->dev, "IBM FlashSystem PCI: preparing for slot reset.\n");
+
+	card->eeh_state = 1;
+	rsxx_mask_interrupts(card);
+
+	/*
+	 * We need to guarantee that the write for eeh_state and masking
+	 * interrupts does not become reordered. This will prevent a possible
+	 * race condition with the EEH code.
+	 */
+	wmb();
+
+	pci_disable_device(dev);
+
+	rsxx_eeh_save_issued_dmas(card);
+
+	rsxx_eeh_save_issued_creg(card);
+
+	for (i = 0; i < card->n_targets; i++) {
+		if (card->ctrl[i].status.buf)
+			pci_free_consistent(card->dev, STATUS_BUFFER_SIZE8,
+					    card->ctrl[i].status.buf,
+					    card->ctrl[i].status.dma_addr);
+		if (card->ctrl[i].cmd.buf)
+			pci_free_consistent(card->dev, COMMAND_BUFFER_SIZE8,
+					    card->ctrl[i].cmd.buf,
+					    card->ctrl[i].cmd.dma_addr);
+	}
+}
+
+static void rsxx_eeh_failure(struct pci_dev *dev)
+{
+	struct rsxx_cardinfo *card = pci_get_drvdata(dev);
+	int i;
+
+	dev_err(&dev->dev, "IBM FlashSystem PCI: disabling failed card.\n");
+
+	card->eeh_state = 1;
+
+	for (i = 0; i < card->n_targets; i++)
+		del_timer_sync(&card->ctrl[i].activity_timer);
+
+	rsxx_eeh_cancel_dmas(card);
+}
+
+static int rsxx_eeh_fifo_flush_poll(struct rsxx_cardinfo *card)
+{
+	unsigned int status;
+	int iter = 0;
+
+	/* We need to wait for the hardware to reset */
+	while (iter++ < 10) {
+		status = ioread32(card->regmap + PCI_RECONFIG);
+
+		if (status & RSXX_FLUSH_BUSY) {
+			ssleep(1);
+			continue;
+		}
+
+		if (status & RSXX_FLUSH_TIMEOUT)
+			dev_warn(CARD_TO_DEV(card), "HW: flash controller timeout\n");
+		return 0;
+	}
+
+	/* Hardware failed resetting itself. */
+	return -1;
+}
+
+static pci_ers_result_t rsxx_error_detected(struct pci_dev *dev,
+					    enum pci_channel_state error)
+{
+	if (dev->revision < RSXX_EEH_SUPPORT)
+		return PCI_ERS_RESULT_NONE;
+
+	if (error == pci_channel_io_perm_failure) {
+		rsxx_eeh_failure(dev);
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	rsxx_eeh_frozen(dev);
+	return PCI_ERS_RESULT_NEED_RESET;
+}
+
+static pci_ers_result_t rsxx_slot_reset(struct pci_dev *dev)
+{
+	struct rsxx_cardinfo *card = pci_get_drvdata(dev);
+	unsigned long flags;
+	int i;
+	int st;
+
+	dev_warn(&dev->dev,
+		"IBM FlashSystem PCI: recovering from slot reset.\n");
+
+	st = pci_enable_device(dev);
+	if (st)
+		goto failed_hw_setup;
+
+	pci_set_master(dev);
+
+	st = rsxx_eeh_fifo_flush_poll(card);
+	if (st)
+		goto failed_hw_setup;
+
+	rsxx_dma_queue_reset(card);
+
+	for (i = 0; i < card->n_targets; i++) {
+		st = rsxx_hw_buffers_init(dev, &card->ctrl[i]);
+		if (st)
+			goto failed_hw_buffers_init;
+	}
+
+	if (card->config_valid)
+		rsxx_dma_configure(card);
+
+	/* Clears the ISR register from spurious interrupts */
+	st = ioread32(card->regmap + ISR);
+
+	card->eeh_state = 0;
+
+	st = rsxx_eeh_remap_dmas(card);
+	if (st)
+		goto failed_remap_dmas;
+
+	spin_lock_irqsave(&card->irq_lock, flags);
+	if (card->n_targets & RSXX_MAX_TARGETS)
+		rsxx_enable_ier_and_isr(card, CR_INTR_ALL_G);
+	else
+		rsxx_enable_ier_and_isr(card, CR_INTR_ALL_C);
+	spin_unlock_irqrestore(&card->irq_lock, flags);
+
+	rsxx_kick_creg_queue(card);
+
+	for (i = 0; i < card->n_targets; i++) {
+		spin_lock(&card->ctrl[i].queue_lock);
+		if (list_empty(&card->ctrl[i].queue)) {
+			spin_unlock(&card->ctrl[i].queue_lock);
+			continue;
+		}
+		spin_unlock(&card->ctrl[i].queue_lock);
+
+		queue_work(card->ctrl[i].issue_wq,
+				&card->ctrl[i].issue_dma_work);
+	}
+
+	dev_info(&dev->dev, "IBM FlashSystem PCI: recovery complete.\n");
+
+	return PCI_ERS_RESULT_RECOVERED;
+
+failed_hw_buffers_init:
+failed_remap_dmas:
+	for (i = 0; i < card->n_targets; i++) {
+		if (card->ctrl[i].status.buf)
+			pci_free_consistent(card->dev,
+					STATUS_BUFFER_SIZE8,
+					card->ctrl[i].status.buf,
+					card->ctrl[i].status.dma_addr);
+		if (card->ctrl[i].cmd.buf)
+			pci_free_consistent(card->dev,
+					COMMAND_BUFFER_SIZE8,
+					card->ctrl[i].cmd.buf,
+					card->ctrl[i].cmd.dma_addr);
+	}
+failed_hw_setup:
+	rsxx_eeh_failure(dev);
+	return PCI_ERS_RESULT_DISCONNECT;
+
+}
+
 /*----------------- Driver Initialization & Setup -------------------*/
 /* Returns:   0 if the driver is compatible with the device
 	     -1 if the driver is NOT compatible with the device */
@@ -383,6 +575,7 @@ static int rsxx_pci_probe(struct pci_dev
 
 	spin_lock_init(&card->irq_lock);
 	card->halt = 0;
+	card->eeh_state = 0;
 
 	spin_lock_irq(&card->irq_lock);
 	rsxx_disable_ier_and_isr(card, CR_INTR_ALL);
@@ -593,6 +786,11 @@ static void rsxx_pci_shutdown(struct pci
 	card_shutdown(card);
 }
 
+static const struct pci_error_handlers rsxx_err_handler = {
+	.error_detected = rsxx_error_detected,
+	.slot_reset     = rsxx_slot_reset,
+};
+
 static DEFINE_PCI_DEVICE_TABLE(rsxx_pci_ids) = {
 	{PCI_DEVICE(PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_FS70_FLASH)},
 	{PCI_DEVICE(PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_FS80_FLASH)},
@@ -608,6 +806,7 @@ static struct pci_driver rsxx_pci_driver
 	.remove		= rsxx_pci_remove,
 	.suspend	= rsxx_pci_suspend,
 	.shutdown	= rsxx_pci_shutdown,
+	.err_handler    = &rsxx_err_handler,
 };
 
 static int __init rsxx_core_init(void)
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/cregs.c linux-block/drivers/block/rsxx/cregs.c
--- linux-block-vanilla/drivers/block/rsxx/cregs.c	2013-03-15 11:47:45.071462800 -0500
+++ linux-block/drivers/block/rsxx/cregs.c	2013-03-15 11:48:16.941459124 -0500
@@ -58,7 +58,7 @@ static struct kmem_cache *creg_cmd_pool;
 #error Unknown endianess!!! Aborting...
 #endif
 
-static void copy_to_creg_data(struct rsxx_cardinfo *card,
+static int copy_to_creg_data(struct rsxx_cardinfo *card,
 			      int cnt8,
 			      void *buf,
 			      unsigned int stream)
@@ -66,6 +66,9 @@ static void copy_to_creg_data(struct rsx
 	int i = 0;
 	u32 *data = buf;
 
+	if (unlikely(card->eeh_state))
+		return -EIO;
+
 	for (i = 0; cnt8 > 0; i++, cnt8 -= 4) {
 		/*
 		 * Firmware implementation makes it necessary to byte swap on
@@ -76,10 +79,12 @@ static void copy_to_creg_data(struct rsx
 		else
 			iowrite32(data[i], card->regmap + CREG_DATA(i));
 	}
+
+	return 0;
 }
 
 
-static void copy_from_creg_data(struct rsxx_cardinfo *card,
+static int copy_from_creg_data(struct rsxx_cardinfo *card,
 				int cnt8,
 				void *buf,
 				unsigned int stream)
@@ -87,6 +92,9 @@ static void copy_from_creg_data(struct r
 	int i = 0;
 	u32 *data = buf;
 
+	if (unlikely(card->eeh_state))
+		return -EIO;
+
 	for (i = 0; cnt8 > 0; i++, cnt8 -= 4) {
 		/*
 		 * Firmware implementation makes it necessary to byte swap on
@@ -97,19 +105,32 @@ static void copy_from_creg_data(struct r
 		else
 			data[i] = ioread32(card->regmap + CREG_DATA(i));
 	}
+
+	return 0;
 }
 
 static void creg_issue_cmd(struct rsxx_cardinfo *card, struct creg_cmd *cmd)
 {
+	int st;
+
+	if (unlikely(card->eeh_state))
+		return;
+
 	iowrite32(cmd->addr, card->regmap + CREG_ADD);
 	iowrite32(cmd->cnt8, card->regmap + CREG_CNT);
 
 	if (cmd->op == CREG_OP_WRITE) {
-		if (cmd->buf)
-			copy_to_creg_data(card, cmd->cnt8,
-					  cmd->buf, cmd->stream);
+		if (cmd->buf) {
+			st = copy_to_creg_data(card, cmd->cnt8,
+					       cmd->buf, cmd->stream);
+			if (st)
+				return;
+		}
 	}
 
+	if (unlikely(card->eeh_state))
+		return;
+
 	/* Setting the valid bit will kick off the command. */
 	iowrite32(cmd->op, card->regmap + CREG_CMD);
 }
@@ -272,7 +293,7 @@ static void creg_cmd_done(struct work_st
 			goto creg_done;
 		}
 
-		copy_from_creg_data(card, cnt8, cmd->buf, cmd->stream);
+		st = copy_from_creg_data(card, cnt8, cmd->buf, cmd->stream);
 	}
 
 creg_done:
@@ -675,6 +696,32 @@ int rsxx_reg_access(struct rsxx_cardinfo
 	return 0;
 }
 
+void rsxx_eeh_save_issued_creg(struct rsxx_cardinfo *card)
+{
+	struct creg_cmd *cmd = NULL;
+
+	cmd = card->creg_ctrl.active_cmd;
+	card->creg_ctrl.active_cmd = NULL;
+
+	if (cmd) {
+		del_timer_sync(&card->creg_ctrl.cmd_timer);
+
+		spin_lock_bh(&card->creg_ctrl.lock);
+		list_add(&cmd->list, &card->creg_ctrl.queue);
+		card->creg_ctrl.q_depth++;
+		card->creg_ctrl.active = 0;
+		spin_unlock_bh(&card->creg_ctrl.lock);
+	}
+}
+
+void rsxx_kick_creg_queue(struct rsxx_cardinfo *card)
+{
+	spin_lock_bh(&card->creg_ctrl.lock);
+	if (!list_empty(&card->creg_ctrl.queue))
+		creg_kick_queue(card);
+	spin_unlock_bh(&card->creg_ctrl.lock);
+}
+
 /*------------ Initialization & Setup --------------*/
 int rsxx_creg_setup(struct rsxx_cardinfo *card)
 {
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/dma.c linux-block/drivers/block/rsxx/dma.c
--- linux-block-vanilla/drivers/block/rsxx/dma.c	2013-03-15 11:47:46.835458307 -0500
+++ linux-block/drivers/block/rsxx/dma.c	2013-03-15 11:57:40.071456795 -0500
@@ -81,9 +81,6 @@ enum rsxx_hw_status {
 	HW_STATUS_FAULT		= 0x08,
 };
 
-#define STATUS_BUFFER_SIZE8     4096
-#define COMMAND_BUFFER_SIZE8    4096
-
 static struct kmem_cache *rsxx_dma_pool;
 
 struct dma_tracker {
@@ -122,7 +119,7 @@ static unsigned int rsxx_get_dma_tgt(str
 	return tgt;
 }
 
-static void rsxx_dma_queue_reset(struct rsxx_cardinfo *card)
+void rsxx_dma_queue_reset(struct rsxx_cardinfo *card)
 {
 	/* Reset all DMA Command/Status Queues */
 	iowrite32(DMA_QUEUE_RESET, card->regmap + RESET);
@@ -210,7 +207,8 @@ static void dma_intr_coal_auto_tune(stru
 	u32 q_depth = 0;
 	u32 intr_coal;
 
-	if (card->config.data.intr_coal.mode != RSXX_INTR_COAL_AUTO_TUNE)
+	if (card->config.data.intr_coal.mode != RSXX_INTR_COAL_AUTO_TUNE ||
+	    unlikely(card->eeh_state))
 		return;
 
 	for (i = 0; i < card->n_targets; i++)
@@ -223,31 +221,26 @@ static void dma_intr_coal_auto_tune(stru
 }
 
 /*----------------- RSXX DMA Handling -------------------*/
-static void rsxx_complete_dma(struct rsxx_cardinfo *card,
+static void rsxx_complete_dma(struct rsxx_dma_ctrl *ctrl,
 				  struct rsxx_dma *dma,
 				  unsigned int status)
 {
 	if (status & DMA_SW_ERR)
-		printk_ratelimited(KERN_ERR
-				   "SW Error in DMA(cmd x%02x, laddr x%08x)\n",
-				   dma->cmd, dma->laddr);
+		ctrl->stats.dma_sw_err++;
 	if (status & DMA_HW_FAULT)
-		printk_ratelimited(KERN_ERR
-				   "HW Fault in DMA(cmd x%02x, laddr x%08x)\n",
-				   dma->cmd, dma->laddr);
+		ctrl->stats.dma_hw_fault++;
 	if (status & DMA_CANCELLED)
-		printk_ratelimited(KERN_ERR
-				   "DMA Cancelled(cmd x%02x, laddr x%08x)\n",
-				   dma->cmd, dma->laddr);
+		ctrl->stats.dma_cancelled++;
 
 	if (dma->dma_addr)
-		pci_unmap_page(card->dev, dma->dma_addr, get_dma_size(dma),
+		pci_unmap_page(ctrl->card->dev, dma->dma_addr,
+			       get_dma_size(dma),
 			       dma->cmd == HW_CMD_BLK_WRITE ?
 					   PCI_DMA_TODEVICE :
 					   PCI_DMA_FROMDEVICE);
 
 	if (dma->cb)
-		dma->cb(card, dma->cb_data, status ? 1 : 0);
+		dma->cb(ctrl->card, dma->cb_data, status ? 1 : 0);
 
 	kmem_cache_free(rsxx_dma_pool, dma);
 }
@@ -330,14 +323,15 @@ static void rsxx_handle_dma_error(struct
 	if (requeue_cmd)
 		rsxx_requeue_dma(ctrl, dma);
 	else
-		rsxx_complete_dma(ctrl->card, dma, status);
+		rsxx_complete_dma(ctrl, dma, status);
 }
 
 static void dma_engine_stalled(unsigned long data)
 {
 	struct rsxx_dma_ctrl *ctrl = (struct rsxx_dma_ctrl *)data;
 
-	if (atomic_read(&ctrl->stats.hw_q_depth) == 0)
+	if (atomic_read(&ctrl->stats.hw_q_depth) == 0 ||
+	    unlikely(ctrl->card->eeh_state))
 		return;
 
 	if (ctrl->cmd.idx != ioread32(ctrl->regmap + SW_CMD_IDX)) {
@@ -369,7 +363,8 @@ static void rsxx_issue_dmas(struct work_
 	ctrl = container_of(work, struct rsxx_dma_ctrl, issue_dma_work);
 	hw_cmd_buf = ctrl->cmd.buf;
 
-	if (unlikely(ctrl->card->halt))
+	if (unlikely(ctrl->card->halt) ||
+	    unlikely(ctrl->card->eeh_state))
 		return;
 
 	while (1) {
@@ -397,7 +392,7 @@ static void rsxx_issue_dmas(struct work_
 		 */
 		if (unlikely(ctrl->card->dma_fault)) {
 			push_tracker(ctrl->trackers, tag);
-			rsxx_complete_dma(ctrl->card, dma, DMA_CANCELLED);
+			rsxx_complete_dma(ctrl, dma, DMA_CANCELLED);
 			continue;
 		}
 
@@ -435,6 +430,12 @@ static void rsxx_issue_dmas(struct work_
 		atomic_add(cmds_pending, &ctrl->stats.hw_q_depth);
 		mod_timer(&ctrl->activity_timer,
 			  jiffies + DMA_ACTIVITY_TIMEOUT);
+
+		if (unlikely(ctrl->card->eeh_state)) {
+			del_timer_sync(&ctrl->activity_timer);
+			return;
+		}
+
 		iowrite32(ctrl->cmd.idx, ctrl->regmap + SW_CMD_IDX);
 	}
 }
@@ -453,7 +454,8 @@ static void rsxx_dma_done(struct work_st
 	hw_st_buf = ctrl->status.buf;
 
 	if (unlikely(ctrl->card->halt) ||
-	    unlikely(ctrl->card->dma_fault))
+	    unlikely(ctrl->card->dma_fault) ||
+	    unlikely(ctrl->card->eeh_state))
 		return;
 
 	count = le16_to_cpu(hw_st_buf[ctrl->status.idx].count);
@@ -498,7 +500,7 @@ static void rsxx_dma_done(struct work_st
 		if (status)
 			rsxx_handle_dma_error(ctrl, dma, status);
 		else
-			rsxx_complete_dma(ctrl->card, dma, 0);
+			rsxx_complete_dma(ctrl, dma, 0);
 
 		push_tracker(ctrl->trackers, tag);
 
@@ -717,20 +719,54 @@ bvec_err:
 
 
 /*----------------- DMA Engine Initialization & Setup -------------------*/
+int rsxx_hw_buffers_init(struct pci_dev *dev, struct rsxx_dma_ctrl *ctrl)
+{
+	ctrl->status.buf = pci_alloc_consistent(dev, STATUS_BUFFER_SIZE8,
+				&ctrl->status.dma_addr);
+	ctrl->cmd.buf = pci_alloc_consistent(dev, COMMAND_BUFFER_SIZE8,
+				&ctrl->cmd.dma_addr);
+	if (ctrl->status.buf == NULL || ctrl->cmd.buf == NULL)
+		return -ENOMEM;
+
+	memset(ctrl->status.buf, 0xac, STATUS_BUFFER_SIZE8);
+	iowrite32(lower_32_bits(ctrl->status.dma_addr),
+		ctrl->regmap + SB_ADD_LO);
+	iowrite32(upper_32_bits(ctrl->status.dma_addr),
+		ctrl->regmap + SB_ADD_HI);
+
+	memset(ctrl->cmd.buf, 0x83, COMMAND_BUFFER_SIZE8);
+	iowrite32(lower_32_bits(ctrl->cmd.dma_addr), ctrl->regmap + CB_ADD_LO);
+	iowrite32(upper_32_bits(ctrl->cmd.dma_addr), ctrl->regmap + CB_ADD_HI);
+
+	ctrl->status.idx = ioread32(ctrl->regmap + HW_STATUS_CNT);
+	if (ctrl->status.idx > RSXX_MAX_OUTSTANDING_CMDS) {
+		dev_crit(&dev->dev, "Failed reading status cnt x%x\n",
+			ctrl->status.idx);
+		return -EINVAL;
+	}
+	iowrite32(ctrl->status.idx, ctrl->regmap + HW_STATUS_CNT);
+	iowrite32(ctrl->status.idx, ctrl->regmap + SW_STATUS_CNT);
+
+	ctrl->cmd.idx = ioread32(ctrl->regmap + HW_CMD_IDX);
+	if (ctrl->cmd.idx > RSXX_MAX_OUTSTANDING_CMDS) {
+		dev_crit(&dev->dev, "Failed reading cmd cnt x%x\n",
+			ctrl->status.idx);
+		return -EINVAL;
+	}
+	iowrite32(ctrl->cmd.idx, ctrl->regmap + HW_CMD_IDX);
+	iowrite32(ctrl->cmd.idx, ctrl->regmap + SW_CMD_IDX);
+
+	return 0;
+}
+
 static int rsxx_dma_ctrl_init(struct pci_dev *dev,
 				  struct rsxx_dma_ctrl *ctrl)
 {
 	int i;
+	int st;
 
 	memset(&ctrl->stats, 0, sizeof(ctrl->stats));
 
-	ctrl->status.buf = pci_alloc_consistent(dev, STATUS_BUFFER_SIZE8,
-						&ctrl->status.dma_addr);
-	ctrl->cmd.buf = pci_alloc_consistent(dev, COMMAND_BUFFER_SIZE8,
-					     &ctrl->cmd.dma_addr);
-	if (ctrl->status.buf == NULL || ctrl->cmd.buf == NULL)
-		return -ENOMEM;
-
 	ctrl->trackers = vmalloc(DMA_TRACKER_LIST_SIZE8);
 	if (!ctrl->trackers)
 		return -ENOMEM;
@@ -760,33 +796,9 @@ static int rsxx_dma_ctrl_init(struct pci
 	INIT_WORK(&ctrl->issue_dma_work, rsxx_issue_dmas);
 	INIT_WORK(&ctrl->dma_done_work, rsxx_dma_done);
 
-	memset(ctrl->status.buf, 0xac, STATUS_BUFFER_SIZE8);
-	iowrite32(lower_32_bits(ctrl->status.dma_addr),
-		  ctrl->regmap + SB_ADD_LO);
-	iowrite32(upper_32_bits(ctrl->status.dma_addr),
-		  ctrl->regmap + SB_ADD_HI);
-
-	memset(ctrl->cmd.buf, 0x83, COMMAND_BUFFER_SIZE8);
-	iowrite32(lower_32_bits(ctrl->cmd.dma_addr), ctrl->regmap + CB_ADD_LO);
-	iowrite32(upper_32_bits(ctrl->cmd.dma_addr), ctrl->regmap + CB_ADD_HI);
-
-	ctrl->status.idx = ioread32(ctrl->regmap + HW_STATUS_CNT);
-	if (ctrl->status.idx > RSXX_MAX_OUTSTANDING_CMDS) {
-		dev_crit(&dev->dev, "Failed reading status cnt x%x\n",
-			 ctrl->status.idx);
-		return -EINVAL;
-	}
-	iowrite32(ctrl->status.idx, ctrl->regmap + HW_STATUS_CNT);
-	iowrite32(ctrl->status.idx, ctrl->regmap + SW_STATUS_CNT);
-
-	ctrl->cmd.idx = ioread32(ctrl->regmap + HW_CMD_IDX);
-	if (ctrl->cmd.idx > RSXX_MAX_OUTSTANDING_CMDS) {
-		dev_crit(&dev->dev, "Failed reading cmd cnt x%x\n",
-			 ctrl->status.idx);
-		return -EINVAL;
-	}
-	iowrite32(ctrl->cmd.idx, ctrl->regmap + HW_CMD_IDX);
-	iowrite32(ctrl->cmd.idx, ctrl->regmap + SW_CMD_IDX);
+	st = rsxx_hw_buffers_init(dev, ctrl);
+	if (st)
+		return st;
 
 	return 0;
 }
@@ -822,7 +834,7 @@ static int rsxx_dma_stripe_setup(struct 
 	return 0;
 }
 
-static int rsxx_dma_configure(struct rsxx_cardinfo *card)
+int rsxx_dma_configure(struct rsxx_cardinfo *card)
 {
 	u32 intr_coal;
 
@@ -968,6 +980,94 @@ void rsxx_dma_destroy(struct rsxx_cardin
 	}
 }
 
+void rsxx_eeh_save_issued_dmas(struct rsxx_cardinfo *card)
+{
+	int i;
+	int j;
+	int cnt;
+	struct rsxx_dma *dma;
+	struct list_head issued_dmas[card->n_targets];
+
+	for (i = 0; i < card->n_targets; i++) {
+		INIT_LIST_HEAD(&issued_dmas[i]);
+		cnt = 0;
+		for (j = 0; j < RSXX_MAX_OUTSTANDING_CMDS; j++) {
+			dma = get_tracker_dma(card->ctrl[i].trackers, j);
+			if (dma == NULL)
+				continue;
+
+			if (dma->cmd == HW_CMD_BLK_WRITE)
+				card->ctrl[i].stats.writes_issued--;
+			else if (dma->cmd == HW_CMD_BLK_DISCARD)
+				card->ctrl[i].stats.discards_issued--;
+			else
+				card->ctrl[i].stats.reads_issued--;
+
+			list_add_tail(&dma->list, &issued_dmas[i]);
+			push_tracker(card->ctrl[i].trackers, j);
+			cnt++;
+		}
+
+		spin_lock(&card->ctrl[i].queue_lock);
+		list_splice(&issued_dmas[i], &card->ctrl[i].queue);
+
+		atomic_sub(cnt, &card->ctrl[i].stats.hw_q_depth);
+		card->ctrl[i].stats.sw_q_depth += cnt;
+		card->ctrl[i].e_cnt = 0;
+
+		list_for_each_entry(dma, &card->ctrl[i].queue, list) {
+			if (dma->dma_addr)
+				pci_unmap_page(card->dev, dma->dma_addr,
+					       get_dma_size(dma),
+					       dma->cmd == HW_CMD_BLK_WRITE ?
+					       PCI_DMA_TODEVICE :
+					       PCI_DMA_FROMDEVICE);
+		}
+		spin_unlock(&card->ctrl[i].queue_lock);
+	}
+}
+
+void rsxx_eeh_cancel_dmas(struct rsxx_cardinfo *card)
+{
+	struct rsxx_dma *dma;
+	struct rsxx_dma *tmp;
+	int i;
+
+	for (i = 0; i < card->n_targets; i++) {
+		spin_lock(&card->ctrl[i].queue_lock);
+		list_for_each_entry_safe(dma, tmp, &card->ctrl[i].queue, list) {
+			list_del(&dma->list);
+
+			rsxx_complete_dma(&card->ctrl[i], dma, DMA_CANCELLED);
+		}
+		spin_unlock(&card->ctrl[i].queue_lock);
+	}
+}
+
+int rsxx_eeh_remap_dmas(struct rsxx_cardinfo *card)
+{
+	struct rsxx_dma *dma;
+	struct rsxx_dma *tmp;
+	int i;
+
+	for (i = 0; i < card->n_targets; i++) {
+		spin_lock(&card->ctrl[i].queue_lock);
+		list_for_each_entry(dma, &card->ctrl[i].queue, list) {
+			dma->dma_addr = pci_map_page(card->dev, dma->page,
+					dma->pg_off, get_dma_size(dma),
+					dma->cmd == HW_CMD_BLK_WRITE ?
+					PCI_DMA_TODEVICE :
+					PCI_DMA_FROMDEVICE);
+			if (!dma->dma_addr) {
+				kmem_cache_free(rsxx_dma_pool, dma);
+				return -ENOMEM;
+			}
+		}
+		spin_unlock(&card->ctrl[i].queue_lock);
+	}
+
+	return 0;
+}
 
 int rsxx_dma_init(void)
 {
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/rsxx_priv.h linux-block/drivers/block/rsxx/rsxx_priv.h
--- linux-block-vanilla/drivers/block/rsxx/rsxx_priv.h	2013-03-15 11:47:46.847457300 -0500
+++ linux-block/drivers/block/rsxx/rsxx_priv.h	2013-03-15 11:48:16.955455968 -0500
@@ -64,6 +64,9 @@ struct proc_cmd;
 #define RSXX_MAX_OUTSTANDING_CMDS	255
 #define RSXX_CS_IDX_MASK		0xff
 
+#define STATUS_BUFFER_SIZE8     4096
+#define COMMAND_BUFFER_SIZE8    4096
+
 #define RSXX_MAX_TARGETS	8
 
 struct dma_tracker_list;
@@ -88,6 +91,9 @@ struct rsxx_dma_stats {
 	u32 discards_failed;
 	u32 done_rescheduled;
 	u32 issue_rescheduled;
+	u32 dma_sw_err;
+	u32 dma_hw_fault;
+	u32 dma_cancelled;
 	u32 sw_q_depth;		/* Number of DMAs on the SW queue. */
 	atomic_t hw_q_depth;	/* Number of DMAs queued to HW. */
 };
@@ -113,6 +119,7 @@ struct rsxx_dma_ctrl {
 struct rsxx_cardinfo {
 	struct pci_dev		*dev;
 	unsigned int		halt;
+	unsigned int		eeh_state;
 
 	void			__iomem *regmap;
 	spinlock_t		irq_lock;
@@ -221,6 +228,7 @@ enum rsxx_pci_regmap {
 	PERF_RD512_HI	= 0xac,
 	PERF_WR512_LO	= 0xb0,
 	PERF_WR512_HI	= 0xb4,
+	PCI_RECONFIG	= 0xb8,
 };
 
 enum rsxx_intr {
@@ -234,6 +242,8 @@ enum rsxx_intr {
 	CR_INTR_DMA5	= 0x00000080,
 	CR_INTR_DMA6	= 0x00000100,
 	CR_INTR_DMA7	= 0x00000200,
+	CR_INTR_ALL_C	= 0x0000003f,
+	CR_INTR_ALL_G	= 0x000003ff,
 	CR_INTR_DMA_ALL = 0x000003f5,
 	CR_INTR_ALL	= 0xffffffff,
 };
@@ -250,8 +260,14 @@ enum rsxx_pci_reset {
 	DMA_QUEUE_RESET		= 0x00000001,
 };
 
+enum rsxx_hw_fifo_flush {
+	RSXX_FLUSH_BUSY		= 0x00000002,
+	RSXX_FLUSH_TIMEOUT	= 0x00000004,
+};
+
 enum rsxx_pci_revision {
 	RSXX_DISCARD_SUPPORT = 2,
+	RSXX_EEH_SUPPORT     = 3,
 };
 
 enum rsxx_creg_cmd {
@@ -357,11 +373,17 @@ int rsxx_dma_setup(struct rsxx_cardinfo 
 void rsxx_dma_destroy(struct rsxx_cardinfo *card);
 int rsxx_dma_init(void);
 void rsxx_dma_cleanup(void);
+void rsxx_dma_queue_reset(struct rsxx_cardinfo *card);
+int rsxx_dma_configure(struct rsxx_cardinfo *card);
 int rsxx_dma_queue_bio(struct rsxx_cardinfo *card,
 			   struct bio *bio,
 			   atomic_t *n_dmas,
 			   rsxx_dma_cb cb,
 			   void *cb_data);
+int rsxx_hw_buffers_init(struct pci_dev *dev, struct rsxx_dma_ctrl *ctrl);
+void rsxx_eeh_save_issued_dmas(struct rsxx_cardinfo *card);
+void rsxx_eeh_cancel_dmas(struct rsxx_cardinfo *card);
+int rsxx_eeh_remap_dmas(struct rsxx_cardinfo *card);
 
 /***** cregs.c *****/
 int rsxx_creg_write(struct rsxx_cardinfo *card, u32 addr,
@@ -386,10 +408,11 @@ int rsxx_creg_setup(struct rsxx_cardinfo
 void rsxx_creg_destroy(struct rsxx_cardinfo *card);
 int rsxx_creg_init(void);
 void rsxx_creg_cleanup(void);
-
 int rsxx_reg_access(struct rsxx_cardinfo *card,
 			struct rsxx_reg_access __user *ucmd,
 			int read);
+void rsxx_eeh_save_issued_creg(struct rsxx_cardinfo *card);
+void rsxx_kick_creg_queue(struct rsxx_cardinfo *card);
 
 
 


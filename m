Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab3BFMIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 07:08:25 -0500
Received: from mga11.intel.com ([192.55.52.93]:63458 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab3BFMHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 07:07:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,615,1355126400"; 
   d="scan'208";a="287310822"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/6] mei: initial extract of ME hw specifics from mei_device
Date: Wed,  6 Feb 2013 14:06:40 +0200
Message-Id: <1360152404-5769-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1360152404-5769-1-git-send-email-tomas.winkler@intel.com>
References: <1360152404-5769-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is initial step of move the ME hw specifics
out of mei_device structure into mei_me_hw

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me.c   |  131 +++++++++++++++++++++++++++++---------------
 drivers/misc/mei/hw-me.h   |   12 ++++
 drivers/misc/mei/init.c    |   28 +---------
 drivers/misc/mei/mei_dev.h |   10 +--
 drivers/misc/mei/pci-me.c  |   21 ++++---
 5 files changed, 114 insertions(+), 88 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 94b203e..3bdf228 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -28,10 +28,10 @@
  *
  * returns register value (u32)
  */
-static inline u32 mei_reg_read(const struct mei_device *dev,
+static inline u32 mei_reg_read(const struct mei_me_hw *hw,
 			       unsigned long offset)
 {
-	return ioread32(dev->mem_addr + offset);
+	return ioread32(hw->mem_addr + offset);
 }
 
 
@@ -42,10 +42,10 @@ static inline u32 mei_reg_read(const struct mei_device *dev,
  * @offset: offset from which to write the data
  * @value: register value to write (u32)
  */
-static inline void mei_reg_write(const struct mei_device *dev,
+static inline void mei_reg_write(const struct mei_me_hw *hw,
 				 unsigned long offset, u32 value)
 {
-	iowrite32(value, dev->mem_addr + offset);
+	iowrite32(value, hw->mem_addr + offset);
 }
 
 /**
@@ -58,7 +58,7 @@ static inline void mei_reg_write(const struct mei_device *dev,
  */
 u32 mei_mecbrw_read(const struct mei_device *dev)
 {
-	return mei_reg_read(dev, ME_CB_RW);
+	return mei_reg_read(to_me_hw(dev), ME_CB_RW);
 }
 /**
  * mei_mecsr_read - Reads 32bit data from the ME CSR
@@ -67,9 +67,9 @@ u32 mei_mecbrw_read(const struct mei_device *dev)
  *
  * returns ME_CSR_HA register value (u32)
  */
-static inline u32 mei_mecsr_read(const struct mei_device *dev)
+static inline u32 mei_mecsr_read(const struct mei_me_hw *hw)
 {
-	return mei_reg_read(dev, ME_CSR_HA);
+	return mei_reg_read(hw, ME_CSR_HA);
 }
 
 /**
@@ -79,9 +79,9 @@ static inline u32 mei_mecsr_read(const struct mei_device *dev)
  *
  * returns H_CSR register value (u32)
  */
-static inline u32 mei_hcsr_read(const struct mei_device *dev)
+static inline u32 mei_hcsr_read(const struct mei_me_hw *hw)
 {
-	return mei_reg_read(dev, H_CSR);
+	return mei_reg_read(hw, H_CSR);
 }
 
 /**
@@ -90,10 +90,10 @@ static inline u32 mei_hcsr_read(const struct mei_device *dev)
  *
  * @dev: the device structure
  */
-static inline void mei_hcsr_set(struct mei_device *dev, u32 hcsr)
+static inline void mei_hcsr_set(struct mei_me_hw *hw, u32 hcsr)
 {
 	hcsr &= ~H_IS;
-	mei_reg_write(dev, H_CSR, hcsr);
+	mei_reg_write(hw, H_CSR, hcsr);
 }
 
 
@@ -104,7 +104,7 @@ static inline void mei_hcsr_set(struct mei_device *dev, u32 hcsr)
  */
 void mei_hw_config(struct mei_device *dev)
 {
-	u32 hcsr = mei_hcsr_read(dev);
+	u32 hcsr = mei_hcsr_read(to_me_hw(dev));
 	/* Doesn't change in runtime */
 	dev->hbuf_depth = (hcsr & H_CBD) >> 24;
 }
@@ -115,9 +115,10 @@ void mei_hw_config(struct mei_device *dev)
  */
 void mei_clear_interrupts(struct mei_device *dev)
 {
-	u32 hcsr = mei_hcsr_read(dev);
+	struct mei_me_hw *hw = to_me_hw(dev);
+	u32 hcsr = mei_hcsr_read(hw);
 	if ((hcsr & H_IS) == H_IS)
-		mei_reg_write(dev, H_CSR, hcsr);
+		mei_reg_write(hw, H_CSR, hcsr);
 }
 
 /**
@@ -127,9 +128,10 @@ void mei_clear_interrupts(struct mei_device *dev)
  */
 void mei_enable_interrupts(struct mei_device *dev)
 {
-	u32 hcsr = mei_hcsr_read(dev);
+	struct mei_me_hw *hw = to_me_hw(dev);
+	u32 hcsr = mei_hcsr_read(hw);
 	hcsr |= H_IE;
-	mei_hcsr_set(dev, hcsr);
+	mei_hcsr_set(hw, hcsr);
 }
 
 /**
@@ -139,9 +141,10 @@ void mei_enable_interrupts(struct mei_device *dev)
  */
 void mei_disable_interrupts(struct mei_device *dev)
 {
-	u32 hcsr = mei_hcsr_read(dev);
+	struct mei_me_hw *hw = to_me_hw(dev);
+	u32 hcsr = mei_hcsr_read(hw);
 	hcsr  &= ~H_IE;
-	mei_hcsr_set(dev, hcsr);
+	mei_hcsr_set(hw, hcsr);
 }
 
 /**
@@ -152,7 +155,8 @@ void mei_disable_interrupts(struct mei_device *dev)
  */
 void mei_hw_reset(struct mei_device *dev, bool intr_enable)
 {
-	u32 hcsr = mei_hcsr_read(dev);
+	struct mei_me_hw *hw = to_me_hw(dev);
+	u32 hcsr = mei_hcsr_read(hw);
 
 	dev_dbg(&dev->pdev->dev, "before reset HCSR = 0x%08x.\n", hcsr);
 
@@ -163,14 +167,14 @@ void mei_hw_reset(struct mei_device *dev, bool intr_enable)
 	else
 		hcsr &= ~H_IE;
 
-	mei_hcsr_set(dev, hcsr);
+	mei_hcsr_set(hw, hcsr);
 
-	hcsr = mei_hcsr_read(dev) | H_IG;
+	hcsr = mei_hcsr_read(hw) | H_IG;
 	hcsr &= ~H_RST;
 
-	mei_hcsr_set(dev, hcsr);
+	mei_hcsr_set(hw, hcsr);
 
-	hcsr = mei_hcsr_read(dev);
+	hcsr = mei_hcsr_read(hw);
 
 	dev_dbg(&dev->pdev->dev, "current HCSR = 0x%08x.\n", hcsr);
 }
@@ -184,8 +188,9 @@ void mei_hw_reset(struct mei_device *dev, bool intr_enable)
 
 void mei_host_set_ready(struct mei_device *dev)
 {
-	dev->host_hw_state |= H_IE | H_IG | H_RDY;
-	mei_hcsr_set(dev, dev->host_hw_state);
+	struct mei_me_hw *hw = to_me_hw(dev);
+	hw->host_hw_state |= H_IE | H_IG | H_RDY;
+	mei_hcsr_set(hw, hw->host_hw_state);
 }
 /**
  * mei_host_is_ready - check whether the host has turned ready
@@ -195,8 +200,9 @@ void mei_host_set_ready(struct mei_device *dev)
  */
 bool mei_host_is_ready(struct mei_device *dev)
 {
-	dev->host_hw_state = mei_hcsr_read(dev);
-	return (dev->host_hw_state & H_RDY) == H_RDY;
+	struct mei_me_hw *hw = to_me_hw(dev);
+	hw->host_hw_state = mei_hcsr_read(hw);
+	return (hw->host_hw_state & H_RDY) == H_RDY;
 }
 
 /**
@@ -207,8 +213,9 @@ bool mei_host_is_ready(struct mei_device *dev)
  */
 bool mei_me_is_ready(struct mei_device *dev)
 {
-	dev->me_hw_state = mei_mecsr_read(dev);
-	return (dev->me_hw_state & ME_RDY_HRA) == ME_RDY_HRA;
+	struct mei_me_hw *hw = to_me_hw(dev);
+	hw->me_hw_state = mei_mecsr_read(hw);
+	return (hw->me_hw_state & ME_RDY_HRA) == ME_RDY_HRA;
 }
 
 /**
@@ -222,13 +229,14 @@ bool mei_me_is_ready(struct mei_device *dev)
 irqreturn_t mei_interrupt_quick_handler(int irq, void *dev_id)
 {
 	struct mei_device *dev = (struct mei_device *) dev_id;
-	u32 csr_reg = mei_hcsr_read(dev);
+	struct mei_me_hw *hw = to_me_hw(dev);
+	u32 csr_reg = mei_hcsr_read(hw);
 
 	if ((csr_reg & H_IS) != H_IS)
 		return IRQ_NONE;
 
 	/* clear H_IS bit in H_CSR */
-	mei_reg_write(dev, H_CSR, csr_reg);
+	mei_reg_write(hw, H_CSR, csr_reg);
 
 	return IRQ_WAKE_THREAD;
 }
@@ -242,12 +250,13 @@ irqreturn_t mei_interrupt_quick_handler(int irq, void *dev_id)
  */
 static unsigned char mei_hbuf_filled_slots(struct mei_device *dev)
 {
+	struct mei_me_hw *hw = to_me_hw(dev);
 	char read_ptr, write_ptr;
 
-	dev->host_hw_state = mei_hcsr_read(dev);
+	hw->host_hw_state = mei_hcsr_read(hw);
 
-	read_ptr = (char) ((dev->host_hw_state & H_CBRP) >> 8);
-	write_ptr = (char) ((dev->host_hw_state & H_CBWP) >> 16);
+	read_ptr = (char) ((hw->host_hw_state & H_CBRP) >> 8);
+	write_ptr = (char) ((hw->host_hw_state & H_CBWP) >> 16);
 
 	return (unsigned char) (write_ptr - read_ptr);
 }
@@ -297,6 +306,7 @@ int mei_hbuf_empty_slots(struct mei_device *dev)
 int mei_write_message(struct mei_device *dev, struct mei_msg_hdr *header,
 		      unsigned char *buf)
 {
+	struct mei_me_hw *hw = to_me_hw(dev);
 	unsigned long rem, dw_cnt;
 	unsigned long length = header->length;
 	u32 *reg_buf = (u32 *)buf;
@@ -313,20 +323,20 @@ int mei_write_message(struct mei_device *dev, struct mei_msg_hdr *header,
 	if (empty_slots < 0 || dw_cnt > empty_slots)
 		return -EIO;
 
-	mei_reg_write(dev, H_CB_WW, *((u32 *) header));
+	mei_reg_write(hw, H_CB_WW, *((u32 *) header));
 
 	for (i = 0; i < length / 4; i++)
-		mei_reg_write(dev, H_CB_WW, reg_buf[i]);
+		mei_reg_write(hw, H_CB_WW, reg_buf[i]);
 
 	rem = length & 0x3;
 	if (rem > 0) {
 		u32 reg = 0;
 		memcpy(&reg, &buf[length - rem], rem);
-		mei_reg_write(dev, H_CB_WW, reg);
+		mei_reg_write(hw, H_CB_WW, reg);
 	}
 
-	hcsr = mei_hcsr_read(dev) | H_IG;
-	mei_hcsr_set(dev, hcsr);
+	hcsr = mei_hcsr_read(hw) | H_IG;
+	mei_hcsr_set(hw, hcsr);
 	if (!mei_me_is_ready(dev))
 		return -EIO;
 
@@ -342,13 +352,14 @@ int mei_write_message(struct mei_device *dev, struct mei_msg_hdr *header,
  */
 int mei_count_full_read_slots(struct mei_device *dev)
 {
+	struct mei_me_hw *hw = to_me_hw(dev);
 	char read_ptr, write_ptr;
 	unsigned char buffer_depth, filled_slots;
 
-	dev->me_hw_state = mei_mecsr_read(dev);
-	buffer_depth = (unsigned char)((dev->me_hw_state & ME_CBD_HRA) >> 24);
-	read_ptr = (char) ((dev->me_hw_state & ME_CBRP_HRA) >> 8);
-	write_ptr = (char) ((dev->me_hw_state & ME_CBWP_HRA) >> 16);
+	hw->me_hw_state = mei_mecsr_read(hw);
+	buffer_depth = (unsigned char)((hw->me_hw_state & ME_CBD_HRA) >> 24);
+	read_ptr = (char) ((hw->me_hw_state & ME_CBRP_HRA) >> 8);
+	write_ptr = (char) ((hw->me_hw_state & ME_CBWP_HRA) >> 16);
 	filled_slots = (unsigned char) (write_ptr - read_ptr);
 
 	/* check for overflow */
@@ -369,6 +380,7 @@ int mei_count_full_read_slots(struct mei_device *dev)
 void mei_read_slots(struct mei_device *dev, unsigned char *buffer,
 		    unsigned long buffer_length)
 {
+	struct mei_me_hw *hw = to_me_hw(dev);
 	u32 *reg_buf = (u32 *)buffer;
 	u32 hcsr;
 
@@ -380,7 +392,36 @@ void mei_read_slots(struct mei_device *dev, unsigned char *buffer,
 		memcpy(reg_buf, &reg, buffer_length);
 	}
 
-	hcsr = mei_hcsr_read(dev) | H_IG;
-	mei_hcsr_set(dev, hcsr);
+	hcsr = mei_hcsr_read(hw) | H_IG;
+	mei_hcsr_set(hw, hcsr);
 }
 
+/**
+ * init_mei_device - allocates and initializes the mei device structure
+ *
+ * @pdev: The pci device structure
+ *
+ * returns The mei_device_device pointer on success, NULL on failure.
+ */
+struct mei_device *mei_me_dev_init(struct pci_dev *pdev)
+{
+	struct mei_device *dev;
+
+	dev = kzalloc(sizeof(struct mei_device) +
+			 sizeof(struct mei_me_hw), GFP_KERNEL);
+	if (!dev)
+		return NULL;
+
+	mei_device_init(dev);
+
+	INIT_LIST_HEAD(&dev->wd_cl.link);
+	INIT_LIST_HEAD(&dev->iamthif_cl.link);
+	mei_io_list_init(&dev->amthif_cmd_list);
+	mei_io_list_init(&dev->amthif_rd_complete_list);
+
+	INIT_DELAYED_WORK(&dev->timer_work, mei_timer);
+	INIT_WORK(&dev->init_work, mei_host_client_init);
+
+	dev->pdev = pdev;
+	return dev;
+}
diff --git a/drivers/misc/mei/hw-me.h b/drivers/misc/mei/hw-me.h
index 73bef54..53bcc00 100644
--- a/drivers/misc/mei/hw-me.h
+++ b/drivers/misc/mei/hw-me.h
@@ -21,8 +21,20 @@
 
 #include <linux/mei.h>
 #include "mei_dev.h"
+#include "client.h"
 
+struct mei_me_hw {
+	void __iomem *mem_addr;
+	/*
+	 * hw states of host and fw(ME)
+	 */
+	u32 host_hw_state;
+	u32 me_hw_state;
+};
 
+#define to_me_hw(dev) (struct mei_me_hw *)((dev)->hw)
+
+struct mei_device *mei_me_dev_init(struct pci_dev *pdev);
 
 void mei_read_slots(struct mei_device *dev,
 		     unsigned char *buffer,
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 5d08db5..1e1876f 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -42,28 +42,10 @@ const char *mei_dev_state_str(int state)
 #undef MEI_DEV_STATE
 }
 
-
-
-
-/**
- * init_mei_device - allocates and initializes the mei device structure
- *
- * @pdev: The pci device structure
- *
- * returns The mei_device_device pointer on success, NULL on failure.
- */
-struct mei_device *mei_device_init(struct pci_dev *pdev)
+void mei_device_init(struct mei_device *dev)
 {
-	struct mei_device *dev;
-
-	dev = kzalloc(sizeof(struct mei_device), GFP_KERNEL);
-	if (!dev)
-		return NULL;
-
 	/* setup our list array */
 	INIT_LIST_HEAD(&dev->file_list);
-	INIT_LIST_HEAD(&dev->wd_cl.link);
-	INIT_LIST_HEAD(&dev->iamthif_cl.link);
 	mutex_init(&dev->device_lock);
 	init_waitqueue_head(&dev->wait_recvd_msg);
 	init_waitqueue_head(&dev->wait_stop_wd);
@@ -74,14 +56,6 @@ struct mei_device *mei_device_init(struct pci_dev *pdev)
 	mei_io_list_init(&dev->write_waiting_list);
 	mei_io_list_init(&dev->ctrl_wr_list);
 	mei_io_list_init(&dev->ctrl_rd_list);
-	mei_io_list_init(&dev->amthif_cmd_list);
-	mei_io_list_init(&dev->amthif_rd_complete_list);
-
-	INIT_DELAYED_WORK(&dev->timer_work, mei_timer);
-	INIT_WORK(&dev->init_work, mei_host_client_init);
-
-	dev->pdev = pdev;
-	return dev;
 }
 
 /**
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 3b2bca3..bb759fd 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -235,18 +235,13 @@ struct mei_device {
 	struct list_head file_list;
 	long open_handle_count;
 
-	void __iomem *mem_addr;
 	/*
 	 * lock for the device
 	 */
 	struct mutex device_lock; /* device lock */
 	struct delayed_work timer_work;	/* MEI timer delayed work (timeouts) */
 	bool recvd_msg;
-	/*
-	 * hw states of host and fw(ME)
-	 */
-	u32 host_hw_state;
-	u32 me_hw_state;
+
 	u8  hbuf_depth;
 	/*
 	 * waiting queue for receive message from FW
@@ -311,6 +306,7 @@ struct mei_device {
 	bool iamthif_canceled;
 
 	struct work_struct init_work;
+	char hw[0] __aligned(sizeof(void *));
 };
 
 static inline unsigned long mei_secs_to_jiffies(unsigned long sec)
@@ -322,7 +318,7 @@ static inline unsigned long mei_secs_to_jiffies(unsigned long sec)
 /*
  * mei init function prototypes
  */
-struct mei_device *mei_device_init(struct pci_dev *pdev);
+void mei_device_init(struct mei_device *dev);
 void mei_reset(struct mei_device *dev, int interrupts);
 int mei_hw_init(struct mei_device *dev);
 
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index eaed398..27ac717 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -90,7 +90,6 @@ MODULE_DEVICE_TABLE(pci, mei_pci_tbl);
 
 static DEFINE_MUTEX(mei_mutex);
 
-
 /**
  * mei_quirk_probe - probe for devices that doesn't valid ME interface
  * @pdev: PCI device structure
@@ -120,10 +119,10 @@ static bool mei_quirk_probe(struct pci_dev *pdev,
  *
  * returns 0 on success, <0 on failure.
  */
-static int mei_probe(struct pci_dev *pdev,
-				const struct pci_device_id *ent)
+static int mei_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct mei_device *dev;
+	struct mei_me_hw *hw;
 	int err;
 
 	mutex_lock(&mei_mutex);
@@ -152,14 +151,15 @@ static int mei_probe(struct pci_dev *pdev,
 		goto disable_device;
 	}
 	/* allocates and initializes the mei dev structure */
-	dev = mei_device_init(pdev);
+	dev = mei_me_dev_init(pdev);
 	if (!dev) {
 		err = -ENOMEM;
 		goto release_regions;
 	}
+	hw = to_me_hw(dev);
 	/* mapping  IO device memory */
-	dev->mem_addr = pci_iomap(pdev, 0, 0);
-	if (!dev->mem_addr) {
+	hw->mem_addr = pci_iomap(pdev, 0, 0);
+	if (!hw->mem_addr) {
 		dev_err(&pdev->dev, "mapping I/O device memory failure.\n");
 		err = -ENOMEM;
 		goto free_device;
@@ -212,7 +212,7 @@ release_irq:
 	free_irq(pdev->irq, dev);
 disable_msi:
 	pci_disable_msi(pdev);
-	pci_iounmap(pdev, dev->mem_addr);
+	pci_iounmap(pdev, hw->mem_addr);
 free_device:
 	kfree(dev);
 release_regions:
@@ -236,6 +236,7 @@ end:
 static void mei_remove(struct pci_dev *pdev)
 {
 	struct mei_device *dev;
+	struct mei_me_hw *hw;
 
 	if (mei_pdev != pdev)
 		return;
@@ -244,6 +245,8 @@ static void mei_remove(struct pci_dev *pdev)
 	if (!dev)
 		return;
 
+	hw = to_me_hw(dev);
+
 	mutex_lock(&dev->device_lock);
 
 	cancel_delayed_work(&dev->timer_work);
@@ -289,8 +292,8 @@ static void mei_remove(struct pci_dev *pdev)
 	pci_disable_msi(pdev);
 	pci_set_drvdata(pdev, NULL);
 
-	if (dev->mem_addr)
-		pci_iounmap(pdev, dev->mem_addr);
+	if (hw->mem_addr)
+		pci_iounmap(pdev, hw->mem_addr);
 
 	kfree(dev);
 
-- 
1.7.4.4


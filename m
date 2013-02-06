Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab3BFMIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 07:08:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:39807 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842Ab3BFMHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 07:07:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,615,1355126400"; 
   d="scan'208";a="287310842"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 3/6] mei: separate compilation of the ME hardware specifics
Date: Wed,  6 Feb 2013 14:06:41 +0200
Message-Id: <1360152404-5769-4-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1360152404-5769-1-git-send-email-tomas.winkler@intel.com>
References: <1360152404-5769-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We add struct mei_hw_ops to virtualize access to hw specific
configurations. This allows us to separate the compilation
of the ME interface from the ME hardware specifics

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/Kconfig     |   17 ++++-
 drivers/misc/mei/Makefile    |    6 +-
 drivers/misc/mei/amthif.c    |    6 +-
 drivers/misc/mei/hw-me.c     |   87 +++++++++++++++++++---------
 drivers/misc/mei/hw-me.h     |   19 ------
 drivers/misc/mei/init.c      |    2 +-
 drivers/misc/mei/interrupt.c |   10 ++--
 drivers/misc/mei/main.c      |    5 +-
 drivers/misc/mei/mei_dev.h   |  132 ++++++++++++++++++++++++++++++++++++++---
 9 files changed, 210 insertions(+), 74 deletions(-)

diff --git a/drivers/misc/mei/Kconfig b/drivers/misc/mei/Kconfig
index 5a79ccd..fa5c249 100644
--- a/drivers/misc/mei/Kconfig
+++ b/drivers/misc/mei/Kconfig
@@ -1,11 +1,22 @@
 config INTEL_MEI
-	tristate "Intel Management Engine Interface (Intel MEI)"
-	depends on X86 && PCI && WATCHDOG_CORE
+	tristate "Intel Management Engine Interface"
+	depends on X86 && PCI
 	help
 	  The Intel Management Engine (Intel ME) provides Manageability,
 	  Security and Media services for system containing Intel chipsets.
 	  if selected /dev/mei misc device will be created.
 
+	  For more information see
+	  <http://software.intel.com/en-us/manageability/>
+
+config INTEL_MEI_ME
+	bool "ME Enabled Intel Chipsets"
+	depends on INTEL_MEI
+	depends on X86 && PCI && WATCHDOG_CORE
+	default y
+	help
+	  MEI support for ME Enabled Intel chipsets.
+
 	  Supported Chipsets are:
 	  7 Series Chipset Family
 	  6 Series Chipset Family
@@ -24,5 +35,3 @@ config INTEL_MEI
 	  82Q33 Express
 	  82X38/X48 Express
 
-	  For more information see
-	  <http://software.intel.com/en-us/manageability/>
diff --git a/drivers/misc/mei/Makefile b/drivers/misc/mei/Makefile
index 068f553..040af6c 100644
--- a/drivers/misc/mei/Makefile
+++ b/drivers/misc/mei/Makefile
@@ -6,9 +6,9 @@ obj-$(CONFIG_INTEL_MEI) += mei.o
 mei-objs := init.o
 mei-objs += hbm.o
 mei-objs += interrupt.o
-mei-objs += hw-me.o
+mei-objs += client.o
 mei-objs += main.o
 mei-objs += amthif.o
 mei-objs += wd.o
-mei-objs += client.o
-mei-objs += pci-me.o
+mei-$(CONFIG_INTEL_MEI_ME) += pci-me.o
+mei-$(CONFIG_INTEL_MEI_ME) += hw-me.o
diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index 263ed4c..a7c4838 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -300,8 +300,8 @@ static int mei_amthif_send_cmd(struct mei_device *dev, struct mei_cl_cb *cb)
 	if (ret && dev->mei_host_buffer_is_empty) {
 		ret = 0;
 		dev->mei_host_buffer_is_empty = false;
-		if (cb->request_buffer.size > mei_hbuf_max_data(dev)) {
-			mei_hdr.length = mei_hbuf_max_data(dev);
+		if (cb->request_buffer.size > mei_hbuf_max_len(dev)) {
+			mei_hdr.length = mei_hbuf_max_len(dev);
 			mei_hdr.msg_complete = 0;
 		} else {
 			mei_hdr.length = cb->request_buffer.size;
@@ -583,7 +583,7 @@ int mei_amthif_irq_read(struct mei_device *dev, s32 *slots)
 	dev->iamthif_msg_buf_index = 0;
 	dev->iamthif_msg_buf_size = 0;
 	dev->iamthif_stall_timer = MEI_IAMTHIF_STALL_TIMER;
-	dev->mei_host_buffer_is_empty = mei_hbuf_is_empty(dev);
+	dev->mei_host_buffer_is_empty = mei_hbuf_is_ready(dev);
 	return 0;
 }
 
diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 3bdf228..6300943 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -56,7 +56,7 @@ static inline void mei_reg_write(const struct mei_me_hw *hw,
  *
  * returns ME_CB_RW register value (u32)
  */
-u32 mei_mecbrw_read(const struct mei_device *dev)
+static u32 mei_me_mecbrw_read(const struct mei_device *dev)
 {
 	return mei_reg_read(to_me_hw(dev), ME_CB_RW);
 }
@@ -102,7 +102,7 @@ static inline void mei_hcsr_set(struct mei_me_hw *hw, u32 hcsr)
  *
  * @dev: mei device
  */
-void mei_hw_config(struct mei_device *dev)
+static void mei_me_hw_config(struct mei_device *dev)
 {
 	u32 hcsr = mei_hcsr_read(to_me_hw(dev));
 	/* Doesn't change in runtime */
@@ -113,20 +113,19 @@ void mei_hw_config(struct mei_device *dev)
  *
  * @dev: the device structure
  */
-void mei_clear_interrupts(struct mei_device *dev)
+static void mei_me_intr_clear(struct mei_device *dev)
 {
 	struct mei_me_hw *hw = to_me_hw(dev);
 	u32 hcsr = mei_hcsr_read(hw);
 	if ((hcsr & H_IS) == H_IS)
 		mei_reg_write(hw, H_CSR, hcsr);
 }
-
 /**
- * mei_enable_interrupts - enables mei device interrupts
+ * mei_me_intr_enable - enables mei device interrupts
  *
  * @dev: the device structure
  */
-void mei_enable_interrupts(struct mei_device *dev)
+static void mei_me_intr_enable(struct mei_device *dev)
 {
 	struct mei_me_hw *hw = to_me_hw(dev);
 	u32 hcsr = mei_hcsr_read(hw);
@@ -139,7 +138,7 @@ void mei_enable_interrupts(struct mei_device *dev)
  *
  * @dev: the device structure
  */
-void mei_disable_interrupts(struct mei_device *dev)
+static void mei_me_intr_disable(struct mei_device *dev)
 {
 	struct mei_me_hw *hw = to_me_hw(dev);
 	u32 hcsr = mei_hcsr_read(hw);
@@ -148,12 +147,12 @@ void mei_disable_interrupts(struct mei_device *dev)
 }
 
 /**
- * mei_hw_reset - resets fw via mei csr register.
+ * mei_me_hw_reset - resets fw via mei csr register.
  *
  * @dev: the device structure
  * @interrupts_enabled: if interrupt should be enabled after reset.
  */
-void mei_hw_reset(struct mei_device *dev, bool intr_enable)
+static void mei_me_hw_reset(struct mei_device *dev, bool intr_enable)
 {
 	struct mei_me_hw *hw = to_me_hw(dev);
 	u32 hcsr = mei_hcsr_read(hw);
@@ -180,25 +179,25 @@ void mei_hw_reset(struct mei_device *dev, bool intr_enable)
 }
 
 /**
- * mei_host_set_ready - enable device
+ * mei_me_host_set_ready - enable device
  *
  * @dev - mei device
  * returns bool
  */
 
-void mei_host_set_ready(struct mei_device *dev)
+static void mei_me_host_set_ready(struct mei_device *dev)
 {
 	struct mei_me_hw *hw = to_me_hw(dev);
 	hw->host_hw_state |= H_IE | H_IG | H_RDY;
 	mei_hcsr_set(hw, hw->host_hw_state);
 }
 /**
- * mei_host_is_ready - check whether the host has turned ready
+ * mei_me_host_is_ready - check whether the host has turned ready
  *
  * @dev - mei device
  * returns bool
  */
-bool mei_host_is_ready(struct mei_device *dev)
+static bool mei_me_host_is_ready(struct mei_device *dev)
 {
 	struct mei_me_hw *hw = to_me_hw(dev);
 	hw->host_hw_state = mei_hcsr_read(hw);
@@ -206,12 +205,12 @@ bool mei_host_is_ready(struct mei_device *dev)
 }
 
 /**
- * mei_me_is_ready - check whether the me has turned ready
+ * mei_me_hw_is_ready - check whether the me(hw) has turned ready
  *
  * @dev - mei device
  * returns bool
  */
-bool mei_me_is_ready(struct mei_device *dev)
+static bool mei_me_hw_is_ready(struct mei_device *dev)
 {
 	struct mei_me_hw *hw = to_me_hw(dev);
 	hw->me_hw_state = mei_mecsr_read(hw);
@@ -268,19 +267,19 @@ static unsigned char mei_hbuf_filled_slots(struct mei_device *dev)
  *
  * returns true if empty, false - otherwise.
  */
-bool mei_hbuf_is_empty(struct mei_device *dev)
+static bool mei_me_hbuf_is_empty(struct mei_device *dev)
 {
 	return mei_hbuf_filled_slots(dev) == 0;
 }
 
 /**
- * mei_hbuf_empty_slots - counts write empty slots.
+ * mei_me_hbuf_empty_slots - counts write empty slots.
  *
  * @dev: the device structure
  *
  * returns -1(ESLOTS_OVERFLOW) if overflow, otherwise empty slots count
  */
-int mei_hbuf_empty_slots(struct mei_device *dev)
+static int mei_me_hbuf_empty_slots(struct mei_device *dev)
 {
 	unsigned char filled_slots, empty_slots;
 
@@ -294,6 +293,12 @@ int mei_hbuf_empty_slots(struct mei_device *dev)
 	return empty_slots;
 }
 
+static size_t mei_me_hbuf_max_len(const struct mei_device *dev)
+{
+	return dev->hbuf_depth * sizeof(u32) - sizeof(struct mei_msg_hdr);
+}
+
+
 /**
  * mei_write_message - writes a message to mei device.
  *
@@ -303,8 +308,9 @@ int mei_hbuf_empty_slots(struct mei_device *dev)
  *
  * This function returns -EIO if write has failed
  */
-int mei_write_message(struct mei_device *dev, struct mei_msg_hdr *header,
-		      unsigned char *buf)
+static int mei_me_write_message(struct mei_device *dev,
+			struct mei_msg_hdr *header,
+			unsigned char *buf)
 {
 	struct mei_me_hw *hw = to_me_hw(dev);
 	unsigned long rem, dw_cnt;
@@ -337,20 +343,20 @@ int mei_write_message(struct mei_device *dev, struct mei_msg_hdr *header,
 
 	hcsr = mei_hcsr_read(hw) | H_IG;
 	mei_hcsr_set(hw, hcsr);
-	if (!mei_me_is_ready(dev))
+	if (!mei_me_hw_is_ready(dev))
 		return -EIO;
 
 	return 0;
 }
 
 /**
- * mei_count_full_read_slots - counts read full slots.
+ * mei_me_count_full_read_slots - counts read full slots.
  *
  * @dev: the device structure
  *
  * returns -1(ESLOTS_OVERFLOW) if overflow, otherwise filled slots count
  */
-int mei_count_full_read_slots(struct mei_device *dev)
+static int mei_me_count_full_read_slots(struct mei_device *dev)
 {
 	struct mei_me_hw *hw = to_me_hw(dev);
 	char read_ptr, write_ptr;
@@ -371,13 +377,13 @@ int mei_count_full_read_slots(struct mei_device *dev)
 }
 
 /**
- * mei_read_slots - reads a message from mei device.
+ * mei_me_read_slots - reads a message from mei device.
  *
  * @dev: the device structure
  * @buffer: message buffer will be written
  * @buffer_length: message size will be read
  */
-void mei_read_slots(struct mei_device *dev, unsigned char *buffer,
+static int mei_me_read_slots(struct mei_device *dev, unsigned char *buffer,
 		    unsigned long buffer_length)
 {
 	struct mei_me_hw *hw = to_me_hw(dev);
@@ -385,17 +391,42 @@ void mei_read_slots(struct mei_device *dev, unsigned char *buffer,
 	u32 hcsr;
 
 	for (; buffer_length >= sizeof(u32); buffer_length -= sizeof(u32))
-		*reg_buf++ = mei_mecbrw_read(dev);
+		*reg_buf++ = mei_me_mecbrw_read(dev);
 
 	if (buffer_length > 0) {
-		u32 reg = mei_mecbrw_read(dev);
+		u32 reg = mei_me_mecbrw_read(dev);
 		memcpy(reg_buf, &reg, buffer_length);
 	}
 
 	hcsr = mei_hcsr_read(hw) | H_IG;
 	mei_hcsr_set(hw, hcsr);
+	return 0;
 }
 
+static const struct mei_hw_ops mei_me_hw_ops = {
+
+	.host_set_ready = mei_me_host_set_ready,
+	.host_is_ready = mei_me_host_is_ready,
+
+	.hw_is_ready = mei_me_hw_is_ready,
+	.hw_reset = mei_me_hw_reset,
+	.hw_config  = mei_me_hw_config,
+
+	.intr_clear = mei_me_intr_clear,
+	.intr_enable = mei_me_intr_enable,
+	.intr_disable = mei_me_intr_disable,
+
+	.hbuf_free_slots = mei_me_hbuf_empty_slots,
+	.hbuf_is_ready = mei_me_hbuf_is_empty,
+	.hbuf_max_len = mei_me_hbuf_max_len,
+
+	.write = mei_me_write_message,
+
+	.rdbuf_full_slots = mei_me_count_full_read_slots,
+	.read_hdr = mei_me_mecbrw_read,
+	.read = mei_me_read_slots
+};
+
 /**
  * init_mei_device - allocates and initializes the mei device structure
  *
@@ -422,6 +453,8 @@ struct mei_device *mei_me_dev_init(struct pci_dev *pdev)
 	INIT_DELAYED_WORK(&dev->timer_work, mei_timer);
 	INIT_WORK(&dev->init_work, mei_host_client_init);
 
+	dev->ops = &mei_me_hw_ops;
+
 	dev->pdev = pdev;
 	return dev;
 }
diff --git a/drivers/misc/mei/hw-me.h b/drivers/misc/mei/hw-me.h
index 53bcc00..9a3aaab 100644
--- a/drivers/misc/mei/hw-me.h
+++ b/drivers/misc/mei/hw-me.h
@@ -36,29 +36,10 @@ struct mei_me_hw {
 
 struct mei_device *mei_me_dev_init(struct pci_dev *pdev);
 
-void mei_read_slots(struct mei_device *dev,
-		     unsigned char *buffer,
-		     unsigned long buffer_length);
-
-int mei_write_message(struct mei_device *dev,
-			struct mei_msg_hdr *header,
-			unsigned char *buf);
-
-bool mei_hbuf_is_empty(struct mei_device *dev);
-
-int mei_hbuf_empty_slots(struct mei_device *dev);
-
-static inline size_t mei_hbuf_max_data(const struct mei_device *dev)
-{
-	return dev->hbuf_depth * sizeof(u32) - sizeof(struct mei_msg_hdr);
-}
-
 /* get slots (dwords) from a message length + header (bytes) */
 static inline unsigned char mei_data2slots(size_t length)
 {
 	return DIV_ROUND_UP(sizeof(struct mei_msg_hdr) + length, 4);
 }
 
-int mei_count_full_read_slots(struct mei_device *dev);
-
 #endif /* _MEI_INTERFACE_H_ */
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 1e1876f..51a005e 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -104,7 +104,7 @@ int mei_hw_init(struct mei_device *dev)
 		goto err;
 	}
 
-	if (!mei_me_is_ready(dev)) {
+	if (!mei_hw_is_ready(dev)) {
 		dev_err(&dev->pdev->dev, "ME is not ready.\n");
 		goto err;
 	}
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index b04ed9b..431aa91 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -329,7 +329,7 @@ static int mei_irq_thread_read_handler(struct mei_cl_cb *cmpl_list,
 	int ret = 0;
 
 	if (!dev->rd_msg_hdr) {
-		dev->rd_msg_hdr = mei_mecbrw_read(dev);
+		dev->rd_msg_hdr = mei_read_hdr(dev);
 		dev_dbg(&dev->pdev->dev, "slots =%08x.\n", *slots);
 		(*slots)--;
 		dev_dbg(&dev->pdev->dev, "slots =%08x.\n", *slots);
@@ -430,7 +430,7 @@ static int mei_irq_thread_write_handler(struct mei_device *dev,
 	s32 slots;
 	int ret;
 
-	if (!mei_hbuf_is_empty(dev)) {
+	if (!mei_hbuf_is_ready(dev)) {
 		dev_dbg(&dev->pdev->dev, "host buffer is not empty.\n");
 		return 0;
 	}
@@ -698,7 +698,7 @@ irqreturn_t mei_interrupt_thread_handler(int irq, void *dev_id)
 		mei_clear_interrupts(dev);
 
 	/* check if ME wants a reset */
-	if (!mei_me_is_ready(dev) &&
+	if (!mei_hw_is_ready(dev) &&
 	    dev->dev_state != MEI_DEV_RESETING &&
 	    dev->dev_state != MEI_DEV_INITIALIZING) {
 		dev_dbg(&dev->pdev->dev, "FW not ready.\n");
@@ -709,7 +709,7 @@ irqreturn_t mei_interrupt_thread_handler(int irq, void *dev_id)
 
 	/*  check if we need to start the dev */
 	if (!mei_host_is_ready(dev)) {
-		if (mei_me_is_ready(dev)) {
+		if (mei_hw_is_ready(dev)) {
 			dev_dbg(&dev->pdev->dev, "we need to start the dev.\n");
 
 			mei_host_set_ready(dev);
@@ -743,7 +743,7 @@ irqreturn_t mei_interrupt_thread_handler(int irq, void *dev_id)
 	rets = mei_irq_thread_write_handler(dev, &complete_list);
 end:
 	dev_dbg(&dev->pdev->dev, "end of bottom half function.\n");
-	dev->mei_host_buffer_is_empty = mei_hbuf_is_empty(dev);
+	dev->mei_host_buffer_is_empty = mei_hbuf_is_ready(dev);
 
 	bus_message_received = false;
 	if (dev->recvd_msg && waitqueue_active(&dev->wait_recvd_msg)) {
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 018623c..843ae2f 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -462,8 +462,8 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 	}
 
 	dev->mei_host_buffer_is_empty = false;
-	if (length >  mei_hbuf_max_data(dev)) {
-		mei_hdr.length = mei_hbuf_max_data(dev);
+	if (length >  mei_hbuf_max_len(dev)) {
+		mei_hdr.length = mei_hbuf_max_len(dev);
 		mei_hdr.msg_complete = 0;
 	} else {
 		mei_hdr.length = length;
@@ -765,4 +765,5 @@ void mei_deregister(void)
 	mei_misc_device.parent = NULL;
 }
 
+MODULE_LICENSE("GPL v2");
 
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index bb759fd..c974292 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -211,6 +211,58 @@ struct mei_cl {
 	struct mei_cl_cb *read_cb;
 };
 
+/** struct mei_hw_ops
+ *
+ * @host_set_ready   - notify FW that host side is ready
+ * @host_is_ready    - query for host readiness
+
+ * @hw_is_ready      - query if hw is ready
+ * @hw_reset         - reset hw
+ * @hw_config        - configure hw
+
+ * @intr_clear       - clear pending interrupts
+ * @intr_enable      - enable interrupts
+ * @intr_disable     - disable interrupts
+
+ * @hbuf_free_slots  - query for write buffer empty slots
+ * @hbuf_is_ready    - query if write buffer is empty
+ * @hbuf_max_len     - query for write buffer max len
+
+ * @write            - write a message to FW
+
+ * @rdbuf_full_slots - query how many slots are filled
+
+ * @read_hdr         - get first 4 bytes (header)
+ * @read             - read a buffer from the FW
+ */
+struct mei_hw_ops {
+
+	void (*host_set_ready) (struct mei_device *dev);
+	bool (*host_is_ready) (struct mei_device *dev);
+
+	bool (*hw_is_ready) (struct mei_device *dev);
+	void (*hw_reset) (struct mei_device *dev, bool enable);
+	void (*hw_config) (struct mei_device *dev);
+
+	void (*intr_clear) (struct mei_device *dev);
+	void (*intr_enable) (struct mei_device *dev);
+	void (*intr_disable) (struct mei_device *dev);
+
+	int (*hbuf_free_slots) (struct mei_device *dev);
+	bool (*hbuf_is_ready) (struct mei_device *dev);
+	size_t (*hbuf_max_len) (const struct mei_device *dev);
+
+	int (*write)(struct mei_device *dev,
+		     struct mei_msg_hdr *hdr,
+		     unsigned char *buf);
+
+	int (*rdbuf_full_slots)(struct mei_device *dev);
+
+	u32 (*read_hdr)(const struct mei_device *dev);
+	int (*read) (struct mei_device *dev,
+		     unsigned char *buf, unsigned long len);
+};
+
 /**
  * struct mei_device -  MEI private device struct
  * @mem_addr - mem mapped base register address
@@ -306,6 +358,8 @@ struct mei_device {
 	bool iamthif_canceled;
 
 	struct work_struct init_work;
+
+	const struct mei_hw_ops *ops;
 	char hw[0] __aligned(sizeof(void *));
 };
 
@@ -376,26 +430,84 @@ void mei_watchdog_register(struct mei_device *dev);
  */
 void mei_watchdog_unregister(struct mei_device *dev);
 
-
 /*
  * Register Access Function
  */
 
-void mei_hw_config(struct mei_device *dev);
-void mei_hw_reset(struct mei_device *dev, bool intr_enable);
-u32 mei_mecbrw_read(const struct mei_device *dev);
+static inline void mei_hw_config(struct mei_device *dev)
+{
+	dev->ops->hw_config(dev);
+}
+static inline void mei_hw_reset(struct mei_device *dev, bool enable)
+{
+	dev->ops->hw_reset(dev, enable);
+}
+
+static inline void mei_clear_interrupts(struct mei_device *dev)
+{
+	dev->ops->intr_clear(dev);
+}
+
+static inline void mei_enable_interrupts(struct mei_device *dev)
+{
+	dev->ops->intr_enable(dev);
+}
 
+static inline void mei_disable_interrupts(struct mei_device *dev)
+{
+	dev->ops->intr_disable(dev);
+}
 
+static inline void mei_host_set_ready(struct mei_device *dev)
+{
+	dev->ops->host_set_ready(dev);
+}
+static inline bool mei_host_is_ready(struct mei_device *dev)
+{
+	return dev->ops->host_is_ready(dev);
+}
+static inline bool mei_hw_is_ready(struct mei_device *dev)
+{
+	return dev->ops->hw_is_ready(dev);
+}
 
-void mei_clear_interrupts(struct mei_device *dev);
-void mei_enable_interrupts(struct mei_device *dev);
-void mei_disable_interrupts(struct mei_device *dev);
+static inline bool mei_hbuf_is_ready(struct mei_device *dev)
+{
+	return dev->ops->hbuf_is_ready(dev);
+}
 
-void mei_host_set_ready(struct mei_device *dev);
-bool mei_host_is_ready(struct mei_device *dev);
-bool mei_me_is_ready(struct mei_device *dev);
+static inline int mei_hbuf_empty_slots(struct mei_device *dev)
+{
+	return dev->ops->hbuf_free_slots(dev);
+}
 
+static inline size_t mei_hbuf_max_len(const struct mei_device *dev)
+{
+	return dev->ops->hbuf_max_len(dev);
+}
 
+static inline int mei_write_message(struct mei_device *dev,
+			struct mei_msg_hdr *hdr,
+			unsigned char *buf)
+{
+	return dev->ops->write(dev, hdr, buf);
+}
+
+static inline u32 mei_read_hdr(const struct mei_device *dev)
+{
+	return dev->ops->read_hdr(dev);
+}
+
+static inline void mei_read_slots(struct mei_device *dev,
+		     unsigned char *buf, unsigned long len)
+{
+	dev->ops->read(dev, buf, len);
+}
+
+static inline int mei_count_full_read_slots(struct mei_device *dev)
+{
+	return dev->ops->rdbuf_full_slots(dev);
+}
 
 int mei_register(struct device *dev);
 void mei_deregister(void);
-- 
1.7.4.4


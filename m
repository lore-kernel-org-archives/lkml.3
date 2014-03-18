Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933107AbaCRUxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:53:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:13521 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932956AbaCRUxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:53:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,680,1389772800"; 
   d="scan'208";a="475172392"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [char-misc-next 04/13] mei: condition PGI support on HW and HBM version
Date: Tue, 18 Mar 2014 22:51:58 +0200
Message-Id: <1395175927-10562-5-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395175927-10562-1-git-send-email-tomas.winkler@intel.com>
References: <1395175927-10562-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable power gating isolation only if hw and fw support it.
This is indicated by ME_PGIC_HRA bit in ME_CSR_HA register
and on HBM protocol version.

The information is exported to MEI layer through
new pg_is_enabled hw op.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
---
 drivers/misc/mei/hw-me.c   | 37 +++++++++++++++++++++++++++++++++++++
 drivers/misc/mei/hw-txe.c  | 14 ++++++++++++++
 drivers/misc/mei/hw.h      |  6 ++++++
 drivers/misc/mei/mei_dev.h | 10 ++++++++++
 4 files changed, 67 insertions(+)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index fc5d001..7a7e662 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -460,6 +460,41 @@ static void mei_me_pg_exit(struct mei_device *dev)
 }
 
 /**
+ * mei_me_pg_is_enabled - detect if PG is supported by HW
+ *
+ * @dev: the device structure
+ *
+ * returns: true is pg supported, false otherwise
+ */
+static bool mei_me_pg_is_enabled(struct mei_device *dev)
+{
+	struct mei_me_hw *hw = to_me_hw(dev);
+	u32 reg = mei_me_reg_read(hw, ME_CSR_HA);
+
+	if ((reg & ME_PGIC_HRA) == 0)
+		goto notsupported;
+
+	if (dev->version.major_version < HBM_MAJOR_VERSION_PGI)
+		goto notsupported;
+
+	if (dev->version.major_version == HBM_MAJOR_VERSION_PGI &&
+	    dev->version.minor_version < HBM_MINOR_VERSION_PGI)
+		goto notsupported;
+
+	return true;
+
+notsupported:
+	dev_dbg(&dev->pdev->dev, "pg: not supported: HGP = %d hbm version %d.%d ?= %d.%d\n",
+		!!(reg & ME_PGIC_HRA),
+		dev->version.major_version,
+		dev->version.minor_version,
+		HBM_MAJOR_VERSION_PGI,
+		HBM_MINOR_VERSION_PGI);
+
+	return false;
+}
+
+/**
  * mei_me_irq_quick_handler - The ISR of the MEI device
  *
  * @irq: The irq number
@@ -573,6 +608,8 @@ static const struct mei_hw_ops mei_me_hw_ops = {
 	.hw_config = mei_me_hw_config,
 	.hw_start = mei_me_hw_start,
 
+	.pg_is_enabled = mei_me_pg_is_enabled,
+
 	.intr_clear = mei_me_intr_clear,
 	.intr_enable = mei_me_intr_enable,
 	.intr_disable = mei_me_intr_disable,
diff --git a/drivers/misc/mei/hw-txe.c b/drivers/misc/mei/hw-txe.c
index f60182a..49f197a 100644
--- a/drivers/misc/mei/hw-txe.c
+++ b/drivers/misc/mei/hw-txe.c
@@ -280,6 +280,18 @@ int mei_txe_aliveness_set_sync(struct mei_device *dev, u32 req)
 }
 
 /**
+ * mei_txe_pg_is_enabled - detect if PG is supported by HW
+ *
+ * @dev: the device structure
+ *
+ * returns: true is pg supported, false otherwise
+ */
+static bool mei_txe_pg_is_enabled(struct mei_device *dev)
+{
+	return true;
+}
+
+/**
  * mei_txe_input_ready_interrupt_enable - sets the Input Ready Interrupt
  *
  * @dev: the device structure
@@ -1017,6 +1029,8 @@ static const struct mei_hw_ops mei_txe_hw_ops = {
 	.hw_config = mei_txe_hw_config,
 	.hw_start = mei_txe_hw_start,
 
+	.pg_is_enabled = mei_txe_pg_is_enabled,
+
 	.intr_clear = mei_txe_intr_clear,
 	.intr_enable = mei_txe_intr_enable,
 	.intr_disable = mei_txe_intr_disable,
diff --git a/drivers/misc/mei/hw.h b/drivers/misc/mei/hw.h
index 1d70968..ec4a91a 100644
--- a/drivers/misc/mei/hw.h
+++ b/drivers/misc/mei/hw.h
@@ -39,6 +39,12 @@
 #define HBM_MINOR_VERSION                   0
 #define HBM_MAJOR_VERSION                   1
 
+/*
+ * MEI version with PGI support
+ */
+#define HBM_MINOR_VERSION_PGI               1
+#define HBM_MAJOR_VERSION_PGI               1
+
 /* Host bus message command opcode */
 #define MEI_HBM_CMD_OP_MSK                  0x7f
 /* Host bus message command RESPONSE */
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 4d4c041..ca7581c 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -220,6 +220,8 @@ struct mei_cl {
  * @hw_start         - start hw after reset
  * @hw_config        - configure hw
 
+ * @pg_is_enabled    - is power gating enabled
+
  * @intr_clear       - clear pending interrupts
  * @intr_enable      - enable interrupts
  * @intr_disable     - disable interrupts
@@ -244,6 +246,8 @@ struct mei_hw_ops {
 	int (*hw_start)(struct mei_device *dev);
 	void (*hw_config)(struct mei_device *dev);
 
+	bool (*pg_is_enabled)(struct mei_device *dev);
+
 	void (*intr_clear)(struct mei_device *dev);
 	void (*intr_enable)(struct mei_device *dev);
 	void (*intr_disable)(struct mei_device *dev);
@@ -558,6 +562,12 @@ static inline void mei_hw_config(struct mei_device *dev)
 {
 	dev->ops->hw_config(dev);
 }
+
+static inline bool mei_pg_is_enabled(struct mei_device *dev)
+{
+	return dev->ops->pg_is_enabled(dev);
+}
+
 static inline int mei_hw_reset(struct mei_device *dev, bool enable)
 {
 	return dev->ops->hw_reset(dev, enable);
-- 
1.8.5.3


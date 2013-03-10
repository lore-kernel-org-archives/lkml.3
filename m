Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab3CJL4j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 07:56:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:23657 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115Ab3CJL4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 07:56:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,817,1355126400"; 
   d="scan'208";a="299148189"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org, sameo@linux.intel.com
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc 1/2][3.9] mei: ME hardware reset needs to be synchronized
Date: Sun, 10 Mar 2013 13:56:07 +0200
Message-Id: <1362916568-9650-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1362916568-9650-1-git-send-email-tomas.winkler@intel.com>
References: <1362916568-9650-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes failure during initialization on Lynx Point LP devices.

ME driver needs to release the device from the reset
only after the FW has completed its flow and indicated
it by delivering an interrupt to the host.

This is the correct behavior for all the ME devices yet the
the previous versions are less susceptive to the implementation
that ignored FW reset completion indication.

We add mei_me_hw_reset_release function which is called
after reset from the interrupt thread or directly
from mei_reset during power down.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 45ea718..642c622 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -152,6 +152,20 @@ static void mei_me_intr_disable(struct mei_device *dev)
 }
 
 /**
+ * mei_me_hw_reset_release - release device from the reset
+ *
+ * @dev: the device structure
+ */
+static void mei_me_hw_reset_release(struct mei_device *dev)
+{
+	struct mei_me_hw *hw = to_me_hw(dev);
+	u32 hcsr = mei_hcsr_read(hw);
+
+	hcsr |= H_IG;
+	hcsr &= ~H_RST;
+	mei_hcsr_set(hw, hcsr);
+}
+/**
  * mei_me_hw_reset - resets fw via mei csr register.
  *
  * @dev: the device structure
@@ -169,18 +183,14 @@ static void mei_me_hw_reset(struct mei_device *dev, bool intr_enable)
 	if (intr_enable)
 		hcsr |= H_IE;
 	else
-		hcsr &= ~H_IE;
-
-	mei_hcsr_set(hw, hcsr);
-
-	hcsr = mei_hcsr_read(hw) | H_IG;
-	hcsr &= ~H_RST;
+		hcsr |= ~H_IE;
 
 	mei_hcsr_set(hw, hcsr);
 
-	hcsr = mei_hcsr_read(hw);
+	if (dev->dev_state == MEI_DEV_POWER_DOWN)
+		mei_me_hw_reset_release(dev);
 
-	dev_dbg(&dev->pdev->dev, "current HCSR = 0x%08x.\n", hcsr);
+	dev_dbg(&dev->pdev->dev, "current HCSR = 0x%08x.\n", mei_hcsr_read(hw));
 }
 
 /**
@@ -466,7 +476,8 @@ irqreturn_t mei_me_irq_thread_handler(int irq, void *dev_id)
 			mutex_unlock(&dev->device_lock);
 			return IRQ_HANDLED;
 		} else {
-			dev_dbg(&dev->pdev->dev, "FW not ready.\n");
+			dev_dbg(&dev->pdev->dev, "Reset Completed.\n");
+			mei_me_hw_reset_release(dev);
 			mutex_unlock(&dev->device_lock);
 			return IRQ_HANDLED;
 		}
-- 
1.8.1.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab3HBRjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 13:39:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:10958 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350Ab3HBRgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 13:36:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,802,1367996400"; 
   d="scan'208";a="375273110"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 06/15] NTB: BWD Link Recovery
Date: Fri,  2 Aug 2013 10:35:35 -0700
Message-Id: <1375464944-27914-7-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375464944-27914-1-git-send-email-jon.mason@intel.com>
References: <1375464944-27914-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BWD NTB device will drop the link if an error is encountered on the
point-to-point PCI bridge.  The link will stay down until all errors are
cleared and the link is re-established.  On link down, check to see if
the error is detected, if so do the necessary housekeeping to try and
recover from the error and reestablish the link.

There is a potential race between the 2 NTB devices recovering at the
same time.  If the times are synchronized, the link will not recover and the
driver will be stuck in this loop forever.  Add a random interval to the
recovery time to prevent this race.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_hw.c   |  110 ++++++++++++++++++++++++++++++++++++++++++++++--
 drivers/ntb/ntb_hw.h   |    5 +++
 drivers/ntb/ntb_regs.h |   15 +++++++
 3 files changed, 127 insertions(+), 3 deletions(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index 674bc09..d259d41 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -46,10 +46,12 @@
  * Jon Mason <jon.mason@intel.com>
  */
 #include <linux/debugfs.h>
+#include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/random.h>
 #include <linux/slab.h>
 #include "ntb_hw.h"
 #include "ntb_regs.h"
@@ -84,6 +86,8 @@ enum {
 
 struct dentry *debugfs_dir;
 
+#define BWD_LINK_RECOVERY_TIME	500
+
 /* Translate memory window 0,1 to BAR 2,4 */
 #define MW_TO_BAR(mw)	(mw * NTB_MAX_NUM_MW + 2)
 
@@ -425,6 +429,49 @@ void ntb_ring_sdb(struct ntb_device *ndev, unsigned int db)
 		       (db * ndev->bits_per_vector), ndev->reg_ofs.sdb);
 }
 
+static void bwd_recover_link(struct ntb_device *ndev)
+{
+	u32 status;
+
+	/* Driver resets the NTB ModPhy lanes - magic! */
+	writeb(0xe0, ndev->reg_base + BWD_MODPHY_PCSREG6);
+	writeb(0x40, ndev->reg_base + BWD_MODPHY_PCSREG4);
+	writeb(0x60, ndev->reg_base + BWD_MODPHY_PCSREG4);
+	writeb(0x60, ndev->reg_base + BWD_MODPHY_PCSREG6);
+
+	/* Driver waits 100ms to allow the NTB ModPhy to settle */
+	msleep(100);
+
+	/* Clear AER Errors, write to clear */
+	status = readl(ndev->reg_base + BWD_ERRCORSTS_OFFSET);
+	dev_dbg(&ndev->pdev->dev, "ERRCORSTS = %x\n", status);
+	status &= PCI_ERR_COR_REP_ROLL;
+	writel(status, ndev->reg_base + BWD_ERRCORSTS_OFFSET);
+
+	/* Clear unexpected electrical idle event in LTSSM, write to clear */
+	status = readl(ndev->reg_base + BWD_LTSSMERRSTS0_OFFSET);
+	dev_dbg(&ndev->pdev->dev, "LTSSMERRSTS0 = %x\n", status);
+	status |= BWD_LTSSMERRSTS0_UNEXPECTEDEI;
+	writel(status, ndev->reg_base + BWD_LTSSMERRSTS0_OFFSET);
+
+	/* Clear DeSkew Buffer error, write to clear */
+	status = readl(ndev->reg_base + BWD_DESKEWSTS_OFFSET);
+	dev_dbg(&ndev->pdev->dev, "DESKEWSTS = %x\n", status);
+	status |= BWD_DESKEWSTS_DBERR;
+	writel(status, ndev->reg_base + BWD_DESKEWSTS_OFFSET);
+
+	status = readl(ndev->reg_base + BWD_IBSTERRRCRVSTS0_OFFSET);
+	dev_dbg(&ndev->pdev->dev, "IBSTERRRCRVSTS0 = %x\n", status);
+	status &= BWD_IBIST_ERR_OFLOW;
+	writel(status, ndev->reg_base + BWD_IBSTERRRCRVSTS0_OFFSET);
+
+	/* Releases the NTB state machine to allow the link to retrain */
+	status = readl(ndev->reg_base + BWD_LTSSMSTATEJMP_OFFSET);
+	dev_dbg(&ndev->pdev->dev, "LTSSMSTATEJMP = %x\n", status);
+	status &= ~BWD_LTSSMSTATEJMP_FORCEDETECT;
+	writel(status, ndev->reg_base + BWD_LTSSMSTATEJMP_OFFSET);
+}
+
 static void ntb_link_event(struct ntb_device *ndev, int link_state)
 {
 	unsigned int event;
@@ -448,13 +495,16 @@ static void ntb_link_event(struct ntb_device *ndev, int link_state)
 			if (rc)
 				return;
 		}
+
+		ndev->link_width = (status & NTB_LINK_WIDTH_MASK) >> 4;
+		ndev->link_speed = (status & NTB_LINK_SPEED_MASK);
 		dev_info(&ndev->pdev->dev, "Link Width %d, Link Speed %d\n",
-			 (status & NTB_LINK_WIDTH_MASK) >> 4,
-			 (status & NTB_LINK_SPEED_MASK));
+			 ndev->link_width, ndev->link_speed);
 	} else {
 		dev_info(&ndev->pdev->dev, "Link Down\n");
 		ndev->link_status = NTB_LINK_DOWN;
 		event = NTB_EVENT_HW_LINK_DOWN;
+		/* Don't modify link width/speed, we need it in link recovery */
 	}
 
 	/* notify the upper layer if we have an event change */
@@ -494,6 +544,47 @@ static int ntb_link_status(struct ntb_device *ndev)
 	return 0;
 }
 
+static void bwd_link_recovery(struct work_struct *work)
+{
+	struct ntb_device *ndev = container_of(work, struct ntb_device,
+					       lr_timer.work);
+	u32 status32;
+
+	bwd_recover_link(ndev);
+	/* There is a potential race between the 2 NTB devices recovering at the
+	 * same time.  If the times are the same, the link will not recover and
+	 * the driver will be stuck in this loop forever.  Add a random interval
+	 * to the recovery time to prevent this race.
+	 */
+	msleep(BWD_LINK_RECOVERY_TIME + prandom_u32() % BWD_LINK_RECOVERY_TIME);
+
+	status32 = readl(ndev->reg_base + BWD_LTSSMSTATEJMP_OFFSET);
+	if (status32 & BWD_LTSSMSTATEJMP_FORCEDETECT)
+		goto retry;
+
+	status32 = readl(ndev->reg_base + BWD_IBSTERRRCRVSTS0_OFFSET);
+	if (status32 & BWD_IBIST_ERR_OFLOW)
+		goto retry;
+
+	status32 = readl(ndev->reg_ofs.lnk_cntl);
+	if (!(status32 & BWD_CNTL_LINK_DOWN)) {
+		unsigned char speed, width;
+		u16 status16;
+
+		status16 = readw(ndev->reg_ofs.lnk_stat);
+		width = (status16 & NTB_LINK_WIDTH_MASK) >> 4;
+		speed = (status16 & NTB_LINK_SPEED_MASK);
+		if (ndev->link_width != width || ndev->link_speed != speed)
+			goto retry;
+	}
+
+	schedule_delayed_work(&ndev->hb_timer, NTB_HB_TIMEOUT);
+	return;
+
+retry:
+	schedule_delayed_work(&ndev->lr_timer, NTB_HB_TIMEOUT);
+}
+
 /* BWD doesn't have link status interrupt, poll on that platform */
 static void bwd_link_poll(struct work_struct *work)
 {
@@ -509,6 +600,16 @@ static void bwd_link_poll(struct work_struct *work)
 		if (rc)
 			dev_err(&ndev->pdev->dev,
 				"Error determining link status\n");
+
+		/* Check to see if a link error is the cause of the link down */
+		if (ndev->link_status == NTB_LINK_DOWN) {
+			u32 status32 = readl(ndev->reg_base +
+					     BWD_LTSSMSTATEJMP_OFFSET);
+			if (status32 & BWD_LTSSMSTATEJMP_FORCEDETECT) {
+				schedule_delayed_work(&ndev->lr_timer, 0);
+				return;
+			}
+		}
 	}
 
 	schedule_delayed_work(&ndev->hb_timer, NTB_HB_TIMEOUT);
@@ -693,6 +794,7 @@ static int ntb_bwd_setup(struct ntb_device *ndev)
 
 	/* Since bwd doesn't have a link interrupt, setup a poll timer */
 	INIT_DELAYED_WORK(&ndev->hb_timer, bwd_link_poll);
+	INIT_DELAYED_WORK(&ndev->lr_timer, bwd_link_recovery);
 	schedule_delayed_work(&ndev->hb_timer, NTB_HB_TIMEOUT);
 
 	return 0;
@@ -733,8 +835,10 @@ static int ntb_device_setup(struct ntb_device *ndev)
 
 static void ntb_device_free(struct ntb_device *ndev)
 {
-	if (ndev->hw_type == BWD_HW)
+	if (ndev->hw_type == BWD_HW) {
 		cancel_delayed_work_sync(&ndev->hb_timer);
+		cancel_delayed_work_sync(&ndev->lr_timer);
+	}
 }
 
 static irqreturn_t bwd_callback_msix_irq(int irq, void *data)
diff --git a/drivers/ntb/ntb_hw.h b/drivers/ntb/ntb_hw.h
index 72fcb22..3a15d49 100644
--- a/drivers/ntb/ntb_hw.h
+++ b/drivers/ntb/ntb_hw.h
@@ -125,10 +125,15 @@ struct ntb_device {
 	unsigned char num_msix;
 	unsigned char bits_per_vector;
 	unsigned char max_cbs;
+	unsigned char link_width;
+	unsigned char link_speed;
 	unsigned char link_status;
+
 	struct delayed_work hb_timer;
 	unsigned long last_ts;
 
+	struct delayed_work lr_timer;
+
 	struct dentry *debugfs_dir;
 };
 
diff --git a/drivers/ntb/ntb_regs.h b/drivers/ntb/ntb_regs.h
index 4fe135a..8f3f903 100644
--- a/drivers/ntb/ntb_regs.h
+++ b/drivers/ntb/ntb_regs.h
@@ -114,6 +114,7 @@
 #define BWD_MBAR45_OFFSET	0xb020
 #define BWD_DEVCTRL_OFFSET	0xb048
 #define BWD_LINK_STATUS_OFFSET	0xb052
+#define BWD_ERRCORSTS_OFFSET	0xb110
 
 #define BWD_SBAR2XLAT_OFFSET	0x0008
 #define BWD_SBAR4XLAT_OFFSET	0x0010
@@ -131,6 +132,20 @@
 #define BWD_B2B_SPADSEMA_OFFSET	0x80c0
 #define BWD_B2B_STKYSPAD_OFFSET	0x80c4
 
+#define BWD_MODPHY_PCSREG4	0x1c004
+#define BWD_MODPHY_PCSREG6	0x1c006
+
+#define BWD_IP_BASE		0xC000
+#define BWD_DESKEWSTS_OFFSET	(BWD_IP_BASE + 0x3024)
+#define BWD_LTSSMERRSTS0_OFFSET (BWD_IP_BASE + 0x3180)
+#define BWD_LTSSMSTATEJMP_OFFSET	(BWD_IP_BASE + 0x3040)
+#define BWD_IBSTERRRCRVSTS0_OFFSET	(BWD_IP_BASE + 0x3324)
+
+#define BWD_DESKEWSTS_DBERR	(1 << 15)
+#define BWD_LTSSMERRSTS0_UNEXPECTEDEI	(1 << 20)
+#define BWD_LTSSMSTATEJMP_FORCEDETECT	(1 << 2)
+#define BWD_IBIST_ERR_OFLOW	0x7FFF7FFF
+
 #define NTB_CNTL_BAR23_SNOOP	(1 << 2)
 #define NTB_CNTL_BAR45_SNOOP	(1 << 6)
 #define BWD_CNTL_LINK_DOWN	(1 << 16)
-- 
1.7.9.5


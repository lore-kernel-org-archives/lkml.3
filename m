Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab3A2HW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 02:22:58 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:33766 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab3A2HVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 02:21:48 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID r0T7Lbuw004026
From: <wei_wang@realsil.com.cn>
To: <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <rogerable@realtek.com>, Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH 6/6] MFD:rtsx: Optimize card detect flow
Date: Tue, 29 Jan 2013 15:21:37 +0800
Message-ID: <cd40ddce56e51d6e9dcadce00bd95bf3d276401c.1359443488.git.wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1359443487.git.wei_wang@realsil.com.cn>
References: <cover.1359443487.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

1. Schedule card detect work at the end of ISR
2. Callback function ops->cd_deglitch may delay for a period of time.
It is not proper to call this callback when local irq disabled
3. Card detect flow can't be exectued in parallel with other card reader
operations, so it's better to be protected by mutex

Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
---
 drivers/mfd/rtsx_pcr.c |   31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index 67bb34e..9016932 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -752,7 +752,7 @@ static void rtsx_pci_card_detect(struct work_struct *work)
 	struct delayed_work *dwork;
 	struct rtsx_pcr *pcr;
 	unsigned long flags;
-	unsigned int card_detect = 0;
+	unsigned int card_detect = 0, card_inserted, card_removed;
 	u32 irq_status;
 
 	dwork = to_delayed_work(work);
@@ -760,25 +760,32 @@ static void rtsx_pci_card_detect(struct work_struct *work)
 
 	dev_dbg(&(pcr->pci->dev), "--> %s\n", __func__);
 
+	mutex_lock(&pcr->pcr_mutex);
 	spin_lock_irqsave(&pcr->lock, flags);
 
 	irq_status = rtsx_pci_readl(pcr, RTSX_BIPR);
 	dev_dbg(&(pcr->pci->dev), "irq_status: 0x%08x\n", irq_status);
 
-	if (pcr->card_inserted || pcr->card_removed) {
+	irq_status &= CARD_EXIST;
+	card_inserted = pcr->card_inserted & irq_status;
+	card_removed = pcr->card_removed;
+	pcr->card_inserted = 0;
+	pcr->card_removed = 0;
+
+	spin_unlock_irqrestore(&pcr->lock, flags);
+
+	if (card_inserted || card_removed) {
 		dev_dbg(&(pcr->pci->dev),
 				"card_inserted: 0x%x, card_removed: 0x%x\n",
-				pcr->card_inserted, pcr->card_removed);
+				card_inserted, card_removed);
 
 		if (pcr->ops->cd_deglitch)
-			pcr->card_inserted = pcr->ops->cd_deglitch(pcr);
+			card_inserted = pcr->ops->cd_deglitch(pcr);
 
-		card_detect = pcr->card_inserted | pcr->card_removed;
-		pcr->card_inserted = 0;
-		pcr->card_removed = 0;
+		card_detect = card_inserted | card_removed;
 	}
 
-	spin_unlock_irqrestore(&pcr->lock, flags);
+	mutex_unlock(&pcr->pcr_mutex);
 
 	if ((card_detect & SD_EXIST) && pcr->slots[RTSX_SD_CARD].card_event)
 		pcr->slots[RTSX_SD_CARD].card_event(
@@ -830,10 +837,6 @@ static irqreturn_t rtsx_pci_isr(int irq, void *dev_id)
 		}
 	}
 
-	if (pcr->card_inserted || pcr->card_removed)
-		schedule_delayed_work(&pcr->carddet_work,
-				msecs_to_jiffies(200));
-
 	if (int_reg & (NEED_COMPLETE_INT | DELINK_INT)) {
 		if (int_reg & (TRANS_FAIL_INT | DELINK_INT)) {
 			pcr->trans_result = TRANS_RESULT_FAIL;
@@ -846,6 +849,10 @@ static irqreturn_t rtsx_pci_isr(int irq, void *dev_id)
 		}
 	}
 
+	if (pcr->card_inserted || pcr->card_removed)
+		schedule_delayed_work(&pcr->carddet_work,
+				msecs_to_jiffies(200));
+
 	spin_unlock(&pcr->lock);
 	return IRQ_HANDLED;
 }
-- 
1.7.9.5


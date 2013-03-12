Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933757Ab3CLWlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:41:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60382 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076Ab3CLWd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:33:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wei WANG <wei_wang@realsil.com.cn>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Tim Gardner <rtg.canonical@gmail.com>
Subject: [ 079/100] mfd: rtsx: Optimize card detect flow
Date: Tue, 12 Mar 2013 15:32:04 -0700
Message-Id: <20130312223131.419492516@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei WANG <wei_wang@realsil.com.cn>

commit 504decc0a063e6a09a1e5b203ca68bc21dfffde9 upstream.

1. Schedule card detect work at the end of the ISR
2. Callback function ops->cd_deglitch may delay for a period of time.
It is not proper to call this callback when local irq disabled.
3. Card detect flow can't be executed in parallel with other card reader
operations, so it's better to be protected by mutex.

Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Cc: Tim Gardner <rtg.canonical@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/rtsx_pcr.c |   31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -758,7 +758,7 @@ static void rtsx_pci_card_detect(struct
 	struct delayed_work *dwork;
 	struct rtsx_pcr *pcr;
 	unsigned long flags;
-	unsigned int card_detect = 0;
+	unsigned int card_detect = 0, card_inserted, card_removed;
 	u32 irq_status;
 
 	dwork = to_delayed_work(work);
@@ -766,25 +766,32 @@ static void rtsx_pci_card_detect(struct
 
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
@@ -836,10 +843,6 @@ static irqreturn_t rtsx_pci_isr(int irq,
 		}
 	}
 
-	if (pcr->card_inserted || pcr->card_removed)
-		schedule_delayed_work(&pcr->carddet_work,
-				msecs_to_jiffies(200));
-
 	if (int_reg & (NEED_COMPLETE_INT | DELINK_INT)) {
 		if (int_reg & (TRANS_FAIL_INT | DELINK_INT)) {
 			pcr->trans_result = TRANS_RESULT_FAIL;
@@ -852,6 +855,10 @@ static irqreturn_t rtsx_pci_isr(int irq,
 		}
 	}
 
+	if (pcr->card_inserted || pcr->card_removed)
+		schedule_delayed_work(&pcr->carddet_work,
+				msecs_to_jiffies(200));
+
 	spin_unlock(&pcr->lock);
 	return IRQ_HANDLED;
 }



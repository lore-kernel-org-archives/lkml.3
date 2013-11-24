Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab3KXXgs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 18:36:48 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:38870 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab3KXXgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 18:36:46 -0500
Date: Sun, 24 Nov 2013 17:36:35 -0600
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com
Subject: [PATCH 1/1] rsxx: Reset the pcie slot of adapter trains incorrectly.
Message-ID: <20131124233635.GA1428@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112423-9332-0000-0000-0000024770A2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

This patch contains a software workaround for a firmware bug that
can cause the pcie adapter to train to a width below the desired
width of x8.

It will reset the adapter 3 times before the driver gives up and
informs the user that the link width has been trained to something
unexpected.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>



diff --git a/drivers/block/rsxx/core.c b/drivers/block/rsxx/core.c
index a8de2ee..d15b678 100644
--- a/drivers/block/rsxx/core.c
+++ b/drivers/block/rsxx/core.c
@@ -42,6 +42,8 @@
 
 #define NO_LEGACY 0
 #define SYNC_START_TIMEOUT (10 * 60) /* 10 minutes */
+#define EXPECTED_LINK_WIDTH 8
+#define MAX_RETRAIN_CNT     3
 
 MODULE_DESCRIPTION("IBM Flash Adapter 900GB Full Height Device Driver");
 MODULE_AUTHOR("Joshua Morris/Philip Kelleher, IBM");
@@ -600,6 +602,50 @@ static int card_shutdown(struct rsxx_cardinfo *card)
 	return 0;
 }
 
+static void rsxx_reset_slot(struct rsxx_cardinfo *card)
+{
+	if (card->retrain_cnt >= MAX_RETRAIN_CNT) {
+		dev_warn(CARD_TO_DEV(card), "Failed to train the adapter to x%d "
+					    "(is x%d), performance degradation "
+					    "possible", EXPECTED_LINK_WIDTH,
+					    card->link_width);
+		return;
+	}
+
+	pci_cfg_access_lock(card->dev);
+	pci_set_pcie_reset_state(card->dev, pcie_warm_reset);
+	msleep(500);
+	pci_set_pcie_reset_state(card->dev, pcie_deassert_reset);
+	msleep(2000);
+	pci_cfg_access_unlock(card->dev);
+
+}
+
+static void rsxx_verify_link_width(struct rsxx_cardinfo *card)
+{
+	int pos;
+	u16 reg16;
+
+	card->retrain_cnt = 0;
+
+	do {
+		pos = pci_find_capability(card->dev, PCI_CAP_ID_EXP);
+		pci_read_config_word(card->dev,
+				     pos + PCI_EXP_LNKSTA,
+				     &reg16);
+		card->link_width = (reg16 & PCI_EXP_LNKSTA_NLW) >> 4;
+
+		if (card->link_width != EXPECTED_LINK_WIDTH) {
+			card->retrain_cnt++;
+			rsxx_reset_slot(card);
+		} else {
+			pci_restore_state(card->dev);
+			break;
+		}
+
+	} while (card->retrain_cnt < MAX_RETRAIN_CNT);
+}
+
 static int rsxx_eeh_frozen(struct pci_dev *dev)
 {
 	struct rsxx_cardinfo *card = pci_get_drvdata(dev);
@@ -723,6 +769,8 @@ static pci_ers_result_t rsxx_slot_reset(struct pci_dev *dev)
 	dev_warn(&dev->dev,
 		"IBM Flash Adapter PCI: recovering from slot reset.\n");
 
+	rsxx_verify_link_width(card);
+
 	st = pci_enable_device(dev);
 	if (st)
 		goto failed_hw_setup;
@@ -837,6 +885,14 @@ static int rsxx_pci_probe(struct pci_dev *dev,
 	if (st)
 		goto failed_ida_get;
 
+	st = pci_save_state(dev);
+	if (st) {
+		dev_err(CARD_TO_DEV(card), "Failed to save PCI config space\n");
+		goto failed_enable;
+	}
+
+	rsxx_verify_link_width(card);
+
 	st = pci_enable_device(dev);
 	if (st)
 		goto failed_enable;
diff --git a/drivers/block/rsxx/rsxx_priv.h b/drivers/block/rsxx/rsxx_priv.h
index 6bbc64d..348dbbb 100644
--- a/drivers/block/rsxx/rsxx_priv.h
+++ b/drivers/block/rsxx/rsxx_priv.h
@@ -52,7 +52,7 @@ struct proc_cmd;
 #define RS70_PCI_REV_SUPPORTED	4
 
 #define DRIVER_NAME "rsxx"
-#define DRIVER_VERSION "4.0.3.2516"
+#define DRIVER_VERSION "4.0.4"
 
 /* Block size is 4096 */
 #define RSXX_HW_BLK_SHIFT		12
@@ -122,6 +122,8 @@ struct rsxx_cardinfo {
 	struct pci_dev		*dev;
 	unsigned int		halt;
 	unsigned int		eeh_state;
+	unsigned short		link_width;
+	unsigned int		retrain_cnt;
 
 	void			__iomem *regmap;
 	spinlock_t		irq_lock;


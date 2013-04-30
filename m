Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933674Ab3D3T4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 15:56:36 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:36289 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932735Ab3D3T4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 15:56:33 -0400
Date: Tue, 30 Apr 2013 14:56:15 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, klebers@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com
Subject: [PATCH 5/9] rsxx: Adding in sync_start module paramenter.
Message-ID: <20130430195615.GB14601@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13043019-9360-0000-0000-000011F7CA89
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

Adding a module parameter called 'sync_start' to wait for
the card to fully up and running before driver load is
complete.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------


diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/core.c linux-block/drivers/block/rsxx/core.c
--- linux-block-vanilla/drivers/block/rsxx/core.c	2013-04-30 11:23:04.238259534 -0500
+++ linux-block/drivers/block/rsxx/core.c	2013-04-30 11:21:50.717187878 -0500
@@ -39,6 +39,8 @@
 #include "rsxx_cfg.h"
 
 #define NO_LEGACY 0
+#define NO_SYNC_START 0
+#define SYNC_START_TIMEOUT (10 * 60) /* 10 minutes */
 
 MODULE_DESCRIPTION("IBM FlashSystem 70/80 PCIe SSD Device Driver");
 MODULE_AUTHOR("Joshua Morris/Philip Kelleher, IBM");
@@ -49,6 +51,11 @@ static unsigned int force_legacy = NO_LE
 module_param(force_legacy, uint, 0444);
 MODULE_PARM_DESC(force_legacy, "Force the use of legacy type PCI interrupts");
 
+static unsigned int sync_start = NO_SYNC_START;
+module_param(sync_start, uint, 0444);
+MODULE_PARM_DESC(sync_start,
+	"Driver load will not complete until the card startup has completed.");
+
 static DEFINE_IDA(rsxx_disk_ida);
 static DEFINE_SPINLOCK(rsxx_ida_lock);
 
@@ -728,6 +735,7 @@ static int rsxx_pci_probe(struct pci_dev
 {
 	struct rsxx_cardinfo *card;
 	int st;
+	unsigned int sync_timeout;
 
 	dev_info(&dev->dev, "PCI-Flash SSD discovered\n");
 
@@ -900,6 +908,33 @@ static int rsxx_pci_probe(struct pci_dev
 		if (st)
 			dev_crit(CARD_TO_DEV(card),
 				"Failed issuing card startup\n");
+		if (sync_start) {
+			sync_timeout = SYNC_START_TIMEOUT;
+
+			dev_info(CARD_TO_DEV(card),
+				 "Waiting for card to startup\n");
+
+			do {
+				ssleep(1);
+				sync_timeout--;
+
+				rsxx_get_card_state(card, &card->state);
+			} while (sync_timeout &&
+				(card->state == CARD_STATE_STARTING));
+
+			if (card->state == CARD_STATE_STARTING) {
+				dev_warn(CARD_TO_DEV(card),
+					 "Card startup timed out\n");
+				card->size8 = 0;
+			} else {
+				dev_info(CARD_TO_DEV(card),
+					 "card state: %s\n",
+					 rsxx_card_state_to_str(card->state));
+				st = rsxx_get_card_size8(card, &card->size8);
+				if (st)
+					card->size8 = 0;
+			}
+		}
 	} else if (card->state == CARD_STATE_GOOD ||
 		   card->state == CARD_STATE_RD_ONLY_FAULT) {
 		st = rsxx_get_card_size8(card, &card->size8);


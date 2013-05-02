Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab3EBA3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 20:29:12 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:54810 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab3EBA3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 20:29:10 -0400
Date: Wed, 1 May 2013 19:29:03 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, klebers@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com
Subject: [PATCH 5/8] rsxx: Adding in sync_start module paramenter.
Message-ID: <20130502002903.GA2435@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050200-5518-0000-0000-00000E330B85
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
--- linux-block-vanilla/drivers/block/rsxx/core.c	2013-05-01 18:36:44.683234070 -0500
+++ linux-block/drivers/block/rsxx/core.c	2013-05-01 18:40:57.738183991 -0500
@@ -41,6 +41,8 @@
 #include "rsxx_cfg.h"
 
 #define NO_LEGACY 0
+#define NO_SYNC_START 0
+#define SYNC_START_TIMEOUT (10 * 60) /* 10 minutes */
 #define DEBUGFS_NULL NULL
 
 MODULE_DESCRIPTION("IBM FlashSystem 70/80 PCIe SSD Device Driver");
@@ -52,6 +54,11 @@ static unsigned int force_legacy = NO_LE
 module_param(force_legacy, uint, 0444);
 MODULE_PARM_DESC(force_legacy, "Force the use of legacy type PCI interrupts");
 
+static unsigned int sync_start = NO_SYNC_START;
+module_param(sync_start, uint, 0444);
+MODULE_PARM_DESC(sync_start,
+	"Driver load will not complete until the card startup has completed.");
+
 static DEFINE_IDA(rsxx_disk_ida);
 static DEFINE_SPINLOCK(rsxx_ida_lock);
 
@@ -717,6 +724,7 @@ static int rsxx_pci_probe(struct pci_dev
 {
 	struct rsxx_cardinfo *card;
 	int st;
+	unsigned int sync_timeout;
 
 	dev_info(&dev->dev, "PCI-Flash SSD discovered\n");
 
@@ -875,6 +883,33 @@ static int rsxx_pci_probe(struct pci_dev
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


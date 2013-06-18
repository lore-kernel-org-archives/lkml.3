Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082Ab3FRTmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 15:42:51 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38445 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab3FRTmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 15:42:50 -0400
Date: Tue, 18 Jun 2013 14:42:36 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com
Subject: [PATCH 5/11] rsxx: Adding in sync_start module paramenter.
Message-ID: <20130618194235.GF6492@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061819-7182-0000-0000-0000076437A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

Before, the partition table would have to be reread because our
card was attached before it transistioned out of it's 'starting'
state.

This change will cause the driver to wait to attach the device
until the adapter is ready.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------



diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/core.c linux-block/drivers/block/rsxx/core.c
--- linux-block-vanilla/drivers/block/rsxx/core.c	2013-06-17 16:53:06.790030813 -0500
+++ linux-block/drivers/block/rsxx/core.c	2013-06-17 17:25:48.811853040 -0500
@@ -39,6 +39,7 @@
 #include "rsxx_cfg.h"
 
 #define NO_LEGACY 0
+#define SYNC_START_TIMEOUT (10 * 60) /* 10 minutes */
 
 MODULE_DESCRIPTION("IBM FlashSystem 70/80 PCIe SSD Device Driver");
 MODULE_AUTHOR("Joshua Morris/Philip Kelleher, IBM");
@@ -49,6 +50,11 @@ static unsigned int force_legacy = NO_LE
 module_param(force_legacy, uint, 0444);
 MODULE_PARM_DESC(force_legacy, "Force the use of legacy type PCI interrupts");
 
+static unsigned int sync_start = 1;
+module_param(sync_start, uint, 0444);
+MODULE_PARM_DESC(sync_start, "On by Default: Driver load will not complete "
+			     "until the card startup has completed.");
+
 static DEFINE_IDA(rsxx_disk_ida);
 static DEFINE_SPINLOCK(rsxx_ida_lock);
 
@@ -540,6 +546,7 @@ static int rsxx_pci_probe(struct pci_dev
 {
 	struct rsxx_cardinfo *card;
 	int st;
+	unsigned int sync_timeout;
 
 	dev_info(&dev->dev, "PCI-Flash SSD discovered\n");
 
@@ -698,6 +705,33 @@ static int rsxx_pci_probe(struct pci_dev
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
+					"card state: %s\n",
+					rsxx_card_state_to_str(card->state));
+				st = rsxx_get_card_size8(card, &card->size8);
+				if (st)
+					card->size8 = 0;
+			}
+		}
 	} else if (card->state == CARD_STATE_GOOD ||
 		   card->state == CARD_STATE_RD_ONLY_FAULT) {
 		st = rsxx_get_card_size8(card, &card->size8);


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab3FAAgq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 20:36:46 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:35556 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab3FAAgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 20:36:40 -0400
Date: Fri, 31 May 2013 19:36:35 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] rsxx: Adding in sync_start module paramenter.
Message-ID: <20130601003635.GI3051@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060100-5518-0000-0000-00000F3CEC02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

Before the partition table would have to be reread because our
card was attached before it transistioned out of it's 'starting'
state.

This change will wait until the card has transitioned from it's
'starting' state before it will attach the device. This way there
is no need to manually reread the partition table.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------


diff -uprN -X linux-block/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/core.c linux-block/drivers/block/rsxx/core.c
--- linux-block-vanilla/drivers/block/rsxx/core.c	2013-05-31 17:50:37.427340286 -0500
+++ linux-block/drivers/block/rsxx/core.c	2013-05-31 18:03:22.421016950 -0500
@@ -41,6 +41,7 @@
 #include "rsxx_cfg.h"
 
 #define NO_LEGACY 0
+#define SYNC_START_TIMEOUT (10 * 60) /* 10 minutes */
 
 MODULE_DESCRIPTION("IBM FlashSystem 70/80 PCIe SSD Device Driver");
 MODULE_AUTHOR("Joshua Morris/Philip Kelleher, IBM");
@@ -51,6 +52,11 @@ static unsigned int force_legacy = NO_LE
 module_param(force_legacy, uint, 0444);
 MODULE_PARM_DESC(force_legacy, "Force the use of legacy type PCI interrupts");
 
+static unsigned int sync_start = 1;
+module_param(sync_start, uint, 0444);
+MODULE_PARM_DESC(sync_start, "On by Default: Driver load will not complete "
+			     "until the card startup has completed.");
+
 static DEFINE_IDA(rsxx_disk_ida);
 static DEFINE_SPINLOCK(rsxx_ida_lock);
 
@@ -704,6 +710,7 @@ static int rsxx_pci_probe(struct pci_dev
 {
 	struct rsxx_cardinfo *card;
 	int st;
+	unsigned int sync_timeout;
 
 	dev_info(&dev->dev, "PCI-Flash SSD discovered\n");
 
@@ -862,6 +869,33 @@ static int rsxx_pci_probe(struct pci_dev
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab3FRTkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 15:40:46 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:55019 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322Ab3FRTkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 15:40:45 -0400
Date: Tue, 18 Jun 2013 14:39:44 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com
Subject: [PATCH 4/11] rsxx: Allow block size to be determined by
 configuration.
Message-ID: <20130618193944.GE6492@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061819-3620-0000-0000-0000032D854F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

Previously, the block size was determined by whether or not
our Hardware could handle 512 byte accesses. Now, all of our
Hardware can handle 512 and 4096 block sizes.

This fix allows it to be user configurable.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------


diff -uprN -X linux-block/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/dev.c linux-block/drivers/block/rsxx/dev.c
--- linux-block-vanilla/drivers/block/rsxx/dev.c	2013-05-31 16:33:27.674030890 -0500
+++ linux-block/drivers/block/rsxx/dev.c	2013-05-31 17:22:48.214019619 -0500
@@ -227,24 +227,6 @@ static bool rsxx_discard_supported(struc
 	return (pci_rev >= RSXX_DISCARD_SUPPORT);
 }
 
-static unsigned short rsxx_get_logical_block_size(
-					struct rsxx_cardinfo *card)
-{
-	u32 capabilities = 0;
-	int st;
-
-	st = rsxx_get_card_capabilities(card, &capabilities);
-	if (st)
-		dev_warn(CARD_TO_DEV(card),
-			"Failed reading card capabilities register\n");
-
-	/* Earlier firmware did not have support for 512 byte accesses */
-	if (capabilities & CARD_CAP_SUBPAGE_WRITES)
-		return 512;
-	else
-		return RSXX_HW_BLK_SIZE;
-}
-
 int rsxx_attach_dev(struct rsxx_cardinfo *card)
 {
 	mutex_lock(&card->dev_lock);
@@ -307,7 +289,7 @@ int rsxx_setup_dev(struct rsxx_cardinfo 
 		return -ENOMEM;
 	}
 
-	blk_size = rsxx_get_logical_block_size(card);
+	blk_size = card->config.data.block_size;
 
 	blk_queue_make_request(card->queue, rsxx_make_request);
 	blk_queue_bounce_limit(card->queue, BLK_BOUNCE_ANY);


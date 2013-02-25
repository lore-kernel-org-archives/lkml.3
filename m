Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759533Ab3BYTYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 14:24:20 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:54620 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759216Ab3BYTYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 14:24:17 -0500
Date: Mon, 25 Feb 2013 13:09:40 -0600
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com,
        josh.h.morris@us.ibm.com
Subject: [PATCH 4/4] block: IBM RamSan 70/80 error message bug fix.
Message-ID: <20130225190940.GA10908@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022519-4834-0000-0000-00000410CB7D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

This patch includes a simple change to the rsxx_pci_remove
function that caused error messages because traffic was halted
too early.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------


diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/core.c linux-block/drivers/block/rsxx/core.c
--- linux-block-vanilla/drivers/block/rsxx/core.c	2013-02-25 11:23:39.077245757 -0600
+++ linux-block/drivers/block/rsxx/core.c	2013-02-25 11:24:39.446183327 -0600
@@ -538,9 +538,6 @@ static void rsxx_pci_remove(struct pci_d
 	rsxx_disable_ier_and_isr(card, CR_INTR_EVENT);
 	spin_unlock_irqrestore(&card->irq_lock, flags);
 
-	/* Prevent work_structs from re-queuing themselves. */
-	card->halt = 1;
-
 	cancel_work_sync(&card->event_work);
 
 	rsxx_destroy_dev(card);
@@ -549,6 +546,10 @@ static void rsxx_pci_remove(struct pci_d
 	spin_lock_irqsave(&card->irq_lock, flags);
 	rsxx_disable_ier_and_isr(card, CR_INTR_ALL);
 	spin_unlock_irqrestore(&card->irq_lock, flags);
+
+	/* Prevent work_structs from re-queuing themselves. */
+	card->halt = 1;
+
 	free_irq(dev->irq, card);
 
 	if (!force_legacy)


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759866Ab3CZQDW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:03:22 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:39922 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756018Ab3CZQDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 12:03:15 -0400
Date: Tue, 26 Mar 2013 11:03:07 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, klebers@linux.vnet.ibm.com
Subject: [PATCHv2 01/02] block: removes dynamic allocation on stack
Message-ID: <20130326160307.GD7136@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032616-7182-0000-0000-000005F3FE21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

Removing the dynamic allocation on the stack.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------
o Version 2 consists of the error checking that was foolishly left out.
o Added error checking to multiple functions to support the dynamically
  allocated list_head array.


diff -uprN -X linux-block/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/core.c linux-block/drivers/block/rsxx/core.c
--- linux-block-vanilla/drivers/block/rsxx/core.c	2013-03-26 09:56:33.508217353 -0500
+++ linux-block/drivers/block/rsxx/core.c	2013-03-26 10:00:21.211964584 -0500
@@ -323,10 +323,11 @@ static int card_shutdown(struct rsxx_car
 	return 0;
 }
 
-static void rsxx_eeh_frozen(struct pci_dev *dev)
+static int rsxx_eeh_frozen(struct pci_dev *dev)
 {
 	struct rsxx_cardinfo *card = pci_get_drvdata(dev);
 	int i;
+	int st;
 
 	dev_warn(&dev->dev, "IBM FlashSystem PCI: preparing for slot reset.\n");
 
@@ -342,7 +343,9 @@ static void rsxx_eeh_frozen(struct pci_d
 
 	pci_disable_device(dev);
 
-	rsxx_eeh_save_issued_dmas(card);
+	st = rsxx_eeh_save_issued_dmas(card);
+	if (st)
+		return st;
 
 	rsxx_eeh_save_issued_creg(card);
 
@@ -356,6 +359,8 @@ static void rsxx_eeh_frozen(struct pci_d
 					    card->ctrl[i].cmd.buf,
 					    card->ctrl[i].cmd.dma_addr);
 	}
+
+	return 0;
 }
 
 static void rsxx_eeh_failure(struct pci_dev *dev)
@@ -399,6 +404,8 @@ static int rsxx_eeh_fifo_flush_poll(stru
 static pci_ers_result_t rsxx_error_detected(struct pci_dev *dev,
 					    enum pci_channel_state error)
 {
+	int st;
+
 	if (dev->revision < RSXX_EEH_SUPPORT)
 		return PCI_ERS_RESULT_NONE;
 
@@ -407,7 +414,13 @@ static pci_ers_result_t rsxx_error_detec
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
-	rsxx_eeh_frozen(dev);
+	st = rsxx_eeh_frozen(dev);
+	if (st) {
+		dev_err(&dev->dev, "Slot reset setup failed\n");
+		rsxx_eeh_failure(dev);
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+
 	return PCI_ERS_RESULT_NEED_RESET;
 }
 
diff -uprN -X linux-block/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/dma.c linux-block/drivers/block/rsxx/dma.c
--- linux-block-vanilla/drivers/block/rsxx/dma.c	2013-03-26 09:57:10.071023932 -0500
+++ linux-block/drivers/block/rsxx/dma.c	2013-03-26 09:57:22.186976829 -0500
@@ -980,7 +980,7 @@ void rsxx_dma_destroy(struct rsxx_cardin
 	}
 }
 
-void rsxx_eeh_save_issued_dmas(struct rsxx_cardinfo *card)
+int rsxx_eeh_save_issued_dmas(struct rsxx_cardinfo *card)
 {
 	int i;
 	int j;
@@ -990,6 +990,8 @@ void rsxx_eeh_save_issued_dmas(struct rs
 
 	issued_dmas = kzalloc(sizeof(*issued_dmas) * card->n_targets,
 			      GFP_KERNEL);
+	if (!issued_dmas)
+		return -ENOMEM;
 
 	for (i = 0; i < card->n_targets; i++) {
 		INIT_LIST_HEAD(&issued_dmas[i]);
@@ -1030,6 +1032,8 @@ void rsxx_eeh_save_issued_dmas(struct rs
 	}
 
 	kfree(issued_dmas);
+
+	return 0;
 }
 
 void rsxx_eeh_cancel_dmas(struct rsxx_cardinfo *card)
diff -uprN -X linux-block/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/rsxx_priv.h linux-block/drivers/block/rsxx/rsxx_priv.h
--- linux-block-vanilla/drivers/block/rsxx/rsxx_priv.h	2013-03-26 09:56:33.531059843 -0500
+++ linux-block/drivers/block/rsxx/rsxx_priv.h	2013-03-26 09:57:22.192990813 -0500
@@ -381,7 +381,7 @@ int rsxx_dma_queue_bio(struct rsxx_cardi
 			   rsxx_dma_cb cb,
 			   void *cb_data);
 int rsxx_hw_buffers_init(struct pci_dev *dev, struct rsxx_dma_ctrl *ctrl);
-void rsxx_eeh_save_issued_dmas(struct rsxx_cardinfo *card);
+int rsxx_eeh_save_issued_dmas(struct rsxx_cardinfo *card);
 void rsxx_eeh_cancel_dmas(struct rsxx_cardinfo *card);
 int rsxx_eeh_remap_dmas(struct rsxx_cardinfo *card);
 


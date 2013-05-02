Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab3EBAZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 20:25:12 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60824 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790Ab3EBAZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 20:25:09 -0400
Date: Wed, 1 May 2013 19:25:03 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, klebers@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com
Subject: [PATCH 2/8] rsxx: Individual workqueues for interruptible events.
Message-ID: <20130502002502.GB29619@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050200-7182-0000-0000-0000067F692C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

Giving all interrupt based events their own workqueue to complete
tasks on.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------


diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/core.c linux-block/drivers/block/rsxx/core.c
--- linux-block-vanilla/drivers/block/rsxx/core.c	2013-05-01 18:23:31.055183203 -0500
+++ linux-block/drivers/block/rsxx/core.c	2013-05-01 18:29:26.666299304 -0500
@@ -351,12 +351,13 @@ static irqreturn_t rsxx_isr(int irq, voi
 		}
 
 		if (isr & CR_INTR_CREG) {
-			schedule_work(&card->creg_ctrl.done_work);
+			queue_work(card->creg_ctrl.creg_wq,
+				   &card->creg_ctrl.done_work);
 			handled++;
 		}
 
 		if (isr & CR_INTR_EVENT) {
-			schedule_work(&card->event_work);
+			queue_work(card->event_wq, &card->event_work);
 			rsxx_disable_ier_and_isr(card, CR_INTR_EVENT);
 			handled++;
 		}
@@ -798,7 +799,11 @@ static int rsxx_pci_probe(struct pci_dev
 	}
 
 	/************* Setup Processor Command Interface *************/
-	rsxx_creg_setup(card);
+	st = rsxx_creg_setup(card);
+	if (st) {
+		dev_err(CARD_TO_DEV(card), "Failed to setup creg interface.\n");
+		goto failed_creg_setup;
+	}
 
 	spin_lock_irq(&card->irq_lock);
 	rsxx_enable_ier_and_isr(card, CR_INTR_CREG);
@@ -838,6 +843,12 @@ static int rsxx_pci_probe(struct pci_dev
 	}
 
 	/************* Setup Card Event Handler *************/
+	card->event_wq = create_singlethread_workqueue(DRIVER_NAME"_event");
+	if (!card->event_wq) {
+		dev_err(CARD_TO_DEV(card), "Failed card event setup.\n");
+		goto failed_event_handler;
+	}
+
 	INIT_WORK(&card->event_work, card_event_handler);
 
 	st = rsxx_setup_dev(card);
@@ -880,9 +891,15 @@ static int rsxx_pci_probe(struct pci_dev
 	return 0;
 
 failed_create_dev:
+	destroy_workqueue(card->event_wq);
+	card->event_wq = NULL;
+failed_event_handler:
 	rsxx_dma_destroy(card);
 failed_dma_setup:
 failed_compatiblity_check:
+	destroy_workqueue(card->creg_ctrl.creg_wq);
+	card->creg_ctrl.creg_wq = NULL;
+failed_creg_setup:
 	spin_lock_irq(&card->irq_lock);
 	rsxx_disable_ier_and_isr(card, CR_INTR_ALL);
 	spin_unlock_irq(&card->irq_lock);
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/cregs.c linux-block/drivers/block/rsxx/cregs.c
--- linux-block-vanilla/drivers/block/rsxx/cregs.c	2013-05-01 11:35:38.631248826 -0500
+++ linux-block/drivers/block/rsxx/cregs.c	2013-05-01 18:30:55.076464661 -0500
@@ -727,6 +727,11 @@ int rsxx_creg_setup(struct rsxx_cardinfo
 {
 	card->creg_ctrl.active_cmd = NULL;
 
+	card->creg_ctrl.creg_wq =
+			create_singlethread_workqueue(DRIVER_NAME"_creg");
+	if (!card->creg_ctrl.creg_wq)
+		return -ENOMEM;
+
 	INIT_WORK(&card->creg_ctrl.done_work, creg_cmd_done);
 	mutex_init(&card->creg_ctrl.reset_lock);
 	INIT_LIST_HEAD(&card->creg_ctrl.queue);
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/rsxx_priv.h linux-block/drivers/block/rsxx/rsxx_priv.h
--- linux-block-vanilla/drivers/block/rsxx/rsxx_priv.h	2013-05-01 18:23:31.064623365 -0500
+++ linux-block/drivers/block/rsxx/rsxx_priv.h	2013-05-01 18:32:24.021184958 -0500
@@ -134,6 +134,7 @@ struct rsxx_cardinfo {
 		spinlock_t		lock;
 		bool			active;
 		struct creg_cmd		*active_cmd;
+		struct workqueue_struct	*creg_wq;
 		struct work_struct	done_work;
 		struct list_head	queue;
 		unsigned int		q_depth;
@@ -154,6 +155,7 @@ struct rsxx_cardinfo {
 		int buf_len;
 	} log;
 
+	struct workqueue_struct	*event_wq;
 	struct work_struct	event_work;
 	unsigned int		state;
 	u64			size8;


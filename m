Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759233Ab3BYSdM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 13:33:12 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:51287 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758907Ab3BYSdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 13:33:11 -0500
Date: Mon, 25 Feb 2013 12:31:31 -0600
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com,
        josh.h.morris@us.ibm.com
Subject: [PATCH 2/4] block: IBM RamSan 70/80 fixes inconsistent locking.
Message-ID: <20130225183131.GB7415@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022518-5806-0000-0000-000020137561
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

This patch includes changes to the cregs locking scheme. Before,
inconsistant locking would occur because of misuse of spin_lock,
spin_lock_bh, and counter parts.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------


diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/cregs.c linux-block/drivers/block/rsxx/cregs.c
--- linux-block-vanilla/drivers/block/rsxx/cregs.c	2013-02-25 12:06:55.435422297 -0600
+++ linux-block/drivers/block/rsxx/cregs.c	2013-02-25 12:08:06.783185190 -0600
@@ -99,22 +99,6 @@ static void copy_from_creg_data(struct r
 	}
 }
 
-static struct creg_cmd *pop_active_cmd(struct rsxx_cardinfo *card)
-{
-	struct creg_cmd *cmd;
-
-	/*
-	 * Spin lock is needed because this can be called in atomic/interrupt
-	 * context.
-	 */
-	spin_lock_bh(&card->creg_ctrl.lock);
-	cmd = card->creg_ctrl.active_cmd;
-	card->creg_ctrl.active_cmd = NULL;
-	spin_unlock_bh(&card->creg_ctrl.lock);
-
-	return cmd;
-}
-
 static void creg_issue_cmd(struct rsxx_cardinfo *card, struct creg_cmd *cmd)
 {
 	iowrite32(cmd->addr, card->regmap + CREG_ADD);
@@ -189,11 +173,11 @@ static int creg_queue_cmd(struct rsxx_ca
 	cmd->cb_private = cb_private;
 	cmd->status	= 0;
 
-	spin_lock(&card->creg_ctrl.lock);
+	spin_lock_bh(&card->creg_ctrl.lock);
 	list_add_tail(&cmd->list, &card->creg_ctrl.queue);
 	card->creg_ctrl.q_depth++;
 	creg_kick_queue(card);
-	spin_unlock(&card->creg_ctrl.lock);
+	spin_unlock_bh(&card->creg_ctrl.lock);
 
 	return 0;
 }
@@ -203,7 +187,11 @@ static void creg_cmd_timed_out(unsigned 
 	struct rsxx_cardinfo *card = (struct rsxx_cardinfo *) data;
 	struct creg_cmd *cmd;
 
-	cmd = pop_active_cmd(card);
+	spin_lock(&card->creg_ctrl.lock);
+	cmd = card->creg_ctrl.active_cmd;
+	card->creg_ctrl.active_cmd = NULL;
+	spin_unlock(&card->creg_ctrl.lock);
+
 	if (cmd == NULL) {
 		card->creg_ctrl.creg_stats.creg_timeout++;
 		dev_warn(CARD_TO_DEV(card),
@@ -240,7 +228,11 @@ static void creg_cmd_done(struct work_st
 	if (del_timer_sync(&card->creg_ctrl.cmd_timer) == 0)
 		card->creg_ctrl.creg_stats.failed_cancel_timer++;
 
-	cmd = pop_active_cmd(card);
+	spin_lock_bh(&card->creg_ctrl.lock);
+	cmd = card->creg_ctrl.active_cmd;
+	card->creg_ctrl.active_cmd = NULL;
+	spin_unlock_bh(&card->creg_ctrl.lock);
+
 	if (cmd == NULL) {
 		dev_err(CARD_TO_DEV(card),
 			"Spurious creg interrupt!\n");
@@ -289,10 +281,10 @@ creg_done:
 
 	kmem_cache_free(creg_cmd_pool, cmd);
 
-	spin_lock(&card->creg_ctrl.lock);
+	spin_lock_bh(&card->creg_ctrl.lock);
 	card->creg_ctrl.active = 0;
 	creg_kick_queue(card);
-	spin_unlock(&card->creg_ctrl.lock);
+	spin_unlock_bh(&card->creg_ctrl.lock);
 }
 
 static void creg_reset(struct rsxx_cardinfo *card)
@@ -317,7 +309,7 @@ static void creg_reset(struct rsxx_cardi
 		"Resetting creg interface for recovery\n");
 
 	/* Cancel outstanding commands */
-	spin_lock(&card->creg_ctrl.lock);
+	spin_lock_bh(&card->creg_ctrl.lock);
 	list_for_each_entry_safe(cmd, tmp, &card->creg_ctrl.queue, list) {
 		list_del(&cmd->list);
 		card->creg_ctrl.q_depth--;
@@ -338,7 +330,7 @@ static void creg_reset(struct rsxx_cardi
 
 		card->creg_ctrl.active = 0;
 	}
-	spin_unlock(&card->creg_ctrl.lock);
+	spin_unlock_bh(&card->creg_ctrl.lock);
 
 	card->creg_ctrl.reset = 0;
 	spin_lock_irqsave(&card->irq_lock, flags);
@@ -705,7 +697,7 @@ void rsxx_creg_destroy(struct rsxx_cardi
 	int cnt = 0;
 
 	/* Cancel outstanding commands */
-	spin_lock(&card->creg_ctrl.lock);
+	spin_lock_bh(&card->creg_ctrl.lock);
 	list_for_each_entry_safe(cmd, tmp, &card->creg_ctrl.queue, list) {
 		list_del(&cmd->list);
 		if (cmd->cb)
@@ -730,7 +722,7 @@ void rsxx_creg_destroy(struct rsxx_cardi
 			"Canceled active creg command\n");
 		kmem_cache_free(creg_cmd_pool, cmd);
 	}
-	spin_unlock(&card->creg_ctrl.lock);
+	spin_unlock_bh(&card->creg_ctrl.lock);
 
 	cancel_work_sync(&card->creg_ctrl.done_work);
 }


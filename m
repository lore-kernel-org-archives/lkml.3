Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab3JQOTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:19:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:35261 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab3JQOTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:19:45 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org, kishon@ti.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Daniel Mack <zonque@gmail.com>
Subject: [PATCH 1/2] dma: cppi41: redo descriptor collection in abort case
Date: Thu, 17 Oct 2013 16:19:35 +0200
Message-Id: <1382019576-25105-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.4.rc3
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the logic here is try and error since what actually happens does
not match the trm or I miss read it.
My first assumption was that the queue on which the tear-down descriptor
completes (their own complete queue vs "active descriptor" complete
queue) depends on the transfer direction. This seems not to be true
because I manage to trigger
|  WARN_ON(c->desc_phys != desc_phys);
and the other few were fine means the tear-down descriptor was valid but
on different queue.

This patch changes the logic here to look on both queues for the
descriptor.

Cc: Daniel Mack <zonque@gmail.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/dma/cppi41.c | 41 ++++++++++++++++-------------------------
 1 file changed, 16 insertions(+), 25 deletions(-)

diff --git a/drivers/dma/cppi41.c b/drivers/dma/cppi41.c
index 42d1c58..272969c 100644
--- a/drivers/dma/cppi41.c
+++ b/drivers/dma/cppi41.c
@@ -563,36 +563,27 @@ static int cppi41_tear_down_chan(struct cppi41_channel *c)
 		c->td_retry = 100;
 	}
 
-	if (!c->td_seen) {
+	if (!c->td_seen || !c->td_desc_seen) {
 		unsigned td_comp_queue;
 
-		if (c->is_tx)
-			td_comp_queue =  cdd->td_queue.complete;
-		else
-			td_comp_queue =  c->q_comp_num;
+		desc_phys = cppi41_pop_desc(cdd, cdd->td_queue.complete);
+		if (!desc_phys)
+			desc_phys = cppi41_pop_desc(cdd, c->q_comp_num);
 
-		desc_phys = cppi41_pop_desc(cdd, td_comp_queue);
-		if (desc_phys) {
-			__iormb();
+		if (desc_phys == c->desc_phys) {
+			c->td_desc_seen = 1;
+
+		} else if (desc_phys == td_desc_phys) {
+			u32 pd0;
 
-			if (desc_phys == td_desc_phys) {
-				u32 pd0;
-				pd0 = td->pd0;
-				WARN_ON((pd0 >> DESC_TYPE) != DESC_TYPE_TEARD);
-				WARN_ON(!c->is_tx && !(pd0 & TD_DESC_IS_RX));
-				WARN_ON((pd0 & 0x1f) != c->port_num);
-			} else {
-				WARN_ON_ONCE(1);
-			}
-			c->td_seen = 1;
-		}
-	}
-	if (!c->td_desc_seen) {
-		desc_phys = cppi41_pop_desc(cdd, c->q_comp_num);
-		if (desc_phys) {
 			__iormb();
-			WARN_ON(c->desc_phys != desc_phys);
-			c->td_desc_seen = 1;
+			pd0 = td->pd0;
+			WARN_ON((pd0 >> DESC_TYPE) != DESC_TYPE_TEARD);
+			WARN_ON(!c->is_tx && !(pd0 & TD_DESC_IS_RX));
+			WARN_ON((pd0 & 0x1f) != c->port_num);
+			c->td_seen = 1;
+		} else if (desc_phys) {
+			WARN_ON_ONCE(1);
 		}
 	}
 	c->td_retry--;
-- 
1.8.4.rc3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab3B1Ope (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:45:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41838 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264Ab3B1Op2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:45:28 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Wang, Song-Bo (Stoney)" <song-bo.wang@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 001/139] genirq: Avoid deadlock in spurious handling
Date: Thu, 28 Feb 2013 14:42:31 +0000
Message-Id: <1362062689-2567-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit e716efde75267eab919cdb2bef5b2cb77f305326 upstream.

commit 52553ddf(genirq: fix regression in irqfixup, irqpoll)
introduced a potential deadlock by calling the action handler with the
irq descriptor lock held.

Remove the call and let the handling code run even for an interrupt
where only a single action is registered. That matches the goal of
the above commit and avoids the deadlock.

Document the confusing action = desc->action reload in the handling
loop while at it.

Reported-and-tested-by: "Wang, Warner" <warner.wang@hp.com>
Tested-by: Edward Donovan <edward.donovan@numble.net>
Cc: "Wang, Song-Bo (Stoney)" <song-bo.wang@hp.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/irq/spurious.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 611cd60..7b5f012 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -80,13 +80,11 @@ static int try_one_irq(int irq, struct irq_desc *desc, bool force)
 
 	/*
 	 * All handlers must agree on IRQF_SHARED, so we test just the
-	 * first. Check for action->next as well.
+	 * first.
 	 */
 	action = desc->action;
 	if (!action || !(action->flags & IRQF_SHARED) ||
-	    (action->flags & __IRQF_TIMER) ||
-	    (action->handler(irq, action->dev_id) == IRQ_HANDLED) ||
-	    !action->next)
+	    (action->flags & __IRQF_TIMER))
 		goto out;
 
 	/* Already running on another processor */
@@ -104,6 +102,7 @@ static int try_one_irq(int irq, struct irq_desc *desc, bool force)
 	do {
 		if (handle_irq_event(desc) == IRQ_HANDLED)
 			ret = IRQ_HANDLED;
+		/* Make sure that there is still a valid action */
 		action = desc->action;
 	} while ((desc->istate & IRQS_PENDING) && action);
 	desc->istate &= ~IRQS_POLL_INPROGRESS;
-- 
1.8.1.2


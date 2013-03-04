Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab3CDEVe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:21:34 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60745 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755334Ab3CDDmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:42:32 -0500
Message-Id: <20130304033707.877845434@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:09 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>,
        Edward Donovan <edward.donovan@numble.net>,
        "Wang, Song-Bo (Stoney)" <song-bo.wang@hp.com>
Subject: [ 002/153] genirq: Avoid deadlock in spurious handling
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/irq/spurious.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -80,13 +80,11 @@ static int try_one_irq(int irq, struct i
 
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
@@ -104,6 +102,7 @@ static int try_one_irq(int irq, struct i
 	do {
 		if (handle_irq_event(desc) == IRQ_HANDLED)
 			ret = IRQ_HANDLED;
+		/* Make sure that there is still a valid action */
 		action = desc->action;
 	} while ((desc->istate & IRQS_PENDING) && action);
 	desc->istate &= ~IRQS_POLL_INPROGRESS;



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab3BYWdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:33:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55128 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759894Ab3BYWUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:20:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Edward Donovan <edward.donovan@numble.net>,
        "Wang, Song-Bo (Stoney)" <song-bo.wang@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [ 09/58] genirq: Avoid deadlock in spurious handling
Date: Mon, 25 Feb 2013 14:19:05 -0800
Message-Id: <20130225221638.073410943@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130225221636.018756060@linuxfoundation.org>
References: <20130225221636.018756060@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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



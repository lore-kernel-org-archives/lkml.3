Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966407AbaFTVlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 17:41:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:34213 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbaFTVla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 17:41:30 -0400
Date: Fri, 20 Jun 2014 23:41:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Torben Hohn <torbenh@linutronix.de>,
        Sebastian Siewior <bigeasy@linutronix.de>, Greg KH <greg@kroah.com>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org
Subject: usb: musb: Ensure that cppi41 timer gets armed on premature DMA TX
 irq
Message-ID: <alpine.DEB.2.10.1406202327180.5170@nanos>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some TI chips raise the DMA complete interrupt before the actual
transfer has been completed. The code tries to busy wait for a few
microseconds and if that fails it arms an hrtimer to recheck. So far
so good, but that has the following issue:

CPU 0					CPU1

start_next_transfer(RQ1);

DMA interrupt
  if (premature_irq(RQ1))
    if (!hrtimer_active(timer))
       hrtimer_start(timer);

hrtimer expires
  timer->state = CALLBACK_RUNNING;
  timer->fn() 
    cppi41_recheck_tx_req()
      complete_request(RQ1); 
      if (requests_pending())
        start_next_transfer(RQ2);

					DMA interrupt
					  if (premature_irq(RQ2))
					    if (!hrtimer_active(timer))
					       hrtimer_start(timer);
  timer->state = INACTIVE; 

The premature interrupt of request2 on CPU1 does not arm the timer and
therefor the request completion never happens because it checks for
!hrtimer_active(). hrtimer_active() evaluates:

  timer->state != HRTIMER_STATE_INACTIVE

which of course evaluates to true in the above case as timer->state is
CALLBACK_RUNNING.

That's clearly documented:

 * A timer is active, when it is enqueued into the rbtree or the                
 * callback function is running or it's in the state of being migrated          
 * to another cpu.         

But that's not what the code wants to check. The code wants to check
whether the timer is queued, i.e. whether its armed and waiting for
expiry.

We have a helper function for this: hrtimer_is_queued(). This
evaluates:

  timer->state & HRTIMER_STATE_QUEUED

So in the above case this evaluates to false and therefor forces the
DMA interrupt on CPU1 to call hrtimer_start().

Use hrtimer_is_queued() instead of hrtimer_active() and evrything is
good.

Reported-by: Torben Hohn <torbenh@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
---
 drivers/usb/musb/musb_cppi41.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/usb/musb/musb_cppi41.c
===================================================================
--- linux.orig/drivers/usb/musb/musb_cppi41.c
+++ linux/drivers/usb/musb/musb_cppi41.c
@@ -318,7 +318,7 @@ static void cppi41_dma_callback(void *pr
 		}
 		list_add_tail(&cppi41_channel->tx_check,
 				&controller->early_tx_list);
-		if (!hrtimer_active(&controller->early_tx)) {
+		if (!hrtimer_is_queued(&controller->early_tx)) {
 			hrtimer_start_range_ns(&controller->early_tx,
 				ktime_set(0, 140 * NSEC_PER_USEC),
 				40 * NSEC_PER_USEC,

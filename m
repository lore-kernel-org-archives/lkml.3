Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbaHHUsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:48:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40659 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758149AbaHHUsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:48:13 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Felipe Balbi <balbi@ti.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 040/259] usb: musb: Ensure that cppi41 timer gets armed on premature DMA TX irq
Date: Fri,  8 Aug 2014 13:37:43 -0700
Message-Id: <1407530482-4483-41-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit c58d80f523ffc15ef4d062fc7aeb03793fe39701 upstream.

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
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/musb/musb_cppi41.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/musb/musb_cppi41.c b/drivers/usb/musb/musb_cppi41.c
index a12bd30..4a5af5c 100644
--- a/drivers/usb/musb/musb_cppi41.c
+++ b/drivers/usb/musb/musb_cppi41.c
@@ -266,7 +266,7 @@ static void cppi41_dma_callback(void *private_data)
 		}
 		list_add_tail(&cppi41_channel->tx_check,
 				&controller->early_tx_list);
-		if (!hrtimer_active(&controller->early_tx)) {
+		if (!hrtimer_is_queued(&controller->early_tx)) {
 			hrtimer_start_range_ns(&controller->early_tx,
 				ktime_set(0, 140 * NSEC_PER_USEC),
 				40 * NSEC_PER_USEC,
-- 
1.9.1


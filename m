Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbaKKLd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:33:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57690 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260AbaKKLKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 118/170] usb: musb: cppi41: restart hrtimer only if not yet done
Date: Tue, 11 Nov 2014 11:07:57 +0000
Message-Id: <1415704129-12709-119-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit d2e6d62c9cbbc2da4211f672dbeea08960e29a80 upstream.

commit c58d80f52 ("usb: musb: Ensure that cppi41 timer gets armed on
premature DMA TX irq") fixed hrtimer scheduling bug. There is one left
which does not trigger that often.
The following scenario is still possible:

    lock(&x->lock);
    hrtimer_start(&x->t);
    unlock(&x->lock);

expires:
    t->function();
                                lock(&x->lock);
    lock(&x->lock);             if (!hrtimer_queued(&x->t))
                                        hrtimer_start(&x->t);
                                unlock(&x->lock);

    if (!list_empty(x->early_tx_list))
           ret = HRTIMER_RESTART;
->         hrtimer_forward_now(...)
    } else
           ret = HRTIMER_NORESTART;

    unlock(&x->lock);

and the timer callback returns HRTIMER_RESTART for an armed timer. This
is wrong and we run into the BUG_ON() in __run_hrtimer().
This can happens on SMP or PREEMPT-RT.
The patch fixes the problem by only starting the timer if the timer is
not yet queued.

Reported-by: Torben Hohn <torbenh@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bigeasy: collected information and created a patch + description based
          on it]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/musb/musb_cppi41.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/musb/musb_cppi41.c b/drivers/usb/musb/musb_cppi41.c
index 5341bb223b7c..b4fe70355682 100644
--- a/drivers/usb/musb/musb_cppi41.c
+++ b/drivers/usb/musb/musb_cppi41.c
@@ -230,7 +230,8 @@ static enum hrtimer_restart cppi41_recheck_tx_req(struct hrtimer *timer)
 		}
 	}
 
-	if (!list_empty(&controller->early_tx_list)) {
+	if (!list_empty(&controller->early_tx_list) &&
+	    !hrtimer_is_queued(&controller->early_tx)) {
 		ret = HRTIMER_RESTART;
 		hrtimer_forward_now(&controller->early_tx,
 				ktime_set(0, 150 * NSEC_PER_USEC));
-- 
2.1.0


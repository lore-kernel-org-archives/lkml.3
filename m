Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965392AbaKLBpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:45:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60608 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965374AbaKLBp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:45:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Torben Hohn <torbenh@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.14 148/203] usb: musb: cppi41: restart hrtimer only if not yet done
Date: Wed, 12 Nov 2014 10:16:58 +0900
Message-Id: <20141112011549.504129549@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/musb/musb_cppi41.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/musb/musb_cppi41.c
+++ b/drivers/usb/musb/musb_cppi41.c
@@ -190,7 +190,8 @@ static enum hrtimer_restart cppi41_reche
 		}
 	}
 
-	if (!list_empty(&controller->early_tx_list)) {
+	if (!list_empty(&controller->early_tx_list) &&
+	    !hrtimer_is_queued(&controller->early_tx)) {
 		ret = HRTIMER_RESTART;
 		hrtimer_forward_now(&controller->early_tx,
 				ktime_set(0, 150 * NSEC_PER_USEC));



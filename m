Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbaKROeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:34:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57215 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094AbaKROKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:12 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 158/206] usb: musb: cppi41: restart hrtimer only if not yet done
Date: Tue, 18 Nov 2014 15:08:33 +0100
Message-Id: <cd4386a94a23465eb28dfdce149e3cce72839588.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/musb/musb_cppi41.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/musb/musb_cppi41.c b/drivers/usb/musb/musb_cppi41.c
index bd6cc0bea150..5c91ff379345 100644
--- a/drivers/usb/musb/musb_cppi41.c
+++ b/drivers/usb/musb/musb_cppi41.c
@@ -190,7 +190,8 @@ static enum hrtimer_restart cppi41_recheck_tx_req(struct hrtimer *timer)
 		}
 	}
 
-	if (!list_empty(&controller->early_tx_list)) {
+	if (!list_empty(&controller->early_tx_list) &&
+	    !hrtimer_is_queued(&controller->early_tx)) {
 		ret = HRTIMER_RESTART;
 		hrtimer_forward_now(&controller->early_tx,
 				ktime_set(0, 50 * NSEC_PER_USEC));
-- 
2.1.3


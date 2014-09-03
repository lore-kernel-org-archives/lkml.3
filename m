Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459AbaICJ61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:58:27 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57453 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932440AbaICJ6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:58:24 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Mack <zonque@gmail.com>,
        Felipe Balbi <balbi@ti.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 02/56] usb: musb: cppi41: fire hrtimer according to programmed channel length
Date: Wed,  3 Sep 2014 11:26:21 +0200
Message-Id: <bd78518ba277b4f768941f80c5e7b6f0c3c8ccf5.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Mack <zonque@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 50aea6fca771d6daf3ec24f771da866f7fd836e4 upstream.

The musb/cppi41 code installs a hrtimer to work around DMA completion
interrupts that have fired too early on AM335x hardware. This timer
is currently programmed to first fire 140 microseconds after the DMA
completion callback. According to the commit which introduced it
(a655f481d83, "usb: musb: musb_cppi41: handle pre-mature TX complete
interrupt"), that value is is considered a 'rule of thumb' that worked
well with the test case described in the commit log.

Test show, however, that for USB audio devices and much smaller packet
sizes, the timer has to fire earlier in order to correctly handle the audio
stream. The original test case had output transfer sizes of 1514 bytes, and
a delay of 140 microseconds. For audio devices with 24 bytes channel size, 3
microseconds seem to work well.

Hence, let's assume that the time it takes to clear the bit correlates with
the number of bytes transferred. The referenced commit log mentions such a
suspicion as well. Let the timer fire in cppi41_channel->total_len/10
microseconds to correctly handle both cases.

Also, shorten the interval in which the timer fires again in case of
a non-empty early_tx list.

With these changes in place, both FS and HS audio devices appear to work
well on AM335x hardware.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Reported-by: Sebastian Reimers <sebastian.reimers@googlemail.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/musb/musb_cppi41.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/musb/musb_cppi41.c b/drivers/usb/musb/musb_cppi41.c
index cc319305c022..bd6cc0bea150 100644
--- a/drivers/usb/musb/musb_cppi41.c
+++ b/drivers/usb/musb/musb_cppi41.c
@@ -193,7 +193,7 @@ static enum hrtimer_restart cppi41_recheck_tx_req(struct hrtimer *timer)
 	if (!list_empty(&controller->early_tx_list)) {
 		ret = HRTIMER_RESTART;
 		hrtimer_forward_now(&controller->early_tx,
-				ktime_set(0, 150 * NSEC_PER_USEC));
+				ktime_set(0, 50 * NSEC_PER_USEC));
 	}
 
 	spin_unlock_irqrestore(&musb->lock, flags);
@@ -267,8 +267,10 @@ static void cppi41_dma_callback(void *private_data)
 		list_add_tail(&cppi41_channel->tx_check,
 				&controller->early_tx_list);
 		if (!hrtimer_is_queued(&controller->early_tx)) {
+			unsigned long usecs = cppi41_channel->total_len / 10;
+
 			hrtimer_start_range_ns(&controller->early_tx,
-				ktime_set(0, 140 * NSEC_PER_USEC),
+				ktime_set(0, usecs * NSEC_PER_USEC),
 				40 * NSEC_PER_USEC,
 				HRTIMER_MODE_REL);
 		}
-- 
2.1.0


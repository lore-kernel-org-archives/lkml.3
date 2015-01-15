Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415AbbAOHMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 02:12:07 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:48255 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbbAOHMF (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Thu, 15 Jan 2015 02:12:05 -0500
Message-ID: <1421305903.17403.0.camel@stgolabs.net>
Subject: [PATCH] sound/oss: use current->state helpers
From: Davidlohr Bueso <dave@stgolabs.net>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andrew Veliath <andrewtv@usa.net>, Jaroslav Kysela <perex@perex.cz>,
        Davidlohr Bueso <dave@stgolabs.net>, linux-kernel@vger.kernel.org
Date: Wed, 14 Jan 2015 23:11:43 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@stgolabs.net>

Call __set_current_state() instead of assigning the new state directly.
These interfaces also aid CONFIG_DEBUG_ATOMIC_SLEEP environments, keeping
track of who changed the state.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 sound/oss/msnd_pinnacle.c | 4 ++--
 sound/oss/swarm_cs4297a.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/oss/msnd_pinnacle.c b/sound/oss/msnd_pinnacle.c
index c23f9f9..a8ceef8 100644
--- a/sound/oss/msnd_pinnacle.c
+++ b/sound/oss/msnd_pinnacle.c
@@ -675,7 +675,7 @@ static void dsp_write_flush(void)
 		timeout);
 	clear_bit(F_WRITEFLUSH, &dev.flags);
 	if (!signal_pending(current)) {
-		current->state = TASK_INTERRUPTIBLE;
+		__set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout(get_play_delay_jiffies(DAP_BUFF_SIZE));
 	}
 	clear_bit(F_WRITING, &dev.flags);
@@ -1288,7 +1288,7 @@ static int __init calibrate_adc(WORD srate)
 		       & ~0x0001, dev.SMA + SMA_wCurrHostStatusFlags);
 	if (msnd_send_word(&dev, 0, 0, HDEXAR_CAL_A_TO_D) == 0 &&
 	    chk_send_dsp_cmd(&dev, HDEX_AUX_REQ) == 0) {
-		current->state = TASK_INTERRUPTIBLE;
+		__set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout(HZ / 3);
 		return 0;
 	}
diff --git a/sound/oss/swarm_cs4297a.c b/sound/oss/swarm_cs4297a.c
index a33e8ce..213a416 100644
--- a/sound/oss/swarm_cs4297a.c
+++ b/sound/oss/swarm_cs4297a.c
@@ -1654,7 +1654,7 @@ static int drain_dac(struct cs4297a_state *s, int nonblock)
         s->dma_dac.hwptr = s->dma_dac.swptr = hwptr;
         spin_unlock_irqrestore(&s->lock, flags);
 	remove_wait_queue(&s->dma_dac.wait, &wait);
-	current->state = TASK_RUNNING;
+	__set_current_state(TASK_RUNNING);
 	return 0;
 }
 
-- 
2.1.2





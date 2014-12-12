Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760164AbaLLGRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:17:53 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51900 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760073AbaLLGRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:17:20 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Takashi Iwai" <tiwai@suse.de>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.460362706@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 060/164] ALSA: emu10k1: Fix deadlock in synth voice lookup
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 95926035b187cc9fee6fb61385b7da9c28123f74 upstream.

The emu10k1 voice allocator takes voice_lock spinlock.  When there is
no empty stream available, it tries to release a voice used by synth,
and calls get_synth_voice.  The callback function,
snd_emu10k1_synth_get_voice(), however, also takes the voice_lock,
thus it deadlocks.

The fix is simply removing the voice_lock holds in
snd_emu10k1_synth_get_voice(), as this is always called in the
spinlock context.

Reported-and-tested-by: Arthur Marsh <arthur.marsh@internode.on.net>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/emu10k1/emu10k1_callback.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/sound/pci/emu10k1/emu10k1_callback.c
+++ b/sound/pci/emu10k1/emu10k1_callback.c
@@ -85,6 +85,8 @@ snd_emu10k1_ops_setup(struct snd_emux *e
  * get more voice for pcm
  *
  * terminate most inactive voice and give it as a pcm voice.
+ *
+ * voice_lock is already held.
  */
 int
 snd_emu10k1_synth_get_voice(struct snd_emu10k1 *hw)
@@ -92,12 +94,10 @@ snd_emu10k1_synth_get_voice(struct snd_e
 	struct snd_emux *emu;
 	struct snd_emux_voice *vp;
 	struct best_voice best[V_END];
-	unsigned long flags;
 	int i;
 
 	emu = hw->synth;
 
-	spin_lock_irqsave(&emu->voice_lock, flags);
 	lookup_voices(emu, hw, best, 1); /* no OFF voices */
 	for (i = 0; i < V_END; i++) {
 		if (best[i].voice >= 0) {
@@ -113,11 +113,9 @@ snd_emu10k1_synth_get_voice(struct snd_e
 			vp->emu->num_voices--;
 			vp->ch = -1;
 			vp->state = SNDRV_EMUX_ST_OFF;
-			spin_unlock_irqrestore(&emu->voice_lock, flags);
 			return ch;
 		}
 	}
-	spin_unlock_irqrestore(&emu->voice_lock, flags);
 
 	/* not found */
 	return -ENOMEM;


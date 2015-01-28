Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761362AbbA1ESc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:18:32 -0500
Received: from mail.kernel.org ([198.145.29.136]:38484 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755667AbbA1ES3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:18:29 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 053/177] ALSA: emu10k1: Fix deadlock in synth voice lookup
Date: Wed, 28 Jan 2015 12:07:52 +0800
Message-Id: <1422418236-12852-105-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 sound/pci/emu10k1/emu10k1_callback.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/pci/emu10k1/emu10k1_callback.c b/sound/pci/emu10k1/emu10k1_callback.c
index a0afa50..f35284b 100644
--- a/sound/pci/emu10k1/emu10k1_callback.c
+++ b/sound/pci/emu10k1/emu10k1_callback.c
@@ -85,6 +85,8 @@ snd_emu10k1_ops_setup(struct snd_emux *emux)
  * get more voice for pcm
  *
  * terminate most inactive voice and give it as a pcm voice.
+ *
+ * voice_lock is already held.
  */
 int
 snd_emu10k1_synth_get_voice(struct snd_emu10k1 *hw)
@@ -92,12 +94,10 @@ snd_emu10k1_synth_get_voice(struct snd_emu10k1 *hw)
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
@@ -113,11 +113,9 @@ snd_emu10k1_synth_get_voice(struct snd_emu10k1 *hw)
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
-- 
1.9.1


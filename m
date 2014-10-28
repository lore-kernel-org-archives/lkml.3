Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbaJ1DjE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:39:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44578 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439AbaJ1DjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:39:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.17 073/146] ALSA: emu10k1: Fix deadlock in synth voice lookup
Date: Tue, 28 Oct 2014 11:33:35 +0800
Message-Id: <20141028033346.549414036@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/emu10k1/emu10k1_callback.c |    6 ++----
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



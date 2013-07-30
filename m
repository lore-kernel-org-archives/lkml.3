Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472Ab3G3PUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:20:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55379 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab3G3PUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:20:42 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 23/75] ALSA: 6fire: Fix unlocked snd_pcm_stop() call
Date: Tue, 30 Jul 2013 08:16:52 -0700
Message-Id: <1375197464-27962-24-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 5b9ab3f7324a1b94a5a5a76d44cf92dfeb3b5e80 upstream.

snd_pcm_stop() must be called in the PCM substream lock context.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/usb/6fire/pcm.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/sound/usb/6fire/pcm.c b/sound/usb/6fire/pcm.c
index 40dd50a..8221ff2 100644
--- a/sound/usb/6fire/pcm.c
+++ b/sound/usb/6fire/pcm.c
@@ -641,17 +641,25 @@ int usb6fire_pcm_init(struct sfire_chip *chip)
 void usb6fire_pcm_abort(struct sfire_chip *chip)
 {
 	struct pcm_runtime *rt = chip->pcm;
+	unsigned long flags;
 	int i;
 
 	if (rt) {
 		rt->panic = true;
 
-		if (rt->playback.instance)
+		if (rt->playback.instance) {
+			snd_pcm_stream_lock_irqsave(rt->playback.instance, flags);
 			snd_pcm_stop(rt->playback.instance,
 					SNDRV_PCM_STATE_XRUN);
-		if (rt->capture.instance)
+			snd_pcm_stream_unlock_irqrestore(rt->playback.instance, flags);
+		}
+
+		if (rt->capture.instance) {
+			snd_pcm_stream_lock_irqsave(rt->capture.instance, flags);
 			snd_pcm_stop(rt->capture.instance,
 					SNDRV_PCM_STATE_XRUN);
+			snd_pcm_stream_unlock_irqrestore(rt->capture.instance, flags);
+		}
 
 		for (i = 0; i < PCM_N_URBS; i++) {
 			usb_poison_urb(&rt->in_urbs[i].instance);
-- 
1.8.1.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934882Ab3GWWug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:50:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41559 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934566Ab3GWW1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 033/103] ALSA: 6fire: Fix unlocked snd_pcm_stop() call
Date: Tue, 23 Jul 2013 15:25:44 -0700
Message-Id: <20130723220422.257688311@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 5b9ab3f7324a1b94a5a5a76d44cf92dfeb3b5e80 upstream.

snd_pcm_stop() must be called in the PCM substream lock context.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/6fire/pcm.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/sound/usb/6fire/pcm.c
+++ b/sound/usb/6fire/pcm.c
@@ -641,17 +641,25 @@ int usb6fire_pcm_init(struct sfire_chip
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



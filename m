Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab3G3PUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:20:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55395 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab3G3PUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:20:48 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 25/75] ALSA: usx2y: Fix unlocked snd_pcm_stop() call
Date: Tue, 30 Jul 2013 08:16:54 -0700
Message-Id: <1375197464-27962-26-git-send-email-kamal@canonical.com>
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

commit 5be1efb4c2ed79c3d7c0cbcbecae768377666e84 upstream.

snd_pcm_stop() must be called in the PCM substream lock context.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/usb/usx2y/usbusx2yaudio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/usb/usx2y/usbusx2yaudio.c b/sound/usb/usx2y/usbusx2yaudio.c
index b376532..0ce90337 100644
--- a/sound/usb/usx2y/usbusx2yaudio.c
+++ b/sound/usb/usx2y/usbusx2yaudio.c
@@ -273,7 +273,11 @@ static void usX2Y_clients_stop(struct usX2Ydev *usX2Y)
 		struct snd_usX2Y_substream *subs = usX2Y->subs[s];
 		if (subs) {
 			if (atomic_read(&subs->state) >= state_PRERUNNING) {
+				unsigned long flags;
+
+				snd_pcm_stream_lock_irqsave(subs->pcm_substream, flags);
 				snd_pcm_stop(subs->pcm_substream, SNDRV_PCM_STATE_XRUN);
+				snd_pcm_stream_unlock_irqrestore(subs->pcm_substream, flags);
 			}
 			for (u = 0; u < NRURBS; u++) {
 				struct urb *urb = subs->urb[u];
-- 
1.8.1.2


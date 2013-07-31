Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760092Ab3GaNdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:33:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47064 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759819Ab3GaN0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:26:03 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Takashi Iwai" <tiwai@suse.de>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.965998866@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [46/84] ALSA: usx2y: Fix unlocked snd_pcm_stop() call
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 5be1efb4c2ed79c3d7c0cbcbecae768377666e84 upstream.

snd_pcm_stop() must be called in the PCM substream lock context.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/usb/usx2y/usbusx2yaudio.c | 4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/usb/usx2y/usbusx2yaudio.c
+++ b/sound/usb/usx2y/usbusx2yaudio.c
@@ -273,7 +273,11 @@ static void usX2Y_clients_stop(struct us
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


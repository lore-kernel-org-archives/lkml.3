Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939Ab3GaNaB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:30:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47122 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759537Ab3GaN0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:26:07 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Takashi Iwai" <tiwai@suse.de>,
        "Clemens Ladisch" <clemens@ladisch.de>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.621662122@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [45/84] ALSA: ua101: Fix unlocked snd_pcm_stop() call
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

commit 9538aa46c2427d6782aa10036c4da4c541605e0e upstream.

snd_pcm_stop() must be called in the PCM substream lock context.

Acked-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/usb/misc/ua101.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/sound/usb/misc/ua101.c
+++ b/sound/usb/misc/ua101.c
@@ -613,14 +613,24 @@ static int start_usb_playback(struct ua1
 
 static void abort_alsa_capture(struct ua101 *ua)
 {
-	if (test_bit(ALSA_CAPTURE_RUNNING, &ua->states))
+	unsigned long flags;
+
+	if (test_bit(ALSA_CAPTURE_RUNNING, &ua->states)) {
+		snd_pcm_stream_lock_irqsave(ua->capture.substream, flags);
 		snd_pcm_stop(ua->capture.substream, SNDRV_PCM_STATE_XRUN);
+		snd_pcm_stream_unlock_irqrestore(ua->capture.substream, flags);
+	}
 }
 
 static void abort_alsa_playback(struct ua101 *ua)
 {
-	if (test_bit(ALSA_PLAYBACK_RUNNING, &ua->states))
+	unsigned long flags;
+
+	if (test_bit(ALSA_PLAYBACK_RUNNING, &ua->states)) {
+		snd_pcm_stream_lock_irqsave(ua->playback.substream, flags);
 		snd_pcm_stop(ua->playback.substream, SNDRV_PCM_STATE_XRUN);
+		snd_pcm_stream_unlock_irqrestore(ua->playback.substream, flags);
+	}
 }
 
 static int set_stream_hw(struct ua101 *ua, struct snd_pcm_substream *substream,


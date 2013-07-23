Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934909Ab3GWWtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:49:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41562 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934577Ab3GWW1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [ 034/103] ALSA: ua101: Fix unlocked snd_pcm_stop() call
Date: Tue, 23 Jul 2013 15:25:45 -0700
Message-Id: <20130723220422.370373563@linuxfoundation.org>
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

commit 9538aa46c2427d6782aa10036c4da4c541605e0e upstream.

snd_pcm_stop() must be called in the PCM substream lock context.

Acked-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/misc/ua101.c |   14 ++++++++++++--
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



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbaCHBPz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:15:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46606 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356AbaCHBHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:07:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 83/99] ALSA: ua101: Fix unlocked snd_pcm_stop() call
Date: Fri,  7 Mar 2014 17:08:19 -0800
Message-Id: <20140308010614.248622354@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140308010611.468206150@linuxfoundation.org>
References: <20140308010611.468206150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 9538aa46c2427d6782aa10036c4da4c541605e0e upstream.

snd_pcm_stop() must be called in the PCM substream lock context.

Acked-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
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



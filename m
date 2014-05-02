Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbaEBQXo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:23:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43744 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbaEBPjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:39:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 144/151] ALSA: ice1712: Fix boundary checks in PCM pointer ops
Date: Fri,  2 May 2014 08:38:52 -0700
Message-Id: <1399045139-4531-145-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 4f8e940095536bc002a81666a4107a581c84e9b9 upstream.

PCM pointer callbacks in ice1712 driver check the buffer size boundary
wrongly between bytes and frames.  This leads to PCM core warnings
like:
   snd_pcm_update_hw_ptr0: 105 callbacks suppressed
   ALSA pcm_lib.c:352 BUG: pcmC3D0c:0, pos = 5461, buffer size = 5461, period size = 2730

This patch fixes these checks to be placed after the proper unit
conversions.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/ice1712/ice1712.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
index 28ec872..b6e278f 100644
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -685,9 +685,10 @@ static snd_pcm_uframes_t snd_ice1712_playback_pointer(struct snd_pcm_substream *
 	if (!(snd_ice1712_read(ice, ICE1712_IREG_PBK_CTRL) & 1))
 		return 0;
 	ptr = runtime->buffer_size - inw(ice->ddma_port + 4);
+	ptr = bytes_to_frames(substream->runtime, ptr);
 	if (ptr == runtime->buffer_size)
 		ptr = 0;
-	return bytes_to_frames(substream->runtime, ptr);
+	return ptr;
 }
 
 static snd_pcm_uframes_t snd_ice1712_playback_ds_pointer(struct snd_pcm_substream *substream)
@@ -704,9 +705,10 @@ static snd_pcm_uframes_t snd_ice1712_playback_ds_pointer(struct snd_pcm_substrea
 		addr = ICE1712_DSC_ADDR0;
 	ptr = snd_ice1712_ds_read(ice, substream->number * 2, addr) -
 		ice->playback_con_virt_addr[substream->number];
+	ptr = bytes_to_frames(substream->runtime, ptr);
 	if (ptr == substream->runtime->buffer_size)
 		ptr = 0;
-	return bytes_to_frames(substream->runtime, ptr);
+	return ptr;
 }
 
 static snd_pcm_uframes_t snd_ice1712_capture_pointer(struct snd_pcm_substream *substream)
@@ -717,9 +719,10 @@ static snd_pcm_uframes_t snd_ice1712_capture_pointer(struct snd_pcm_substream *s
 	if (!(snd_ice1712_read(ice, ICE1712_IREG_CAP_CTRL) & 1))
 		return 0;
 	ptr = inl(ICEREG(ice, CONCAP_ADDR)) - ice->capture_con_virt_addr;
+	ptr = bytes_to_frames(substream->runtime, ptr);
 	if (ptr == substream->runtime->buffer_size)
 		ptr = 0;
-	return bytes_to_frames(substream->runtime, ptr);
+	return ptr;
 }
 
 static const struct snd_pcm_hardware snd_ice1712_playback = {
@@ -1113,9 +1116,10 @@ static snd_pcm_uframes_t snd_ice1712_playback_pro_pointer(struct snd_pcm_substre
 	if (!(inl(ICEMT(ice, PLAYBACK_CONTROL)) & ICE1712_PLAYBACK_START))
 		return 0;
 	ptr = ice->playback_pro_size - (inw(ICEMT(ice, PLAYBACK_SIZE)) << 2);
+	ptr = bytes_to_frames(substream->runtime, ptr);
 	if (ptr == substream->runtime->buffer_size)
 		ptr = 0;
-	return bytes_to_frames(substream->runtime, ptr);
+	return ptr;
 }
 
 static snd_pcm_uframes_t snd_ice1712_capture_pro_pointer(struct snd_pcm_substream *substream)
@@ -1126,9 +1130,10 @@ static snd_pcm_uframes_t snd_ice1712_capture_pro_pointer(struct snd_pcm_substrea
 	if (!(inl(ICEMT(ice, PLAYBACK_CONTROL)) & ICE1712_CAPTURE_START_SHADOW))
 		return 0;
 	ptr = ice->capture_pro_size - (inw(ICEMT(ice, CAPTURE_SIZE)) << 2);
+	ptr = bytes_to_frames(substream->runtime, ptr);
 	if (ptr == substream->runtime->buffer_size)
 		ptr = 0;
-	return bytes_to_frames(substream->runtime, ptr);
+	return ptr;
 }
 
 static const struct snd_pcm_hardware snd_ice1712_playback_pro = {
-- 
1.9.1


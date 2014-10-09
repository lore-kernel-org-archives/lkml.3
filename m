Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366AbaJIVGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:06:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59053 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308AbaJIVGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:06:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 137/163] ALSA: pcm: fix fifo_size frame calculation
Date: Thu,  9 Oct 2014 14:02:42 -0700
Message-Id: <1412888588-26755-138-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit a9960e6a293e6fc3ed414643bb4e4106272e4d0a upstream.

The calculated frame size was wrong because snd_pcm_format_physical_width()
actually returns the number of bits, not bytes.

Use snd_pcm_format_size() instead, which not only returns bytes, but also
simplifies the calculation.

Fixes: 8bea869c5e56 ("ALSA: PCM midlevel: improve fifo_size handling")
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/core/pcm_lib.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index a210467..e1ef106 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1783,14 +1783,16 @@ static int snd_pcm_lib_ioctl_fifo_size(struct snd_pcm_substream *substream,
 {
 	struct snd_pcm_hw_params *params = arg;
 	snd_pcm_format_t format;
-	int channels, width;
+	int channels;
+	ssize_t frame_size;
 
 	params->fifo_size = substream->runtime->hw.fifo_size;
 	if (!(substream->runtime->hw.info & SNDRV_PCM_INFO_FIFO_IN_FRAMES)) {
 		format = params_format(params);
 		channels = params_channels(params);
-		width = snd_pcm_format_physical_width(format);
-		params->fifo_size /= width * channels;
+		frame_size = snd_pcm_format_size(format, channels);
+		if (frame_size > 0)
+			params->fifo_size /= (unsigned)frame_size;
 	}
 	return 0;
 }
-- 
1.9.1


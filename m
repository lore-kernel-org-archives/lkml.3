Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbaK0ItI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:49:08 -0500
Received: from mail.kernel.org ([198.145.19.201]:42351 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755146AbaK0Is6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:48:58 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Clemens Ladisch <clemens@ladisch.de>,
        Takashi Iwai <tiwai@suse.de>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 59/91] ALSA: pcm: fix fifo_size frame calculation
Date: Thu, 27 Nov 2014 16:42:42 +0800
Message-Id: <1417077794-9299-59-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Clemens Ladisch <clemens@ladisch.de>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit a9960e6a293e6fc3ed414643bb4e4106272e4d0a upstream.

The calculated frame size was wrong because snd_pcm_format_physical_width()
actually returns the number of bits, not bytes.

Use snd_pcm_format_size() instead, which not only returns bytes, but also
simplifies the calculation.

Fixes: 8bea869c5e56 ("ALSA: PCM midlevel: improve fifo_size handling")
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 sound/core/pcm_lib.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index 370fc56..6292575 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1693,14 +1693,16 @@ static int snd_pcm_lib_ioctl_fifo_size(struct snd_pcm_substream *substream,
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


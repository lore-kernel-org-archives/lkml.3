Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbaKAW4g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:56:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60123 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751553AbaKAWj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:27 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Takashi Iwai" <tiwai@suse.de>,
        "Clemens Ladisch" <clemens@ladisch.de>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.717976970@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 066/102] ALSA: pcm: fix fifo_size frame calculation
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/core/pcm_lib.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1692,14 +1692,16 @@ static int snd_pcm_lib_ioctl_fifo_size(s
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


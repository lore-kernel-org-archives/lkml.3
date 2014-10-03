Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbaJCWDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:03:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45923 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171AbaJCVxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:53:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.14 045/238] ALSA: pcm: fix fifo_size frame calculation
Date: Fri,  3 Oct 2014 14:29:20 -0700
Message-Id: <20141003212915.099305770@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/pcm_lib.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1783,14 +1783,16 @@ static int snd_pcm_lib_ioctl_fifo_size(s
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



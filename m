Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573AbaJNO7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:59:35 -0400
Received: from resqmta-po-05v.sys.comcast.net ([96.114.154.164]:60321 "EHLO
	resqmta-po-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932498AbaJNO7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:59:32 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: m.chehab@samsung.com, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, crope@iki.fi, olebowle@gmx.com,
        dheitmueller@kernellabs.com, hverkuil@xs4all.nl, ramakrmu@cisco.com,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        perex@perex.cz, tiwai@suse.de, prabhakar.csengg@gmail.com,
        tim.gardner@canonical.com, linux@eikelenboom.it
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/6] sound/usb: pcm changes to use media token api
Date: Tue, 14 Oct 2014 08:58:41 -0600
Message-Id: <cf1059cc2606f20d921e5691e3d59945a19a7871.1413246372.git.shuahkh@osg.samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1413246370.git.shuahkh@osg.samsung.com>
References: <cover.1413246370.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1413246370.git.shuahkh@osg.samsung.com>
References: <cover.1413246370.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change snd_usb_capture_ops trigger to hold audio token prior
starting endpoints for SNDRV_PCM_TRIGGER_START request and
release after stopping endpoints for SNDRV_PCM_TRIGGER_STOP
request. Audio token is released from snd_usb_capture_ops
close interface to cover the case where an application exits
without stopping capture. Audio token get request will succeed
if it is free or when a media application with the same task
pid or task gid makes the request. This covers the cases when
a media application first hold the tuner nd audio token and
then requests SNDRV_PCM_TRIGGER_START either from the same
thread or a another thread in the same process group.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 sound/usb/pcm.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index c62a165..d23abeb 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -21,6 +21,7 @@
 #include <linux/usb.h>
 #include <linux/usb/audio.h>
 #include <linux/usb/audio-v2.h>
+#include <linux/media_tknres.h>
 
 #include <sound/core.h>
 #include <sound/pcm.h>
@@ -1220,6 +1221,7 @@ static int snd_usb_pcm_close(struct snd_pcm_substream *substream, int direction)
 
 	subs->pcm_substream = NULL;
 	snd_usb_autosuspend(subs->stream->chip);
+	media_put_audio_tkn(&subs->dev->dev);
 
 	return 0;
 }
@@ -1573,6 +1575,12 @@ static int snd_usb_substream_capture_trigger(struct snd_pcm_substream *substream
 
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
+		err = media_get_audio_tkn(&subs->dev->dev);
+		if (err == -EBUSY) {
+			dev_info(&subs->dev->dev, "%s device is busy\n",
+					__func__);
+			return err;
+		}
 		err = start_endpoints(subs, false);
 		if (err < 0)
 			return err;
@@ -1583,6 +1591,7 @@ static int snd_usb_substream_capture_trigger(struct snd_pcm_substream *substream
 	case SNDRV_PCM_TRIGGER_STOP:
 		stop_endpoints(subs, false);
 		subs->running = 0;
+		media_put_audio_tkn(&subs->dev->dev);
 		return 0;
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
 		subs->data_endpoint->retire_data_urb = NULL;
-- 
1.7.10.4


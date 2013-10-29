Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab3J2S0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:26:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59243 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab3J2SFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:05:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: fzu@wemgehoertderstaat.de, Daniel Mack <zonque@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 04/81] ALSA: snd-usb-usx2y: remove bogus frame checks
Date: Tue, 29 Oct 2013 11:03:25 -0700
Message-Id: <1383069882-11437-5-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Mack <zonque@gmail.com>

commit a9d14bc0b188a822e42787d01e56c06fe9750162 upstream.

The frame check in i_usX2Y_urb_complete() and
i_usX2Y_usbpcm_urb_complete() is bogus and produces false positives as
described in this LAU thread:

  http://linuxaudio.org/mailarchive/lau/2013/5/20/200177

This patch removes the check code entirely.

Cc: fzu@wemgehoertderstaat.de
Reported-by: Dr Nicholas J Bailey <nicholas.bailey@glasgow.ac.uk>
Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Daniel Mack <zonque@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/usb/usx2y/usbusx2yaudio.c | 22 +++-------------------
 sound/usb/usx2y/usx2yhwdeppcm.c |  7 +------
 2 files changed, 4 insertions(+), 25 deletions(-)

diff --git a/sound/usb/usx2y/usbusx2yaudio.c b/sound/usb/usx2y/usbusx2yaudio.c
index 0ce90337..cd69a80 100644
--- a/sound/usb/usx2y/usbusx2yaudio.c
+++ b/sound/usb/usx2y/usbusx2yaudio.c
@@ -299,19 +299,6 @@ static void usX2Y_error_urb_status(struct usX2Ydev *usX2Y,
 	usX2Y_clients_stop(usX2Y);
 }
 
-static void usX2Y_error_sequence(struct usX2Ydev *usX2Y,
-				 struct snd_usX2Y_substream *subs, struct urb *urb)
-{
-	snd_printk(KERN_ERR
-"Sequence Error!(hcd_frame=%i ep=%i%s;wait=%i,frame=%i).\n"
-"Most probably some urb of usb-frame %i is still missing.\n"
-"Cause could be too long delays in usb-hcd interrupt handling.\n",
-		   usb_get_current_frame_number(usX2Y->dev),
-		   subs->endpoint, usb_pipein(urb->pipe) ? "in" : "out",
-		   usX2Y->wait_iso_frame, urb->start_frame, usX2Y->wait_iso_frame);
-	usX2Y_clients_stop(usX2Y);
-}
-
 static void i_usX2Y_urb_complete(struct urb *urb)
 {
 	struct snd_usX2Y_substream *subs = urb->context;
@@ -328,12 +315,9 @@ static void i_usX2Y_urb_complete(struct urb *urb)
 		usX2Y_error_urb_status(usX2Y, subs, urb);
 		return;
 	}
-	if (likely((urb->start_frame & 0xFFFF) == (usX2Y->wait_iso_frame & 0xFFFF)))
-		subs->completed_urb = urb;
-	else {
-		usX2Y_error_sequence(usX2Y, subs, urb);
-		return;
-	}
+
+	subs->completed_urb = urb;
+
 	{
 		struct snd_usX2Y_substream *capsubs = usX2Y->subs[SNDRV_PCM_STREAM_CAPTURE],
 			*playbacksubs = usX2Y->subs[SNDRV_PCM_STREAM_PLAYBACK];
diff --git a/sound/usb/usx2y/usx2yhwdeppcm.c b/sound/usb/usx2y/usx2yhwdeppcm.c
index f2a1acd..814d0e8 100644
--- a/sound/usb/usx2y/usx2yhwdeppcm.c
+++ b/sound/usb/usx2y/usx2yhwdeppcm.c
@@ -244,13 +244,8 @@ static void i_usX2Y_usbpcm_urb_complete(struct urb *urb)
 		usX2Y_error_urb_status(usX2Y, subs, urb);
 		return;
 	}
-	if (likely((urb->start_frame & 0xFFFF) == (usX2Y->wait_iso_frame & 0xFFFF)))
-		subs->completed_urb = urb;
-	else {
-		usX2Y_error_sequence(usX2Y, subs, urb);
-		return;
-	}
 
+	subs->completed_urb = urb;
 	capsubs = usX2Y->subs[SNDRV_PCM_STREAM_CAPTURE];
 	capsubs2 = usX2Y->subs[SNDRV_PCM_STREAM_CAPTURE + 2];
 	playbacksubs = usX2Y->subs[SNDRV_PCM_STREAM_PLAYBACK];
-- 
1.8.1.2


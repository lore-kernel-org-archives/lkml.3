Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761495Ab3JPSEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:04:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35819 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932796Ab3JPRqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:46:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dr Nicholas J Bailey <nicholas.bailey@glasgow.ac.uk>,
        Takashi Iwai <tiwai@suse.de>, Daniel Mack <zonque@gmail.com>,
        fzu@wemgehoertderstaat.de
Subject: [ 01/50] ALSA: snd-usb-usx2y: remove bogus frame checks
Date: Wed, 16 Oct 2013 10:44:47 -0700
Message-Id: <20131016174358.529559228@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174358.335646140@linuxfoundation.org>
References: <20131016174358.335646140@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/usx2y/usbusx2yaudio.c |   22 +++-------------------
 sound/usb/usx2y/usx2yhwdeppcm.c |    7 +------
 2 files changed, 4 insertions(+), 25 deletions(-)

--- a/sound/usb/usx2y/usbusx2yaudio.c
+++ b/sound/usb/usx2y/usbusx2yaudio.c
@@ -299,19 +299,6 @@ static void usX2Y_error_urb_status(struc
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
@@ -328,12 +315,9 @@ static void i_usX2Y_urb_complete(struct
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
--- a/sound/usb/usx2y/usx2yhwdeppcm.c
+++ b/sound/usb/usx2y/usx2yhwdeppcm.c
@@ -244,13 +244,8 @@ static void i_usX2Y_usbpcm_urb_complete(
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



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab3KYOGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:06:40 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59008 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754586Ab3KYNxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:46 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Dr Nicholas J Bailey" <nicholas.bailey@glasgow.ac.uk>,
        fzu@wemgehoertderstaat.de, "Daniel Mack" <zonque@gmail.com>,
        "Takashi Iwai" <tiwai@suse.de>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.135566227@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 47/87] ALSA: snd-usb-usx2y: remove bogus frame checks
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/usb/usx2y/usbusx2yaudio.c | 22 +++-------------------
 sound/usb/usx2y/usx2yhwdeppcm.c |  7 +------
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
-"Most propably some urb of usb-frame %i is still missing.\n"
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


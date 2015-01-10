Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbbAJFix (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 00:38:53 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50094 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbbAJFhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 00:37:00 -0500
From: Chris Rorvick <chris@rorvick.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chris Rorvick <chris@rorvick.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Davide Berardi <berardi.dav@gmail.com>, devel@driverdev.osuosl.org,
        Fabian Mewes <architekt@coding4coffee.org>,
        Gulsah Kose <gulsah.1004@gmail.com>,
        Himangi Saraogi <himangi774@gmail.com>,
        Jerry Snitselaar <dev@snitselaar.org>,
        =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>,
        linux-kernel@vger.kernel.org, Mikhail Boiko <mm.boiko@yandex.ru>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Stefan Hajnoczi <stefanha@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 20/25] staging: line6: Move audio endpoints to properties
Date: Fri,  9 Jan 2015 23:36:06 -0600
Message-Id: <1420868171-2031-21-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420868171-2031-1-git-send-email-chris@rorvick.com>
References: <1420868171-2031-1-git-send-email-chris@rorvick.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device type can now be used to determine the addresses of the
audio endpoints for the interface.  Drop the conditional logic and make
these values properties.

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 drivers/staging/line6/capture.c  |  9 ++++----
 drivers/staging/line6/driver.c   | 38 +++++++++++++++++++++++++++++++
 drivers/staging/line6/driver.h   |  2 ++
 drivers/staging/line6/pcm.c      | 48 ++--------------------------------------
 drivers/staging/line6/pcm.h      | 10 ---------
 drivers/staging/line6/playback.c |  9 ++++----
 6 files changed, 52 insertions(+), 64 deletions(-)

diff --git a/drivers/staging/line6/capture.c b/drivers/staging/line6/capture.c
index e6ca631..f24c7c5 100644
--- a/drivers/staging/line6/capture.c
+++ b/drivers/staging/line6/capture.c
@@ -400,6 +400,7 @@ struct snd_pcm_ops snd_line6_capture_ops = {
 
 int line6_create_audio_in_urbs(struct snd_line6_pcm *line6pcm)
 {
+	struct usb_line6 *line6 = line6pcm->line6;
 	int i;
 
 	/* create audio URBs and fill in constant values: */
@@ -411,14 +412,14 @@ int line6_create_audio_in_urbs(struct snd_line6_pcm *line6pcm)
 		    usb_alloc_urb(LINE6_ISO_PACKETS, GFP_KERNEL);
 
 		if (urb == NULL) {
-			dev_err(line6pcm->line6->ifcdev, "Out of memory\n");
+			dev_err(line6->ifcdev, "Out of memory\n");
 			return -ENOMEM;
 		}
 
-		urb->dev = line6pcm->line6->usbdev;
+		urb->dev = line6->usbdev;
 		urb->pipe =
-		    usb_rcvisocpipe(line6pcm->line6->usbdev,
-				    line6pcm->ep_audio_read &
+		    usb_rcvisocpipe(line6->usbdev,
+				    line6->properties->ep_audio_r &
 				    USB_ENDPOINT_NUMBER_MASK);
 		urb->transfer_flags = URB_ISO_ASAP;
 		urb->start_frame = -1;
diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index 40ec57c..4bfef21 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -70,6 +70,8 @@ static const struct line6_properties line6_properties_table[] = {
 		.altsetting = 5,
 		.ep_ctrl_r = 0x84,
 		.ep_ctrl_w = 0x03,
+		.ep_audio_r = 0x82,
+		.ep_audio_w = 0x01,
 	},
 	[LINE6_BASSPODXTLIVE] = {
 		.id = "BassPODxtLive",
@@ -80,6 +82,8 @@ static const struct line6_properties line6_properties_table[] = {
 		.altsetting = 1,
 		.ep_ctrl_r = 0x84,
 		.ep_ctrl_w = 0x03,
+		.ep_audio_r = 0x82,
+		.ep_audio_w = 0x01,
 	},
 	[LINE6_BASSPODXTPRO] = {
 		.id = "BassPODxtPro",
@@ -90,6 +94,8 @@ static const struct line6_properties line6_properties_table[] = {
 		.altsetting = 5,
 		.ep_ctrl_r = 0x84,
 		.ep_ctrl_w = 0x03,
+		.ep_audio_r = 0x82,
+		.ep_audio_w = 0x01,
 	},
 	[LINE6_GUITARPORT] = {
 		.id = "GuitarPort",
@@ -97,6 +103,8 @@ static const struct line6_properties line6_properties_table[] = {
 		.capabilities	= LINE6_CAP_PCM,
 		.altsetting = 2,  /* 1..4 seem to be ok */
 		/* no control channel */
+		.ep_audio_r = 0x82,
+		.ep_audio_w = 0x01,
 	},
 	[LINE6_POCKETPOD] = {
 		.id = "PocketPOD",
@@ -105,6 +113,7 @@ static const struct line6_properties line6_properties_table[] = {
 		.altsetting = 0,
 		.ep_ctrl_r = 0x82,
 		.ep_ctrl_w = 0x02,
+		/* no audio channel */
 	},
 	[LINE6_PODHD300] = {
 		.id = "PODHD300",
@@ -115,6 +124,8 @@ static const struct line6_properties line6_properties_table[] = {
 		.altsetting = 5,
 		.ep_ctrl_r = 0x84,
 		.ep_ctrl_w = 0x03,
+		.ep_audio_r = 0x82,
+		.ep_audio_w = 0x01,
 	},
 	[LINE6_PODHD400] = {
 		.id = "PODHD400",
@@ -125,6 +136,8 @@ static const struct line6_properties line6_properties_table[] = {
 		.altsetting = 5,
 		.ep_ctrl_r = 0x84,
 		.ep_ctrl_w = 0x03,
+		.ep_audio_r = 0x82,
+		.ep_audio_w = 0x01,
 	},
 	[LINE6_PODHD500_0] = {
 		.id = "PODHD500",
@@ -135,6 +148,8 @@ static const struct line6_properties line6_properties_table[] = {
 		.altsetting = 1,
 		.ep_ctrl_r = 0x81,
 		.ep_ctrl_w = 0x01,
+		.ep_audio_r = 0x86,
+		.ep_audio_w = 0x02,
 	},
 	[LINE6_PODHD500_1] = {
 		.id = "PODHD500",
@@ -145,6 +160,8 @@ static const struct line6_properties line6_properties_table[] = {
 		.altsetting = 1,
 		.ep_ctrl_r = 0x81,
 		.ep_ctrl_w = 0x01,
+		.ep_audio_r = 0x86,
+		.ep_audio_w = 0x02,
 	},
 	[LINE6_PODSTUDIO_GX] = {
 		.id = "PODStudioGX",
@@ -152,6 +169,8 @@ static const struct line6_properties line6_properties_table[] = {
 		.capabilities	= LINE6_CAP_PCM,
 		.altsetting = 2,  /* 1..4 seem to be ok */
 		/* no control channel */
+		.ep_audio_r = 0x82,
+		.ep_audio_w = 0x01,
 	},
 	[LINE6_PODSTUDIO_UX1] = {
 		.id = "PODStudioUX1",
@@ -159,6 +178,8 @@ static const struct line6_properties line6_properties_table[] = {
 		.capabilities	= LINE6_CAP_PCM,
 		.altsetting = 2,  /* 1..4 seem to be ok */
 		/* no control channel */
+		.ep_audio_r = 0x82,
+		.ep_audio_w = 0x01,
 	},
 	[LINE6_PODSTUDIO_UX2] = {
 		.id = "PODStudioUX2",
@@ -166,6 +187,8 @@ static const struct line6_properties line6_properties_table[] = {
 		.capabilities	= LINE6_CAP_PCM,
 		.altsetting = 2,  /* defaults to 44.1kHz, 16-bit */
 		/* no control channel */
+		.ep_audio_r = 0x82,
+		.ep_audio_w = 0x01,
 	},
 	[LINE6_PODXT] = {
 		.id = "PODxt",
@@ -176,6 +199,8 @@ static const struct line6_properties line6_properties_table[] = {
 		.altsetting = 5,
 		.ep_ctrl_r = 0x84,
 		.ep_ctrl_w = 0x03,
+		.ep_audio_r = 0x82,
+		.ep_audio_w = 0x01,
 	},
 	[LINE6_PODXTLIVE_POD] = {
 		.id = "PODxtLive",
@@ -186,6 +211,8 @@ static const struct line6_properties line6_properties_table[] = {
 		.altsetting = 1,
 		.ep_ctrl_r = 0x84,
 		.ep_ctrl_w = 0x03,
+		.ep_audio_r = 0x82,
+		.ep_audio_w = 0x01,
 	},
 	[LINE6_PODXTLIVE_VARIAX] = {
 		.id = "PODxtLive",
@@ -196,6 +223,8 @@ static const struct line6_properties line6_properties_table[] = {
 		.altsetting = 1,
 		.ep_ctrl_r = 0x86,
 		.ep_ctrl_w = 0x05,
+		.ep_audio_r = 0x82,
+		.ep_audio_w = 0x01,
 	},
 	[LINE6_PODXTPRO] = {
 		.id = "PODxtPro",
@@ -206,6 +235,8 @@ static const struct line6_properties line6_properties_table[] = {
 		.altsetting = 5,
 		.ep_ctrl_r = 0x84,
 		.ep_ctrl_w = 0x03,
+		.ep_audio_r = 0x82,
+		.ep_audio_w = 0x01,
 	},
 	[LINE6_TONEPORT_GX] = {
 		.id = "TonePortGX",
@@ -213,6 +244,8 @@ static const struct line6_properties line6_properties_table[] = {
 		.capabilities	= LINE6_CAP_PCM,
 		.altsetting = 2,  /* 1..4 seem to be ok */
 		/* no control channel */
+		.ep_audio_r = 0x82,
+		.ep_audio_w = 0x01,
 	},
 	[LINE6_TONEPORT_UX1] = {
 		.id = "TonePortUX1",
@@ -220,6 +253,8 @@ static const struct line6_properties line6_properties_table[] = {
 		.capabilities	= LINE6_CAP_PCM,
 		.altsetting = 2,  /* 1..4 seem to be ok */
 		/* no control channel */
+		.ep_audio_r = 0x82,
+		.ep_audio_w = 0x01,
 	},
 	[LINE6_TONEPORT_UX2] = {
 		.id = "TonePortUX2",
@@ -227,6 +262,8 @@ static const struct line6_properties line6_properties_table[] = {
 		.capabilities	= LINE6_CAP_PCM,
 		.altsetting = 2,  /* defaults to 44.1kHz, 16-bit */
 		/* no control channel */
+		.ep_audio_r = 0x82,
+		.ep_audio_w = 0x01,
 	},
 	[LINE6_VARIAX] = {
 		.id = "Variax",
@@ -235,6 +272,7 @@ static const struct line6_properties line6_properties_table[] = {
 		.altsetting = 1,
 		.ep_ctrl_r = 0x82,
 		.ep_ctrl_w = 0x01,
+		/* no audio channel */
 	}
 };
 
diff --git a/drivers/staging/line6/driver.h b/drivers/staging/line6/driver.h
index a0555f4..a4bde71 100644
--- a/drivers/staging/line6/driver.h
+++ b/drivers/staging/line6/driver.h
@@ -120,6 +120,8 @@ struct line6_properties {
 
 	unsigned ep_ctrl_r;
 	unsigned ep_ctrl_w;
+	unsigned ep_audio_r;
+	unsigned ep_audio_w;
 };
 
 /**
diff --git a/drivers/staging/line6/pcm.c b/drivers/staging/line6/pcm.c
index 19aa927..6d4e5cd 100644
--- a/drivers/staging/line6/pcm.c
+++ b/drivers/staging/line6/pcm.c
@@ -421,55 +421,13 @@ int line6_init_pcm(struct usb_line6 *line6,
 	};
 
 	int err;
-	int ep_read = 0, ep_write = 0;
+	unsigned ep_read = line6->properties->ep_audio_r;
+	unsigned ep_write = line6->properties->ep_audio_w;
 	struct snd_line6_pcm *line6pcm;
 
 	if (!(line6->properties->capabilities & LINE6_CAP_PCM))
 		return 0;	/* skip PCM initialization and report success */
 
-	/* initialize PCM subsystem based on device: */
-	switch (line6->type) {
-	case LINE6_BASSPODXT:
-	case LINE6_BASSPODXTLIVE:
-	case LINE6_BASSPODXTPRO:
-	case LINE6_PODXT:
-	case LINE6_PODXTLIVE_POD:
-	case LINE6_PODXTLIVE_VARIAX:
-	case LINE6_PODXTPRO:
-	case LINE6_PODHD300:
-	case LINE6_PODHD400:
-		ep_read = 0x82;
-		ep_write = 0x01;
-		break;
-
-	case LINE6_PODHD500_0:
-	case LINE6_PODHD500_1:
-		ep_read = 0x86;
-		ep_write = 0x02;
-		break;
-
-	case LINE6_GUITARPORT:
-	case LINE6_PODSTUDIO_GX:
-	case LINE6_PODSTUDIO_UX1:
-	case LINE6_PODSTUDIO_UX2:
-	case LINE6_TONEPORT_GX:
-	case LINE6_TONEPORT_UX1:
-	case LINE6_TONEPORT_UX2:
-		ep_read = 0x82;
-		ep_write = 0x01;
-		break;
-
-	/* this is for interface_number == 1:
-	case LINE6_DEVID_TONEPORT_UX2:
-	case LINE6_DEVID_PODSTUDIO_UX2:
-		ep_read  = 0x87;
-		ep_write = 0x00;
-		break; */
-
-	default:
-		MISSING_CASE;
-	}
-
 	line6pcm = kzalloc(sizeof(*line6pcm), GFP_KERNEL);
 
 	if (line6pcm == NULL)
@@ -478,8 +436,6 @@ int line6_init_pcm(struct usb_line6 *line6,
 	line6pcm->volume_playback[0] = line6pcm->volume_playback[1] = 255;
 	line6pcm->volume_monitor = 255;
 	line6pcm->line6 = line6;
-	line6pcm->ep_audio_read = ep_read;
-	line6pcm->ep_audio_write = ep_write;
 
 	/* Read and write buffers are sized identically, so choose minimum */
 	line6pcm->max_packet_size = min(
diff --git a/drivers/staging/line6/pcm.h b/drivers/staging/line6/pcm.h
index 5716f16..cddfd06 100644
--- a/drivers/staging/line6/pcm.h
+++ b/drivers/staging/line6/pcm.h
@@ -297,16 +297,6 @@ struct snd_line6_pcm {
 	int max_packet_size;
 
 	/**
-		 USB endpoint for listening to audio data.
-	*/
-	int ep_audio_read;
-
-	/**
-		 USB endpoint for writing audio data.
-	*/
-	int ep_audio_write;
-
-	/**
 		 Bit mask of active capture URBs.
 	*/
 	unsigned long active_urb_in;
diff --git a/drivers/staging/line6/playback.c b/drivers/staging/line6/playback.c
index 54b7f60..da2e3b8 100644
--- a/drivers/staging/line6/playback.c
+++ b/drivers/staging/line6/playback.c
@@ -560,6 +560,7 @@ struct snd_pcm_ops snd_line6_playback_ops = {
 
 int line6_create_audio_out_urbs(struct snd_line6_pcm *line6pcm)
 {
+	struct usb_line6 *line6 = line6pcm->line6;
 	int i;
 
 	/* create audio URBs and fill in constant values: */
@@ -571,14 +572,14 @@ int line6_create_audio_out_urbs(struct snd_line6_pcm *line6pcm)
 		    usb_alloc_urb(LINE6_ISO_PACKETS, GFP_KERNEL);
 
 		if (urb == NULL) {
-			dev_err(line6pcm->line6->ifcdev, "Out of memory\n");
+			dev_err(line6->ifcdev, "Out of memory\n");
 			return -ENOMEM;
 		}
 
-		urb->dev = line6pcm->line6->usbdev;
+		urb->dev = line6->usbdev;
 		urb->pipe =
-		    usb_sndisocpipe(line6pcm->line6->usbdev,
-				    line6pcm->ep_audio_write &
+		    usb_sndisocpipe(line6->usbdev,
+				    line6->properties->ep_audio_w &
 				    USB_ENDPOINT_NUMBER_MASK);
 		urb->transfer_flags = URB_ISO_ASAP;
 		urb->start_frame = -1;
-- 
2.1.0


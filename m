Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbbAJFhB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 00:37:01 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:61928 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbbAJFg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 00:36:57 -0500
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
Subject: [PATCH 18/25] staging: line6: Move control endpoints to properties
Date: Fri,  9 Jan 2015 23:36:04 -0600
Message-Id: <1420868171-2031-19-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420868171-2031-1-git-send-email-chris@rorvick.com>
References: <1420868171-2031-1-git-send-email-chris@rorvick.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device type can now be used to determine the addresses of the
control endpoints for the interface.  Drop the conditional logic and
make these values properties.

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 drivers/staging/line6/driver.c | 73 +++++++++++++++++++++++++-----------------
 drivers/staging/line6/driver.h | 13 ++------
 drivers/staging/line6/midi.c   |  2 +-
 3 files changed, 48 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index 0150470..40ec57c 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -68,6 +68,8 @@ static const struct line6_properties line6_properties_table[] = {
 				| LINE6_CAP_PCM
 				| LINE6_CAP_HWMON,
 		.altsetting = 5,
+		.ep_ctrl_r = 0x84,
+		.ep_ctrl_w = 0x03,
 	},
 	[LINE6_BASSPODXTLIVE] = {
 		.id = "BassPODxtLive",
@@ -76,6 +78,8 @@ static const struct line6_properties line6_properties_table[] = {
 				| LINE6_CAP_PCM
 				| LINE6_CAP_HWMON,
 		.altsetting = 1,
+		.ep_ctrl_r = 0x84,
+		.ep_ctrl_w = 0x03,
 	},
 	[LINE6_BASSPODXTPRO] = {
 		.id = "BassPODxtPro",
@@ -84,18 +88,23 @@ static const struct line6_properties line6_properties_table[] = {
 				| LINE6_CAP_PCM
 				| LINE6_CAP_HWMON,
 		.altsetting = 5,
+		.ep_ctrl_r = 0x84,
+		.ep_ctrl_w = 0x03,
 	},
 	[LINE6_GUITARPORT] = {
 		.id = "GuitarPort",
 		.name = "GuitarPort",
 		.capabilities	= LINE6_CAP_PCM,
 		.altsetting = 2,  /* 1..4 seem to be ok */
+		/* no control channel */
 	},
 	[LINE6_POCKETPOD] = {
 		.id = "PocketPOD",
 		.name = "Pocket POD",
 		.capabilities	= LINE6_CAP_CONTROL,
 		.altsetting = 0,
+		.ep_ctrl_r = 0x82,
+		.ep_ctrl_w = 0x02,
 	},
 	[LINE6_PODHD300] = {
 		.id = "PODHD300",
@@ -104,6 +113,8 @@ static const struct line6_properties line6_properties_table[] = {
 				| LINE6_CAP_PCM
 				| LINE6_CAP_HWMON,
 		.altsetting = 5,
+		.ep_ctrl_r = 0x84,
+		.ep_ctrl_w = 0x03,
 	},
 	[LINE6_PODHD400] = {
 		.id = "PODHD400",
@@ -112,6 +123,8 @@ static const struct line6_properties line6_properties_table[] = {
 				| LINE6_CAP_PCM
 				| LINE6_CAP_HWMON,
 		.altsetting = 5,
+		.ep_ctrl_r = 0x84,
+		.ep_ctrl_w = 0x03,
 	},
 	[LINE6_PODHD500_0] = {
 		.id = "PODHD500",
@@ -120,6 +133,8 @@ static const struct line6_properties line6_properties_table[] = {
 				| LINE6_CAP_PCM
 				| LINE6_CAP_HWMON,
 		.altsetting = 1,
+		.ep_ctrl_r = 0x81,
+		.ep_ctrl_w = 0x01,
 	},
 	[LINE6_PODHD500_1] = {
 		.id = "PODHD500",
@@ -128,24 +143,29 @@ static const struct line6_properties line6_properties_table[] = {
 				| LINE6_CAP_PCM
 				| LINE6_CAP_HWMON,
 		.altsetting = 1,
+		.ep_ctrl_r = 0x81,
+		.ep_ctrl_w = 0x01,
 	},
 	[LINE6_PODSTUDIO_GX] = {
 		.id = "PODStudioGX",
 		.name = "POD Studio GX",
 		.capabilities	= LINE6_CAP_PCM,
 		.altsetting = 2,  /* 1..4 seem to be ok */
+		/* no control channel */
 	},
 	[LINE6_PODSTUDIO_UX1] = {
 		.id = "PODStudioUX1",
 		.name = "POD Studio UX1",
 		.capabilities	= LINE6_CAP_PCM,
 		.altsetting = 2,  /* 1..4 seem to be ok */
+		/* no control channel */
 	},
 	[LINE6_PODSTUDIO_UX2] = {
 		.id = "PODStudioUX2",
 		.name = "POD Studio UX2",
 		.capabilities	= LINE6_CAP_PCM,
 		.altsetting = 2,  /* defaults to 44.1kHz, 16-bit */
+		/* no control channel */
 	},
 	[LINE6_PODXT] = {
 		.id = "PODxt",
@@ -154,6 +174,8 @@ static const struct line6_properties line6_properties_table[] = {
 				| LINE6_CAP_PCM
 				| LINE6_CAP_HWMON,
 		.altsetting = 5,
+		.ep_ctrl_r = 0x84,
+		.ep_ctrl_w = 0x03,
 	},
 	[LINE6_PODXTLIVE_POD] = {
 		.id = "PODxtLive",
@@ -162,6 +184,8 @@ static const struct line6_properties line6_properties_table[] = {
 				| LINE6_CAP_PCM
 				| LINE6_CAP_HWMON,
 		.altsetting = 1,
+		.ep_ctrl_r = 0x84,
+		.ep_ctrl_w = 0x03,
 	},
 	[LINE6_PODXTLIVE_VARIAX] = {
 		.id = "PODxtLive",
@@ -170,6 +194,8 @@ static const struct line6_properties line6_properties_table[] = {
 				| LINE6_CAP_PCM
 				| LINE6_CAP_HWMON,
 		.altsetting = 1,
+		.ep_ctrl_r = 0x86,
+		.ep_ctrl_w = 0x05,
 	},
 	[LINE6_PODXTPRO] = {
 		.id = "PODxtPro",
@@ -178,30 +204,37 @@ static const struct line6_properties line6_properties_table[] = {
 				| LINE6_CAP_PCM
 				| LINE6_CAP_HWMON,
 		.altsetting = 5,
+		.ep_ctrl_r = 0x84,
+		.ep_ctrl_w = 0x03,
 	},
 	[LINE6_TONEPORT_GX] = {
 		.id = "TonePortGX",
 		.name = "TonePort GX",
 		.capabilities	= LINE6_CAP_PCM,
 		.altsetting = 2,  /* 1..4 seem to be ok */
+		/* no control channel */
 	},
 	[LINE6_TONEPORT_UX1] = {
 		.id = "TonePortUX1",
 		.name = "TonePort UX1",
 		.capabilities	= LINE6_CAP_PCM,
 		.altsetting = 2,  /* 1..4 seem to be ok */
+		/* no control channel */
 	},
 	[LINE6_TONEPORT_UX2] = {
 		.id = "TonePortUX2",
 		.name = "TonePort UX2",
 		.capabilities	= LINE6_CAP_PCM,
 		.altsetting = 2,  /* defaults to 44.1kHz, 16-bit */
+		/* no control channel */
 	},
 	[LINE6_VARIAX] = {
 		.id = "Variax",
 		.name = "Variax Workbench",
 		.capabilities	= LINE6_CAP_CONTROL,
 		.altsetting = 1,
+		.ep_ctrl_r = 0x82,
+		.ep_ctrl_w = 0x01,
 	}
 };
 
@@ -245,9 +278,9 @@ static int line6_start_listen(struct usb_line6 *line6)
 	int err;
 
 	usb_fill_int_urb(line6->urb_listen, line6->usbdev,
-			 usb_rcvintpipe(line6->usbdev, line6->ep_control_read),
-			 line6->buffer_listen, LINE6_BUFSIZE_LISTEN,
-			 line6_data_received, line6, line6->interval);
+		usb_rcvintpipe(line6->usbdev, line6->properties->ep_ctrl_r),
+		line6->buffer_listen, LINE6_BUFSIZE_LISTEN,
+		line6_data_received, line6, line6->interval);
 	line6->urb_listen->actual_length = 0;
 	err = usb_submit_urb(line6->urb_listen, GFP_ATOMIC);
 	return err;
@@ -277,7 +310,7 @@ int line6_send_raw_message(struct usb_line6 *line6, const char *buffer,
 
 		retval = usb_interrupt_msg(line6->usbdev,
 					usb_sndintpipe(line6->usbdev,
-						line6->ep_control_write),
+						line6->properties->ep_ctrl_w),
 					(char *)frag_buf, frag_size,
 					&partial, LINE6_TIMEOUT * HZ);
 
@@ -319,9 +352,9 @@ static int line6_send_raw_message_async_part(struct message *msg,
 	int bytes = min(msg->size - done, line6->max_packet_size);
 
 	usb_fill_int_urb(urb, line6->usbdev,
-			 usb_sndintpipe(line6->usbdev, line6->ep_control_write),
-			 (char *)msg->buffer + done, bytes,
-			 line6_async_request_sent, msg, line6->interval);
+		usb_sndintpipe(line6->usbdev, line6->properties->ep_ctrl_w),
+		(char *)msg->buffer + done, bytes,
+		line6_async_request_sent, msg, line6->interval);
 
 	msg->done += bytes;
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
@@ -525,7 +558,7 @@ int line6_send_program(struct usb_line6 *line6, u8 value)
 
 	retval = usb_interrupt_msg(line6->usbdev,
 				   usb_sndintpipe(line6->usbdev,
-						  line6->ep_control_write),
+						  line6->properties->ep_ctrl_w),
 				   buffer, 2, &partial, LINE6_TIMEOUT * HZ);
 
 	if (retval)
@@ -555,7 +588,7 @@ int line6_transmit_parameter(struct usb_line6 *line6, int param, u8 value)
 
 	retval = usb_interrupt_msg(line6->usbdev,
 				   usb_sndintpipe(line6->usbdev,
-						  line6->ep_control_write),
+						  line6->properties->ep_ctrl_w),
 				   buffer, 3, &partial, LINE6_TIMEOUT * HZ);
 
 	if (retval)
@@ -725,7 +758,6 @@ static int line6_probe(struct usb_interface *interface,
 	const struct line6_properties *properties;
 	int interface_number;
 	int size = 0;
-	int ep_read = 0, ep_write = 0;
 	int ret;
 
 	if (interface == NULL)
@@ -764,28 +796,20 @@ static int line6_probe(struct usb_interface *interface,
 	case LINE6_PODXT:
 	case LINE6_PODXTPRO:
 		size = sizeof(struct usb_line6_pod);
-		ep_read = 0x84;
-		ep_write = 0x03;
 		break;
 
 	case LINE6_PODHD300:
 	case LINE6_PODHD400:
 		size = sizeof(struct usb_line6_podhd);
-		ep_read = 0x84;
-		ep_write = 0x03;
 		break;
 
 	case LINE6_PODHD500_0:
 	case LINE6_PODHD500_1:
 		size = sizeof(struct usb_line6_podhd);
-		ep_read = 0x81;
-		ep_write = 0x01;
 		break;
 
 	case LINE6_POCKETPOD:
 		size = sizeof(struct usb_line6_pod);
-		ep_read = 0x82;
-		ep_write = 0x02;
 		break;
 
 	case LINE6_PODSTUDIO_GX:
@@ -796,25 +820,18 @@ static int line6_probe(struct usb_interface *interface,
 	case LINE6_TONEPORT_UX2:
 	case LINE6_GUITARPORT:
 		size = sizeof(struct usb_line6_toneport);
-		/* these don't have a control channel */
 		break;
 
 	case LINE6_PODXTLIVE_POD:
 		size = sizeof(struct usb_line6_pod);
-		ep_read = 0x84;
-		ep_write = 0x03;
 		break;
 
 	case LINE6_PODXTLIVE_VARIAX:
 		size = sizeof(struct usb_line6_variax);
-		ep_read = 0x86;
-		ep_write = 0x05;
 		break;
 
 	case LINE6_VARIAX:
 		size = sizeof(struct usb_line6_variax);
-		ep_read = 0x82;
-		ep_write = 0x01;
 		break;
 
 	default:
@@ -840,15 +857,13 @@ static int line6_probe(struct usb_interface *interface,
 	line6->properties = properties;
 	line6->usbdev = usbdev;
 	line6->ifcdev = &interface->dev;
-	line6->ep_control_read = ep_read;
-	line6->ep_control_write = ep_write;
 	line6->type = devtype;
 
 	/* get data from endpoint descriptor (see usb_maxpacket): */
 	{
 		struct usb_host_endpoint *ep;
-		unsigned epnum =
-		    usb_pipeendpoint(usb_rcvintpipe(usbdev, ep_read));
+		unsigned pipe = usb_rcvintpipe(usbdev, properties->ep_ctrl_r);
+		unsigned epnum = usb_pipeendpoint(pipe);
 		ep = usbdev->ep_in[epnum];
 
 		if (ep != NULL) {
diff --git a/drivers/staging/line6/driver.h b/drivers/staging/line6/driver.h
index 97d6be1..a0555f4 100644
--- a/drivers/staging/line6/driver.h
+++ b/drivers/staging/line6/driver.h
@@ -117,6 +117,9 @@ struct line6_properties {
 	int capabilities;
 
 	int altsetting;
+
+	unsigned ep_ctrl_r;
+	unsigned ep_ctrl_w;
 };
 
 /**
@@ -171,16 +174,6 @@ struct usb_line6 {
 	struct snd_line6_midi *line6midi;
 
 	/**
-		 USB endpoint for listening to control commands.
-	*/
-	int ep_control_read;
-
-	/**
-		 USB endpoint for writing control commands.
-	*/
-	int ep_control_write;
-
-	/**
 		 URB for listening to PODxt Pro control endpoint.
 	*/
 	struct urb *urb_listen;
diff --git a/drivers/staging/line6/midi.c b/drivers/staging/line6/midi.c
index c453485..c9d725a 100644
--- a/drivers/staging/line6/midi.c
+++ b/drivers/staging/line6/midi.c
@@ -136,7 +136,7 @@ static int send_midi_async(struct usb_line6 *line6, unsigned char *data,
 
 	usb_fill_int_urb(urb, line6->usbdev,
 			 usb_sndbulkpipe(line6->usbdev,
-					 line6->ep_control_write),
+					 line6->properties->ep_ctrl_w),
 			 transfer_buffer, length, midi_sent, line6,
 			 line6->interval);
 	urb->actual_length = 0;
-- 
2.1.0


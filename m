Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584AbbAJFmg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 00:42:36 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:47542 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbbAJFgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 00:36:39 -0500
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
Subject: [PATCH 07/25] staging: line6: Key off of device type
Date: Fri,  9 Jan 2015 23:35:53 -0600
Message-Id: <1420868171-2031-8-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420868171-2031-1-git-send-email-chris@rorvick.com>
References: <1420868171-2031-1-git-send-email-chris@rorvick.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver currently uses the device's idProduct as input to several
switch statements.  In some cases this is not sufficiently granular and
the interface number must be taken into account.

Store the device type in `usb_line6' and key off of it instead.  New
types can then be added that map to specific interfaces on the device so
that this conditional logic can be flattened out.

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 drivers/staging/line6/driver.c   | 203 ++++++++++++++++++++-------------------
 drivers/staging/line6/driver.h   |   4 +-
 drivers/staging/line6/pcm.c      |  38 ++++----
 drivers/staging/line6/toneport.c |  42 ++++----
 4 files changed, 144 insertions(+), 143 deletions(-)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index c090b2b..81d5a27 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -363,23 +363,23 @@ static void line6_data_received(struct urb *urb)
 		line6->message_length = done;
 		line6_midi_receive(line6, line6->buffer_message, done);
 
-		switch (le16_to_cpu(line6->usbdev->descriptor.idProduct)) {
-		case LINE6_DEVID_BASSPODXT:
-		case LINE6_DEVID_BASSPODXTLIVE:
-		case LINE6_DEVID_BASSPODXTPRO:
-		case LINE6_DEVID_PODXT:
-		case LINE6_DEVID_PODXTPRO:
-		case LINE6_DEVID_POCKETPOD:
+		switch (line6->type) {
+		case LINE6_BASSPODXT:
+		case LINE6_BASSPODXTLIVE:
+		case LINE6_BASSPODXTPRO:
+		case LINE6_PODXT:
+		case LINE6_PODXTPRO:
+		case LINE6_POCKETPOD:
 			line6_pod_process_message((struct usb_line6_pod *)
 						  line6);
 			break;
 
-		case LINE6_DEVID_PODHD300:
-		case LINE6_DEVID_PODHD400:
-		case LINE6_DEVID_PODHD500:
+		case LINE6_PODHD300:
+		case LINE6_PODHD400:
+		case LINE6_PODHD500:
 			break; /* let userspace handle MIDI */
 
-		case LINE6_DEVID_PODXTLIVE:
+		case LINE6_PODXTLIVE:
 			switch (line6->interface_number) {
 			case PODXTLIVE_INTERFACE_POD:
 				line6_pod_process_message((struct usb_line6_pod
@@ -399,7 +399,7 @@ static void line6_data_received(struct urb *urb)
 			}
 			break;
 
-		case LINE6_DEVID_VARIAX:
+		case LINE6_VARIAX:
 			line6_variax_process_message((struct usb_line6_variax *)
 						     line6);
 			break;
@@ -629,7 +629,6 @@ static int line6_probe(struct usb_interface *interface,
 	struct usb_line6 *line6;
 	const struct line6_properties *properties;
 	int interface_number, alternate = 0;
-	int product;
 	int size = 0;
 	int ep_read = 0, ep_write = 0;
 	int ret;
@@ -651,19 +650,18 @@ static int line6_probe(struct usb_interface *interface,
 	/* initialize device info: */
 	properties = &line6_properties_table[devtype];
 	dev_info(&interface->dev, "Line6 %s found\n", properties->name);
-	product = le16_to_cpu(usbdev->descriptor.idProduct);
 
 	/* query interface number */
 	interface_number = interface->cur_altsetting->desc.bInterfaceNumber;
 
-	switch (product) {
-	case LINE6_DEVID_BASSPODXTLIVE:
-	case LINE6_DEVID_PODXTLIVE:
-	case LINE6_DEVID_VARIAX:
+	switch (devtype) {
+	case LINE6_BASSPODXTLIVE:
+	case LINE6_PODXTLIVE:
+	case LINE6_VARIAX:
 		alternate = 1;
 		break;
 
-	case LINE6_DEVID_POCKETPOD:
+	case LINE6_POCKETPOD:
 		switch (interface_number) {
 		case 0:
 			return -ENODEV;	/* this interface has no endpoints */
@@ -675,7 +673,7 @@ static int line6_probe(struct usb_interface *interface,
 		}
 		break;
 
-	case LINE6_DEVID_PODHD500:
+	case LINE6_PODHD500:
 		switch (interface_number) {
 		case 0:
 			alternate = 1;
@@ -688,25 +686,25 @@ static int line6_probe(struct usb_interface *interface,
 		}
 		break;
 
-	case LINE6_DEVID_BASSPODXT:
-	case LINE6_DEVID_BASSPODXTPRO:
-	case LINE6_DEVID_PODXT:
-	case LINE6_DEVID_PODXTPRO:
-	case LINE6_DEVID_PODHD300:
-	case LINE6_DEVID_PODHD400:
+	case LINE6_BASSPODXT:
+	case LINE6_BASSPODXTPRO:
+	case LINE6_PODXT:
+	case LINE6_PODXTPRO:
+	case LINE6_PODHD300:
+	case LINE6_PODHD400:
 		alternate = 5;
 		break;
 
-	case LINE6_DEVID_GUITARPORT:
-	case LINE6_DEVID_PODSTUDIO_GX:
-	case LINE6_DEVID_PODSTUDIO_UX1:
-	case LINE6_DEVID_TONEPORT_GX:
-	case LINE6_DEVID_TONEPORT_UX1:
+	case LINE6_GUITARPORT:
+	case LINE6_PODSTUDIO_GX:
+	case LINE6_PODSTUDIO_UX1:
+	case LINE6_TONEPORT_GX:
+	case LINE6_TONEPORT_UX1:
 		alternate = 2;	/* 1..4 seem to be ok */
 		break;
 
-	case LINE6_DEVID_TONEPORT_UX2:
-	case LINE6_DEVID_PODSTUDIO_UX2:
+	case LINE6_TONEPORT_UX2:
+	case LINE6_PODSTUDIO_UX2:
 		switch (interface_number) {
 		case 0:
 			/* defaults to 44.1kHz, 16-bit */
@@ -735,49 +733,49 @@ static int line6_probe(struct usb_interface *interface,
 		goto err_put;
 	}
 
-	/* initialize device data based on product id: */
-	switch (product) {
-	case LINE6_DEVID_BASSPODXT:
-	case LINE6_DEVID_BASSPODXTLIVE:
-	case LINE6_DEVID_BASSPODXTPRO:
-	case LINE6_DEVID_PODXT:
-	case LINE6_DEVID_PODXTPRO:
+	/* initialize device data based on device: */
+	switch (devtype) {
+	case LINE6_BASSPODXT:
+	case LINE6_BASSPODXTLIVE:
+	case LINE6_BASSPODXTPRO:
+	case LINE6_PODXT:
+	case LINE6_PODXTPRO:
 		size = sizeof(struct usb_line6_pod);
 		ep_read = 0x84;
 		ep_write = 0x03;
 		break;
 
-	case LINE6_DEVID_PODHD300:
-	case LINE6_DEVID_PODHD400:
+	case LINE6_PODHD300:
+	case LINE6_PODHD400:
 		size = sizeof(struct usb_line6_podhd);
 		ep_read = 0x84;
 		ep_write = 0x03;
 		break;
 
-	case LINE6_DEVID_PODHD500:
+	case LINE6_PODHD500:
 		size = sizeof(struct usb_line6_podhd);
 		ep_read = 0x81;
 		ep_write = 0x01;
 		break;
 
-	case LINE6_DEVID_POCKETPOD:
+	case LINE6_POCKETPOD:
 		size = sizeof(struct usb_line6_pod);
 		ep_read = 0x82;
 		ep_write = 0x02;
 		break;
 
-	case LINE6_DEVID_PODSTUDIO_GX:
-	case LINE6_DEVID_PODSTUDIO_UX1:
-	case LINE6_DEVID_PODSTUDIO_UX2:
-	case LINE6_DEVID_TONEPORT_GX:
-	case LINE6_DEVID_TONEPORT_UX1:
-	case LINE6_DEVID_TONEPORT_UX2:
-	case LINE6_DEVID_GUITARPORT:
+	case LINE6_PODSTUDIO_GX:
+	case LINE6_PODSTUDIO_UX1:
+	case LINE6_PODSTUDIO_UX2:
+	case LINE6_TONEPORT_GX:
+	case LINE6_TONEPORT_UX1:
+	case LINE6_TONEPORT_UX2:
+	case LINE6_GUITARPORT:
 		size = sizeof(struct usb_line6_toneport);
 		/* these don't have a control channel */
 		break;
 
-	case LINE6_DEVID_PODXTLIVE:
+	case LINE6_PODXTLIVE:
 		switch (interface_number) {
 		case PODXTLIVE_INTERFACE_POD:
 			size = sizeof(struct usb_line6_pod);
@@ -797,7 +795,7 @@ static int line6_probe(struct usb_interface *interface,
 		}
 		break;
 
-	case LINE6_DEVID_VARIAX:
+	case LINE6_VARIAX:
 		size = sizeof(struct usb_line6_variax);
 		ep_read = 0x82;
 		ep_write = 0x01;
@@ -829,7 +827,7 @@ static int line6_probe(struct usb_interface *interface,
 	line6->ifcdev = &interface->dev;
 	line6->ep_control_read = ep_read;
 	line6->ep_control_write = ep_write;
-	line6->product = product;
+	line6->type = devtype;
 
 	/* get data from endpoint descriptor (see usb_maxpacket): */
 	{
@@ -885,25 +883,25 @@ static int line6_probe(struct usb_interface *interface,
 		}
 	}
 
-	/* initialize device data based on product id: */
-	switch (product) {
-	case LINE6_DEVID_BASSPODXT:
-	case LINE6_DEVID_BASSPODXTLIVE:
-	case LINE6_DEVID_BASSPODXTPRO:
-	case LINE6_DEVID_POCKETPOD:
-	case LINE6_DEVID_PODXT:
-	case LINE6_DEVID_PODXTPRO:
+	/* initialize device data based on device: */
+	switch (devtype) {
+	case LINE6_BASSPODXT:
+	case LINE6_BASSPODXTLIVE:
+	case LINE6_BASSPODXTPRO:
+	case LINE6_POCKETPOD:
+	case LINE6_PODXT:
+	case LINE6_PODXTPRO:
 		ret = line6_pod_init(interface, (struct usb_line6_pod *)line6);
 		break;
 
-	case LINE6_DEVID_PODHD300:
-	case LINE6_DEVID_PODHD400:
-	case LINE6_DEVID_PODHD500:
+	case LINE6_PODHD300:
+	case LINE6_PODHD400:
+	case LINE6_PODHD500:
 		ret = line6_podhd_init(interface,
 				       (struct usb_line6_podhd *)line6);
 		break;
 
-	case LINE6_DEVID_PODXTLIVE:
+	case LINE6_PODXTLIVE:
 		switch (interface_number) {
 		case PODXTLIVE_INTERFACE_POD:
 			ret =
@@ -926,19 +924,19 @@ static int line6_probe(struct usb_interface *interface,
 
 		break;
 
-	case LINE6_DEVID_VARIAX:
+	case LINE6_VARIAX:
 		ret =
 		    line6_variax_init(interface,
 				      (struct usb_line6_variax *)line6);
 		break;
 
-	case LINE6_DEVID_PODSTUDIO_GX:
-	case LINE6_DEVID_PODSTUDIO_UX1:
-	case LINE6_DEVID_PODSTUDIO_UX2:
-	case LINE6_DEVID_TONEPORT_GX:
-	case LINE6_DEVID_TONEPORT_UX1:
-	case LINE6_DEVID_TONEPORT_UX2:
-	case LINE6_DEVID_GUITARPORT:
+	case LINE6_PODSTUDIO_GX:
+	case LINE6_PODSTUDIO_UX1:
+	case LINE6_PODSTUDIO_UX2:
+	case LINE6_TONEPORT_GX:
+	case LINE6_TONEPORT_UX1:
+	case LINE6_TONEPORT_UX2:
+	case LINE6_GUITARPORT:
 		ret =
 		    line6_toneport_init(interface,
 					(struct usb_line6_toneport *)line6);
@@ -1004,23 +1002,23 @@ static void line6_disconnect(struct usb_interface *interface)
 			dev_err(line6->ifcdev,
 				"driver bug: inconsistent usb device\n");
 
-		switch (le16_to_cpu(line6->usbdev->descriptor.idProduct)) {
-		case LINE6_DEVID_BASSPODXT:
-		case LINE6_DEVID_BASSPODXTLIVE:
-		case LINE6_DEVID_BASSPODXTPRO:
-		case LINE6_DEVID_POCKETPOD:
-		case LINE6_DEVID_PODXT:
-		case LINE6_DEVID_PODXTPRO:
+		switch (line6->type) {
+		case LINE6_BASSPODXT:
+		case LINE6_BASSPODXTLIVE:
+		case LINE6_BASSPODXTPRO:
+		case LINE6_POCKETPOD:
+		case LINE6_PODXT:
+		case LINE6_PODXTPRO:
 			line6_pod_disconnect(interface);
 			break;
 
-		case LINE6_DEVID_PODHD300:
-		case LINE6_DEVID_PODHD400:
-		case LINE6_DEVID_PODHD500:
+		case LINE6_PODHD300:
+		case LINE6_PODHD400:
+		case LINE6_PODHD500:
 			line6_podhd_disconnect(interface);
 			break;
 
-		case LINE6_DEVID_PODXTLIVE:
+		case LINE6_PODXTLIVE:
 			switch (interface_number) {
 			case PODXTLIVE_INTERFACE_POD:
 				line6_pod_disconnect(interface);
@@ -1033,17 +1031,17 @@ static void line6_disconnect(struct usb_interface *interface)
 
 			break;
 
-		case LINE6_DEVID_VARIAX:
+		case LINE6_VARIAX:
 			line6_variax_disconnect(interface);
 			break;
 
-		case LINE6_DEVID_PODSTUDIO_GX:
-		case LINE6_DEVID_PODSTUDIO_UX1:
-		case LINE6_DEVID_PODSTUDIO_UX2:
-		case LINE6_DEVID_TONEPORT_GX:
-		case LINE6_DEVID_TONEPORT_UX1:
-		case LINE6_DEVID_TONEPORT_UX2:
-		case LINE6_DEVID_GUITARPORT:
+		case LINE6_PODSTUDIO_GX:
+		case LINE6_PODSTUDIO_UX1:
+		case LINE6_PODSTUDIO_UX2:
+		case LINE6_TONEPORT_GX:
+		case LINE6_TONEPORT_UX1:
+		case LINE6_TONEPORT_UX2:
+		case LINE6_GUITARPORT:
 			line6_toneport_disconnect(interface);
 			break;
 
@@ -1107,15 +1105,18 @@ static int line6_reset_resume(struct usb_interface *interface)
 {
 	struct usb_line6 *line6 = usb_get_intfdata(interface);
 
-	switch (le16_to_cpu(line6->usbdev->descriptor.idProduct)) {
-	case LINE6_DEVID_PODSTUDIO_GX:
-	case LINE6_DEVID_PODSTUDIO_UX1:
-	case LINE6_DEVID_PODSTUDIO_UX2:
-	case LINE6_DEVID_TONEPORT_GX:
-	case LINE6_DEVID_TONEPORT_UX1:
-	case LINE6_DEVID_TONEPORT_UX2:
-	case LINE6_DEVID_GUITARPORT:
+	switch (line6->type) {
+	case LINE6_PODSTUDIO_GX:
+	case LINE6_PODSTUDIO_UX1:
+	case LINE6_PODSTUDIO_UX2:
+	case LINE6_TONEPORT_GX:
+	case LINE6_TONEPORT_UX1:
+	case LINE6_TONEPORT_UX2:
+	case LINE6_GUITARPORT:
 		line6_toneport_reset_resume((struct usb_line6_toneport *)line6);
+
+	default:
+		break;
 	}
 
 	return line6_resume(interface);
diff --git a/drivers/staging/line6/driver.h b/drivers/staging/line6/driver.h
index 8fb4a9c..c536795 100644
--- a/drivers/staging/line6/driver.h
+++ b/drivers/staging/line6/driver.h
@@ -126,9 +126,9 @@ struct usb_line6 {
 	struct usb_device *usbdev;
 
 	/**
-		 Product id.
+		 Device type.
 	*/
-	int product;
+	enum line6_device_type type;
 
 	/**
 		 Properties.
diff --git a/drivers/staging/line6/pcm.c b/drivers/staging/line6/pcm.c
index 076c87b..86c7bcb 100644
--- a/drivers/staging/line6/pcm.c
+++ b/drivers/staging/line6/pcm.c
@@ -427,37 +427,37 @@ int line6_init_pcm(struct usb_line6 *line6,
 	if (!(line6->properties->capabilities & LINE6_BIT_PCM))
 		return 0;	/* skip PCM initialization and report success */
 
-	/* initialize PCM subsystem based on product id: */
-	switch (line6->product) {
-	case LINE6_DEVID_BASSPODXT:
-	case LINE6_DEVID_BASSPODXTLIVE:
-	case LINE6_DEVID_BASSPODXTPRO:
-	case LINE6_DEVID_PODXT:
-	case LINE6_DEVID_PODXTLIVE:
-	case LINE6_DEVID_PODXTPRO:
-	case LINE6_DEVID_PODHD300:
-	case LINE6_DEVID_PODHD400:
+	/* initialize PCM subsystem based on device: */
+	switch (line6->type) {
+	case LINE6_BASSPODXT:
+	case LINE6_BASSPODXTLIVE:
+	case LINE6_BASSPODXTPRO:
+	case LINE6_PODXT:
+	case LINE6_PODXTLIVE:
+	case LINE6_PODXTPRO:
+	case LINE6_PODHD300:
+	case LINE6_PODHD400:
 		ep_read = 0x82;
 		ep_write = 0x01;
 		break;
 
-	case LINE6_DEVID_PODHD500:
+	case LINE6_PODHD500:
 		ep_read = 0x86;
 		ep_write = 0x02;
 		break;
 
-	case LINE6_DEVID_POCKETPOD:
+	case LINE6_POCKETPOD:
 		ep_read = 0x82;
 		ep_write = 0x02;
 		break;
 
-	case LINE6_DEVID_GUITARPORT:
-	case LINE6_DEVID_PODSTUDIO_GX:
-	case LINE6_DEVID_PODSTUDIO_UX1:
-	case LINE6_DEVID_PODSTUDIO_UX2:
-	case LINE6_DEVID_TONEPORT_GX:
-	case LINE6_DEVID_TONEPORT_UX1:
-	case LINE6_DEVID_TONEPORT_UX2:
+	case LINE6_GUITARPORT:
+	case LINE6_PODSTUDIO_GX:
+	case LINE6_PODSTUDIO_UX1:
+	case LINE6_PODSTUDIO_UX2:
+	case LINE6_TONEPORT_GX:
+	case LINE6_TONEPORT_UX1:
+	case LINE6_TONEPORT_UX2:
 		ep_read = 0x82;
 		ep_write = 0x01;
 		break;
diff --git a/drivers/staging/line6/toneport.c b/drivers/staging/line6/toneport.c
index 6943715..a2607e7 100644
--- a/drivers/staging/line6/toneport.c
+++ b/drivers/staging/line6/toneport.c
@@ -97,11 +97,11 @@ static const struct {
 	{"Inst & Mic", 0x0901}
 };
 
-static bool toneport_has_led(short product)
+static bool toneport_has_led(enum line6_device_type type)
 {
 	return
-	    (product == LINE6_DEVID_GUITARPORT) ||
-	    (product == LINE6_DEVID_TONEPORT_GX);
+	    (type == LINE6_GUITARPORT) ||
+	    (type == LINE6_TONEPORT_GX);
 	/* add your device here if you are missing support for the LEDs */
 }
 
@@ -310,7 +310,6 @@ static void toneport_setup(struct usb_line6_toneport *toneport)
 	int ticks;
 	struct usb_line6 *line6 = &toneport->line6;
 	struct usb_device *usbdev = line6->usbdev;
-	u16 idProduct = le16_to_cpu(usbdev->descriptor.idProduct);
 
 	/* sync time on device with host: */
 	ticks = (int)get_seconds();
@@ -320,17 +319,19 @@ static void toneport_setup(struct usb_line6_toneport *toneport)
 	toneport_send_cmd(usbdev, 0x0301, 0x0000);
 
 	/* initialize source select: */
-	switch (le16_to_cpu(usbdev->descriptor.idProduct)) {
-	case LINE6_DEVID_TONEPORT_UX1:
-	case LINE6_DEVID_TONEPORT_UX2:
-	case LINE6_DEVID_PODSTUDIO_UX1:
-	case LINE6_DEVID_PODSTUDIO_UX2:
+	switch (line6->type) {
+	case LINE6_TONEPORT_UX1:
+	case LINE6_TONEPORT_UX2:
+	case LINE6_PODSTUDIO_UX1:
+	case LINE6_PODSTUDIO_UX2:
 		toneport_send_cmd(usbdev,
 				  toneport_source_info[toneport->source].code,
 				  0x0000);
+	default:
+		break;
 	}
 
-	if (toneport_has_led(idProduct))
+	if (toneport_has_led(line6->type))
 		toneport_update_led(&usbdev->dev);
 }
 
@@ -342,8 +343,6 @@ static int toneport_try_init(struct usb_interface *interface,
 {
 	int err;
 	struct usb_line6 *line6 = &toneport->line6;
-	struct usb_device *usbdev = line6->usbdev;
-	u16 idProduct = le16_to_cpu(usbdev->descriptor.idProduct);
 
 	if ((interface == NULL) || (toneport == NULL))
 		return -ENODEV;
@@ -366,17 +365,20 @@ static int toneport_try_init(struct usb_interface *interface,
 		return err;
 
 	/* register source select control: */
-	switch (le16_to_cpu(usbdev->descriptor.idProduct)) {
-	case LINE6_DEVID_TONEPORT_UX1:
-	case LINE6_DEVID_TONEPORT_UX2:
-	case LINE6_DEVID_PODSTUDIO_UX1:
-	case LINE6_DEVID_PODSTUDIO_UX2:
+	switch (line6->type) {
+	case LINE6_TONEPORT_UX1:
+	case LINE6_TONEPORT_UX2:
+	case LINE6_PODSTUDIO_UX1:
+	case LINE6_PODSTUDIO_UX2:
 		err =
 		    snd_ctl_add(line6->card,
 				snd_ctl_new1(&toneport_control_source,
 					     line6->line6pcm));
 		if (err < 0)
 			return err;
+
+	default:
+		break;
 	}
 
 	/* register audio system: */
@@ -387,7 +389,7 @@ static int toneport_try_init(struct usb_interface *interface,
 	line6_read_serial_number(line6, &toneport->serial_number);
 	line6_read_data(line6, 0x80c2, &toneport->firmware_version, 1);
 
-	if (toneport_has_led(idProduct)) {
+	if (toneport_has_led(line6->type)) {
 		CHECK_RETURN(device_create_file
 			     (&interface->dev, &dev_attr_led_red));
 		CHECK_RETURN(device_create_file
@@ -433,16 +435,14 @@ void line6_toneport_reset_resume(struct usb_line6_toneport *toneport)
 void line6_toneport_disconnect(struct usb_interface *interface)
 {
 	struct usb_line6_toneport *toneport;
-	u16 idProduct;
 
 	if (interface == NULL)
 		return;
 
 	toneport = usb_get_intfdata(interface);
 	del_timer_sync(&toneport->timer);
-	idProduct = le16_to_cpu(toneport->line6.usbdev->descriptor.idProduct);
 
-	if (toneport_has_led(idProduct)) {
+	if (toneport_has_led(toneport->line6.type)) {
 		device_remove_file(&interface->dev, &dev_attr_led_red);
 		device_remove_file(&interface->dev, &dev_attr_led_green);
 	}
-- 
2.1.0


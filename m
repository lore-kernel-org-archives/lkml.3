Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab3GLJDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 05:03:25 -0400
Received: from shell.v3.sk ([195.168.3.45]:50584 "EHLO zimbra.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757361Ab3GLJDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 05:03:22 -0400
From: Lubomir Rintel <lkundrak@v3.sk>
To: linux-media@vger.kernel.org
Cc: Lubomir Rintel <lkundrak@v3.sk>, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [media] usbtv: Add S-Video input support
Date: Fri, 12 Jul 2013 11:03:03 +0200
Message-Id: <1373619783-31456-1-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alongside already existing Composite input.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
---
 drivers/media/usb/usbtv/usbtv.c |   99 ++++++++++++++++++++++++++++++++-------
 1 files changed, 82 insertions(+), 17 deletions(-)

diff --git a/drivers/media/usb/usbtv/usbtv.c b/drivers/media/usb/usbtv/usbtv.c
index 9165017..9b250a7 100644
--- a/drivers/media/usb/usbtv/usbtv.c
+++ b/drivers/media/usb/usbtv/usbtv.c
@@ -91,17 +91,78 @@ struct usbtv {
 	u32 frame_id;
 	int chunks_done;
 
+	enum {
+		USBTV_COMPOSITE_INPUT,
+		USBTV_SVIDEO_INPUT,
+	} input;
 	int iso_size;
 	unsigned int sequence;
 	struct urb *isoc_urbs[USBTV_ISOC_TRANSFERS];
 };
 
-static int usbtv_setup_capture(struct usbtv *usbtv)
+static int usbtv_set_regs(struct usbtv *usbtv, const u16 regs[][2], int size)
 {
 	int ret;
 	int pipe = usb_rcvctrlpipe(usbtv->udev, 0);
 	int i;
-	static const u16 protoregs[][2] = {
+
+	for (i = 0; i < size; i++) {
+		u16 index = regs[i][0];
+		u16 value = regs[i][1];
+
+		ret = usb_control_msg(usbtv->udev, pipe, USBTV_REQUEST_REG,
+			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			value, index, NULL, 0, 0);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int usbtv_select_input(struct usbtv *usbtv, int input)
+{
+	int ret;
+
+	static const u16 composite[][2] = {
+		{ USBTV_BASE + 0x0105, 0x0060 },
+		{ USBTV_BASE + 0x011f, 0x00f2 },
+		{ USBTV_BASE + 0x0127, 0x0060 },
+		{ USBTV_BASE + 0x00ae, 0x0010 },
+		{ USBTV_BASE + 0x0284, 0x00aa },
+		{ USBTV_BASE + 0x0239, 0x0060 },
+	};
+
+	static const u16 svideo[][2] = {
+		{ USBTV_BASE + 0x0105, 0x0010 },
+		{ USBTV_BASE + 0x011f, 0x00ff },
+		{ USBTV_BASE + 0x0127, 0x0060 },
+		{ USBTV_BASE + 0x00ae, 0x0030 },
+		{ USBTV_BASE + 0x0284, 0x0088 },
+		{ USBTV_BASE + 0x0239, 0x0060 },
+	};
+
+	switch (input) {
+	case USBTV_COMPOSITE_INPUT:
+		ret = usbtv_set_regs(usbtv, composite, ARRAY_SIZE(composite));
+		break;
+	case USBTV_SVIDEO_INPUT:
+		ret = usbtv_set_regs(usbtv, svideo, ARRAY_SIZE(svideo));
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	if (!ret)
+		usbtv->input = input;
+
+	return ret;
+}
+
+static int usbtv_setup_capture(struct usbtv *usbtv)
+{
+	int ret;
+	static const u16 setup[][2] = {
 		/* These seem to enable the device. */
 		{ USBTV_BASE + 0x0008, 0x0001 },
 		{ USBTV_BASE + 0x01d0, 0x00ff },
@@ -189,16 +250,13 @@ static int usbtv_setup_capture(struct usbtv *usbtv)
 		{ USBTV_BASE + 0x024f, 0x0002 },
 	};
 
-	for (i = 0; i < ARRAY_SIZE(protoregs); i++) {
-		u16 index = protoregs[i][0];
-		u16 value = protoregs[i][1];
+	ret = usbtv_set_regs(usbtv, setup, ARRAY_SIZE(setup));
+	if (ret)
+		return ret;
 
-		ret = usb_control_msg(usbtv->udev, pipe, USBTV_REQUEST_REG,
-			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			value, index, NULL, 0, 0);
-		if (ret < 0)
-			return ret;
-	}
+	ret = usbtv_select_input(usbtv, usbtv->input);
+	if (ret)
+		return ret;
 
 	return 0;
 }
@@ -443,10 +501,17 @@ static int usbtv_querycap(struct file *file, void *priv,
 static int usbtv_enum_input(struct file *file, void *priv,
 					struct v4l2_input *i)
 {
-	if (i->index > 0)
+	switch (i->index) {
+	case USBTV_COMPOSITE_INPUT:
+		strlcpy(i->name, "Composite", sizeof(i->name));
+		break;
+	case USBTV_SVIDEO_INPUT:
+		strlcpy(i->name, "S-Video", sizeof(i->name));
+		break;
+	default:
 		return -EINVAL;
+	}
 
-	strlcpy(i->name, "Composite", sizeof(i->name));
 	i->type = V4L2_INPUT_TYPE_CAMERA;
 	i->std = V4L2_STD_525_60;
 	return 0;
@@ -486,15 +551,15 @@ static int usbtv_g_std(struct file *file, void *priv, v4l2_std_id *norm)
 
 static int usbtv_g_input(struct file *file, void *priv, unsigned int *i)
 {
-	*i = 0;
+	struct usbtv *usbtv = video_drvdata(file);
+	*i = usbtv->input;
 	return 0;
 }
 
 static int usbtv_s_input(struct file *file, void *priv, unsigned int i)
 {
-	if (i > 0)
-		return -EINVAL;
-	return 0;
+	struct usbtv *usbtv = video_drvdata(file);
+	return usbtv_select_input(usbtv, i);
 }
 
 static int usbtv_s_std(struct file *file, void *priv, v4l2_std_id norm)
-- 
1.7.1


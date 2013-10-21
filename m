Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab3JUPBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 11:01:53 -0400
Received: from shell.v3.sk ([195.168.3.45]:49253 "EHLO shell.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439Ab3JUPBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 11:01:51 -0400
From: Lubomir Rintel <lkundrak@v3.sk>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, Georg Kaindl <gkaindl@mac.com>
Subject: [PATCH] [media] usbtv: Add support for PAL video source.
Date: Mon, 21 Oct 2013 17:01:36 +0200
Message-Id: <1382367696-24896-1-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Georg Kaindl <gkaindl@mac.com>

Signed-off-by: Georg Kaindl <gkaindl@mac.com>
Tested-by: Lubomir Rintel <lkundrak@v3.sk>
---
Hi,

this is a patch sent to me by Georg Kaindl, who uses it with ambi-tv [1]. It 
looks fine to me and works well, please review and eventually pull it into the 
media tree.

[1] https://github.com/gkaindl/ambi-tv

Thanks!
Lubo

 drivers/media/usb/usbtv/usbtv.c |  174 ++++++++++++++++++++++++++++++---------
 1 files changed, 136 insertions(+), 38 deletions(-)

diff --git a/drivers/media/usb/usbtv/usbtv.c b/drivers/media/usb/usbtv/usbtv.c
index 8a505a9..6222a4a 100644
--- a/drivers/media/usb/usbtv/usbtv.c
+++ b/drivers/media/usb/usbtv/usbtv.c
@@ -50,13 +50,8 @@
 #define USBTV_ISOC_TRANSFERS	16
 #define USBTV_ISOC_PACKETS	8
 
-#define USBTV_WIDTH		720
-#define USBTV_HEIGHT		480
-
 #define USBTV_CHUNK_SIZE	256
 #define USBTV_CHUNK		240
-#define USBTV_CHUNKS		(USBTV_WIDTH * USBTV_HEIGHT \
-					/ 4 / USBTV_CHUNK)
 
 /* Chunk header. */
 #define USBTV_MAGIC_OK(chunk)	((be32_to_cpu(chunk[0]) & 0xff000000) \
@@ -65,6 +60,27 @@
 #define USBTV_ODD(chunk)	((be32_to_cpu(chunk[0]) & 0x0000f000) >> 15)
 #define USBTV_CHUNK_NO(chunk)	(be32_to_cpu(chunk[0]) & 0x00000fff)
 
+#define USBTV_TV_STD  (V4L2_STD_525_60 | V4L2_STD_PAL)
+
+/* parameters for supported TV norms */
+struct usbtv_norm_params {
+	v4l2_std_id norm;
+	int cap_width, cap_height;
+};
+
+static struct usbtv_norm_params norm_params[] = {
+	{
+		.norm = V4L2_STD_525_60,
+		.cap_width = 720,
+		.cap_height = 480,
+	},
+	{
+		.norm = V4L2_STD_PAL,
+		.cap_width = 720,
+		.cap_height = 576,
+	}
+};
+
 /* A single videobuf2 frame buffer. */
 struct usbtv_buf {
 	struct vb2_buffer vb;
@@ -94,11 +110,38 @@ struct usbtv {
 		USBTV_COMPOSITE_INPUT,
 		USBTV_SVIDEO_INPUT,
 	} input;
+	v4l2_std_id norm;
+	int width, height;
+	int n_chunks;
 	int iso_size;
 	unsigned int sequence;
 	struct urb *isoc_urbs[USBTV_ISOC_TRANSFERS];
 };
 
+static int usbtv_configure_for_norm(struct usbtv *usbtv, v4l2_std_id norm)
+{
+	int i, ret = 0;
+	struct usbtv_norm_params *params = NULL;
+
+	for (i = 0; i < ARRAY_SIZE(norm_params); i++) {
+		if (norm_params[i].norm & norm) {
+			params = &norm_params[i];
+			break;
+		}
+	}
+
+	if (params) {
+		usbtv->width = params->cap_width;
+		usbtv->height = params->cap_height;
+		usbtv->n_chunks = usbtv->width * usbtv->height
+						/ 4 / USBTV_CHUNK;
+		usbtv->norm = params->norm;
+	} else
+		ret = -EINVAL;
+
+	return ret;
+}
+
 static int usbtv_set_regs(struct usbtv *usbtv, const u16 regs[][2], int size)
 {
 	int ret;
@@ -158,6 +201,57 @@ static int usbtv_select_input(struct usbtv *usbtv, int input)
 	return ret;
 }
 
+static int usbtv_select_norm(struct usbtv *usbtv, v4l2_std_id norm)
+{
+	int ret;
+	static const u16 pal[][2] = {
+		{ USBTV_BASE + 0x001a, 0x0068 },
+		{ USBTV_BASE + 0x010e, 0x0072 },
+		{ USBTV_BASE + 0x010f, 0x00a2 },
+		{ USBTV_BASE + 0x0112, 0x00b0 },
+		{ USBTV_BASE + 0x0117, 0x0001 },
+		{ USBTV_BASE + 0x0118, 0x002c },
+		{ USBTV_BASE + 0x012d, 0x0010 },
+		{ USBTV_BASE + 0x012f, 0x0020 },
+		{ USBTV_BASE + 0x024f, 0x0002 },
+		{ USBTV_BASE + 0x0254, 0x0059 },
+		{ USBTV_BASE + 0x025a, 0x0016 },
+		{ USBTV_BASE + 0x025b, 0x0035 },
+		{ USBTV_BASE + 0x0263, 0x0017 },
+		{ USBTV_BASE + 0x0266, 0x0016 },
+		{ USBTV_BASE + 0x0267, 0x0036 }
+	};
+
+	static const u16 ntsc[][2] = {
+		{ USBTV_BASE + 0x001a, 0x0079 },
+		{ USBTV_BASE + 0x010e, 0x0068 },
+		{ USBTV_BASE + 0x010f, 0x009c },
+		{ USBTV_BASE + 0x0112, 0x00f0 },
+		{ USBTV_BASE + 0x0117, 0x0000 },
+		{ USBTV_BASE + 0x0118, 0x00fc },
+		{ USBTV_BASE + 0x012d, 0x0004 },
+		{ USBTV_BASE + 0x012f, 0x0008 },
+		{ USBTV_BASE + 0x024f, 0x0001 },
+		{ USBTV_BASE + 0x0254, 0x005f },
+		{ USBTV_BASE + 0x025a, 0x0012 },
+		{ USBTV_BASE + 0x025b, 0x0001 },
+		{ USBTV_BASE + 0x0263, 0x001c },
+		{ USBTV_BASE + 0x0266, 0x0011 },
+		{ USBTV_BASE + 0x0267, 0x0005 }
+	};
+
+	ret = usbtv_configure_for_norm(usbtv, norm);
+
+	if (!ret) {
+		if (norm & V4L2_STD_525_60)
+			ret = usbtv_set_regs(usbtv, ntsc, ARRAY_SIZE(ntsc));
+		else if (norm & V4L2_STD_PAL)
+			ret = usbtv_set_regs(usbtv, pal, ARRAY_SIZE(pal));
+	}
+
+	return ret;
+}
+
 static int usbtv_setup_capture(struct usbtv *usbtv)
 {
 	int ret;
@@ -225,26 +319,11 @@ static int usbtv_setup_capture(struct usbtv *usbtv)
 
 		{ USBTV_BASE + 0x0284, 0x0088 },
 		{ USBTV_BASE + 0x0003, 0x0004 },
-		{ USBTV_BASE + 0x001a, 0x0079 },
 		{ USBTV_BASE + 0x0100, 0x00d3 },
-		{ USBTV_BASE + 0x010e, 0x0068 },
-		{ USBTV_BASE + 0x010f, 0x009c },
-		{ USBTV_BASE + 0x0112, 0x00f0 },
 		{ USBTV_BASE + 0x0115, 0x0015 },
-		{ USBTV_BASE + 0x0117, 0x0000 },
-		{ USBTV_BASE + 0x0118, 0x00fc },
-		{ USBTV_BASE + 0x012d, 0x0004 },
-		{ USBTV_BASE + 0x012f, 0x0008 },
 		{ USBTV_BASE + 0x0220, 0x002e },
 		{ USBTV_BASE + 0x0225, 0x0008 },
 		{ USBTV_BASE + 0x024e, 0x0002 },
-		{ USBTV_BASE + 0x024f, 0x0001 },
-		{ USBTV_BASE + 0x0254, 0x005f },
-		{ USBTV_BASE + 0x025a, 0x0012 },
-		{ USBTV_BASE + 0x025b, 0x0001 },
-		{ USBTV_BASE + 0x0263, 0x001c },
-		{ USBTV_BASE + 0x0266, 0x0011 },
-		{ USBTV_BASE + 0x0267, 0x0005 },
 		{ USBTV_BASE + 0x024e, 0x0002 },
 		{ USBTV_BASE + 0x024f, 0x0002 },
 	};
@@ -253,6 +332,10 @@ static int usbtv_setup_capture(struct usbtv *usbtv)
 	if (ret)
 		return ret;
 
+	ret = usbtv_select_norm(usbtv, usbtv->norm);
+	if (ret)
+		return ret;
+
 	ret = usbtv_select_input(usbtv, usbtv->input);
 	if (ret)
 		return ret;
@@ -296,7 +379,7 @@ static void usbtv_image_chunk(struct usbtv *usbtv, u32 *chunk)
 	frame_id = USBTV_FRAME_ID(chunk);
 	odd = USBTV_ODD(chunk);
 	chunk_no = USBTV_CHUNK_NO(chunk);
-	if (chunk_no >= USBTV_CHUNKS)
+	if (chunk_no >= usbtv->n_chunks)
 		return;
 
 	/* Beginning of a frame. */
@@ -324,10 +407,10 @@ static void usbtv_image_chunk(struct usbtv *usbtv, u32 *chunk)
 	usbtv->chunks_done++;
 
 	/* Last chunk in a frame, signalling an end */
-	if (odd && chunk_no == USBTV_CHUNKS-1) {
+	if (odd && chunk_no == usbtv->n_chunks-1) {
 		int size = vb2_plane_size(&buf->vb, 0);
 		enum vb2_buffer_state state = usbtv->chunks_done ==
-						USBTV_CHUNKS ?
+						usbtv->n_chunks ?
 						VB2_BUF_STATE_DONE :
 						VB2_BUF_STATE_ERROR;
 
@@ -500,6 +583,8 @@ static int usbtv_querycap(struct file *file, void *priv,
 static int usbtv_enum_input(struct file *file, void *priv,
 					struct v4l2_input *i)
 {
+	struct usbtv *dev = video_drvdata(file);
+
 	switch (i->index) {
 	case USBTV_COMPOSITE_INPUT:
 		strlcpy(i->name, "Composite", sizeof(i->name));
@@ -512,7 +597,7 @@ static int usbtv_enum_input(struct file *file, void *priv,
 	}
 
 	i->type = V4L2_INPUT_TYPE_CAMERA;
-	i->std = V4L2_STD_525_60;
+	i->std = dev->vdev.tvnorms;
 	return 0;
 }
 
@@ -531,23 +616,37 @@ static int usbtv_enum_fmt_vid_cap(struct file *file, void  *priv,
 static int usbtv_fmt_vid_cap(struct file *file, void *priv,
 					struct v4l2_format *f)
 {
-	f->fmt.pix.width = USBTV_WIDTH;
-	f->fmt.pix.height = USBTV_HEIGHT;
+	struct usbtv *usbtv = video_drvdata(file);
+
+	f->fmt.pix.width = usbtv->width;
+	f->fmt.pix.height = usbtv->height;
 	f->fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV;
 	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
-	f->fmt.pix.bytesperline = USBTV_WIDTH * 2;
+	f->fmt.pix.bytesperline = usbtv->width * 2;
 	f->fmt.pix.sizeimage = (f->fmt.pix.bytesperline * f->fmt.pix.height);
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
-	f->fmt.pix.priv = 0;
+
 	return 0;
 }
 
 static int usbtv_g_std(struct file *file, void *priv, v4l2_std_id *norm)
 {
-	*norm = V4L2_STD_525_60;
+	struct usbtv *usbtv = video_drvdata(file);
+	*norm = usbtv->norm;
 	return 0;
 }
 
+static int usbtv_s_std(struct file *file, void *priv, v4l2_std_id norm)
+{
+	int ret = -EINVAL;
+	struct usbtv *usbtv = video_drvdata(file);
+
+	if ((norm & V4L2_STD_525_60) || (norm & V4L2_STD_PAL))
+		ret = usbtv_select_norm(usbtv, norm);
+
+	return ret;
+}
+
 static int usbtv_g_input(struct file *file, void *priv, unsigned int *i)
 {
 	struct usbtv *usbtv = video_drvdata(file);
@@ -561,13 +660,6 @@ static int usbtv_s_input(struct file *file, void *priv, unsigned int i)
 	return usbtv_select_input(usbtv, i);
 }
 
-static int usbtv_s_std(struct file *file, void *priv, v4l2_std_id norm)
-{
-	if (norm & V4L2_STD_525_60)
-		return 0;
-	return -EINVAL;
-}
-
 struct v4l2_ioctl_ops usbtv_ioctl_ops = {
 	.vidioc_querycap = usbtv_querycap,
 	.vidioc_enum_input = usbtv_enum_input,
@@ -604,10 +696,12 @@ static int usbtv_queue_setup(struct vb2_queue *vq,
 	const struct v4l2_format *v4l_fmt, unsigned int *nbuffers,
 	unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
 {
+	struct usbtv *usbtv = vb2_get_drv_priv(vq);
+
 	if (*nbuffers < 2)
 		*nbuffers = 2;
 	*nplanes = 1;
-	sizes[0] = USBTV_WIDTH * USBTV_HEIGHT / 2 * sizeof(u32);
+	sizes[0] = USBTV_CHUNK * usbtv->n_chunks * 2 * sizeof(u32);
 
 	return 0;
 }
@@ -690,7 +784,11 @@ static int usbtv_probe(struct usb_interface *intf,
 		return -ENOMEM;
 	usbtv->dev = dev;
 	usbtv->udev = usb_get_dev(interface_to_usbdev(intf));
+
 	usbtv->iso_size = size;
+
+	(void)usbtv_configure_for_norm(usbtv, V4L2_STD_525_60);
+
 	spin_lock_init(&usbtv->buflock);
 	mutex_init(&usbtv->v4l2_lock);
 	mutex_init(&usbtv->vb2q_lock);
@@ -727,7 +825,7 @@ static int usbtv_probe(struct usb_interface *intf,
 	usbtv->vdev.release = video_device_release_empty;
 	usbtv->vdev.fops = &usbtv_fops;
 	usbtv->vdev.ioctl_ops = &usbtv_ioctl_ops;
-	usbtv->vdev.tvnorms = V4L2_STD_525_60;
+	usbtv->vdev.tvnorms = USBTV_TV_STD;
 	usbtv->vdev.queue = &usbtv->vb2q;
 	usbtv->vdev.lock = &usbtv->v4l2_lock;
 	set_bit(V4L2_FL_USE_FH_PRIO, &usbtv->vdev.flags);
-- 
1.7.1


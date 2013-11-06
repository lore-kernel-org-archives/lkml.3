Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab3KFQor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 11:44:47 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:40634 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab3KFQoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 11:44:46 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        linux-media@vger.kernel.org (open list:MT9M032 APTINA SE...),
        linux-kernel@vger.kernel.org (open list)
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v4] videodev2: Set vb2_rect's width and height as unsigned
Date: Wed,  6 Nov 2013 17:44:38 +0100
Message-Id: <1383756278-29642-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As addressed on the media summit 2013, there is no reason for the width
and height to be signed.

Therefore this patch is an attempt to convert those fields into unsigned.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
v3: Comments by Sakari
-Update also doc

v2: Comments by Sakari Ailus and Laurent Pinchart

-Fix alignment on all drivers
-Replace min with min_t where possible and remove unneeded checks

 Documentation/DocBook/media/v4l/compat.xml         | 12 ++++++++
 Documentation/DocBook/media/v4l/dev-overlay.xml    |  8 ++---
 Documentation/DocBook/media/v4l/vidioc-cropcap.xml |  8 ++---
 drivers/media/i2c/mt9m032.c                        | 16 +++++-----
 drivers/media/i2c/mt9p031.c                        | 28 ++++++++++--------
 drivers/media/i2c/mt9t001.c                        | 26 ++++++++++-------
 drivers/media/i2c/mt9v032.c                        | 34 ++++++++++++----------
 drivers/media/i2c/smiapp/smiapp-core.c             |  8 ++---
 drivers/media/i2c/soc_camera/mt9m111.c             |  4 +--
 drivers/media/i2c/tvp5150.c                        | 14 ++++-----
 drivers/media/pci/bt8xx/bttv-driver.c              |  6 ++--
 drivers/media/pci/saa7134/saa7134-video.c          |  4 ---
 drivers/media/platform/soc_camera/soc_scale_crop.c |  4 +--
 include/uapi/linux/videodev2.h                     |  4 +--
 14 files changed, 97 insertions(+), 79 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index 0c7195e..5dbe68b 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2523,6 +2523,18 @@ that used it. It was originally scheduled for removal in 2.6.35.
       </orderedlist>
     </section>
 
+    <section>
+      <title>V4L2 in Linux 3.12</title>
+      <orderedlist>
+        <listitem>
+		<para> In struct <structname>v4l2_rect</structname>, the type
+of <structfield>width</structfield> and <structfield>height</structfield>
+fields changed from _s32 to _u32.
+	  </para>
+        </listitem>
+      </orderedlist>
+    </section>
+
     <section id="other">
       <title>Relation of V4L2 to other Linux multimedia APIs</title>
 
diff --git a/Documentation/DocBook/media/v4l/dev-overlay.xml b/Documentation/DocBook/media/v4l/dev-overlay.xml
index 40d1d76..a44ac66 100644
--- a/Documentation/DocBook/media/v4l/dev-overlay.xml
+++ b/Documentation/DocBook/media/v4l/dev-overlay.xml
@@ -346,16 +346,14 @@ rectangle, in pixels.</entry>
 rectangle, in pixels. Offsets increase to the right and down.</entry>
 	  </row>
 	  <row>
-	    <entry>__s32</entry>
+	    <entry>__u32</entry>
 	    <entry><structfield>width</structfield></entry>
 	    <entry>Width of the rectangle, in pixels.</entry>
 	  </row>
 	  <row>
-	    <entry>__s32</entry>
+	    <entry>__u32</entry>
 	    <entry><structfield>height</structfield></entry>
-	    <entry>Height of the rectangle, in pixels. Width and
-height cannot be negative, the fields are signed for hysterical
-reasons. <!-- video4linux-list@redhat.com on 22 Oct 2002 subject
+	    <entry>Height of the rectangle, in pixels.<!-- video4linux-list@redhat.com on 22 Oct 2002 subject
 "Re:[V4L][patches!] Re:v4l2/kernel-2.5" --></entry>
 	  </row>
 	</tbody>
diff --git a/Documentation/DocBook/media/v4l/vidioc-cropcap.xml b/Documentation/DocBook/media/v4l/vidioc-cropcap.xml
index bf7cc97..26b8f8f 100644
--- a/Documentation/DocBook/media/v4l/vidioc-cropcap.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-cropcap.xml
@@ -133,16 +133,14 @@ rectangle, in pixels.</entry>
 rectangle, in pixels.</entry>
 	  </row>
 	  <row>
-	    <entry>__s32</entry>
+	    <entry>__u32</entry>
 	    <entry><structfield>width</structfield></entry>
 	    <entry>Width of the rectangle, in pixels.</entry>
 	  </row>
 	  <row>
-	    <entry>__s32</entry>
+	    <entry>__u32</entry>
 	    <entry><structfield>height</structfield></entry>
-	    <entry>Height of the rectangle, in pixels. Width
-and height cannot be negative, the fields are signed for
-hysterical reasons. <!-- video4linux-list@redhat.com
+	    <entry>Height of the rectangle, in pixels.<!-- video4linux-list@redhat.com
 on 22 Oct 2002 subject "Re:[V4L][patches!] Re:v4l2/kernel-2.5" -->
 </entry>
 	  </row>
diff --git a/drivers/media/i2c/mt9m032.c b/drivers/media/i2c/mt9m032.c
index 846b15f..85ec3ba 100644
--- a/drivers/media/i2c/mt9m032.c
+++ b/drivers/media/i2c/mt9m032.c
@@ -459,13 +459,15 @@ static int mt9m032_set_pad_crop(struct v4l2_subdev *subdev,
 			  MT9M032_COLUMN_START_MAX);
 	rect.top = clamp(ALIGN(crop->rect.top, 2), MT9M032_ROW_START_MIN,
 			 MT9M032_ROW_START_MAX);
-	rect.width = clamp(ALIGN(crop->rect.width, 2), MT9M032_COLUMN_SIZE_MIN,
-			   MT9M032_COLUMN_SIZE_MAX);
-	rect.height = clamp(ALIGN(crop->rect.height, 2), MT9M032_ROW_SIZE_MIN,
-			    MT9M032_ROW_SIZE_MAX);
-
-	rect.width = min(rect.width, MT9M032_PIXEL_ARRAY_WIDTH - rect.left);
-	rect.height = min(rect.height, MT9M032_PIXEL_ARRAY_HEIGHT - rect.top);
+	rect.width = clamp_t(unsigned int, ALIGN(crop->rect.width, 2),
+			     MT9M032_COLUMN_SIZE_MIN, MT9M032_COLUMN_SIZE_MAX);
+	rect.height = clamp_t(unsigned int, ALIGN(crop->rect.height, 2),
+			      MT9M032_ROW_SIZE_MIN, MT9M032_ROW_SIZE_MAX);
+
+	rect.width = min_t(unsigned int, rect.width,
+			   MT9M032_PIXEL_ARRAY_WIDTH - rect.left);
+	rect.height = min_t(unsigned int, rect.height,
+			    MT9M032_PIXEL_ARRAY_HEIGHT - rect.top);
 
 	__crop = __mt9m032_get_pad_crop(sensor, fh, crop->which);
 
diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index 4734836..722f78a 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -518,11 +518,13 @@ static int mt9p031_set_format(struct v4l2_subdev *subdev,
 
 	/* Clamp the width and height to avoid dividing by zero. */
 	width = clamp_t(unsigned int, ALIGN(format->format.width, 2),
-			max(__crop->width / 7, MT9P031_WINDOW_WIDTH_MIN),
+			max_t(unsigned int, __crop->width / 7,
+			      MT9P031_WINDOW_WIDTH_MIN),
 			__crop->width);
 	height = clamp_t(unsigned int, ALIGN(format->format.height, 2),
-			max(__crop->height / 8, MT9P031_WINDOW_HEIGHT_MIN),
-			__crop->height);
+			 max_t(unsigned int, __crop->height / 8,
+			       MT9P031_WINDOW_HEIGHT_MIN),
+			 __crop->height);
 
 	hratio = DIV_ROUND_CLOSEST(__crop->width, width);
 	vratio = DIV_ROUND_CLOSEST(__crop->height, height);
@@ -564,15 +566,17 @@ static int mt9p031_set_crop(struct v4l2_subdev *subdev,
 			  MT9P031_COLUMN_START_MAX);
 	rect.top = clamp(ALIGN(crop->rect.top, 2), MT9P031_ROW_START_MIN,
 			 MT9P031_ROW_START_MAX);
-	rect.width = clamp(ALIGN(crop->rect.width, 2),
-			   MT9P031_WINDOW_WIDTH_MIN,
-			   MT9P031_WINDOW_WIDTH_MAX);
-	rect.height = clamp(ALIGN(crop->rect.height, 2),
-			    MT9P031_WINDOW_HEIGHT_MIN,
-			    MT9P031_WINDOW_HEIGHT_MAX);
-
-	rect.width = min(rect.width, MT9P031_PIXEL_ARRAY_WIDTH - rect.left);
-	rect.height = min(rect.height, MT9P031_PIXEL_ARRAY_HEIGHT - rect.top);
+	rect.width = clamp_t(unsigned int, ALIGN(crop->rect.width, 2),
+			     MT9P031_WINDOW_WIDTH_MIN,
+			     MT9P031_WINDOW_WIDTH_MAX);
+	rect.height = clamp_t(unsigned int, ALIGN(crop->rect.height, 2),
+			      MT9P031_WINDOW_HEIGHT_MIN,
+			      MT9P031_WINDOW_HEIGHT_MAX);
+
+	rect.width = min_t(unsigned int, rect.width,
+			   MT9P031_PIXEL_ARRAY_WIDTH - rect.left);
+	rect.height = min_t(unsigned int, rect.height,
+			    MT9P031_PIXEL_ARRAY_HEIGHT - rect.top);
 
 	__crop = __mt9p031_get_pad_crop(mt9p031, fh, crop->pad, crop->which);
 
diff --git a/drivers/media/i2c/mt9t001.c b/drivers/media/i2c/mt9t001.c
index 7964634..d41c70e 100644
--- a/drivers/media/i2c/mt9t001.c
+++ b/drivers/media/i2c/mt9t001.c
@@ -291,10 +291,12 @@ static int mt9t001_set_format(struct v4l2_subdev *subdev,
 
 	/* Clamp the width and height to avoid dividing by zero. */
 	width = clamp_t(unsigned int, ALIGN(format->format.width, 2),
-			max(__crop->width / 8, MT9T001_WINDOW_HEIGHT_MIN + 1),
+			max_t(unsigned int, __crop->width / 8,
+			      MT9T001_WINDOW_HEIGHT_MIN + 1),
 			__crop->width);
 	height = clamp_t(unsigned int, ALIGN(format->format.height, 2),
-			 max(__crop->height / 8, MT9T001_WINDOW_HEIGHT_MIN + 1),
+			 max_t(unsigned int, __crop->height / 8,
+			       MT9T001_WINDOW_HEIGHT_MIN + 1),
 			 __crop->height);
 
 	hratio = DIV_ROUND_CLOSEST(__crop->width, width);
@@ -339,15 +341,17 @@ static int mt9t001_set_crop(struct v4l2_subdev *subdev,
 	rect.top = clamp(ALIGN(crop->rect.top, 2),
 			 MT9T001_ROW_START_MIN,
 			 MT9T001_ROW_START_MAX);
-	rect.width = clamp(ALIGN(crop->rect.width, 2),
-			   MT9T001_WINDOW_WIDTH_MIN + 1,
-			   MT9T001_WINDOW_WIDTH_MAX + 1);
-	rect.height = clamp(ALIGN(crop->rect.height, 2),
-			    MT9T001_WINDOW_HEIGHT_MIN + 1,
-			    MT9T001_WINDOW_HEIGHT_MAX + 1);
-
-	rect.width = min(rect.width, MT9T001_PIXEL_ARRAY_WIDTH - rect.left);
-	rect.height = min(rect.height, MT9T001_PIXEL_ARRAY_HEIGHT - rect.top);
+	rect.width = clamp_t(unsigned int, ALIGN(crop->rect.width, 2),
+			     MT9T001_WINDOW_WIDTH_MIN + 1,
+			     MT9T001_WINDOW_WIDTH_MAX + 1);
+	rect.height = clamp_t(unsigned int, ALIGN(crop->rect.height, 2),
+			      MT9T001_WINDOW_HEIGHT_MIN + 1,
+			      MT9T001_WINDOW_HEIGHT_MAX + 1);
+
+	rect.width = min_t(unsigned int, rect.width,
+			   MT9T001_PIXEL_ARRAY_WIDTH - rect.left);
+	rect.height = min_t(unsigned int, rect.height,
+			    MT9T001_PIXEL_ARRAY_HEIGHT - rect.top);
 
 	__crop = __mt9t001_get_pad_crop(mt9t001, fh, crop->pad, crop->which);
 
diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index 2c50eff..ba8da9b 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -420,12 +420,14 @@ static int mt9v032_set_format(struct v4l2_subdev *subdev,
 					format->which);
 
 	/* Clamp the width and height to avoid dividing by zero. */
-	width = clamp_t(unsigned int, ALIGN(format->format.width, 2),
-			max(__crop->width / 8, MT9V032_WINDOW_WIDTH_MIN),
-			__crop->width);
-	height = clamp_t(unsigned int, ALIGN(format->format.height, 2),
-			 max(__crop->height / 8, MT9V032_WINDOW_HEIGHT_MIN),
-			 __crop->height);
+	width = clamp(ALIGN(format->format.width, 2),
+		      max_t(unsigned int, __crop->width / 8,
+			    MT9V032_WINDOW_WIDTH_MIN),
+		      __crop->width);
+	height = clamp(ALIGN(format->format.height, 2),
+		       max_t(unsigned int, __crop->height / 8,
+			     MT9V032_WINDOW_HEIGHT_MIN),
+		       __crop->height);
 
 	hratio = DIV_ROUND_CLOSEST(__crop->width, width);
 	vratio = DIV_ROUND_CLOSEST(__crop->height, height);
@@ -471,15 +473,17 @@ static int mt9v032_set_crop(struct v4l2_subdev *subdev,
 	rect.top = clamp(ALIGN(crop->rect.top + 1, 2) - 1,
 			 MT9V032_ROW_START_MIN,
 			 MT9V032_ROW_START_MAX);
-	rect.width = clamp(ALIGN(crop->rect.width, 2),
-			   MT9V032_WINDOW_WIDTH_MIN,
-			   MT9V032_WINDOW_WIDTH_MAX);
-	rect.height = clamp(ALIGN(crop->rect.height, 2),
-			    MT9V032_WINDOW_HEIGHT_MIN,
-			    MT9V032_WINDOW_HEIGHT_MAX);
-
-	rect.width = min(rect.width, MT9V032_PIXEL_ARRAY_WIDTH - rect.left);
-	rect.height = min(rect.height, MT9V032_PIXEL_ARRAY_HEIGHT - rect.top);
+	rect.width = clamp_t(unsigned int, ALIGN(crop->rect.width, 2),
+			     MT9V032_WINDOW_WIDTH_MIN,
+			     MT9V032_WINDOW_WIDTH_MAX);
+	rect.height = clamp_t(unsigned int, ALIGN(crop->rect.height, 2),
+			      MT9V032_WINDOW_HEIGHT_MIN,
+			      MT9V032_WINDOW_HEIGHT_MAX);
+
+	rect.width = min_t(unsigned int,
+			   rect.width, MT9V032_PIXEL_ARRAY_WIDTH - rect.left);
+	rect.height = min_t(unsigned int,
+			    rect.height, MT9V032_PIXEL_ARRAY_HEIGHT - rect.top);
 
 	__crop = __mt9v032_get_pad_crop(mt9v032, fh, crop->pad, crop->which);
 
diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index ae66d91..3fadb9e 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2028,8 +2028,8 @@ static int smiapp_set_crop(struct v4l2_subdev *subdev,
 	sel->r.width = min(sel->r.width, src_size->width);
 	sel->r.height = min(sel->r.height, src_size->height);
 
-	sel->r.left = min(sel->r.left, src_size->width - sel->r.width);
-	sel->r.top = min(sel->r.top, src_size->height - sel->r.height);
+	sel->r.left = min_t(int, sel->r.left, src_size->width - sel->r.width);
+	sel->r.top = min_t(int, sel->r.top, src_size->height - sel->r.height);
 
 	*crops[sel->pad] = sel->r;
 
@@ -2121,8 +2121,8 @@ static int smiapp_set_selection(struct v4l2_subdev *subdev,
 
 	sel->r.left = max(0, sel->r.left & ~1);
 	sel->r.top = max(0, sel->r.top & ~1);
-	sel->r.width = max(0, SMIAPP_ALIGN_DIM(sel->r.width, sel->flags));
-	sel->r.height = max(0, SMIAPP_ALIGN_DIM(sel->r.height, sel->flags));
+	sel->r.width = SMIAPP_ALIGN_DIM(sel->r.width, sel->flags);
+	sel->r.height =	SMIAPP_ALIGN_DIM(sel->r.height, sel->flags);
 
 	sel->r.width = max_t(unsigned int,
 			     sensor->limits[SMIAPP_LIMIT_MIN_X_OUTPUT_SIZE],
diff --git a/drivers/media/i2c/soc_camera/mt9m111.c b/drivers/media/i2c/soc_camera/mt9m111.c
index 6f40566..ccf5940 100644
--- a/drivers/media/i2c/soc_camera/mt9m111.c
+++ b/drivers/media/i2c/soc_camera/mt9m111.c
@@ -208,8 +208,8 @@ struct mt9m111 {
 	struct mt9m111_context *ctx;
 	struct v4l2_rect rect;	/* cropping rectangle */
 	struct v4l2_clk *clk;
-	int width;		/* output */
-	int height;		/* sizes */
+	unsigned int width;	/* output */
+	unsigned int height;	/* sizes */
 	struct mutex power_lock; /* lock to protect power_count */
 	int power_count;
 	const struct mt9m111_datafmt *fmt;
diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 89c0b13..7b8962e 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -867,7 +867,7 @@ static int tvp5150_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
 	struct v4l2_rect rect = a->c;
 	struct tvp5150 *decoder = to_tvp5150(sd);
 	v4l2_std_id std;
-	int hmax;
+	unsigned int hmax;
 
 	v4l2_dbg(1, debug, sd, "%s left=%d, top=%d, width=%d, height=%d\n",
 		__func__, rect.left, rect.top, rect.width, rect.height);
@@ -877,9 +877,9 @@ static int tvp5150_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
 
 	/* tvp5150 has some special limits */
 	rect.left = clamp(rect.left, 0, TVP5150_MAX_CROP_LEFT);
-	rect.width = clamp(rect.width,
-			   TVP5150_H_MAX - TVP5150_MAX_CROP_LEFT - rect.left,
-			   TVP5150_H_MAX - rect.left);
+	rect.width = clamp_t(unsigned int, rect.width,
+			     TVP5150_H_MAX - TVP5150_MAX_CROP_LEFT - rect.left,
+			     TVP5150_H_MAX - rect.left);
 	rect.top = clamp(rect.top, 0, TVP5150_MAX_CROP_TOP);
 
 	/* Calculate height based on current standard */
@@ -893,9 +893,9 @@ static int tvp5150_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
 	else
 		hmax = TVP5150_V_MAX_OTHERS;
 
-	rect.height = clamp(rect.height,
-			    hmax - TVP5150_MAX_CROP_TOP - rect.top,
-			    hmax - rect.top);
+	rect.height = clamp_t(unsigned int, rect.height,
+			      hmax - TVP5150_MAX_CROP_TOP - rect.top,
+			      hmax - rect.top);
 
 	tvp5150_write(sd, TVP5150_VERT_BLANKING_START, rect.top);
 	tvp5150_write(sd, TVP5150_VERT_BLANKING_STOP,
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index c6532de..41ec4fa 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -1126,9 +1126,9 @@ bttv_crop_calc_limits(struct bttv_crop *c)
 		c->min_scaled_height = 32;
 	} else {
 		c->min_scaled_width =
-			(max(48, c->rect.width >> 4) + 3) & ~3;
+			(max_t(unsigned int, 48, c->rect.width >> 4) + 3) & ~3;
 		c->min_scaled_height =
-			max(32, c->rect.height >> 4);
+			max_t(unsigned int, 32, c->rect.height >> 4);
 	}
 
 	c->max_scaled_width  = c->rect.width & ~3;
@@ -2024,7 +2024,7 @@ limit_scaled_size_lock       (struct bttv_fh *               fh,
 		/* We cannot scale up. When the scaled image is larger
 		   than crop.rect we adjust the crop.rect as required
 		   by the V4L2 spec, hence cropcap.bounds are our limit. */
-		max_width = min(b->width, (__s32) MAX_HACTIVE);
+		max_width = min_t(unsigned int, b->width, MAX_HACTIVE);
 		max_height = b->height;
 
 		/* We cannot capture the same line as video and VBI data.
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index fb60da8..bdbd805 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1979,10 +1979,6 @@ static int saa7134_s_crop(struct file *file, void *f, const struct v4l2_crop *cr
 	if (crop->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
 	    crop->type != V4L2_BUF_TYPE_VIDEO_OVERLAY)
 		return -EINVAL;
-	if (crop->c.height < 0)
-		return -EINVAL;
-	if (crop->c.width < 0)
-		return -EINVAL;
 
 	if (res_locked(fh->dev, RESOURCE_OVERLAY))
 		return -EBUSY;
diff --git a/drivers/media/platform/soc_camera/soc_scale_crop.c b/drivers/media/platform/soc_camera/soc_scale_crop.c
index cbd3a34..8e74fb7 100644
--- a/drivers/media/platform/soc_camera/soc_scale_crop.c
+++ b/drivers/media/platform/soc_camera/soc_scale_crop.c
@@ -141,8 +141,8 @@ int soc_camera_client_s_crop(struct v4l2_subdev *sd,
 	 * Popular special case - some cameras can only handle fixed sizes like
 	 * QVGA, VGA,... Take care to avoid infinite loop.
 	 */
-	width = max(cam_rect->width, 2);
-	height = max(cam_rect->height, 2);
+	width = max_t(unsigned int, cam_rect->width, 2);
+	height = max_t(unsigned int, cam_rect->height, 2);
 
 	/*
 	 * Loop as long as sensor is not covering the requested rectangle and
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 437f1b0..6ae7bbe 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -207,8 +207,8 @@ enum v4l2_priority {
 struct v4l2_rect {
 	__s32   left;
 	__s32   top;
-	__s32   width;
-	__s32   height;
+	__u32   width;
+	__u32   height;
 };
 
 struct v4l2_fract {
-- 
1.8.4.rc3


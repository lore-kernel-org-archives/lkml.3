Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965226AbaGCKM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:12:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51630 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758294AbaGCJVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:21:48 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Olivier Langlois <olivier@trillion01.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 040/198] [media] uvcvideo: Fix clock param realtime setting
Date: Thu,  3 Jul 2014 10:18:03 +0100
Message-Id: <1404379241-8590-41-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivier Langlois <olivier@trillion01.com>

commit 3b35fc81e7ec552147a4fd843d0da0bbbe4ef253 upstream.

timestamps in v4l2 buffers returned to userspace are updated in
uvc_video_clock_update() which uses timestamps fetched from
uvc_video_clock_decode() by calling unconditionally ktime_get_ts().

Hence setting the module clock param to realtime has no effect before
this patch.

This has been tested with ffmpeg:

ffmpeg -y -f v4l2 -input_format yuyv422 -video_size 640x480 -framerate 30 -i /dev/video0 \
 -f alsa -acodec pcm_s16le -ar 16000 -ac 1 -i default \
 -c:v libx264 -preset ultrafast \
 -c:a libfdk_aac \
 out.mkv

and inspecting the v4l2 input starting timestamp.

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/usb/uvc/uvc_video.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index e1c5bf3ea112..c081812ac5c0 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -361,6 +361,14 @@ static int uvc_commit_video(struct uvc_streaming *stream,
  * Clocks and timestamps
  */
 
+static inline void uvc_video_get_ts(struct timespec *ts)
+{
+	if (uvc_clock_param == CLOCK_MONOTONIC)
+		ktime_get_ts(ts);
+	else
+		ktime_get_real_ts(ts);
+}
+
 static void
 uvc_video_clock_decode(struct uvc_streaming *stream, struct uvc_buffer *buf,
 		       const __u8 *data, int len)
@@ -420,7 +428,7 @@ uvc_video_clock_decode(struct uvc_streaming *stream, struct uvc_buffer *buf,
 	stream->clock.last_sof = dev_sof;
 
 	host_sof = usb_get_current_frame_number(stream->dev->udev);
-	ktime_get_ts(&ts);
+	uvc_video_get_ts(&ts);
 
 	/* The UVC specification allows device implementations that can't obtain
 	 * the USB frame number to keep their own frame counters as long as they
@@ -1010,10 +1018,7 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 			return -ENODATA;
 		}
 
-		if (uvc_clock_param == CLOCK_MONOTONIC)
-			ktime_get_ts(&ts);
-		else
-			ktime_get_real_ts(&ts);
+		uvc_video_get_ts(&ts);
 
 		buf->buf.v4l2_buf.sequence = stream->sequence;
 		buf->buf.v4l2_buf.timestamp.tv_sec = ts.tv_sec;
-- 
1.9.1


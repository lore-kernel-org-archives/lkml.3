Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934100AbaGOVxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:53:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54872 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759651AbaGOVi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:38:29 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Olivier Langlois <olivier@trillion01.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 048/198] [media] uvcvideo: Fix clock param realtime setting
Date: Tue, 15 Jul 2014 14:28:38 -0700
Message-Id: <1405459868-15089-49-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/usb/uvc/uvc_video.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index e32d6a5..2ef5b0f8 100644
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
@@ -1011,10 +1019,7 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
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


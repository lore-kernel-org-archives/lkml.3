Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbaF3Moj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:44:39 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754809AbaF3MbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:31:06 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Olivier Langlois <olivier@trillion01.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 143/181] media: uvcvideo: Fix clock param realtime setting
Date: Mon, 30 Jun 2014 13:52:44 +0200
Message-Id: <1b7e7f0b92251b1ba9c08336b599e6465e7de259.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olivier Langlois <olivier@trillion01.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
2.0.0


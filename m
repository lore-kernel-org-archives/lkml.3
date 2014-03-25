Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551AbaCYElO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 00:41:14 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:42559 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbaCYElM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 00:41:12 -0400
From: Anton Leontiev <bunder@t-25.ru>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anton Leontiev <bunder@t-25.ru>
Subject: [PATCH] [media] uvcvideo: Fix marking buffer erroneous in case of FID toggling
Date: Tue, 25 Mar 2014 08:40:57 +0400
Message-Id: <1395722457-28080-1-git-send-email-bunder@t-25.ru>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set error bit for incomplete buffers when end of buffer is detected by
FID toggling (for example when last transaction with EOF is lost).
This prevents passing incomplete buffers to the userspace.

Signed-off-by: Anton Leontiev <bunder@t-25.ru>
---
 drivers/media/usb/uvc/uvc_video.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 8d52baf..57c9a4b 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1133,6 +1133,17 @@ static int uvc_video_encode_data(struct uvc_streaming *stream,
  */
 
 /*
+ * Set error flag for incomplete buffer.
+ */
+static void uvc_buffer_check_bytesused(const struct uvc_streaming *const stream,
+	struct uvc_buffer *const buf)
+{
+	if (buf->length != buf->bytesused &&
+			!(stream->cur_format->flags & UVC_FMT_FLAG_COMPRESSED))
+		buf->error = 1;
+}
+
+/*
  * Completion handler for video URBs.
  */
 static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming *stream,
@@ -1156,9 +1167,11 @@ static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming *stream,
 		do {
 			ret = uvc_video_decode_start(stream, buf, mem,
 				urb->iso_frame_desc[i].actual_length);
-			if (ret == -EAGAIN)
+			if (ret == -EAGAIN) {
+				uvc_buffer_check_bytesused(stream, buf);
 				buf = uvc_queue_next_buffer(&stream->queue,
 							    buf);
+			}
 		} while (ret == -EAGAIN);
 
 		if (ret < 0)
@@ -1173,11 +1186,7 @@ static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming *stream,
 			urb->iso_frame_desc[i].actual_length);
 
 		if (buf->state == UVC_BUF_STATE_READY) {
-			if (buf->length != buf->bytesused &&
-			    !(stream->cur_format->flags &
-			      UVC_FMT_FLAG_COMPRESSED))
-				buf->error = 1;
-
+			uvc_buffer_check_bytesused(stream, buf);
 			buf = uvc_queue_next_buffer(&stream->queue, buf);
 		}
 	}
-- 
1.9.1


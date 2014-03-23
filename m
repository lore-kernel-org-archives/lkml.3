Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbaCWPav (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 11:30:51 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:55958 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbaCWPas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 11:30:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Roland Scheidegger <rscheidegger_lists@hispeed.ch>
Subject: [PATCH 1/2] usb: gadget: uvc: Switch to monotonic clock for buffer timestamps
Date: Sun, 23 Mar 2014 16:32:33 +0100
Message-Id: <1395588754-20587-2-git-send-email-laurent.pinchart@ideasonboard.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395588754-20587-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <20140323001018.GA11963@localhost>
 <1395588754-20587-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wall time clock isn't useful for applications as it can jump around
due to time adjustement. Switch to the monotonic clock.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/usb/gadget/uvc_queue.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/gadget/uvc_queue.c b/drivers/usb/gadget/uvc_queue.c
index 0bb5d50..d4561ba 100644
--- a/drivers/usb/gadget/uvc_queue.c
+++ b/drivers/usb/gadget/uvc_queue.c
@@ -364,6 +364,7 @@ static struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
 						struct uvc_buffer *buf)
 {
 	struct uvc_buffer *nextbuf;
+	struct timespec ts;
 
 	if ((queue->flags & UVC_QUEUE_DROP_INCOMPLETE) &&
 	     buf->length != buf->bytesused) {
@@ -379,14 +380,11 @@ static struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
 	else
 		nextbuf = NULL;
 
-	/*
-	 * FIXME: with videobuf2, the sequence number or timestamp fields
-	 * are valid only for video capture devices and the UVC gadget usually
-	 * is a video output device. Keeping these until the specs are clear on
-	 * this aspect.
-	 */
+	ktime_get_ts(&ts);
+
 	buf->buf.v4l2_buf.sequence = queue->sequence++;
-	do_gettimeofday(&buf->buf.v4l2_buf.timestamp);
+	buf->buf.v4l2_buf.timestamp.tv_sec = ts.tv_sec;
+	buf->buf.v4l2_buf.timestamp.tv_usec = ts.tv_nsec / NSEC_PER_USEC;
 
 	vb2_set_plane_payload(&buf->buf, 0, buf->bytesused);
 	vb2_buffer_done(&buf->buf, VB2_BUF_STATE_DONE);
-- 
1.8.3.2


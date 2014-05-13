Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760356AbaEMJn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:43:26 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60890 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760105AbaEMJ25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:57 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Oleksij Rempel <linux@rempel-privat.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 086/182] media: uvcvideo: Do not use usb_set_interface on bulk EP
Date: Tue, 13 May 2014 11:27:18 +0200
Message-Id: <4ed175cff81f5698b532610c0051fa42cc4c368e.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleksij Rempel <linux@rempel-privat.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b1e43f232698274871e1358c276d7b0242a7d607 upstream.

The UVC specification uses alternate setting selection to notify devices
of stream start/stop. This breaks when using bulk-based devices, as the
video streaming interface has a single alternate setting in that case,
making video stream start and video stream stop events to appear
identical to the device. Bulk-based devices are thus not well supported
by UVC.

The webcam built in the Asus Zenbook UX302LA ignores the set interface
request and will keep the video stream enabled when the driver tries to
stop it. If USB autosuspend is enabled the device will then be suspended
and will crash, requiring a cold reboot.

USB trace capture showed that Windows sends a CLEAR_FEATURE(HALT)
request to the bulk endpoint when stopping the stream instead of
selecting alternate setting 0. The camera then behaves correctly, and
thus seems to require that behaviour.

Replace selection of alternate setting 0 with clearing of the endpoint
halt feature at video stream stop for bulk-based devices. Let's refrain
from blaming Microsoft this time, as it's not clear whether this
Windows-specific but USB-compliant behaviour was specifically developed
to handle bulkd-based UVC devices, or if the camera just took advantage
of it.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/usb/uvc/uvc_video.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 3394c3432011..e1c5bf3ea112 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1846,7 +1846,25 @@ int uvc_video_enable(struct uvc_streaming *stream, int enable)
 
 	if (!enable) {
 		uvc_uninit_video(stream, 1);
-		usb_set_interface(stream->dev->udev, stream->intfnum, 0);
+		if (stream->intf->num_altsetting > 1) {
+			usb_set_interface(stream->dev->udev,
+					  stream->intfnum, 0);
+		} else {
+			/* UVC doesn't specify how to inform a bulk-based device
+			 * when the video stream is stopped. Windows sends a
+			 * CLEAR_FEATURE(HALT) request to the video streaming
+			 * bulk endpoint, mimic the same behaviour.
+			 */
+			unsigned int epnum = stream->header.bEndpointAddress
+					   & USB_ENDPOINT_NUMBER_MASK;
+			unsigned int dir = stream->header.bEndpointAddress
+					 & USB_ENDPOINT_DIR_MASK;
+			unsigned int pipe;
+
+			pipe = usb_sndbulkpipe(stream->dev->udev, epnum) | dir;
+			usb_clear_halt(stream->dev->udev, pipe);
+		}
+
 		uvc_queue_enable(&stream->queue, 0);
 		uvc_video_clock_cleanup(stream);
 		return 0;
-- 
1.9.3


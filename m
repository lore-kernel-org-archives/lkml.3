Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbaEDPmB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:42:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36232 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbaEDPly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oleksij Rempel <linux@rempel-privat.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.14 110/158] media: uvcvideo: Do not use usb_set_interface on bulk EP
Date: Sun,  4 May 2014 11:40:19 -0400
Message-Id: <20140504154044.955675000@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <linux@rempel-privat.de>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/uvc/uvc_video.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1847,7 +1847,25 @@ int uvc_video_enable(struct uvc_streamin
 
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



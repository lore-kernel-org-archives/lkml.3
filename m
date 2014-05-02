Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbaEBQKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:10:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43952 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbaEBPnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:43:05 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleksij Rempel <linux@rempel-privat.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 029/151] [media] uvcvideo: Do not use usb_set_interface on bulk EP
Date: Fri,  2 May 2014 08:36:57 -0700
Message-Id: <1399045139-4531-30-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/usb/uvc/uvc_video.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 898c208..e32d6a5 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1847,7 +1847,25 @@ int uvc_video_enable(struct uvc_streaming *stream, int enable)
 
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
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbaD1Bcu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:32:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42968 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752659AbaD1B3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
        "Mauro Carvalho Chehab" <m.chehab@samsung.com>,
        "Oleksij Rempel" <linux@rempel-privat.de>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.427428393@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 35/94] [media] uvcvideo: Do not use usb_set_interface
 on bulk EP
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/video/uvc/uvc_video.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -1267,7 +1267,25 @@ int uvc_video_enable(struct uvc_streamin
 
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
 		return 0;
 	}


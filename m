Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab3DXAnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 20:43:00 -0400
Received: from mail-gg0-f201.google.com ([209.85.161.201]:47010 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab3DXAm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 20:42:58 -0400
From: Shawn Nematbakhsh <shawnn@chromium.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, shawnn@chromium.org
Subject: [PATCH] [media] uvcvideo: Retry usb_submit_urb on -EPERM return
Date: Tue, 23 Apr 2013 17:42:32 -0700
Message-Id: <1366764152-9797-1-git-send-email-shawnn@chromium.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While usb_kill_urb is in progress, calls to usb_submit_urb will fail
with -EPERM (documented in Documentation/usb/URB.txt). The UVC driver
does not correctly handle this case -- there is no synchronization
between uvc_v4l2_open / uvc_status_start and uvc_v4l2_release /
uvc_status_stop.

This patch adds a retry / timeout when uvc_status_open / usb_submit_urb
returns -EPERM. This usually means that usb_kill_urb is in progress, and
we just need to wait a while.

Signed-off-by: Shawn Nematbakhsh <shawnn@chromium.org>
---
 drivers/media/usb/uvc/uvc_v4l2.c | 10 +++++++++-
 drivers/media/usb/uvc/uvcvideo.h |  1 +
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index b2dc326..f1498a8 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -479,6 +479,7 @@ static int uvc_v4l2_open(struct file *file)
 {
 	struct uvc_streaming *stream;
 	struct uvc_fh *handle;
+	unsigned long timeout;
 	int ret = 0;
 
 	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_open\n");
@@ -499,7 +500,14 @@ static int uvc_v4l2_open(struct file *file)
 	}
 
 	if (atomic_inc_return(&stream->dev->users) == 1) {
-		ret = uvc_status_start(stream->dev);
+		timeout = jiffies + msecs_to_jiffies(UVC_STATUS_START_TIMEOUT);
+		/* -EPERM means stop in progress, wait for completion */
+		do {
+			ret = uvc_status_start(stream->dev);
+			if (ret == -EPERM)
+				usleep_range(5000, 6000);
+		} while (ret == -EPERM && time_before(jiffies, timeout));
+
 		if (ret < 0) {
 			atomic_dec(&stream->dev->users);
 			usb_autopm_put_interface(stream->dev->intf);
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index af505fd..a47e1d3 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -122,6 +122,7 @@
 
 #define UVC_CTRL_CONTROL_TIMEOUT	300
 #define UVC_CTRL_STREAMING_TIMEOUT	5000
+#define UVC_STATUS_START_TIMEOUT	100
 
 /* Maximum allowed number of control mappings per device */
 #define UVC_MAX_CONTROL_MAPPINGS	1024
-- 
1.7.12.4


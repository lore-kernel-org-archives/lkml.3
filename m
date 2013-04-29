Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759045Ab3D2Uew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 16:34:52 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:53430 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758942Ab3D2Ueu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 16:34:50 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Shawn Nematbakhsh <shawnn@chromium.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] uvcvideo: Retry usb_submit_urb on -EPERM return
Date: Mon, 29 Apr 2013 22:34:56 +0200
Message-ID: <2335654.c00h6tDv9u@avalon>
User-Agent: KMail/4.10.2 (Linux/3.7.10-gentoo-r1; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1366764152-9797-1-git-send-email-shawnn@chromium.org>
References: <1366764152-9797-1-git-send-email-shawnn@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shawn,

Thank you for the patch.

On Tuesday 23 April 2013 17:42:32 Shawn Nematbakhsh wrote:
> While usb_kill_urb is in progress, calls to usb_submit_urb will fail
> with -EPERM (documented in Documentation/usb/URB.txt). The UVC driver
> does not correctly handle this case -- there is no synchronization
> between uvc_v4l2_open / uvc_status_start and uvc_v4l2_release /
> uvc_status_stop.

Wouldn't it be better to synchronize status operations in open/release ?
Something like the following patch:

>From 9285d678ed2f823bb215f6bdec3ca1a9e1cac977 Mon Sep 17 00:00:00 2001
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date: Fri, 26 Apr 2013 03:28:51 +0200
Subject: [PATCH] uvcvideo: Fix open/close race condition

Maintaining the users count using an atomic variable makes sure that
access to the counter won't be racy, but doesn't serialize access to the
operations protected by the counter. This creates a race condition that
could result in the status URB being submitted multiple times.

Use a mutex to protect the users count and serialize access to the
status start and stop operations.

Reported-by: Shawn Nematbakhsh <shawnn@chromium.org>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 22 ++++++++++++++++------
 drivers/media/usb/uvc/uvc_status.c | 21 ++-------------------
 drivers/media/usb/uvc/uvc_v4l2.c   | 14 ++++++++++----
 drivers/media/usb/uvc/uvcvideo.h   |  7 +++----
 4 files changed, 31 insertions(+), 33 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index e68fa53..b638037 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1836,8 +1836,8 @@ static int uvc_probe(struct usb_interface *intf,
 	INIT_LIST_HEAD(&dev->chains);
 	INIT_LIST_HEAD(&dev->streams);
 	atomic_set(&dev->nstreams, 0);
-	atomic_set(&dev->users, 0);
 	atomic_set(&dev->nmappings, 0);
+	mutex_init(&dev->lock);
 
 	dev->udev = usb_get_dev(udev);
 	dev->intf = usb_get_intf(intf);
@@ -1953,8 +1953,12 @@ static int uvc_suspend(struct usb_interface *intf, pm_message_t message)
 
 	/* Controls are cached on the fly so they don't need to be saved. */
 	if (intf->cur_altsetting->desc.bInterfaceSubClass ==
-	    UVC_SC_VIDEOCONTROL)
-		return uvc_status_suspend(dev);
+	    UVC_SC_VIDEOCONTROL) {
+		mutex_lock(&dev->lock);
+		if (dev->users)
+			uvc_status_stop(dev);
+		mutex_unlock(&dev->lock);
+	}
 
 	list_for_each_entry(stream, &dev->streams, list) {
 		if (stream->intf == intf)
@@ -1976,14 +1980,20 @@ static int __uvc_resume(struct usb_interface *intf, int reset)
 
 	if (intf->cur_altsetting->desc.bInterfaceSubClass ==
 	    UVC_SC_VIDEOCONTROL) {
-		if (reset) {
-			int ret = uvc_ctrl_resume_device(dev);
+		int ret = 0;
 
+		if (reset) {
+			ret = uvc_ctrl_resume_device(dev);
 			if (ret < 0)
 				return ret;
 		}
 
-		return uvc_status_resume(dev);
+		mutex_lock(&dev->lock);
+		if (dev->users)
+			ret = uvc_status_start(dev, GFP_NOIO);
+		mutex_unlock(&dev->lock);
+
+		return ret;
 	}
 
 	list_for_each_entry(stream, &dev->streams, list) {
diff --git a/drivers/media/usb/uvc/uvc_status.c b/drivers/media/usb/uvc/uvc_status.c
index b749277..f552ab9 100644
--- a/drivers/media/usb/uvc/uvc_status.c
+++ b/drivers/media/usb/uvc/uvc_status.c
@@ -206,32 +206,15 @@ void uvc_status_cleanup(struct uvc_device *dev)
 	uvc_input_cleanup(dev);
 }
 
-int uvc_status_start(struct uvc_device *dev)
+int uvc_status_start(struct uvc_device *dev, gfp_t flags)
 {
 	if (dev->int_urb == NULL)
 		return 0;
 
-	return usb_submit_urb(dev->int_urb, GFP_KERNEL);
+	return usb_submit_urb(dev->int_urb, flags);
 }
 
 void uvc_status_stop(struct uvc_device *dev)
 {
 	usb_kill_urb(dev->int_urb);
 }
-
-int uvc_status_suspend(struct uvc_device *dev)
-{
-	if (atomic_read(&dev->users))
-		usb_kill_urb(dev->int_urb);
-
-	return 0;
-}
-
-int uvc_status_resume(struct uvc_device *dev)
-{
-	if (dev->int_urb == NULL || atomic_read(&dev->users) == 0)
-		return 0;
-
-	return usb_submit_urb(dev->int_urb, GFP_NOIO);
-}
-
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index b2dc326..3afff92 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -498,16 +498,20 @@ static int uvc_v4l2_open(struct file *file)
 		return -ENOMEM;
 	}
 
-	if (atomic_inc_return(&stream->dev->users) == 1) {
-		ret = uvc_status_start(stream->dev);
+	mutex_lock(&stream->dev->lock);
+	if (stream->dev->users == 0) {
+		ret = uvc_status_start(stream->dev, GFP_KERNEL);
 		if (ret < 0) {
-			atomic_dec(&stream->dev->users);
+			mutex_unlock(&stream->dev->lock);
 			usb_autopm_put_interface(stream->dev->intf);
 			kfree(handle);
 			return ret;
 		}
 	}
 
+	stream->dev->users++;
+	mutex_unlock(&stream->dev->lock);
+
 	v4l2_fh_init(&handle->vfh, stream->vdev);
 	v4l2_fh_add(&handle->vfh);
 	handle->chain = stream->chain;
@@ -538,8 +542,10 @@ static int uvc_v4l2_release(struct file *file)
 	kfree(handle);
 	file->private_data = NULL;
 
-	if (atomic_dec_return(&stream->dev->users) == 0)
+	mutex_lock(&stream->dev->lock);
+	if (--stream->dev->users == 0)
 		uvc_status_stop(stream->dev);
+	mutex_unlock(&stream->dev->lock);
 
 	usb_autopm_put_interface(stream->dev->intf);
 	return 0;
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 9cd584a..eb90a92 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -515,7 +515,8 @@ struct uvc_device {
 	char name[32];
 
 	enum uvc_device_state state;
-	atomic_t users;
+	struct mutex lock;		/* Protects users */
+	unsigned int users;
 	atomic_t nmappings;
 
 	/* Video control interface */
@@ -661,10 +662,8 @@ void uvc_video_clock_update(struct uvc_streaming *stream,
 /* Status */
 extern int uvc_status_init(struct uvc_device *dev);
 extern void uvc_status_cleanup(struct uvc_device *dev);
-extern int uvc_status_start(struct uvc_device *dev);
+extern int uvc_status_start(struct uvc_device *dev, gfp_t flags);
 extern void uvc_status_stop(struct uvc_device *dev);
-extern int uvc_status_suspend(struct uvc_device *dev);
-extern int uvc_status_resume(struct uvc_device *dev);
 
 /* Controls */
 extern const struct v4l2_subscribed_event_ops uvc_ctrl_sub_ev_ops;

> This patch adds a retry / timeout when uvc_status_open / usb_submit_urb
> returns -EPERM. This usually means that usb_kill_urb is in progress, and
> we just need to wait a while.
> 
> Signed-off-by: Shawn Nematbakhsh <shawnn@chromium.org>
> ---
>  drivers/media/usb/uvc/uvc_v4l2.c | 10 +++++++++-
>  drivers/media/usb/uvc/uvcvideo.h |  1 +
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
> b/drivers/media/usb/uvc/uvc_v4l2.c index b2dc326..f1498a8 100644
> --- a/drivers/media/usb/uvc/uvc_v4l2.c
> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> @@ -479,6 +479,7 @@ static int uvc_v4l2_open(struct file *file)
>  {
>  	struct uvc_streaming *stream;
>  	struct uvc_fh *handle;
> +	unsigned long timeout;
>  	int ret = 0;
> 
>  	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_open\n");
> @@ -499,7 +500,14 @@ static int uvc_v4l2_open(struct file *file)
>  	}
> 
>  	if (atomic_inc_return(&stream->dev->users) == 1) {
> -		ret = uvc_status_start(stream->dev);
> +		timeout = jiffies + msecs_to_jiffies(UVC_STATUS_START_TIMEOUT);
> +		/* -EPERM means stop in progress, wait for completion */
> +		do {
> +			ret = uvc_status_start(stream->dev);
> +			if (ret == -EPERM)
> +				usleep_range(5000, 6000);
> +		} while (ret == -EPERM && time_before(jiffies, timeout));
> +
>  		if (ret < 0) {
>  			atomic_dec(&stream->dev->users);
>  			usb_autopm_put_interface(stream->dev->intf);
> diff --git a/drivers/media/usb/uvc/uvcvideo.h
> b/drivers/media/usb/uvc/uvcvideo.h index af505fd..a47e1d3 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -122,6 +122,7 @@
> 
>  #define UVC_CTRL_CONTROL_TIMEOUT	300
>  #define UVC_CTRL_STREAMING_TIMEOUT	5000
> +#define UVC_STATUS_START_TIMEOUT	100
> 
>  /* Maximum allowed number of control mappings per device */
>  #define UVC_MAX_CONTROL_MAPPINGS	1024
-- 
Regards,

Laurent Pinchart


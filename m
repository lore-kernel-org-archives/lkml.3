Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbbALOKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 09:10:49 -0500
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:59916 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753426AbbALOKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 09:10:44 -0500
Message-ID: <54B3D5D5.9060602@xs4all.nl>
Date: Mon, 12 Jan 2015 15:10:29 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Shuah Khan <shuahkh@osg.samsung.com>, m.chehab@samsung.com,
        hans.verkuil@cisco.com, dheitmueller@kernellabs.com,
        prabhakar.csengg@gmail.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, ttmesterr@gmail.com
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] media: au0828 remove video and vbi buffer timeout
 work-around
References: <cover.1418918401.git.shuahkh@osg.samsung.com> <7210fb24807adf46f76197a12dab11358f4dcd30.1418918402.git.shuahkh@osg.samsung.com>
In-Reply-To: <7210fb24807adf46f76197a12dab11358f4dcd30.1418918402.git.shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2014 05:20 PM, Shuah Khan wrote:
> au0828 does video and vbi buffer timeout handling to prevent
> applications such as tvtime from hanging by ensuring that the
> video frames continue to be delivered even when the ITU-656
> input isn't receiving any data. This work-around is complex
> as it introduces set and clear tier code paths in start/stop
> streaming, and close interfaces. After the vb2 conversion, the
> timeout handling is introducing instability as well as feeding
> too many blank green screens, resulting in degraded video quality.

Why would this result in degraded video quality? And which instability
exactly?

> Without this timeout handling, both xawtv, and tvtime are working
> well with good quality video.

Erm, tvtime without the recent 'tvtime: don't block indefinitely waiting
for frames' patch will not work well with au0828 without the timeout code
if there is no valid video data.

This should at minimum be mentioned in the commit log.

Especially if this fixes other issues as you mentioned in the log I am
all for it. But others will probably object to this.

Regards,

	Hans

> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  drivers/media/usb/au0828/au0828-video.c | 103 +-------------------------------
>  drivers/media/usb/au0828/au0828.h       |   5 --
>  2 files changed, 1 insertion(+), 107 deletions(-)
> 
> diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
> index ef49b2e..3bdf132 100644
> --- a/drivers/media/usb/au0828/au0828-video.c
> +++ b/drivers/media/usb/au0828/au0828-video.c
> @@ -593,15 +593,6 @@ static inline int au0828_isoc_copy(struct au0828_dev *dev, struct urb *urb)
>  					outp = NULL;
>  				else
>  					outp = vb2_plane_vaddr(&buf->vb, 0);
> -
> -				/* As long as isoc traffic is arriving, keep
> -				   resetting the timer */
> -				if (dev->vid_timeout_running)
> -					mod_timer(&dev->vid_timeout,
> -						  jiffies + (HZ / 10));
> -				if (dev->vbi_timeout_running)
> -					mod_timer(&dev->vbi_timeout,
> -						  jiffies + (HZ / 10));
>  			}
>  
>  			if (buf != NULL) {
> @@ -804,15 +795,9 @@ int au0828_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
>  			return rc;
>  		}
>  
> -		if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> +		if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
>  			v4l2_device_call_all(&dev->v4l2_dev, 0, video,
>  						s_stream, 1);
> -			dev->vid_timeout_running = 1;
> -			mod_timer(&dev->vid_timeout, jiffies + (HZ / 10));
> -		} else if (vq->type == V4L2_BUF_TYPE_VBI_CAPTURE) {
> -			dev->vbi_timeout_running = 1;
> -			mod_timer(&dev->vbi_timeout, jiffies + (HZ / 10));
> -		}
>  	}
>  	dev->streaming_users++;
>  	return rc;
> @@ -851,9 +836,6 @@ static void au0828_stop_streaming(struct vb2_queue *vq)
>  		(AUVI_INPUT(i).audio_setup)(dev, 0);
>  	}
>  	spin_unlock_irqrestore(&dev->slock, flags);
> -
> -	dev->vid_timeout_running = 0;
> -	del_timer_sync(&dev->vid_timeout);
>  }
>  
>  void au0828_stop_vbi_streaming(struct vb2_queue *vq)
> @@ -882,9 +864,6 @@ void au0828_stop_vbi_streaming(struct vb2_queue *vq)
>  		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
>  	}
>  	spin_unlock_irqrestore(&dev->slock, flags);
> -
> -	dev->vbi_timeout_running = 0;
> -	del_timer_sync(&dev->vbi_timeout);
>  }
>  
>  static struct vb2_ops au0828_video_qops = {
> @@ -917,56 +896,6 @@ void au0828_analog_unregister(struct au0828_dev *dev)
>  	mutex_unlock(&au0828_sysfs_lock);
>  }
>  
> -/* This function ensures that video frames continue to be delivered even if
> -   the ITU-656 input isn't receiving any data (thereby preventing applications
> -   such as tvtime from hanging) */
> -static void au0828_vid_buffer_timeout(unsigned long data)
> -{
> -	struct au0828_dev *dev = (struct au0828_dev *) data;
> -	struct au0828_dmaqueue *dma_q = &dev->vidq;
> -	struct au0828_buffer *buf;
> -	unsigned char *vid_data;
> -	unsigned long flags = 0;
> -
> -	spin_lock_irqsave(&dev->slock, flags);
> -
> -	buf = dev->isoc_ctl.buf;
> -	if (buf != NULL) {
> -		vid_data = vb2_plane_vaddr(&buf->vb, 0);
> -		memset(vid_data, 0x00, buf->length); /* Blank green frame */
> -		buffer_filled(dev, dma_q, buf);
> -	}
> -	get_next_buf(dma_q, &buf);
> -
> -	if (dev->vid_timeout_running == 1)
> -		mod_timer(&dev->vid_timeout, jiffies + (HZ / 10));
> -
> -	spin_unlock_irqrestore(&dev->slock, flags);
> -}
> -
> -static void au0828_vbi_buffer_timeout(unsigned long data)
> -{
> -	struct au0828_dev *dev = (struct au0828_dev *) data;
> -	struct au0828_dmaqueue *dma_q = &dev->vbiq;
> -	struct au0828_buffer *buf;
> -	unsigned char *vbi_data;
> -	unsigned long flags = 0;
> -
> -	spin_lock_irqsave(&dev->slock, flags);
> -
> -	buf = dev->isoc_ctl.vbi_buf;
> -	if (buf != NULL) {
> -		vbi_data = vb2_plane_vaddr(&buf->vb, 0);
> -		memset(vbi_data, 0x00, buf->length);
> -		vbi_buffer_filled(dev, dma_q, buf);
> -	}
> -	vbi_get_next_buf(dma_q, &buf);
> -
> -	if (dev->vbi_timeout_running == 1)
> -		mod_timer(&dev->vbi_timeout, jiffies + (HZ / 10));
> -	spin_unlock_irqrestore(&dev->slock, flags);
> -}
> -
>  static int au0828_v4l2_open(struct file *filp)
>  {
>  	struct video_device *vdev = video_devdata(filp);
> @@ -1016,7 +945,6 @@ static int au0828_v4l2_close(struct file *filp)
>  {
>  	int ret;
>  	struct au0828_dev *dev = video_drvdata(filp);
> -	struct video_device *vdev = video_devdata(filp);
>  
>  	dprintk(1,
>  		"%s called std_set %d dev_state %d stream users %d users %d\n",
> @@ -1024,17 +952,6 @@ static int au0828_v4l2_close(struct file *filp)
>  		dev->streaming_users, dev->users);
>  
>  	mutex_lock(&dev->lock);
> -	if (vdev->vfl_type == VFL_TYPE_GRABBER && dev->vid_timeout_running) {
> -		/* Cancel timeout thread in case they didn't call streamoff */
> -		dev->vid_timeout_running = 0;
> -		del_timer_sync(&dev->vid_timeout);
> -	} else if (vdev->vfl_type == VFL_TYPE_VBI &&
> -			dev->vbi_timeout_running) {
> -		/* Cancel timeout thread in case they didn't call streamoff */
> -		dev->vbi_timeout_running = 0;
> -		del_timer_sync(&dev->vbi_timeout);
> -	}
> -
>  	if (dev->dev_state == DEV_DISCONNECTED)
>  		goto end;
>  
> @@ -1626,11 +1543,6 @@ void au0828_v4l2_suspend(struct au0828_dev *dev)
>  			}
>  		}
>  	}
> -
> -	if (dev->vid_timeout_running)
> -		del_timer_sync(&dev->vid_timeout);
> -	if (dev->vbi_timeout_running)
> -		del_timer_sync(&dev->vbi_timeout);
>  }
>  
>  void au0828_v4l2_resume(struct au0828_dev *dev)
> @@ -1644,11 +1556,6 @@ void au0828_v4l2_resume(struct au0828_dev *dev)
>  		au0828_init_tuner(dev);
>  	}
>  
> -	if (dev->vid_timeout_running)
> -		mod_timer(&dev->vid_timeout, jiffies + (HZ / 10));
> -	if (dev->vbi_timeout_running)
> -		mod_timer(&dev->vbi_timeout, jiffies + (HZ / 10));
> -
>  	/* If we were doing ac97 instead of i2s, it would go here...*/
>  	au0828_i2s_init(dev);
>  
> @@ -1817,14 +1724,6 @@ int au0828_analog_register(struct au0828_dev *dev,
>  	INIT_LIST_HEAD(&dev->vidq.active);
>  	INIT_LIST_HEAD(&dev->vbiq.active);
>  
> -	dev->vid_timeout.function = au0828_vid_buffer_timeout;
> -	dev->vid_timeout.data = (unsigned long) dev;
> -	init_timer(&dev->vid_timeout);
> -
> -	dev->vbi_timeout.function = au0828_vbi_buffer_timeout;
> -	dev->vbi_timeout.data = (unsigned long) dev;
> -	init_timer(&dev->vbi_timeout);
> -
>  	dev->width = NTSC_STD_W;
>  	dev->height = NTSC_STD_H;
>  	dev->field_size = dev->width * dev->height;
> diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
> index eb15187..9dac92e 100644
> --- a/drivers/media/usb/au0828/au0828.h
> +++ b/drivers/media/usb/au0828/au0828.h
> @@ -221,11 +221,6 @@ struct au0828_dev {
>  	unsigned int frame_count;
>  	unsigned int vbi_frame_count;
>  
> -	struct timer_list vid_timeout;
> -	int vid_timeout_running;
> -	struct timer_list vbi_timeout;
> -	int vbi_timeout_running;
> -
>  	int users;
>  	int streaming_users;
>  
> 


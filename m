Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbbALOdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 09:33:16 -0500
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:49232 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752919AbbALOdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 09:33:14 -0500
Message-ID: <54B3DB1C.50505@xs4all.nl>
Date: Mon, 12 Jan 2015 15:33:00 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Shuah Khan <shuahkh@osg.samsung.com>, m.chehab@samsung.com,
        hans.verkuil@cisco.com, dheitmueller@kernellabs.com,
        prabhakar.csengg@gmail.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, ttmesterr@gmail.com
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] media: au0828 - convert to use videobuf2
References: <cover.1418918401.git.shuahkh@osg.samsung.com> <14b955f13c972a55bcfeaf6734f3487c320260bb.1418918402.git.shuahkh@osg.samsung.com>
In-Reply-To: <14b955f13c972a55bcfeaf6734f3487c320260bb.1418918402.git.shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shuah,

Looks good! I do have a few small comments, see below.

On 12/18/2014 05:20 PM, Shuah Khan wrote:
> Convert au0828 to use videobuf2. Tested with NTSC.
> Tested video and vbi devices with xawtv, tvtime,
> and vlc. Ran v4l2-compliance to ensure there are
> no new regressions in video and vbi now has 3 fewer
> failures.
> 
> video before:
> test VIDIOC_G_FMT: FAIL 3 failures
> Total: 72, Succeeded: 69, Failed: 3, Warnings: 0
> 
> Video after:
> test VIDIOC_G_FMT: FAIL 3 failures
> Total: 72, Succeeded: 69, Failed: 3, Warnings: 0
> 
> vbi before:
> test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: FAIL
> test VIDIOC_EXPBUF: FAIL
> test USERPTR: FAIL
> Total: 72, Succeeded: 66, Failed: 6, Warnings: 0
> 
> vbi after:
> test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
> test VIDIOC_EXPBUF: OK (Not Supported)
> test USERPTR: OK
> Total: 72, Succeeded: 69, Failed: 3, Warnings: 0
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  drivers/media/usb/au0828/Kconfig        |   2 +-
>  drivers/media/usb/au0828/au0828-cards.c |   2 +-
>  drivers/media/usb/au0828/au0828-vbi.c   | 122 ++--
>  drivers/media/usb/au0828/au0828-video.c | 949 +++++++++++++-------------------
>  drivers/media/usb/au0828/au0828.h       |  61 +-
>  5 files changed, 444 insertions(+), 692 deletions(-)
> 
> diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
> index 5f337b1..3011ca8 100644
> --- a/drivers/media/usb/au0828/au0828-video.c
> +++ b/drivers/media/usb/au0828/au0828-video.c
> +void au0828_analog_unregister(struct au0828_dev *dev)
>  {
> -	switch (fh->type) {
> -	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> -		return AU0828_RESOURCE_VIDEO;
> -	case V4L2_BUF_TYPE_VBI_CAPTURE:
> -		return AU0828_RESOURCE_VBI;
> -	default:
> -		BUG();
> -		return 0;
> -	}
> +	dprintk(1, "au0828_analog_unregister called\n");
> +	mutex_lock(&au0828_sysfs_lock);
> +
> +	if (dev->vdev)
> +		video_unregister_device(dev->vdev);
> +	if (dev->vbi_dev)
> +		video_unregister_device(dev->vbi_dev);
> +
> +	mutex_unlock(&au0828_sysfs_lock);
>  }
>  
>  /* This function ensures that video frames continue to be delivered even if
> @@ -951,8 +932,8 @@ static void au0828_vid_buffer_timeout(unsigned long data)
>  
>  	buf = dev->isoc_ctl.buf;
>  	if (buf != NULL) {
> -		vid_data = videobuf_to_vmalloc(&buf->vb);
> -		memset(vid_data, 0x00, buf->vb.size); /* Blank green frame */
> +		vid_data = vb2_plane_vaddr(&buf->vb, 0);
> +		memset(vid_data, 0x00, buf->length); /* Blank green frame */
>  		buffer_filled(dev, dma_q, buf);
>  	}
>  	get_next_buf(dma_q, &buf);
> @@ -975,8 +956,8 @@ static void au0828_vbi_buffer_timeout(unsigned long data)
>  
>  	buf = dev->isoc_ctl.vbi_buf;
>  	if (buf != NULL) {
> -		vbi_data = videobuf_to_vmalloc(&buf->vb);
> -		memset(vbi_data, 0x00, buf->vb.size);
> +		vbi_data = vb2_plane_vaddr(&buf->vb, 0);
> +		memset(vbi_data, 0x00, buf->length);
>  		vbi_buffer_filled(dev, dma_q, buf);
>  	}
>  	vbi_get_next_buf(dma_q, &buf);
> @@ -986,14 +967,12 @@ static void au0828_vbi_buffer_timeout(unsigned long data)
>  	spin_unlock_irqrestore(&dev->slock, flags);
>  }
>  
> -
>  static int au0828_v4l2_open(struct file *filp)
>  {
> -	int ret = 0;
>  	struct video_device *vdev = video_devdata(filp);
>  	struct au0828_dev *dev = video_drvdata(filp);
> -	struct au0828_fh *fh;
>  	int type;
> +	int ret = 0;
>  
>  	switch (vdev->vfl_type) {
>  	case VFL_TYPE_GRABBER:

This switch can be removed.

> @@ -1957,17 +1693,23 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
>  	.vidioc_g_audio             = vidioc_g_audio,
>  	.vidioc_s_audio             = vidioc_s_audio,
>  	.vidioc_cropcap             = vidioc_cropcap,
> -	.vidioc_reqbufs             = vidioc_reqbufs,
> -	.vidioc_querybuf            = vidioc_querybuf,
> -	.vidioc_qbuf                = vidioc_qbuf,
> -	.vidioc_dqbuf               = vidioc_dqbuf,
> +
> +	.vidioc_reqbufs             = vb2_ioctl_reqbufs,
> +	.vidioc_create_bufs         = vb2_ioctl_create_bufs,
> +	.vidioc_prepare_buf         = vb2_ioctl_prepare_buf,
> +	.vidioc_querybuf            = vb2_ioctl_querybuf,
> +	.vidioc_qbuf                = vb2_ioctl_qbuf,
> +	.vidioc_dqbuf               = vb2_ioctl_dqbuf,

Add vidioc_expbuf as well. That is now supported by videobuf2-vmalloc.

> +
>  	.vidioc_s_std               = vidioc_s_std,
>  	.vidioc_g_std               = vidioc_g_std,
>  	.vidioc_enum_input          = vidioc_enum_input,
>  	.vidioc_g_input             = vidioc_g_input,
>  	.vidioc_s_input             = vidioc_s_input,
> -	.vidioc_streamon            = vidioc_streamon,
> -	.vidioc_streamoff           = vidioc_streamoff,
> +
> +	.vidioc_streamon            = vb2_ioctl_streamon,
> +	.vidioc_streamoff           = vb2_ioctl_streamoff,
> +
>  	.vidioc_g_tuner             = vidioc_g_tuner,
>  	.vidioc_s_tuner             = vidioc_s_tuner,
>  	.vidioc_g_frequency         = vidioc_g_frequency,
> @@ -1988,6 +1730,42 @@ static const struct video_device au0828_video_template = {
>  	.tvnorms                    = V4L2_STD_NTSC_M | V4L2_STD_PAL_M,
>  };
>  
> +static int au0828_vb2_setup(struct au0828_dev *dev)
> +{
> +	int rc;
> +	struct vb2_queue *q;
> +
> +	/* Setup Videobuf2 for Video capture */
> +	q = &dev->vb_vidq;
> +	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	q->io_modes = VB2_READ | VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->drv_priv = dev;
> +	q->buf_struct_size = sizeof(struct au0828_buffer);
> +	q->ops = &au0828_video_qops;
> +	q->mem_ops = &vb2_vmalloc_memops;
> +
> +	rc = vb2_queue_init(q);
> +	if (rc < 0)
> +		return rc;
> +
> +	/* Setup Videobuf2 for VBI capture */
> +	q = &dev->vb_vbiq;
> +	q->type = V4L2_BUF_TYPE_VBI_CAPTURE;
> +	q->io_modes = VB2_READ | VB2_MMAP | VB2_USERPTR;

Add VB2_DMABUF here as well.

Admittedly, nobody will use it, but it comes for free, so why not?

> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->drv_priv = dev;
> +	q->buf_struct_size = sizeof(struct au0828_buffer);
> +	q->ops = &au0828_vbi_qops;
> +	q->mem_ops = &vb2_vmalloc_memops;
> +
> +	rc = vb2_queue_init(q);
> +	if (rc < 0)
> +		return rc;
> +
> +	return 0;
> +}
> +
>  /**************************************************************************/
>  
>  int au0828_analog_register(struct au0828_dev *dev,
> @@ -2039,9 +1817,7 @@ int au0828_analog_register(struct au0828_dev *dev,
>  
>  	/* init video dma queues */
>  	INIT_LIST_HEAD(&dev->vidq.active);
> -	INIT_LIST_HEAD(&dev->vidq.queued);
>  	INIT_LIST_HEAD(&dev->vbiq.active);
> -	INIT_LIST_HEAD(&dev->vbiq.queued);
>  
>  	dev->vid_timeout.function = au0828_vid_buffer_timeout;
>  	dev->vid_timeout.data = (unsigned long) dev;
> @@ -2078,18 +1854,34 @@ int au0828_analog_register(struct au0828_dev *dev,
>  		goto err_vdev;
>  	}
>  
> +	mutex_init(&dev->vb_queue_lock);
> +	mutex_init(&dev->vb_vbi_queue_lock);
> +
>  	/* Fill the video capture device struct */
>  	*dev->vdev = au0828_video_template;
>  	dev->vdev->v4l2_dev = &dev->v4l2_dev;
>  	dev->vdev->lock = &dev->lock;
> +	dev->vdev->queue = &dev->vb_vidq;
> +	dev->vdev->queue->lock = &dev->vb_queue_lock;
>  	strcpy(dev->vdev->name, "au0828a video");
>  
>  	/* Setup the VBI device */
>  	*dev->vbi_dev = au0828_video_template;
>  	dev->vbi_dev->v4l2_dev = &dev->v4l2_dev;
>  	dev->vbi_dev->lock = &dev->lock;
> +	dev->vbi_dev->queue = &dev->vb_vbiq;
> +	dev->vbi_dev->queue->lock = &dev->vb_vbi_queue_lock;
>  	strcpy(dev->vbi_dev->name, "au0828a vbi");
>  
> +	/* initialize videobuf2 stuff */
> +	retval = au0828_vb2_setup(dev);
> +	if (retval != 0) {
> +		dprintk(1, "unable to setup videobuf2 queues (error = %d).\n",
> +			retval);
> +		ret = -ENODEV;
> +		goto err_vbi_dev;
> +	}
> +
>  	/* Register the v4l2 device */
>  	video_set_drvdata(dev->vdev, dev);
>  	retval = video_register_device(dev->vdev, VFL_TYPE_GRABBER, -1);
> @@ -2110,6 +1902,7 @@ int au0828_analog_register(struct au0828_dev *dev,
>  		goto err_vbi_dev;
>  	}
>  
> +

This spurious line can be removed.

>  	dprintk(1, "%s completed!\n", __func__);
>  
>  	return 0;

Regards,

	Hans


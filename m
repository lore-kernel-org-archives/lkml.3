Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab3JSS1K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 14:27:10 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:32915 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab3JSS1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 14:27:08 -0400
Message-ID: <5262CEF6.1040003@gmail.com>
Date: Sat, 19 Oct 2013 20:27:02 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Ricardo Ribalda <ricardo.ribalda@gmail.com>
CC: Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] videobuf2: Add missing lock held on vb2_fop_relase
References: <1382198877-27164-1-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1382198877-27164-1-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2013 06:07 PM, Ricardo Ribalda wrote:
[...]
> ---
>   drivers/media/platform/exynos4-is/fimc-capture.c |  2 +-
>   drivers/media/platform/exynos4-is/fimc-lite.c    |  2 +-
>   drivers/media/usb/em28xx/em28xx-video.c          |  2 +-
>   drivers/media/v4l2-core/videobuf2-core.c         | 18 +++++++++++++++++-
>   include/media/videobuf2-core.h                   |  2 ++
>   5 files changed, 22 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
> index fb27ff7..c38d247c 100644
> --- a/drivers/media/platform/exynos4-is/fimc-capture.c
> +++ b/drivers/media/platform/exynos4-is/fimc-capture.c
> @@ -549,7 +549,7 @@ static int fimc_capture_release(struct file *file)
>   		vc->streaming = false;
>   	}
>
> -	ret = vb2_fop_release(file);
> +	ret = __vb2_fop_release(file, true);
>
>   	if (close) {
>   		clear_bit(ST_CAPT_BUSY,&fimc->state);
> diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
> index e5798f7..021d804 100644
> --- a/drivers/media/platform/exynos4-is/fimc-lite.c
> +++ b/drivers/media/platform/exynos4-is/fimc-lite.c
> @@ -546,7 +546,7 @@ static int fimc_lite_release(struct file *file)
>   		mutex_unlock(&entity->parent->graph_mutex);
>   	}
>
> -	vb2_fop_release(file);
> +	__vb2_fop_release(file, true);
>   	pm_runtime_put(&fimc->pdev->dev);
>   	clear_bit(ST_FLITE_SUSPENDED,&fimc->state);
>
> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> index 9d10334..6a5c147 100644
> --- a/drivers/media/usb/em28xx/em28xx-video.c
> +++ b/drivers/media/usb/em28xx/em28xx-video.c
> @@ -1664,7 +1664,7 @@ static int em28xx_v4l2_close(struct file *filp)
>   	em28xx_videodbg("users=%d\n", dev->users);
>
>   	mutex_lock(&dev->lock);
> -	vb2_fop_release(filp);
> +	__vb2_fop_release(filp, false);

I believe no modifications are needed for this driver.

>   	if (dev->users == 1) {
>   		/* the device is already disconnect,
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 594c75e..ce309a8 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -2619,16 +2619,32 @@ int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma)
>   }
>   EXPORT_SYMBOL_GPL(vb2_fop_mmap);
>
> -int vb2_fop_release(struct file *file)
> +int __vb2_fop_release(struct file *file, bool lock_is_held)
>   {
>   	struct video_device *vdev = video_devdata(file);
> +	struct mutex *lock;
>
>   	if (file->private_data == vdev->queue->owner) {
> +		if (lock_is_held)
> +			lock = NULL;
> +		else
> +			lock = vdev->queue->lock ?
> +				vdev->queue->lock : vdev->lock;
> +		if (lock)
> +			mutex_lock(lock);
>   		vb2_queue_release(vdev->queue);
>   		vdev->queue->owner = NULL;
> +		if (lock)
> +			mutex_unlock(lock);
>   	}
>   	return v4l2_fh_release(file);
>   }
> +EXPORT_SYMBOL_GPL(__vb2_fop_release);
> +
> +int vb2_fop_release(struct file *file)
> +{
> +	return __vb2_fop_release(file, false);
> +}
>   EXPORT_SYMBOL_GPL(vb2_fop_release);

It might be better to make it something like:

static int _vb2_fop_release(struct file *file, bool locked)
{
   	struct video_device *vdev = video_devdata(file);
	struct mutex *lock;

   	if (file->private_data == vdev->queue->owner) {
		lock = vdev->queue->lock ?
			vdev->queue->lock : vdev->lock;

		if (lock && !locked)
			mutex_lock(lock);

   		vb2_queue_release(vdev->queue);
    		vdev->queue->owner = NULL;
		if (lock && !locked)
			mutex_unlock(lock);
   	}
    	return v4l2_fh_release(file);
}

int vb2_fop_release(struct file *file)
{
	return _vb2_fop_release(file, false);
}
EXPORT_SYMBOL_GPL(vb2_fop_release);

/*
  * This function should be used instead of vb2_fop_release()
  * if the caller already holds the video queue mutex.
  */
int __vb2_fop_release(struct file *file)
{
	return _vb2_fop_release(file, true);
}
EXPORT_SYMBOL_GPL(__vb2_fop_release);

since __vb2_fop_release(file, false); is basically useless, it is same
as vb2_fop_release(file);

>   ssize_t vb2_fop_write(struct file *file, char __user *buf,
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 6781258..cd1e4d5 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -491,6 +491,8 @@ int vb2_ioctl_expbuf(struct file *file, void *priv,
>
>   int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma);
>   int vb2_fop_release(struct file *file);
> +/* must be used if the lock is held. */

Let's put any comments at the function body, not here.

> +int __vb2_fop_release(struct file *file, bool lock_is_held);

int __vb2_fop_release(struct file *file);

>   ssize_t vb2_fop_write(struct file *file, char __user *buf,
>   		size_t count, loff_t *ppos);
>   ssize_t vb2_fop_read(struct file *file, char __user *buf,

Thanks,
Sylwester

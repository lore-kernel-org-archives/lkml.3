Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab3JaOPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 10:15:19 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:49516 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402Ab3JaOPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 10:15:17 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-0d-527265f26425
Message-id: <527265F0.6020706@samsung.com>
Date: Thu, 31 Oct 2013 15:15:12 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.0
MIME-version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Ricardo Ribalda <ricardo.ribalda@gmail.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "open list:SAMSUNG S5P/EXYNO..." <linux-media@vger.kernel.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] videobuf2: Add missing lock held on vb2_fop_relase
References: <1382198877-27164-1-git-send-email-ricardo.ribalda@gmail.com>
 <20131031114243.2416bc88@samsung.com>
In-reply-to: <20131031114243.2416bc88@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t/xa7qfUouCDH5+1LHoXXCVzeJs0xt2
	i02Pr7FaXN41h82iZ8NWVosZ5/cxWVxcJ2+x9shddospb3+yW3R1z2OyOPymndWB22PnrLvs
	HpuX1Hs8/vWSzaNvyypGj8+b5AJYo7hsUlJzMstSi/TtErgyrk6azFpwR6/ib98X9gbGvWpd
	jJwcEgImEhdu/GaGsMUkLtxbz9bFyMUhJLCUUeJl3wEWCOcTo8TvM7OZQKp4BbQkrr98AWaz
	CKhKvLq6gRHEZhMwlOg92gdmiwqESRxt+skKUS8o8WPyPRYQW0QgXmLFfpAaLg5mgbvMEhf/
	ngVrEBbwkpj0rxusSEigUGJZ+312EJtTwEji2YJ3YHFmAR2J/a3T2CBseYnNa94yT2AUmIVk
	xywkZbOQlC1gZF7FKJpamlxQnJSea6RXnJhbXJqXrpecn7uJERINX3cwLj1mdYhRgINRiYeX
	QbcwSIg1say4MvcQowQHs5II76PooiAh3pTEyqrUovz4otKc1OJDjEwcnFINjMu/v1jtckRX
	OpAj6Nb+p7wLBQMvN1WK3Oyuf7N97sO5yw/0Czx7droq4Lmpp9aL7tKe60tZZbgNezn8kuy8
	BJsn3OeaYJuWur9TVPFr68W7RxsudWs8upCZpKt765/u+TTxB43K+47WVE3dJLw6P/rx413v
	nuZwzrY/X6AknrFzn9VRqdKnO5VYijMSDbWYi4oTAabKBmRkAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/10/13 14:42, Mauro Carvalho Chehab wrote:
> Em Sat, 19 Oct 2013 18:07:57 +0200
> Ricardo Ribalda <ricardo.ribalda@gmail.com> escreveu:
> 
>> vb2_fop_relase does not held the lock although it is modifying the
>> queue->owner field.
>>
>> This could lead to race conditions on the vb2_perform_io function
>> when multiple applications are accessing the video device via
>> read/write API:
[...]
>> Signed-off-by: Ricardo Ribalda <ricardo.ribalda@gmail.com>
>> ---
>>  drivers/media/platform/exynos4-is/fimc-capture.c |  2 +-
>>  drivers/media/platform/exynos4-is/fimc-lite.c    |  2 +-
>>  drivers/media/usb/em28xx/em28xx-video.c          |  2 +-
>>  drivers/media/v4l2-core/videobuf2-core.c         | 18 +++++++++++++++++-
>>  include/media/videobuf2-core.h                   |  2 ++
>>  5 files changed, 22 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
>> index fb27ff7..c38d247c 100644
>> --- a/drivers/media/platform/exynos4-is/fimc-capture.c
>> +++ b/drivers/media/platform/exynos4-is/fimc-capture.c
>> @@ -549,7 +549,7 @@ static int fimc_capture_release(struct file *file)
>>  		vc->streaming = false;
>>  	}
>>  
>> -	ret = vb2_fop_release(file);
>> +	ret = __vb2_fop_release(file, true);
>>  
>>  	if (close) {
>>  		clear_bit(ST_CAPT_BUSY, &fimc->state);
>> diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
>> index e5798f7..021d804 100644
>> --- a/drivers/media/platform/exynos4-is/fimc-lite.c
>> +++ b/drivers/media/platform/exynos4-is/fimc-lite.c
>> @@ -546,7 +546,7 @@ static int fimc_lite_release(struct file *file)
>>  		mutex_unlock(&entity->parent->graph_mutex);
>>  	}
>>  
>> -	vb2_fop_release(file);
>> +	__vb2_fop_release(file, true);
>>  	pm_runtime_put(&fimc->pdev->dev);
>>  	clear_bit(ST_FLITE_SUSPENDED, &fimc->state);
>>  
>> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
>> index 9d10334..6a5c147 100644
>> --- a/drivers/media/usb/em28xx/em28xx-video.c
>> +++ b/drivers/media/usb/em28xx/em28xx-video.c
>> @@ -1664,7 +1664,7 @@ static int em28xx_v4l2_close(struct file *filp)
>>  	em28xx_videodbg("users=%d\n", dev->users);
>>  
>>  	mutex_lock(&dev->lock);
>> -	vb2_fop_release(filp);
>> +	__vb2_fop_release(filp, false);
>>  
>>  	if (dev->users == 1) {
>>  		/* the device is already disconnect,
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>> index 594c75e..ce309a8 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -2619,16 +2619,32 @@ int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma)
>>  }
>>  EXPORT_SYMBOL_GPL(vb2_fop_mmap);
>>  
>> -int vb2_fop_release(struct file *file)
>> +int __vb2_fop_release(struct file *file, bool lock_is_held)
>>  {
>>  	struct video_device *vdev = video_devdata(file);
>> +	struct mutex *lock;
>>  
>>  	if (file->private_data == vdev->queue->owner) {
>> +		if (lock_is_held)
>> +			lock = NULL;
>> +		else
>> +			lock = vdev->queue->lock ?
>> +				vdev->queue->lock : vdev->lock;
>> +		if (lock)
>> +			mutex_lock(lock);
>>  		vb2_queue_release(vdev->queue);
>>  		vdev->queue->owner = NULL;
>> +		if (lock)
>> +			mutex_unlock(lock);
>>  	}
>>  	return v4l2_fh_release(file);
>>  }
>> +EXPORT_SYMBOL_GPL(__vb2_fop_release);
>> +
>> +int vb2_fop_release(struct file *file)
>> +{
>> +	return __vb2_fop_release(file, false);
>> +}
>>  EXPORT_SYMBOL_GPL(vb2_fop_release);
> 
> In general, when a symbol has both locked/unlocked versions, we
> use the __symbol for unlocked versions (as the usage of the __symbol
> requires the caller do do additional protection).
> 
> On this patch, (and on  Sylwester's version) you're seeming to be doing 
> just the opposite. That sounds inconsistent with other Kernel symbols.

Actually the version with double underscore prefix in my proposed changes
doesn't take the lock internally (please see below). Hence it follows
the common convention you're ponting out.

> Please either use that version or add a suffix (like _locked / __unlocked)
> to allow a clearer understanding about what's the locked version.
> 
> Btw, Does it even make sense to have both options, or wouldn't be better
> to just make sure that all drivers will do the same? My concern here is
> with race conditions that may happen at device removal, if the lock is
> released/retaken inside the routine that unbinds the driver.

Exactly for this reason, i.e. not needing to release and reacquire lock
in driver release() callback I suggested to have the
int __vb2_fop_release(struct file *file); version, for cases when drivers
use their custom handler and call __vb2_fop_release() from within it with
the lock already held.

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

This function takes the lock internally.

int vb2_fop_release(struct file *file)
{
	return _vb2_fop_release(file, false);
}
EXPORT_SYMBOL_GPL(vb2_fop_release);

And this one deesn't.

int __vb2_fop_release(struct file *file)
{
	return _vb2_fop_release(file, true);
}
EXPORT_SYMBOL_GPL(__vb2_fop_release);

It probably makes sense to move the locking out of _vb2_fop_release()
and do it only vb2_fop_release(), even though v4l2_fh_release() may
be unnecessarily called while keeping the mutex.

--
Thanks,
Sylwester

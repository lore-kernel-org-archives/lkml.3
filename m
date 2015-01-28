Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812AbbA2BtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:49:19 -0500
Received: from lists.s-osg.org ([54.187.51.154]:41430 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753927AbbA2BtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:49:10 -0500
Message-ID: <54C9769C.1090502@osg.samsung.com>
Date: Wed, 28 Jan 2015 16:54:04 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com, prabhakar.csengg@gmail.com,
        laurent.pinchart@ideasonboard.com
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: au0828 analog_register error path fixes to do
 proper cleanup
References: <1419985334-6155-1-git-send-email-shuahkh@osg.samsung.com>
In-Reply-To: <1419985334-6155-1-git-send-email-shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2014 05:22 PM, Shuah Khan wrote:
> au0828_analog_register() doesn't release video and vbi queues
> created by vb2_queue_init(). In addition, it doesn't unregister
> vdev when vbi register fails. Add vb2_queue_release() calls to
> release video and vbi queues to the failure path to be called
> when vdev register fails. Add video_unregister_device() for
> vdev when vbi register fails.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
> Please note that this patch is dependent on the au0828 vb2
> conversion patch.

I have to fold this patch into the vb2 conversion patch as
it no longer applies after the recent changes to address
comments on patch v3. I will fold it into vb2 convert patch v6.
It makes sense since vb2_queue_release() should be part of the
conversion work anyway.

thanks,
-- Shuah
> 
>  drivers/media/usb/au0828/au0828-video.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
> index 94b65b8..17450eb 100644
> --- a/drivers/media/usb/au0828/au0828-video.c
> +++ b/drivers/media/usb/au0828/au0828-video.c
> @@ -1785,7 +1785,7 @@ int au0828_analog_register(struct au0828_dev *dev,
>  		dprintk(1, "unable to register video device (error = %d).\n",
>  			retval);
>  		ret = -ENODEV;
> -		goto err_vbi_dev;
> +		goto err_reg_vdev;
>  	}
>  
>  	/* Register the vbi device */
> @@ -1795,14 +1795,18 @@ int au0828_analog_register(struct au0828_dev *dev,
>  		dprintk(1, "unable to register vbi device (error = %d).\n",
>  			retval);
>  		ret = -ENODEV;
> -		goto err_vbi_dev;
> +		goto err_reg_vbi_dev;
>  	}
>  
> -
>  	dprintk(1, "%s completed!\n", __func__);
>  
>  	return 0;
>  
> +err_reg_vbi_dev:
> +	video_unregister_device(dev->vdev);
> +err_reg_vdev:
> +	vb2_queue_release(&dev->vb_vidq);
> +	vb2_queue_release(&dev->vb_vbiq);
>  err_vbi_dev:
>  	video_device_release(dev->vbi_dev);
>  err_vdev:
> 


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978

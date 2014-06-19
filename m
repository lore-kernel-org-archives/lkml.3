Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966048AbaFSWCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 18:02:10 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:51234 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965552AbaFSWCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 18:02:07 -0400
MIME-Version: 1.0
In-Reply-To: <53A353E5.1010704@codeaurora.org>
References: <1403124927-21514-1-git-send-email-hali@codeaurora.org>
	<53A353E5.1010704@codeaurora.org>
Date: Thu, 19 Jun 2014 18:02:06 -0400
Message-ID: <CAF6AEGsQjL3=Qar3=tYjEY3wDXWdjHE3z5=rKc6F1RWtneMZQQ@mail.gmail.com>
Subject: Re: [PATCH] drm/msm: Implement msm drm fb_mmap callback function
From: Rob Clark <robdclark@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Hai Li <hali@codeaurora.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephane Viau <sviau@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 5:19 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 06/18/14 13:55, Hai Li wrote:
>> diff --git a/drivers/gpu/drm/msm/msm_fbdev.c b/drivers/gpu/drm/msm/msm_fbdev.c
>> index 4f4e7b4..2522f51 100644
>> --- a/drivers/gpu/drm/msm/msm_fbdev.c
>> +++ b/drivers/gpu/drm/msm/msm_fbdev.c
>> @@ -19,6 +19,11 @@
>>
>>  #include "drm_crtc.h"
>>  #include "drm_fb_helper.h"
>> +#include "msm_gem.h"
>> +
>> +extern int msm_gem_mmap_obj(struct drm_gem_object *obj,
>> +                                     struct vm_area_struct *vma);
>
> This can't go into some header file?

it probably should go in msm_gem.h.. although this would be the one
special case where it is needed outside of msm_gem.c so I don't mind
too much

>> +static int msm_fbdev_mmap(struct fb_info *info, struct vm_area_struct *vma);
>>
>>  /*
>>   * fbdev funcs, to implement legacy fbdev interface on top of drm driver
>> @@ -43,6 +48,7 @@ static struct fb_ops msm_fb_ops = {
>>       .fb_fillrect = sys_fillrect,
>>       .fb_copyarea = sys_copyarea,
>>       .fb_imageblit = sys_imageblit,
>> +     .fb_mmap = msm_fbdev_mmap,
>>
>>       .fb_check_var = drm_fb_helper_check_var,
>>       .fb_set_par = drm_fb_helper_set_par,
>> @@ -51,6 +57,31 @@ static struct fb_ops msm_fb_ops = {
>>       .fb_setcmap = drm_fb_helper_setcmap,
>>  };
>>
>> +static int msm_fbdev_mmap(struct fb_info *info, struct vm_area_struct *vma)
>> +{
>> +     struct drm_fb_helper *helper = (struct drm_fb_helper *)info->par;
>> +     struct msm_fbdev *fbdev = to_msm_fbdev(helper);
>> +     struct drm_gem_object *drm_obj = fbdev->bo;
>> +     struct drm_device *dev = helper->dev;
>> +     int ret = 0;
>
> unnecessary initialization to 0.
>
>> +
>> +     if (drm_device_is_unplugged(dev))
>> +             return -ENODEV;
>> +
>> +     mutex_lock(&dev->struct_mutex);
>> +
>> +     ret = drm_gem_mmap_obj(drm_obj, drm_obj->size, vma);
>> +
>> +     mutex_unlock(&dev->struct_mutex);
>> +
>> +     if (ret) {
>> +             pr_err("%s:drm_gem_mmap_obj fail\n", __func__);
>> +             return ret;
>> +     }
>> +
>> +     return msm_gem_mmap_obj(drm_obj, vma);
>> +}
>> +
>>  static int msm_fbdev_create(struct drm_fb_helper *helper,
>>               struct drm_fb_helper_surface_size *sizes)
>>  {
>> @@ -108,7 +139,11 @@ static int msm_fbdev_create(struct drm_fb_helper *helper,
>>       mutex_lock(&dev->struct_mutex);
>>
>>       /* TODO implement our own fb_mmap so we don't need this: */
>
> Is this comment still relevant?

partially.. although it changes to the "can we make sure we can safely
pin on panic when fbcon is restored"..

probably a low priority thing, because we are not really tight on
device virtual space.

BR,
-R


>> -     msm_gem_get_iova_locked(fbdev->bo, 0, &paddr);
>> +     ret = msm_gem_get_iova_locked(fbdev->bo, 0, &paddr);
>> +     if (ret) {
>> +             dev_err(dev->dev, "failed to get buffer obj iova: %d\n", ret);
>> +             goto fail;
>> +     }
>>
>>       fbi = framebuffer_alloc(0, dev->dev);
>>       if (!fbi) {
>
>
> --
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
>

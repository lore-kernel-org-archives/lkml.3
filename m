Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbaKKQ0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 11:26:24 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:42437 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbaKKQ0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 11:26:22 -0500
MIME-Version: 1.0
In-Reply-To: <54621D21.2000100@linaro.org>
References: <1415639805-17477-1-git-send-email-daniel.thompson@linaro.org>
	<CAF6AEGspGE2EsS7zuVFXh1kT2Rq8Rt8Z1dpGNdVKPr4mBcTZuw@mail.gmail.com>
	<54621D21.2000100@linaro.org>
Date: Tue, 11 Nov 2014 11:26:21 -0500
Message-ID: <CAF6AEGsaBpgrKKHYF+N+woySp6yMs-rDFKO+ZjbuMb2xAjirnw@mail.gmail.com>
Subject: Re: [PATCH v3.18-rc3] drm: msm: Allow exported dma-bufs to be mapped
From: Rob Clark <robdclark@gmail.com>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 9:28 AM, Daniel Thompson
<daniel.thompson@linaro.org> wrote:
> On 10/11/14 17:36, Rob Clark wrote:
>> On Mon, Nov 10, 2014 at 12:16 PM, Daniel Thompson
>> <daniel.thompson@linaro.org> wrote:
>>> diff --git a/drivers/gpu/drm/msm/msm_gem_prime.c b/drivers/gpu/drm/msm/msm_gem_prime.c
>>> index ad772fe36115..4e4fa5828d5d 100644
>>> --- a/drivers/gpu/drm/msm/msm_gem_prime.c
>>> +++ b/drivers/gpu/drm/msm/msm_gem_prime.c
>>> @@ -20,6 +20,14 @@
>>>
>>>  #include <linux/dma-buf.h>
>>>
>>> +struct dma_buf *msm_gem_prime_export(struct drm_device *dev,
>>> +                                    struct drm_gem_object *obj, int flags)
>>> +{
>>> +       /* we want to be able to write in mmapped buffer */
>>> +       flags |= O_RDWR;
>>> +       return drm_gem_prime_export(dev, obj, flags);
>>> +}
>>> +
>>
>> seems like this probably should be done more centrally..  and in fact,
>> might be better to have something like this in
>> drm_prime_handle_to_fd_ioctl:
>>
>>     /* check flags are valid */
>> -    if (args->flags & ~DRM_CLOEXEC)
>> +    if (args->flags & ~(DRM_CLOEXEC | O_RDWR))
>>        return -EINVAL;
>>
>> so exporter can specify whether to allow mmap or not.
>
> That makes sense I'll try this.
>
> Do we need to wrap O_RDWR in the same way we wrap O_CLOEXEC? (I don't
> really understand why DRM_CLOEXEC exists; even the patch description
> from when the symbol was introduced names it O_CLOEXEC).

I *think* wrapping it w/ DRM_CLOEXEC was mostly just for purposes of
making it clear which flags are appropriate.. probably best to do the
same w/ a DRM_RDWR I guess

BR,
-R

> Also the "flags |= O_RDWR" approach is copied from the sti driver. I'll
> share a patch to remove it but that will definitely needs Benjamin's ack
> because it will stop some userspaces working correctly (however I
> suspect that Benjamin may be the only person currently with such a
> userspace and that he can be persuaded not to call it a regression).
>
>
> Daniel.

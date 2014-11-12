Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbaKLJog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 04:44:36 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:47571 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbaKLJod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 04:44:33 -0500
Message-ID: <54632BF6.5080007@linaro.org>
Date: Wed, 12 Nov 2014 09:44:22 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Rob Clark <robdclark@gmail.com>
CC: David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>
Subject: Re: [PATCH v3.18-rc3] drm: msm: Allow exported dma-bufs to be mapped
References: <1415639805-17477-1-git-send-email-daniel.thompson@linaro.org>	<CAF6AEGspGE2EsS7zuVFXh1kT2Rq8Rt8Z1dpGNdVKPr4mBcTZuw@mail.gmail.com>	<54621D21.2000100@linaro.org>	<CAF6AEGsaBpgrKKHYF+N+woySp6yMs-rDFKO+ZjbuMb2xAjirnw@mail.gmail.com> <CA+M3ks6SU6ivFPMbqWRsN0JLC3SBnkWJdRd+r_10n9qgpdbDCQ@mail.gmail.com>
In-Reply-To: <CA+M3ks6SU6ivFPMbqWRsN0JLC3SBnkWJdRd+r_10n9qgpdbDCQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/14 09:41, Benjamin Gaignard wrote:
> The same kind of issue has been fixed in v4l2:
> 
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/patch/drivers/media/v4l2-core/videobuf2-core.c?id=c1b96a236e94d49d9396d0bbceb5524519c5c66e
> 
> I'm ok to add a DRM_RDWR flag, just do not remove the code from sti
> driver until I have been able to test it.

Don't worry. I'll do that as a separate patch so you can ack/nack as you
need to.


Daniel.

> 
> Benjamin
> 
> 
> 2014-11-11 17:26 GMT+01:00 Rob Clark <robdclark@gmail.com>:
>> On Tue, Nov 11, 2014 at 9:28 AM, Daniel Thompson
>> <daniel.thompson@linaro.org> wrote:
>>> On 10/11/14 17:36, Rob Clark wrote:
>>>> On Mon, Nov 10, 2014 at 12:16 PM, Daniel Thompson
>>>> <daniel.thompson@linaro.org> wrote:
>>>>> diff --git a/drivers/gpu/drm/msm/msm_gem_prime.c b/drivers/gpu/drm/msm/msm_gem_prime.c
>>>>> index ad772fe36115..4e4fa5828d5d 100644
>>>>> --- a/drivers/gpu/drm/msm/msm_gem_prime.c
>>>>> +++ b/drivers/gpu/drm/msm/msm_gem_prime.c
>>>>> @@ -20,6 +20,14 @@
>>>>>
>>>>>  #include <linux/dma-buf.h>
>>>>>
>>>>> +struct dma_buf *msm_gem_prime_export(struct drm_device *dev,
>>>>> +                                    struct drm_gem_object *obj, int flags)
>>>>> +{
>>>>> +       /* we want to be able to write in mmapped buffer */
>>>>> +       flags |= O_RDWR;
>>>>> +       return drm_gem_prime_export(dev, obj, flags);
>>>>> +}
>>>>> +
>>>>
>>>> seems like this probably should be done more centrally..  and in fact,
>>>> might be better to have something like this in
>>>> drm_prime_handle_to_fd_ioctl:
>>>>
>>>>     /* check flags are valid */
>>>> -    if (args->flags & ~DRM_CLOEXEC)
>>>> +    if (args->flags & ~(DRM_CLOEXEC | O_RDWR))
>>>>        return -EINVAL;
>>>>
>>>> so exporter can specify whether to allow mmap or not.
>>>
>>> That makes sense I'll try this.
>>>
>>> Do we need to wrap O_RDWR in the same way we wrap O_CLOEXEC? (I don't
>>> really understand why DRM_CLOEXEC exists; even the patch description
>>> from when the symbol was introduced names it O_CLOEXEC).
>>
>> I *think* wrapping it w/ DRM_CLOEXEC was mostly just for purposes of
>> making it clear which flags are appropriate.. probably best to do the
>> same w/ a DRM_RDWR I guess
>>
>> BR,
>> -R
>>
>>> Also the "flags |= O_RDWR" approach is copied from the sti driver. I'll
>>> share a patch to remove it but that will definitely needs Benjamin's ack
>>> because it will stop some userspaces working correctly (however I
>>> suspect that Benjamin may be the only person currently with such a
>>> userspace and that he can be persuaded not to call it a regression).
>>>
>>>
>>> Daniel.
> 
> 
> 


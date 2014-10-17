Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbaJQOrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 10:47:04 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39565 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaJQOrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 10:47:02 -0400
Message-ID: <54412BED.5000704@linaro.org>
Date: Fri, 17 Oct 2014 15:47:09 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Rob Clark <robdclark@gmail.com>
CC: David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 3.17] drm/msm: Fix fbdev for 16- and 24-bit modes.
References: <1413556088-30194-1-git-send-email-daniel.thompson@linaro.org> <CAF6AEGscgtzr6pW+M6xb3Ht7pMknd7ZT5Qd1zJYExgJf8wqaVg@mail.gmail.com>
In-Reply-To: <CAF6AEGscgtzr6pW+M6xb3Ht7pMknd7ZT5Qd1zJYExgJf8wqaVg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/10/14 15:43, Rob Clark wrote:
> On Fri, Oct 17, 2014 at 10:28 AM, Daniel Thompson
> <daniel.thompson@linaro.org> wrote:
>> Currently forcing the video mode from the kernel command line (for example
>> video=HDMI-A-1:1280x720-16@60) does not correctly set the number of bits
>> per pixel. This is due to a rather aggressive override in
>> msm_fbdev_create(). This is a particular problem for Android bring up
>> because the software EGL fallbacks don't support 32bpp.
>>
>> This problem could be trivially fixed by removing the override completely.
>> However to avoid regressing commit 96673ecbd7f6 ("drm/msm: default to
>> XR24 rather than AR24") this patch continues to override the depth if
>> there are 32 bits per pixel.
>>
>> Change was tested by dd'ing a test image to /dev/fb0 with no video=
>> (still 32bpp, DBG() message observed), video=1920x1080-32@60 (message
>> observed), video=1920x1080-24@60 and video=1920x1080-16@60 .
>>
>> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
>> Cc: David Airlie <airlied@linux.ie>
>> Cc: Rob Clark <robdclark@gmail.com>
>> ---
>>  drivers/gpu/drm/msm/msm_fbdev.c | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/msm/msm_fbdev.c b/drivers/gpu/drm/msm/msm_fbdev.c
>> index ab5bfd2..ed0171d 100644
>> --- a/drivers/gpu/drm/msm/msm_fbdev.c
>> +++ b/drivers/gpu/drm/msm/msm_fbdev.c
>> @@ -93,8 +93,10 @@ static int msm_fbdev_create(struct drm_fb_helper *helper,
>>         uint32_t paddr;
>>         int ret, size;
>>
>> -       sizes->surface_bpp = 32;
>> -       sizes->surface_depth = 24;
>> +       if (sizes->surface_bpp == 32) {
>> +               DBG("forcing surface depth to 24\n");
>> +               sizes->surface_depth = 24;
>> +       }
> 
> Thanks.. we could probably even drop this forcing depth to 24.. from a
> quick check in drm_fb_helper_single_fb_probe() the default is 24/32
> which should be enough for the "flicker-free" handover from splash
> screen to X.

Interesting...

I probably should have checked that myself. "git blame" told me that the
change to surface_depth came a long time after forcing the surface_bpp
so I figured it was needed.

v2 may be forthcoming shortly.



> Not really sure why I was forcing the depth/bpp.. I think copy/paste
> of a hack from another driver to do video 'underlays' ;-)
> 
> BR,
> -R
> 
>>
>>         DBG("create fbdev: %dx%d@%d (%dx%d)", sizes->surface_width,
>>                         sizes->surface_height, sizes->surface_bpp,
>> --
>> 1.9.3
>>


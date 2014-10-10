Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbaJJWN5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 18:13:57 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:49026 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbaJJWNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 18:13:55 -0400
From: Kevin Hilman <khilman@kernel.org>
To: Javier Martinez Canillas <javier@dowhile0.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        "linux-samsung-soc\@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] ARM: exynos_defconfig: re-enable USB gadget and max77802 options
References: <1412879767-24326-1-git-send-email-javier.martinez@collabora.co.uk>
	<7h8ukolsvx.fsf@deeprootsystems.com>
	<CABxcv==bbfoY6=g3P6N2bLw6DqoV8KEpgro5VOdrj6A9OuuTmA@mail.gmail.com>
Date: Fri, 10 Oct 2014 15:13:52 -0700
In-Reply-To: <CABxcv==bbfoY6=g3P6N2bLw6DqoV8KEpgro5VOdrj6A9OuuTmA@mail.gmail.com>
	(Javier Martinez Canillas's message of "Fri, 10 Oct 2014 14:25:27
	+0200")
Message-ID: <7hvbnrindr.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javier Martinez Canillas <javier@dowhile0.org> writes:

> Hello Kevin,
>
> On Fri, Oct 10, 2014 at 1:34 AM, Kevin Hilman <khilman@kernel.org> wrote:
>> Javier Martinez Canillas <javier.martinez@collabora.co.uk> writes:
>>
>>> Commit 43eeaa42e03a ("ARM: exynos_defconfig: savedefconfig") removed a
>>> set of Kconfig symbols. For most of them there were no functional change
>>> since are selected by other Kconfig options or were deprecated but some
>>> options are not explicitly selected so they should not had been removed.
>>>
>>> The options that have to be enabled are USB gadget and the MAX77802 PMIC
>>> support which were enabled in commits:
>>>
>>> 508423bebcda ("ARM: exynos_defconfig: enable USB gadget support")
>>> 6e80e3d87549 ("ARM: exynos_defconfig: Enable MAX77802")
>>>
>>> Enable those options to leave the config in the state before the change.
>>>
>>> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>>
>> Acked-by: Kevin Hilman <khilman@linaro.org>
>> Tested-by: Kevin Hilman <khilman@linaro.org>
>
> Thanks for testing.
>
>>
>> This is needed to get RTC wakeup from suspend working on
>> exynos5800-peach-pi.
>>
>> Note that the s3c-rtc works fine, but the max77802-rtc doesn't seem to
>> work be functional for me:
>>
>> [    2.408178] max77802-rtc max77802-rtc: rtc core: registered max77802-rtc as rtc0
>> [    3.595485] s3c-rtc 101e0000.rtc: rtc core: registered s3c as rtc1
>>
>> root@(none):/# hwclock --rtc /dev/rtc0
>> hwclock: ioctl(RTC_RD_TIME) to /dev/rtc0 to read the time failed:
>> Invalid argument
>> root@(none):/# hwclock --rtc /dev/rtc1
>> Thu Oct  9 23:33:06 2014  -0.111978 seconds
>>
>
> Strange, I don't get that error when testing on my Peach Pit with
> linux-next + $subject
>
> [    2.311591] max77802-rtc max77802-rtc: rtc core: registered
> max77802-rtc as rtc0
> [    3.594438] s3c-rtc 101e0000.rtc: rtc core: registered s3c as rtc1
>
> # hwclock --rtc /dev/rtc0
> Fri 10 Oct 2014 12:19:23 PM UTC  -0.909103 seconds
> # hwclock --rtc /dev/rtc1
> Fri 10 Oct 2014 12:19:26 PM UTC  -0.719862 seconds
>
> I'll take a look but if you have a test case that makes it fail
> consistently that would be really helpful.

I'm using:
- next-20141010 + $subject patch
- exynos_defconfig
- exynos5800-peach-pi
- ubuntu-based rootfs, but booting with init=/bin/bash, so not much
  userspace involved

Boot-time RTC-related messages:

root@(none):/# dmesg |grep rtc
[    2.349742] s3c-rtc 101e0000.rtc: failed to find rtc source clock
[    2.349795] platform 101e0000.rtc: Driver s3c-rtc requests probe deferral
[    2.373313] max77802-rtc max77802-rtc: rtc core: registered max77802-rtc as rtc0
[    3.590520] s3c-rtc 101e0000.rtc: rtc core: registered s3c as rtc1
[    3.925792] max77802-rtc max77802-rtc: hctosys: unable to read the hardware clock

Note there was an "unable to read" failure during boot too.

Then it fails like this every time when trying from userspace:

oot@(none):/# hwclock --rtc /dev/rtc0
hwclock: ioctl(RTC_RD_TIME) to /dev/rtc0 to read the time failed: Invalid argument
root@(none):/# hwclock --rtc /dev/rtc1
Fri Oct 10 22:09:47 2014  -0.375445 seconds

FWIW, I don't think this problem should hold up $SUBJECT patch from
being merged, as it's not directly related.

Kevin

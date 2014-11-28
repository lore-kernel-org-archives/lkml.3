Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbaK1QKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:10:51 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:53359 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaK1QKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:10:49 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1411280005500.3961@nanos>
References: <1417089760-26848-1-git-send-email-pang.xunlei@linaro.org>
	<1417089760-26848-4-git-send-email-pang.xunlei@linaro.org>
	<alpine.DEB.2.11.1411280005500.3961@nanos>
Date: Sat, 29 Nov 2014 00:10:48 +0800
Message-ID: <CADcy93Vk96E0djD3rFYtKr_kBcwCJOEesg_UW_ZdGv=B_uM8Ug@mail.gmail.com>
Subject: Re: [RFC PATCH 3/4] rtc/lib: Provide interfaces to map between 32bit
 hardware and 64bit time
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Sven Schnelle <svens@stackframe.org>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 November 2014 at 07:16, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 27 Nov 2014, Xunlei Pang wrote:
>> +/* Rtc epoch year, can be overrided by command line */
>> +static unsigned int rtc_epoch = 1970;
>> +time64_t rtc_epoch_secs_since_1970;
>> +
>> +static int __init
>> +set_rtc_epoch(char *str)
>
> One line please
>
>> +{
>> +     unsigned int epoch;
>> +
>> +     if (kstrtou32(str, 0, &epoch) != 0) {
>> +             printk(KERN_WARNING "Invalid setup epoch %u!\n", epoch);
>
> Sure that makes a lot of sense to print epoch if the string conversion
> failed. epoch is going to be either uninitialized stack value or 0
> depending on the kstrtou32 implementation.
>
>> +     if (rtc_epoch < 1970)
>> +             printk(KERN_WARNING "Epoch %u is smaller than 1970!\n", epoch);
>
>   pr_warn() ....
>
> +__setup("rtc_epoch=", set_rtc_epoch);
>
> Not documented in Documentation/kernel-parameters.txt ...
>
>>  /*
>> + * Convert seconds since rtc epoch to seconds since Unix epoch.
>> + */
>> +time64_t rtc_hw32_to_time64(u32 hwtime)
>> +{
>> +     return (rtc_epoch_secs_since_1970 + hwtime);
>> +}
>> +EXPORT_SYMBOL_GPL(rtc_hw32_to_time64);
>
> So we need a exported function to add a global variable and a function
> argument? inline ?
>
>> +/*
>> + * Convert seconds since Unix epoch to seconds since rtc epoch.
>> + */
>> +int rtc_time64_to_hw32(time64_t time, u32 *hwtime)
>> +{
>> +     /* time must be after rtc epoch */
>> +     if (time < rtc_epoch_secs_since_1970)
>> +             return -EINVAL;
>> +
>> +     /* rtc epoch may be too small? */
>> +     if (time - rtc_epoch_secs_since_1970 > UINT_MAX)
>> +             return -EOVERFLOW;
>
> And what's the caller supposed to do with that information?

This probably means the current rtc hardware has pushed its envelope now,
the users should rely on the rtc_epoch command line to continue use it.

>
>> +     *hwtime = time - rtc_epoch_secs_since_1970;
>> +
>> +     return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(rtc_time64_to_hw32);
>
> How is that going to be useful w/o a mechanism to adjust the epoch
> offset at runtime by any means?

If the rtc epoch changes at runtime, we'll not get the right time once
the system is rebooting.
So, it can only be altered throught command line, and must stay
invariable ever since unless
it uses NTP or something.

Thanks,
Xunlei

>
> Thanks,
>
>         tglx
>
>

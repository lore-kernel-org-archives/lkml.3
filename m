Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934051AbaJ3QaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 12:30:07 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:62116 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933539AbaJ3QaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:30:05 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1410301444100.5308@nanos>
References: <1414667745-7703-1-git-send-email-pang.xunlei@linaro.org>
	<1414667745-7703-4-git-send-email-pang.xunlei@linaro.org>
	<alpine.DEB.2.11.1410301444100.5308@nanos>
Date: Fri, 31 Oct 2014 00:30:04 +0800
Message-ID: <CADcy93WzP-y8HXNrfx-vOCkruEdXVOhP2Up=KqW=vLuxHM7_YQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 03/11] time: Add rtc_tm_to_time64() safe
 version(using time64_t)
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        xen-devel@lists.xenproject.org, John Stultz <john.stultz@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 October 2014 21:55, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 30 Oct 2014, pang.xunlei wrote:
>
> Same $subject issue.
>
>> As part of addressing 2038 saftey for in-kernel uses, this patch
>> adds safe rtc_tm_to_time64() using time64_t. After this patch,
>> rtc_tm_to_time() should be replaced by rtc_tm_to_time64() one by
>> one. Eventually, rtc_tm_to_time() will be removed from the kernel
>> when it has no users.
>>
>> Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
>> ---
>>  drivers/rtc/rtc-lib.c |   15 ++++++++++++++-
>>  include/linux/rtc.h   |    1 +
>>  2 files changed, 15 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/rtc/rtc-lib.c b/drivers/rtc/rtc-lib.c
>> index c4cf057..6948cbd 100644
>> --- a/drivers/rtc/rtc-lib.c
>> +++ b/drivers/rtc/rtc-lib.c
>> @@ -110,10 +110,23 @@ EXPORT_SYMBOL(rtc_valid_tm);
>>
>>  /*
>>   * Convert Gregorian date to seconds since 01-01-1970 00:00:00.
>> + * Safe version for 2038 safety.
>
> Docbook comment missing. See the previous replies.
>
>> + */
>> +int rtc_tm_to_time64(struct rtc_time *tm, time64_t *time)
>
> What's the point of the return value? Just because rtc_tm_to_time()
> has one?
>
> Yes it does, but that does not mean that we blindly copy the existing
> nonsense when we implement a replacement interface.
>
> What's wrong with changing it to:
>
> time64_t rtc_tm_to_time64(struct rtc_time *tm)
> {
>         return mktime64(......);
> }

Thank you for reminding me of this, and also a valuable principle when
doing things.

I wanna change it to:
void rtc_tm_to_time64(struct rtc_time *tm, time64_t *time)
{
    time = mktime64(......);
}

Just keep it the similar format as rtc_time64_to_tm(), is this acceptable?

>
>> +/*
>> + * Convert Gregorian date to seconds since 01-01-1970 00:00:00.
>> + * TODO: [2038 safety] should be replaced by rtc_tm_to_time64.
>
> Groan.
>
>>   */
>>  int rtc_tm_to_time(struct rtc_time *tm, unsigned long *time)
>>  {
>> -       *time = mktime(tm->tm_year + 1900, tm->tm_mon + 1, tm->tm_mday,
>> +       *time = (unsigned long) mktime64(tm->tm_year + 1900, tm->tm_mon + 1, tm->tm_mday,
>>                         tm->tm_hour, tm->tm_min, tm->tm_sec);
>
> And that would become
>
>          *time = rtc_time_to_time64(tm);
>
>>         return 0;
>>  }
>
> Please stop doing purely mechanical changes. Just blindly copying
> stuff and make it take time64_t instead of unsigned long can be done
> with a script as well.
>
> Thanks,
>
>         tglx

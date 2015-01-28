Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933698AbbA2DeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:34:14 -0500
Received: from mail-yk0-f171.google.com ([209.85.160.171]:53422 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757205AbbA2DeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 22:34:10 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1501241746210.5526@nanos>
References: <1421928077-4698-1-git-send-email-pang.xunlei@linaro.org>
	<1421928077-4698-3-git-send-email-pang.xunlei@linaro.org>
	<alpine.DEB.2.11.1501222202420.5526@nanos>
	<CADcy93UD1EHiHLsgCPjODZMu1fBpKhOXuN=4Egwu6gB2UZX0+w@mail.gmail.com>
	<alpine.DEB.2.11.1501241746210.5526@nanos>
Date: Thu, 29 Jan 2015 00:00:07 +0800
Message-ID: <CADcy93VetnSr2ic_M37Zr+bwGfLzzW6-YgrC+q66s_nY5v0kuQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] time: clocksource: Add a comment to CLOCK_SOURCE_SUSPEND_NONSTOP
From: Xunlei Pang <pang.xunlei@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On 25 January 2015 at 01:07, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Sat, 24 Jan 2015, Xunlei Pang wrote:
>
>> Before this, I tried to add some code to catch such problem at the
>> time of registering the clocksource, like using the
>> CLOCKSOURCE_MASK(), for example 64bit counter will never wrap for
>> us. But there may be other values like CLOCKSOURCE_MASK(56), I just
>> can't figure out exactly how to do this judge.
>
> I don't think there is a good way to do so. Registration time is the
> wrong place anyway because the problem depends on:
>
>  - The width of the counter
>  - The frequency of the counter
>
> The frequency of the counter might even change after registration. Now
> add the unknown duration of the suspend to the picture and you're
> completely lost.
>
> All we can do is provide information about the actual wraparound time,
> if the CLOCK_SOURCE_SUSPEND_NONSTOP flag is set and the wraparound
> time is less than some reasonable margin.
>

Yes, we can only deal with it approximately. How about this?

1) Add a new member about reference wraparound time(max system suspend
period allowed) to struct  clocksource. In
__clocksource_updatefreq_scale(), we can use  "sec" which already
applys 12.5% margin as its value.

2) Add a new tuneable sysctl threshold with a default time period
value(for example, 365 days)
    We can also printk its value when booting or changing its value to
notice people about this.

3) then,  in timekeeping_resume(), we can compare the reference
wraparound of the nonstop clocksource with the sysctl threshold to
decide if it is dependable to use.

Thanks,
Xunlei

>
>
>
>

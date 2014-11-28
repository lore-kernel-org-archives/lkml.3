Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588AbaK1P62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 10:58:28 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:49022 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaK1P61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 10:58:27 -0500
MIME-Version: 1.0
In-Reply-To: <4653852.SPZ1tnKaLF@wuerfel>
References: <1417089760-26848-1-git-send-email-pang.xunlei@linaro.org>
	<1417089760-26848-2-git-send-email-pang.xunlei@linaro.org>
	<alpine.DEB.2.11.1411272350190.3961@nanos>
	<4653852.SPZ1tnKaLF@wuerfel>
Date: Fri, 28 Nov 2014 23:58:26 +0800
Message-ID: <CADcy93Wda-aGETFKmqHrByTuegtjXJ3B2npQ9TRJJvb4Ps7a+A@mail.gmail.com>
Subject: Re: [RFC PATCH 1/4] rtc/mxc: Convert get_alarm_or_time()/set_alarm_or_time()
 to use time64_t
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Sven Schnelle <svens@stackframe.org>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 November 2014 at 07:47, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 28 November 2014 00:02:47 Thomas Gleixner wrote:
>>
>> >  static int rtc_update_alarm(struct device *dev, struct rtc_time *alrm)
>> >  {
>> >       struct rtc_time alarm_tm, now_tm;
>> > -     unsigned long now, time;
>> > +     time64_t now, time;
>> >       struct platform_device *pdev = to_platform_device(dev);
>> >       struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
>> >       void __iomem *ioaddr = pdata->ioaddr;
>> >
>> >       now = get_alarm_or_time(dev, MXC_RTC_TIME);
>> > -     rtc_time_to_tm(now, &now_tm);
>> > +     rtc_time64_to_tm(now, &now_tm);
>>
>> So here you convert that to struct rtc_time.
>>
>> >       alarm_tm.tm_year = now_tm.tm_year;
>> >       alarm_tm.tm_mon = now_tm.tm_mon;
>> >       alarm_tm.tm_mday = now_tm.tm_mday;
>> >       alarm_tm.tm_hour = alrm->tm_hour;
>> >       alarm_tm.tm_min = alrm->tm_min;
>> >       alarm_tm.tm_sec = alrm->tm_sec;
>> > -     rtc_tm_to_time(&alarm_tm, &time);
>> > +     time = rtc_tm_to_time64(&alarm_tm);
>>
>> Just to convert it back and then do the reverse operation in
>> set_alarm_or_time()
>
> Apparently the code originally tried to make the alarm fire within
> the next 24 hours. What you and the author of c92182ee0b5a3
> ("drivers/rtc/rtc-mxc.c: make alarm work") apparently missed is that
> it is taking the year/mon/mday value of today and the hour/min/sec
> value from the function argument.
>
> I think the idea was to make it work with user space that sets only
> the last three fields (which would work on the typical x86 rtc),
> but after that other patch, the function no longer makes any sense,
> since it will set the alarm in the past half of the time.

In rtc_dev_ioctl() RTC_ALM_SET, there is some common code handling such issue:
/* alarm may need to wrap into tomorrow */
if (then < now) {
rtc_time_to_tm(now + 24 * 60 * 60, &tm);
alarm.time.tm_mday = tm.tm_mday;
alarm.time.tm_mon = tm.tm_mon;
alarm.time.tm_year = tm.tm_year;
}
}

return rtc_set_alarm(rtc, &alarm);

But it still has a small window may set the past alarm time, even in
rtc drivers' set_alarm().
I think the driver should behave as follows to completely avoid this issue:

disable local irq

make sure the alarm time is later than now by delta, this delta should
be long enough to finish regs operations.

set alarm regs

enable local irq

Sadly, lots of rtc drivers have problems.

Regards,
-Xunlei
>
>         Arnd

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760155Ab3K0Bnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:43:40 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:53211 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758242Ab3K0A57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:57:59 -0500
MIME-Version: 1.0
In-Reply-To: <52953870.5050906@roeck-us.net>
References: <1385490637-10306-1-git-send-email-dianders@chromium.org>
	<5294ED12.9080700@roeck-us.net>
	<CAD=FV=UX5gm3Ju8sCd3DSgyo97P6imN_Ay1zvc8yX=qTJ_mbrw@mail.gmail.com>
	<52953870.5050906@roeck-us.net>
Date: Tue, 26 Nov 2013 16:57:57 -0800
X-Google-Sender-Auth: yuqyysxn-XlHGR-WzjG4S1Cg5xo
Message-ID: <CAD=FV=UBDBsWxkaO8Y4G8DN+HhA9ngw8Ftpte4EszF82eiZ38w@mail.gmail.com>
Subject: Re: [PATCH] watchdog: s3c2410_wdt: Handle rounding a little better
 for timeout
From: Doug Anderson <dianders@chromium.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wim Van Sebroeck <wim@iguana.be>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Olof Johansson <olof@lixom.net>, Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-watchdog@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guenter,

On Tue, Nov 26, 2013 at 4:10 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> On 11/26/2013 01:34 PM, Doug Anderson wrote:
>>
>> Guenter,
>>
>> On Tue, Nov 26, 2013 at 10:48 AM, Guenter Roeck <linux@roeck-us.net>
>> wrote:
>>>
>>> On 11/26/2013 10:30 AM, Doug Anderson wrote:
>>>>
>>>>
>>>> The existing watchdog timeout worked OK but didn't deal with
>>>> rounding in an ideal way when dividing out all of its clocks.
>>>>
>>>> Specifically if you had a timeout of 32 seconds and an input clock of
>>>> 66666666, you'd end up setting a timeout of 31.9998 seconds and
>>>> reporting a timeout of 31 seconds.
>>>>
>>>> Specifically DBG printouts showed:
>>>>     s3c2410wdt_set_heartbeat: count=16666656, timeout=32, freq=520833
>>>>     s3c2410wdt_set_heartbeat: timeout=32, divisor=255, count=16666656
>>>> (0000ff4f)
>>>> and the final timeout reported to the user was:
>>>>     ((count / divisor) * divisor) / freq
>>>>     (0xff4f * 255) / 520833 = 31 (truncated from 31.9998)
>>>> the technically "correct" value is:
>>>>     (0xff4f * 255) / (66666666.0 / 128) = 31.9998
>>>>
>>>> By using "DIV_ROUND_UP" we can be a little more correct.
>>>>     s3c2410wdt_set_heartbeat: count=16666688, timeout=32, freq=520834
>>>>     s3c2410wdt_set_heartbeat: timeout=32, divisor=255, count=16666688
>>>> (0000ff50)
>>>> and the final timeout reported to the user:
>>>>     (0xff50 * 255) / 520834 = 32
>>>> the technically "correct" value is:
>>>>     (0xff50 * 255) / (66666666.0 / 128) = 32.0003
>>>>
>>>> We'll use a DIV_ROUND_UP to solve this, generally erroring on the side
>>>> of reporting shorter values to the user and setting the watchdog to
>>>> slightly longer than requested:
>>>> * Round input frequency up to assume watchdog is counting faster.
>>>> * Round divisions by divisor up to give us extra time.
>>>>
>>>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>>>> ---
>>>>    drivers/watchdog/s3c2410_wdt.c | 10 +++++-----
>>>>    1 file changed, 5 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/drivers/watchdog/s3c2410_wdt.c
>>>> b/drivers/watchdog/s3c2410_wdt.c
>>>> index 7d8fd04..fe2322b 100644
>>>> --- a/drivers/watchdog/s3c2410_wdt.c
>>>> +++ b/drivers/watchdog/s3c2410_wdt.c
>>>> @@ -188,7 +188,7 @@ static int s3c2410wdt_set_heartbeat(struct
>>>> watchdog_device *wdd, unsigned timeou
>>>>          if (timeout < 1)
>>>>                  return -EINVAL;
>>>>
>>>> -       freq /= 128;
>>>> +       freq = DIV_ROUND_UP(freq, 128);
>>>>          count = timeout * freq;
>>>>
>>>>          DBG("%s: count=%d, timeout=%d, freq=%lu\n",
>>>> @@ -201,20 +201,20 @@ static int s3c2410wdt_set_heartbeat(struct
>>>> watchdog_device *wdd, unsigned timeou
>>>>
>>>>          if (count >= 0x10000) {
>>>>                  for (divisor = 1; divisor <= 0x100; divisor++) {
>>>> -                       if ((count / divisor) < 0x10000)
>>>> +                       if (DIV_ROUND_UP(count, divisor) < 0x10000)
>>>>                                  break;
>>>>                  }
>>>>
>>> Since you are at it,
>>>          divisor = DIV_ROUND_UP(count + 1, 0x10000);
>>> might be faster, simpler, and easier to understand than the loop.
>>
>>
>> Way to see the forest for the trees!
>>
>> Your math ends up with a slightly different result than the old code,
>> though.  One example is when the count is 0x1ffff.  You'll end up with
>> a divider of 2 and I'll end up with a divider of 3.
>>
>> I think we just want:
>>
>> divisor = DIV_ROUND_UP(count, 0xffff);
>>
>> ...that produces the same result as the old loop, but am curious to
>> know why you chose the "count + 1" and "0x10000".
>>
>
> Hi Doug,
>
> I thought the idea was to keep (count / div) less than 0x10000, which you
> get
> by dividing through 0x10000. 0x10000 / 0x10000 = 1, though, so I added 1
> to the counter. But maybe I was thinking too much ;-).

Ah, I was trying to keep "DIV_ROUND_UP(count, divisor);" less than
0x10000, which (I think) means that you need to do division by 0xFFFF.
 Specifically below in my patch I use DIV_ROUND_UP() since I want to
error on the side of having a higher count (fire later).  This stuff
always makes my head spin, though.

I believe that DIV_ROUND_UP(0x1ffff, 2) = 0x10000, which is greater than 0xffff.

> Now, 0x1ffff / 2 = 0xffff is still lower than 0x10000, which is what
> I thought is the requirement. Ultimately the error is small either way,
> so DIV_ROUND_UP(count, 0xffff) is just as good to me to avoid the loop.

I did code up a quick test script that made sure that the result with
"DIV_ROUND_UP(count, 0xffff)" matched the results of the loop that I
coded up in the first version of this patchset for all reasonable
values of count, so I'm going to go with that.

Spun patch coming right up...

-Doug

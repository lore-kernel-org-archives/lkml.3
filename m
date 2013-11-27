Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab3K0AK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:10:29 -0500
Received: from mail.active-venture.com ([67.228.131.205]:56048 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab3K0AK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:10:26 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52953870.5050906@roeck-us.net>
Date: Tue, 26 Nov 2013 16:10:24 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Wim Van Sebroeck <wim@iguana.be>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Olof Johansson <olof@lixom.net>, Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-watchdog@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] watchdog: s3c2410_wdt: Handle rounding a little better
 for timeout
References: <1385490637-10306-1-git-send-email-dianders@chromium.org>	<5294ED12.9080700@roeck-us.net> <CAD=FV=UX5gm3Ju8sCd3DSgyo97P6imN_Ay1zvc8yX=qTJ_mbrw@mail.gmail.com>
In-Reply-To: <CAD=FV=UX5gm3Ju8sCd3DSgyo97P6imN_Ay1zvc8yX=qTJ_mbrw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 01:34 PM, Doug Anderson wrote:
> Guenter,
>
> On Tue, Nov 26, 2013 at 10:48 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>> On 11/26/2013 10:30 AM, Doug Anderson wrote:
>>>
>>> The existing watchdog timeout worked OK but didn't deal with
>>> rounding in an ideal way when dividing out all of its clocks.
>>>
>>> Specifically if you had a timeout of 32 seconds and an input clock of
>>> 66666666, you'd end up setting a timeout of 31.9998 seconds and
>>> reporting a timeout of 31 seconds.
>>>
>>> Specifically DBG printouts showed:
>>>     s3c2410wdt_set_heartbeat: count=16666656, timeout=32, freq=520833
>>>     s3c2410wdt_set_heartbeat: timeout=32, divisor=255, count=16666656
>>> (0000ff4f)
>>> and the final timeout reported to the user was:
>>>     ((count / divisor) * divisor) / freq
>>>     (0xff4f * 255) / 520833 = 31 (truncated from 31.9998)
>>> the technically "correct" value is:
>>>     (0xff4f * 255) / (66666666.0 / 128) = 31.9998
>>>
>>> By using "DIV_ROUND_UP" we can be a little more correct.
>>>     s3c2410wdt_set_heartbeat: count=16666688, timeout=32, freq=520834
>>>     s3c2410wdt_set_heartbeat: timeout=32, divisor=255, count=16666688
>>> (0000ff50)
>>> and the final timeout reported to the user:
>>>     (0xff50 * 255) / 520834 = 32
>>> the technically "correct" value is:
>>>     (0xff50 * 255) / (66666666.0 / 128) = 32.0003
>>>
>>> We'll use a DIV_ROUND_UP to solve this, generally erroring on the side
>>> of reporting shorter values to the user and setting the watchdog to
>>> slightly longer than requested:
>>> * Round input frequency up to assume watchdog is counting faster.
>>> * Round divisions by divisor up to give us extra time.
>>>
>>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>>> ---
>>>    drivers/watchdog/s3c2410_wdt.c | 10 +++++-----
>>>    1 file changed, 5 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/watchdog/s3c2410_wdt.c
>>> b/drivers/watchdog/s3c2410_wdt.c
>>> index 7d8fd04..fe2322b 100644
>>> --- a/drivers/watchdog/s3c2410_wdt.c
>>> +++ b/drivers/watchdog/s3c2410_wdt.c
>>> @@ -188,7 +188,7 @@ static int s3c2410wdt_set_heartbeat(struct
>>> watchdog_device *wdd, unsigned timeou
>>>          if (timeout < 1)
>>>                  return -EINVAL;
>>>
>>> -       freq /= 128;
>>> +       freq = DIV_ROUND_UP(freq, 128);
>>>          count = timeout * freq;
>>>
>>>          DBG("%s: count=%d, timeout=%d, freq=%lu\n",
>>> @@ -201,20 +201,20 @@ static int s3c2410wdt_set_heartbeat(struct
>>> watchdog_device *wdd, unsigned timeou
>>>
>>>          if (count >= 0x10000) {
>>>                  for (divisor = 1; divisor <= 0x100; divisor++) {
>>> -                       if ((count / divisor) < 0x10000)
>>> +                       if (DIV_ROUND_UP(count, divisor) < 0x10000)
>>>                                  break;
>>>                  }
>>>
>> Since you are at it,
>>          divisor = DIV_ROUND_UP(count + 1, 0x10000);
>> might be faster, simpler, and easier to understand than the loop.
>
> Way to see the forest for the trees!
>
> Your math ends up with a slightly different result than the old code,
> though.  One example is when the count is 0x1ffff.  You'll end up with
> a divider of 2 and I'll end up with a divider of 3.
>
> I think we just want:
>
> divisor = DIV_ROUND_UP(count, 0xffff);
>
> ...that produces the same result as the old loop, but am curious to
> know why you chose the "count + 1" and "0x10000".
>

Hi Doug,

I thought the idea was to keep (count / div) less than 0x10000, which you get
by dividing through 0x10000. 0x10000 / 0x10000 = 1, though, so I added 1
to the counter. But maybe I was thinking too much ;-).

Now, 0x1ffff / 2 = 0xffff is still lower than 0x10000, which is what
I thought is the requirement. Ultimately the error is small either way,
so DIV_ROUND_UP(count, 0xffff) is just as good to me to avoid the loop.

Thanks,
Guenter


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376AbaFSQbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:31:14 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:64164 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757533AbaFSQbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:31:12 -0400
MIME-Version: 1.0
In-Reply-To: <53A30D08.6070107@gmail.com>
References: <1403167145-5267-1-git-send-email-amit.daniel@samsung.com>
	<53A2B9C3.1050906@gmail.com>
	<CAD=FV=VmC-p4_R1GV3U3bg1JojTzNYKyFTa8o8QMJ=3m=WuRYA@mail.gmail.com>
	<53A30D08.6070107@gmail.com>
Date: Thu, 19 Jun 2014 09:31:11 -0700
X-Google-Sender-Auth: 6xkTN-fgQvkZ6H9geTJ8VIHXVPU
Message-ID: <CAD=FV=UjFJ9utR9i=Xu4DRQ7gdULCtXQXgsQ8gUYm6-V5U4GaQ@mail.gmail.com>
Subject: Re: [PATCH v2] clocksource: exynos-mct: Register the timer for stable udelay
From: Doug Anderson <dianders@chromium.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Riley <davidriley@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz,

On Thu, Jun 19, 2014 at 9:17 AM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> On 19.06.2014 18:01, Doug Anderson wrote:
>> Hi,
>>
>> On Thu, Jun 19, 2014 at 3:21 AM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
>>>> +static struct delay_timer exynos4_delay_timer;
>>>> +
>>>> +static unsigned long exynos4_read_current_timer(void)
>>
>> Note: I think this should return a cycles_t, not an unsigned long.
>> They're the same (right now), but probably shouldn't be (see below).
>>
>>
>>>> +{
>>>> +#ifdef ARM
>>>> +     return __raw_readl(reg_base + EXYNOS4_MCT_G_CNT_L);
>>>> +#else /* ARM64, etc */
>>>> +     return exynos4_frc_read(&mct_frc);
>>>> +#endif
>>>> +}
>>>> +
>>>
>>> No need for anything like this. Even if running on ARM64, the delay
>>> timer code should be able to cope with different timer widths. For
>>> delays, 32 bits are enough, so just always read the lower part.
>>
>> I agree that the timer code should cope but it doesn't appear to.  I see:
>>
>>   cycles_t start = get_cycles();
>>   while ((get_cycles() - start) < cycles)
>>     cpu_relax();
>>
>> Right now cycles_t is defined as "unsigned long".  If that's 64-bits
>> on ARM64 then this function will have problems with wraparound.
>
> Well, first of all, I'm not sure why we're discussing ARM64 here, if it
> doesn't have support for register_current_timer_delay() at all.
> Moreover, the only user if it is ARM32 and, if I remember correctly, the
> assumption was that you need a >= 32 bit timer to use it for delays and
> so with 32 bit unsigned long everything should work. Now if ARM64 also
> wants to use this infrastructure, instead of hacking drivers now and
> encouraging ARM64 people to continue using this kind of hackery, I
> believe we should indicate that ARM64 delay timer code needs to be
> implemented correctly and cope for different timer widths.
>
> Of course the best way would be to redesign this interface right now to
> consider time width (it is not just about 32 or 64 bits, there are
> various timers, possibly 48- or 52-bit) and change ARM32 implementation
> of it as well, if there are any volunteers.

I was arguing that it was a lot of extra complexity to add to the code
to support different timer sizes for udelay when 32-bits is enough
(and it's trivial for timer implementations to truncate down to
32-bits).


> Changing the code to always
> use 32-bit type regardless of arch is also an option.

Right, that's what I was arguing for.


>> My personal vote would be to submit a patch to change "cycles_t" to
>> always be 32-bits.  Given that 32-bits was fine for udelay() for ARM
>> that seems sane and simple.  If someone later comes up with a super
>> compelling reason why we need 64-bit timers for udelay (really??) then
>> they can later add all the complexity needed.
>
> Yes, this could work. I'm not sure what else cycles_t is used for, though.

True, it is a bit questionable to change this since it's a type that's
not obviously just for udelay().  Perhaps a better option would be to
make a new typedef for the result of read_current_timer().  ...or just
change it to return a u32?


>> Amit: can you code up such a patch and add it to the series?  I know
>> it changes code that touches all ARM devices but I still think it's
>> the right thing to do and actually only really changes behavior on
>> ARM64.
>>
>>
>>> Also use of raw accessors in drivers is discouraged - please use
>>> readl_relaxed().
>>
>> It doesn't seem like that should happen in the same patch.  Perhaps
>> Amit can do a cleanup patch first that changes all instances of
>> __raw_readl / __raw_writel in this file, then submit his patch atop
>> that.
>
> Why not? The patch adding exynos4_read_current_timer() (and so the call
> to __raw_readl() was Amit's patch. I'm not asking to fix this in the
> whole driver, just to do things correctly in new code.

IMHO consistency within a file is more important.  Having a single
readl_relaxed() in a file that uses all __raw_readl() doesn't seem
beneficial to me.  ...but I certainly won't NAK the patch if that's
what others want.


>>> Btw. I don't even see support for this on ARM64 in mainline, where arch
>>> timer is always used for delays and AFAIK this is a platform requirement.
>>
>> Yeah, I'd vote for not using MCT on ARM64, but it I suppose it doesn't
>> hurt to keep it working.
>
> Right now there is no need for this, so let's just keep things simple.

It should at least have a comment saying that it's broken in subtle
ways (only on udelays that happen to span the 32-bit wraparound) on
anything where cycle_t is not 32-bits.  Perhaps at least a:
  WARN_ON_ONCE(sizeof(cycles_t) != sizeof(u32));

The above should be optimized by the compiler.

-Doug

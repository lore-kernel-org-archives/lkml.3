Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010AbaFSQBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:01:41 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:59084 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757568AbaFSQBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:01:39 -0400
MIME-Version: 1.0
In-Reply-To: <53A2B9C3.1050906@gmail.com>
References: <1403167145-5267-1-git-send-email-amit.daniel@samsung.com>
	<53A2B9C3.1050906@gmail.com>
Date: Thu, 19 Jun 2014 09:01:38 -0700
X-Google-Sender-Auth: ORBCApb51NNA8tGWkIbFp0nA84c
Message-ID: <CAD=FV=VmC-p4_R1GV3U3bg1JojTzNYKyFTa8o8QMJ=3m=WuRYA@mail.gmail.com>
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

Hi,

On Thu, Jun 19, 2014 at 3:21 AM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
>> +static struct delay_timer exynos4_delay_timer;
>> +
>> +static unsigned long exynos4_read_current_timer(void)

Note: I think this should return a cycles_t, not an unsigned long.
They're the same (right now), but probably shouldn't be (see below).


>> +{
>> +#ifdef ARM
>> +     return __raw_readl(reg_base + EXYNOS4_MCT_G_CNT_L);
>> +#else /* ARM64, etc */
>> +     return exynos4_frc_read(&mct_frc);
>> +#endif
>> +}
>> +
>
> No need for anything like this. Even if running on ARM64, the delay
> timer code should be able to cope with different timer widths. For
> delays, 32 bits are enough, so just always read the lower part.

I agree that the timer code should cope but it doesn't appear to.  I see:

  cycles_t start = get_cycles();
  while ((get_cycles() - start) < cycles)
    cpu_relax();

Right now cycles_t is defined as "unsigned long".  If that's 64-bits
on ARM64 then this function will have problems with wraparound.

My personal vote would be to submit a patch to change "cycles_t" to
always be 32-bits.  Given that 32-bits was fine for udelay() for ARM
that seems sane and simple.  If someone later comes up with a super
compelling reason why we need 64-bit timers for udelay (really??) then
they can later add all the complexity needed.

Amit: can you code up such a patch and add it to the series?  I know
it changes code that touches all ARM devices but I still think it's
the right thing to do and actually only really changes behavior on
ARM64.


> Also use of raw accessors in drivers is discouraged - please use
> readl_relaxed().

It doesn't seem like that should happen in the same patch.  Perhaps
Amit can do a cleanup patch first that changes all instances of
__raw_readl / __raw_writel in this file, then submit his patch atop
that.


> Btw. I don't even see support for this on ARM64 in mainline, where arch
> timer is always used for delays and AFAIK this is a platform requirement.

Yeah, I'd vote for not using MCT on ARM64, but it I suppose it doesn't
hurt to keep it working.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365AbaFTRrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 13:47:13 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:58580 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbaFTRrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 13:47:10 -0400
MIME-Version: 1.0
In-Reply-To: <CADGdYn6ZCvnfod3smE_mdJhK-BdkHMtno2GCH8jzX=BRWDCRPQ@mail.gmail.com>
References: <1403167145-5267-1-git-send-email-amit.daniel@samsung.com>
	<53A2B9C3.1050906@gmail.com>
	<CAD=FV=VmC-p4_R1GV3U3bg1JojTzNYKyFTa8o8QMJ=3m=WuRYA@mail.gmail.com>
	<53A30D08.6070107@gmail.com>
	<CAD=FV=UjFJ9utR9i=Xu4DRQ7gdULCtXQXgsQ8gUYm6-V5U4GaQ@mail.gmail.com>
	<53A31291.9000007@gmail.com>
	<20140620081509.GA25104@arm.com>
	<CADGdYn6ZCvnfod3smE_mdJhK-BdkHMtno2GCH8jzX=BRWDCRPQ@mail.gmail.com>
Date: Fri, 20 Jun 2014 10:47:09 -0700
X-Google-Sender-Auth: fQPhMiCaJtll46JydCVcECtSLQg
Message-ID: <CAD=FV=UJFnDj_fuehfTUjMEzS52dWxVUjHSFxPS9oj63pNKT4A@mail.gmail.com>
Subject: Re: [PATCH v2] clocksource: exynos-mct: Register the timer for stable udelay
From: Doug Anderson <dianders@chromium.org>
To: amit daniel kachhap <amit.daniel@samsung.com>
Cc: Will Deacon <will.deacon@arm.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        David Riley <davidriley@chromium.org>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jun 20, 2014 at 4:19 AM, amit daniel kachhap
<amit.daniel@samsung.com> wrote:
> On Fri, Jun 20, 2014 at 1:45 PM, Will Deacon <will.deacon@arm.com> wrote:
>> On Thu, Jun 19, 2014 at 05:40:49PM +0100, Tomasz Figa wrote:
>>> On 19.06.2014 18:31, Doug Anderson wrote:
>>> >>> My personal vote would be to submit a patch to change "cycles_t" to
>>> >>> always be 32-bits.  Given that 32-bits was fine for udelay() for ARM
>>> >>> that seems sane and simple.  If someone later comes up with a super
>>> >>> compelling reason why we need 64-bit timers for udelay (really??) then
>>> >>> they can later add all the complexity needed.
>>> >>
>>> >> Yes, this could work. I'm not sure what else cycles_t is used for, though.
>>> >
>>> > True, it is a bit questionable to change this since it's a type that's
>>> > not obviously just for udelay().  Perhaps a better option would be to
>>> > make a new typedef for the result of read_current_timer().  ...or just
>>> > change it to return a u32?
>>> >
>>>
>>> Sounds good to me, but let's hear other opinions. I'm adding Will and
>>> Jonathan as they wrote the ARM delay timer code.
>>
>> I think cycles_t is only used for small interval calculations at the moment,
>> but I remember Ted mentioning something about using it (or something
>> similar) as a source of early entropy, in which case the more bits the
>> better.
>>
> Will,
> Thanks for the clarification that cycles_t is used for short
> intervals. So it is safe to return lower 32 bit
> counter for read_current_timer.

As I looked at it more, I realized that we have two types in Linux.
There's cycle_t and cycles_t.  Whoa, confusing!

I'd perhaps advocate a wholesale rename of cycles_t to avoid the
confusion.  I don't have a good name for it, though.  cycle32_t?  Or
we could just use u32 for the function...  :-/


> Tomasz, Doug,
> As of now let me send a minimal implementation of this read delay
> timer to fix the broken udelay for exynos platforms so that it goes to
> upstream in rc releases. I will also prepare a fix for all
> raw_readl/writel in mct to relaxed version to make it consistent.

I'm reworking my 32-bit conversion patches right now and it's getting
messy to intermingle this with yours.  I'm going to pick up your patch
and include it in my series.  I hope that's OK.

My plan is:

1. For 3.16 I think it's important to fix the udelay() problems and
trying to rework cycle_t there doesn't seem like it makes sense.  I'll
just use Amit's original code that uses exynos_frc_read().  It might
not be quite as optimal but it's good as a safe bugfix.

2. I'll post the cleanup patch moving away from the __raw_readl / __raw_writel

3. I'll post a patch moving to 32-bit, including moving Amit's code to
32-bit but with a compile time warning for now.  I'll add a KConfig
depends to keep it from compiling on ARM64.  We can improve this once
we change the delay timer to always request 32-bits.

-Doug

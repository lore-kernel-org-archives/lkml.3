Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967241AbaFTWGA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 18:06:00 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:50060 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966070AbaFTWF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 18:05:57 -0400
MIME-Version: 1.0
In-Reply-To: <7hwqcbs166.fsf@paris.lan>
References: <1403155273-1057-1-git-send-email-dianders@chromium.org>
	<7h8uosyc3k.fsf@paris.lan>
	<CAD=FV=XxNVmF+N5HF4SnZoJRJvkSUkpEx6ct4v2gtmAQ9n28-Q@mail.gmail.com>
	<7hwqcbs166.fsf@paris.lan>
Date: Fri, 20 Jun 2014 15:05:56 -0700
X-Google-Sender-Auth: vZO3VVVEjTdUV7jKJFa-phNmR8o
Message-ID: <CAD=FV=Uz9O0i2gmuk2+BHa-Tksvyxv0+MTi2UEjVREAMNCK7Ug@mail.gmail.com>
Subject: Re: [PATCH] i2c: exynos5: Properly use the "noirq" variants of suspend/resume
From: Doug Anderson <dianders@chromium.org>
To: Kevin Hilman <khilman@linaro.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, Kukjin Kim <kgene.kim@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        naveen krishna <ch.naveen@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>, Jean Delvare <jdelvare@suse.de>,
        Simon Glass <sjg@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, standby24x7@gmail.com,
        Sachin Kamat <sachin.kamat@linaro.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin,

On Fri, Jun 20, 2014 at 2:48 PM, Kevin Hilman <khilman@linaro.org> wrote:
> Hi Doug,
>
> Doug Anderson <dianders@chromium.org> writes:
>
>> On Thu, Jun 19, 2014 at 11:43 AM, Kevin Hilman <khilman@linaro.org> wrote:
>>> Doug Anderson <dianders@chromium.org> writes:
>>>
>>>> The original code for the exynos i2c controller registered for the
>>>> "noirq" variants.  However during review feedback it was moved to
>>>> SIMPLE_DEV_PM_OPS without anyone noticing that it meant we were no
>>>> longer actually "noirq" (despite functions named
>>>> exynos5_i2c_suspend_noirq and exynos5_i2c_resume_noirq).
>>>>
>>>> i2c controllers that might have wakeup sources on them seem to need to
>>>> resume at noirq time so that the individual drivers can actually read
>>>> the i2c bus to handle their wakeup.
>>>
>>> I suspect usage of the noirq variants pre-dates the existence of the
>>> late/early callbacks in the PM core, but based on the description above,
>>> I suspect what you actually want is the late/early callbacks.
>>
>> I think it actually really needs noirq.  ;)
>
> Yes, it appears it does.   Objection withdrawn.
>
> I just wanted to be sure because since the introduction of late/early,
> the need for noirq should be pretty rare, but there certainly are needs.
>
> <tangent>
> In this case though, the need for it has more to do with the
> lack of a way for us to describe non parent-child device dependencies
> than whether or not IRQs are enabled or not.
> </tangent>

Actually, I'm not sure that's true, but I'll talk through it and you
can point to where I'm wrong (I often am!)

If you're a wakeup device then you need to be ready to handle
interrupts as soon as the "noirq" phase of resume is done, right?
Said another way: you need to be ready to handle interrupts _before_
the normal resume code is called and be ready to handle interrupts
even _before_ the early resume code is called.

That means if you are implementing a bus that's needed by any devices
with wakeup interrupts then it's your responsibility to also be
prepared to run this early.

In this particular case the max77686 driver doesn't need to do
anything at all to be ready to handle interrupts.  It's suspend and
resume code is just boilerplate "enable wakeups / disable wakeups" and
it has no "noirq" code.  The max77686 driver doesn't have any "noirq"
wake call because it would just be empty.

Said another way: the problem isn't that the max77686 wakeup gets
called before the i2c wakeup.  The problem is that i2c is needed ASAP
once IRQs are enabled and thus needs to be run noirq.

Does that sound semi-correct?

-Doug

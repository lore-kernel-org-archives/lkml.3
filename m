Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbaFWWBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 18:01:44 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:59464 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816AbaFWWBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 18:01:40 -0400
MIME-Version: 1.0
In-Reply-To: <53A4CADA.4030002@gmail.com>
References: <1403155273-1057-1-git-send-email-dianders@chromium.org>
	<7h8uosyc3k.fsf@paris.lan>
	<CAD=FV=XxNVmF+N5HF4SnZoJRJvkSUkpEx6ct4v2gtmAQ9n28-Q@mail.gmail.com>
	<7hwqcbs166.fsf@paris.lan>
	<CAD=FV=Uz9O0i2gmuk2+BHa-Tksvyxv0+MTi2UEjVREAMNCK7Ug@mail.gmail.com>
	<7h7g4brx6w.fsf@paris.lan>
	<CAD=FV=VmPMf6tCNmKJ1o5J7PyAXoU8fb6+s+Fkv18FH2WaQp7A@mail.gmail.com>
	<53A4CADA.4030002@gmail.com>
Date: Mon, 23 Jun 2014 15:01:39 -0700
X-Google-Sender-Auth: kLVRnAkULjUiwAiCvCD3mBo6bxw
Message-ID: <CAD=FV=VkxA01eEFiXSp+c+GDuVJi7TctAdnyrMggk1gRw6BStQ@mail.gmail.com>
Subject: Re: [PATCH] i2c: exynos5: Properly use the "noirq" variants of suspend/resume
From: Doug Anderson <dianders@chromium.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Kevin Hilman <khilman@linaro.org>, Wolfram Sang <wsa@the-dreams.de>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        naveen krishna <ch.naveen@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>, Jean Delvare <jdelvare@suse.de>,
        Simon Glass <sjg@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Masanari Iida <standby24x7@gmail.com>,
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

Tomasz,

On Fri, Jun 20, 2014 at 4:59 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> On 21.06.2014 01:53, Doug Anderson wrote:
>> Kevin,
>>
>> On Fri, Jun 20, 2014 at 4:13 PM, Kevin Hilman <khilman@linaro.org> wrote:
>>> Doug Anderson <dianders@chromium.org> writes:
>>>
>>>> Kevin,
>>>>
>>>> On Fri, Jun 20, 2014 at 2:48 PM, Kevin Hilman <khilman@linaro.org> wrote:
>>>>> Hi Doug,
>>>>>
>>>>> Doug Anderson <dianders@chromium.org> writes:
>>>>>
>>>>>> On Thu, Jun 19, 2014 at 11:43 AM, Kevin Hilman <khilman@linaro.org> wrote:
>>>>>>> Doug Anderson <dianders@chromium.org> writes:
>>>>>>>
>>>>>>>> The original code for the exynos i2c controller registered for the
>>>>>>>> "noirq" variants.  However during review feedback it was moved to
>>>>>>>> SIMPLE_DEV_PM_OPS without anyone noticing that it meant we were no
>>>>>>>> longer actually "noirq" (despite functions named
>>>>>>>> exynos5_i2c_suspend_noirq and exynos5_i2c_resume_noirq).
>>>>>>>>
>>>>>>>> i2c controllers that might have wakeup sources on them seem to need to
>>>>>>>> resume at noirq time so that the individual drivers can actually read
>>>>>>>> the i2c bus to handle their wakeup.
>>>>>>>
>>>>>>> I suspect usage of the noirq variants pre-dates the existence of the
>>>>>>> late/early callbacks in the PM core, but based on the description above,
>>>>>>> I suspect what you actually want is the late/early callbacks.
>>>>>>
>>>>>> I think it actually really needs noirq.  ;)
>>>>>
>>>>> Yes, it appears it does.   Objection withdrawn.
>>>>>
>>>>> I just wanted to be sure because since the introduction of late/early,
>>>>> the need for noirq should be pretty rare, but there certainly are needs.
>>>>>
>>>>> <tangent>
>>>>> In this case though, the need for it has more to do with the
>>>>> lack of a way for us to describe non parent-child device dependencies
>>>>> than whether or not IRQs are enabled or not.
>>>>> </tangent>
>>>>
>>>> Actually, I'm not sure that's true, but I'll talk through it and you
>>>> can point to where I'm wrong (I often am!)
>>>>
>>>> If you're a wakeup device then you need to be ready to handle
>>>> interrupts as soon as the "noirq" phase of resume is done, right?
>>>
>>> As soon as the noirq phase of your own driver is done, correct.
>>>
>>>> Said another way: you need to be ready to handle interrupts _before_
>>>> the normal resume code is called and be ready to handle interrupts
>>>> even _before_ the early resume code is called.
>>>
>>> Correct.
>>>
>>>> That means if you are implementing a bus that's needed by any devices
>>>> with wakeup interrupts then it's your responsibility to also be
>>>> prepared to run this early.
>>>>
>>>> In this particular case the max77686 driver doesn't need to do
>>>> anything at all to be ready to handle interrupts.  It's suspend and
>>>> resume code is just boilerplate "enable wakeups / disable wakeups" and
>>>> it has no "noirq" code.  The max77686 driver doesn't have any "noirq"
>>>> wake call because it would just be empty.
>>>>
>>>> Said another way: the problem isn't that the max77686 wakeup gets
>>>> called before the i2c wakeup.  The problem is that i2c is needed ASAP
>>>> once IRQs are enabled and thus needs to be run noirq.
>>>>
>>>> Does that sound semi-correct?
>>>
>>> Yes that's correct.
>>>
>>> My point above was (trying to be) that ultimately this is an ordering
>>> issue.  e.g. the bus device needs to be "ready" before wakeup devices on
>>> that bus can handle wakeup interrupts etc.  The way we're handling that
>>> ordering is by the implied ordering of noirq, late/early and "normal"
>>> callbacks.  That's convenient, but not exactly obvious.
>>>
>>> It works because we dont' typically need too many layers here, but it
>>> would be much more understandable if we could describe this kind of
>>> dependency in a way that the suspend/resume code would suspend/resume
>>> things in the right order rather than by tinkering with callback levels
>>> (since otherwise suspend/resume ordering just depends on probe order.)
>>>
>>> This issue then usually gets me headed down my usual rant path about how
>>> I think runtime PM is much better suited for handling ordering and
>>> dependencies becuase it automatically handles parent/child dependencies
>>> and non parent/child dependencies can be handled by taking advantage of
>>> the get/put APIs which are refcounted, ect etc. but that's another can
>>> worms.
>>
>> Ah, I gotcha.  Yes, I'm a fan of having explicit dependency orderings too.
>>
>> So I guess in this case the truly correct way to handle it is:
>>
>> 1. i2c controller should have Runtime PM even though (as per the code
>> now) there's nothing you can do to it to save power under normal
>> circumstances.  So the runtime "suspend" code would be a no-op.
>>
>> 2. When the i2c controller is told to runtime resume, it should
>> double-check if a full SoC poweroff has happened since the last time
>> it checked.  In this case it should reinit its hardware.
>>
>> 3. If the i2c controller gets a full "resume" callback then it should
>> also reinit the hardware just so it's not sitting in a half-configured
>> state until the first peripheral uses it.
>>
>> If later someone finds a way to power gate the i2c controller when no
>> active transfers are going (and we actually save non-trivial power
>> doing this) then we've got a nice place to put that code.
>>
>> NOTE: Unless we can actually save power by power gating the i2c
>> peripheral when there are no active transfers, we would also just have
>> the i2c_xfer() init the hardware if needed.  Maybe that's kinda gross,
>> though.
>>
>>
>> -Doug
>>
>>
>> P.S. Just to confirm: you're not opposed to landing the noirq code
>> as-is.  This discussion is about how someone could make it better in
>> the future...
>>
>
> I'm not sure noirq is going to work correctly, at least not with current
> callbacks. I can see a call to clk_prepare_enable() there which needs to
> acquire a mutex.

Nice catch, thanks!  :)

OK, looking at that now.  Interestingly this doesn't seem to cause us
problems in our ChromeOS 3.8 tree.  I just tried enabling:
  CONFIG_DEBUG_ATOMIC_SLEEP=y

...and confirmed that I got it on right:

# zgrep -i atomic /proc/config.gz
CONFIG_DEBUG_ATOMIC_SLEEP=y

I can suspend/resume with no problems.  My bet is that it works fine because:

* resume_noirq is not considered "atomic" in the sense enforced by
CONFIG_DEBUG_ATOMIC_SLEEP (at least not in 3.8--I haven't tried on
ToT)

* At resume_noirq time nobody else is running so nobody else could be
holding the mutex.  Thus: no sleep

* The clock being used doesn't really have a prepare stage so it
doesn't sleep either.

That being said it doesn't seem so ideal to have a
clk_prepare_enable() in the noirq callback.  How about I add a
suspend/resume callback that does the prepare stage?


> Would disabling the irq in suspend callback of your wakeup device and
> reenabling it in resume, while keeping their wakeup capability enabled,
> work for you? Then you could resume i2c in .resume_early callback
> without any issues.

I will do it if that's what people want and I'll bet it will work.
...but I'm not a huge fan because:

* It seems to me that it's working around the kernel and not working
with the kernel.  The kernel's noirq stage is specifically for
handling any wakeup that needs to happen before IRQs are enabled.

* If any other i2c devices need wakeup they'll also need this workaround.

* We still need to change the i2c driver to use the early/late, which
is an implicit ordering.

...all that being said if we have a goal to avoid "noirq" then this
would accomplish that goal.

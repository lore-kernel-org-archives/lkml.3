Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab3ETMtE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 08:49:04 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:35128 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921Ab3ETMtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 08:49:02 -0400
MIME-Version: 1.0
In-Reply-To: <6807056B-84F9-468D-87C6-4C4AD7D8BA99@gmail.com>
References: <1368332581-94691-1-git-send-email-dt.tangr@gmail.com>
	<1368332581-94691-5-git-send-email-dt.tangr@gmail.com>
	<CACRpkdZBFbOnQ9rCehO0yKDN7fH9VR3VYCa_NkOGJz7KN+02FQ@mail.gmail.com>
	<26FBB324-AAA9-4C10-8978-C2EC1C26672E@gmail.com>
	<CACRpkdaO7ieSdo5+Yq0+CLDfP==+DBOWn8+v0ap5iMOJy0Vf=Q@mail.gmail.com>
	<6807056B-84F9-468D-87C6-4C4AD7D8BA99@gmail.com>
Date: Mon, 20 May 2013 14:49:01 +0200
Message-ID: <CACRpkdZ+nkRVwh9RguJkctCk4U7wnYBxuyg5j2nAUg7o3SvWPg@mail.gmail.com>
Subject: Re: [RFC PATCHv3 4/6] clocksource: Add TI-Nspire timer drivers
From: Linus Walleij <linus.walleij@linaro.org>
To: Daniel Tang <dt.tangr@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 18, 2013 at 8:40 AM, Daniel Tang <dt.tangr@gmail.com> wrote:
> On 17/05/2013, at 11:17 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
>
>>>> If this timer is really just 16 bits, it's a *pretty* good idea to use
>>>> the prescaler (I guess this is what IO_DIVIDER is) beacuse else you
>>>> will get short sleep times with CONFIG_NO_HZ_IDLE on this system,
>>>> and wake up unnecessarily often.
>>>>
>>>> The same goes for the clock event.
>>>
>>> The clock frequency is 32768Hz. Should I be scaling it down at that frequency?
>>
>> No. But that was *pretty* slow.
>>
>> The thing is that the driver is getting "some clockfrequency" from
>> the clk subsystem and does not know what it is.
>>
>> Usually (and I've seen this hardware design pattern a lot) when you
>> have a clock like this, and go talk to the clk implementation specialist
>> s/he will say "oh, yeah, I can mux in this 34 MHz clock to the timer
>> as well", and if that is possible then that is often what you want,
>> because it's good for things like HRtimers, and then it's useful to have
>> a prescaler och the clocksource/clockevent.
>>
>> You can use that 32768 Hz for clock events and clocksource (but I
>> suspect that HRtimers will never be useful on this platform due to this).
>>
>
> I forgot to mention before that there is also another timer that runs
> at the same freq as the APB (which is usually around 30MHz).
> Is this what you were alluding to? I haven't tested the driver on that timer yet.

OK then that is probably the timer you will use for clock event and
also sched_clock() in the end. (You'll be setting a better rating on it.)

I'm not alluding to it as I didn't know of it, but it makes HW-sense
that it exists :-)

> As I understand it, you're saying to use a prescaler on faster clock rates
> so the kernel can have a longer maximum delay time (since a 16 bit register
> can only hold only so much). In that case, what kind of range should I be
> scaling to? I suspect it needs to be large enough to keep the kernel from
> constantly waking but small enough for HR timers to be useful.

Yeah :-/

This is one of the cases where one thing excludes the other.

But if it's hard-wired to 32kHz you probably want to leave it as it
is.

Yours,
Linus Walleij

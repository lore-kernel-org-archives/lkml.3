Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbaFESVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 14:21:39 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:61229 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbaFESVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 14:21:37 -0400
MIME-Version: 1.0
In-Reply-To: <539051F9.4030100@gmail.com>
References: <1401903034-20074-1-git-send-email-dianders@chromium.org>
	<1401903034-20074-3-git-send-email-dianders@chromium.org>
	<alpine.DEB.2.10.1406042004140.3319@nanos>
	<CAD=FV=UDAcBeXewVinSG0WeoHkkw2zHe2ORp7BLW=NKxmKUiew@mail.gmail.com>
	<539051F9.4030100@gmail.com>
Date: Thu, 5 Jun 2014 11:21:36 -0700
X-Google-Sender-Auth: mEW0jmhKGkpULrX0rRQuEoQkQhE
Message-ID: <CAD=FV=WYT6gEh9vJjAWxE_zY1m0hojq_5LYL9vKgUzN+7MZ9ow@mail.gmail.com>
Subject: Re: [PATCH 3/3] clocksource: exynos_mct: Optimize register reads with ldmia
From: Doug Anderson <dianders@chromium.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Kukjin Kim <kgene.kim@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Chirantan Ekbote <chirantan@chromium.org>,
        David Riley <davidriley@chromium.org>, Olof Johansson <olof@lixom.net>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz,

On Thu, Jun 5, 2014 at 4:18 AM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> On 04.06.2014 20:49, Doug Anderson wrote:
>> Thomas,
>>
>> On Wed, Jun 4, 2014 at 11:05 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>>> On Wed, 4 Jun 2014, Doug Anderson wrote:
>>>
>>>> As we saw in (clocksource: exynos_mct: cache mct upper count), the
>>>> time spent reading the MCT shows up fairly high in real-world
>>>> profiles.  That means that it's worth some optimization.
>>>>
>>>> We get a roughly 10% speedup in userspace gettimeofday() by using an
>>>> ldmia to read the two halfs of the MCT.  That seems like a worthwhile
>>>> thing to do.
>>>>
>>>> Before: 1173084 us for 1000000 gettimeofday in userspace
>>>> After:  1045674 us for 1000000 gettimeofday in userspace
>>>>
>>>> NOTE: we could actually do better than this if we really wanted to.
>>>> Technically we could register the clocksource as a 32-bit timer and
>>>> only use the "lower" half.  Doing so brings us down to 1014429 us for
>>>> 1000000 gettimeofday in userspace (and doesn't even require assembly
>>>> code).  That would be an alternative to this change.
>>>
>>> I was about to ask exactly that question: What's the advantage of the
>>> 64 bit dance there? AFAICT nothing.
>>
>> I debated whether to send out the 32-bit version, since I'd
>> implemented both.  I'm happy to send out the 32-bit version too and
>> people can pick which they like better.  Let me know.
>>
>> The final thing that pushed me over the edge to send the 64-bit
>> version was that I didn't know enough about how MCT was used with
>> respect to low power modes (we don't use AFTR / LPA modes on our
>> system).  I could actually believe that we might want to set a timer
>> for more than 178 seconds into the future for these low power modes.
>> If that's the case, we still need to keep around the 64-bit read code
>> for that case.  ...and once we have the 64-bit code then we might as
>> well use it for the rest of the timers.
>>
>> Perhaps Tomasz will comment on this.
>
> I can't say definitely that we won't need those extra 32-bits, but the
> low power modes you mentioned are (and probably will always be)
> implemented as CPU idle modes. This means that most likely having a
> wake-up every 178 second wouldn't hurt that much, especially considering
> the fact that in normal use cases, when the system is not fully
> suspended it usually has things to do and will need to be woken up more
> frequently than that.
>
> Adding Bart and Krzysztof to the discussion as they are currently
> working on power management.

OK, I'm happy to send out the 32-bit version of the patches.  In the
other series Vincent was questioning whether the performance gain of
32-bit would be offset by the extra overhead of needing to handle the
wraparound.  I have no idea what the answer is there.  Who on this
thread would be willing to pick between the two?

My own personal opinion is to take the existing optimized 64-bit
versions I sent out since:
* there's no question that they work and won't regress performance or
functionality
* the speed is nearly equal to the 32-bit version
* the single assembly instruction isn't _too_ ugly.


-Doug

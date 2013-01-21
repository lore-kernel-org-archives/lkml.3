Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab3AUXax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 18:30:53 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:59271 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab3AUXav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 18:30:51 -0500
MIME-Version: 1.0
In-Reply-To: <20130121231318.GC23505@n2100.arm.linux.org.uk>
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com>
 <201301212041.17951.arnd@arndb.de> <50FDAC5F.4040605@linaro.org>
 <CAKGA1b=D5CNikijoOAk5xP6TC-nB_gEGtS05ncrPR68sQTMrxw@mail.gmail.com>
 <50FDC2DD.7090406@linaro.org> <CAKGA1bmtTH1N8nx79MGiMighdQROpNtpvAZXhHKT+mT3kcazBQ@mail.gmail.com>
 <20130121231318.GC23505@n2100.arm.linux.org.uk>
From: Matt Sealey <matt@genesi-usa.com>
Date: Mon, 21 Jan 2013 17:30:31 -0600
Message-ID: <CAKGA1b=wDE9ujby_gcoHJudsG=JbWDdNRo+thCe8BhoJLi+B5Q@mail.gmail.com>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 5:13 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Jan 21, 2013 at 04:54:31PM -0600, Matt Sealey wrote:
>> Hmm, I think it might be appreciated for people looking at this stuff
>> (same as I stumbled into it) for a little comment on WHY the default
>> is 200. That way you don't wonder even if you know why EBSA110 has a
>> HZ=200 default, why Exynos is lumped in there too (to reduce the
>> number of interrupts firing?
>
> Err, _reduce_ ?
>
> Can you please explain why changing HZ from 100 to 200 is a reduction?

We were talking about HZ=1000 at the time, sorry...

>> Maybe the Exynos timer interrupt is kind
>> of a horrid core NMI kind of thing and it's desirable for it not to be
>> every millisecond,
>
> Huh?  HZ=100 is centisecond intervals...

See above..

> I think you're understanding is just waaaayyyyy off.  That default is
> there because that is the _architecture_ _default_ and there _has_ to
> be a default.  No, including kernel/Kconfig.hz won't give us any kind
> of non-specified default because, as I've already said in one of my
> other mails, you can't supplement Kconfig symbol definitions by
> declaring it multiple times.

Okay, so the real



>> I know where the 60Hz clocksource might come from, the old Amiga
>> platforms have one based on the PSU frequency (50Hz in Europe, 60Hz
>> US/Japan). Even a 60Hz clocksource is useful though (on the Amiga, at
>> least, it is precisely the vsync clock for synchronizing your display
>> output on TV-out, which makes it completely useful for the framebuffer
>> driver), but.. you just won't expect to assign it as sched_clock or
>> your delay timer. And if anyone does I'd expect they'd know full well
>> it'd not run so well.
>
> Except in the UK where it'd be 50Hz for the TV out.  (Lengthy irrelevant
> explanation why this is so for UK cut.)

Read again: "50Hz in Europe".

Australia too. I'm British and I used to have more EU-manufactured
Amigas than I knew what to do with.. so.. just like your NTP story, I
definitely know this already.

>> >From that description, we are booting with standard HZ on ARM, and the
>> core sched_clock (as in we can call setup_sched_clock)
>> and/or/both/optionally using a real delay_timer switch to HRT mode if
>> we have the right equipment available in the kernel and at runtime on
>> the SoC.. but the process scheduler isn't compiled with the means to
>> actually take advantage of us being in HRT mode?
>
> Don't mix sched_clock() into this; it has nothing to do with HZ at all.
> You're confusing your apples with your oranges.

Okay..

>> A simple BUILD_BUG_ON and a BUG_ON right after each other in the
>> appropriate clocksource driver solves that.. if there's an insistence
>> on having at least some rope, we can put them in a field and tell them
>> they have to use the moon to actually hang themselves...
>
> No it doesn't - it introduces a whole load of new ways to make the
> kernel build or boot fail for pointless reasons - more failures, more
> regressions.
>
> No thank you.

But it would effectively stop users drinking kool-aid.. if you set
your HZ to something stupid, you don't even get a kernel to build, and
certainly don't get to boot past the first 40 lines of boot messages..
I think most people would rather a build error, or a runtime
unmistakable, unmissable warning than a subtle and almost
imperceptible skew in NTP synchronization, to use your example.

-- 
Matt Sealey <matt@genesi-usa.com>
Product Development Analyst, Genesi USA, Inc.

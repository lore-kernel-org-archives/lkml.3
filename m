Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab3IJUsD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 16:48:03 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:52983 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab3IJUsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 16:48:00 -0400
MIME-Version: 1.0
In-Reply-To: <20130910150419.GA29237@thunk.org>
References: <10005394.BRCyBMYWy3@tauon>
	<20130910150419.GA29237@thunk.org>
Date: Tue, 10 Sep 2013 22:48:00 +0200
X-Google-Sender-Auth: 5lMFYLzzaZfxPKlVdWG74Z5NG1s
Message-ID: <CAMuHMdXcXGpgE5ArcjNU-RgAr52qB8ih_b48jwR=+OqK4RDhFA@mail.gmail.com>
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many architectures
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Stephan Mueller <smueller@chronox.de>,
        LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 5:04 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Sep 10, 2013 at 01:31:41PM +0200, Stephan Mueller wrote:
>> /dev/random uses the get_cycles() function to obtain entropy in addition to jiffies and the event value of hardware events.
>>
>> Typically the high-resolution timer of get_cycles delivers the majority of entropy, because the event value is quite deterministic and jiffies are very coarse.
>>
>> However, on the following architectures, get_cycles will return 0....
>
> I am working on this issue with the MIPS maintainers, and on all of
> the platforms where we have some kind of counter which is derived from
> the CPU cycle clock, we should use it.  So for example there is a
> register on MIPS which is incremented on every single clock cycle mod
> the number of entries in the TLB.  This isn't sufficient for
> get_cycles() in general, but what I am thinking about doing is
> defining interface random_get_fast_cycles() which can be get_cycles()
> on those platforms that have such an interface, but on platforms that
> don't we can try to do something else.
>
>> The following patch uses the clocksource clock for a time value in
>> case get_cycles returns 0. As clocksource may not be available
>> during boot time, a flag is introduced which allows random.c to
>> check the availability of clocksource.
>
> I'm a bit concerned about doing things this way because reading the
> clocksource clock might be quite heavyweight, and we need something
> which is very low overhead, since we call get_cycles() on every single
> interrupt.  If reading fom the clocksource clock is the equivalent of
> a L3 cache miss (or worse) doing this on every single interrupt could
> be highly problematic.  So I think we will need to implement a
> random_get_fast_cycles() for each platform for which get_cycles() is
> not available.  In some cases we may be able to use the local clock
> source (if that's the best we can do), but in others, that may not be
> appropriate at all.

Good to know it's called from every interrupt.

So the first importance for random_get_fast_cycles() is that it needs to
be fast. What's most important next: number of bits or high-frequency?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

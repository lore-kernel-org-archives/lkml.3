Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab3AVB4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 20:56:30 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44611 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab3AVB43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 20:56:29 -0500
MIME-Version: 1.0
In-Reply-To: <20130122011808.GF23505@n2100.arm.linux.org.uk>
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com>
 <201301212041.17951.arnd@arndb.de> <50FDAC5F.4040605@linaro.org>
 <CAKGA1b=D5CNikijoOAk5xP6TC-nB_gEGtS05ncrPR68sQTMrxw@mail.gmail.com>
 <50FDC2DD.7090406@linaro.org> <CAKGA1bmtTH1N8nx79MGiMighdQROpNtpvAZXhHKT+mT3kcazBQ@mail.gmail.com>
 <50FDE2AE.8030608@linaro.org> <CAKGA1bkXx2qn+c6sKqXsty-aFe1r-W79uyem0O8p6JNeeq6zxQ@mail.gmail.com>
 <20130122011808.GF23505@n2100.arm.linux.org.uk>
From: Matt Sealey <matt@genesi-usa.com>
Date: Mon, 21 Jan 2013 19:56:08 -0600
Message-ID: <CAKGA1bmXU-sGKPTvRXPmPXwzBOety=0DkSK8cp9RXLNHdNFB+Q@mail.gmail.com>
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

On Mon, Jan 21, 2013 at 7:18 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Jan 21, 2013 at 07:06:59PM -0600, Matt Sealey wrote:
>> On Mon, Jan 21, 2013 at 6:51 PM, John Stultz <john.stultz@linaro.org> wrote:
>> > On 01/21/2013 02:54 PM, Matt Sealey wrote:
>
> sched_clock() has nothing to do with time keeping, and that
> HZ/NO_HZ/HRTIMERS don't affect it (when it isn't being derived from
> jiffies).
>
> Now, sched_clock() is there to give the scheduler a _fast_ to access,
> higher resolution clock than is available from other sources, so that
> there's ways of accurately measuring the amount of time processes run
> for,

That depends on what you meant by timekeeping, right?

I'm really not concerned about the wallclock time, more about the
accuracy of the scheduler clock (tick?), preemption, accurate delays
(i.e. if I msleep(10) does it delay for 10ms or for 40ms because my
delay timer is inaccurate? I'd rather it was better but closer to
10ms), and whether the scheduler (the thing that tells my userspace
whether firefox is running now, or totem, or any other task) is using
the correct high resolution periodic, oneshot, repeatable (however it
repeats) timers *properly* given that this magic config item is
missing on ARM.

That magic config item being CONFIG_SCHED_HRTICK which is referenced a
bunch in kernel/sched/*.[ch] but *ONLY* defined as a Kconfig item in
kernel/Kconfig.hz.

Do we need to copy that Kconfig item out to arch/arm/Kconfig, that's
the question?

>  and other such measurements - and it uses that to determine how
> to schedule a particular task and when to preempt it.
>
> Not providing it means you get those measurements at HZ-based resolution,
> which is suboptimal for tasks which run often for sub-HZ periods (which
> can end up accumulating zero run time.)

Okay, and John said earlier:

John Stultz:
> So I'm actually not super familiar with SCHED_HRTICK details, but from my
> brief skim of it it looks like its useful for turning off the periodic timer
> tick, and allowing the scheduler tick to be triggered by an hrtimer itself
> (There's a number of these interesting inversions that go on in switching to
> HRT mode - for instance, standard timer ticks are switched to being hrtimer
> events themselves).
>
> This likely has the benefit of time-accurate preemption (well, long term, as
> if the timer granularity isn't matching you could be delayed up to a tick -
> but it wouldn't drift).
>
> I'm guessing Thomas would probably know best what the potential issues would
> be from running ((CONFIG_HRTIMER  || CONFIG_NO_HZ) && !CONFIG_SCHED_HRTICK).

If SCHED_HRTICK isn't enabled but setup_sched_clock has been given an
accessor for a real, hardware, fast, high resolution counter that
meets all the needs of sched_clock, what's going on? If it's enabled,
what extra is it doing that, say, my_plat_read_sched_clock doesn't?

--
Matt Sealey <matt@genesi-usa.com>
Product Development Analyst, Genesi USA, Inc.

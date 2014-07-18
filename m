Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946026AbaGRTZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 15:25:50 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:60159 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377AbaGRTZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 15:25:49 -0400
MIME-Version: 1.0
In-Reply-To: <20140718191338.GF3935@laptop>
References: <1405705419-4194-1-git-send-email-pawel.moll@arm.com>
	<20140718191338.GF3935@laptop>
Date: Fri, 18 Jul 2014 12:25:48 -0700
Message-ID: <CALAqxLX4ia_dBO-oNY1XMnSrJdDZc87EneHj9WcxtOZaupZaCg@mail.gmail.com>
Subject: Re: [RFC] sched_clock: Track monotonic raw clock
From: John Stultz <john.stultz@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Pawel Moll <pawel.moll@arm.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Baruch Siach <baruch@tkos.co.il>,
        Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 12:13 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Jul 18, 2014 at 06:43:39PM +0100, Pawel Moll wrote:
>> This change is trying to make the sched clock "similar" to the
>> monotonic raw one.
>>
>> The main goal is to provide some kind of unification between time
>> flow in kernel and in user space, mainly to achieve correlation
>> between perf timestamps and clock_gettime(CLOCK_MONOTONIC_RAW).
>> This has been suggested by Ingo and John during the latest
>> discussion (of many, we tried custom ioctl, custom clock etc.)
>> about this:
>>
>> http://thread.gmane.org/gmane.linux.kernel/1611683/focus=1612554
>>
>> For now I focused on the generic sched clock implementation,
>> but similar approach can be applied elsewhere.
>>
>> Initially I just wanted to copy epoch from monotonic to sched
>> clock at update_clock(), but this can cause the sched clock
>> going backwards in certain corner cases, eg. when the sched
>> clock "increases faster" than the monotonic one. I believe
>> it's a killer issue, but feel free to ridicule me if I worry
>> too much :-)
>
> But on hardware using generic sched_clock we use the exact same hardware
> as the regular timekeeping, right?

Probably most likely, but not necessarily (one can register a
clocksource for sched_clock and then userspace could switch to a
different clocksource for timekeeping).

Also, assuming we someday will merge the x86 sched_clock logic into
the generic sched_clock code, we'll have to handle cases where they
aren't the same.

> So we could start off with the same offset/mult/shift and never deviate,
> or is that a silly question?, I've never really looked at the generic
> sched_clock stuff too closely.

Ideally I'd like to remove the mult/shift pari from clocksources all
together and allow the subsystems that use them to keep their own
mult/shift pair. Mostly because the fine frequency tuning tradeoffs we
want for timekeeping are different from the long-running intervals
without mult overflow we want for sched_clock.

With Thomas' change recently to get the cycle_last bit moved out of
the clocksource structure, we should be fairly close to doing this.

thanks
-john

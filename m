Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414Ab3BVTBo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 14:01:44 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:55474 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab3BVTBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 14:01:42 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 0/2] cpustat: use atomic operations to read/update stats
References: <1361512604-2720-1-git-send-email-khilman@linaro.org>
	<1361522767.26780.44.camel@laptop>
	<20130222125019.GC17948@somewhere.redhat.com>
	<1361542150.26780.64.camel@laptop>
	<1361542891.3683.6.camel@edumazet-glaptop>
	<20130222142302.GC18149@somewhere.redhat.com>
Date: Fri, 22 Feb 2013 11:01:39 -0800
In-Reply-To: <20130222142302.GC18149@somewhere.redhat.com> (Frederic
	Weisbecker's message of "Fri, 22 Feb 2013 15:23:05 +0100")
Message-ID: <87y5egyxyk.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> writes:

> On Fri, Feb 22, 2013 at 06:21:31AM -0800, Eric Dumazet wrote:
>> On Fri, 2013-02-22 at 15:09 +0100, Peter Zijlstra wrote:
>> > On Fri, 2013-02-22 at 13:50 +0100, Frederic Weisbecker wrote:
>> > > > Argh!! at what cost? 64bit atomics are like expensive. Wouldn't
>> > > adding
>> > > > a seqlock be saner?
>> > > 
>> > > Not sure. This requires a spinlock in the write side which is called
>> > > from
>> > > fast path like the timer interrupt.
>> > 
>> > A single spinlock is _way_ cheaper than a ton of cmpxchg8b()s to update
>> > a few variables.
>> 
>> We also have include/linux/u64_stats_sync.h since 2.6.36
>
> Interesting, we should probably use that instead.

OK, I'll spin a version using the u64_stats interface.

Unfortunately, for 32-bit platforms that have atomic 64-bit loads
stores[1], u64_stats leads to some unnecessary overhead, but I'll look
at possibly optimizing u64_stats for those platforms as a follow-up
patch.

Kevin

[1] ARM >= v6k devices have ldrexd/strexd instructions for 64-bit loads
    stores which are used by the atomic64 accessors on those devices.
    (c.f. arch/arm/include/asm/atomic.h:atomic64_read()

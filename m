Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbaGVQRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:17:25 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:48071 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755382AbaGVQRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:17:23 -0400
Message-ID: <1406045843.25343.71.camel@hornet>
Subject: Re: [RFC] sched_clock: Track monotonic raw clock
From: Pawel Moll <pawel.moll@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: John Stultz <john.stultz@linaro.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Baruch Siach <baruch@tkos.co.il>,
        Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>
Date: Tue, 22 Jul 2014 17:17:23 +0100
In-Reply-To: <20140718224100.GV3588@twins.programming.kicks-ass.net>
References: <1405705419-4194-1-git-send-email-pawel.moll@arm.com>
	 <20140718191338.GF3935@laptop>
	 <CALAqxLX4ia_dBO-oNY1XMnSrJdDZc87EneHj9WcxtOZaupZaCg@mail.gmail.com>
	 <20140718193417.GG3935@laptop> <53C97995.2090500@linaro.org>
	 <20140718202250.GR9918@twins.programming.kicks-ass.net>
	 <20140718224100.GV3588@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-18 at 23:41 +0100, Peter Zijlstra wrote:
> So something that might be usable for all of us would be the
> 'abstracted' control loop.
> 
> So the problem is, given a Set Point (CLOCK_MONOTONIC_RAW), a Process
> Variable (sched_clock) compute a Control Output (multiplier).
> 
> If that were implemented with an interface like:
> 
> 
> struct sched_clock_cl; /* Control Loop state */
> 
> /**
>  * sched_clock_cl_init - intialize the control loop
>  */
> extern void sched_clock_cl_init(struct sched_clock_cl *sccl, u32 mult, u32 shift);
> 
> /**
>  * sched_clock_cl_update - compute a new multiplier for sched_clock
>  * @sccl - pointer to control loop state structure
>  * @sp - current set-point, aka. CLOCK_MONOTONIC_RAW
>  * @pv - current process-variable, aka. sched_clock()
>  */
> extern u32 sched_clock_cl_update(struct sched_clock_cl *sccl, u64 sp, u64 pv);

Yeah, happy to provide this.

> That way I can run one per-cpu and try and keep each individual CPU
> synced up to CLOCK_MONOTONIC_RAW, thereby also providing some inter-cpu
> guarantee (due to max error bounds on the control loop, etc..).
> 
> And you can run a single instance for the generic sched_clock code,
> since that's globally consistent.
> 
> And we'd all still be using the same control loop logic.
> 
> Now, I already mentioned max error bounds, and I've not yet looked at
> your actual control loop, but that is something to keep in mind, we want
> something that's limited.

Indeed. Richard has already expressed concerns that my coefficients
won't work everywhere (as in with different clock rate ratios) and he's
most likely right. My money is on a more advanced, "self-tuning"
solution, where we definitely need an escape condition.

> If we can do this (and I'm fairly sure we can) we can in fact kill some
> rather ugly code.

I'm really glad we're more or less on the same page. Will do some more
research in different conditions. Of course all ideas and suggestions
are more than welcome!

Pawel


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab3LLBtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 20:49:04 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:59139 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751013Ab3LLBtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 20:49:03 -0500
Date: Wed, 11 Dec 2013 20:49:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: Stephane Eranian <eranian@google.com>,
        Josh Triplett <josh@joshtriplett.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Olof Johansson <olof@lixom.net>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, pawel.moll@arm.com
Subject: Re: [RFC PATCH] drivers: char: Add a dynamic clock for the trace
 clock
Message-ID: <20131211204900.76993a7d@gandalf.local.home>
In-Reply-To: <CAPz6YkU6-ccJ8eJwYUgs_Gjo5rYeSh3ftSgd_MzCXRTyzhPiiQ@mail.gmail.com>
References: <1386376451-24593-1-git-send-email-sonnyrao@chromium.org>
	<20131209074933.GA2922@jtriplet-mobl1>
	<CABPqkBTufgMk=iqXM87+psUeLd865QF9tCEVHT6hwT4=TtetfQ@mail.gmail.com>
	<CAPz6YkU6-ccJ8eJwYUgs_Gjo5rYeSh3ftSgd_MzCXRTyzhPiiQ@mail.gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Dec 2013 17:17:30 -0800
Sonny Rao <sonnyrao@chromium.org> wrote:

> On Wed, Dec 11, 2013 at 11:30 AM, Stephane Eranian <eranian@google.com> wrote:
> > Sonny,
> >
> > Your patch has a couple of problems for me:
> >  - requires CONFIG_TRACING
> >
> > You should directly invoke getrawmonotonic()
> >  and inline the code from trace_clock_getres().
> >
> > That's how I managed to compile your kernel module on my system.
> 
> You need the changes in kernel/trace/trace.c which is why it's
> dependent on CONFIG_TRACING.
> If we put those functions elsewhere we could remove that dependency,
> but it sounds like people want to just fix the clock that perf uses so
> that it's exportable and not handle this with something like this
> patch, which is better.

I have no issue moving the trace_clock.c code into lib/ and we can add
a CONFIG_TRACE_CLOCK option that can be set by perf and ftrace.

> 
> Also, we should ensure that perf and ftrace are guaranteed to use the
> same clock, I think it just happens to be the same right now.

ftrace has several clocks that it uses:

o local - basically sched_clock()
o global - something like hpet that is monotonic across CPUs but slower
o counter - a simple atomic counter (no time associated to it)
o uptime - jiffy counter
o perf  - trace_clock, which is what perf uses
o x86_tsc - the raw tsc counter.

# cat /sys/kernel/debug/trace_clock
[local] global counter uptime perf x86-tsc

-- Steve

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432Ab3K3JTG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 04:19:06 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57970 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab3K3JTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 04:19:01 -0500
Date: Sat, 30 Nov 2013 10:18:47 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC][PATCH 5/7] x86: Use latch data structure for cyc2ns
Message-ID: <20131130091847.GF16796@laptop.programming.kicks-ass.net>
References: <20131129173657.252094369@infradead.org>
 <20131129174430.076978392@infradead.org>
 <CALCETrX=XvBP7-RjzCqMAV-3ZtMQY9XqBTOZOG3A85M9vhYwCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrX=XvBP7-RjzCqMAV-3ZtMQY9XqBTOZOG3A85M9vhYwCw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 03:22:45PM -0800, Andy Lutomirski wrote:
> On Fri, Nov 29, 2013 at 9:37 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > Use the 'latch' data structure for cyc2ns.
> >
> > This is a data structure first proposed by me and later named by
> > Mathieu. If anybody's got a better name; do holler.
> 
> That structure must exist in the literature, but I have no idea what
> it's called.  It's a multi-word lock-free atomic (I think -- maybe
> it's just regular) register.  I even published a considerably fancier
> version of much the same thing a few years ago.  :)

Yeah, its a fairly straight fwd thing it has to be named someplace ;-)

> I've occasionally wondered whether it would be possible to make a
> monotonicity-preserving version of this and use it for clock_gettime.
> One approach: have the writer set the time for the update to be a bit
> in the future and have the reader compare the current raw time to the
> cutoff to see which set of frequency/offset to use.  (This requires
> having some kind of bound on how long it takes to update the data
> structures.)
> 
> The advantage: clock_gettime would never block.
> The disadvantage: complicated, potentially nasty to implement, and it
> would get complicated if anyone tried to allow multiple updates in
> rapid succession.

Yes, that way you can chain a number of linear segments in various
slots, but you're indeed right in that it will limit the update
frequency. More slots will give you more room, but eventually you're
limited.

I suppose NTP is the primary updater in that case, does that have a
limit on the updates? All the other updates we can artificially limit,
that shouldn't really matter.

But yeah in my case we pretty much assume the TSC is complete crap and a
little more crap simply doesn't matter.

For the 'stable' tsc on modern machines we never set the frequency and
it doesn't matter anyway.

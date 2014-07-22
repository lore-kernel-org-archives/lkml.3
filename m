Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbaGVTkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 15:40:00 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54525 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757AbaGVTj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 15:39:59 -0400
Date: Tue, 22 Jul 2014 21:39:39 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Baruch Siach <baruch@tkos.co.il>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] sched_clock: Track monotonic raw clock
Message-ID: <20140722193939.GA15507@localhost.localdomain>
References: <1405705419-4194-1-git-send-email-pawel.moll@arm.com>
 <20140719050233.GA4408@netboy>
 <1406045849.25343.72.camel@hornet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406045849.25343.72.camel@hornet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 05:17:29PM +0100, Pawel Moll wrote:
> That approach has been also discussed, last time in the mentioned
> thread:
> 
> http://thread.gmane.org/gmane.linux.kernel/1611683/focus=1612554
> http://thread.gmane.org/gmane.linux.kernel/1611683/focus=1612554
> 
> With both Ingo and John showing preference towards the clock alignment,
> so that's where I looked this time (I've already done custom perf
> ioctls, posix clocks... don't really know how many different ways I've
> tried).

I re-read that thread, and it sounds like Ingo also suggested simply
tracing the system time updates, leaving the correlation to the perf
clock to user space. This is what I mean, too.

John and Ingo said that exporting MONO-RAW would be "ideal", and maybe
it would be (in the sense of easy-to-use), but only if it were always
correct.  However, hacking some half baked servo into the kernel will
fail, at least some of the time.  When it does fail, there is no way
to figure out what happened, because the servo code obliterates the
information in the original time stamps.

So the only reasonable way, IMHO, is to simply provide the needed
information in the traces, and then add some user space code to find
the relationship between the perf clock and the system clock. The
great advantage of this approach is that you don't have to create a
perfect servo from day one. The time stamps can be re-analyzed at any
time after the fact.

And if you are going to use this for clusters, then you really want
the global time and not MONO-RAW. I would suggest using CLOCK_TAI.

Thanks,
Richard

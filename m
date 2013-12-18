Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab3LRVtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:49:36 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:34700 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab3LRVte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:49:34 -0500
Date: Wed, 18 Dec 2013 13:49:30 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Alex Shi <alex.shi@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Stultz <john.stultz@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [RFC PATCH 00/13] nohz: Use sysidle detection to let the
 timekeeper sleep
Message-ID: <20131218214930.GU19211@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
 <52B102BB.1050907@linaro.org>
 <20131218174355.GA19788@localhost.localdomain>
 <52B213D1.1000104@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B213D1.1000104@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121821-0928-0000-0000-000004D393AC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 01:29:53PM -0800, Andy Lutomirski wrote:
> On 12/18/2013 09:43 AM, Frederic Weisbecker wrote:
> > On Wed, Dec 18, 2013 at 10:04:43AM +0800, Alex Shi wrote:
> >> On 12/18/2013 06:51 AM, Frederic Weisbecker wrote:
> >>> So this is what this series brings, more details following:
> >>>
> >>> * Some code, naming and whitespace cleanups
> >>>
> >>> * Allow all CPUs outside the nohz_full range to handle the timekeeping
> >>>   duty, not just CPU 0. Balancing the timekeeping duty should improve
> >>>   powersavings.
> >>
> >> If the system just has one nohz_full cpu running, it will need another
> >> cpu to do timerkeeper job. Then the system roughly needs 2 cpu living.
> >> From powersaving POV, that is not good compare to normal nohz idle.
> > 
> > Sure, but everything has a tradeoff :)
> > 
> > We could theoretically run with the timekeeper purely idle if the other
> > CPU in full dynticks mode runs in userspace for a long while and seldom
> > do syscalls and faults. Timekeeping could be updated on kernel/user
> > boundaries in this case without much impact on performances.
> > 
> > But then there is one strict condition for that: it can't read the timeofday
> > through the vdso but only through a syscall.
> 
> Where's your ambition? :)
> 
> If the vdso timing functions could see that it's been too long since a
> real timekeeping update, they could fall back to a syscall.  Otherwise,
> they could using rdtsc or whatever is in use.

One objection to that approach in the past has been that it injects
avoidable latency into the worker CPUs.  I suppose that you could argue
that the cache misses due to a timekeeping-CPU update are not free, but
then again, the syscall is likely to also incur a few cache misses as
well.

I bet that the timekeeping-CPU approach wins, but it would be cool to
see you prove me wrong.

							Thanx, Paul


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294AbaEJAsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 20:48:52 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:45236 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965AbaEJAst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 20:48:49 -0400
Date: Sat, 10 May 2014 02:48:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>, Tejun Heo <tj@kernel.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        hughd@google.com, viresh.kumar@linaro.org,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: vmstat: On demand vmstat workers V4
Message-ID: <20140510004843.GB32393@localhost.localdomain>
References: <alpine.DEB.2.10.1405081033090.23786@gentwo.org>
 <20140508142903.c2ef166c95d2b8acd0d7ea7d@linux-foundation.org>
 <alpine.DEB.2.02.1405090003120.6261@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1405090949170.11318@gentwo.org>
 <alpine.DEB.2.02.1405091659350.6261@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1405091027040.11318@gentwo.org>
 <alpine.DEB.2.02.1405092358390.6261@ionos.tec.linutronix.de>
 <20140509234745.GB8754@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140509234745.GB8754@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 04:47:45PM -0700, Paul E. McKenney wrote:
> On Sat, May 10, 2014 at 12:57:15AM +0200, Thomas Gleixner wrote:
> If someone decides to make tick_do_timer_cpu non-constant in NO_HZ_FULL
> CPUs, they will break unless/until I make RCU deal with that sort
> of thing, at least for NO_HZ_FULL_SYSIDLE kernels.  ;-)
> 
> > We all know that we can do large scale overhauls in a very controlled
> > way if the need arises. But going for the most complex solution while
> > not knowing whether the least complex solution is feasible at all is
> > outright stupid or beyond.
> > 
> > Unless someone comes up with a reasonable explantion for all of this I
> > put a general NAK on patches which are directed to kernel/time/*
> > 
> > Correction:
> > 
> > I'm taking patches right away which undo any damage which has been
> > applied w/o me noticing because I trusted the responsible developers /
> > maintainers.
> > 
> > Preferrably those patches arrive before my return from LinuxCon Japan.
> 
> I could easily have missed something, but as far as I know, there is
> nothing in the current kernel that allows tick_do_timer_cpu to move in
> NO_HZ_FULL kernels.

Right.

So we agree that housekeeping/timekeeping is going to stay CPU 0 for now.

But I still have the plan to make the timekeeper use the full sysidle
facility in order to adaptively get to dynticks idle.

Reminder for others: in NO_HZ_FULL, the timekeeper (always CPU 0) stays
completely periodic. It can't enter in dynticks idle mode because it
must maintain timekeeping on behalf of full dynticks CPUs. So that's
a power issue.

But Paul has a feature in RCU that lets us know when all CPUs are idle
and the timekeeper can finally sleep. Then when a full nohz CPU wakes
up from idle, it sends an IPI to the timekeeper if needed so the latter
restarts timekeeping maintainance.

It's not complicated to add to the timer code.
Most of the code is already there, in RCU, for a while already.

Are we keeping that direction? 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165AbaGWQCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 12:02:52 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:51584 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756435AbaGWQCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 12:02:50 -0400
Date: Wed, 23 Jul 2014 18:02:40 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH tip/core/rcu] Do not keep timekeeping CPU tick running
 for non-nohz_full= CPUs
Message-ID: <20140723160238.GC23175@localhost.localdomain>
References: <20140719165350.GA18411@linux.vnet.ibm.com>
 <20140719180120.GA20887@localhost.localdomain>
 <20140720114759.GO8690@linux.vnet.ibm.com>
 <20140720221245.GA2138@lerouge>
 <20140721155922.GX8690@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721155922.GX8690@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 08:59:22AM -0700, Paul E. McKenney wrote:
> On Mon, Jul 21, 2014 at 12:12:48AM +0200, Frederic Weisbecker wrote:
> > On Sun, Jul 20, 2014 at 04:47:59AM -0700, Paul E. McKenney wrote:
> > > On Sat, Jul 19, 2014 at 08:01:24PM +0200, Frederic Weisbecker wrote:
> > > > On Sat, Jul 19, 2014 at 09:53:50AM -0700, Paul E. McKenney wrote:
> > > > > If a non-nohz_full= CPU is non-idle, it will have a scheduling-clock
> > > > > interrupt, and therefore doesn't need the timekeeping CPU to keep
> > > > > its scheduling-clock interrupt going.  This commit therefore ignores
> > > > > the idle state of non-nohz_full CPUs when determining whether or not
> > > > > the timekeeping CPU can safely turn off its scheduling-clock interrupt.
> > > > > 
> > > > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > 
> > > > Unfortunately that's not how things work. Running a CPU tick doesn't necessarily
> > > > imply to run the timekeeping duty.
> > > > 
> > > > Only the timekeeper can update the timekeeping. There is an exception though:
> > > > the timekeeping is also updated by dynticks idle CPUs when they wake up in an
> > > > interrupt from idle.
> > > > 
> > > > Here is in practice why it doesn't work:
> > > > 
> > > > So lets say CPU 0 is timekeeper, CPU 1 a non-nohz-full CPU and all others are full-nohz.
> > > > CPU 0 is sleeping. CPU 1 wakes up from idle, so it has an uptodate timekeeping but then
> > > > if it continues to execute further without waking up CPU 0, it risks stale timestamps.
> > > > 
> > > > This can be changed by allowing timekeeping duty from all non-nohz_full CPUs, that's
> > > > the initial direction I took, but it involved a lot of complications and scalability
> > > > issues.
> > > 
> > > So we really have to have -all- the CPUs be idle to turn off the timekeeper.
> > > This won't make the battery-powered embedded guys happy...
> > 
> > I can imagine all sorts of solutions to solve this. None of them look simple
> > though. And I'm really convinced this isn't worth until some user comes up
> > and report me that 1) he seriously uses full dynticks and 2) he needs non-full-nohz
> > CPUs other than CPU 0.
> > 
> > If 1 and 2 ever happen, I'll gladly work on this.
> 
> Does the thought of special-casing the situation where CONFIG_NO_HZ_FULL=y,
> CONFIG_NO_HZ_FULL_SYSIDLE=y, and there are no nohz_full= CPUs make sense?

Yes. Distros seem to want to make full dynticks available for users but they
also want the off case (when nohz_full= isn't passed) to keep the lowest overhead
as possible.

So CONFIG_NO_HZ_FULL_SYSIDLE=y should probably do the same as it's expected to be
a default choice as well.

> 
> > > Other thoughts on this?  We really should not be setting
> > > CONFIG_NO_HZ_FULL_SYSIDLE by default until this is solved.
> > 
> > Well it's better to save energy when all CPUs are idle than never.
> 
> Fair point!
> 
> 								Thanx, Paul
> 

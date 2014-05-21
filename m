Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbaEUMDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 08:03:23 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:35664 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbaEUMDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 08:03:21 -0400
Date: Wed, 21 May 2014 05:03:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched/rt: don't try to balance rt_runtime when it is
 futile
Message-ID: <20140521120311.GK4570@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1400123931.5175.38.camel@marge.simpson.net>
 <1400386954.5140.36.camel@marge.simpson.net>
 <20140518052039.GF4570@linux.vnet.ibm.com>
 <1400402201.5166.13.camel@marge.simpson.net>
 <20140518155815.GK4570@linux.vnet.ibm.com>
 <1400467481.5211.48.camel@marge.simpson.net>
 <20140519053401.GP4570@linux.vnet.ibm.com>
 <20140520145350.GC17741@localhost.localdomain>
 <20140520155324.GD4570@linux.vnet.ibm.com>
 <1400645881.5158.35.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400645881.5158.35.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052112-8236-0000-0000-0000027CED7F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 06:18:01AM +0200, Mike Galbraith wrote:
> On Tue, 2014-05-20 at 08:53 -0700, Paul E. McKenney wrote: 
> > On Tue, May 20, 2014 at 04:53:52PM +0200, Frederic Weisbecker wrote:
> > > On Sun, May 18, 2014 at 10:34:01PM -0700, Paul E. McKenney wrote:
> > > > On Mon, May 19, 2014 at 04:44:41AM +0200, Mike Galbraith wrote:
> > > > > On Sun, 2014-05-18 at 08:58 -0700, Paul E. McKenney wrote: 
> > > > > > On Sun, May 18, 2014 at 10:36:41AM +0200, Mike Galbraith wrote:
> > > > > > > On Sat, 2014-05-17 at 22:20 -0700, Paul E. McKenney wrote:
> > > > > > > 
> > > > > > > > If you are saying that turning on nohz_full doesn't help unless you
> > > > > > > > also ensure that there is only one runnable task per CPU, I completely
> > > > > > > > agree.  If you are saying something else, you lost me.  ;-)
> > > > > > > 
> > > > > > > Yup, that's it more or less.  It's not only single task loads that could
> > > > > > > benefit from better isolation, but if isolation improving measures are
> > > > > > > tied to nohz_full, other sensitive loads will suffer if they try to use
> > > > > > > isolation improvements.
> > > > > > 
> > > > > > So you are arguing for a separate Kconfig variable that does the isolation?
> > > > > > So that NO_HZ_FULL selects this new variable, and (for example) RCU
> > > > > > uses this new variable to decide when to pin the grace-period kthreads
> > > > > > onto the housekeeping CPU?
> > > > > 
> > > > > I'm thinking more about runtime, but yes.
> > > > > 
> > > > > The tick mode really wants to be selectable per set (in my boxen you can
> > > > > switch between nohz off/idle, but not yet nohz_full, that might get real
> > > > > interesting).  You saw in my numbers that ticked is far better for the
> > > > > threaded rt load, but what if the total load has both sensitive rt and
> > > > > compute components to worry about?  The rt component wants relief from
> > > > > the jitter that flipping the tick inflicts, but also wants as little
> > > > > disturbance as possible, so RCU offload and whatever other measures that
> > > > > are or become available are perhaps interesting to it as well.  The
> > > > > numbers showed that here and now the two modes can work together in the
> > > > > same box, I can have my rt set ticking away, and other cores doing
> > > > > tickless compute, but enabling that via common config (distros don't
> > > > > want to ship many kernel flavors) has a cost to rt performance.
> > > > > 
> > > > > Ideally, bean counting would be switchable too, giving all components
> > > > > the environment they like best.
> > > > 
> > > > Sounds like a question for Frederic (now CCed).  ;-)
> > > 
> > > I'm not sure that I really understand what you want here.
> > > 
> > > The current state of the art is that when you enable CONFIG_NO_HZ_FULL=y, full dynticks
> > > is actually off by default. This is only overriden by "nohz_full=" boot parameter.
> > 
> > If I understand correctly, if there is no nohz_full= boot parameter,
> > then the context-tracking code takes the early exit via the
> > context_tracking_is_enabled() check in context_tracking_user_enter().
> > I would not expect this to cause much in the way of syscall performance
> > degradation.  However, it looks like having even one CPU in nohz_full
> > mode causes all CPUs to enable context tracking.
> > 
> > My guess is that Mike wants to have (say) half of his CPUs running
> > nohz_full, and the other half having fast system calls.  So my guess
> > also is that he would like some way of having the non-nohz_full CPUs
> > to opt out of the context-tracking overhead, including the memory
> > barriers and atomic ops in rcu_user_enter() and rcu_user_exit().  ;-)
> 
> Bingo.
> 
> > > Now if what you need is to enable or disable it at runtime instead of boottime,
> > > I must warn you that this is going to complicate the nohz code a lot (and also perhaps sched
> > > and RCU).
> > 
> > What Frederic said!  Making RCU deal with this is possible, but a bit on
> > the complicated side.  Given that I haven't heard too many people complaining
> > that RCU is too simple, I would like to opt out of runtime changes to the
> > nohz_full mask.
> > 
> > > I've already been eyed by vulturous frozen sharks flying in circles above me lately
> > > after a few overengineering visions.
> > 
> > Nothing like the icy glare of a frozen shark, is there?  ;-)
> > 
> > > And given that the full nohz code is still in a baby shape, it's probably not the right
> > > time to expand it that way. I haven't even yet heard about users who crossed the testing
> > > stage of full nohz.
> > > 
> > > We'll probably extend it that way in the future. But likely not in a near future.
> > 
> > My guess is that Mike would be OK with making nohz_full choice of CPUs
> > still at boot time, but that he would like the CPUs that are not to be
> > in nohz_full state be able to opt out of the context-tracking overhead.
> > 
> > Mike, please let us all know if I am misunderstanding what you are
> > looking for.
> 
> Yup, exactly.  As it sits, you couldn't possible ship nohz_full out to
> the real world in any other form than a specialty kernel.  There's no
> doubt in my mind that there are users out there who would love to have
> high performance rt and compute in the same box though.  I can imagine
> them lurking here and slobbering profusely ;-)

I think that shipping nohz_full out to the real world is already
happening, but that turning on nohz_full at boot time is expected to
clobber syscall performance globally.

Still, I can see the attraction of avoiding clobbering the syscall
performance on the non-nohz_ful CPUs when nohz_full is enabled on
only some of the CPUs.

							Thanx, Paul


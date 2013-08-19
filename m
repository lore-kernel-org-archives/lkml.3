Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750768Ab3HSDdJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 23:33:09 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:58741 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3HSDdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 23:33:07 -0400
Date: Sun, 18 Aug 2013 20:32:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 6/9] nohz_full: Add full-system idle states
 and variables
Message-ID: <20130819033256.GC29406@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130818014918.GA27827@linux.vnet.ibm.com>
 <1376790584-28120-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1376790584-28120-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130818030920.GI28923@leaf>
 <20130819013924.GA29406@linux.vnet.ibm.com>
 <20130819024914.GA11491@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130819024914.GA11491@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081903-2398-0000-0000-0000019D917C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 18, 2013 at 07:49:14PM -0700, Josh Triplett wrote:
> On Sun, Aug 18, 2013 at 06:39:25PM -0700, Paul E. McKenney wrote:
> > On Sat, Aug 17, 2013 at 08:09:21PM -0700, Josh Triplett wrote:
> > > On Sat, Aug 17, 2013 at 06:49:41PM -0700, Paul E. McKenney wrote:
> > > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > > 
> > > > This commit adds control variables and states for full-system idle.
> > > > The system will progress through the states in numerical order when
> > > > the system is fully idle (other than the timekeeping CPU), and reset
> > > > down to the initial state if any non-timekeeping CPU goes non-idle.
> > > > The current state is kept in full_sysidle_state.
> > > > 
> > > > A RCU_SYSIDLE_SMALL macro is defined, and systems with this number
> > > > of CPUs or fewer move through the states more aggressively.  The idea
> > > > is that the resulting memory contention is less of a problem on small
> > > > systems.  Architectures can adjust this value (which defaults to 8)
> > > > using CONFIG_ARCH_RCU_SYSIDLE_SMALL.
> > > > 
> > > > One flavor of RCU will be in charge of driving the state machine,
> > > > defined by rcu_sysidle_state.  This should be the busiest flavor of RCU.
> > > > 
> > > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > > > Cc: Steven Rostedt <rostedt@goodmis.org>
> > > 
> > > One issue (and one question) below; with the issue addressed,
> > > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > > 
> > > >  kernel/rcutree_plugin.h | 28 ++++++++++++++++++++++++++++
> > > >  1 file changed, 28 insertions(+)
> > > > 
> > > > diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> > > > index eab81da..64a05b9f 100644
> > > > --- a/kernel/rcutree_plugin.h
> > > > +++ b/kernel/rcutree_plugin.h
> > > > @@ -2378,6 +2378,34 @@ static void rcu_kick_nohz_cpu(int cpu)
> > > >  #ifdef CONFIG_NO_HZ_FULL_SYSIDLE
> > > >  
> > > >  /*
> > > > + * Handle small systems specially, accelerating their transition into
> > > > + * full idle state.  Allow arches to override this code's idea of
> > > > + * what constitutes a "small" system.
> > > > + */
> > > > +#ifdef CONFIG_ARCH_RCU_SYSIDLE_SMALL
> > > 
> > > I don't see any Kconfig creating this new config option.
> > > 
> > > Also, why not simply define this config option unconditionally, with a
> > > default of 8, and then use its value directly?
> > 
> > Good point, removing this and adding a Kconfig option in the
> > "nohz_full: Add full-system-idle state machine" commit, with a
> > default value of 8.  Architecture maintainers who want something
> > different can then set that up in their defconfig files.
> 
> Sounds good.
> 
> > > > +static int __maybe_unused full_sysidle_state; /* Current system-idle state. */
> > > > +#define RCU_SYSIDLE_NOT		0	/* Some CPU is not idle. */
> > > > +#define RCU_SYSIDLE_SHORT	1	/* All CPUs idle for brief period. */
> > > > +#define RCU_SYSIDLE_LONG	2	/* All CPUs idle for long enough. */
> > > > +#define RCU_SYSIDLE_FULL	3	/* All CPUs idle, ready for sysidle. */
> > > > +#define RCU_SYSIDLE_FULL_NOTED	4	/* Actually entered sysidle state. */
> > > 
> > > Perhaps there's a kernel style rule I'm not thinking of that makes it
> > > verboten, but: why not use an enum for a state variable like this?
> > 
> > I didn't trust enum interactions with xchg and cmpxchg, so opted for "int"
> > instead.  That said, enum is much more portable than when I last looked
> > at it.  Admittedly, the last time I looked at it was in the early 1980s...
> 
> That would make sense if this was an atomic_t, but it's an int; unless I
> missed something, you don't currently use xchg or cmpxchg on it.

The xchg and cmpxchg show up in the "Add full-system-idle state machine"
commit.  Of course, now I am trying to remember why I used int instead
of atomic_t in this case...  :-/

							Thanx, Paul


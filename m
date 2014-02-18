Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbaBRVaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:30:05 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:42218 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbaBRVaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:30:02 -0500
Date: Tue, 18 Feb 2014 13:29:55 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Torvald Riegel <triegel@redhat.com>
Cc: Peter.Sewell@cl.cam.ac.uk,
        "mark.batty@cl.cam.ac.uk" <Mark.Batty@cl.cam.ac.uk>,
        peterz@infradead.org, torvalds@linux-foundation.org,
        Will Deacon <will.deacon@arm.com>, Ramana.Radhakrishnan@arm.com,
        dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mingo@kernel.org, gcc@gcc.gnu.org
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140218212955.GW4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAHWkzRQSaKOM23yg1LbCO=uWremNzwnXUCUJF2H-+z_Xhmp79g@mail.gmail.com>
 <1392756211.18779.8263.camel@triegel.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392756211.18779.8263.camel@triegel.csb>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021821-0928-0000-0000-00000690875B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 09:43:31PM +0100, Torvald Riegel wrote:
> xagsmtp5.20140218204423.3934@bldgate.vnet.ibm.com
> X-Xagent-Gateway: bldgate.vnet.ibm.com (XAGSMTP5 at BLDGATE)
> 
> On Tue, 2014-02-18 at 12:12 +0000, Peter Sewell wrote:
> > Several of you have said that the standard and compiler should not
> > permit speculative writes of atomics, or (effectively) that the
> > compiler should preserve dependencies.  In simple examples it's easy
> > to see what that means, but in general it's not so clear what the
> > language should guarantee, because dependencies may go via non-atomic
> > code in other compilation units, and we have to consider the extent to
> > which it's desirable to limit optimisation there.
> 
> [...]
> 
> > 2) otherwise, the language definition should prohibit it but the
> >    compiler would have to preserve dependencies even in compilation
> >    units that have no mention of atomics.  It's unclear what the
> >    (runtime and compiler development) cost of that would be in
> >    practice - perhaps Torvald could comment?
> 
> If I'm reading the standard correctly, it requires that data
> dependencies are preserved through loads and stores, including nonatomic
> ones.  That sounds convenient because it allows programmers to use
> temporary storage.
> 
> However, what happens if a dependency "arrives" at a store for which the
> alias set isn't completely known?  Then we either have to add a barrier
> to enforce the ordering at this point, or we have to assume that all
> other potentially aliasing memory locations would also have to start
> carrying dependencies (which might be in other functions in other
> compilation units).  Neither option is good.  The first might introduce
> barriers in places in which they might not be required (or the
> programmer has to use kill_dependency() quite often to avoid all these).
> The second is bad because points-to analysis is hard, so in practice the
> points-to set will not be precisely known for a lot of pointers.  So
> this might not just creep into other functions via calls of
> [[carries_dependency]] functions, but also through normal loads and
> stores, likely prohibiting many optimizations.

I cannot immediately think of a situation where a store carrying a
dependency into a non-trivially aliased object wouldn't be a usage
error, so perhaps emitting a barrier and a diagnostic at that point
is best.

> Furthermore, the dependency tracking can currently only be
> "disabled/enabled" on a function granularity (via
> [[carries_dependency]]).  Thus, if we have big functions, then
> dependency tracking may slow down a lot of code in the big function.  If
> we have small functions, there's a lot of attributes to be added.
> 
> If a function may only carry a dependency but doesn't necessarily (eg,
> depending on input parameters), then the programmer has to make a
> trade-off whether he/she want's to benefit from mo_consume but slow down
> other calls due to additional barriers (ie, when this function is called
> from non-[[carries_dependency]] functions), or vice versa.  (IOW,
> because of the function granularity, other code's performance is
> affected.)
> 
> If a compiler wants to implement dependency tracking just for a few
> constructs (e.g., operators -> + ...) and use barriers otherwise, then
> this decision must be compatible with how all this is handled in other
> compilation units.  Thus, compiler optimizations effectively become part
> of the ABI, which doesn't seem right.
> 
> I hope these examples illustrate my concerns about the implementability
> in practice of this.  It's also why I've suggested to move from an
> opt-out approach as in the current standard (ie, with kill_dependency())
> to an opt-in approach for conservative dependency tracking (e.g., with a
> preserve_dependencies(exp) call, where exp will not be optimized in a
> way that removes any dependencies).  This wouldn't help with many
> optimizations being prevented, but it should at least help programmers
> contain the problem to smaller regions of code.
> 
> I'm not aware of any implementation that tries to track dependencies, so
> I can't give any real performance numbers.  This could perhaps be
> simulated, but I'm not sure whether a realistic case would be made
> without at least supporting [[carries_dependency]] properly in the
> compiler, which would be some work.

Another approach would be to use start-tracking/stop-tracking directives
that could be buried into rcu_read_lock() and rcu_read_unlock().  There
are issues with nesting and conditional use of rcu_read_lock() and
rcu_read_unlock(), but it does give you nicer granularity properties.

							Thanx, Paul


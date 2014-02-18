Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591AbaBRUoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 15:44:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbaBRUoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 15:44:17 -0500
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Torvald Riegel <triegel@redhat.com>
To: Peter.Sewell@cl.cam.ac.uk
Cc: "mark.batty@cl.cam.ac.uk" <Mark.Batty@cl.cam.ac.uk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, peterz@infradead.org,
        torvalds@linux-foundation.org, Will Deacon <will.deacon@arm.com>,
        Ramana.Radhakrishnan@arm.com, dhowells@redhat.com,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@kernel.org, gcc@gcc.gnu.org
In-Reply-To: <CAHWkzRQSaKOM23yg1LbCO=uWremNzwnXUCUJF2H-+z_Xhmp79g@mail.gmail.com>
References: <CAHWkzRQSaKOM23yg1LbCO=uWremNzwnXUCUJF2H-+z_Xhmp79g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Feb 2014 21:43:31 +0100
Message-ID: <1392756211.18779.8263.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-18 at 12:12 +0000, Peter Sewell wrote:
> Several of you have said that the standard and compiler should not
> permit speculative writes of atomics, or (effectively) that the
> compiler should preserve dependencies.  In simple examples it's easy
> to see what that means, but in general it's not so clear what the
> language should guarantee, because dependencies may go via non-atomic
> code in other compilation units, and we have to consider the extent to
> which it's desirable to limit optimisation there.

[...]

> 2) otherwise, the language definition should prohibit it but the
>    compiler would have to preserve dependencies even in compilation
>    units that have no mention of atomics.  It's unclear what the
>    (runtime and compiler development) cost of that would be in
>    practice - perhaps Torvald could comment?

If I'm reading the standard correctly, it requires that data
dependencies are preserved through loads and stores, including nonatomic
ones.  That sounds convenient because it allows programmers to use
temporary storage.

However, what happens if a dependency "arrives" at a store for which the
alias set isn't completely known?  Then we either have to add a barrier
to enforce the ordering at this point, or we have to assume that all
other potentially aliasing memory locations would also have to start
carrying dependencies (which might be in other functions in other
compilation units).  Neither option is good.  The first might introduce
barriers in places in which they might not be required (or the
programmer has to use kill_dependency() quite often to avoid all these).
The second is bad because points-to analysis is hard, so in practice the
points-to set will not be precisely known for a lot of pointers.  So
this might not just creep into other functions via calls of
[[carries_dependency]] functions, but also through normal loads and
stores, likely prohibiting many optimizations.

Furthermore, the dependency tracking can currently only be
"disabled/enabled" on a function granularity (via
[[carries_dependency]]).  Thus, if we have big functions, then
dependency tracking may slow down a lot of code in the big function.  If
we have small functions, there's a lot of attributes to be added.

If a function may only carry a dependency but doesn't necessarily (eg,
depending on input parameters), then the programmer has to make a
trade-off whether he/she want's to benefit from mo_consume but slow down
other calls due to additional barriers (ie, when this function is called
from non-[[carries_dependency]] functions), or vice versa.  (IOW,
because of the function granularity, other code's performance is
affected.)

If a compiler wants to implement dependency tracking just for a few
constructs (e.g., operators -> + ...) and use barriers otherwise, then
this decision must be compatible with how all this is handled in other
compilation units.  Thus, compiler optimizations effectively become part
of the ABI, which doesn't seem right.

I hope these examples illustrate my concerns about the implementability
in practice of this.  It's also why I've suggested to move from an
opt-out approach as in the current standard (ie, with kill_dependency())
to an opt-in approach for conservative dependency tracking (e.g., with a
preserve_dependencies(exp) call, where exp will not be optimized in a
way that removes any dependencies).  This wouldn't help with many
optimizations being prevented, but it should at least help programmers
contain the problem to smaller regions of code.

I'm not aware of any implementation that tries to track dependencies, so
I can't give any real performance numbers.  This could perhaps be
simulated, but I'm not sure whether a realistic case would be made
without at least supporting [[carries_dependency]] properly in the
compiler, which would be some work.


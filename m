Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab3GEOvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 10:51:44 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:56208 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757382Ab3GEOvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 10:51:41 -0400
Date: Fri, 5 Jul 2013 15:51:01 +0100
From: Dave P Martin <Dave.Martin@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Dave Martin <dave.martin@linaro.org>,
        Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: scripts/kallsyms: Avoid ARM veneer symbols
Message-ID: <20130705145100.GE2932@localhost.localdomain>
References: <2983817.Xe2505Drlj@wuerfel>
 <20130625150941.GF2327@linaro.org>
 <201307031803.04501.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201307031803.04501.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 06:03:04PM +0200, Arnd Bergmann wrote:
> On Tuesday 25 June 2013, Dave Martin wrote:
> > On Mon, Jun 24, 2013 at 04:01:43PM +0200, Arnd Bergmann wrote:
> > > When building ARM kernels that exceed a certain size, the linker
> > > will add "veneers" that allow long branches. Unfortunately,
> > > using a longer kallsyms section may lead to the extra veneers
> > > being needed, which leads to inconsistent kallsyms data with the
> > > message
> > > 
> > > Inconsistent kallsyms data
> > > Try make KALLSYMS_EXTRA_PASS=1 as a workaround
> > > 
> > > In some case, not just one but up to three extra passes were
> > > needed before getting to a state that needed no extra veneers.
> > 
> > Do you understand why this was happening?  It sounds like there
> > must have been branches crossing from one side of the kallsyms
> > data to the other, triggering veneer insertion any time the
> > kallsyms data grows.
> > 
> > Branches between .{init,exit}.text and .text (crossing .rodata) seem the
> > likeliest culprits, but that's guesswork on my part.
> 
> kallsyms is part of rodata, which is between .text and .init.text.
> I understand this is intentional, and we already use two passes
> of kallsyms to make sure the size is right. However the assumption
> is that only the data of the kallsyms table changes between runs,
> not the size of it.

I guess sticking the init stuff at the end makes it tidier to
discard without leaving a gap in the middle of the kernel image.
There might be other reasons.

> > If that's whats going on, multiple kallsyms passes is actually a correct
> > approach here: I think they should terminate after a number of steps
> > roughly proportional to log(number of branches across .rodata). We
> > could come up with a heuristic which allows us to choose the right
> > limit with a high degree of reliability, since branch density in
> > compiled C code is likely to be roughly.
> 
> It also seems to be a part of the design to do exactly two passes
> and treat anything beyond that as bugs, doing it the way you

Sure -- I was that making the point the implementation is based on
an assumption that isn't true here.

> suggest would significantly increase the build time since the
> kallsyms+linker stage cannot be done in parallel or sped up
> using ccache.
> 
> > But including the veneer symbols in kallsyms is arguably not all
> > that useful.
> > 
> > The main potential effect is that profiling might occasionally
> > sample the PC as being in a completely bogus function which it
> > never passed through at all, because of the way kallsyms tracks
> > only symbol locations and not sizes (if I remember right) --
> > so a veneer will actually get accounted against some arbitrary
> > adjacent function.
> > 
> > I don't know how much this matters.
> 
> Interesting point. No idea how often that happens. All the veneers
> for one section are in one place though, so we could in theory
> add a kallsyms entry for that section as long as can identify
> it.

We could collapse any contiguous sequence of __veneer_* symbols down
to a single symbol to mark those holes.

However, many kallsyms passes could still be needed: each pass might add
extra veneer blocks, unless the size of kallsyms data is identical to
that in the previous pass.  The expected convergence rate is faster,
though.

> > > The easiest solution is to skip veneers in kallsyms in the
> > > same way we already skip a couple of other symbols.

Your suggestion of omitting the symbols completely seems to be the only
way to ensure convergence in 2 passes, so far as I can see.


Adding size information to every entry in kallsyms would make it possible
to identify the "holes" without potentially requiring many kallsyms passes,
but it would bloat the table.  The extra info would be interesting only
for a tiny subset of the symbols.  I expect people aren't going to like
that much.

So I guess your original suggestion may be the best thing to do for now,
after all...

There is no proper reserved symbol namespace for linker-generated symbols,
so a real symbol could have the name __*_veneer, at which point things
start to get really confusing.  But hopefully that won't happen much.
I don't see any such symbol right now, and hopefully nobody will be so
silly as to add one...

If we eventually need to fix the bogus symbol resolution problem, I can't
see an alternative to adding size info to every symbol.  But we should
leave that for now.  It doesn't sound like a serious problem.

> > The other symbols are not stripped for the purpose of making
> > kallsyms terminate quickly.  The mapping symbols are rather
> > different: masses of symbols with duplicate names which are
> > not very interesting for most people.
> 
> Right.
> 
> > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > > ---
> > > diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
> > > index 487ac6f..53ec0bb 100644
> > > --- a/scripts/kallsyms.c
> > > +++ b/scripts/kallsyms.c
> > > @@ -69,14 +69,32 @@ static void usage(void)
> > >  	exit(1);
> > >  }
> > >  
> > > -/*
> > > - * This ignores the intensely annoying "mapping symbols" found
> > > - * in ARM ELF files: $a, $t and $d.
> > > - */
> > >  static inline int is_arm_mapping_symbol(const char *str)
> > 
> > The function's name is now wrong.  Should it be renamed or split up?
> 
> Sure I can rename it. Any suggestions?

Maybe just something more generic like is_arm_special_symbol()?

Cheers
---Dave

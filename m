Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936Ab3GCQDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 12:03:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59167 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369Ab3GCQDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 12:03:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: scripts/kallsyms: Avoid ARM veneer symbols
Date: Wed, 3 Jul 2013 18:03:04 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Dave Martin <dave.martin@linaro.org>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
References: <2983817.Xe2505Drlj@wuerfel> <20130625150941.GF2327@linaro.org>
In-Reply-To: <20130625150941.GF2327@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307031803.04501.arnd@arndb.de>
X-Provags-ID: V02:K0:5jt5BhsO9WaxeWAb9237xl9v40dj//YVUBwyQV2xlrN
 v1GBgdQ+vuD5OQxUjck2cyWPh9F3yGlR+cSeNdTyqPGXWGA+8Q
 s/SmMDWkUFj7yCXn0SOEGjGXkA3qh2mRj938g6a/lrxJ3tn9d3
 E8ecxUZBsy0eTM9d1woaJf/RAl5dnPiqzvCt46NRdJOW8srtwL
 x3mLc/KAOZO+ckyqv7TKKg4nFEjI64jZyn2IpVan5/5+nNj3Bj
 hh/0P4oe3DlzToKYuidVKRuajbyE/cdySg3TUPPLRpplhjmJAm
 cOd8ncZkdXn2m0X0nlzJTT68uWWjH1fjUkCebymX1o6aC2eGeq
 hyCaIj683NtO3qzrq8hg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 June 2013, Dave Martin wrote:
> On Mon, Jun 24, 2013 at 04:01:43PM +0200, Arnd Bergmann wrote:
> > When building ARM kernels that exceed a certain size, the linker
> > will add "veneers" that allow long branches. Unfortunately,
> > using a longer kallsyms section may lead to the extra veneers
> > being needed, which leads to inconsistent kallsyms data with the
> > message
> > 
> > Inconsistent kallsyms data
> > Try make KALLSYMS_EXTRA_PASS=1 as a workaround
> > 
> > In some case, not just one but up to three extra passes were
> > needed before getting to a state that needed no extra veneers.
> 
> Do you understand why this was happening?  It sounds like there
> must have been branches crossing from one side of the kallsyms
> data to the other, triggering veneer insertion any time the
> kallsyms data grows.
> 
> Branches between .{init,exit}.text and .text (crossing .rodata) seem the
> likeliest culprits, but that's guesswork on my part.

kallsyms is part of rodata, which is between .text and .init.text.
I understand this is intentional, and we already use two passes
of kallsyms to make sure the size is right. However the assumption
is that only the data of the kallsyms table changes between runs,
not the size of it.

> If that's whats going on, multiple kallsyms passes is actually a correct
> approach here: I think they should terminate after a number of steps
> roughly proportional to log(number of branches across .rodata). We
> could come up with a heuristic which allows us to choose the right
> limit with a high degree of reliability, since branch density in
> compiled C code is likely to be roughly.

It also seems to be a part of the design to do exactly two passes
and treat anything beyond that as bugs, doing it the way you
suggest would significantly increase the build time since the
kallsyms+linker stage cannot be done in parallel or sped up
using ccache.

> But including the veneer symbols in kallsyms is arguably not all
> that useful.
> 
> The main potential effect is that profiling might occasionally
> sample the PC as being in a completely bogus function which it
> never passed through at all, because of the way kallsyms tracks
> only symbol locations and not sizes (if I remember right) --
> so a veneer will actually get accounted against some arbitrary
> adjacent function.
> 
> I don't know how much this matters.

Interesting point. No idea how often that happens. All the veneers
for one section are in one place though, so we could in theory
add a kallsyms entry for that section as long as can identify
it.

> > The easiest solution is to skip veneers in kallsyms in the
> > same way we already skip a couple of other symbols.
> 
> The other symbols are not stripped for the purpose of making
> kallsyms terminate quickly.  The mapping symbols are rather
> different: masses of symbols with duplicate names which are
> not very interesting for most people.

Right.

> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> > diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
> > index 487ac6f..53ec0bb 100644
> > --- a/scripts/kallsyms.c
> > +++ b/scripts/kallsyms.c
> > @@ -69,14 +69,32 @@ static void usage(void)
> >  	exit(1);
> >  }
> >  
> > -/*
> > - * This ignores the intensely annoying "mapping symbols" found
> > - * in ARM ELF files: $a, $t and $d.
> > - */
> >  static inline int is_arm_mapping_symbol(const char *str)
> 
> The function's name is now wrong.  Should it be renamed or split up?

Sure I can rename it. Any suggestions?

	Arnd

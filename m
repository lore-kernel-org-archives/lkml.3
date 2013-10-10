Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab3JJMdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 08:33:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032Ab3JJMdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 08:33:13 -0400
Date: Thu, 10 Oct 2013 14:32:36 +0200
From: Jakub Jelinek <jakub@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH, -v2] compiler/gcc4: Add quirk for 'asm goto'
 miscompilation bug
Message-ID: <20131010123236.GH30970@tucnak.zalov.cz>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20131009190231.GI13848@laptop.programming.kicks-ass.net>
 <20131009190851.GX30970@tucnak.zalov.cz>
 <20131010062238.GB9853@gmail.com>
 <20131010065104.GY30970@tucnak.zalov.cz>
 <20131010080457.GC21875@tucnak.zalov.cz>
 <20131010082430.GA20577@gmail.com>
 <20131010083107.GZ30970@tucnak.zalov.cz>
 <20131010084535.GA10620@gmail.com>
 <20131010085506.GA11775@gmail.com>
 <20131010115617.GY28601@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010115617.GY28601@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 01:56:17PM +0200, Peter Zijlstra wrote:
> On Thu, Oct 10, 2013 at 10:55:06AM +0200, Ingo Molnar wrote:
> > +/*
> > + * GCC 'asm goto' miscompiles certain code sequences:
> > + *
> > + *   http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670
> > + *
> > + * Work it around via quirk suggested by Jakub Jelinek.
> > + * Fixed in GCC 4.8.2 and later versions.
> > + */
> > +#if GCC_VERSION <= 40801
> 
> We didn't do version checks for CC_HAVE_ASM_GOTO because of vendor
> backports; can't we detect this in the same way?

The problem is that it will be harder to check for this as compile time only
check, and for runtime check you'd need to have the assembly string for
every architecture and you couldn't do it for cross-compiling anyway.
For compile time only check, it wouldn't be 100% reliable, you could e.g.
check for that using -S -O2 -xc - -o - on:
int
foo (int a, int b)
{
  if (a)
    return -3;
  asm volatile goto ("asm volatile goto to %l[lab]" : : "m" (b) : "memory" : lab);
  return 0;
lab:
  return 0;
}
and use awk on the resulting assembly to find out if the
asm volatile goto to (.*)$
string, then skip lines starting in column 0 with an
assembly comment character(s) (#, %, //, not sure if those 3 are all you can
see) and check that the first non-skipped line starts with the string matching
(.*) earlier followed by : (or perhaps skip other labels too?).
That said, the check could fail even in fixed gccs, so perhaps you want to
combine that with both version check and test, if version is >= 4.8.3
(note, while I hope it will be fixed in 4.8.2 release, people using
prerelease compilers would still have __GNUC_PATCHLEVEL__ == 2, at least
in upstream gcc (e.g. in Fedora/RHEL we patch down the patchlevel version,
so that __GNUC_PATCHLEVEL__ is 2 only for GCC release x.y.2 and following
snapshots, while upstream bumps patchlevel immediately after a release is
made), even with gcc containing that bug.  So for >= 4.8.3 just assume no
workaround is needed, otherwise scan assembly.

> 
> > +# define __asm_goto(vol, x...) do { asm vol goto(x); asm (""); } while (0)
> > +#else
> > +# define __asm_goto(vol, x...) do { asm vol goto(x); } while (0)
> > +#endif
> 
> This places the asm("") in the fallthrough case; but Jakub wrote:
> 
> > @@ -8,6 +8,7 @@ foo (int a, int b)
> >    asm volatile goto ("bts $1, %0; jc %l[lab]" : : "m" (b) : "memory" : lab);
> >    return 0;
> >  lab:
> > +  asm ("");
> >    return 0;
> >  }
> 
> Which places the asm ("") after the label, these two are not the same.

See the follow-up mails, I think placing it immediately after asm goto might
be better.

	Jakub

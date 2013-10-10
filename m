Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab3JJGvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 02:51:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab3JJGvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 02:51:38 -0400
Date: Thu, 10 Oct 2013 08:51:04 +0200
From: Jakub Jelinek <jakub@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [x86] BUG: unable to handle kernel paging request at 00740060
Message-ID: <20131010065104.GY30970@tucnak.zalov.cz>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20131008143400.GA14721@redhat.com>
 <20131009080459.GA2298@localhost>
 <20131009124310.GA11769@redhat.com>
 <20131009140734.GH3081@twins.programming.kicks-ass.net>
 <20131009143359.GU26785@twins.programming.kicks-ass.net>
 <20131009144656.GV26785@twins.programming.kicks-ass.net>
 <20131009181613.GW30970@tucnak.zalov.cz>
 <20131009190231.GI13848@laptop.programming.kicks-ass.net>
 <20131009190851.GX30970@tucnak.zalov.cz>
 <20131010062238.GB9853@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010062238.GB9853@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 08:22:38AM +0200, Ingo Molnar wrote:
> > On Wed, Oct 09, 2013 at 09:02:31PM +0200, Peter Zijlstra wrote:
> > > On Wed, Oct 09, 2013 at 08:16:13PM +0200, Jakub Jelinek wrote:
> > >
> > > > Confirmed as gcc bug, filed http://gcc.gnu.org/PR58670 Seems all of 
> > > > 4.[6-9] miscompile it.  Will have a look tomorrow unless somebody 
> > > > beats me to it.  But historically, the case where asm goto labels 
> > > > jump to fallthru basic block had numerous problems in the past.
> > > 
> > > That bug lists the component as middle end; this suggests x86_64 would 
> > > be vulnerable too, can you confirm? So far we've only observed the 
> > > wrong code on i386 targets, x86_64 targets appeared correct.
> > 
> > Any target, the testcase in the bugzilla aborts on x86_64 with -O2, and 
> > even say on ppc64 (sure, one would have to rewrite the asm to have it 
> > fail at runtime).
> 
> Please let us know once you know enough about the bug to suggest 
> workarounds. Because it's a nice optimization even extra instruction(s) 
> would be acceptable I suspect: we could perhaps put a NOP into a slowpath, 
> with an (unused) goto to it, or something like that?

IMHO you don't need to put there a nop, I guess asm (""); would be enough,
that will still make sure the label is never in the fallthru basic block
and the whole class of issues with asm goto with labels in the fallthru
bb can't hit.  The disadvantage is that it will generate worse code.

@@ -8,6 +8,7 @@ foo (int a, int b)
   asm volatile goto ("bts $1, %0; jc %l[lab]" : : "m" (b) : "memory" : lab);
   return 0;
 lab:
+  asm ("");
   return 0;
 }

on the testcase from the PR results in something like:
#APP
# 8 "pr58670-1.c" 1
        bts $1, -4(%rsp); jc .L3
# 0 "" 2
#NO_APP
.L5:
        xorl    %eax, %eax
        ret
        .p2align 4,,10
        .p2align 3
.L3:
        xorl    %eax, %eax
        ret
        .p2align 4,,10
        .p2align 3
.L4:
        movl    $-3, %eax
        ret
while code without the extra asm (""); and with a fixed compiler:
#APP
# 6 "pr58670.c" 1
        bts $1, -4(%rsp); jc .L3
# 0 "" 2
#NO_APP
.L3:
        xorl    %eax, %eax
        ret
        .p2align 4,,10
        .p2align 3
.L4:
.L2:
        movl    $-3, %eax
        ret

FYI, list of past compiler issues with asm goto include:
PR54127, PR46226, PR44071, PR52650, PR54455, PR51767.

I hope we get this fixed for 4.8.2, so you could then avoid
these hacks for GCC 4.8.2 and later.

	Jakub

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab3ILLwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 07:52:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43609 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab3ILLwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 07:52:13 -0400
Date: Thu, 12 Sep 2013 13:51:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Peter Anvin <hpa@zytor.com>, Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 0/7] preempt_count rework -v2
Message-ID: <20130912115155.GV31370@twins.programming.kicks-ass.net>
References: <20130910164519.GL31370@twins.programming.kicks-ass.net>
 <CA+55aFz7WtcdkwKEGoqCzmC9HsY0LPK-oVK_oATYhRnbGq=2GA@mail.gmail.com>
 <20130910212509.GA18147@laptop.programming.kicks-ass.net>
 <CA+55aFxsEYQPXnoxNXAeSPEkk3uT8iq-_KJVe2M2qZZbtL=cbA@mail.gmail.com>
 <20130911131323.GQ31370@twins.programming.kicks-ass.net>
 <CA+55aFyxcHvQUe_h8cyQrNbGJ6-G_NQnK9pVenABLjCF-7WMXg@mail.gmail.com>
 <20130911185944.GA1798@laptop.programming.kicks-ass.net>
 <CA+55aFxDbqeFumkVApf-L2pi+FQn06GQqQf4rWkzOC4LF=fn=A@mail.gmail.com>
 <20130912022040.GT31370@twins.programming.kicks-ass.net>
 <CA+55aFwdS5-U8UtjZ8qsKyn7ap05MPXMFeU-GXgU2PE5KrCrHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwdS5-U8UtjZ8qsKyn7ap05MPXMFeU-GXgU2PE5KrCrHg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 07:43:42PM -0700, Linus Torvalds wrote:
> On Wed, Sep 11, 2013 at 7:20 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > I split the thing up into two macros GEN_UNARY_RMWcc and
> > GEN_BINARY_RMWcc which ends up being more readable as well as smaller
> > code overall.
> 
> Yes, that looks like the right abstraction level. Powerful without
> being complicated.

> That said, the very same memory clobber may be what makes this whole
> approach a loss, if it causes gcc to do tons of reloads or other
> random things.

Random things below, not sure why

> For other cases? Who knows.. A lot of the "change and test atomically"
> things have the same containment need, so it might not be a problem.

Right, all atomic ops already contain a memory clobber to go along with
their memory barrier semantics.

So I did a defconfig build without the patch and with the patch and got
a significant size increase:

      text    data     bss   filename
   11173443 1423736 1183744 defconfig-build/vmlinux.before
   11174516 1423736 1183744 defconfig-build/vmlinux.after

I then undid all the bitop conversions that added the extra memory
clobber and got:

   11174204 1423736 1183744 defconfig-build/vmlinux.after

Which is still a significant increase, so I had a look at what GCC
generates, for mm/rmap.c, which uses quite a few atomic_*_and_test(),
functions I got:

   text    data     bss     dec     hex filename
   8675       1      16    8692    21f4 defconfig-build/mm/rmap.o
   8739       1      16    8756    2234 defconfig-build/mm/rmap.o

So the increase is there too, doing a objdump -D on them the first
difference is:

0000000000000660 <do_page_add_anon_rmap>:
     660:	55                   	push   %rbp
     661:	48 89 e5             	mov    %rsp,%rbp
     664:	48 83 ec 20          	sub    $0x20,%rsp
     668:	48 89 5d f0          	mov    %rbx,-0x10(%rbp)
     66c:	4c 89 65 f8          	mov    %r12,-0x8(%rbp)
     670:	48 89 fb             	mov    %rdi,%rbx
     673:	f0 ff 47 18          	lock incl 0x18(%rdi)
     677:	0f 94 c0             	sete   %al
     67a:	84 c0                	test   %al,%al
     67c:	75 12                	jne    690 <do_page_add_anon_rmap+0x30>
     67e:	48 8b 5d f0          	mov    -0x10(%rbp),%rbx
     682:	4c 8b 65 f8          	mov    -0x8(%rbp),%r12
     686:	c9                   	leaveq 

vs.:

0000000000000660 <do_page_add_anon_rmap>:
     660:	55                   	push   %rbp
     661:	48 89 e5             	mov    %rsp,%rbp
     664:	48 83 ec 20          	sub    $0x20,%rsp
     668:	48 89 5d e0          	mov    %rbx,-0x20(%rbp)
     66c:	4c 89 65 e8          	mov    %r12,-0x18(%rbp)
     670:	48 89 fb             	mov    %rdi,%rbx
     673:	4c 89 6d f0          	mov    %r13,-0x10(%rbp)
     677:	4c 89 75 f8          	mov    %r14,-0x8(%rbp)
     67b:	f0 ff 47 18          	lock incl 0x18(%rdi)
     67f:	74 17                	je     698 <do_page_add_anon_rmap+0x38>
     681:	48 8b 5d e0          	mov    -0x20(%rbp),%rbx
     685:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
     689:	4c 8b 6d f0          	mov    -0x10(%rbp),%r13
     68d:	4c 8b 75 f8          	mov    -0x8(%rbp),%r14
     691:	c9                   	leaveq 

For some obscure (to me) reason the new fangled asm goto construct
generates a bunch of extra MOVs.

OTOH the good news is that a kernel with that patch applied does indeed
boot properly on real hardware.

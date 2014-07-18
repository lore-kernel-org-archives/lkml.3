Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761154AbaGRJml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:42:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:46484 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923AbaGRJmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:42:38 -0400
Date: Fri, 18 Jul 2014 11:42:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: Ley Foon Tan <lftan@altera.com>, Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Subject: Re: [PATCH v2 21/29] nios2: Futex operations
In-Reply-To: <17186253.ZJUn1qWK0f@wuerfel>
Message-ID: <alpine.DEB.2.10.1407181140250.24854@nanos>
References: <1405413956-2772-1-git-send-email-lftan@altera.com> <12323898.sHjczXbE7P@wuerfel> <CAFiDJ5-uDPCZha-s2-DrLbHLjezBkLTEjJ0nbnsMocof7kO=1Q@mail.gmail.com> <17186253.ZJUn1qWK0f@wuerfel>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2014, Arnd Bergmann wrote:
> On Friday 18 July 2014 14:07:42 Ley Foon Tan wrote:
> > On Thu, Jul 17, 2014 at 7:07 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > > The get_user/put_user functions really need to be annotated might_fault(),
> > > because that's what they do.
> > >
> > > The whole point of get_user() is to access an unchecked user space
> > > pointer, which  can do a number of things based on what the pointer
> > > points to:
> > >
> > > - access a user space variable that resides in memory
> > > - access a kernel pointer and fail because of the access_ok()
> > >   check
> > > - access a user space pointer that is not mapped and return
> > >   through the __ex_table fixup.
> > > - access a user space pointer that has a valid VMA but not PTE,
> > >   causing a page fault to be resolved.
> > >
> > > It's the last case that breaks here.
> > So, do you mean that we can't use get_user/put_user in futex support?
> > BTW, some architectures like sh,parisc, m68k use get_user in futex
> > function as well.
> > Any recommendation way to support futex if we can't use get_user.
> > Note, nios2 doesn't have atomic instruction.
> > Thanks.
> 
> I looked at it again now and I'm no longer sure about my initial
> interpretation. The way it seems to work is that pagefault_disable()
> turns the case I mentioned into a simple error through the fixup,
> so we return -EFAULT from get_user, and retry the futex from
> futex_wake_op().
> 
> This would however also mean that there is no need for a spinlock
> at all, atomicity is already implied by pagefault_disable() here
> because you are running on a UP kernel and pagefault_disable() also
> means there is no preemption.
> 
> If this understanding is right, we can probably just merge the
> m68k implementation into the asm-generic version, as that does
> exactly that, and just isn't SMP safe. I'm still unsure whether
> I'm missing something here though, as everything else seems to
> do this in assembly, even for non-SMP machines that could use
> the trivial method that m68k has.

For UP relying of pagefault disable should be good enough indeed. I
guess the asm for the other UP stuff results from looking at
architectures or copying from architectures which did this in ASM :)

Thanks,

	tglx

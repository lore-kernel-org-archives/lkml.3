Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab3IZRi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 13:38:57 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:35759 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab3IZRis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 13:38:48 -0400
Date: Thu, 26 Sep 2013 19:38:41 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 0/8] softirq: Consolidation and stack overrun fix v3
Message-ID: <20130926173840.GA26012@localhost.localdomain>
References: <1380212686-25897-1-git-send-email-fweisbec@gmail.com>
 <CA+55aFxwAJLBoZtxwRr=S2GJLvBhcvu7zV3f1TJ+Amasx7bPZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxwAJLBoZtxwRr=S2GJLvBhcvu7zV3f1TJ+Amasx7bPZw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 09:43:38AM -0700, Linus Torvalds wrote:
> On Thu, Sep 26, 2013 at 9:24 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >
> > * Turn __ARCH_IRQ_EXIT_ON_IRQ_STACK old ad-hoc style symbol to proper Kconfig
> > (CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK)
> >
> > * Activates it to powerpc as well.
> >
> > * Fix a bit the changelog of patch 6/8
> 
> 
> Ack on the whole series.
> 
> I guess x86-64 and powerpc no longer care, but for other architectures
> the stack usage issue can be a regression even if I think it's only
> been reported on Power. So I'm assuming we should pull this into 3.12.
> Yes?
> 
> And what about earlier stable kernels? Afaik this was originally
> introduced by commit facd8b80c67a, merged into 3.9. Or was there some
> other trigger? Do we want to just do the "__do_softirq" ->
> "do_softirq()" change for stable?

So there is like an underway proposition inside this patchset: the very first commit
has a stable tag on it. This way it can be merged seperately first for 3.12 and
then backported up to the release that has facd8b80c67a.

Then the rest of the series can go for the next merge window in a seperate tree.

Now that's really just one way among possible others to spread the patchset. Because
the regression fix alone unfortunately comes with a performance penalty.

Now if we compare that performance penalty to what we had prior facd8b80c67a, we
were already calling plain do_softirq() on irq_exit() for all archs that had
__ARCH_IRQ_EXIT_IRQS_DISABLED not defined. Namely only arm, arm64, blackfin, s390
were calling __do_softirq() instead. These archs, especially arm, aren't the least
that being said.

We could also backport the part that consolidates to do_softirq_own_stack() and call
it directly if __ARCH_IRQ_EXIT_IRQS_DISABLED. That restores a bit the facd8b80c67a~
state. But it's a bit invasive for post -rc2.

Now may be somebody has some better scenario in mind.


> 
> "Help us, Obi-wan Weisbecker. You are our only hope"

"To thy heart thou shalt listen, young Linux maintainer. Then the right merge decision
thou wilt take".

> 
>                 Linus

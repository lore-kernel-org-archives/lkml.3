Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486Ab3HTPFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 11:05:13 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:65437 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751111Ab3HTPFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 11:05:12 -0400
Date: Tue, 20 Aug 2013 16:04:25 +0100
From: Will Deacon <will.deacon@arm.com>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Matt Sealey <neko@bakuhatsu.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lior Amsalem <alior@marvell.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 1/3] ARM: Introduce atomic MMIO clear/set
Message-ID: <20130820150425.GA27819@mudshark.cambridge.arm.com>
References: <1376138582-7550-1-git-send-email-ezequiel.garcia@free-electrons.com>
 <1376138582-7550-2-git-send-email-ezequiel.garcia@free-electrons.com>
 <20130812182942.GA28695@mudshark.cambridge.arm.com>
 <20130819165955.GA20522@localhost>
 <CAHCPf3t1Tv_kpkCi2YQrr7+6ujQJy9MhifueO=k6fT=oZuqAwA@mail.gmail.com>
 <20130820145158.GB4889@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820145158.GB4889@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 03:52:00PM +0100, Ezequiel Garcia wrote:
> On Tue, Aug 20, 2013 at 09:32:13AM -0500, Matt Sealey wrote:
> > On Mon, Aug 19, 2013 at 11:59 AM, Ezequiel Garcia
> > <ezequiel.garcia@free-electrons.com> wrote:
> > > On Mon, Aug 12, 2013 at 07:29:42PM +0100, Will Deacon wrote:
> > >> I suggest adding an iowmb after the writel if you really need this ordering
> > >> to be enforced (but this may have a significant performance impact,
> > >> depending on your SoC).
> > >
> > > I don't want to argue with you, given I have zero knowledge about this
> > > ordering issue. However let me ask you a question.
> > >
> > > In arch/arm/include/asm/spinlock.h I'm seeing this comment:
> > >
> > > ""ARMv6 ticket-based spin-locking.
> > > A memory barrier is required after we get a lock, and before we
> > > release it, because V6 CPUs are assumed to have weakly ordered
> > > memory.""
> > >
> > > and also:
> > >
> > > static inline void arch_spin_unlock(arch_spinlock_t *lock)
> > > {
> > >         smp_mb();
> > >         lock->tickets.owner++;
> > >         dsb_sev();
> > > }
> > >
> > > So, knowing this atomic API should work for every ARMv{N}, and not being very
> > > sure what the call to dsb_sev() does. Would you care to explain how the above
> > > is *not* enough to guarantee a memory barrier before the spin unlocking?
> > 
> > arch_spin_[un]lock as an API is not guaranteed to use a barrier before
> > or after doing anything, even if this particular implementation does.

[...]

> Of course. I agree completely.

Well, even if the barrier was guaranteed by the API, it's still not
sufficient to ensure ordering between two different memory types. For
example, on Cortex-A9 with PL310, you would also need to perform an
outer_sync() operation before the unlock.

Will

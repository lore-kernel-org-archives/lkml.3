Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab3HTOwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 10:52:03 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33186 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751544Ab3HTOwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 10:52:00 -0400
Date: Tue, 20 Aug 2013 11:52:00 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Matt Sealey <neko@bakuhatsu.net>
Cc: Will Deacon <will.deacon@arm.com>,
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
Message-ID: <20130820145158.GB4889@localhost>
References: <1376138582-7550-1-git-send-email-ezequiel.garcia@free-electrons.com>
 <1376138582-7550-2-git-send-email-ezequiel.garcia@free-electrons.com>
 <20130812182942.GA28695@mudshark.cambridge.arm.com>
 <20130819165955.GA20522@localhost>
 <CAHCPf3t1Tv_kpkCi2YQrr7+6ujQJy9MhifueO=k6fT=oZuqAwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHCPf3t1Tv_kpkCi2YQrr7+6ujQJy9MhifueO=k6fT=oZuqAwA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 09:32:13AM -0500, Matt Sealey wrote:
> On Mon, Aug 19, 2013 at 11:59 AM, Ezequiel Garcia
> <ezequiel.garcia@free-electrons.com> wrote:
> > On Mon, Aug 12, 2013 at 07:29:42PM +0100, Will Deacon wrote:
> >
> >> This means that you don't have ordering guarantees between the two accesses
> >> outside of the CPU, potentially giving you:
> >>
> >>       spin_lock(&__io_lock);
> >>       spin_unlock(&__io_lock);
> >>       writel((readl(reg) & ~clear) | set, reg);
> >>
> >> which is probably not what you want.
> >>
> >> I suggest adding an iowmb after the writel if you really need this ordering
> >> to be enforced (but this may have a significant performance impact,
> >> depending on your SoC).
> >
> > I don't want to argue with you, given I have zero knowledge about this
> > ordering issue. However let me ask you a question.
> >
> > In arch/arm/include/asm/spinlock.h I'm seeing this comment:
> >
> > ""ARMv6 ticket-based spin-locking.
> > A memory barrier is required after we get a lock, and before we
> > release it, because V6 CPUs are assumed to have weakly ordered
> > memory.""
> >
> > and also:
> >
> > static inline void arch_spin_unlock(arch_spinlock_t *lock)
> > {
> >         smp_mb();
> >         lock->tickets.owner++;
> >         dsb_sev();
> > }
> >
> > So, knowing this atomic API should work for every ARMv{N}, and not being very
> > sure what the call to dsb_sev() does. Would you care to explain how the above
> > is *not* enough to guarantee a memory barrier before the spin unlocking?
> 
> arch_spin_[un]lock as an API is not guaranteed to use a barrier before
> or after doing anything, even if this particular implementation does.
> 
> dsb_sev() is an SMP helper which does a synchronization barrier and
> then sends events to other CPUs which informs them of the unlock. If
> the other CPUs were in WFE state waiting on that spinlock, they can
> now thunder in and attempt to lock it themselves. It's not really
> relevant to the discussion as arch_spin_unlock is not guaranteed to
> perform a barrier before returning.
> 
> On some other architecture there may be ISA additions which make
> locking barrier-less, or on a specific implementation of an ARM
> architecture SoC whereby there may be a bank of "hardware spinlocks"
> available.
> 
> So, in this sense, you shouldn't rely on implementation-specific
> behaviors of a function. If you need to be sure C follows B follows A,
> insert a barrier yourself. Don't expect A to barrier for you just
> because you saw some source code that does it today, as tomorrow it
> may be different. It's not an optimization, just a potential source of
> new bugs if the implementation changes underneath you later.
> 

Of course. I agree completely.

Thanks a lot,
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com

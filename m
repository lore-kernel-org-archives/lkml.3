Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751109Ab3HSQ76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 12:59:58 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56526 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750867Ab3HSQ75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 12:59:57 -0400
Date: Mon, 19 Aug 2013 13:59:56 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lior Amsalem <alior@marvell.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 1/3] ARM: Introduce atomic MMIO clear/set
Message-ID: <20130819165955.GA20522@localhost>
References: <1376138582-7550-1-git-send-email-ezequiel.garcia@free-electrons.com>
 <1376138582-7550-2-git-send-email-ezequiel.garcia@free-electrons.com>
 <20130812182942.GA28695@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130812182942.GA28695@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 07:29:42PM +0100, Will Deacon wrote:
> On Sat, Aug 10, 2013 at 01:43:00PM +0100, Ezequiel Garcia wrote:
> > Some SoC have MMIO regions that are shared across orthogonal
> > subsystems. This commit implements a possible solution for the
> > thread-safe access of such regions through a spinlock-protected API
> > with clear-set semantics.
> > 
> > Concurrent access is protected with a single spinlock for the
> > entire MMIO address space. While this protects shared-registers,
> > it also serializes access to unrelated/unshared registers.
> > 
> > Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> 
> [...]
> 
> > +void atomic_io_clear_set(void __iomem *reg, u32 clear, u32 set)
> > +{
> > +	spin_lock(&__io_lock);
> > +	writel((readl(reg) & ~clear) | set, reg);
> > +	spin_unlock(&__io_lock);
> > +}
> 
> I appreciate that you've lifted this code from a previous driver, but this
> doesn't really make any sense to me. The spin_unlock operation is
> essentially a store to normal, cacheable memory, whilst the writel is an
> __iowmb followed by a store to device memory.
> 
> This means that you don't have ordering guarantees between the two accesses
> outside of the CPU, potentially giving you:
> 
> 	spin_lock(&__io_lock);
> 	spin_unlock(&__io_lock);
> 	writel((readl(reg) & ~clear) | set, reg);
> 
> which is probably not what you want.
> 
> I suggest adding an iowmb after the writel if you really need this ordering
> to be enforced (but this may have a significant performance impact,
> depending on your SoC).
> 

I don't want to argue with you, given I have zero knowledge about this
ordering issue. However let me ask you a question.

In arch/arm/include/asm/spinlock.h I'm seeing this comment:

""ARMv6 ticket-based spin-locking.
A memory barrier is required after we get a lock, and before we
release it, because V6 CPUs are assumed to have weakly ordered
memory.""

and also:

static inline void arch_spin_unlock(arch_spinlock_t *lock)
{
	smp_mb();
	lock->tickets.owner++;
	dsb_sev();
}

So, knowing this atomic API should work for every ARMv{N}, and not being very
sure what the call to dsb_sev() does. Would you care to explain how the above
is *not* enough to guarantee a memory barrier before the spin unlocking?

Thanks!
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com

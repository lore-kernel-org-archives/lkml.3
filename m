Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab3A2LD0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 06:03:26 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:55417 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753993Ab3A2LDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 06:03:24 -0500
Date: Tue, 29 Jan 2013 11:03:12 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Lei Wen <adrian.wenl@gmail.com>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "leiwen@marvell.com" <leiwen@marvell.com>
Subject: Re: [PATCH v3 15/31] arm64: SMP support
Message-ID: <20130129110311.GD25983@arm.com>
References: <CALZhoSTsmmsBgT2CtpC1uN9DQM5NTftA024FsyRitCFhPa7LpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALZhoSTsmmsBgT2CtpC1uN9DQM5NTftA024FsyRitCFhPa7LpQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 02:46:53AM +0000, Lei Wen wrote:
> On Sat, Sep 8, 2012 at 12:26 AM, Catalin Marinas <catalin.marinas@arm.com<mailto:catalin.marinas@arm.com>> wrote:
> > This patch adds SMP initialisation and spinlocks implementation for
> > AArch64. The spinlock support uses the new load-acquire/store-release
> > instructions to avoid explicit barriers. The architecture also specifies
> > that an event is automatically generated when clearing the exclusive
> > monitor state to wake up processors in WFE, so there is no need for an
> > explicit DSB/SEV instruction sequence. The SEVL instruction is used to
> > set the exclusive monitor locally as there is no conditional WFE and a
> > branch is more expensive.
> > 
> > For the SMP booting protocol, see Documentation/arm64/booting.txt.
> > 
> > Signed-off-by: Will Deacon <will.deacon@arm.com<mailto:will.deacon@arm.com>>
> > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com<mailto:marc.zyngier@arm.com>>
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com<mailto:catalin.marinas@arm.com>>
> > Acked-by: Arnd Bergmann <arnd@arndb.de<mailto:arnd@arndb.de>>
> > Acked-by: Tony Lindgren <tony@atomide.com<mailto:tony@atomide.com>>
> > ---
> >  arch/arm64/include/asm/hardirq.h        |    5 +
> >  arch/arm64/include/asm/smp.h            |   69 +++++
> >  arch/arm64/include/asm/spinlock.h       |  202 +++++++++++++
> >  arch/arm64/include/asm/spinlock_types.h |   38 +++
> >  arch/arm64/kernel/smp.c                 |  469 +++++++++++++++++++++++++++++++
> >  5 files changed, 783 insertions(+), 0 deletions(-)
> >  create mode 100644 arch/arm64/include/asm/smp.h
> >  create mode 100644 arch/arm64/include/asm/spinlock.h
> >  create mode 100644 arch/arm64/include/asm/spinlock_types.h
> >  create mode 100644 arch/arm64/kernel/smp.c
> > 
> [snip...]
> > +static inline void arch_spin_lock(arch_spinlock_t *lock)
> > +{
> > +       unsigned int tmp;
> > +
> > +       asm volatile(
> > +       "       sevl\n"
> > +       "1:     wfe\n"
> > +       "2:     ldaxr   %w0, [%1]\n"
> > +       "       cbnz    %w0, 1b\n"
> > +       "       stxr    %w0, %w2, [%1]\n"
> > +       "       cbnz    %w0, 2b\n"
> > +       : "=&r" (tmp)
> > +       : "r" (&lock->lock), "r" (1)
> > +       : "memory");
> 
> Why just put "memory" attribute here is enough for keep lock variable
> being updated around multi-cores? I check the original spinlock we use
> in bit32 machine: arch/arm/include/asm/spinlock.h It actually use
> smp_mb after successfully acquire that lock, so we don't need it for
> arm64? Or if it is true that we don't need it in arm64, could we also
> eliminate the smp_mb usage in arm32?

We need the smp_mb (which is a dmb instruction) on AArch32 (ARMv6/v7
instruction set). For AArch64 we have load-acquire and store-release
instructions (lda*, stl*) which act as half-barriers. In the
arch_spin_lock function above we have a ldaxr which prevents any memory
accesses inside the locked region to be observed before this
instruction. The unlock is done with a stlr instructions which prevents
any memory accesses inside the locked region to be observed after this
instruction.

-- 
Catalin

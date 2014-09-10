Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711AbaIJRic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 13:38:32 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35947 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750734AbaIJRib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 13:38:31 -0400
Date: Wed, 10 Sep 2014 18:38:29 +0100
From: Will Deacon <will.deacon@arm.com>
To: Olof Johansson <olof@lixom.net>
Cc: "behanw@converseincode.com" <behanw@converseincode.com>,
        "anderson@redhat.com" <anderson@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "cl@linux.com" <cl@linux.com>,
        "cov@codeaurora.org" <cov@codeaurora.org>,
        "jays.lee@samsung.com" <jays.lee@samsung.com>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "sandeepa.prabhu@linaro.org" <sandeepa.prabhu@linaro.org>,
        "srivatsa.bhat@linux.vnet.ibm.com" <srivatsa.bhat@linux.vnet.ibm.com>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        "takahiro.akashi@linaro.org" <takahiro.akashi@linaro.org>,
        "Vijaya.Kumar@caviumnetworks.com" <Vijaya.Kumar@caviumnetworks.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "acme@kernel.org" <acme@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Matthew Leach <Matthew.Leach@arm.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH] arm64: LLVMLinux: Fix inline arm64 assembly for use with
 clang
Message-ID: <20140910173829.GI1710@arm.com>
References: <1409959460-15989-1-git-send-email-behanw@converseincode.com>
 <20140908093051.GA12657@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140908093051.GA12657@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 10:30:51AM +0100, Olof Johansson wrote:
> On Fri, Sep 05, 2014 at 04:24:20PM -0700, behanw@converseincode.com wrote:
> > From: Mark Charlebois <charlebm@gmail.com>
> > 
> > Fix variable types for 64-bit inline assembly.
> > 
> > This patch now works with both gcc and clang.
> > 
> > Signed-off-by: Mark Charlebois <charlebm@gmail.com>
> > Signed-off-by: Behan Webster <behanw@converseincode.com>
> > ---
> >  arch/arm64/include/asm/arch_timer.h | 26 +++++++++++++++-----------
> >  arch/arm64/include/asm/uaccess.h    |  2 +-
> >  arch/arm64/kernel/debug-monitors.c  |  8 ++++----
> >  arch/arm64/kernel/perf_event.c      | 34 +++++++++++++++++-----------------
> >  arch/arm64/mm/mmu.c                 |  2 +-
> >  5 files changed, 38 insertions(+), 34 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
> > index 9400596..c1f87e0 100644
> > --- a/arch/arm64/include/asm/arch_timer.h
> > +++ b/arch/arm64/include/asm/arch_timer.h
> > @@ -37,19 +37,23 @@ void arch_timer_reg_write_cp15(int access, enum arch_timer_reg reg, u32 val)
> >  	if (access == ARCH_TIMER_PHYS_ACCESS) {
> >  		switch (reg) {
> >  		case ARCH_TIMER_REG_CTRL:
> > -			asm volatile("msr cntp_ctl_el0,  %0" : : "r" (val));
> > +			asm volatile("msr cntp_ctl_el0,  %0"
> > +				: : "r" ((u64)val));
> 
> Ick. Care to elaborate in the patch description why this is needed with
> LLVM? It's really messy and very annoying having to cast register values
> every time they're passed in, instead of the compiler handling it for you.
> 
> Is there a way to catch this with GCC? If not, I expect you to get broken
> all the time on this by people who don't notice.

Question to the clang people (Clangers?): what happens if the %0 above is
rewritten as %x0 and the cast on val is dropped? I could stomach a change
adding that, but it's still likely to regress without regular build testing.

Will

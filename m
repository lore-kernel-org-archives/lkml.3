Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbaAUMJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 07:09:21 -0500
Received: from smtp.citrix.com ([66.165.176.89]:10603 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477AbaAUMJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 07:09:19 -0500
X-IronPort-AV: E=Sophos;i="4.95,696,1384300800"; 
   d="scan'208";a="94836649"
Date: Tue, 21 Jan 2014 12:08:02 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Will Deacon <will.deacon@arm.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "gang.chen@asianux.com" <gang.chen@asianux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jaccon.bastiaansen@gmail.com" <jaccon.bastiaansen@gmail.com>
Subject: Re: [PATCH v3] arm: remove !CPU_V6 and !GENERIC_ATOMIC64 build
 dependencies for XEN
In-Reply-To: <20140121110826.GG30706@mudshark.cambridge.arm.com>
Message-ID: <alpine.DEB.2.02.1401211207080.21510@kaball.uk.xensource.com>
References: <1389204023-26912-1-git-send-email-stefano.stabellini@eu.citrix.com> <20140109103004.GB11089@mudshark.cambridge.arm.com> <201401091204.17932.arnd@arndb.de> <alpine.DEB.2.02.1401091247000.21510@kaball.uk.xensource.com> <20140109184251.GL17838@mudshark.cambridge.arm.com>
 <alpine.DEB.2.02.1401161622570.21510@kaball.uk.xensource.com> <20140116193123.GB22105@mudshark.cambridge.arm.com> <alpine.DEB.2.02.1401201523240.21510@kaball.uk.xensource.com> <20140121110826.GG30706@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jan 2014, Will Deacon wrote:
> On Mon, Jan 20, 2014 at 03:32:48PM +0000, Stefano Stabellini wrote:
> > On Thu, 16 Jan 2014, Will Deacon wrote:
> > > For the xchg part, yes, that looks a lot better. I don't like the #undef
> > > CONFIG_CPU_V6 though, can that be rewritten to use __LINUX_ARM_ARCH__?
> > 
> > The problem is that the 1 and 2 byte parameter size cases in __cmpxchg
> > are ifdef'ed CONFIG_CPU_V6 but drivers/xen/grant-table.c needs them.
> > 
> > So we can either undef CONFIG_CPU_V6 in grant-table.c or call a
> > different function.
> > 
> > If I switch from ifdef CONFIG_CPU_V6 to if __LINUX_ARM_ARCH__ > 6 in
> > __cmpxchg, we still have the problem that if __LINUX_ARM_ARCH__ == 6,
> > grant-table.c doesn't compile.
> > 
> > Maybe the approach taken by the other patch for cmpxchg is better, see
> > below.
> 
> Yes, I prefer this approach. Minor comment below.
> 
> > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > index c1f1a7e..ae54ae0 100644
> > --- a/arch/arm/Kconfig
> > +++ b/arch/arm/Kconfig
> > @@ -1881,8 +1881,7 @@ config XEN_DOM0
> >  config XEN
> >  	bool "Xen guest support on ARM (EXPERIMENTAL)"
> >  	depends on ARM && AEABI && OF
> > -	depends on CPU_V7 && !CPU_V6
> > -	depends on !GENERIC_ATOMIC64
> > +	depends on CPU_V7
> >  	select ARM_PSCI
> >  	select SWIOTLB_XEN
> >  	help
> > diff --git a/arch/arm/include/asm/cmpxchg.h b/arch/arm/include/asm/cmpxchg.h
> > index df2fbba..cc8a4a2 100644
> > --- a/arch/arm/include/asm/cmpxchg.h
> > +++ b/arch/arm/include/asm/cmpxchg.h
> > @@ -133,6 +133,44 @@ extern void __bad_cmpxchg(volatile void *ptr, int size);
> >   * cmpxchg only support 32-bits operands on ARMv6.
> >   */
> >  
> > +static inline unsigned long __cmpxchg8(volatile void *ptr, unsigned long old,
> > +				      unsigned long new)
> > +{
> > +	unsigned long oldval, res;
> > +
> > +	do {
> > +		asm volatile("@ __cmpxchg1\n"
> > +		"	ldrexb	%1, [%2]\n"
> > +		"	mov	%0, #0\n"
> > +		"	teq	%1, %3\n"
> > +		"	strexbeq %0, %4, [%2]\n"
> > +			: "=&r" (res), "=&r" (oldval)
> > +			: "r" (ptr), "Ir" (old), "r" (new)
> > +			: "memory", "cc");
> > +	} while (res);
> > +
> > +	return oldval;
> > +}
> > +
> > +static inline unsigned long __cmpxchg16(volatile void *ptr, unsigned long old,
> > +				      unsigned long new)
> > +{
> > +	unsigned long oldval, res;
> > +
> > +	do {
> > +		asm volatile("@ __cmpxchg1\n"
> 
> Can you fix this comment while you're here please?

OK, I'll use @ __cmpxchg16 and @ __cmpxchg8.
I'll resend as a separate patch.

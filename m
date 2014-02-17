Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbaBQMeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 07:34:07 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:36752 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbaBQMeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 07:34:04 -0500
X-IronPort-AV: E=Sophos;i="4.95,860,1384300800"; 
   d="scan'208";a="101402992"
Date: Mon, 17 Feb 2014 12:33:59 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: <linux@arm.linux.org.uk>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "jaccon.bastiaansen@gmail.com" <jaccon.bastiaansen@gmail.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v4] arm: remove !CPU_V6 and !GENERIC_ATOMIC64 build
 dependencies for XEN
In-Reply-To: <20140121180750.GO30706@mudshark.cambridge.arm.com>
Message-ID: <alpine.DEB.2.02.1402171232220.27926@kaball.uk.xensource.com>
References: <1390311864-19119-1-git-send-email-stefano.stabellini@eu.citrix.com> <20140121180750.GO30706@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jan 2014, Will Deacon wrote:
> On Tue, Jan 21, 2014 at 01:44:24PM +0000, Stefano Stabellini wrote:
> > Remove !GENERIC_ATOMIC64 build dependency:
> > - introduce xen_atomic64_xchg
> > - use it to implement xchg_xen_ulong
> > 
> > Remove !CPU_V6 build dependency:
> > - introduce __cmpxchg8 and __cmpxchg16, compiled even ifdef
> >   CONFIG_CPU_V6
> > - implement sync_cmpxchg using __cmpxchg8 and __cmpxchg16
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > CC: arnd@arndb.de
> > CC: linux@arm.linux.org.uk
> > CC: will.deacon@arm.com
> > CC: catalin.marinas@arm.com
> > CC: linux-arm-kernel@lists.infradead.org
> > CC: linux-kernel@vger.kernel.org
> > CC: xen-devel@lists.xenproject.org
> 
>   Reviewed-by: Will Deacon <will.deacon@arm.com>

Russell, are you OK with this patch for 3.15?


> Changes in v4:
> - avoid moving and renaming atomic64_xchg
> - introduce xen_atomic64_xchg
> - fix asm comment in __cmpxchg8 and __cmpxchg16.
> 
> ---
>  arch/arm/Kconfig                   |    3 +-
>  arch/arm/include/asm/cmpxchg.h     |   60 ++++++++++++++++++++++++------------
>  arch/arm/include/asm/sync_bitops.h |   24 ++++++++++++++-
>  arch/arm/include/asm/xen/events.h  |   32 ++++++++++++++++++-
>  4 files changed, 95 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index c1f1a7e..ae54ae0 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1881,8 +1881,7 @@ config XEN_DOM0
>  config XEN
>  	bool "Xen guest support on ARM (EXPERIMENTAL)"
>  	depends on ARM && AEABI && OF
> -	depends on CPU_V7 && !CPU_V6
> -	depends on !GENERIC_ATOMIC64
> +	depends on CPU_V7
>  	select ARM_PSCI
>  	select SWIOTLB_XEN
>  	help
> diff --git a/arch/arm/include/asm/cmpxchg.h b/arch/arm/include/asm/cmpxchg.h
> index df2fbba..a17cff1 100644
> --- a/arch/arm/include/asm/cmpxchg.h
> +++ b/arch/arm/include/asm/cmpxchg.h
> @@ -133,6 +133,44 @@ extern void __bad_cmpxchg(volatile void *ptr, int size);
>   * cmpxchg only support 32-bits operands on ARMv6.
>   */
>  
> +static inline unsigned long __cmpxchg8(volatile void *ptr, unsigned long old,
> +				      unsigned long new)
> +{
> +	unsigned long oldval, res;
> +
> +	do {
> +		asm volatile("@ __cmpxchg8\n"
> +		"	ldrexb	%1, [%2]\n"
> +		"	mov	%0, #0\n"
> +		"	teq	%1, %3\n"
> +		"	strexbeq %0, %4, [%2]\n"
> +			: "=&r" (res), "=&r" (oldval)
> +			: "r" (ptr), "Ir" (old), "r" (new)
> +			: "memory", "cc");
> +	} while (res);
> +
> +	return oldval;
> +}
> +
> +static inline unsigned long __cmpxchg16(volatile void *ptr, unsigned long old,
> +				      unsigned long new)
> +{
> +	unsigned long oldval, res;
> +
> +	do {
> +		asm volatile("@ __cmpxchg16\n"
> +		"	ldrexh	%1, [%2]\n"
> +		"	mov	%0, #0\n"
> +		"	teq	%1, %3\n"
> +		"	strexheq %0, %4, [%2]\n"
> +			: "=&r" (res), "=&r" (oldval)
> +			: "r" (ptr), "Ir" (old), "r" (new)
> +			: "memory", "cc");
> +	} while (res);
> +
> +	return oldval;
> +}
> +
>  static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
>  				      unsigned long new, int size)
>  {
> @@ -141,28 +179,10 @@ static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
>  	switch (size) {
>  #ifndef CONFIG_CPU_V6	/* min ARCH >= ARMv6K */
>  	case 1:
> -		do {
> -			asm volatile("@ __cmpxchg1\n"
> -			"	ldrexb	%1, [%2]\n"
> -			"	mov	%0, #0\n"
> -			"	teq	%1, %3\n"
> -			"	strexbeq %0, %4, [%2]\n"
> -				: "=&r" (res), "=&r" (oldval)
> -				: "r" (ptr), "Ir" (old), "r" (new)
> -				: "memory", "cc");
> -		} while (res);
> +		oldval = __cmpxchg8(ptr, old, new);
>  		break;
>  	case 2:
> -		do {
> -			asm volatile("@ __cmpxchg1\n"
> -			"	ldrexh	%1, [%2]\n"
> -			"	mov	%0, #0\n"
> -			"	teq	%1, %3\n"
> -			"	strexheq %0, %4, [%2]\n"
> -				: "=&r" (res), "=&r" (oldval)
> -				: "r" (ptr), "Ir" (old), "r" (new)
> -				: "memory", "cc");
> -		} while (res);
> +		oldval = __cmpxchg16(ptr, old, new);
>  		break;
>  #endif
>  	case 4:
> diff --git a/arch/arm/include/asm/sync_bitops.h b/arch/arm/include/asm/sync_bitops.h
> index 63479ee..942659a 100644
> --- a/arch/arm/include/asm/sync_bitops.h
> +++ b/arch/arm/include/asm/sync_bitops.h
> @@ -21,7 +21,29 @@
>  #define sync_test_and_clear_bit(nr, p)	_test_and_clear_bit(nr, p)
>  #define sync_test_and_change_bit(nr, p)	_test_and_change_bit(nr, p)
>  #define sync_test_bit(nr, addr)		test_bit(nr, addr)
> -#define sync_cmpxchg			cmpxchg
>  
> +static inline unsigned long sync_cmpxchg(volatile void *ptr,
> +										 unsigned long old,
> +										 unsigned long new)
> +{
> +	unsigned long oldval;
> +	int size = sizeof(*(ptr));
> +
> +	smp_mb();
> +	switch (size) {
> +	case 1:
> +		oldval = __cmpxchg8(ptr, old, new);
> +		break;
> +	case 2:
> +		oldval = __cmpxchg16(ptr, old, new);
> +		break;
> +	default:
> +		oldval = __cmpxchg(ptr, old, new, size);
> +		break;
> +	}
> +	smp_mb();
> +
> +	return oldval;
> +}
>  
>  #endif
> diff --git a/arch/arm/include/asm/xen/events.h b/arch/arm/include/asm/xen/events.h
> index 8b1f37b..2032ee6 100644
> --- a/arch/arm/include/asm/xen/events.h
> +++ b/arch/arm/include/asm/xen/events.h
> @@ -16,7 +16,37 @@ static inline int xen_irqs_disabled(struct pt_regs *regs)
>  	return raw_irqs_disabled_flags(regs->ARM_cpsr);
>  }
>  
> -#define xchg_xen_ulong(ptr, val) atomic64_xchg(container_of((ptr),	\
> +#ifdef CONFIG_GENERIC_ATOMIC64
> +/* if CONFIG_GENERIC_ATOMIC64 is defined we cannot use the generic
> + * atomic64_xchg function because it is implemented using spin locks.
> + * Here we need proper atomic instructions to read and write memory
> + * shared with the hypervisor.
> + */
> +static inline u64 xen_atomic64_xchg(atomic64_t *ptr, u64 new)
> +{
> +	u64 result;
> +	unsigned long tmp;
> +
> +	smp_mb();
> +
> +	__asm__ __volatile__("@ xen_atomic64_xchg\n"
> +"1:	ldrexd	%0, %H0, [%3]\n"
> +"	strexd	%1, %4, %H4, [%3]\n"
> +"	teq	%1, #0\n"
> +"	bne	1b"
> +	: "=&r" (result), "=&r" (tmp), "+Qo" (ptr->counter)
> +	: "r" (&ptr->counter), "r" (new)
> +	: "cc");
> +
> +	smp_mb();
> +
> +	return result;
> +}
> +#else
> +#define xen_atomic64_xchg atomic64_xchg
> +#endif
> +
> +#define xchg_xen_ulong(ptr, val) xen_atomic64_xchg(container_of((ptr),	\
>  							    atomic64_t,	\
>  							    counter), (val))
>  
> -- 
> 1.7.10.4

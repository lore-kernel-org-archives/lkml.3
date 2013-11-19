Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab3KSLyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 06:54:01 -0500
Received: from smtp.citrix.com ([66.165.176.89]:16088 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab3KSLx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 06:53:59 -0500
X-IronPort-AV: E=Sophos;i="4.93,729,1378857600"; 
   d="scan'208";a="75888756"
Message-ID: <528B5153.80607@citrix.com>
Date: Tue, 19 Nov 2013 11:53:55 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Elena Ufimtseva <ufimtseva@gmail.com>
CC: <xen-devel@lists.xenproject.org>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <x86@kernel.org>, <akpm@linux-foundation.org>,
        <tangchen@cn.fujitsu.com>, <wency@cn.fujitsu.com>,
        <ian.campbell@citrix.com>, <stefano.stabellini@eu.citrix.com>,
        <mukesh.rathor@oracle.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND v2 1/2] xen: vnuma support for PV guests running
 as domU
References: <1384811922-14642-1-git-send-email-ufimtseva@gmail.com> <1384811922-14642-2-git-send-email-ufimtseva@gmail.com>
In-Reply-To: <1384811922-14642-2-git-send-email-ufimtseva@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/11/13 21:58, Elena Ufimtseva wrote:
> Issues Xen hypercall subop XENMEM_get_vnumainfo and sets the
> NUMA topology, otherwise sets dummy NUMA node and prevents
> numa_init from calling other numa initializators as they dont
> work with pv guests.
[...]
> --- /dev/null
> +++ b/arch/x86/include/asm/xen/vnuma.h
> @@ -0,0 +1,12 @@
> +#ifndef _ASM_X86_VNUMA_H
> +#define _ASM_X86_VNUMA_H
> +
> +#ifdef CONFIG_XEN
> +bool xen_vnuma_supported(void);
> +int xen_numa_init(void);
> +#else
> +static inline bool xen_vnuma_supported(void) { return false; };
> +static inline int xen_numa_init(void) { return -1; };

Return a valid -ve errno here.  e.g., -ENOSYS.

> +#endif
> +
> +#endif /* _ASM_X86_VNUMA_H */
> diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
> index 24aec58..99efa1b 100644
> --- a/arch/x86/mm/numa.c
> +++ b/arch/x86/mm/numa.c
> @@ -17,6 +17,7 @@
>  #include <asm/dma.h>
>  #include <asm/acpi.h>
>  #include <asm/amd_nb.h>
> +#include "asm/xen/vnuma.h"
>  
>  #include "numa_internal.h"
>  
> @@ -632,6 +633,8 @@ static int __init dummy_numa_init(void)
>  void __init x86_numa_init(void)
>  {
>  	if (!numa_off) {
> +		if (!numa_init(xen_numa_init))
> +			return;
>  #ifdef CONFIG_X86_NUMAQ
>  		if (!numa_init(numaq_numa_init))
>  			return;
> diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
> index 96ab2c0..de9deab 100644
> --- a/arch/x86/xen/Makefile
> +++ b/arch/x86/xen/Makefile
> @@ -13,7 +13,7 @@ CFLAGS_mmu.o			:= $(nostackp)
>  obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
>  			time.o xen-asm.o xen-asm_$(BITS).o \
>  			grant-table.o suspend.o platform-pci-unplug.o \
> -			p2m.o
> +			p2m.o vnuma.o

obj-$(CONFIG_NUMA) += vnuma.o

I commented on this already, please take more care to address all
comments before reposting.

> --- /dev/null
> +++ b/arch/x86/xen/vnuma.c
> @@ -0,0 +1,127 @@
> +#include <linux/err.h>
> +#include <linux/memblock.h>
> +#include <xen/interface/xen.h>
> +#include <xen/interface/memory.h>
> +#include <asm/xen/interface.h>
> +#include <asm/xen/hypercall.h>
> +#include <asm/xen/vnuma.h>
> +
> +#ifdef CONFIG_NUMA
> +
> +/* Checks if hypercall is supported */
> +bool xen_vnuma_supported(void)
> +{
> +	return HYPERVISOR_memory_op(XENMEM_get_vnuma_info, NULL)
> +					== -ENOSYS ? false : true;

return HYPERVISOR_memory_op() != -ENOSYS;

But as I note in the other email, I think this function isn't needed.

> --- a/include/xen/interface/memory.h
> +++ b/include/xen/interface/memory.h
> @@ -263,4 +263,47 @@ struct xen_remove_from_physmap {
>  };
>  DEFINE_GUEST_HANDLE_STRUCT(xen_remove_from_physmap);
>  
> +/* vNUMA structures */
> +struct vmemrange {
> +	uint64_t start, end;
> +	/* reserved */
> +	uint64_t _padm;

If this field is reserved for future use, please name it _reserved and
ensure that the hypervisor checks that it is 0.

> +struct vnuma_topology_info {
> +	/* OUT */
> +	domid_t domid;
> +	uint32_t __pad;
> +	/* IN */
> +	/* number of virtual numa nodes */
> +	union {
> +		GUEST_HANDLE(uint) nr_nodes;
> +		uint64_t    _padn;
> +	};

I don't think anonymous unions are allowed in the ABI.  They're a c99
extension I think.

David

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab3KNLSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 06:18:32 -0500
Received: from smtp.citrix.com ([66.165.176.89]:63096 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778Ab3KNLS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 06:18:29 -0500
X-IronPort-AV: E=Sophos;i="4.93,699,1378857600"; 
   d="scan'208";a="74402865"
Message-ID: <5284B181.4010704@citrix.com>
Date: Thu, 14 Nov 2013 11:18:25 +0000
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
Subject: Re: [PATCH 1/2] xen: vnuma support for PV guests running as domU.
References: <1384400179-24404-1-git-send-email-ufimtseva@gmail.com> <1384400179-24404-2-git-send-email-ufimtseva@gmail.com>
In-Reply-To: <1384400179-24404-2-git-send-email-ufimtseva@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/11/13 03:36, Elena Ufimtseva wrote:
> Issues Xen hypercall subop XENMEM_get_vnumainfo and sets the
> NUMA topology, otherwise sets dummy NUMA node and prevents
> numa_init from calling other numa initializators as they may
> break other guests.

"break other guests" doesn't seem correct to me.  "...which prevents
numa_init() from calling other hardware-specific initializers (which do
not work in PV guests)." reads better I think.

> --- /dev/null
> +++ b/arch/x86/include/asm/xen/vnuma.h
> @@ -0,0 +1,12 @@
> +#ifndef _ASM_X86_VNUMA_H
> +#define _ASM_X86_VNUMA_H
> +
> +#ifdef CONFIG_XEN
> +int xen_vnuma_supported(void);
> +int xen_numa_init(void);
> +#else
> +int xen_vnuma_supported(void) { return 0; };

Return bool.

> +int xen_numa_init(void) { return -1; };

I don't think you need this stub.

> +#endif
> +
> +#endif /* _ASM_X86_VNUMA_H */
> diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
> index 8bf93ba..c8a61dc 100644
> --- a/arch/x86/mm/numa.c
> +++ b/arch/x86/mm/numa.c
> @@ -19,6 +19,7 @@
>  #include <asm/amd_nb.h>

#include <asm/xen/vnuma.h> here..

>  #include "numa_internal.h"
> +#include "asm/xen/vnuma.h"

...not here.

>  int __initdata numa_off;
>  nodemask_t numa_nodes_parsed __initdata;
> @@ -621,6 +622,10 @@ static int __init dummy_numa_init(void)
>  void __init x86_numa_init(void)
>  {
>  	if (!numa_off) {
> +#ifdef CONFIG_XEN
> +		if (xen_vnuma_supported() && !numa_init(xen_numa_init))
> +			return;
> +#endif

I would put the xen_vnuma_supported() call into xen_numa_init().

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

Then you can remove the #ifdef CONFIG_NUMA from xen/vnuma.c

> --- a/include/xen/interface/memory.h
> +++ b/include/xen/interface/memory.h
> @@ -263,4 +263,32 @@ struct xen_remove_from_physmap {
>  };
>  DEFINE_GUEST_HANDLE_STRUCT(xen_remove_from_physmap);
>  
> +/* vNUMA structures */
> +struct vmemrange {
> +	uint64_t start, end;
> +	struct vmemrange *next;

A pointer in a ABI structure looks wrong.

> +};
> +DEFINE_GUEST_HANDLE_STRUCT(vmemrange);
> +
> +struct vnuma_topology_info {
> +	/* OUT */
> +	domid_t domid;
> +	uint32_t __pad;
> +	/* IN */
> +	GUEST_HANDLE(uint) nr_nodes; /* number of virtual numa nodes */
> +	/* distance table */
> +	GUEST_HANDLE(uint) vdistance;
> +	/* cpu mapping to vnodes */
> +	GUEST_HANDLE(uint) cpu_to_node;
> +	/*
> +	* array of numa memory areas constructed by Xen
> +	* where start and end are pfn numbers of the area
> +	* Xen takes into account domains e820 map
> +	*/
> +	GUEST_HANDLE(vmemrange) vmemblks;
> +};

The structure has different size on 32-bit and 64-bit x86 guests.  Is
this intentional?  The __pad field suggests not.

David

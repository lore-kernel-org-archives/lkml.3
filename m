Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbaLWLBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 06:01:20 -0500
Received: from smtp.citrix.com ([66.165.176.89]:29689 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709AbaLWLBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 06:01:18 -0500
X-IronPort-AV: E=Sophos;i="5.07,631,1413244800"; 
   d="scan'208";a="207333193"
Message-ID: <54994B7B.20309@citrix.com>
Date: Tue, 23 Dec 2014 11:01:15 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>, David Vrabel <david.vrabel@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: xen-devel <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] xen/x86: properly retrieve NMI reason
References: <54945D760200007800051157@mail.emea.novell.com>
In-Reply-To: <54945D760200007800051157@mail.emea.novell.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/12/14 16:16, Jan Beulich wrote:
> Using the native code here can't work properly, as the hypervisor would
> normally have cleared the two reason bits by the time Dom0 gets to see
> the NMI (if passed to it at all). There's a shared info field for this,
> and there's an existing hook to use - just fit the two together. Note
> that the hook can (and should) be used irrespective of whether being in
> Dom0, as accessing port 0x61 in a DomU would be even worse, while the
> shared info field would just hold zero all the time.

What's the user visible impact of this fix?

David

> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> ---
>  arch/x86/xen/enlighten.c    |   22 +++++++++++++++++-
>  include/xen/interface/nmi.h |   52 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 73 insertions(+), 1 deletion(-)
> 
> --- 3.18/arch/x86/xen/enlighten.c
> +++ 3.18-xen-x86-NMI-reason/arch/x86/xen/enlighten.c
> @@ -40,6 +40,7 @@
>  #include <xen/interface/physdev.h>
>  #include <xen/interface/vcpu.h>
>  #include <xen/interface/memory.h>
> +#include <xen/interface/nmi.h>
>  #include <xen/interface/xen-mca.h>
>  #include <xen/features.h>
>  #include <xen/page.h>
> @@ -66,6 +67,7 @@
>  #include <asm/reboot.h>
>  #include <asm/stackprotector.h>
>  #include <asm/hypervisor.h>
> +#include <asm/mach_traps.h>
>  #include <asm/mwait.h>
>  #include <asm/pci_x86.h>
>  #include <asm/pat.h>
> @@ -1357,6 +1359,21 @@ static const struct machine_ops xen_mach
>  	.emergency_restart = xen_emergency_restart,
>  };
>  
> +static unsigned char xen_get_nmi_reason(void)
> +{
> +	unsigned char reason = 0;
> +
> +	/* Construct a value which looks like it came from port 0x61. */
> +	if (test_bit(_XEN_NMIREASON_io_error,
> +		     &HYPERVISOR_shared_info->arch.nmi_reason))
> +		reason |= NMI_REASON_IOCHK;
> +	if (test_bit(_XEN_NMIREASON_pci_serr,
> +		     &HYPERVISOR_shared_info->arch.nmi_reason))
> +		reason |= NMI_REASON_SERR;
> +
> +	return reason;
> +}
> +
>  static void __init xen_boot_params_init_edd(void)
>  {
>  #if IS_ENABLED(CONFIG_EDD)
> @@ -1541,9 +1558,12 @@ asmlinkage __visible void __init xen_sta
>  	pv_info = xen_info;
>  	pv_init_ops = xen_init_ops;
>  	pv_apic_ops = xen_apic_ops;
> -	if (!xen_pvh_domain())
> +	if (!xen_pvh_domain()) {
>  		pv_cpu_ops = xen_cpu_ops;
>  
> +		x86_platform.get_nmi_reason = xen_get_nmi_reason;
> +	}
> +
>  	if (xen_feature(XENFEAT_auto_translated_physmap))
>  		x86_init.resources.memory_setup = xen_auto_xlated_memory_setup;
>  	else
> --- /usr/local/src/linux-3.18/include/xen/interface/nmi.h	1970-01-01 01:00:00.000000000 +0100
> +++ 3.18-xen-x86-NMI-reason/include/xen/interface/nmi.h
> @@ -0,0 +1,52 @@
> +/******************************************************************************
> + * nmi.h
> + * 
> + * NMI callback registration and reason codes.
> + * 
> + * Copyright (c) 2005, Keir Fraser <keir@xensource.com>
> + */
> +
> +#ifndef __XEN_PUBLIC_NMI_H__
> +#define __XEN_PUBLIC_NMI_H__
> +
> +#include <xen/interface/xen.h>
> +
> +/*
> + * NMI reason codes:
> + * Currently these are x86-specific, stored in arch_shared_info.nmi_reason.
> + */
> + /* I/O-check error reported via ISA port 0x61, bit 6. */
> +#define _XEN_NMIREASON_io_error     0
> +#define XEN_NMIREASON_io_error      (1UL << _XEN_NMIREASON_io_error)
> + /* PCI SERR reported via ISA port 0x61, bit 7. */
> +#define _XEN_NMIREASON_pci_serr     1
> +#define XEN_NMIREASON_pci_serr      (1UL << _XEN_NMIREASON_pci_serr)
> + /* Unknown hardware-generated NMI. */
> +#define _XEN_NMIREASON_unknown      2
> +#define XEN_NMIREASON_unknown       (1UL << _XEN_NMIREASON_unknown)
> +
> +/*
> + * long nmi_op(unsigned int cmd, void *arg)
> + * NB. All ops return zero on success, else a negative error code.
> + */
> +
> +/*
> + * Register NMI callback for this (calling) VCPU. Currently this only makes
> + * sense for domain 0, vcpu 0. All other callers will be returned EINVAL.
> + * arg == pointer to xennmi_callback structure.
> + */
> +#define XENNMI_register_callback   0
> +struct xennmi_callback {
> +    unsigned long handler_address;
> +    unsigned long pad;
> +};
> +typedef struct xennmi_callback xennmi_callback_t;
> +DEFINE_XEN_GUEST_HANDLE(xennmi_callback_t);
> +
> +/*
> + * Deregister NMI callback for this (calling) VCPU.
> + * arg == NULL.
> + */
> +#define XENNMI_unregister_callback 1
> +
> +#endif /* __XEN_PUBLIC_NMI_H__ */
> 
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
> 


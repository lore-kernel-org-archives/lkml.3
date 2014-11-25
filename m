Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaKYMNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:13:14 -0500
Received: from smtp.citrix.com ([66.165.176.89]:48751 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbaKYMNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:13:12 -0500
X-IronPort-AV: E=Sophos;i="5.07,455,1413244800"; 
   d="scan'208";a="196102570"
Date: Tue, 25 Nov 2014 12:05:19 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC: <david.vrabel@citrix.com>, <konrad.wilk@oracle.com>,
        <stefano.stabellini@eu.citrix.com>, <jun.nakajima@intel.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xen.org>
Subject: Re: [PATCH v3 2/2] xen/pci: Use APIC directly when APIC virtualization
 is supported by hardware
In-Reply-To: <1416870378-32481-3-git-send-email-boris.ostrovsky@oracle.com>
Message-ID: <alpine.DEB.2.02.1411251203500.2675@kaball.uk.xensource.com>
References: <1416870378-32481-1-git-send-email-boris.ostrovsky@oracle.com> <1416870378-32481-3-git-send-email-boris.ostrovsky@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2014, Boris Ostrovsky wrote:
> When hardware supports APIC/x2APIC virtualization we don't need to use pirqs
> for MSI handling and instead use APIC since most APIC accesses (MMIO or MSR)
> will now be processed without VMEXITs.
> 
> As an example, netperf on the original code produces this profile
> (collected wih 'xentrace -e 0x0008ffff -T 5'):
> 
>     342 cpu_change
>     260 CPUID
>   34638 HLT
>   64067 INJ_VIRQ
>   28374 INTR
>   82733 INTR_WINDOW
>      10 NPF
>   24337 TRAP
>  370610 vlapic_accept_pic_intr
>  307528 VMENTRY
>  307527 VMEXIT
>  140998 VMMCALL
>     127 wrap_buffer
> 
> After applying this patch the same test shows
> 
>     230 cpu_change
>     260 CPUID
>   36542 HLT
>     174 INJ_VIRQ
>   27250 INTR
>     222 INTR_WINDOW
>      20 NPF
>   24999 TRAP
>  381812 vlapic_accept_pic_intr
>  166480 VMENTRY
>  166479 VMEXIT
>   77208 VMMCALL
>      81 wrap_buffer
> 
> ApacheBench results (ab -n 10000 -c 200) improve by about 10%

Very nice!


> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> ---
>  arch/x86/include/asm/xen/cpuid.h | 91 ++++++++++++++++++++++++++++++++++++++++
>  arch/x86/pci/xen.c               | 10 +++++
>  2 files changed, 101 insertions(+)
>  create mode 100644 arch/x86/include/asm/xen/cpuid.h
> 
> diff --git a/arch/x86/include/asm/xen/cpuid.h b/arch/x86/include/asm/xen/cpuid.h
> new file mode 100644
> index 0000000..0d809e9
> --- /dev/null
> +++ b/arch/x86/include/asm/xen/cpuid.h
> @@ -0,0 +1,91 @@
> +/******************************************************************************
> + * arch-x86/cpuid.h
> + *
> + * CPUID interface to Xen.
> + *
> + * Permission is hereby granted, free of charge, to any person obtaining a copy
> + * of this software and associated documentation files (the "Software"), to
> + * deal in the Software without restriction, including without limitation the
> + * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
> + * sell copies of the Software, and to permit persons to whom the Software is
> + * furnished to do so, subject to the following conditions:
> + *
> + * The above copyright notice and this permission notice shall be included in
> + * all copies or substantial portions of the Software.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> + * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> + * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
> + * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
> + * DEALINGS IN THE SOFTWARE.
> + *
> + * Copyright (c) 2007 Citrix Systems, Inc.
> + *
> + * Authors:
> + *    Keir Fraser <keir@xen.org>
> + */
> +
> +#ifndef __XEN_PUBLIC_ARCH_X86_CPUID_H__
> +#define __XEN_PUBLIC_ARCH_X86_CPUID_H__
> +
> +/*
> + * For compatibility with other hypervisor interfaces, the Xen cpuid leaves
> + * can be found at the first otherwise unused 0x100 aligned boundary starting
> + * from 0x40000000.
> + *
> + * e.g If viridian extensions are enabled for an HVM domain, the Xen cpuid
> + * leaves will start at 0x40000100
> + */
> +
> +#define XEN_CPUID_FIRST_LEAF 0x40000000
> +#define XEN_CPUID_LEAF(i)    (XEN_CPUID_FIRST_LEAF + (i))
> +
> +/*
> + * Leaf 1 (0x40000x00)
> + * EAX: Largest Xen-information leaf. All leaves up to an including @EAX
> + *      are supported by the Xen host.
> + * EBX-EDX: "XenVMMXenVMM" signature, allowing positive identification
> + *      of a Xen host.
> + */
> +#define XEN_CPUID_SIGNATURE_EBX 0x566e6558 /* "XenV" */
> +#define XEN_CPUID_SIGNATURE_ECX 0x65584d4d /* "MMXe" */
> +#define XEN_CPUID_SIGNATURE_EDX 0x4d4d566e /* "nVMM" */
> +
> +/*
> + * Leaf 2 (0x40000x01)
> + * EAX[31:16]: Xen major version.
> + * EAX[15: 0]: Xen minor version.
> + * EBX-EDX: Reserved (currently all zeroes).
> + */
> +
> +/*
> + * Leaf 3 (0x40000x02)
> + * EAX: Number of hypercall transfer pages. This register is always guaranteed
> + *      to specify one hypercall page.
> + * EBX: Base address of Xen-specific MSRs.
> + * ECX: Features 1. Unused bits are set to zero.
> + * EDX: Features 2. Unused bits are set to zero.
> + */
> +
> +/* Does the host support MMU_PT_UPDATE_PRESERVE_AD for this guest? */
> +#define _XEN_CPUID_FEAT1_MMU_PT_UPDATE_PRESERVE_AD 0
> +#define XEN_CPUID_FEAT1_MMU_PT_UPDATE_PRESERVE_AD  (1u<<0)
> +
> +/*
> + * Leaf 5 (0x40000x04)
> + * HVM-specific features
> + */
> +
> +/* EAX Features */
> +/* Virtualized APIC registers */
> +#define XEN_HVM_CPUID_APIC_ACCESS_VIRT (1u << 0)
> +/* Virtualized x2APIC accesses */
> +#define XEN_HVM_CPUID_X2APIC_VIRT      (1u << 1)
> +/* Memory mapped from other domains has valid IOMMU entries */
> +#define XEN_HVM_CPUID_IOMMU_MAPPINGS   (1u << 2)
> +
> +#define XEN_CPUID_MAX_NUM_LEAVES 4
> +
> +#endif /* __XEN_PUBLIC_ARCH_X86_CPUID_H__ */
> diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
> index 1370716..e4a5bab 100644
> --- a/arch/x86/pci/xen.c
> +++ b/arch/x86/pci/xen.c
> @@ -23,6 +23,8 @@
>  #include <xen/features.h>
>  #include <xen/events.h>
>  #include <asm/xen/pci.h>
> +#include <asm/xen/cpuid.h>
> +#include <asm/apic.h>
>  #include <asm/i8259.h>
>  
>  static int xen_pcifront_enable_irq(struct pci_dev *dev)
> @@ -434,6 +436,14 @@ int __init pci_xen_init(void)
>  #ifdef CONFIG_PCI_MSI
>  void __init xen_msi_init(void)
>  {
> +	if (!disable_apic) {
> +		uint32_t eax = cpuid_eax(xen_cpuid_base() + 4);
> +
> +		if (((eax & XEN_HVM_CPUID_X2APIC_VIRT) && x2apic_mode) ||
> +		    ((eax & XEN_HVM_CPUID_APIC_ACCESS_VIRT) && cpu_has_apic))
> +			return;
> +	}

Please add an in-code comment to explain what this check does.


>  	x86_msi.setup_msi_irqs = xen_hvm_setup_msi_irqs;
>  	x86_msi.teardown_msi_irq = xen_teardown_msi_irq;
>  }
> -- 
> 1.9.3
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab3JDN6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 09:58:32 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:23088 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab3JDN6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 09:58:31 -0400
Date: Fri, 4 Oct 2013 09:57:59 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        bhelgaas@google.com, x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, bhelgaas@google.com,
        benh@kernel.crashing.org, daniel.price@gmail.com,
        thierry.reding@gmail.com, linux-kernel@vger.kernel.org,
        jason@lakedaemon.net
Subject: Re: [PATCH] x86: fix PCI_MSI build on !SMP
Message-ID: <20131004135759.GA27019@phenom.dumpdata.com>
References: <20130930171849.GW3106@phenom.dumpdata.com>
 <1380794354-9079-1-git-send-email-thomas.petazzoni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380794354-9079-1-git-send-email-thomas.petazzoni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 11:59:14AM +0200, Thomas Petazzoni wrote:
> Commit ebd97be635 ('PCI: remove ARCH_SUPPORTS_MSI kconfig option')
> removed the ARCH_SUPPORTS_MSI option which architectures could select
> to indicate that they support MSI. Now, all architectures are supposed
> to build fine when MSI support is enabled: instead of having the
> architecture tell *when* MSI support can be used, it's up to the
> architecture code to ensure that MSI support can be enabled.
> 
> On x86, commit ebd97be635 removed the following line:
> 
>   select ARCH_SUPPORTS_MSI if (X86_LOCAL_APIC && X86_IO_APIC)
> 
> Which meant that MSI support was only available when the local APIC
> and I/O APIC were enabled. While this is always true on SMP or x86-64,
> it is not necessarily the case on i386 !SMP.
> 
> The below patch makes sure that the local APIC and I/O APIC support is
> always enabled when MSI support is enabled. To do so, it:
> 
>  * Ensures the X86_UP_APIC option is not visible when PCI_MSI is
>    enabled. This is the option that allows, on UP machines, to enable
>    or not the APIC support. It is already not visible on SMP systems,
>    or x86-64 systems, for example. We're simply also making it
>    invisible on i386 MSI systems.
> 
>  * Ensures that the X86_LOCAL_APIC and X86_IO_APIC options are 'y'
>    when PCI_MSI is enabled.
> 
> Notice that this change requires a change in drivers/iommu/Kconfig to
> avoid a recursive Kconfig dependencey. The AMD_IOMMU option selects
> PCI_MSI, but was depending on X86_IO_APIC. This dependency is no
> longer needed: as soon as PCI_MSI is selected, the presence of
> X86_IO_APIC is guaranteed. Moreover, the AMD_IOMMU already depended on
> X86_64, which already guaranteed that X86_IO_APIC was enabled, so this
> dependency was anyway redundant.
> 
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

And Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Bjorn or x86 maintainers, please commit this in queue for 3.12!

Thank you!
> Cc: bhelgaas@google.com
> Cc: benh@kernel.crashing.org
> Cc: daniel.price@gmail.com
> Cc: thierry.reding@gmail.com
> Cc: linux-kernel@vger.kernel.org
> Cc: jason@lakedaemon.net
> Cc: x86@kernel.org
> ---
> As this patch fixes a regression introduced by ebd97be635, which got
> merged in 3.12-rc1, this patch should be applied as part of the
> 3.12-rc cycle.
> ---
>  arch/x86/Kconfig      | 6 +++---
>  drivers/iommu/Kconfig | 2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index ee2fb9d..145d703 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -860,7 +860,7 @@ source "kernel/Kconfig.preempt"
>  
>  config X86_UP_APIC
>  	bool "Local APIC support on uniprocessors"
> -	depends on X86_32 && !SMP && !X86_32_NON_STANDARD
> +	depends on X86_32 && !SMP && !X86_32_NON_STANDARD && !PCI_MSI
>  	---help---
>  	  A local APIC (Advanced Programmable Interrupt Controller) is an
>  	  integrated interrupt controller in the CPU. If you have a single-CPU
> @@ -885,11 +885,11 @@ config X86_UP_IOAPIC
>  
>  config X86_LOCAL_APIC
>  	def_bool y
> -	depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_APIC
> +	depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_APIC || PCI_MSI
>  
>  config X86_IO_APIC
>  	def_bool y
> -	depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_IOAPIC
> +	depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_IOAPIC || PCI_MSI
>  
>  config X86_VISWS_APIC
>  	def_bool y
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index fe302e3..c880eba 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -52,7 +52,7 @@ config AMD_IOMMU
>  	select PCI_PRI
>  	select PCI_PASID
>  	select IOMMU_API
> -	depends on X86_64 && PCI && ACPI && X86_IO_APIC
> +	depends on X86_64 && PCI && ACPI
>  	---help---
>  	  With this option you can enable support for AMD IOMMU hardware in
>  	  your system. An IOMMU is a hardware component which provides
> -- 
> 1.8.1.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

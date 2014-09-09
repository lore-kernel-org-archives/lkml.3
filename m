Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbaIIMhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 08:37:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:52529 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586AbaIIMhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 08:37:52 -0400
Date: Tue, 9 Sep 2014 14:37:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        x86@kernel.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Prarit Bhargava <prarit@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        linux-pm@vger.kernel.org
Subject: Re: [Patch v4 14/16] x86, irq: Introduce helper to check whether an
 IOAPIC has been registered
In-Reply-To: <1409192561-19744-15-git-send-email-jiang.liu@linux.intel.com>
Message-ID: <alpine.DEB.2.10.1409091433150.11037@nanos>
References: <1409192561-19744-1-git-send-email-jiang.liu@linux.intel.com> <1409192561-19744-15-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2014, Jiang Liu wrote:

> Introduce acpi_ioapic_registered() to check whether an IOAPIC has already
> been registered, it will be used when enabling IOAPIC hotplug.
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  arch/x86/include/asm/io_apic.h |    1 +
>  arch/x86/kernel/acpi/boot.c    |   11 +++++++++++
>  arch/x86/kernel/apic/io_apic.c |   11 +++++++++++
>  include/linux/acpi.h           |    1 +
>  4 files changed, 24 insertions(+)
> 
> diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
> index ce63cf34c93c..0db2b7037e4b 100644
> --- a/arch/x86/include/asm/io_apic.h
> +++ b/arch/x86/include/asm/io_apic.h
> @@ -191,6 +191,7 @@ extern void mp_unmap_irq(int irq);
>  extern int mp_register_ioapic(int id, u32 address, u32 gsi_base,
>  			      struct ioapic_domain_cfg *cfg);
>  extern int mp_unregister_ioapic(u32 gsi_base);
> +extern int mp_ioapic_registered(u32 gsi_base);
>  extern int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
>  			    irq_hw_number_t hwirq);
>  extern void mp_irqdomain_unmap(struct irq_domain *domain, unsigned int virq);
> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
> index 560a6d1cb0f4..6aa796f77b71 100644
> --- a/arch/x86/kernel/acpi/boot.c
> +++ b/arch/x86/kernel/acpi/boot.c
> @@ -810,6 +810,17 @@ int acpi_unregister_ioapic(acpi_handle handle, u32 gsi_base)
>  }
>  EXPORT_SYMBOL(acpi_unregister_ioapic);
>  
> +int acpi_ioapic_registered(acpi_handle handle, u32 gsi_base)
> +{
> +	int ret;
> +
> +	down_write(&acpi_ioapic_rwsem);

Why down_write? You are merily checking whether the thing is
registered already.

> +	ret  = mp_ioapic_registered(gsi_base);
> +	up_write(&acpi_ioapic_rwsem);
> +
> +	return ret;
> +}

So I assume that this is for a particular caller in the apci ioapic
hotplug code and that call site has its own serialization. Otherwise
the return value is not protected at all.

Please add a Docbook comment to that function, and document the
locking rules as thats pretty non obvious.

The such is missing in some other patches as well.

Thanks,

	tglx

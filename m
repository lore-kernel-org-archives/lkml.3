Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603AbaIIMUz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 08:20:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:52322 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649AbaIIMUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 08:20:53 -0400
Date: Tue, 9 Sep 2014 14:20:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        x86@kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        linux-pm@vger.kernel.org
Subject: Re: [Patch v4 12/16] x86, irq, ACPI: Implement interface to support
 ACPI based IOAPIC hot-addition
In-Reply-To: <1409192561-19744-13-git-send-email-jiang.liu@linux.intel.com>
Message-ID: <alpine.DEB.2.10.1409091417120.11037@nanos>
References: <1409192561-19744-1-git-send-email-jiang.liu@linux.intel.com> <1409192561-19744-13-git-send-email-jiang.liu@linux.intel.com>
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
>  EXPORT_SYMBOL(acpi_register_ioapic);
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 6e67af0c5f99..b286461cabf9 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -3851,7 +3851,13 @@ static int bad_ioapic_register(int idx)
>  
>  static int find_free_ioapic_entry(void)
>  {
> -	return nr_ioapics;
> +	int idx;
> +
> +	for (idx = 0; idx < MAX_IO_APICS; idx++)
> +		if (ioapics[idx].nr_registers == 0)
> +			return idx;
> +
> +	return MAX_IO_APICS;
>  }
>  
>  int mp_register_ioapic(int id, u32 address, u32 gsi_base,
> @@ -3867,8 +3873,15 @@ int mp_register_ioapic(int id, u32 address, u32 gsi_base,
>  	}
>  	for_each_ioapic(ioapic)
>  		if (ioapics[ioapic].mp_config.apicaddr == address) {
> -			pr_warn("address 0x%x conflicts with IOAPIC%d\n",
> -				address, ioapic);
> +			/*
> +			 * IOAPIC unit may also be visible in PCI scope.
> +			 * When ioapic PCI driver's probe() is called,
> +			 * the IOAPIC unit may have already been initialized
> +			 * at boot time.
> +			 */
> +			if (!ioapic_initialized)
> +				pr_warn("address 0x%x conflicts with IOAPIC%d\n",
> +					address, ioapic);

Hmm. This smells fishy. Why do we allow multiple initializations of
the same IOAPIC in the first place. Either it's done via ACPI or via
PCI, but not both.

>  			return -EEXIST;
>  		}
>  
> @@ -3918,6 +3931,14 @@ int mp_register_ioapic(int id, u32 address, u32 gsi_base,
>  	ioapics[idx].irqdomain = NULL;
>  	ioapics[idx].irqdomain_cfg = *cfg;
>  
> +	if (ioapic_initialized) {

I have a hard time to understand this conditional. Why can't we do
that unconditionally?

> +		if (mp_irqdomain_create(idx)) {
> +			clear_fixmap(FIX_IO_APIC_BASE_0 + idx);
> +			return -ENOMEM;
> +		}
> +		alloc_ioapic_saved_registers(idx);
> +	}
> +
>  	if (gsi_cfg->gsi_end >= gsi_top)
>  		gsi_top = gsi_cfg->gsi_end + 1;
>  	if (nr_ioapics <= idx)

Thanks,

	tglx

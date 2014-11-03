Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbaKCOvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 09:51:09 -0500
Received: from mail.skyhub.de ([78.46.96.112]:59925 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbaKCOvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 09:51:05 -0500
Date: Mon, 3 Nov 2014 15:50:56 +0100
From: Borislav Petkov <bp@alien8.de>
To: jiang.liu@linux.intel.com, hpa@zytor.com, bhelgaas@google.com,
        rjw@rjwysocki.net, rdunlap@infradead.org, mingo@kernel.org,
        joro@8bytes.org, tglx@linutronix.de, tony.luck@intel.com,
        konrad.wilk@oracle.com, gregkh@linuxfoundation.org,
        benh@kernel.crashing.org, yinghai@kernel.org,
        linux-kernel@vger.kernel.org
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/apic] x86, PCI, ACPI: Kill private function
 resource_to_addr() in arch/x86/pci/acpi.c
Message-ID: <20141103145055.GA27387@pd.tnic>
References: <1414387308-27148-5-git-send-email-jiang.liu@linux.intel.com>
 <tip-e22ce93870deae0e9a54e1539f0088538f187780@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tip-e22ce93870deae0e9a54e1539f0088538f187780@git.kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 02:57:31AM -0800, tip-bot for Jiang Liu wrote:
> Commit-ID:  e22ce93870deae0e9a54e1539f0088538f187780
> Gitweb:     http://git.kernel.org/tip/e22ce93870deae0e9a54e1539f0088538f187780
> Author:     Jiang Liu <jiang.liu@linux.intel.com>
> AuthorDate: Mon, 27 Oct 2014 13:21:34 +0800
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Mon, 3 Nov 2014 11:56:07 +0100
> 
> x86, PCI, ACPI: Kill private function resource_to_addr() in arch/x86/pci/acpi.c
> 
> Private function resource_to_addr() is used to parse ACPI resources
> for PCI host bridge. There are public interfaces available for that
> purpose, so replace resource_to_addr() with public interfaces.
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Link: http://lkml.kernel.org/r/1414387308-27148-5-git-send-email-jiang.liu@linux.intel.com
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---

...

>  static acpi_status setup_resource(struct acpi_resource *acpi_res, void *data)
>  {
>  	struct pci_root_info *info = data;
> -	struct resource *res;
> -	struct acpi_resource_address64 addr;
> -	acpi_status status;
> -	unsigned long flags;
> -	u64 start, orig_end, end;
> +	u64 translation_offset = 0;
> +	struct resource r = {
> +		.flags = 0
> +	};
> +
> +	if (acpi_dev_resource_memory(acpi_res, &r)) {
> +		r.flags &= IORESOURCE_MEM | IORESOURCE_IO;
> +	} else if (acpi_dev_resource_address_space(acpi_res, &r)) {
> +		u64 orig_end;
> +		struct acpi_resource_address64 addr;
> +
> +		r.flags &= IORESOURCE_MEM | IORESOURCE_IO;
> +		if (r.flags == 0)
> +			return AE_OK;
>  
> -	status = resource_to_addr(acpi_res, &addr);
> -	if (!ACPI_SUCCESS(status))
> -		return AE_OK;
> +		if (ACPI_FAILURE(acpi_resource_to_address64(acpi_res, &addr)))
> +			return AE_OK;
>  
> -	if (addr.resource_type == ACPI_MEMORY_RANGE) {
> -		flags = IORESOURCE_MEM;
> -		if (addr.info.mem.caching == ACPI_PREFETCHABLE_MEMORY)
> -			flags |= IORESOURCE_PREFETCH;
> -	} else if (addr.resource_type == ACPI_IO_RANGE) {
> -		flags = IORESOURCE_IO;
> -	} else
> -		return AE_OK;
> +		if (addr.resource_type == ACPI_MEMORY_RANGE &&
> +		    addr.info.mem.caching == ACPI_PREFETCHABLE_MEMORY)
> +			r.flags |= IORESOURCE_PREFETCH;
>  
> -	start = addr.minimum + addr.translation_offset;
> -	orig_end = end = addr.maximum + addr.translation_offset;
> +		translation_offset = addr.translation_offset;
> +		orig_end = r.end;
> +		r.start += translation_offset;
> +		r.end += translation_offset;
>  
> -	/* Exclude non-addressable range or non-addressable portion of range */
> -	end = min(end, (u64)iomem_resource.end);
> -	if (end <= start) {
> -		dev_info(&info->bridge->dev,
> -			"host bridge window [%#llx-%#llx] "
> -			"(ignored, not CPU addressable)\n", start, orig_end);
> -		return AE_OK;
> -	} else if (orig_end != end) {
> -		dev_info(&info->bridge->dev,
> -			"host bridge window [%#llx-%#llx] "
> -			"([%#llx-%#llx] ignored, not CPU addressable)\n", 
> -			start, orig_end, end + 1, orig_end);
> +		/* Exclude non-addressable range or non-addressable portion of range */
> +		r.end = min(r.end, iomem_resource.end);
> +		if (r.end <= r.start) {
> +			dev_info(&info->bridge->dev,
> +				"host bridge window [%#llx-%#llx] (ignored, not CPU addressable)\n",
> +				 r.start, orig_end);
> +			return AE_OK;
> +		} else if (orig_end != r.end) {
> +			dev_info(&info->bridge->dev,
> +				"host bridge window [%#llx-%#llx] ([%#llx-%#llx] ignored, not CPU addressable)\n",
> +				r.start, orig_end, r.end + 1, orig_end);
> +		}

I see the warnings below on 32-bit, those resource_size_t things on
32-bit are u32 through the phys_addr_t typedef:

#ifdef CONFIG_PHYS_ADDR_T_64BIT
typedef u64 phys_addr_t;
#else
typedef u32 phys_addr_t;
#endif

typedef phys_addr_t resource_size_t;
---

arch/x86/pci/acpi.c: In function ‘setup_resource’:
arch/x86/pci/acpi.c:271:4: warning: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 3 has type ‘resource_size_t’ [-Wformat=]
    dev_info(&info->bridge->dev,
    ^
arch/x86/pci/acpi.c:276:4: warning: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 3 has type ‘resource_size_t’ [-Wformat=]
    dev_info(&info->bridge->dev,
    ^
arch/x86/pci/acpi.c:276:4: warning: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 5 has type ‘resource_size_t’ [-Wformat=]

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

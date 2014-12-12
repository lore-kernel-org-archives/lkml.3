Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759623AbaLLO5D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 09:57:03 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49237 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759493AbaLLO5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 09:57:00 -0500
Date: Fri, 12 Dec 2014 15:56:57 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        x86@kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [patch 3/4] x86: pci: acpi: Fix the range check for IO resources
Message-ID: <20141212145657.GC30699@pd.tnic>
References: <20141211191853.613107396@linutronix.de>
 <20141211193112.725667793@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141211193112.725667793@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 07:48:22PM -0000, Thomas Gleixner wrote:
> The range check in setup_res() checks the IO range against
> iomem_resource. That's just wrong.
> 
> Move the check into a separate function and use ioport_resource for IO
> ranges.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/x86/pci/acpi.c |   51 +++++++++++++++++++++++++++++++++------------------
>  1 file changed, 33 insertions(+), 18 deletions(-)
> 
> Index: tip/arch/x86/pci/acpi.c
> ===================================================================
> --- tip.orig/arch/x86/pci/acpi.c
> +++ tip/arch/x86/pci/acpi.c
> @@ -240,12 +240,41 @@ static acpi_status count_resource(struct
>  	return AE_OK;
>  }
>  
> +static bool valid_resource_range(struct resource *r, struct device *dev)
> +{
> +	struct resource *ior;
> +	u64 end;
> +
> +	ior = (r->flags & IORESOURCE_IO) ? &ioport_resource : &iomem_resource;
> +
> +	/*
> +	 * Exclude non-addressable range or non-addressable portion of
> +	 * range. We only check end because ior->start is always 0.
> +	 */
> +	end = r->end;
> +	r->end = min(r->end, ior->end);
> +	if (r->end <= r->start) {
> +		dev_info(dev, "host bridge %s window [%#llx-%#llx] invalid range\n",
> +			 r->flags & IORESOURCE_IO ? "io" : "mem",

I think you can simplify this and below even further as the check
Iagainst ORESOURCE_IO is done already when selecting the ior thing (diff
Iontop):

---
Index: b/arch/x86/pci/acpi.c
===================================================================
--- a/arch/x86/pci/acpi.c	2014-12-12 15:54:40.856317113 +0100
+++ b/arch/x86/pci/acpi.c	2014-12-12 15:53:16.832319561 +0100
@@ -255,7 +255,7 @@ static bool valid_resource_range(struct
 	r->end = min(r->end, ior->end);
 	if (r->end <= r->start) {
 		dev_info(dev, "host bridge %s window [%#llx-%#llx] invalid range\n",
-			 r->flags & IORESOURCE_IO ? "io" : "mem",
+			 ior->name,
 			 (unsigned long long)r->start, end);
 		return false;
 	}
@@ -264,7 +264,7 @@ static bool valid_resource_range(struct
 		return true;
 
 	dev_info(dev, "host bridge %s window [%#llx-%#llx] truncated to [%#llx-%#llx]\n",
-		 r->flags & IORESOURCE_IO ? "io" : "mem",
+		 ior->name,
 		 (unsigned long long)r->start, end,
 		 (unsigned long long)r->start, (unsigned long long)r->end);
 	return true;

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

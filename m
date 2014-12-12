Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968044AbaLLNju (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 08:39:50 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33598 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967589AbaLLNjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 08:39:49 -0500
Date: Fri, 12 Dec 2014 14:39:45 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        x86@kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [patch 2/4] x86: pci: acpi: Respect ioresource flags
Message-ID: <20141212133945.GB30699@pd.tnic>
References: <20141211191853.613107396@linutronix.de>
 <20141211193112.630941351@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141211193112.630941351@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 07:48:20PM -0000, Thomas Gleixner wrote:
> setup_res() blindly clear all resource->flags except IO and MEM. So if
> a resource is marked disabled by the acpi code, setup_res() will use
> it nevertheless.
> 
> Preserve the flags and add proper checks to setup_res() and
> __release_pci_root_info(). The latter is simplified while at it.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/x86/pci/acpi.c |   35 ++++++++++++++++-------------------
>  1 file changed, 16 insertions(+), 19 deletions(-)
> 
> Index: tip/arch/x86/pci/acpi.c
> ===================================================================
> --- tip.orig/arch/x86/pci/acpi.c
> +++ tip/arch/x86/pci/acpi.c
> @@ -218,6 +218,12 @@ static void teardown_mcfg_map(struct pci
>  }
>  #endif
>  
> +static bool is_valid_resource(struct resource *res)
> +{
> +	return (res->flags & (IORESOURCE_MEM | IORESOURCE_IO)) &&
> +		!(res->flags & IORESOURCE_DISABLED);
> +}
> +
>  static acpi_status count_resource(struct acpi_resource *acpi_res, void *data)
>  {
>  	struct pci_root_info *info = data;
> @@ -228,7 +234,7 @@ static acpi_status count_resource(struct
>  	    !acpi_dev_resource_address_space(acpi_res, &r))
>  		return AE_OK;
>  
> -	if ((r.flags & (IORESOURCE_IO | IORESOURCE_MEM)) && resource_size(&r))
> +	if (is_valid_resource(&r))
>  		info->res_num++;
>  
>  	return AE_OK;

Ok, this makes definitely more sense in getting rid of the
*clearing* of the flags which is intuitively backwards to what it should
do.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

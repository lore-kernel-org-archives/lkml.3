Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbaCEIfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 03:35:07 -0500
Received: from dliviu.plus.com ([80.229.23.120]:59388 "EHLO smtp.dudau.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbaCEIfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 03:35:05 -0500
Date: Wed, 5 Mar 2014 08:33:12 +0000
From: Liviu Dudau <liviu@dudau.co.uk>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Liviu Dudau'" <Liviu.Dudau@arm.com>,
        "'linux-pci'" <linux-pci@vger.kernel.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Catalin Marinas'" <Catalin.Marinas@arm.com>,
        "'Will Deacon'" <Will.Deacon@arm.com>,
        "'linaro-kernel'" <linaro-kernel@lists.linaro.org>,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>, devicetree@vger.kernel.org,
        "'LAKML'" <linux-arm-kernel@lists.infradead.org>,
        "'Tanmay Inamdar'" <tinamdar@apm.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>
Subject: Re: [PATCH v5 7/7] pci: Add support for creating a generic
 host_bridge from device tree
Message-ID: <20140305083311.GD13582@bart.dudau.co.uk>
Mail-Followup-To: Jingoo Han <jg1.han@samsung.com>,
	'Liviu Dudau' <Liviu.Dudau@arm.com>,
	'linux-pci' <linux-pci@vger.kernel.org>,
	'Bjorn Helgaas' <bhelgaas@google.com>,
	'Catalin Marinas' <Catalin.Marinas@arm.com>,
	'Will Deacon' <Will.Deacon@arm.com>,
	'linaro-kernel' <linaro-kernel@lists.linaro.org>,
	'Benjamin Herrenschmidt' <benh@kernel.crashing.org>,
	'LKML' <linux-kernel@vger.kernel.org>, devicetree@vger.kernel.org,
	'LAKML' <linux-arm-kernel@lists.infradead.org>,
	'Tanmay Inamdar' <tinamdar@apm.com>,
	'Arnd Bergmann' <arnd@arndb.de>
References: <1393948204-11555-1-git-send-email-Liviu.Dudau@arm.com>
 <1393948204-11555-8-git-send-email-Liviu.Dudau@arm.com>
 <001f01cf3811$18463ed0$48d2bc70$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <001f01cf3811$18463ed0$48d2bc70$%han@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Wed Mar  5 08:35:03 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5316e1b73191772912719
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 10:20:28AM +0900, Jingoo Han wrote:
> On Wednesday, March 05, 2014 12:50 AM, Liviu Dudau wrote:
> > 
> > Several platforms use a rather generic version of parsing
> > the device tree to find the host bridge ranges. Move the common code
> > into the generic PCI code and use it to create a pci_host_bridge
> > structure that can be used by arch code.
> > 
> > Based on early attempts by Andrew Murray to unify the code.
> > Used powerpc and microblaze PCI code as starting point.
> > 
> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> > 
> > diff --git a/drivers/pci/host-bridge.c b/drivers/pci/host-bridge.c
> > index 8708b652..800678a 100644
> > --- a/drivers/pci/host-bridge.c
> > +++ b/drivers/pci/host-bridge.c
> 
> [.....]
> 
> > +		res = kzalloc(sizeof(struct resource), GFP_KERNEL);
> 
> It makes build error with exynos_defconfig. (ARM32)
> Thus, 'slab.h' is necessary in order to fix the build error.
> 
> ./drivers/pci/host-bridge.c
> @@ -8,6 +8,7 @@
>  #include <linux/module.h>
>  #include <linux/of_address.h>
>  #include <linux/of_pci.h>
> +#include <linux/slab.h>

Will add, thanks!

> 
>  #include "pci.h"
> 
> 
> > +		if (!res) {
> > +			err = -ENOMEM;
> > +			goto bridge_ranges_nomem;
> > +		}
> > +
> > +		of_pci_range_to_resource(&range, dev, res);
> > +
> > +		if (resource_type(res) == IORESOURCE_IO)
> > +			*io_base = range.cpu_addr;
> > +
> > +		pci_add_resource_offset(resources, res,
> > +				res->start - range.pci_addr);
> > +	}
> > +
> > +	/* Apply architecture specific fixups for the ranges */
> > +	pcibios_fixup_bridge_ranges(resources);
> 
> It also makes compile problem with exynos_defconfig as below:
> 
> drivers/built-in.o: In function `pci_host_bridge_of_get_ranges':
> drivers/pci/host-bridge.c:157: undefined reference to `pcibios_fixup_bridge_ranges'

Does that mean that exynos_defconfig doesn't define CONFIG_OF? How do you
compile all the .dts files then? Should CONFIG_OF not be added to the default config
file?

Other than that, your comment is correct. drivers/pci/host-bridge.c gets compiled
in regardless of CONFIG_OF and I need to provide an empty implementation for
pcibios_fixup_bridge_ranges().

Thanks!

Liviu

> 
> Best regards,
> Jingoo Han
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
-------------------
   .oooO
   (   )
    \ (  Oooo.
     \_) (   )
          ) /
         (_/

 One small step
   for me ...


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712AbaCGVDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 16:03:31 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:51422 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753656AbaCGVDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 16:03:30 -0500
Message-ID: <1394226207.7470.15.camel@x220>
Subject: Re: [Intel-gfx] agp/intel: can't ioremap flush page - no chipset
 flushing
From: Paul Bolle <pebolle@tiscali.nl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Steven Newbury <steve@snewbury.org.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Date: Fri, 07 Mar 2014 22:03:27 +0100
In-Reply-To: <20140307204021.GA9822@google.com>
References: <1391886379.2669.11.camel@x41>
	 <CAKMK7uE6Gaq-ghgWJ+6Qyn7hrGzAMOHyGT9KQQJ+ij7omPV2Ew@mail.gmail.com>
	 <1391890927.1882.5.camel@x41>
	 <CAKMK7uFx2kksGgnuy9e0xiQRKpt=_+44O1V4wbX5yNBocvjBkg@mail.gmail.com>
	 <1391951759.6036.7.camel@artifact> <1391952344.25424.4.camel@x220>
	 <CAErSpo6uj_Kuk0_F97nRsnM1Pss4C7=HeEaVu6D-NwFFK=1cvA@mail.gmail.com>
	 <1394185698.5608.5.camel@x41>
	 <CAErSpo4jiq38P3TNuGLGS--nbV9NtUAmiuK=cwWyFAneY-=eOA@mail.gmail.com>
	 <1394212609.1987.6.camel@x41> <20140307204021.GA9822@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Mar 2014 21:03:28.0168 (UTC) FILETIME=[AFFCF280:01CF3A48]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-07 at 13:40 -0700, Bjorn Helgaas wrote:
> It seems quite possible that I broke pci_bus_alloc_resource(), which could
> cause an allocation failure like this.  
> 
> If you have a chance to try it, here's a debug patch against v3.14-rc5.  It
> should apply cleanly to 96702be56037.  If you can try it, please attach the
> dmesg log to the bugzilla.

That ThinkPad X41 is now building 96702be56037. Once that build is
finished and tested I'll try your debug patch (on top of v3.14-rc5, see
later). It might take some time to finish both builds and test boots.

> diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
> index 5c85350f4c3d..0dbba6c7c001 100644
> --- a/drivers/char/agp/intel-gtt.c
> +++ b/drivers/char/agp/intel-gtt.c
> @@ -997,6 +997,7 @@ static int intel_alloc_chipset_flush_resource(void)
>  	ret = pci_bus_alloc_resource(intel_private.bridge_dev->bus, &intel_private.ifp_resource, PAGE_SIZE,
>  				     PAGE_SIZE, PCIBIOS_MIN_MEM, 0,
>  				     pcibios_align_resource, intel_private.bridge_dev);
> +	dev_info(&intel_private.bridge_dev->dev, "pci_bus_alloc ret %d\n", ret);
>  
>  	return ret;
>  }
> @@ -1007,6 +1008,7 @@ static void intel_i915_setup_chipset_flush(void)
>  	u32 temp;
>  
>  	pci_read_config_dword(intel_private.bridge_dev, I915_IFPADDR, &temp);
> +	dev_info(&intel_private.bridge_dev->dev, "I915_IFPADDR %#010x\n", temp);
>  	if (!(temp & 0x1)) {
>  		intel_alloc_chipset_flush_resource();
>  		intel_private.resource_valid = 1;
> @@ -1022,6 +1024,7 @@ static void intel_i915_setup_chipset_flush(void)
>  		if (ret)
>  			intel_private.resource_valid = 0;
>  	}
> +	dev_info(&intel_private.bridge_dev->dev, "ifp_resource %pR\n", &intel_private.ifp_resource);
>  }
>  
>  static void intel_i965_g33_setup_chipset_flush(void)

My v3.13 based builds don't have INTEL_GTT set! My v3.14-rcy based
builds do. I have not yet investigated why that is.

(Note that the .config on that ThinkPad X41 is - in short - rebranched
from the kernel .config that is shipped for Fedora 20 every time a rc1
is released.)

> diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
> index 00660cc502c5..1c6d75ae34d9 100644
> --- a/drivers/pci/bus.c
> +++ b/drivers/pci/bus.c
> @@ -146,24 +146,31 @@ static int pci_bus_alloc_from_region(struct pci_bus *bus, struct resource *res,
>  
>  	type_mask |= IORESOURCE_IO | IORESOURCE_MEM;
>  
> +	dev_info(&bus->dev, "%s: alloc %pR size %#llx from bus region [%#010llx-%#010llx]\n", __func__, res, (long long) size, (long long) region->start, (long long) region->end);
>  	pci_bus_for_each_resource(bus, r, i) {
>  		if (!r)
>  			continue;
>  
>  		/* type_mask must match */
> -		if ((res->flags ^ r->flags) & type_mask)
> +		if ((res->flags ^ r->flags) & type_mask) {
> +			dev_info(&bus->dev, "%s: %pR: wrong type (%#lx %#lx mask %#x)\n", __func__, r, res->flags, r->flags, type_mask);
>  			continue;
> +		}
>  
>  		/* We cannot allocate a non-prefetching resource
>  		   from a pre-fetching area */
>  		if ((r->flags & IORESOURCE_PREFETCH) &&
> -		    !(res->flags & IORESOURCE_PREFETCH))
> +		    !(res->flags & IORESOURCE_PREFETCH)) {
> +			dev_info(&bus->dev, "%s: %pR: wrong prefetchability\n", __func__, r);
>  			continue;
> +		}
>  
>  		avail = *r;
>  		pci_clip_resource_to_region(bus, &avail, region);
> -		if (!resource_size(&avail))
> +		if (!resource_size(&avail)) {
> +			dev_info(&bus->dev, "%s: %pR: no space (avail %pR)\n", __func__, r, &avail);
>  			continue;
> +		}
>  
>  		/*
>  		 * "min" is typically PCIBIOS_MIN_IO or PCIBIOS_MIN_MEM to
> @@ -179,6 +186,7 @@ static int pci_bus_alloc_from_region(struct pci_bus *bus, struct resource *res,
>  		/* Ok, try it out.. */
>  		ret = allocate_resource(r, res, size, min, max,
>  					align, alignf, alignf_data);
> +		dev_info(&bus->dev, "%s: %pR: alloc from %#llx-%#llx, ret %d\n", __func__, r, min, max, ret);
>  		if (ret == 0)
>  			return 0;
>  	}

Too bad drivers/pci/bus.o is built in by definition. If only one could
build a kernel without rebuilding all modules. Or is there some way to
actually do that?


Paul Bolle


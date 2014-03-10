Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbaCJXpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 19:45:24 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:54029 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752261AbaCJXpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 19:45:23 -0400
Message-ID: <1394495121.1975.6.camel@x41>
Subject: Re: [Intel-gfx] agp/intel: can't ioremap flush page - no chipset
 flushing
From: Paul Bolle <pebolle@tiscali.nl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Steven Newbury <steve@snewbury.org.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, linux-pci@vger.kernel.org
Date: Tue, 11 Mar 2014 00:45:21 +0100
In-Reply-To: <20140310182431.GA11424@google.com>
References: <CAKMK7uFx2kksGgnuy9e0xiQRKpt=_+44O1V4wbX5yNBocvjBkg@mail.gmail.com>
	 <1391951759.6036.7.camel@artifact> <1391952344.25424.4.camel@x220>
	 <CAErSpo6uj_Kuk0_F97nRsnM1Pss4C7=HeEaVu6D-NwFFK=1cvA@mail.gmail.com>
	 <1394185698.5608.5.camel@x41>
	 <CAErSpo4jiq38P3TNuGLGS--nbV9NtUAmiuK=cwWyFAneY-=eOA@mail.gmail.com>
	 <1394212609.1987.6.camel@x41> <20140307204021.GA9822@google.com>
	 <CAErSpo7Np8oju1ENQA5EgEpN4=Vv7f3s4E823ecbyp6FCWPL_Q@mail.gmail.com>
	 <1394289877.31006.2.camel@x41> <20140310182431.GA11424@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Mar 2014 23:45:21.0736 (UTC) FILETIME=[CCF70C80:01CF3CBA]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas schreef op ma 10-03-2014 om 12:24 [-0600]:
> Thanks.  Can you try the patch below?  I think it should fix the problem.
> 
> 
> PCI: Don't check resource_size() in pci_bus_alloc_resource()
> 
> From: Bjorn Helgaas <bhelgaas@google.com>
> 
> When resource_size_t is 32 bits wide, e.g., when CONFIG_PHYS_ADDR_T_64BIT
> is not defined, resource_size() on [mem 0x00000000-0xffffffff] returns 0
> because (r->end - r->start + 1) overflows.
> 
> Therefore, we can't use "resource_size() == 0" to decide that allocation
> from this resource will fail.  allocate_resource() should fail anyway if it
> can't satisfy the address constraints, so we should just depend on that.
> 
> A [mem 0x00000000-0xffffffff] bus resource is obviously not really valid,
> but we do fall back to it as a default when we don't have information about
> host bridge apertures.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=71611
> Fixes: f75b99d5a77d PCI: Enforce bus address limits in resource allocation
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> ---
>  drivers/pci/bus.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
> index 00660cc502c5..38901665c770 100644
> --- a/drivers/pci/bus.c
> +++ b/drivers/pci/bus.c
> @@ -162,8 +162,6 @@ static int pci_bus_alloc_from_region(struct pci_bus *bus, struct resource *res,
>  
>  		avail = *r;
>  		pci_clip_resource_to_region(bus, &avail, region);
> -		if (!resource_size(&avail))
> -			continue;
>  
>  		/*
>  		 * "min" is typically PCIBIOS_MIN_IO or PCIBIOS_MIN_MEM to

I've applied your patch on top of v3.14-rc6. The boot warning is gone.
And /proc/iomem once again has the lines:
    [...]
    80000000-801fffff : PCI Bus 0000:02
    80200000-8027ffff : 0000:00:02.1
    80280000-80280fff : Intel Flush Page
    [...]

Which is what we want, don't we?

A bit of doubt is caused by two new boot time messages:
    pnp 00:00: unknown resource type 10 in _CRS
    pnp 00:00: can't evaluate _CRS: 1

But I haven't yet tried v3.14-rc6 without your patch, so these might be
unrelated. They're unclear to me, anyway.

Thanks,


Paul Bolle


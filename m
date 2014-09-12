Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbaILKeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 06:34:37 -0400
Received: from service87.mimecast.com ([91.220.42.44]:55127 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbaILKef convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 06:34:35 -0400
Date: Fri, 12 Sep 2014 11:34:29 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v10 09/10] PCI: Assign unassigned bus resources in
 pci_scan_root_bus()
Message-ID: <20140912103429.GA1994@e106497-lin.cambridge.arm.com>
References: <1410184472-17630-1-git-send-email-Liviu.Dudau@arm.com>
 <1410184472-17630-10-git-send-email-Liviu.Dudau@arm.com>
 <5412C75F.30207@amd.com>
MIME-Version: 1.0
In-Reply-To: <5412C75F.30207@amd.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 12 Sep 2014 10:34:30.0907 (UTC) FILETIME=[22E6A4B0:01CFCE75]
X-MC-Unique: 114091211343203301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 11:13:51AM +0100, Suravee Suthikulpanit wrote:
> On 9/8/2014 8:54 AM, Liviu Dudau wrote:
> > If the firmware has not assigned all the bus resources and
> > we are not just probing the PCIe busses, it makes sense to
> > assign the unassigned resources in pci_scan_root_bus().
> >
> > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> > Cc: Rob Herring <robh+dt@kernel.org>
> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> > ---
> >   drivers/pci/probe.c | 3 +++
> >   1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> > index ef891d2..508cf61 100644
> > --- a/drivers/pci/probe.c
> > +++ b/drivers/pci/probe.c
> > @@ -1953,6 +1953,9 @@ struct pci_bus *pci_scan_root_bus(struct device *parent, int bus,
> >   	if (!found)
> >   		pci_bus_update_busn_res_end(b, max);
> >
> > +	if (!pci_has_flag(PCI_PROBE_ONLY))
> > +		pci_assign_unassigned_bus_resources(b);
> > +
> >   	pci_bus_add_devices(b);
> >   	return b;
> >   }
> >
> 
> Liviu,
> 
> Besides the check for PCI_PROBE_ONLY here, I think we also need to avoid calling
> "pci_enable_resources()" in the "driver/pci/pci.c: pcibios_enable_device()" for
> PCI_PROBE_ONLY mode since the resource is not assigned by Linux. Otherwise, the
> "drivers/pci/setup-res.c: pci_enable_resource()" would fail w/ error:
> 
>      can't enable device: BAR ..... not assigned

Hmm, are you sure that is not because the host bridge resources have not been
requested? pci-host-generic.c uses PCI_PROBE_ONLY and yet it works with the series as
is. But it does request_resource() for the host bridge resources inside the driver.

Best regards,
Liviu

> 
> Actually, in "arch/arm/kernel/bios32.c:", the weak "pcibios_enable_device()" function
> also has the check for PCI_PROBE_ONLY mode before calling pci_enable_resources().
> 
> Thanks,
> 
> Suravee
> 
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯


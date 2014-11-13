Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933826AbaKMScX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 13:32:23 -0500
Received: from service87.mimecast.com ([91.220.42.44]:52684 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933146AbaKMScV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 13:32:21 -0500
Date: Thu, 13 Nov 2014 18:32:16 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] PCI: generic: Add set_msi_parent callback
Message-ID: <20141113183216.GF12037@e106497-lin.cambridge.arm.com>
References: <1415647480-3320-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1415647480-3320-3-git-send-email-suravee.suthikulpanit@amd.com>
 <20141111112424.GB16265@arm.com>
 <20141111115227.GF12037@e106497-lin.cambridge.arm.com>
 <20141113152243.GB9726@red-moon>
MIME-Version: 1.0
In-Reply-To: <20141113152243.GB9726@red-moon>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 13 Nov 2014 18:32:17.0539 (UTC) FILETIME=[27280D30:01CFFF70]
X-MC-Unique: 114111318321908501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 03:22:43PM +0000, Lorenzo Pieralisi wrote:
> On Tue, Nov 11, 2014 at 11:52:27AM +0000, Liviu Dudau wrote:
> > On Tue, Nov 11, 2014 at 11:24:24AM +0000, Will Deacon wrote:
> > > Hi Suravee,
> > > 
> > > On Mon, Nov 10, 2014 at 07:24:40PM +0000, suravee.suthikulpanit@amd.com wrote:
> > > > From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> > > > 
> > > > This patch implement set_msi_parent callback for PCI generic host controller.
> > > > 
> > > > Cc: Bjorn Helgass <bhelgaas@google.com>
> > > > Cc: Liviu Dudau <liviu.dudau@arm.com>
> > > > Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> > > > Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> > > > ---
> > > >  drivers/pci/host/pci-host-generic.c | 14 ++++++++++++++
> > > >  1 file changed, 14 insertions(+)
> > > > 
> > > > diff --git a/drivers/pci/host/pci-host-generic.c b/drivers/pci/host/pci-host-generic.c
> > > > index 036ab1b..f9bb97a 100644
> > > > --- a/drivers/pci/host/pci-host-generic.c
> > > > +++ b/drivers/pci/host/pci-host-generic.c
> > > > @@ -42,6 +42,7 @@ struct gen_pci {
> > > >  	struct pci_host_bridge			host;
> > > >  	struct gen_pci_cfg_windows		cfg;
> > > >  	struct list_head			resources;
> > > > +	struct msi_chip				*mchip;
> > > >  };
> > > >  
> > > >  #ifdef CONFIG_ARM
> > > > @@ -128,9 +129,19 @@ static int gen_pci_config_write(struct pci_bus *bus, unsigned int devfn,
> > > >  	return PCIBIOS_SUCCESSFUL;
> > > >  }
> > > >  
> > > > +static int gen_pci_set_msi_parent(struct pci_bus *bus)
> > > > +{
> > > > +	struct gen_pci *pci = bus_to_gen_pci(bus);
> > > > +
> > > > +	bus->msi = pci->mchip;
> > > > +
> > > > +	return PCIBIOS_SUCCESSFUL;
> > > > +}
> > > 
> > > I don't think this makes much sense a host controller callback. Why can't
> > > bus->msi be set in generic code?
> > 
> > Because of the current way in which a bus gets created and them immediately used for
> > scanning devices if you use pci_scan_root_bus(). Alternative is to use pci_create_root_bus()
> > and increase your code size with the body of pci_scan_root_bus().
> > 
> > Solution is to have pci_host_bridge holding the msi_chip pointer and that gets created
> > before root bus, with pci_scan_root_bus() now having all the info needed to do successful
> > setup of scanned devices.
> 
> Why can't we add a hook like pci_bus_assign_domain_nr(), say:
> 
> pci_bus_msi_init()
> 
> in pci_create_root_bus() that does what Suravee wants in a generic way ?

Because even pci_bus_assign_domain_nr() was not really generic until your patches (small steps, etc).

We need a patch that proposes that and we can discuss it. 

> 
> What am I missing ?

Other than the fact that we need to sort out the initialisation order of all these components, nothing I guess.

Best regards,
Liviu

> 
> Lorenzo
> 
> > 
> > Best regards,
> > Liviu
> > 
> > > 
> > > >  static struct pci_ops gen_pci_ops = {
> > > >  	.read	= gen_pci_config_read,
> > > >  	.write	= gen_pci_config_write,
> > > > +	.set_msi_parent = gen_pci_set_msi_parent,
> > > >  };
> > > >  
> > > >  static const struct of_device_id gen_pci_of_match[] = {
> > > > @@ -313,6 +324,9 @@ static int gen_pci_probe(struct platform_device *pdev)
> > > >  		return err;
> > > >  	}
> > > >  
> > > > +	pci->mchip = of_pci_find_msi_chip_by_node(of_parse_phandle(np,
> > > > +						  "msi-parent", 0));
> > > 
> > > This bit should be in the generic of_pci.c code and not duplicated for
> > > each host controller.
> > > 
> > > Will
> > > 
> > 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934436Ab3CHQj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 11:39:29 -0500
Received: from service87.mimecast.com ([91.220.42.44]:42258 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab3CHQj2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 11:39:28 -0500
Date: Fri, 8 Mar 2013 16:39:24 +0000
From: Andrew Murray <andrew.murray@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [RFC PATCH RESEND v2] of/pci: Provide support for parsing PCI
 DT ranges property
Message-ID: <20130308163924.GA2665@arm.com>
References: <1362140616-19346-1-git-send-email-Andrew.Murray@arm.com>
 <5130C59E.8020702@gmail.com>
MIME-Version: 1.0
In-Reply-To: <5130C59E.8020702@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 08 Mar 2013 16:39:26.0029 (UTC) FILETIME=[7EF95FD0:01CE1C1B]
X-MC-Unique: 113030816392518701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 03:13:34PM +0000, Rob Herring wrote:
> On 03/01/2013 06:23 AM, Andrew Murray wrote:
> > This patch factors out common implementations patterns to reduce overall kernel
> > code and provide a means for host bridge drivers to directly obtain struct
> > resources from the DT's ranges property without relying on architecture specific
> > DT handling. This will make it easier to write archiecture independent host bridge
> > drivers and mitigate against further duplication of DT parsing code.
> > 
> > This patch can be used in the following way:
> > 
> > 	struct of_pci_range_iter iter;
> > 	for_each_of_pci_range(&iter, np) {
> > 
> > 		//directly access properties of the address range, e.g.:
> > 		//iter.pci_space, iter.pci_addr, iter.cpu_addr, iter.size or
> > 		//iter.flags
> > 
> > 		//alternatively obtain a struct resource, e.g.:
> > 		//struct resource res;
> > 		//range_iter_fill_resource(iter, np, res);
> > 	}
> > 
> > Additionally the implementation takes care of adjacent ranges and merges them
> > into a single range (as was the case with powerpc and microblaze).
> > 
> > The modifications to microblaze, mips and powerpc have not been tested.
> > 
> > v2:
> >   This follows on from suggestions made by Grant Likely
> >   (marc.info/?l=linux-kernel&m=136079602806328)
> > 
> > Signed-off-by: Andrew Murray <Andrew.Murray@arm.com>
> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> > ---
> >  arch/microblaze/pci/pci-common.c |  100 +++++++++++--------------------------
> >  arch/mips/pci/pci.c              |   44 ++++-------------
> >  arch/powerpc/kernel/pci-common.c |   93 ++++++++++-------------------------
> >  drivers/of/address.c             |   54 ++++++++++++++++++++
> >  include/linux/of_address.h       |   30 +++++++++++
> >  5 files changed, 151 insertions(+), 170 deletions(-)
> 
> The thing is that this still leaves pci_process_bridge_OF_ranges
> basically identical for microblaze and powerpc which is really what
> needs to be moved out to common code. Obviously, struct pci_controller
> vs. struct pci_sys_data on ARM is an issue, but they all have
> fundamentally the same data.
> 
> All these common fields should be in a common PCI controller struct.
> Perhaps introducing this with just what you need would work. Depending
> how invasive moving those fields to a new struct is, you could have a
> wrapper that just copies/translates the fields to the arch specific struct.
> 
> There's also things like ioremap of the i/o range. ARM uses a fixed
> virtual address, so we need to do something different. Just returning
> the i/o cpu_addr and moving the ioremap out of this function would solve
> that.

This is my current thinking...

 - Move struct pci_controller from arch/powerpc/include/asm/pci-bridge.h to
   include/linux/pci-bridge and rename (struct pci_controller_generic). Remove
   struct pci_controller from arch/microblaze/include/asm/pci-bridge.h.

   The powerpc struct pci_controller is a superset of the microblaze struct
   pci_controller. Doing this will allow two architectures to share a common
   implementation of a struct pci_controller. #ifdef's can be used to remove
   extra powerpc fields in the structure (they aren't many).

 - Provide a common implementation of pci_process_bridge_OF_range. This would
   use the for_each_of_pci_range macro to populate a struct pci_controller,
   this would remove duplicate code between microblaze and powerpc. The common
   implementation could use a Kconfig option to enable/disable handling the ISA
   hole (for architectures that don't need/want it). The caller can worry
   about ioremap.

 - Other architectures (mips, ARM) could use this common implementation of
   pci_process_bridge_OF_range in the future but at present they can use
   for_each_of_pci_range (as shown in this patch).
   
This reduces duplicated code, gives ARM a means of parsing PCI DT and provides
a starting point for getting ARM's pci_sys_data more inline with powerpc and
microblaze. Perhaps with a common controller structure - other areas of code
can also be factored out - for example functions like
pcibios_setup_phb_resources, etc - these are probably only arch specific due to
their use of the arch specific pci_controller struct.

Do you think this is a sensible direction?

Andrew Murray


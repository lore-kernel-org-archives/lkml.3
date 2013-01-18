Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216Ab3ARJS6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 04:18:58 -0500
Received: from service87.mimecast.com ([91.220.42.44]:38018 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab3ARJSy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 04:18:54 -0500
Date: Fri, 18 Jan 2013 09:18:47 +0000
From: Andrew Murray <andrew.murray@arm.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 10/14] PCI: tegra: Move PCIe driver to drivers/pci/host
Message-ID: <20130118091847.GA7171@arm.com>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <20130115154038.GA11241@arm.com>
 <20130115211441.GA13139@avionic-0098.adnet.avionic-design.de>
 <201301161400.26587.arnd@arndb.de>
 <20130116161716.GA10630@arm.com>
 <20130116183101.GA28660@avionic-0098.adnet.avionic-design.de>
 <20130117154236.GA25943@arm.com>
 <20130117160501.GC2186@avionic-0098.adnet.avionic-design.de>
 <20130117162218.GA29016@arm.com>
 <20130117203010.GA24584@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
In-Reply-To: <20130117203010.GA24584@avionic-0098.adnet.avionic-design.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 18 Jan 2013 09:18:49.0032 (UTC) FILETIME=[D30E0480:01CDF55C]
X-MC-Unique: 113011809185005101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 08:30:10PM +0000, Thierry Reding wrote:
> On Thu, Jan 17, 2013 at 04:22:18PM +0000, Andrew Murray wrote:
> > On Thu, Jan 17, 2013 at 04:05:02PM +0000, Thierry Reding wrote:
> > > On Thu, Jan 17, 2013 at 03:42:36PM +0000, Andrew Murray wrote:
> > > > On Wed, Jan 16, 2013 at 06:31:01PM +0000, Thierry Reding wrote:
> > > > > Alright, putting the functions into pci_ops doesn't sound like a very
> > > > > good idea then. Or perhaps it would make sense for hardware where the
> > > > > root complex and the MSI controller are handled by the same driver.
> > > > > Basically it could be done as a shortcut and if those are not filled
> > > > > in, the drivers could still opt to look up an MSI controller from a
> > > > > phandle specified in DT.
> > > > > 
> > > > > Even another alternative would be to keep the functions within the
> > > > > struct pci_ops and use generic ones if an external MSI controller is
> > > > > used. Just tossing around ideas.
> > > > 
> > > > I think an ideal solution would be for additional logic in drivers/msi.c
> > > > (e.g. in functions like msi_capability_init) to determine (based on the
> > > > passed in pci_dev) which MSI controller ops to use. I'm not sure the best
> > > > way to implement an association between an MSI controller and PCI busses
> > > > (I believe arch/sparc does something like this - perhaps there will be
> > > > inspiration there).
> > > > 
> > > > As you've pointed out, most RCs will have their own MSI controllers - so
> > > > it should be easy to register and associate both together.
> > > > 
> > > > I've submitted my previous work on MSI controller registration, but it
> > > > doesn't quite solve this problem - perhaps it can be a starting point?
> > > 
> > > We basically have two cases:
> > > 
> > >   - The PCI host bridge contains registers for MSI support. In that case
> > >     it makes little sense to uncouple the MSI implementation from the
> > >     host bridge driver.
> > > 
> > >   - An MSI controller exists outside of the PCI host bridge. The PCI
> > >     host bridge would in that case have to lookup an MSI controller (via
> > >     DT phandle or some other method).
> > > 
> > > In either of those cases, does it make sense to use the MSI support
> > > outside the scope of the PCI infrastructure? That is, would devices
> > > other than PCI devices be able to generate an MSI?
> > 
> > I've come around to your way of thinking. Your approach sounds good for
> > registration of MSI ops - let the RC host driver do it (it probably has its
> > own), or use a helper for following a phandle to get ops that are not part
> > of the driver. MSIs won't be used outside of PCI devices.
> > 
> > Though existing drivers will use MSI framework functions to request MSIs, that
> > will result in callbacks to the arch_setup_msi_irqs type functions. These
> > functions would need to be updated to find these new ops if they exist, i.e. by
> > traversing the pci_dev structure up to the RC and finding a suitable structure.
> > 
> > Perhaps the msi ops could live alongside pci_ops in the pci_bus structure. This
> > way when traversing up the buses from the provided pci_dev - the first bus with
> > msi ops populated would be used?
> > 
> > If no ops are found, the standard arch callbacks can be called - thus preserving
> > exiting functionality.
> 
> Yes, what you describe is exactly what I had in mind. I've been thinking
> about a possible implementation and there may be some details that could
> prove difficult to resolve. For instance, we likely need to pass context
> around for the MSI ops, or else make sure that they can find the context
> from the struct pci_dev or by traversing upwards from it.
> 
> I think for the case where the MSI hardware is controlled by the same
> driver as the PCI host bridge, doing this is easy because the context
> could be part of the PCI host bridge context, which in case of Tegra is
> stored in struct pci_bus' sysdata field (which is actually an ARM struct
> pci_sys_data and in turn stores a pointer to the struct tegra_pcie in
> the .private_data field). Other drivers often just use a global variable
> assuming that there will only ever be a single instance of the PCI host
> bridge.

Yes.

> If the MSI controller is external to the PCI host bridge, things get a
> little more complicated. The easiest way would probably be to store the
> context along with the PCI host bridge context and use simple wrappers
> around the actual implementations to retrieve the PHB context and pass
> the attached MSI context.

This would be nice, but may not be necessary. The MSI controller could use
a global (file-scope) variable to hold context gained from its probe and
assume it will be the only instance of that MSI controller.

> 
> Maybe this could even be made more generic by adding a struct msi_ops *
> along with a struct msi_chip * in struct pci_bus. Perhaps I should try
> and code something up to make things more concrete.

This would be the most complete way to handle this.

Andrew Murray



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab3ANJ5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 04:57:12 -0500
Received: from service87.mimecast.com ([91.220.42.44]:56338 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663Ab3ANJ5K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 04:57:10 -0500
Date: Mon, 14 Jan 2013 09:57:07 +0000
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
Message-ID: <20130114095706.GA23467@arm.com>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <20130111154516.GA25335@avionic-0098.adnet.avionic-design.de>
 <20130112123640.GA22505@avionic-0098.adnet.avionic-design.de>
 <201301122112.25772.arnd@arndb.de>
 <20130113095806.GA31966@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
In-Reply-To: <20130113095806.GA31966@avionic-0098.adnet.avionic-design.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 14 Jan 2013 09:57:07.0775 (UTC) FILETIME=[838F5CF0:01CDF23D]
X-MC-Unique: 113011409570806001
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2013 at 09:58:06AM +0000, Thierry Reding wrote:
> On Sat, Jan 12, 2013 at 09:12:25PM +0000, Arnd Bergmann wrote:
> > On Saturday 12 January 2013, Thierry Reding wrote:
> > > > I already hinted at that in one of the other subthreads. Having such a
> > > > multiplex would also allow the driver to be built as a module. I had
> > > > already thought about this when I was working on an earlier version of
> > > > these patches. Basically these would be two ops attached to the host
> > > > bridge, and the generic arch_setup_msi_irq() could then look that up
> > > > given the struct pci_dev that is passed to it and call this new per-
> > > > host bridge .setup_msi_irq().
> > > 
> > > struct pci_ops looks like a good place to put these. They'll be
> > > available from each struct pci_bus, so should be easy to call from
> > > arch_setup_msi_irq().
> > > 
> > > Any objections?
> > > 
> > 
> > struct pci_ops has a long history of being specifically about
> > config space read/write operations, so on the one hand it does
> > not feel like the right place to put interrupt specific operations,
> > but on the other hand, the name sounds appropriate and I cannot
> > think of any other place to put this, so it's fine with me.
> > 
> > The only alternative I can think of is to introduce a new
> > structure next to it in struct pci_bus, but that feels a bit
> > pointless. Maybe Bjorn has a preference one way or the other.
> 
> The name pci_ops is certainly generic enough. Also the comment above the
> structure declaration says "Low-level architecture-dependent routines",
> which applies to the MSI functions as well.

I've previously looked into this. It seems that architectures handle this
in different ways, some use vector tables, others use a multiplex and others
just let the end user implement the callback directly.

I've made an attempt to find a more common way. Though my implementation, which
I will try to share later today for reference provides a registration function
in drivers/pci/msi.c to provide implementations of the
(setup|teardown)_msi_irq(s) ops. This seems slightly better than the current
approach and doesn't break existing users - but is still ugly.

At present the PCI and MSI frameworks are largely uncoupled from each other and
so I was keen to not pollute PCI structures (e.g. pci_ops) with MSI ops. Just
because most PCI host bridges also provide MSI support I don't think there is a
reason why they should always come as a pair or be provided by the same chip.

Perhaps the solution is to support MSI controller drivers and a means to
associate them with PCI host controller drivers?

Andrew Murray



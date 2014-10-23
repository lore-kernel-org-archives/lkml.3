Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbaJWL1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 07:27:46 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36729 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916AbaJWL1l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:27:41 -0400
Date: Thu, 23 Oct 2014 12:27:31 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        jgunthorpe@obsidianresearch.com
Subject: Re: [RFC 2/4] PCI: generic: Add support for ARM64 and MSI(x)
Message-ID: <20141023112731.GA5823@e102568-lin.cambridge.arm.com>
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com>
 <3256560.C0cZnIlnAv@wuerfel>
 <20141022155914.GB25939@e102568-lin.cambridge.arm.com>
 <2148776.X8NPqiYA6S@wuerfel>
 <20141023091309.GF25302@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
In-Reply-To: <20141023091309.GF25302@e106497-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 23 Oct 2014 11:27:35.0250 (UTC) FILETIME=[57DA9320:01CFEEB4]
X-MC-Unique: 114102312273610501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 10:13:09AM +0100, Liviu Dudau wrote:
> On Wed, Oct 22, 2014 at 09:52:19PM +0100, Arnd Bergmann wrote:
> > On Wednesday 22 October 2014 16:59:14 Lorenzo Pieralisi wrote:
> > > On Wed, Oct 01, 2014 at 10:38:45AM +0100, Arnd Bergmann wrote:
> > > 
> > > [...]
> > > 
> > > > The arm32 implementations of pci_domain_nr/pci_proc_domain can probably be
> > > > removed if we change the arm32 pcibios_init_hw function to call the new
> > > > interfaces that set the domain number.
> > > 
> > > I wished, but it is a bit more complicated than I thought unfortunately,
> > > mostly because some drivers, eg cns3xxx set the domain numbers
> > > statically in pci_sys_data and this sets a chain of dependency that is
> > > not easy to untangle. I think cns3xxx is the only legacy driver that "uses"
> > > the domain number (in pci_sys_data) in a way that clashes with the
> > > generic domain_nr implementation, I need to give it more thought.
> > 
> > Just had a look at that driver, shouldn't be too hard to change, see below.
> 
> I like this!
> 
> One thing though ...

I like it too, it is one way of removing the artificial domain dependency
from this driver.

I think that by removing that, we could switch to CONFIG_PCI_DOMAINS_GENERIC
on ARM32. I will remove the dependency in drivers/pci/host/pci-mvebu.c
introduced by commit 2613ba48. pci_sys_data.domain is always 0 in that
driver so its usefulness is doubtful, comments welcome, copied Jason in
if he has comments.

[...]

> > @@ -323,6 +309,14 @@ static int cns3xxx_pcie_abort_handler(unsigned long addr, unsigned int fsr,
> >  void __init cns3xxx_pcie_init_late(void)
> >  {
> >  	int i;
> > +	void *private_data;
> > +	struct hw_pci hw_pci = {
> > +		.nr_controllers = 1,
> > +		.ops = &cns3xxx_pcie_ops,
> > +		.setup = cns3xxx_pci_setup,
> > +		.map_irq = cns3xxx_pcie_map_irq,
> > +		.private_data = &private_data,
> > +	};
> >  
> >  	pcibios_min_io = 0;
> >  	pcibios_min_mem = 0;
> > @@ -335,7 +329,9 @@ void __init cns3xxx_pcie_init_late(void)
> >  		cns3xxx_pwr_soft_rst(0x1 << PM_SOFT_RST_REG_OFFST_PCIE(i));
> >  		cns3xxx_pcie_check_link(&cns3xxx_pcie[i]);
> >  		cns3xxx_pcie_hw_init(&cns3xxx_pcie[i]);
> > -		pci_common_init(&cns3xxx_pcie[i].hw_pci);
> > +		hw_pci->domain = i;

+		hw_pci.domain = i;

I will remove this since if we move to generic domains it is useless to
pass the value through hw_pci.

> > +		private_data = &cns3xxx_pcie[i];
> 
> Is this dance with pointers absolutely necessary? Does gcc though dishes at you
> for doing hw_pci->private_data = &cns3xxx_pcie[i] directly?

You can't, hw_pci.private_data is void **.

Lorenzo


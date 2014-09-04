Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaIDNkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 09:40:06 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36380 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaIDNkE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 09:40:04 -0400
Date: Thu, 4 Sep 2014 14:39:56 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] drivers: pci: convert generic host controller to DT host
 bridge creation API
Message-ID: <20140904133956.GA12351@e102568-lin.cambridge.arm.com>
References: <1407861695-25549-1-git-send-email-Liviu.Dudau@arm.com>
 <20140819120553.GA23128@arm.com>
MIME-Version: 1.0
In-Reply-To: <20140819120553.GA23128@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 04 Sep 2014 13:40:00.0176 (UTC) FILETIME=[B9285300:01CFC845]
X-MC-Unique: 114090414400102501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

sorry for the delay in replying (I was not copied in).

On Tue, Aug 19, 2014 at 01:05:54PM +0100, Will Deacon wrote:
> Hi guys,
> 
> On Tue, Aug 12, 2014 at 05:41:35PM +0100, Liviu Dudau wrote:
> > From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> > 
> > In order to consolidate DT configuration for PCI host controllers in the
> > kernel, a new API was introduced that allows creating a host bridge
> > and its PCI bus from DT, removing duplicated code present in the
> > majority of pci host driver implementations.
> > 
> > This patch converts the existing PCI generic host controller driver to
> > the new API. Most of the code parsing ranges and creating resources is
> > now delegated to of_create_pci_host_bridge() API which also triggers
> > a scan of the root bus.
> > 
> > The setup hook passed by the host controller code to the generic DT
> > layer completes the initialization by performing resource filtering
> > (ie it checks that at least one non-prefetchable memory resource is
> > present), remapping IO and configuration regions and initializing
> > the required PCI flags.
> 
> [...]
> 
> > -static void gen_pci_release_of_pci_ranges(struct gen_pci *pci)
> > -{
> > -	struct pci_host_bridge_window *win;
> > -
> > -	list_for_each_entry(win, &pci->resources, list)
> > -		release_resource(win->res);
> > -
> > -	pci_free_resource_list(&pci->resources);
> > -}
> 
> I take it Liviu's core patches take care of this clean-up now if we fail mid
> way through requesting the resources?

Liviu's core patches free the resource list, but do _not_ request the
resources (so they won't release them). This is still a moot point that
needs clarification.

> > -static int gen_pci_setup(int nr, struct pci_sys_data *sys)
> > +static int gen_pci_setup(struct pci_host_bridge *host,
> > +			 resource_size_t io_cpuaddr)
> >  {
> > -	struct gen_pci *pci = sys->private_data;
> > -	list_splice_init(&pci->resources, &sys->resources);
> > -	return 1;
> > +	int err;
> > +	struct pci_host_bridge_window *window;
> > +	u32 restype, prefetchable;
> > +	struct device *dev = host->dev.parent;
> > +	struct resource *iores = NULL;
> > +	bool res_valid = false;
> > +
> > +	list_for_each_entry(window, &host->windows, list) {
> > +		restype = window->res->flags & IORESOURCE_TYPE_BITS;
> > +		prefetchable = window->res->flags & IORESOURCE_PREFETCH;
> > +
> > +		/*
> > +		 * Require at least one non-prefetchable MEM resource
> > +		 */
> > +		if ((restype == IORESOURCE_MEM) && !prefetchable)
> > +			res_valid = true;
> > +
> > +		if (restype == IORESOURCE_IO)
> > +			iores = window->res;
> > +	}
> > +
> > +	if (!res_valid) {
> > +		dev_err(dev, "non-prefetchable memory resource required\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (iores) {
> > +		if (!PAGE_ALIGNED(io_cpuaddr))
> > +			return -EINVAL;
> 
> Why is this alignment check not in the core code? Probably a question for
> somebody like Arnd, but do we need to deal with multiple IO resources?
> Currently we'll just silently take the last one that we found, which doesn't
> sound ideal.

(1) Yes, the alignment check should be made in core code
(2) I could take the first IO resource and warn on multiple IO resources if
    they are detected. Thoughts ?

> > +		if (err)
> > +			return err;
> > +	}
> > +
> > +	/* Parse and map our Configuration Space windows */
> > +	err = gen_pci_parse_map_cfg_windows(host);
> > +	if (err)
> > +		return err;
> > +
> > +	pci_add_flags(PCI_ENABLE_PROC_DOMAINS);
> > +	pci_add_flags(PCI_REASSIGN_ALL_BUS | PCI_REASSIGN_ALL_RSRC);
> 
> Why does this belong in the host controller driver and how does it interact
> with the probe-only property?

That's a very good question and it is one that confuses me too.

Current code in pci_common_init_dev() sets PCI_REASSIGN_ALL_RSRC behind
our backs silently. That flag has a side effect only if the probing code
detects PCI bridges in the list of devices, since PCI core probing code
will try to reassign the bus numbers upon PCI bridge detection IIUC. I do
not think that PCI_REASSIGN_ALL_BUS has any side effect on ARM (by grepping
around I noticed that PCI_REASSIGN_ALL_RSRC is used in

pcibios_assign_all_busses()

which in turn is triggered only if PCI bridges are detected, still grokking
the code though).

Apart from the PCI_ENABLE_PROC_DOMAINS flag which I think it is safe to
set by default (but let me check that too), I *think* that setting of

PCI_REASSIGN_ALL_BUS and PCI_REASSIGN_ALL_RSRC

should be set by DT, as the probe-only flag is. At the moment this is not a
problem (well...) since:

(a) PCI_REASSIGN_ALL_RSRC is forced by pcibios on ARM
(b) it has no implications on the generic host controller since it is
    run on kvmtools with no PCI bridge devices

If Bjorn or Arnd can help me understand the complete reasoning behind
those flags I would be very grateful and update code according to
Liviu's v10.

Thanks,
Lorenzo


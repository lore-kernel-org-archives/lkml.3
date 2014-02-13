Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbaBMEh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 23:37:56 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:38422 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbaBMEhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 23:37:54 -0500
Date: Thu, 13 Feb 2014 13:37:50 +0900
From: Simon Horman <horms@verge.net.au>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-pci@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        valentine.barshak@cogentembedded.com, ben.dooks@codethink.co.uk
Subject: Re: [PATCH 00/04] PCI: rcar: Driver model and physical address space
 update
Message-ID: <20140213043750.GA11908@verge.net.au>
References: <20140205065243.29445.76593.sendpatchset@w520>
 <20140212205911.GB5554@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212205911.GB5554@google.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 01:59:11PM -0700, Bjorn Helgaas wrote:
> On Wed, Feb 05, 2014 at 03:52:43PM +0900, Magnus Damm wrote:
> > PCI: rcar: Driver model and physical address space update
> > 
> > [PATCH 01/04] PCI: rcar: Register each instance independently
> > [PATCH 02/04] PCI: rcar: Break out window size handling
> > [PATCH 03/04] PCI: rcar: Add DMABOUNCE support
> > [PATCH 04/04] PCI: rcar: Enable BOUNCE in case of HIGHMEM
> > 
> > These patches update the pci-rcar-gen2.c driver in various ways
> > including cleanups for driver model interface (1/4), readability
> > update (2/4) and also bounce buffer support (3/4, 4/4). Basically
> > the first two are just cleanups and the rest are fixes.
> > 
> > As it is today without these patches the system memory start address
> > is hard coded at 0x4000000 and the window is fixed at 1GiB. So we
> > have board specific code hidden in the driver which is good to avoid.
> > 
> > With these hard coded board specific constants there are some error cases
> > that are not handled, in particular the issue that only maximum 1GiB of
> > physical address space can be used for bus mastering with a single window.
> > The common case of using ARM CONFIG_VMSPLIT_3G results in no visible issues
> > as long as CONFIG_BOUNCE is used, but other CONFIG_VMSPLIT settings will
> > break due to the hard coded 1GiB window not being enough. It has been
> > verified that reducing the window size to 256MB makes the driver behave
> > the same with VMSPLIT_3G as 1GiB window size and other VMSPLIT settings.
> > 
> > To handle the maximum 1GiB physical address space limitation two types
> > of bounce buffers are added. The ARM specific DMABOUNCE code is in 3/4
> > hooked up to a chunk of local memory that is also handed of as coherent
> > memory to the pci devices hanging off the PCI bridge. The driver makes
> > sure to set the window so the local memory is always included. When the
> > PCI devices are operating and in case memory is used outside the window
> > then the DMABOUNCE buffers kicks in. This makes the driver support all
> > kinds of VMSPLIT settings and window sizes. The BOUNCE code in 4/4 is
> > selected to make sure bounce buffers are used for HIGHMEM.
> > 
> > With these patches this driver can be used with or without CMA and
> > with or without DMA zone. Basically the system wide memory setup is
> > left to the user. If a DMA zone is used then the PCI window will
> > be setup to cover that. Same thing with CMA.
> > 
> > Tested with USB storage using LPAE and various VMSPLIT settings together
> > with renesas git tag renesas-devel-v3.14-rc1-20140204 from kernel.org
> > 
> > Signed-off-by: Magnus Damm <damm@opensource.se>
> > ---
> > 
> >  Written against renesas.git tag renesas-devel-v3.14-rc1-20140204
> > 
> >  drivers/pci/host/Kconfig         |    3 
> >  drivers/pci/host/pci-rcar-gen2.c |  367 +++++++++++++++++++++++++++++++-------
> >  2 files changed, 306 insertions(+), 64 deletions(-)
> 
> Simon, if you want to ack these, I'll be happy to merge them for v3.15.
> I'm not really qualified to review them myself.

Hi Bjorn,

Magnus has reposted these patches as part of a larger series
which includes some patches of his own. That series is
"[PATCH 00/08] PCI: rcar: Recent driver patches from Ben Dooks and me".
I am happy with it and will Ack it. Could you consider merging it?

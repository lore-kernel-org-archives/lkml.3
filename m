Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab3GaT5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 15:57:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760675Ab3GaT46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 15:56:58 -0400
Date: Wed, 31 Jul 2013 15:56:23 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Takao Indoh <indou.takao@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "ishii.hironobu@jp.fujitsu.com" <ishii.hironobu@jp.fujitsu.com>,
        Don Dutile <ddutile@redhat.com>,
        "Sumner, William" <bill.sumner@hp.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Haren Myneni <hbabu@us.ibm.com>
Subject: Re: [PATCH v2] PCI: Reset PCIe devices to stop ongoing DMA
Message-ID: <20130731195622.GC1577@redhat.com>
References: <CAErSpo5u8qGALt6C+tuPYXdd2YgyMH6fnPnA+afUteEZ7kY0iw@mail.gmail.com>
 <51B93221.2040505@jp.fujitsu.com>
 <CAErSpo5tVK-Z3aOdMTzab-S8o5zLVtDOFQ8-LSYpUgbrJSsxuw@mail.gmail.com>
 <51BA7BB6.1080104@jp.fujitsu.com>
 <51EF7466.20703@jp.fujitsu.com>
 <CAErSpo5B7NzVfxwW3bQnfK+iK+DrRsWQd2Cm14z5PWNnRHWL5w@mail.gmail.com>
 <51F5B966.9080405@jp.fujitsu.com>
 <CAErSpo4JtG5qVJb-nCywe3vkft=-cDeRDKn_V92RCZ-sGXpwbg@mail.gmail.com>
 <51F758B6.9090204@jp.fujitsu.com>
 <CAErSpo7TNhQO0dx_xZvF=dU2fSWTFf8x=xUJcEsbadJkv8ktuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo7TNhQO0dx_xZvF=dU2fSWTFf8x=xUJcEsbadJkv8ktuQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 09:59:16AM -0600, Bjorn Helgaas wrote:
> On Tue, Jul 30, 2013 at 12:09 AM, Takao Indoh
> <indou.takao@jp.fujitsu.com> wrote:
> > (2013/07/29 23:17), Bjorn Helgaas wrote:
> >> On Sun, Jul 28, 2013 at 6:37 PM, Takao Indoh <indou.takao@jp.fujitsu.com> wrote:
> >>> (2013/07/26 2:00), Bjorn Helgaas wrote:
> 
> >>>> My point about IOMMU and PCI initialization order doesn't go away just
> >>>> because it doesn't fit "kdump policy."  Having system initialization
> >>>> occur in a logical order is far more important than making kdump work.
> >>>
> >>> My next plan is as follows. I think this is matched to logical order
> >>> on boot.
> >>>
> >>> drivers/pci/pci.c
> >>> - Add function to reset bus, for example, pci_reset_bus(struct pci_bus *bus)
> >>>
> >>> drivers/iommu/intel-iommu.c
> >>> - On initialization, if IOMMU is already enabled, call this bus reset
> >>>    function before disabling and re-enabling IOMMU.
> >>
> >> I raised this issue because of arches like sparc that enumerate the
> >> IOMMU before the PCI devices that use it.  In that situation, I think
> >> you're proposing this:
> >>
> >>    panic kernel
> >>      enable IOMMU
> >>      panic
> >>    kdump kernel
> >>      initialize IOMMU (already enabled)
> >>        pci_reset_bus
> >>        disable IOMMU
> >>        enable IOMMU
> >>      enumerate PCI devices
> >>
> >> But the problem is that when you call pci_reset_bus(), you haven't
> >> enumerated the PCI devices, so you don't know what to reset.
> >
> > Right, so my idea is adding reset code into "intel-iommu.c". intel-iommu
> > initialization is based on the assumption that enumeration of PCI devices
> > is already done. We can find target device from IOMMU page table instead
> > of scanning all devices in pci tree.
> >
> > Therefore, this idea is only for intel-iommu. Other architectures need
> > to implement their own reset code.
> 
> That's my point.  I'm opposed to adding code to PCI when it only
> benefits x86 and we know other arches will need a fundamentally
> different design.  I would rather have a design that can work for all
> arches.

I agree. It makes sense to work on a design which works for all
arches.

And that's when I feel that handling this problem at IOMMU level
makes more sense, if we can.

Thanks
Vivek

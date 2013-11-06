Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab3KFSA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 13:00:56 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:18067 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab3KFSAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 13:00:54 -0500
Date: Wed, 6 Nov 2013 13:00:43 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xen-devel <xen-devel@lists.xen.org>, Feng Jin <joe.jin@oracle.com>,
        Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>,
        Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 2/3] PCI: Refactor MSI/MSIX mask restore code to fix
 interrupt lost issue
Message-ID: <20131106180043.GG17101@phenom.dumpdata.com>
References: <525E3320.5080700@oracle.com>
 <20131029215848.GA15159@google.com>
 <52706CF8.1090409@oracle.com>
 <20131105143223.GA3550@phenom.dumpdata.com>
 <5279A191.9030807@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5279A191.9030807@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 09:55:29AM +0800, Zhenzhong Duan wrote:
> 
> On 2013-11-05 22:32, Konrad Rzeszutek Wilk wrote:
> >On Wed, Oct 30, 2013 at 10:20:40AM +0800, Zhenzhong Duan wrote:
> >>On 2013-10-30 05:58, Bjorn Helgaas wrote:
> >>>On Wed, Oct 16, 2013 at 02:33:04PM +0800, Zhenzhong Duan wrote:
> >>>>Driver init call graph under baremetal:
> >>>>driver_init->
> >>>>     msix_capability_init->
> >>>>         msix_program_entries->
> >>>>             msix_mask_irq->
> >>>>                 entry->masked = 1
> >>>>     request_irq->
> >>>>         __setup_irq->
> >>>>             irq_startup->
> >>>>                 unmask_msi_irq->
> >>>>                     msix_mask_irq->
> >>>>                         entry->masked = 0;
> >>>>
> >>>>So entry->masked is always updated with newest value and its value could be used
> >>>>to restore to mask register in device.
> >>>>
> >>>>But in initial domain (aka priviliged guest), it's different.
> >>>>Driver init call graph under initial domain:
> >>>>driver_init->
> >>>>     msix_capability_init->
> >>>>         msix_program_entries->
> >>>>             msix_mask_irq->
> >>>>                 entry->masked = 1
> >>>>     request_irq->
> >>>>         __setup_irq->
> >>>>             irq_startup->
> >>>>                 __startup_pirq->
> >>>>                     EVTCHNOP_bind_pirq hypercall    (trap into Xen)
> >>>>[Xen:]
> >>>>pirq_guest_bind->
> >>>>     startup_msi_irq->
> >>>>         unmask_msi_irq->
> >>>>             msi_set_mask_bit->
> >>>>                 entry->msi_attrib.masked = 0;
> >>The right mask value is saved in entry->msi_attrib.masked on Xen.
> >>>>So entry->msi_attrib.masked in xen side always has newest value. entry->masked
> >>>>in initial domain is untouched and is 1 after msix_capability_init.
> >>>If we run the following sequence:
> >>>
> >>>     pci_enable_msix()
> >>>     request_irq()
> >>>
> >>>don't we end up with the MSI IRQ unmasked if we're on bare metal but masked
> >>>if we're on Xen?  It seems like we'd want it unmasked in both cases, so I
> >>>expected your patch to do something to make it unmasked if we're on Xen.
> >>>But I don't think it does, does it?
> >>>
> >>>As far as I can tell, this patch only changes the pci_restore_state()
> >>>path.  I think that part makes sense.
> >>>
> >>>Bjorn
> >>It's unmasked on Xen too. This is just what this patch try to fix.
> >>In PHYSDEVOP_restore_msi hypercall, xen did the right thing that did
> >>by kernel in baremetal.
> >Part of this problem is that all of the interrupt vector setting (either
> >be it GSI, MSI or MSI-X) is handled by the hypervisor. That means the kernel
> >consults the hypervisor for the right 'vector' value for all of the different
> >types of interrupts. And that 'vector' value is not even used - the interrupts
> >first hit the hypervisor - which dispatches them to the guest via a software
> >event channel mechanism (a bitmap of 'active' events - and an event can be
> >tied to a physical interrupt or an IPI, etc).
> Yes, for below sequence, request_irq calls EVTCHNOP_bind_pirq
> hypercall and Xen will
> get MSI IRQ unmasked.
> 
>       pci_enable_msix()
>       request_irq()
> 
> >Even more recently we have been clamping down - so that the kernel pagetables
> >for the MSI-X tables for example are R/O - so it can't write (or over-write)
> >with a different vector value (or the same one). The hypervisor is the one
> >that does this change.
> >
> >Perhaps a different way of fixing this is making the '__msi_mask_irq' and
> >'__msix_mask_irq' be part of the x86.msi function ops? And then the platform
> >can over-write it with its own mechanism for masking/unmasking? (and in case
> >of Xen it would be a nop as that has already been done by the hypervisor?)
> The idea looks good

Thank you.
> >The 'write_msi_msg' we don't have to worry about as it is only used by
> >default_restore_msi_irqs (which is part of the x86.msi and can be over-written).
> >
> >Perhaps something like this (Testing it right now):
> I'd suggest to test with qlogic card with which the bug only reproduce.

I tested it with an Intel NIC:
01:00.0 Ethernet controller: Intel Corporation 82576 Gigabit Network Connection (rev 01)

that can do SR-IOV. And it works nicely with baremetal and Xen (either initial
domain or a PV domain with PCI passthrough). And for baremetal the NIC
works - I can do the netperf/netserver thing.

This patch also fixes a bootup crash when launching a Linux PV guest
with said NIC card. The crash is:

[    5.618325] BUG: unable to handle kernel paging request at ffffc9000030600c
[    5.618330] IP: [<ffffffff8135e906>] msix_mask_irq+0x96/0xb0
[    5.618338] PGD 11f287067 PUD 11f288067 PMD 11f38c067 PTE 80100000fbc44465

B/c Xen marks the MSI-X as RO (the BAR is fbc44000) so that the guest
won't try to fiddle with it.

But msi.c does fiddle and ends up doing a writel to an RO virtual address
which naturally blows it apart. With this patch and the msix_mask_irq
becoming a nop it all works.

But its time to inquire about that QLogic card.

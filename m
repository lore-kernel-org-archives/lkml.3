Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676Ab3KOLqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 06:46:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:55361 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088Ab3KOLqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 06:46:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,707,1378882800"; 
   d="scan'208";a="433996743"
Date: Fri, 15 Nov 2013 13:52:35 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Andreas Noever <andreas.noever@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [3.11.4] Thunderbolt/PCI unplug oops in pci_pme_list_scan
Message-ID: <20131115115235.GA2281@intel.com>
References: <CAMxnaaUim-MCDpaTiLmBqN3wfxjn9V6XE_n4SMfuO=vqeT6rVA@mail.gmail.com>
 <CAErSpo4KU9VAC=SnKuYH3EPz8NuozixAhUQBKv+=Y=76wywdTg@mail.gmail.com>
 <20131015024452.GA31951@srcf.ucam.org>
 <20131016202123.GA17866@google.com>
 <CAMxnaaV1DhaxKo6h85Upa8sPQz2jSYSaW1OJ7+JtvR5F9sAYZw@mail.gmail.com>
 <CAErSpo4q0rcvkHX3_L2rcJrwT-Ofu4My8JXxtxH8gyULLxTDEw@mail.gmail.com>
 <CAE9FiQUMKSak4tWiyZ-N1_50M5ytUp-JAhb7GTG29Y1aRBPuSQ@mail.gmail.com>
 <CAErSpo5yhg1EgJmmOtJeh0myd50tJuu6qVMdVnwR276WTxL8kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo5yhg1EgJmmOtJeh0myd50tJuu6qVMdVnwR276WTxL8kg@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 09:33:50PM -0600, Bjorn Helgaas wrote:
> On Wed, Oct 23, 2013 at 11:53 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Tue, Oct 22, 2013 at 8:32 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> >> On Thu, Oct 17, 2013 at 7:59 AM, Andreas Noever <andreas.noever@gmail.com> wrote:
> >>> On Wed, Oct 16, 2013 at 10:21 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> >>>> On Tue, Oct 15, 2013 at 03:44:52AM +0100, Matthew Garrett wrote:
> >>>>> On Mon, Oct 14, 2013 at 05:50:38PM -0600, Bjorn Helgaas wrote:
> >>>>> > On Mon, Oct 14, 2013 at 4:47 PM, Andreas Noever <andreas.noever@gmail.com> wrote:
> >>>>> > > When I unplug the Thunderbolt ethernet adapter on my MacBookPro Linux
> >>>>> > > crashes a few seconds later. Using
> >>>>> > > echo 1 > /sys/bus/pci/devices/0000:08:00.0/remove
> >>>>> > > to remove a bridge two levels above the device triggers the fault immediately:
> 
> >>>> We save a pci_dev pointer in the pci_pme_list, which of course has a
> >>>> longer lifetime than the pci_dev itself, but we don't acquire a reference
> >>>> on it, so I suspect the pci_dev got released before we got around to
> >>>> doing the pci_pme_list_scan().
> >>>>
> >>>> Andreas, can you try the patch below?  It's against v3.12-rc2, but it
> >>>> should apply to v3.11, too.
> >>>
> >>> I have tested your patch against 3.11 where it solves the problem. Thanks!
> >>>
> >>> Unfortunately I could not reproduce the problem in 3.12-rc5. I only
> >>> get the following warning (and no crash):
> >>>
> >>> tg3 0000:0a:00.0: PME# disabled
> >>> pcieport 0000:09:00.0: PME# disabled
> >>> pciehp 0000:09:00.0:pcie24: unloading service driver pciehp
> >>> pci_bus 0000:0a: dev 00, dec refcount to 0
> >>> pci_bus 0000:0a: dev 00, released physical slot 9
> >>> ------------[ cut here ]------------
> >>> WARNING: CPU: 0 PID: 122 at drivers/pci/pci.c:1430
> >>> pci_disable_device+0x84/0x90()
> >>> Device pcieport
> >>> disabling already-disabled device
> >>> ...
> 
> >>> Bisection points to 928bea964827d7824b548c1f8e06eccbbc4d0d7d .
> >>
> >> This is "PCI: Delay enabling bridges until they're needed" by Yinghai.
> >
> > that double disabling should be addressed by:
> >
> > https://lkml.org/lkml/2013/4/25/608
> >
> > [PATCH] PCI: Remove duplicate pci_disable_device for pcie port
> 
> I'll look at that patch again.  I had some questions about it the
> first time, but perhaps it makes more sense after 928bea9648 has been
> applied.

Bjorn,

Are there any plans to apply the above patch?

I'm seeing that warning on all my TBT test machines:

[  122.914180] pcieport 0000:06:05.0: PME# disabled
[  122.915386] ------------[ cut here ]------------
[  122.916513] WARNING: CPU: 0 PID: 1060 at drivers/pci/pci.c:1430 pci_disable_device+0x7c/0x90()
[  122.917589] Device pcieport
[  122.917589] disabling already-disabled device
[  122.918681] Modules linked in:
[  122.920803] CPU: 0 PID: 1060 Comm: kworker/0:2 Not tainted 3.12.0 #193
[  122.921877] Hardware name:                  /D33217CK, BIOS GKPPT10H.86A.0042.2013.0422.1439 04/22/2013
[  122.922989] Workqueue: kacpi_hotplug hotplug_event_work
[  122.924097]  0000000000000009 ffff88006de81ab0 ffffffff817ca961 ffff88006de81af8
[  122.925241]  ffff88006de81ae8 ffffffff810445c8 ffff88006ea15800 ffff88006ea15800
[  122.926385]  ffffffff81c5ac80 ffff88006ea14098 ffff88006eb35c28 ffff88006de81b48
[  122.927519] Call Trace:
[  122.928626]  [<ffffffff817ca961>] dump_stack+0x45/0x56
[  122.929757]  [<ffffffff810445c8>] warn_slowpath_common+0x78/0xa0
[  122.930884]  [<ffffffff81044637>] warn_slowpath_fmt+0x47/0x50
[  122.932003]  [<ffffffff812deb3d>] ? do_pci_disable_device+0x4d/0x60
[  122.933116]  [<ffffffff812debcc>] pci_disable_device+0x7c/0x90
[  122.934235]  [<ffffffff812ebfb5>] pcie_portdrv_remove+0x15/0x20
[  122.935345]  [<ffffffff812e0318>] pci_device_remove+0x28/0x60
[  122.936442]  [<ffffffff81424f24>] __device_release_driver+0x64/0xd0
[  122.937543]  [<ffffffff81424fae>] device_release_driver+0x1e/0x30
[  122.938636]  [<ffffffff81424837>] bus_remove_device+0xf7/0x140
[  122.939718]  [<ffffffff81421575>] device_del+0x135/0x1d0
[  122.940806]  [<ffffffff812db4c4>] pci_stop_bus_device+0x94/0xa0
[  122.941890]  [<ffffffff812db46b>] pci_stop_bus_device+0x3b/0xa0
[  122.942957]  [<ffffffff812db5cd>] pci_stop_and_remove_bus_device+0xd/0x20
[  122.944004]  [<ffffffff812f3992>] trim_stale_devices+0x62/0xc0
[  122.945034]  [<ffffffff812f39db>] trim_stale_devices+0xab/0xc0
[  122.946042]  [<ffffffff812f39db>] trim_stale_devices+0xab/0xc0
[  122.947034]  [<ffffffff812f3dbe>] acpiphp_check_bridge+0x7e/0xd0
[  122.948036]  [<ffffffff812f4bf2>] hotplug_event+0xf2/0x230
[  122.949042]  [<ffffffff8130dcf3>] ? acpi_os_release_object+0x9/0xd
[  122.950054]  [<ffffffff812f4d52>] hotplug_event_work+0x22/0x60
[  122.951067]  [<ffffffff8105da2a>] process_one_work+0x17a/0x430
[  122.952084]  [<ffffffff8105e619>] worker_thread+0x119/0x390
[  122.953095]  [<ffffffff8105e500>] ? manage_workers.isra.25+0x2a0/0x2a0
[  122.954107]  [<ffffffff810647bb>] kthread+0xbb/0xc0
[  122.955115]  [<ffffffff81064700>] ? kthread_create_on_node+0x110/0x110
[  122.956136]  [<ffffffff817db3fc>] ret_from_fork+0x7c/0xb0
[  122.957141]  [<ffffffff81064700>] ? kthread_create_on_node+0x110/0x110
[  122.958145] ---[ end trace a0dcbb3b178e4755 ]---

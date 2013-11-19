Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab3KSBdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 20:33:50 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:43579 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab3KSBdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 20:33:47 -0500
Date: Mon, 18 Nov 2013 18:33:43 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Andreas Noever <andreas.noever@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [3.11.4] Thunderbolt/PCI unplug oops in pci_pme_list_scan
Message-ID: <20131119013343.GA17294@google.com>
References: <CAMxnaaUim-MCDpaTiLmBqN3wfxjn9V6XE_n4SMfuO=vqeT6rVA@mail.gmail.com>
 <CAErSpo4KU9VAC=SnKuYH3EPz8NuozixAhUQBKv+=Y=76wywdTg@mail.gmail.com>
 <20131015024452.GA31951@srcf.ucam.org>
 <20131016202123.GA17866@google.com>
 <CAMxnaaV1DhaxKo6h85Upa8sPQz2jSYSaW1OJ7+JtvR5F9sAYZw@mail.gmail.com>
 <CAErSpo4q0rcvkHX3_L2rcJrwT-Ofu4My8JXxtxH8gyULLxTDEw@mail.gmail.com>
 <CAE9FiQUMKSak4tWiyZ-N1_50M5ytUp-JAhb7GTG29Y1aRBPuSQ@mail.gmail.com>
 <CAErSpo5yhg1EgJmmOtJeh0myd50tJuu6qVMdVnwR276WTxL8kg@mail.gmail.com>
 <20131115115235.GA2281@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131115115235.GA2281@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 01:52:35PM +0200, Mika Westerberg wrote:
> On Thu, Oct 24, 2013 at 09:33:50PM -0600, Bjorn Helgaas wrote:
> > On Wed, Oct 23, 2013 at 11:53 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > > On Tue, Oct 22, 2013 at 8:32 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > >> On Thu, Oct 17, 2013 at 7:59 AM, Andreas Noever <andreas.noever@gmail.com> wrote:
> > >>> On Wed, Oct 16, 2013 at 10:21 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > >>>> On Tue, Oct 15, 2013 at 03:44:52AM +0100, Matthew Garrett wrote:
> > >>>>> On Mon, Oct 14, 2013 at 05:50:38PM -0600, Bjorn Helgaas wrote:
> > >>>>> > On Mon, Oct 14, 2013 at 4:47 PM, Andreas Noever <andreas.noever@gmail.com> wrote:
> > >>>>> > > When I unplug the Thunderbolt ethernet adapter on my MacBookPro Linux
> > >>>>> > > crashes a few seconds later. Using
> > >>>>> > > echo 1 > /sys/bus/pci/devices/0000:08:00.0/remove
> > >>>>> > > to remove a bridge two levels above the device triggers the fault immediately:
> > 
> > >>>> We save a pci_dev pointer in the pci_pme_list, which of course has a
> > >>>> longer lifetime than the pci_dev itself, but we don't acquire a reference
> > >>>> on it, so I suspect the pci_dev got released before we got around to
> > >>>> doing the pci_pme_list_scan().
> > >>>>
> > >>>> Andreas, can you try the patch below?  It's against v3.12-rc2, but it
> > >>>> should apply to v3.11, too.
> > >>>
> > >>> I have tested your patch against 3.11 where it solves the problem. Thanks!
> > >>>
> > >>> Unfortunately I could not reproduce the problem in 3.12-rc5. I only
> > >>> get the following warning (and no crash):
> > >>>
> > >>> tg3 0000:0a:00.0: PME# disabled
> > >>> pcieport 0000:09:00.0: PME# disabled
> > >>> pciehp 0000:09:00.0:pcie24: unloading service driver pciehp
> > >>> pci_bus 0000:0a: dev 00, dec refcount to 0
> > >>> pci_bus 0000:0a: dev 00, released physical slot 9
> > >>> ------------[ cut here ]------------
> > >>> WARNING: CPU: 0 PID: 122 at drivers/pci/pci.c:1430
> > >>> pci_disable_device+0x84/0x90()
> > >>> Device pcieport
> > >>> disabling already-disabled device
> > >>> ...
> > 
> > >>> Bisection points to 928bea964827d7824b548c1f8e06eccbbc4d0d7d .
> > >>
> > >> This is "PCI: Delay enabling bridges until they're needed" by Yinghai.
> > >
> > > that double disabling should be addressed by:
> > >
> > > https://lkml.org/lkml/2013/4/25/608
> > >
> > > [PATCH] PCI: Remove duplicate pci_disable_device for pcie port
> > 
> > I'll look at that patch again.  I had some questions about it the
> > first time, but perhaps it makes more sense after 928bea9648 has been
> > applied.
> 
> Bjorn,
> 
> Are there any plans to apply the above patch?
> 
> I'm seeing that warning on all my TBT test machines:
> 
> [  122.914180] pcieport 0000:06:05.0: PME# disabled
> [  122.915386] ------------[ cut here ]------------
> [  122.916513] WARNING: CPU: 0 PID: 1060 at drivers/pci/pci.c:1430 pci_disable_device+0x7c/0x90()
> [  122.917589] Device pcieport
> [  122.917589] disabling already-disabled device

I fixed the changelog (the extra disable was actually added by d899871936,
not by dc5351784e) and put the patch below in my for-linus branch.  I'll
ask Linus to pull it later this week.

Sorry for the delay, and thanks for the reminder.

Bjorn


PCI: Remove duplicate pci_disable_device() from pcie_portdrv_remove()

From: Yinghai Lu <yinghai@kernel.org>

The pcie_portdrv .probe() method calls pci_enable_device() once, in
pcie_port_device_register(), but the .remove() method calls
pci_disable_device() twice, in pcie_port_device_remove() and in
pcie_portdrv_remove().

That causes a "disabling already-disabled device" warning when removing a
PCIe port device.  This happens all the time when removing Thunderbolt
devices, but is also easy to reproduce with, e.g.,
"echo 0000:00:1c.3 > /sys/bus/pci/drivers/pcieport/unbind"

This patch removes the disable from pcie_portdrv_remove().

[bhelgaas: changelog, tag for stable]
Reported-by: David Bulkow <David.Bulkow@stratus.com>
Reported-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: stable@vger.kernel.org	# v2.6.32+
---
 drivers/pci/pcie/portdrv_pci.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index cd1e57e51aa7..0d8fdc48e642 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -223,7 +223,6 @@ static int pcie_portdrv_probe(struct pci_dev *dev,
 static void pcie_portdrv_remove(struct pci_dev *dev)
 {
 	pcie_port_device_remove(dev);
-	pci_disable_device(dev);
 }
 
 static int error_detected_iter(struct device *device, void *data)

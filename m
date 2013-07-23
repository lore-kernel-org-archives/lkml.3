Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab3GWV3H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 17:29:07 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:36418 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754713Ab3GWV3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 17:29:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH 0/30] ACPI / hotplug / PCI: Major rework + Thunderbolt workarounds
Date: Tue, 23 Jul 2013 23:39:06 +0200
Message-ID: <3215120.cRBBS5jciE@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQVq3O45SOr9h6c5dBiAZs2Ry6z6L_irW8AE-fZ_1NmMXQ@mail.gmail.com>
References: <26431283.HJCKsss0rt@vostro.rjw.lan> <2366394.4EoP1MXmG2@vostro.rjw.lan> <CAE9FiQVq3O45SOr9h6c5dBiAZs2Ry6z6L_irW8AE-fZ_1NmMXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 22, 2013 11:49:45 PM Yinghai Lu wrote:
> On Wed, Jul 17, 2013 at 4:05 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Hi All,
> >
> > Now the series has been rebased on top of current linux-pm.git/linux-next
> > and tested on two systems with Thunderbolt.  Some changes have been made too. ->
> >
> > On Friday, July 12, 2013 01:34:20 AM Rafael J. Wysocki wrote:
> >> Hi,
> >>
> >> I've made some progress with my ACPIPHP rework since I posted the series last
> >> time and here goes an update.
> >>
> >> First off, the previous series was somewhat racy, which should be fixed now.
> >> Apart from this there's quite some new material on top of the patches I posted
> >> last time (or rather on top of their new versions) and I integrated the
> >> Thunderbolt series from Mika with that.  As a result,
> >>
> >> https://patchwork.kernel.org/patch/2817341/
> >>
> >> is required to be applied.
> >>
> >> Still untested, still based on 3.10 with ACPI+PM 3.11 material merged on top,
> >> but this time I don't have any plans to add more patches to the series for the
> >> time being.  Also 3.11-rc1 should be out in a couple of days, so I'll be able
> >> to integrate this work with the previous cleanups series from Gerry and myself
> >> on top of it.
> >>
> >> I did my best not to change too much at a time and some steps add stuff that
> >> is removed by the subsequent ones, so hopefully it is bisectable.
> >>
> >> If anyone finds something questionable or outright bogus in these patches,
> >> please let me know before it's too late. ;-)
> >>
> >> [ 1/30] Make bus registration and unregistration symmetric.  [Resend]
> >> [ 2/30] Consolidate acpiphp_enumerate_slots().  [Resend]
> >> [ 3/30] Fix error code path in register_slot().  [Resend]
> >> [ 4/30] Introduce hotplug context objects for ACPI device objects corresponding
> >>         to PCI hotplug devices.  [Update]
> >> [ 5/30] Unified notify handler for hotplug events.  [Update]
> >> [ 6/30] Drop acpiphp_handle_to_bridge() and use context objects instead of it.  [Update]
> >> [ 7/30] Pass entire hotplug context objects (instead of their fields
> >>         individually) to event handling work functions.  [Update]
> >> [ 8/30] Merge hotplug event handling functions.  [Update]
> >> [ 9/30] Drop func field from struct acpiphp_bridge.
> >> [10/30] Refactor slot allocation code in register_slot().
> >> [11/30] Make acpiphp_enumerate_slots() to register all devices on the given bus
> >>         and install the notification handler for all of them.
> >> [12/30] Drop sun field from struct acpiphp_slot.
> >> [13/30] Use common slot count variable in register_slot().
> >
> > -> The one above has been dropped, because it might cause regressions to appear
> > on some systems, but that's not a big deal.
> >
> > The numbering of the patches below has changed as a result, so the next one is
> > [13/30] now and so on.
> >
> >> [14/30] Drop flags field from struct acpiphp_bridge.
> >> [15/30] Embed function structure into struct acpiphp_context.
> >> [16/30] Drop handle field from struct acpiphp_func.
> >> [17/30] Drop handle field from struct acpiphp_bridge.
> >> [18/30] Store parent bridge pointer in function objects and bus pointer in slot
> >>         objects.
> >> [19/30] Rework ACPI namespace scanning and trimming routines.
> >> [20/30] Drop redundant checks from check_hotplug_bridge().
> >> [21/30] Consolidate slot disabling and ejecting
> >> [22/30] Do not queue up event handling work items for non-hotplug events.
> >> [23/30] Do not execute _PS0 and _PS3 directly.
> >
> > This one was fixed after Mika had reported a problem with it.
> >
> >> [24/30] Do not check SLOT_ENABLED in enable_device().  [Thunderbolt series]
> >> [25/30] Allow slots without new devices to be rescanned.  [Thunderbolt series]
> >> [26/30] Check for new devices on enabled slots.  [Thunderbolt series, TBD]
> >
> > This one was reworked to use acpi_bus_trim() on ACPI device objects
> > corresponding to PCI devices being removed (it also uses _STA to check the
> > status of those devices if available).
> >
> >> [27/30] Get rid of unused constands in acpiphp.h.  [Thunderbolt series]
> >> [28/30] Sanitize acpiphp_get_(latch)|(adapter)_status().  [Thunderbolt series]
> >> [29/30] Redefine enable_device() and disable_device() (rename and change to void).
> >> [30/30] Clean up the usage of bridge_mutex.
> >
> > The one above is [29/30] now and we have added one more patch:
> >
> > [30/30] Drop check_sub_bridges() which isn't necessary any more.
> >
> > The updated patches follow.
> >
> > If you don't hate this stuff, I'll put it into linux-next over the weekend for
> > further testing.
> 
> pm/linux-next with those patches breaks acpi root bus hotplug.
> it is kvm guest:
> 
> 10:~ # echo "PCI0 3" > /sys/kernel/debug/acpi/sci_notify
> [   92.549508] ACPI: ACPI device name is <PCI0>, event code is <3>
> [   92.552433] ACPI: Notify event is queued
> 10:~ # [   92.554279] ACPI: \_SB_.PCI0: Device eject notify on
> _handle_hotplug_event_root
> [   92.677696] ACPI: Device 0000:00:03.0 -x-> \_SB_.PCI0.S03_
> [   92.679229] ACPI: Device 0000:00:02.0 -x-> \_SB_.PCI0.VGA_
> [   92.680684] ACPI: Device 0000:00:01.3 -x-> \_SB_.PCI0.PX13
> [   92.682235] ata1.00: disabled
> [   92.689000] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [   92.690399] sd 0:0:0:0: [sda]
> [   92.691133] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [   92.693151] sd 0:0:0:0: [sda] Stopping disk
> [   92.694682] sd 0:0:0:0: [sda] START_STOP FAILED
> [   92.696749] sd 0:0:0:0: [sda]
> [   92.698157] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [   92.702852] ata2.00: disabled
> [   92.711550] ACPI: Device 0000:00:01.0 -x-> \_SB_.PCI0.ISA_
> [   92.713208] ACPI: Device pci0000:00 -x-> \_SB_.PCI0
> [   92.713226]   acpi_pci_iommu_remove is called for \_SB_.PCI0 ffff88007ab3f1e0
> [   92.713274]   acpi_pci_ioapic_remove is called for \_SB_.PCI0
> ffff88007ab3f1e0
> [   92.713345] pci 0000:00:00.0: freeing pci_dev info
> [   92.713363] pci 0000:00:01.0: freeing pci_dev info
> [   92.713366] pci 0000:00:01.1: freeing pci_dev info
> [   92.713376] pci 0000:00:01.3: freeing pci_dev info
> [   92.713380] pci 0000:00:02.0: freeing pci_dev info
> [   92.713384] pci 0000:00:03.0: freeing pci_dev info
> [   92.713396] pci_bus 0000:00: busn_res: [bus 00-ff] is released
> [   92.713441] BUG: unable to handle kernel NULL pointer dereference
> at           (null)
> [   92.713446] IP: [<ffffffff81557910>]
> acpiphp_unregister_hotplug_slot+0x20/0x60

Ugh, stupid bug, sorry about it.  We try to unregister something that may have
not been registered.

Can you please check if the appended patch helps (on top of
linux-pm.git/linux-next)?

Rafael


---
 drivers/pci/hotplug/acpiphp_glue.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -340,6 +340,7 @@ static acpi_status register_slot(acpi_ha
 
 		retval = acpiphp_register_hotplug_slot(slot, sun);
 		if (retval) {
+			slot->slot = NULL;
 			bridge->nr_slots--;
 			if (retval == -EBUSY)
 				warn("Slot %llu already registered by another "
@@ -429,7 +430,8 @@ static void cleanup_bridge(struct acpiph
 					err("failed to remove notify handler\n");
 			}
 		}
-		acpiphp_unregister_hotplug_slot(slot);
+		if (slot->slot)
+			acpiphp_unregister_hotplug_slot(slot);
 	}
 
 	mutex_lock(&bridge_mutex);


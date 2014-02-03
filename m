Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbaBCX2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:28:34 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56253 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753861AbaBCX2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:28:32 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: [PATCH v2 0/24] ACPI / hotplug / PCI: ACPIPHP updates and consolidation with ACPI core
Date: Tue, 04 Feb 2014 00:12:26 +0100
Message-ID: <7532948.aJNUotNMpR@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <20140203104408.GQ18029@intel.com>
References: <2217793.001RY6hKlo@vostro.rjw.lan> <1935791.liE9ZlzmO9@vostro.rjw.lan> <20140203104408.GQ18029@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 03, 2014 12:44:08 PM Mika Westerberg wrote:
> On Sun, Feb 02, 2014 at 01:19:33AM +0100, Rafael J. Wysocki wrote:
> > On Monday, January 27, 2014 01:37:17 AM Rafael J. Wysocki wrote:
> > > Hi All,
> > > 
> > > ACPIPHP can be simplified a bit on top of some PCI and ACPI changes merged
> > > recently and the following series of patches implements those simplifications:
> > > 
> > > [1/11] Fix up two kerneldoc comments in acpiphp_glue.c.
> > > [2/11] Get rid of an unnecessary label in register_slot().
> > > [3/11] Drop acpiphp_bus_trim() and use acpi_bus_trim() instead of it directly.
> > > [4/11] Move the acpi_bus_get_device() call out of acpiphp_no_hotplug().
> > > [5/11] Store struct acpi_device pointers instead of ACPI handles in struct acpiphp_context.
> > > [6/11] Drop acpiphp_bus_add() (which has only one user).
> > > [7/11] Drop crit_sect mutexes (that are redundant).
> > > [8/11] Clean up the usage of the slot variable in hotplug_event().
> > > [9/11] Drop dev_in_slot() and rework disable_slot() to walk bus->devices directly.
> > > [10/11] Use acpi_handle_debug() in hotplug_event() instead of open-coded stuff.
> > > [11/11] Drop handle argument from the member functions of struct acpi_dock_ops.
> > > 
> > > All of that is relateively straightforward, but I have some more intrusive changes
> > > on top of it in the works.  They will be posted separately later this week.
> > 
> > I've learned a couple of things since I sent this patchset.  First, all
> > bus->devices list walks that may remove PCI devices should be done in reverse
> > order or they can crash if virtual functions are involved.  Second, hotplug_event()
> > (in acpiphp_glue.c) has to acquire pci_rescan_remove_lock by itself, because it
> > may be called from multiple places and all of them need that lock to be held.
> > That is done by patches [1-2/13] which I'm planning to push as fixes for 3.14-rc2.
> > 
> > The rest is pretty much the same as last time except that the old patch [9/11]
> > became [3/13] in this series and it has been changed so that the list is walked in
> > reverse order.
> 
> On Intel NUC and DZ77RE-75K,
> 
> Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Thanks!

As I said previously, I have found two concurrency-related bugs more in ACPIPHP
and I needed to put fixes for those bugs at the top of the series (after previous
[1-2/13] and the patch at https://patchwork.kernel.org/patch/3567701/).  For this
reason, I also had to rebase the ACPI/PCI hotplug consolidation patchset
(https://lkml.org/lkml/2014/2/2/87) which got a few additional cosmetic changes too.

The following is a combination of the two series with one patch dropped (it would
conflict with [4-5/24]) and a few patches added.  It is on top of 3.14-rc1.

Patches [1-5/24], that are regarded as 3.14-rc2 material, are on the bleeding-edge
branch of linux-pm.git.  The remaining patches will show up in bleeding-edge
shortly.

[1/24] Remove entries from bus->devices in reverse order (in ACPIPHP).
[2/24] Move PCI rescan-remove locking to hotplug_event().
[3/24] Scan root bus under the PCI rescan-remove lock
[4/24] Fix race in handle_hotplug_event() related to concurrent bridge removal.
[5/24] Fix race in hotplug_event() related to dock events and concurrent bridge removal.
[6/24] Drop dev_in_slot() and rework disable_slot() to walk bus->devices directly.
[7/24] Fix up two kerneldoc comments in acpiphp_glue.c.
[8/24] Get rid of an unnecessary label in register_slot().
[9/24] Drop acpiphp_bus_trim() and use acpi_bus_trim() instead of it directly.
[10/24] Move the acpi_bus_get_device() call out of acpiphp_no_hotplug().
[11/24] Store struct acpi_device pointers instead of ACPI handles in struct acpiphp_context.
[12/24] Drop acpiphp_bus_add() (which has only one user).
[13/24] Drop crit_sect mutexes (that are redundant).
[14/24] Clean up the usage of the slot variable in hotplug_event().
[15/24] Use acpi_handle_debug() in hotplug_event() instead of open-coded stuff.
[16/24] Do not pass ACPI handle to hotplug_event().
[17/24] Add a new function to ACPICA allowing a callback to be executed under the
        namespace mutex after calling acpi_ns_get_attached_data().
[18/24] Use the new ACPICA's function to fix a couple of potential races related
        to ACPI notifies.
[19/24] Move the hotplug context lock definition to the ACPI core (from ACPIPHP).
[20/24] Consolidate ACPI hotplug signaling for PCI and ACPI core.
[21/24] Rework the handling of eject requests in the ACPI core.
[22/24] Simplify a routine for installing hotplug notify handlers.
[23/24] Dispatch ACPI hotplug notifications for "core" devices and PCI from
        acpi_bus_notify().
[24/24] Pass struct acpi_device pointer to acpiphp_check_host_bridge().

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

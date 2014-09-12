Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715AbaILSCw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 14:02:52 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:65214 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbaILSCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 14:02:49 -0400
Subject: [PATCH v1 00/13] PCI: Device configuration cleanup
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Rajat Jain <rajatxjain@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Date: Fri, 12 Sep 2014 12:02:46 -0600
Message-ID: <20140912180141.1630.17120.stgit@bhelgaas-glaptop2.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The motivation for this is to fix Linus' complaint about too many _HPP
messages (https://bugzilla.kernel.org/show_bug.cgi?id=84391):

    pci 0000:00:00.0: no hotplug settings from platform
    pci 0000:00:00.0: using default PCI settings

The first patch drops the messages and I intend it for v3.17.  The rest
are candidates for v3.18.

But the excessive *number* of messages is an indication that we're
calling pci_configure_slot() way too many times to begin with.  The
reason this happens is because:

    - acpiphp supports many slots on a single bus
    - on a Bus Check, we call acpiphp_check_bridge() to check each slot
      for changes
    - acpiphp_check_bridge() calls enable_slot() for every valid device it
      finds on a bus
    - enable_slot() calls pci_configure_slot() for every device on the bus

The typical result is that we find a bunch of devices on bus 00, and
each time we find one, we configure every device on bus 00.

I think the best way to fix this is to move device configuration out of
the hotplug drivers and into the PCI core.  That way we can do it once
when the device is enumerated and added.

This series adds a pci_configure_device() function that does the
configuration (similar to the existing pci_configure_slot()), and calls
it from pci_device_add(), where we already call pci_init_capabilities()
to initialize MSI, power management, ARI, etc.

Then it drops the existing pci_configure_slot() calls (this requires
keeping the pcie_bus_configure_settings() MPS and MRRS configuration
that was done by pci_configure_slot() but is not done by
pci_configure_device(), since it's not a simple per-device thing).

Finally, it tweaks several _HPP/_HPX things where we do things not
required by the spec and I haven't seen any other good reason for them:

    - We don't apply _HPP to PCIe devices, and I think we should
    - We clear SERR and PERR bits, and the spec says we shouldn't
    - We don't apply _HPP to certain bridge types (PCI-ISA, etc), and
      I don't see a reason to avoid them
    - We fiddle MPS and MRRS settings based on _HPX, even though Linux
      should control these
    - We only configure hot-added devices, but I think we should
      configure things present at boot the same way

I know some of these might be controversial, so I split them all into
separate patches and we can debate and drop them if necessary.

---

Bjorn Helgaas (13):
      PCI: Remove "no hotplug settings from platform" warning
      PCI: Move pci_configure_slot() to drivers/pci/probe.c
      PCI: Add pci_configure_device() during enumeration
      PCI: pciehp: Configure hot-added display devices
      PCI: pciehp: Remove pci_configure_slot() usage
      PCI: shpchp: Remove pci_configure_slot() usage
      ACPI / hotplug / PCI: Remove pci_configure_slot() usage
      PCI: Remove unused pci_configure_slot()
      PCI: Apply _HPP settings to PCIe devices as well as PCI and PCI-X
      PCI: Preserve BIOS PCI_COMMAND_SERR and PCI_COMMAND_PARITY settings
      PCI: Apply _HPP settings to all hot-added PCI devices
      PCI: Preserve MPS and MRRS when applying _HPX settings
      PCI: Configure *all* devices, not just hot-added ones


 drivers/pci/hotplug/Makefile       |    2 
 drivers/pci/hotplug/acpiphp_glue.c |   11 --
 drivers/pci/hotplug/pciehp_pci.c   |    9 --
 drivers/pci/hotplug/pcihp_slot.c   |  180 ------------------------------------
 drivers/pci/hotplug/shpchp_pci.c   |    8 --
 drivers/pci/probe.c                |  134 +++++++++++++++++++++++++++
 include/linux/pci_hotplug.h        |    2 
 7 files changed, 138 insertions(+), 208 deletions(-)
 delete mode 100644 drivers/pci/hotplug/pcihp_slot.c

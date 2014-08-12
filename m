Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237AbaHLQ3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 12:29:00 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51319 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753361AbaHLQ25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 12:28:57 -0400
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-pci <linux-pci@vger.kernel.org>
Cc: linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v9 00/12] Support for creating generic PCI host bridges from DT
Date: Tue, 12 Aug 2014 17:25:13 +0100
Message-Id: <1407860725-25202-1-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my updated attempt at adding support for generic PCI host
bridge controllers that make use of device tree information to
configure themselves. This version incorporates Catalin's proposal
for managing domain numbers that got Bjorn's approval. I am now requesting
ACKs from the relevant maintainers as I would like to get the upstream ball
rolling.

Of the more important changes vs v8, this version has an altered implementation
of of_create_pci_host_bridge() that allows for easier conversion of architectures
that use pci_scan_root_bus() in their code rather than pci_create_root_bus().
With my v8 version of the patchset it would've meant adding back the code
from pci_scan_root_bus() into architectural code. v9 fixes that and adds
a callback parameter to of_create_pci_host_bridge() that permits the host
controller driver to finish the driver setup before the bus is being scanned.

To repeat for the benefit of people writing host bridge drivers on top of
my patchset: the API for of_create_pci_host_bridge() has changed and it will now
do all the child bus and device scanning for you, so you only need to provide a
setup function that will be called before scanning start. I will post a patch
that Lorenzo has kindly constructed for converting pci-host-generic.c to my API.

Changes from v8:
  - Introduce a new helper function pci_pio_to_address() to translate between
    I/O port numbers and CPU addresses. This is a temporary band aid
    for drivers that rely on the old behaviour of of_pci_range_to_resource()
    until they are converted to the new framework. ARM's Integrator AP
    pci_v3.c makes use of that.
  - Patch pci_v3.c against changes in of_pci_range_to_resource(). This is the
    only driver that made use of the fact that the function was returning
    CPU addresses rather than I/O port numbers.
  - Added a warning when parsing more that one I/O range as this will discard
    previous information regarding the CPU address of the range.
  - Add support for generic domain number handling. The domain number is now
    stored in the struct bus if CONFIG_PCI_DOMAINS_GENERIC is defined. This
    is a cleanup of the patch that Catalin has proposed and Bjorn has ACKed,
    but I've added it here without the ACK as I have slightly modified the
    proposed API.
  - Create a new function to managing domain numbers that will query the DT
    for pci-domain information.
  - Introduce an updated version of of_create_pci_host_bridge() that takes
    a function pointer for a setup function that can be used by the host bridge
    driver to finish the setup after the DT has been parsed and host bridge
    created but before the scanning of the root bus has been initiated.
    This makes of_create_pci_host_bridge() an easy swap for architectures that
    do manual DT parsing and use pci_scan_root_bus()
  - Added arguments to of_create_pci_host_bridge() to be able to pass the
    bus number for the root bus and the maximum bus number to be used in
    the bus range resource. Changed the return value from a pointer to
    the pci_host_bridge into an int with the error code as the host bridge
    is not needed now given that of_create_pci_host_bridge() does all the
    scanning work.
  - Introduce a new pgprot_device() for remapping I/O space. For architectures
    that don't support it defaults to pgprot_noncached.
  - Fix the generic function for remaping I/O space by using
    pgprot_device(PAGE_KERNEL) as the parameter for ioremap_page_range()
  - Header include fixes, initialisation fixes and misc cleanup

Changes from v7:
  - Reordered the patches so that fixes and non-controversial patches
    from v7 can be accepted more easily. If agreed I can split the
    series again into patches that can be upstreamed easily and ones
    that still need discussion.
  - Moved the of_create_host_bridge() function to drivers/of/of_pci.c
    to better reflect its target use.
  - Added the function to remap the bus I/O resources that used to be
    provided in my arm64 patch series and (re)named it pci_remap_iospace()
  - Removed error code checking from parsing and mapping of IRQ from DT
    in recognition that some PCI devices will not have legacy IRQ mappings.

v8 thread here: https://lkml.org/lkml/2014/7/1/450
v7 thread here with all the historic information: https://lkml.org/lkml/2014/3/14/279

Best regards,
Liviu

Liviu Dudau (12):
  Fix ioport_map() for !CONFIG_GENERIC_IOMAP cases.
  PCI: OF: Parse and map the IRQ when adding the PCI device.
  PCI: Introduce helper functions to deal with PCI I/O ranges.
  PCI: OF: Fix the conversion of IO ranges into IO resources.
  ARM: Define PCI_IOBASE as the base of virtual PCI IO space.
  ARM: integrator: Correct usage of of_pci_range_to_resource()
  PCI: Create pci_host_bridge before its associated bus in pci_create_root_bus.
  PCI: Introduce generic domain handling for PCI busses.
  OF: Introduce helper function for getting PCI domain_nr
  OF: PCI: Add support for creating a generic host_bridge from DT
  arm64: Add pgprot_device() interface for device mappings.
  PCI: Introduce pci_remap_iospace() for remapping PCI I/O bus resources into CPU space

 arch/arm/include/asm/io.h         |   1 +
 arch/arm/mach-integrator/pci_v3.c |  24 ++---
 arch/arm64/include/asm/pgtable.h  |   2 +
 drivers/of/address.c              | 141 ++++++++++++++++++++++++++++
 drivers/of/of_pci.c               | 193 ++++++++++++++++++++++++++++++++++++++
 drivers/pci/host-bridge.c         |  15 +++
 drivers/pci/pci.c                 |  36 +++++++
 drivers/pci/probe.c               |  43 +++++----
 include/asm-generic/io.h          |   2 +-
 include/asm-generic/pgtable.h     |   4 +
 include/linux/of_address.h        |  15 +--
 include/linux/of_pci.h            |  20 ++++
 include/linux/pci.h               |  30 ++++++
 13 files changed, 485 insertions(+), 41 deletions(-)

-- 
2.0.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbaCNPgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 11:36:17 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51014 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755143AbaCNPfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 11:35:16 -0400
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v7 0/6] Support for creating generic host_bridge from device tree
Date: Fri, 14 Mar 2014 15:34:26 +0000
Message-Id: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm dropping the RFC tag now as I have the feeling that we are starting to have something in
a good shape that can be pushed for more testing in near future.

This is v7 of my attempt to add support for a generic pci_host_bridge controller created
from a description passed in the device tree.

Changes from v6:
  - Made pci_register_io_range() return an error if PCI_IOBASE is not defined. When the
    cleanup of PCI_IOBASE use is going to happen, that will catch all those architectures
    that don't use virtual mapping of I/O ranges (like x86) or don't support PCI at all.
  - Improved the error handling in of_pci_range_to_resource() and made it propagate the
    error as well.
  - Bail out of the parsing of PCI ranges if of_pci_range_to_resource() fails.

Changes from v5:
  - Tested by Tanmay Inamdar, thanks Tanmay!
  - dropped v5 5/7 pci: Use parent domain number when allocating child busses.
  - Added weak implementation of pcibios_fixup_bridge_ranges() in drivers/pci/host-bridge.c
    so that architectures that enable CONFIG_OF and CONFIG_PCI don't suddenly get compilation
    errors. While at this, changed the signature of the function so that an error can be
    returned.
  - With the new error code in pcibios_fixup_bridge_ranges(), reworked the error handling
    in pci_host_bridge_of_get_ranges() and of_create_pci_host_bridge().
  - Add linux/slab.h to the #include list
  - Revisit the error path in pci_create_root_bus[_in_domain]() and fixed the case where
    failing to allocate the bus will not return an error.

Changes from v4:
  - Export pci_find_host_bridge() to be used by arch code. There is scope for
    making the arch/arm64 version of pci_domain_nr the default weak implementation
    but that would double the size of this series in order to handle all #define
    versions of the pci_domain_nr() function, so I suggest keeping that for a separate
    cleanup series.

Changes from v3:
  - Dynamically allocate bus_range resource in of_create_pci_host_bridge()
  - Fix the domain number used when creating child busses.
  - Changed domain number allocator to use atomic operations.
  - Use ERR_PTR() to propagate the error out of pci_create_root_bus_in_domain()
    and of_create_pci_host_bridge().

Changes from v2:
  - Use range->cpu_addr when calling pci_address_to_pio()
  - Introduce pci_register_io_range() helper function in order to register
    io ranges ahead of their conversion to PIO values. This is needed as no
    information is being stored yet regarding the range mapping, making
    pci_address_to_pio() fail. Default weak implementation does nothing,
    to cover the default weak implementation of pci_address_to_pio() that
    expects direct mapping of physical addresses into PIO values (x86 view).

Changes from v1:
  - Add patch to fix conversion of IO ranges into IO resources.
  - Added a domain_nr member to pci_host_bridge structure, and a new function
    to create a root bus in a given domain number. In order to facilitate that
    I propose changing the order of initialisation between pci_host_bridge and
    it's related bus in pci_create_root_bus() as sort of a rever of 7b5436635800.
    This is done in patch 1/4 and 2/4.
  - Added a simple allocator of domain numbers in drivers/pci/host-bridge.c. The
    code will first try to get a domain id from of_alias_get_id(..., "pci-domain")
    and if that fails assign the next unallocated domain id.
  - Changed the name of the function that creates the generic host bridge from
    pci_host_bridge_of_init to of_create_pci_host_bridge and exported as GPL symbol.

v6 thread here: https://lkml.org/lkml/2014/3/5/179
v5 thread here: https://lkml.org/lkml/2014/3/4/318
v4 thread here: https://lkml.org/lkml/2014/3/3/301
v3 thread here: https://lkml.org/lkml/2014/2/28/216
v2 thread here: https://lkml.org/lkml/2014/2/27/245
v1 thread here: https://lkml.org/lkml/2014/2/3/380

Best regards,
Liviu


Liviu Dudau (6):
  pci: Introduce pci_register_io_range() helper function.
  pci: OF: Fix the conversion of IO ranges into IO resources.
  pci: Create pci_host_bridge before its associated bus in pci_create_root_bus.
  pci: Introduce a domain number for pci_host_bridge.
  pci: Export find_pci_host_bridge() function.
  pci: Add support for creating a generic host_bridge from device tree

 drivers/of/address.c       |  49 +++++++++++
 drivers/pci/host-bridge.c  | 161 ++++++++++++++++++++++++++++++++++-
 drivers/pci/probe.c        |  73 ++++++++++------
 include/linux/of_address.h |  14 +--
 include/linux/pci.h        |  17 ++++
 5 files changed, 278 insertions(+), 36 deletions(-)

-- 
1.9.0


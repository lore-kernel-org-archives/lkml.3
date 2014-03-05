Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbaCELto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 06:49:44 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51564 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755812AbaCELtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 06:49:42 -0500
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v6 0/6] [RFC] Support for creating generic host_bridge from device tree
Date: Wed,  5 Mar 2014 11:48:51 +0000
Message-Id: <1394020137-1830-1-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v6 of my attempt to add support for a generic pci_host_bridge controller created
from a description passed in the device tree.

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

 drivers/of/address.c       |  39 +++++++++++
 drivers/pci/host-bridge.c  | 159 ++++++++++++++++++++++++++++++++++++++++++++-
 drivers/pci/probe.c        |  70 +++++++++++++-------
 include/linux/of_address.h |  14 +---
 include/linux/pci.h        |  17 +++++
 5 files changed, 264 insertions(+), 35 deletions(-)

-- 
1.9.0


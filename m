Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbaCDPux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 10:50:53 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51464 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754472AbaCDPur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 10:50:47 -0500
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
Subject: [PATCH v5 0/7] [RFC] Support for creating generic host_bridge from device tree
Date: Tue,  4 Mar 2014 15:49:57 +0000
Message-Id: <1393948204-11555-1-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v5 of my attempt to add support for a generic pci_host_bridge controller created
from a description passed in the device tree.

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


v4 thread here: https://lkml.org/lkml/2014/3/3/301
v3 thread here: https://lkml.org/lkml/2014/2/28/216
v2 thread here: https://lkml.org/lkml/2014/2/27/245
v1 thread here: https://lkml.org/lkml/2014/2/3/380

Best regards,
Liviu

Liviu Dudau (7):
  pci: Introduce pci_register_io_range() helper function.
  pci: OF: Fix the conversion of IO ranges into IO resources.
  pci: Create pci_host_bridge before its associated bus in pci_create_root_bus.
  pci: Introduce a domain number for pci_host_bridge.
  pci: Use parent domain number when allocating child busses.
  pci: Export find_pci_host_bridge() function.
  pci: Add support for creating a generic host_bridge from device tree

 drivers/of/address.c       |  39 +++++++++++++
 drivers/pci/host-bridge.c  | 142 ++++++++++++++++++++++++++++++++++++++++++++-
 drivers/pci/probe.c        |  72 +++++++++++++++--------
 include/linux/of_address.h |  14 +----
 include/linux/pci.h        |  17 ++++++
 5 files changed, 248 insertions(+), 36 deletions(-)

-- 
1.9.0


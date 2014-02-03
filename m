Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbaBCTXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 14:23:51 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:58250 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbaBCTXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 14:23:49 -0500
MIME-Version: 1.0
In-Reply-To: <20140129174106.15476.7075.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140129174106.15476.7075.stgit@bhelgaas-glaptop.roam.corp.google.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 3 Feb 2014 12:23:28 -0700
Message-ID: <CAErSpo5whsUH0aM8iocKdn4FOQLEjCQoM+ShjVjzWDxSWTzQnA@mail.gmail.com>
Subject: Re: [PATCH 00/17] x86, ia64 NUMA cleanup
To: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Tony]

On Wed, Jan 29, 2014 at 11:17 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> This is all cleanup: it adds no new functionality and should make no
> functional difference at all except a printk change or two.
>
> The main ideas are:
>
>   - Clean up the x86 PCI bus scanning interfaces.  We had:
>       struct pci_bus *pci_scan_bus_on_node(int bus, struct pci_ops *, int node)
>       struct pci_bus *pcibios_scan_root(int bus)
>       struct pci_bus *pci_scan_bus_with_sysdata(int bus)
>       void pcibios_scan_specific_bus(int bus)
>     These were all basically the same, so I kept only pcibios_scan_root().
>
>   - Get rid of mp_bus_to_node[].  This was basically a way of passing node
>     info from the AMD "native host bridg driver" (amd_bus.c) into the PCI
>     core.  It was clunky and inconsistent between x86-64 and i386.  I
>     replaced it with x86_pci_root_bus_node(), analogous to the existing
>     x86_pci_root_bus_resources().
>
>   - Remove _PXM knowledge from the PCI host bridge, IOMMU, and APIC code.
>     They really only care about the NUMA node number, not the raw _PXM
>     value.
>
> ---
>
> Bjorn Helgaas (17):
>       x86/PCI: Drop pcibios_scan_root() check for bus already scanned
>       x86/PCI: Use pcibios_scan_root() instead of pci_scan_bus_with_sysdata()
>       x86/PCI: Use pcibios_scan_root() instead of pci_scan_bus_on_node()
>       x86/PCI: Merge pci_scan_bus_on_node() into pcibios_scan_root()
>       x86/PCI: Drop return value of pcibios_scan_root()
>       x86/PCI: Add x86_pci_root_bus_node() to look up NUMA node from PCI bus
>       x86/PCI: Use x86_pci_root_bus_node() instead of get_mp_bus_to_node()
>       x86/PCI: Remove mp_bus_to_node[], set_mp_bus_to_node(), get_mp_bus_to_node()
>       x86/PCI: Remove unnecessary list_empty(&pci_root_infos) check
>       x86/PCI: Use NUMA_NO_NODE, not -1, for unknown node
>       x86/PCI: Remove acpi_get_pxm() usage
>       ia64 / sba_iommu: Use NUMA_NO_NODE, not MAX_NUMNODES, for unknown node
>       ia64: Remove acpi_get_pxm() usage
>       ACPI / numa: Fix acpi_get_node() prototype
>       ACPI / numa: Simplify acpi_get_node() style
>       ACPI / numa: Make __acpi_map_pxm_to_node(), acpi_get_pxm() static
>       ACPI / numa: Use __weak, not the gcc-specific version
>
>
>  arch/ia64/hp/common/sba_iommu.c |   32 +++-------
>  arch/ia64/include/asm/pci.h     |    2 -
>  arch/ia64/kernel/acpi.c         |   28 ++-------
>  arch/ia64/pci/pci.c             |   10 +--
>  arch/x86/include/asm/pci.h      |    7 --
>  arch/x86/include/asm/topology.h |   14 ----
>  arch/x86/pci/acpi.c             |   29 ++-------
>  arch/x86/pci/amd_bus.c          |   10 ---
>  arch/x86/pci/bus_numa.c         |   13 +++-
>  arch/x86/pci/common.c           |  128 +++++----------------------------------
>  arch/x86/pci/fixup.c            |    6 +-
>  arch/x86/pci/irq.c              |    6 --
>  arch/x86/pci/legacy.c           |    4 -
>  arch/x86/pci/numaq_32.c         |    6 +-
>  arch/x86/pci/visws.c            |    4 +
>  drivers/acpi/numa.c             |   16 ++---
>  include/acpi/acpi_numa.h        |    1
>  include/linux/acpi.h            |    9 +--
>  18 files changed, 75 insertions(+), 250 deletions(-)

I added this series to my "next" branch for v3.14.  Tony, let me know
if you see any ia64 issues.

Bjorn

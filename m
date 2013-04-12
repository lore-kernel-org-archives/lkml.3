Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab3DLPqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 11:46:17 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:36768 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab3DLPqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 11:46:05 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH v9 00/16] Get rid of the ACPI PCI subdriver mechanism
Date: Fri, 12 Apr 2013 23:44:14 +0800
Message-Id: <1365781470-32379-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI, ACPI: remove ACPI PCI subdriver mechanism

This patch set is directly derived from two sources:
1) '[PATCH 00/15] PCI/ACPI: Remove "pci_root" sub-driver support' at
https://lkml.org/lkml/2012/12/7/11 from Myron Stowe
The major goal is to resolve any potential sequencing inter-dependencies
by converting sub-driver functionality to being only supported as
statically built-in to the kernel as part of the "pci_root" driver
itself.

2) 'introduce PCI bus notifier chain to get rid of the ACPI PCI subdriver'
at http://lwn.net/Articles/533547/
The major goal is to update PCI slots(pci_slot), ACPI based PCI hotplug
slots(acpiphp), PCIe AER(aer) etc when hot-plugging PCI devices and P2P
bridges, and eventually get rid of the ACPI PCI subdriver interfaces.

This patchset applies to Bjorn's pci-next branch. Patch 1-4 are minor
fixups for 3.9-rc1. Patch 5-8 introduce two hooks into PCI core which
will be called when creating/destroying PCI buses. Patch 9-12 replace
ACPI PCI subdriver interfaces with the new hook mechanism for pci_slot
and acpiphp. Patch 13 removes the ACPI PCI subdriver interfaces.

v7->v8:
	Hook directly into the PCI core to replace pci_bus notification
	Remove ACPI PCI subdriver related code

v8->v9:
	Introduce kernel boot option "acpiphp.disable" to disable the
	acpiphp driver.

Jiang Liu (13):
  PCI: do not check is_added flag in pci_remove_bus()
  pci: clean up usages of pci_bus->is_added
  PCI/acpiphp: don't rely on function 0 in disable_device()
  ACPI/acpiphp: replace local macros with standard ACPI macros
  PCI: introduce platform dependent hooks for creating/destroying PCI
    busses
  PCI, ACPI: prepare stub functions to handle ACPI PCI (hotplug) slots
  PCI, IA64: implement pcibios_{add|remove}_bus() hooks
  PCI, x86: implement pcibios_{add|remove}_bus() hooks
  PCI, ACPI: handle PCI slot devices when creating/destroying PCI
    busses
  PCI/acpiphp: convert acpiphp as a builtin driver
  PCI/acpiphp: do not use ACPI PCI subdriver mechanism
  PCI/acpiphp: protect acpiphp data structures from concurrent updating
  PCI/acpiphp: introduce a kernel option to disable the acpiphp driver

Myron Stowe (1):
  PCI, ACPI: remove support of ACPI PCI subdrivers

Yijing Wang (2):
  PCI/acpiphp: use list_for_each_entry_safe() in acpiphp_sanitize_bus()
  PCI/acpiphp: use normal list to simplify implementation

 Documentation/kernel-parameters.txt |    3 +
 arch/ia64/pci/pci.c                 |   11 +
 arch/x86/pci/common.c               |   11 +
 drivers/acpi/pci_root.c             |   48 +---
 drivers/acpi/pci_slot.c             |  170 ++------------
 drivers/acpi/scan.c                 |    1 -
 drivers/pci/bus.c                   |   11 +-
 drivers/pci/hotplug/Kconfig         |    7 +-
 drivers/pci/hotplug/acpiphp.h       |   13 +-
 drivers/pci/hotplug/acpiphp_core.c  |   29 +--
 drivers/pci/hotplug/acpiphp_glue.c  |  415 ++++++++++++-----------------------
 drivers/pci/pci-acpi.c              |   30 +++
 drivers/pci/probe.c                 |   15 +-
 drivers/pci/remove.c                |    4 +-
 include/linux/acpi.h                |    9 -
 include/linux/pci-acpi.h            |   26 +++
 include/linux/pci.h                 |    2 +
 17 files changed, 280 insertions(+), 525 deletions(-)

-- 
1.7.9.5


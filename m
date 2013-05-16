Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab3EPPvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 11:51:15 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:52285 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab3EPPvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 11:51:13 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2, part3 00/11] Introduce PCI bus lock and state machine
Date: Thu, 16 May 2013 23:50:48 +0800
Message-Id: <1368719459-24800-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
	About one year ago, I started to solve issues triggered by concurrent
PCI device hotplug operations, and several different solutions have been
sent to community for comments. Now we have made important changes to the
solution, so start again with a "v1".

This is the second take to resolve race conditions when hot-plugging PCI
devices/host bridges. Instead of using a globla lock to serialize all hotplug
operations as in previous version, now we introduce a state machine and lock
mechanism for PCI buses to serialize hotplug operations. For discussions
related to previous version, please refer to:
http://comments.gmane.org/gmane.linux.kernel.pci/15007

This patch-set is still in early stages, so sending it out just requesting
for comments. Any comments are welcomed, especially about whether it's the
right/suitable way to solve these race condition issues.

There are multiple methods to trigger PCI hotplug requests/operations
concurrently, such as:
1. Sysfs interfaces exported by the PCI core subsystem
	/sys/devices/pcissss:bb/ssss:bb:dd.f/.../remove
	/sys/devices/pcissss:bb/ssss:bb:dd.f/.../rescan
	/sys/devices/pcissss:bb/ssss:bb:dd.f/.../pci_bus/ssss:bb/rescan
	/sys/bus/pci/rescan
2. Sysfs interfaces exported by the PCI hotplug subsystem
	/sys/bus/pci/slots/xx/power
3. PCI hotplug events triggered by PCI Hotplug Controllers
4. ACPI hotplug events for PCI host bridges
5. Driver binding/unbinding events
	binding/unbinding pci drivers with SR-IOV support

With current implementation, the PCI core subsystem doesn't support
concurrent hotplug operations yet. The existing pci_bus_sem lock only
protects several lists in struct pci_bus, such as children list,
devices list, but it doesn't protect the pci_bus or pci_dev structure
themselves.

Let's take pci_remove_bus_device() as an example, which are used by
PCI hotplug drivers to hot-remove PCI devices.  Currently all these
are free running without any protection, so it can't support reentrance.
pci_remove_bus_device()
    ->pci_stop_bus_device()
        ->pci_stop_bus_device()
            ->pci_stop_bus_devices()
        ->pci_stop_dev()

Patch 1-4:
1) Introduce PCI bus lock and state machine
2) Introduce a state machine for PCI devices to enable reentrance

Patch 5-8:
1) Enhance PCI core to support new PCI bus lock and state machine
2) Refine xen-pcifront code with new PCI interfaces

Patch 9-10:
1) Give example about how to enhance PCI hotplug drivers with PCI bus
   lcok and state machine

Patch 11:
1) Give an example about how to enhance arch specific PCI code with PCI
   bus lock and state machine

Jiang Liu (11):
  PCI: introduce bus lock and state machine to serialize PCI hotplug
    operations
  PCI: implement state machine for PCI bus
  PCI: introduce a state machine to manage PCI device lifecycle
  PCI: introduce helper function pci_stop_and_remove_device()
  PCI: enhance PCI core logic to support PCI bus lock
  PCI, sysfs: use PCI bus lock to serialize hotplug operations triggered
    by sysfs
  PCI, xen-pcifront: use new PCI interfaces to simplify implementation
  PCI, xen-pcifront: use PCI bus lock to protect PCI device hotplug
  PCI, acpiphp: use PCI bus lock to protect PCI device hotplug
  PCI, pciehp: use PCI bus lock to protect PCI device hotplug
  PCI, ACPI, pci_root: use PCI bus lock to protect PCI device hotplug

 arch/ia64/pci/pci.c                |   2 +-
 arch/x86/pci/acpi.c                |   3 +-
 drivers/acpi/pci_root.c            |  14 +-
 drivers/pci/Kconfig                |   3 +
 drivers/pci/bus.c                  | 274 ++++++++++++++++++++++++++++++++++++-
 drivers/pci/hotplug-pci.c          |   4 +
 drivers/pci/hotplug/acpiphp_glue.c |  16 ++-
 drivers/pci/hotplug/pciehp_pci.c   |  15 ++
 drivers/pci/pci-sysfs.c            |  52 ++++---
 drivers/pci/probe.c                |  33 ++++-
 drivers/pci/remove.c               | 151 +++++++++++++-------
 drivers/pci/xen-pcifront.c         |  95 +++++++------
 include/linux/pci.h                |  63 ++++++++-
 13 files changed, 588 insertions(+), 137 deletions(-)

-- 
1.8.1.2


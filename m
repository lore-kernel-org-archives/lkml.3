Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab3BAQN5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 11:13:57 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:62417 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab3BAQNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 11:13:51 -0500
Message-ID: <510BE9AB.9010702@gmail.com>
Date: Sat, 02 Feb 2013 00:13:31 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@huawei.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [RFC PATCH v5 0/8] introduce PCI bus notifier chain to get rid
 of the ACPI PCI subdriver interfaces
References: <1358525267-14268-1-git-send-email-jiang.liu@huawei.com> <CAErSpo6M-c3diVEUpUESgL=2PenxHYkW1eb=OGBdxxWwkge-Bw@mail.gmail.com> <1598719.tGLtx5aHMZ@vostro.rjw.lan> <51072E1D.8020901@huawei.com>
In-Reply-To: <51072E1D.8020901@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2013 10:04 AM, Jiang Liu wrote:
> On 2013-1-29 8:34, Rafael J. Wysocki wrote:
>> On Monday, January 28, 2013 01:56:33 PM Bjorn Helgaas wrote:
>>> On Fri, Jan 18, 2013 at 9:07 AM, Jiang Liu <liuj97@gmail.com> wrote:
>>>> This is an RFC patchset to address review comments in thread at:
>>>> https://patchwork.kernel.org/patch/1946851/. The patch just pasts
>>>> compilation. If no objection to the new implementation, I will
>>>> go on to modify acpiphp driver and conduct tests.
>>>>
>>>> The main changes from V4 to V5 includes:
>>>> 1) introduce a dedicated notifier chain for PCI buses
>>>> 2) change pci_slot as built-in driver
>>>> 3) unify the way to create/destroy PCI slots
>>>> 4) introduce a kernel option to disable PCIe native hotplug
>>>>
>>>> TODO:
>>>> 1) change acpiphp as built-in and unify the way to create/destroy ACPI
>>>>    based hotplug slots.
>>>> 2) change other ACPI PCI subdriver in Yinghai's root bridge hotplug series
>>>>    to use the PCI bus notifier chain.
>>>> 3) Remove the ACPI PCI subdriver interface eventaully.
>>>>
>>>> Jiang Liu (8):
>>>>   PCI: make PCI device create/destroy logic symmetric
>>>>   PCI: split registration of PCI bus devices into two stages
>>>>   PCI: add a blocking notifier chain for PCI bus addition/removal
>>>>   ACPI, PCI: avoid building pci_slot as module
>>>>   PCI, ACPI: hook PCI bus notifications to create/destroy PCI slots
>>>>   pci_slot: replace printk(KERN_xxx) with pr_xxx()
>>>>   PCI/PCIe: add "pci=nopciehp" to disable PCIe native hotplug
>>>>   PCI/PCIe: only claim PME from firmware when CONFIG_PCIE_PME is
>>>>     enabled
>>>>
>>>>  Documentation/kernel-parameters.txt |    2 +
>>>>  drivers/acpi/Kconfig                |    5 +-
>>>>  drivers/acpi/internal.h             |    5 +
>>>>  drivers/acpi/pci_root.c             |    8 +-
>>>>  drivers/acpi/pci_slot.c             |  217 ++++++++++-------------------------
>>>>  drivers/acpi/scan.c                 |    1 +
>>>>  drivers/pci/bus.c                   |   26 ++++-
>>>>  drivers/pci/pci.c                   |    2 +
>>>>  drivers/pci/pci.h                   |    1 +
>>>>  drivers/pci/pcie/portdrv_core.c     |    7 +-
>>>>  drivers/pci/pcie/portdrv_pci.c      |    3 +
>>>>  drivers/pci/probe.c                 |    7 +-
>>>>  drivers/pci/remove.c                |   15 +--
>>>>  include/linux/pci.h                 |   21 ++++
>>>>  14 files changed, 142 insertions(+), 178 deletions(-)
>>>
>>> I think the problem we're trying to solve is that we don't initialize
>>> hot-added devices, correctly, e.g., we don't set up AER, we don't
>>> update acpi/pci_slot stuff, we probably don't set up PME etc.  We also
>>> have similar issues like IOMMU init on powerpc.
>>>
>>> Notifier chains seem like an unnecessarily complicated way to deal
>>> with this.  They're great for communicating between modules that stay
>>> at arm's length from each other.  But that's not the case here --
>>> everything is PCI and is quite closely coupled.  I think AER, PME,
>>> slot, etc., should  be initialized directly in pci_device_add() or
>>> somewhere nearby.
>>
>> I agree.
>>
>>> This might sound a bit radical because it implies some fairly
>>> far-reaching changes.  It means this code can't be a module (the only
>>> one that can be built as a module today is pciehp, and I think
>>> everybody agrees that we should make it static as soon as we can
>>> figure out the acpiphp/pciehp issue).  I think it also means the
>>> pcieportdrv concept is of dubious value, since all the services should
>>> be known at build-time and we probably don't need a registration
>>> interface for them.
>>
>> It is of dubious value regardless.  It just adds complexity for no gain.
>> Moreover, these things are in fact not mutually independent.
>>
>> I've had a lot of headaches trying to work around that when I was working
>> on PME support and later on _OSC for root bridges.  Let's just take that
>> stuff away once and for good. :-)
> Hi Bjorn and Rafael,
> 	Thanks for advice. We will go this direction to change those modules
> as built-in.
> Regards!
> Gerry
> 
Hi Bjorn,
	I have done some investigation about how to implement this without
using notifier chain. Due to commit "PCI: Put pci_dev in device tree as early
as possible", a PCI device will be registered to the driver core before creating
the subordinate PCI bus. So we can't reply on the ACPI PCI device glue code
to create/destroy PCI slots or acpiphp hotplug slots. So my current plan is
to introduce two weak functions as below, is it acceptable?

Regards!
Gerry

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index b494066..a5c22e7 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -673,6 +673,8 @@ add_dev:
        ret = device_register(&child->dev);
        WARN_ON(ret < 0);
 
+       pcibios_add_bus(child);
+
        /* Create legacy_io and legacy_mem files for this bus */
        pci_create_legacy_files(child);
 
@@ -1661,6 +1663,14 @@ int __weak pcibios_root_bridge_prepare(struct pci_host_bridge *
        return 0;
 }
 
+void __weak pcibios_add_bus(struct pci_bus *bus)
+{
+}
+
+void __weak pcibios_remove_bus(struct pci_bus *bus)
+{
+}
+
 struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
                struct pci_ops *ops, void *sysdata, struct list_head *resources)
 {
@@ -1715,6 +1725,8 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int b
        if (error)
                goto class_dev_reg_err;
 
+       pcibios_remove_bus(b);
+
        /* Create legacy_io and legacy_mem files for this bus */
        pci_create_legacy_files(b);
 
diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index fc38c48..3dbdf82 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -52,6 +52,7 @@ void pci_remove_bus(struct pci_bus *bus)
                return;
 
        pci_remove_legacy_files(bus);
+       pcibios_remove_bus(child);
        device_unregister(&bus->dev);
 }
 EXPORT_SYMBOL(pci_remove_bus);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 056d3d6..fd8ba0c 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -380,6 +380,8 @@ void pci_set_host_bridge_release(struct pci_host_bridge *bridge,
                     void *release_data);
 
 int pcibios_root_bridge_prepare(struct pci_host_bridge *bridge);
+void pcibios_add_bus(struct pci_bus *bus);
+void pcibios_remove_bus(struct pci_bus *bus);
 
 /*
  * The first PCI_BRIDGE_RESOURCE_NUM PCI bus resources (those that correspond


>>
>> Thanks,
>> Rafael
>>
>>
> 
> 


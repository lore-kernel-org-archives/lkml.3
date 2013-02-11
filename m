Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240Ab3BKNDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 08:03:32 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:62522 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757047Ab3BKND3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 08:03:29 -0500
MIME-Version: 1.0
X-Originating-IP: [121.6.200.219]
Date: Mon, 11 Feb 2013 21:03:28 +0800
Message-ID: <CAMVG2svG21yiM1wkH4_2pen2n+cr2-Zv7TbH3Gj+8MwevZjDbw@mail.gmail.com>
Subject: [3.8-rc7] PCI hotplug wakeup oops
From: Daniel J Blueman <daniel@quora.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 3.8-rc7, when unplugging the Thunderbolt ethernet adapter (bus 0a
[1]) on a Macbook Pro 10,1, we see the PCIe port correctly released:

pciehp 0000:06:03.0:pcie24: Card not present on Slot(3)
tg3 0000:0a:00.0: tg3_abort_hw timed out, TX_MODE_ENABLE will not
clear MAC_TX_MODE=ffffffff
tg3 0000:0a:00.0 eth0: No firmware running
tg3 0000:0a:00.0 eth0: Link is down
[sched_delayed] sched: RT throttling activated
pcieport 0000:00:01.1: System wakeup enabled by ACPI
pciehp 0000:09:00.0:pcie24: unloading service driver pciehp
pci_bus 0000:0a: busn_res: [bus 0a] is released
pci_bus 0000:09: busn_res: [bus 09-0a] is released

After some activity later (eg I can reproduce this by switching to a
text console and back), often we'll see an oops:

Unable to handle kernel paging request at 0000000000001070
pci_pme_list_scan+0x3d/0xe0
Call Trace:
process_one_work+0x193
? process_one_work+0x131
? pci_pme_wakeup+0x60
worker_thread+0x15d

(gdb) list *(pci_pme_list_scan+0x3d)
0xffffffff8123f6dd is in pci_pme_list_scan (drivers/pci/pci.c:1556).
1551					/*
1552					 * If bridge is in low power state, the
1553					 * configuration space of subordinate devices
1554					 * may be not accessible
1555					 */
1556					if (bridge && bridge->current_state != PCI_D0)
1557						continue;
1558					pci_pme_wakeup(pme_dev->dev, NULL);
1559				} else {
1560					list_del(&pme_dev->list);

Since a panic in vsnprintf happens after the oops (hence I can't catch
it with EFI pstore), it is almost certainly significant heap
corruption; this would explain why pme_dev became null (the load has
been ordered ahead).

I'll see what I can find out with memory poisoning and list debugging.

Thanks,
  Daniel

--- [1]

$ lspci
00:00.0 Host bridge: Intel Corporation 3rd Gen Core processor DRAM
Controller (rev 09)
00:01.0 PCI bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core
processor PCI Express Root Port (rev 09)
00:01.1 PCI bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core
processor PCI Express Root Port (rev 09)
00:01.2 PCI bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core
processor PCI Express Root Port (rev 09)
00:02.0 VGA compatible controller: Intel Corporation 3rd Gen Core
processor Graphics Controller (rev 09)
00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
Family USB xHCI Host Controller (rev 04)
00:16.0 Communication controller: Intel Corporation 7 Series/C210
Series Chipset Family MEI Controller #1 (rev 04)
00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
Family USB Enhanced Host Controller #2 (rev 04)
00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset
Family High Definition Audio Controller (rev 04)
00:1c.0 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset
Family PCI Express Root Port 1 (rev c4)
00:1c.1 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset
Family PCI Express Root Port 2 (rev c4)
00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
Family USB Enhanced Host Controller #1 (rev 04)
00:1f.0 ISA bridge: Intel Corporation HM77 Express Chipset LPC
Controller (rev 04)
00:1f.2 SATA controller: Intel Corporation 7 Series Chipset Family
6-port SATA Controller [AHCI mode] (rev 04)
00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family
SMBus Controller (rev 04)
01:00.0 VGA compatible controller: NVIDIA Corporation Device 0fd5 (rev ff)
01:00.1 Audio device: NVIDIA Corporation Device 0e1b (rev ff)
03:00.0 Ethernet controller: Broadcom Corporation Device 16a3 (rev 10)
03:00.1 SD Host controller: Broadcom Corporation NetXtreme BCM57765
Memory Card Reader (rev 10)
04:00.0 Network controller: Broadcom Corporation BCM4331 802.11a/b/g/n (rev 02)
05:00.0 PCI bridge: Intel Corporation DSL3510 Thunderbolt Port [Cactus
Ridge] (rev 03)
06:00.0 PCI bridge: Intel Corporation DSL3510 Thunderbolt Port [Cactus
Ridge] (rev 03)
06:03.0 PCI bridge: Intel Corporation DSL3510 Thunderbolt Port [Cactus
Ridge] (rev 03)
06:04.0 PCI bridge: Intel Corporation DSL3510 Thunderbolt Port [Cactus
Ridge] (rev 03)
06:05.0 PCI bridge: Intel Corporation DSL3510 Thunderbolt Port [Cactus
Ridge] (rev 03)
06:06.0 PCI bridge: Intel Corporation DSL3510 Thunderbolt Port [Cactus
Ridge] (rev 03)
07:00.0 System peripheral: Intel Corporation DSL3510 Thunderbolt Port
[Cactus Ridge] (rev 03)
08:00.0 PCI bridge: Intel Corporation DSL3510 Thunderbolt Controller
[Cactus Ridge]
09:00.0 PCI bridge: Intel Corporation DSL3510 Thunderbolt Controller
[Cactus Ridge]
0a:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM57762
Gigabit Ethernet PCIe
-- 
Daniel J Blueman

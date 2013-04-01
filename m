Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562Ab3DAIny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 04:43:54 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:44187 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757737Ab3DAInv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 04:43:51 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Tony Luck <tony.luck@intel.com>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>, <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 2/2] PCI/IA64: fix pci_dev->enable_cnt balance when doing pci hotplug
Date: Mon, 1 Apr 2013 16:42:55 +0800
Message-ID: <1364805775-12396-2-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
In-Reply-To: <1364805775-12396-1-git-send-email-wangyijing@huawei.com>
References: <1364805775-12396-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In IA64 platform, we don't call pci_enable_bridges()
when scan all pci buses during system boot up. But in
X86 we do it in

pcibios_assign_resources()
   pci_assign_unassigned_resources()
       ...........
       pci_enable_bridges()

Then when we doing hot remove

acpiphp_disable_slot()
   pci_stop_and_remove_bus_device()
       pci_stop_bus_device()
          .............
          pcie_portdrv_remove()
			  pcie_port_device_remove()
                  pci_disable_device()   first decrease enable_cnt  here
			  pci_disable_device()     second decrease enable_cnt
So pci_dev->enable_cnt is unbalanced in IA64.

Following Warning info found under IA64 when doing pci hotplug.

------------[ cut here ]------------
WARNING: at drivers/pci/pci.c:1397 pci_disable_device+0x1c0/0x220()
Hardware name: MH8900
Device pcieport
disabling already-disabled device
Modules linked in: acpiphp ipv6 ipmi_si(+) ipmi_devintf ipmi_msghandler fuse vfaa
t fat dm_mod iTCO_wdt iTCO_vendor_support lpc_ich i2c_i801 mfd_core i2c_core sg
sd_mod crc_t10dif ext3 mbcache jbd ata_piix

Call Trace:
 [<a000000100015c00>] show_stack+0x80/0xa0
                                sp=e000000fd629fc00 bsp=e000000fd62996e0
 [<a000000100a9ca20>] dump_stack+0x30/0x50
                                sp=e000000fd629fdd0 bsp=e000000fd62996c8
 [<a000000100061960>] warn_slowpath_common+0xc0/0x100
                                sp=e000000fd629fdd0 bsp=e000000fd6299688
 [<a000000100061b50>] warn_slowpath_fmt+0x90/0xc0
                                sp=e000000fd629fdd0 bsp=e000000fd6299628
 [<a000000100495be0>] pci_disable_device+0x1c0/0x220
                                sp=e000000fd629fe10 bsp=e000000fd62995e8
 [<a0000001004b3ba0>] pcie_portdrv_remove+0xc0/0xe0
                                sp=e000000fd629fe10 bsp=e000000fd62995c8
 [<a000000100499670>] pci_device_remove+0x90/0x1e0
                                sp=e000000fd629fe10 bsp=e000000fd6299598
 [<a000000100636490>] __device_release_driver+0x150/0x280
                                sp=e000000fd629fe10 bsp=e000000fd6299560
 [<a000000100636830>] device_release_driver+0x30/0x60
                                sp=e000000fd629fe10 bsp=e000000fd6299538
 [<a000000100634a40>] bus_remove_device+0x2c0/0x3c0
                                sp=e000000fd629fe10 bsp=e000000fd62994f0
 [<a0000001006306d0>] device_del+0x290/0x440
                                sp=e000000fd629fe10 bsp=e000000fd62994a8
 [<a00000010048d550>] pci_stop_bus_device+0x150/0x200
                                sp=e000000fd629fe10 bsp=e000000fd6299478
 [<a00000010048d470>] pci_stop_bus_device+0x70/0x200
                                sp=e000000fd629fe10 bsp=e000000fd6299448
 [<a00000010048d470>] pci_stop_bus_device+0x70/0x200
                                sp=e000000fd629fe10 bsp=e000000fd6299418
 [<a00000010048d9a0>] pci_stop_and_remove_bus_device+0x20/0x60
                                sp=e000000fd629fe10 bsp=e000000fd62993f0
 [<a0000002089aa100>] acpiphp_disable_slot+0x240/0x4e0 [acpiphp]
                                sp=e000000fd629fe10 bsp=e000000fd62993a0
 [<a0000002089a8a30>] disable_slot+0x50/0x160 [acpiphp]
                                sp=e000000fd629fe20 bsp=e000000fd6299378
 [<a0000001004ba080>] power_write_file+0x140/0x2a0
                                sp=e000000fd629fe20 bsp=e000000fd6299348
 [<a0000001004a6320>] pci_slot_attr_store+0x60/0xa0
                                sp=e000000fd629fe20 bsp=e000000fd6299310
 [<a00000010032a100>] sysfs_write_file+0x240/0x340
                                sp=e000000fd629fe20 bsp=e000000fd62992b8
 [<a00000010023c910>] vfs_write+0x1b0/0x3a0
                                sp=e000000fd629fe20 bsp=e000000fd6299270
 [<a00000010023cc90>] sys_write+0x90/0xe0
                                sp=e000000fd629fe20 bsp=e000000fd62991f0
 [<a00000010000bce0>] ia64_ret_from_syscall+0x0/0x20
                                sp=e000000fd629fe30 bsp=e000000fd62991f0
 [<a000000000040720>] __kernel_syscall_via_break+0x0/0x20
                                sp=e000000fd62a0000 bsp=e000000fd62991f0
---[ end trace 34d87c78dbff78ce ]---
GSI 37 (level, low) -> CPU 15 (0x01e0) vector 68 unregistered
pcie_pme 0000:00:07.0:pcie01: unloading service driver pcie_pme
aer 0000:00:07.0:pcie02: unloading service driver aer

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
---
 arch/ia64/pci/pci.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index 60532ab..a557096 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -383,6 +383,7 @@ struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
 	}
 
 	pci_scan_child_bus(pbus);
+	pci_enable_bridges(pbus);
 	return pbus;
 
 out3:
-- 
1.7.1



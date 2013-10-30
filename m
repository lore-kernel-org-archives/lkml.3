Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab3J3KUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 06:20:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:45278 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751730Ab3J3KUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 06:20:19 -0400
X-IronPort-AV: E=Sophos;i="4.93,599,1378828800"; 
   d="scan'208";a="8899894"
Message-ID: <5270DBFC.3050705@cn.fujitsu.com>
Date: Wed, 30 Oct 2013 18:14:20 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Yinghai Lu <yinghai@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] pci: fix invalid list entry warning for double pci device
 removing via sysfs
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/30 18:18:36,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/30 18:18:36,
	Serialize complete at 2013/10/30 18:18:36
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When concurent removing pci devices which are in the same pci subtree
via sysfs, such as:
echo -n 1 > /sys/bus/pci/devices/0000\:10\:00.0/remove ; echo -n 1 >
/sys/bus/pci/devices/0000\:1a\:01.0/remove
(1a:01.0 device is downstream from the 10:00.0 bridge)

the following warning will show:
[ 1799.280918] ------------[ cut here ]------------
[ 1799.336199] WARNING: CPU: 7 PID: 126 at lib/list_debug.c:53 __list_del_entry+0x63/0xd0()
[ 1799.433093] list_del corruption, ffff8807b4a7c000->next is LIST_POISON1 (dead000000100100)
[ 1799.532110] Modules linked in: nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables sg dm_mirror dm_region_hash dm_log dm_mod vfat fat e1000e igb iTCO_wdt iTCO_vendor_support ioatdma ptp i7core_edac ipmi_si edac_core lpc_ich pps_core i2c_i801 pcspkr mfd_core dca ipmi_msghandler acpi_cpufreq xfs libcrc32c sd_mod crc_t10dif crct10dif_common i2c_algo_bit drm_kms_helper ttm drm mptsas scsi_transport_sas mptscsih i2c_core megaraid_sas mptbase
[ 1800.276623] CPU: 7 PID: 126 Comm: kworker/u512:1 Tainted: G        W    3.12.0-rc5+ #196
[ 1800.508918] Workqueue: sysfsd sysfs_schedule_callback_work
[ 1800.574703]  0000000000000009 ffff8807adbadbd8 ffffffff8168b26c ffff8807c27d08a8
[ 1800.663860]  ffff8807adbadc28 ffff8807adbadc18 ffffffff810711dc ffff8807adbadc68
[ 1800.753130]  ffff8807b4a7c000 ffff8807b4a7c000 ffff8807ad089c00 0000000000000000
[ 1800.842282] Call Trace:
[ 1800.871651]  [<ffffffff8168b26c>] dump_stack+0x55/0x76
[ 1800.933301]  [<ffffffff810711dc>] warn_slowpath_common+0x8c/0xc0
[ 1801.005283]  [<ffffffff810712c6>] warn_slowpath_fmt+0x46/0x50
[ 1801.074081]  [<ffffffff8135a343>] __list_del_entry+0x63/0xd0
[ 1801.141839]  [<ffffffff8135a3c1>] list_del+0x11/0x40
[ 1801.201320]  [<ffffffff813734da>] pci_remove_bus_device+0x6a/0xe0
[ 1801.274279]  [<ffffffff8137356e>] pci_stop_and_remove_bus_device+0x1e/0x30
[ 1801.356606]  [<ffffffff8137b20b>] remove_callback+0x2b/0x40
[ 1801.423412]  [<ffffffff81251848>] sysfs_schedule_callback_work+0x18/0x60
[ 1801.503744]  [<ffffffff8108eab5>] process_one_work+0x1f5/0x540
[ 1801.573640]  [<ffffffff8108ea53>] ? process_one_work+0x193/0x540
[ 1801.645616]  [<ffffffff8108f2ac>] worker_thread+0x11c/0x370
[ 1801.712337]  [<ffffffff8108f190>] ? rescuer_thread+0x350/0x350
[ 1801.782178]  [<ffffffff8109731d>] kthread+0xed/0x100
[ 1801.841661]  [<ffffffff81097230>] ? kthread_create_on_node+0x160/0x160
[ 1801.919919]  [<ffffffff8169cc3c>] ret_from_fork+0x7c/0xb0
[ 1801.984608]  [<ffffffff81097230>] ? kthread_create_on_node+0x160/0x160
[ 1802.062825] ---[ end trace d77f2054de000fb7 ]---

This issue is related to the bug 54411:
https://bugzilla.kernel.org/show_bug.cgi?id=54411

Since we added the pci_bus reference management, the bug becomes a
invalid list entry warning as descripted above. Beacuse it still
trys to delete an deleted pci device from device list.

So here we make stop device actually detach driver only, and remove
device will do device_del instead, and move bus_list change and pci device
resource free into pci_release_dev, so that it'll consistent with
bus reference managment, and the device only can be deleted from device
list in pci_release_dev just for one time.

Besides, it also makes hostbridge to use device_unregister to be pair
with device_register before.

This patch is based on Yinghai's privious similar patch:
http://lkml.org/lkml/2013/5/13/658

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 drivers/pci/probe.c  | 23 +++++++++++++++++++++--
 drivers/pci/remove.c | 32 ++++++++------------------------
 2 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 7ef0f86..c639f44 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1156,6 +1156,21 @@ static void pci_release_capabilities(struct pci_dev *dev)
 	pci_free_cap_save_buffers(dev);
 }
 
+static void pci_free_resources(struct pci_dev *dev)
+{
+	int i;
+
+	msi_remove_pci_irq_vectors(dev);
+
+	pci_cleanup_rom(dev);
+	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
+		struct resource *res = dev->resource + i;
+
+		if (res->parent)
+			release_resource(res);
+	}
+}
+
 /**
  * pci_release_dev - free a pci device structure when all users of it are finished.
  * @dev: device that's been disconnected
@@ -1165,9 +1180,13 @@ static void pci_release_capabilities(struct pci_dev *dev)
  */
 static void pci_release_dev(struct device *dev)
 {
-	struct pci_dev *pci_dev;
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+
+	down_write(&pci_bus_sem);
+	list_del(&pci_dev->bus_list);
+	up_write(&pci_bus_sem);
+	pci_free_resources(pci_dev);
 
-	pci_dev = to_pci_dev(dev);
 	pci_release_capabilities(pci_dev);
 	pci_release_of_node(pci_dev);
 	pcibios_release_device(pci_dev);
diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index 8fc54b7..5659283 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -3,20 +3,6 @@
 #include <linux/pci-aspm.h>
 #include "pci.h"
 
-static void pci_free_resources(struct pci_dev *dev)
-{
-	int i;
-
- 	msi_remove_pci_irq_vectors(dev);
-
-	pci_cleanup_rom(dev);
-	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
-		struct resource *res = dev->resource + i;
-		if (res->parent)
-			release_resource(res);
-	}
-}
-
 static void pci_stop_dev(struct pci_dev *dev)
 {
 	pci_pme_active(dev, false);
@@ -24,8 +10,7 @@ static void pci_stop_dev(struct pci_dev *dev)
 	if (dev->is_added) {
 		pci_proc_detach_device(dev);
 		pci_remove_sysfs_dev_files(dev);
-		device_del(&dev->dev);
-		dev->is_added = 0;
+		device_release_driver(&dev->dev);
 	}
 
 	if (dev->bus->self)
@@ -34,12 +19,11 @@ static void pci_stop_dev(struct pci_dev *dev)
 
 static void pci_destroy_dev(struct pci_dev *dev)
 {
-	down_write(&pci_bus_sem);
-	list_del(&dev->bus_list);
-	up_write(&pci_bus_sem);
-
-	pci_free_resources(dev);
-	put_device(&dev->dev);
+	if (dev->is_added) {
+		device_del(&dev->dev);
+		put_device(&dev->dev);
+		dev->is_added = 0;
+	}
 }
 
 void pci_remove_bus(struct pci_bus *bus)
@@ -126,7 +110,7 @@ void pci_stop_root_bus(struct pci_bus *bus)
 		pci_stop_bus_device(child);
 
 	/* stop the host bridge */
-	device_del(&host_bridge->dev);
+	device_release_driver(&host_bridge->dev);
 }
 
 void pci_remove_root_bus(struct pci_bus *bus)
@@ -145,5 +129,5 @@ void pci_remove_root_bus(struct pci_bus *bus)
 	host_bridge->bus = NULL;
 
 	/* remove the host bridge */
-	put_device(&host_bridge->dev);
+	device_unregister(&host_bridge->dev);
 }
-- 
1.8.1


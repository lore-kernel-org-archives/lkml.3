Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397Ab3L1XGw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 18:06:52 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:49484 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751190Ab3L1XGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 18:06:49 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yinghai Lu <yinghai@kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH][tentative] PCI / ACPI: Rework PCI host bridge removal to avoid sysfs warnings
Date: Sun, 29 Dec 2013 00:20:22 +0100
Message-ID: <37552283.kG1L4S8Daa@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The device_del(&host_bridge->dev) in pci_stop_root_bus() is
problematic, because it causes all sysfs directories below
the host bridge to be removed recursively and when
pci_remove_root_bus() attempts to remove devices on the root
bus (whose sysfs directories are gone now along with all their
subdirectories), it causes warnings similar to this one to be
printed:

WARNING: CPU: 0 PID: 6 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
sysfs group ffffffff819ac5c0 not found for kobject '0001:ff:10.2'
Modules linked in: <irrelevant list>
CPU: 0 PID: 6 Comm: kworker/u512:0 Tainted: G        W    3.13.0-rc5+ #11
Hardware name:
Workqueue: kacpi_hotplug acpi_hotplug_work_fn
 0000000000000009 ffff8808738d3bd8 ffffffff815d84ea ffff8808738d3c20
 ffff8808738d3c10 ffffffff8106594d 0000000000000000 ffffffff819ac5c0
 ffff880871b9d0a8 ffff8a07d1895000 0000000000000103 ffff8808738d3c70
Call Trace:
 [<ffffffff815d84ea>] dump_stack+0x45/0x56
 [<ffffffff8106594d>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff810659bc>] warn_slowpath_fmt+0x4c/0x50
 [<ffffffff8122b52e>] ? sysfs_get_dirent_ns+0x4e/0x70
 [<ffffffff8122c806>] sysfs_remove_group+0xc6/0xd0
 [<ffffffff813b83f3>] dpm_sysfs_remove+0x43/0x50
 [<ffffffff813ae105>] device_del+0x45/0x1c0
 [<ffffffff812e51f6>] pci_remove_bus_device+0x66/0xd0
 [<ffffffff812e5363>] pci_remove_root_bus+0x73/0x80
 [<ffffffff813276ab>] acpi_pci_root_remove+0x42/0x4f
 [<ffffffff81323070>] acpi_bus_trim+0x56/0x89
 [<ffffffff81323052>] acpi_bus_trim+0x38/0x89
 [<ffffffff813245df>] acpi_device_hotplug+0x137/0x33b
 [<ffffffff8131efba>] acpi_hotplug_work_fn+0x1c/0x27
 [<ffffffff81080f1b>] process_one_work+0x17b/0x460
 [<ffffffff81081ccb>] worker_thread+0x11b/0x400
 [<ffffffff81081bb0>] ? rescuer_thread+0x3e0/0x3e0
 [<ffffffff81088a12>] kthread+0xd2/0xf0
 [<ffffffff81088940>] ? kthread_create_on_node+0x180/0x180
 [<ffffffff815e823c>] ret_from_fork+0x7c/0xb0
 [<ffffffff81088940>] ? kthread_create_on_node+0x180/0x180

To avoid that, the host bridge device has to be deleted after all of
its children, so merge pci_stop_root_bus() and pci_remove_root_bus()
into one function, pci_stop_and_remove_root_bus(), that first will
use pci_stop_and_remove_bus_device() to stop and remove all devices
on the root bus and then will delete the host bridge device, remove
its bus and drop the final reference to it.

Reported-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Hi,

I can't really test this patch, but I don't know how it can break anything.

The only user of pci_stop_root_bus() and pci_remove_root_bus() is
acpi_pci_root_remove() and the code ordering there seems to be somewhat
arbitrary.  If you are aware of any reason why it may not work, please let
me know. :-)

Thanks,
Rafael

---
 drivers/acpi/pci_root.c |    4 +---
 drivers/pci/remove.c    |   23 ++++-------------------
 include/linux/pci.h     |    3 +--
 3 files changed, 6 insertions(+), 24 deletions(-)

Index: linux-pm/drivers/acpi/pci_root.c
===================================================================
--- linux-pm.orig/drivers/acpi/pci_root.c
+++ linux-pm/drivers/acpi/pci_root.c
@@ -611,12 +611,10 @@ static void acpi_pci_root_remove(struct
 {
 	struct acpi_pci_root *root = acpi_driver_data(device);
 
-	pci_stop_root_bus(root->bus);
-
 	device_set_run_wake(root->bus->bridge, false);
 	pci_acpi_remove_bus_pm_notifier(device);
 
-	pci_remove_root_bus(root->bus);
+	pci_stop_and_remove_root_bus(root->bus);
 
 	kfree(root);
 }
Index: linux-pm/drivers/pci/remove.c
===================================================================
--- linux-pm.orig/drivers/pci/remove.c
+++ linux-pm/drivers/pci/remove.c
@@ -114,7 +114,7 @@ void pci_stop_and_remove_bus_device(stru
 }
 EXPORT_SYMBOL(pci_stop_and_remove_bus_device);
 
-void pci_stop_root_bus(struct pci_bus *bus)
+void pci_stop_and_remove_root_bus(struct pci_bus *bus)
 {
 	struct pci_dev *child, *tmp;
 	struct pci_host_bridge *host_bridge;
@@ -123,29 +123,14 @@ void pci_stop_root_bus(struct pci_bus *b
 		return;
 
 	host_bridge = to_pci_host_bridge(bus->bridge);
-	list_for_each_entry_safe_reverse(child, tmp,
-					 &bus->devices, bus_list)
-		pci_stop_bus_device(child);
+	list_for_each_entry_safe_reverse(child, tmp, &bus->devices, bus_list)
+		pci_stop_and_remove_bus_device(child);
 
 	/* stop the host bridge */
 	device_del(&host_bridge->dev);
-}
-
-void pci_remove_root_bus(struct pci_bus *bus)
-{
-	struct pci_dev *child, *tmp;
-	struct pci_host_bridge *host_bridge;
-
-	if (!pci_is_root_bus(bus))
-		return;
-
-	host_bridge = to_pci_host_bridge(bus->bridge);
-	list_for_each_entry_safe(child, tmp,
-				 &bus->devices, bus_list)
-		pci_remove_bus_device(child);
+	/* remove the root bus */
 	pci_remove_bus(bus);
 	host_bridge->bus = NULL;
-
 	/* remove the host bridge */
 	put_device(&host_bridge->dev);
 }
Index: linux-pm/include/linux/pci.h
===================================================================
--- linux-pm.orig/include/linux/pci.h
+++ linux-pm/include/linux/pci.h
@@ -779,8 +779,7 @@ struct pci_dev *pci_dev_get(struct pci_d
 void pci_dev_put(struct pci_dev *dev);
 void pci_remove_bus(struct pci_bus *b);
 void pci_stop_and_remove_bus_device(struct pci_dev *dev);
-void pci_stop_root_bus(struct pci_bus *bus);
-void pci_remove_root_bus(struct pci_bus *bus);
+void pci_stop_and_remove_root_bus(struct pci_bus *bus);
 void pci_setup_cardbus(struct pci_bus *bus);
 void pci_sort_breadthfirst(void);
 #define dev_is_pci(d) ((d)->bus == &pci_bus_type)


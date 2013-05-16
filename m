Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab3EPPvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 11:51:45 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:49222 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab3EPPvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 11:51:40 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2, part3 06/11] PCI, sysfs: use PCI bus lock to serialize hotplug operations triggered by sysfs
Date: Thu, 16 May 2013 23:50:54 +0800
Message-Id: <1368719459-24800-7-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368719459-24800-1-git-send-email-jiang.liu@huawei.com>
References: <1368719459-24800-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PCI bus lock to serialize hotplug operations triggered by pci-sysfs,
and remove the redundant local mutex pci_remove_rescan_mutex.

This also fixes the bug reported by Gu Zheng as:
	echo -n 1 > /sys/bus/pci/devices/0000\:10\:00.0/remove ; echo -n 1 >
/sys/bus/pci/devices/0000\:1a\:01.0/remove

will cause kernel crash as bus get freed.

[  418.946462] CPU 4
[  418.968377] Pid: 512, comm: kworker/u:2 Tainted: G        W    3.8.0 #2
FUJITSU-SV PRIMEQUEST 1800E/SB
[  419.081763] RIP: 0010:[<ffffffff8137972e>]  [<ffffffff8137972e>]
pci_bus_read_config_word+0x5e/0x90
[  420.494137] Call Trace:
[  420.523326]  [<ffffffff813851ef>] ? remove_callback+0x1f/0x40
[  420.591984]  [<ffffffff8138044b>] pci_pme_active+0x4b/0x1c0
[  420.658545]  [<ffffffff8137d8e7>] pci_stop_bus_device+0x57/0xb0
[  420.729259]  [<ffffffff8137dab6>] pci_stop_and_remove_bus_device+0x16/0x30
[  420.811392]  [<ffffffff813851fb>] remove_callback+0x2b/0x40
[  420.877955]  [<ffffffff81257a56>] sysfs_schedule_callback_work+0x26/0x70

https://bugzilla.kernel.org/show_bug.cgi?id=54411

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Reported-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pci/pci-sysfs.c | 52 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 18 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index fcc4bb2..91ff11e 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -284,7 +284,6 @@ msi_bus_store(struct device *dev, struct device_attribute *attr,
 	return count;
 }
 
-static DEFINE_MUTEX(pci_remove_rescan_mutex);
 static ssize_t bus_rescan_store(struct bus_type *bus, const char *buf,
 				size_t count)
 {
@@ -293,13 +292,15 @@ static ssize_t bus_rescan_store(struct bus_type *bus, const char *buf,
 
 	if (strict_strtoul(buf, 0, &val) < 0)
 		return -EINVAL;
+	if (!val)
+		return count;
 
-	if (val) {
-		mutex_lock(&pci_remove_rescan_mutex);
-		for_each_pci_root_bus(b)
+	for_each_pci_root_bus(b)
+		if (pci_bus_lock(b, PCI_BUS_STATE_STOPPING - 1, true) == 0) {
 			pci_rescan_bus(b);
-		mutex_unlock(&pci_remove_rescan_mutex);
-	}
+			pci_bus_unlock(b, true);
+		}
+
 	return count;
 }
 
@@ -312,27 +313,41 @@ static ssize_t
 dev_rescan_store(struct device *dev, struct device_attribute *attr,
 		 const char *buf, size_t count)
 {
+	int ret;
 	unsigned long val;
 	struct pci_dev *pdev = to_pci_dev(dev);
 
 	if (strict_strtoul(buf, 0, &val) < 0)
 		return -EINVAL;
+	if (!val)
+		return count;
+
+	do {
+		ret = pci_bus_lock_timeout(pdev->bus,
+				PCI_BUS_STATE_STOPPING - 1, true, HZ);
+		if (ret == 0) {
+			pci_rescan_bus(pdev->bus);
+			pci_bus_unlock(pdev->bus, true);
+			break;
+		}
+		/*
+		 * Prevent a deadlock scenario that thread A waits for
+		 * all sysfs files to be released while holding PCI bus
+		 * locks, and Thread B tries to acquire PCI bus locks
+		 * in a sysfs handler. These checks break the deadlock
+		 * condition.
+		 */
+		if (pci_dev_get_state(pdev) >= PCI_DEV_STATE_STOPPING ||
+		    pci_bus_get_state(pdev->bus) >= PCI_BUS_STATE_STOPPING)
+			return -EBUSY;
+	} while (true);
 
-	if (val) {
-		mutex_lock(&pci_remove_rescan_mutex);
-		pci_rescan_bus(pdev->bus);
-		mutex_unlock(&pci_remove_rescan_mutex);
-	}
 	return count;
 }
 
 static void remove_callback(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-
-	mutex_lock(&pci_remove_rescan_mutex);
-	pci_stop_and_remove_bus_device(pdev);
-	mutex_unlock(&pci_remove_rescan_mutex);
+	pci_stop_and_remove_device(to_pci_dev(dev));
 }
 
 static ssize_t
@@ -366,12 +381,13 @@ dev_bus_rescan_store(struct device *dev, struct device_attribute *attr,
 		return -EINVAL;
 
 	if (val) {
-		mutex_lock(&pci_remove_rescan_mutex);
+		if (pci_bus_lock(bus, PCI_BUS_STATE_STOPPING - 1, true) < 0)
+			return -EBUSY;
 		if (!pci_is_root_bus(bus) && list_empty(&bus->devices))
 			pci_rescan_bus_bridge_resize(bus->self);
 		else
 			pci_rescan_bus(bus);
-		mutex_unlock(&pci_remove_rescan_mutex);
+		pci_bus_unlock(bus, true);
 	}
 	return count;
 }
-- 
1.8.1.2


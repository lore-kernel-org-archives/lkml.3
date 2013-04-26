Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759869Ab3DZBrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 21:47:20 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46951 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759843Ab3DZBrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 21:47:16 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] PCI: Fix racing for pci device removing via sysfs
Date: Thu, 25 Apr 2013 18:47:21 -0700
Message-Id: <1366940841-15370-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gu found nested removing through
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

We have one patch that will let device hold bus ref to prevent it from
being freed, but that will still generate warning.

------------[ cut here ]------------
WARNING: at lib/list_debug.c:53 __list_del_entry+0x63/0xd0()
Hardware name: PRIMEQUEST 1800E
list_del corruption, ffff8807d1b6c000->next is LIST_POISON1 (dead000000100100)
Call Trace:
 [<ffffffff81056d4f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff81056e46>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff81280b13>] __list_del_entry+0x63/0xd0
 [<ffffffff81280b91>] list_del+0x11/0x40
 [<ffffffff81298331>] pci_destroy_dev+0x31/0xc0
 [<ffffffff812985bb>] pci_remove_bus_device+0x5b/0x70
 [<ffffffff812985ee>] pci_stop_and_remove_bus_device+0x1e/0x30
 [<ffffffff8129fc89>] remove_callback+0x29/0x40
 [<ffffffff811f3b84>] sysfs_schedule_callback_work+0x24/0x70

We can just check if the device get removed from pci tree
already in the protection under pci_remove_rescan_mutex.

Reported-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Tested-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/pci-sysfs.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/pci-sysfs.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-sysfs.c
+++ linux-2.6/drivers/pci/pci-sysfs.c
@@ -329,9 +329,16 @@ dev_rescan_store(struct device *dev, str
 static void remove_callback(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
+	int domain = pci_domain_nr(pdev->bus);
+	u8 bus = pdev->bus->number;
+	u8 devfn = pdev->devfn;
 
 	mutex_lock(&pci_remove_rescan_mutex);
-	pci_stop_and_remove_bus_device(pdev);
+	pdev = pci_get_domain_bus_and_slot(domain, bus, devfn);
+	if (pdev) {
+		pci_dev_put(pdev);
+		pci_stop_and_remove_bus_device(pdev);
+	}
 	mutex_unlock(&pci_remove_rescan_mutex);
 }
 

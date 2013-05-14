Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab3ENC3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 22:29:24 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19454 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174Ab3ENC2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 22:28:53 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 4/7] PCI: Fix racing for pci device removing via sysfs
Date: Mon, 13 May 2013 19:28:23 -0700
Message-Id: <1368498506-25857-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1368498506-25857-1-git-send-email-yinghai@kernel.org>
References: <1368498506-25857-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
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

Bjorn pointed out that pci_dev should retain its reference to the pci_bus
for as long as the pci_dev exists, so the release reference should go in
pci_release_dev() instead.

At last we will not need to touch pci-sysfs bits.

-v6: split other changes to other patches.

Reported-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/probe.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/drivers/pci/probe.c
===================================================================
--- linux-2.6.orig/drivers/pci/probe.c
+++ linux-2.6/drivers/pci/probe.c
@@ -1149,6 +1149,7 @@ static void pci_release_dev(struct devic
 	list_del(&pci_dev->bus_list);
 	up_write(&pci_bus_sem);
 	pci_free_resources(pci_dev);
+	put_device(&pci_dev->bus->dev);
 
 	pci_release_capabilities(pci_dev);
 	pci_release_of_node(pci_dev);
@@ -1360,6 +1361,7 @@ void pci_device_add(struct pci_dev *dev,
 	down_write(&pci_bus_sem);
 	list_add_tail(&dev->bus_list, &bus->devices);
 	up_write(&pci_bus_sem);
+	get_device(&bus->dev);
 
 	ret = pcibios_add_device(dev);
 	WARN_ON(ret < 0);

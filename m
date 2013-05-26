Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab3EZP5i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 11:57:38 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:46125 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab3EZP52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 11:57:28 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3, part2 04/20] PCI, IOV: hold a reference to PCI bus when creating virtual PCI devices
Date: Sun, 26 May 2013 23:53:01 +0800
Message-Id: <1369583597-3801-5-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369583597-3801-1-git-send-email-jiang.liu@huawei.com>
References: <1369583597-3801-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also use new iterator to walk PCI devices of a PCI bus.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/pci/iov.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 5eb8165..4b796d6 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -36,19 +36,17 @@ static struct pci_bus *virtfn_add_bus(struct pci_bus *bus, int busnr)
 	struct pci_bus *child;
 
 	if (bus->number == busnr)
-		return bus;
+		return pci_bus_get(bus);
 
-	child = pci_find_bus(pci_domain_nr(bus), busnr);
+	child = pci_get_bus(pci_domain_nr(bus), busnr);
 	if (child)
 		return child;
 
 	child = pci_add_new_bus(bus, NULL, busnr);
-	if (!child)
-		return NULL;
-
-	pci_bus_insert_busn_res(child, busnr, busnr);
+	if (child)
+		pci_bus_insert_busn_res(child, busnr, busnr);
 
-	return child;
+	return pci_bus_get(child);
 }
 
 static void virtfn_remove_bus(struct pci_bus *physbus, struct pci_bus *virtbus)
@@ -113,6 +111,7 @@ static int virtfn_add(struct pci_dev *dev, int id, int reset)
 		goto failed2;
 
 	kobject_uevent(&virtfn->dev.kobj, KOBJ_CHANGE);
+	pci_bus_put(bus);
 
 	return 0;
 
@@ -125,6 +124,7 @@ failed1:
 	virtfn_remove_bus(dev->bus, bus);
 failed0:
 	mutex_unlock(&iov->dev->sriov->lock);
+	pci_bus_put(bus);
 
 	return rc;
 }
-- 
1.8.1.2


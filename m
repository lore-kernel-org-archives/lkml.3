Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab3DLPqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 11:46:15 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:37451 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab3DLPqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 11:46:12 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v9 01/16] PCI: do not check is_added flag in pci_remove_bus()
Date: Fri, 12 Apr 2013 23:44:15 +0800
Message-Id: <1365781470-32379-2-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365781470-32379-1-git-send-email-jiang.liu@huawei.com>
References: <1365781470-32379-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The is_added flag in struct pci_bus is always set after invoking
device_register() and pci_create_legacy_files(). The related code
paths are:
1) pci_create_root_bus() and pci_add_new_bus()
	bus = pci_alloc_bus()
	device_register(&bus->dev)
	pci_create_legacy_file(bus)
2.a) pci_scan_child_bus(bus)
	set is_added flag for PCI root buses
2.b) pci_bus_add_devices(bus)
	set is_added flag for normal PCI buses

So pci_remove_bus() shouldn't use is_added flag to guard invoking of
pci_remove_lagecy_files() and device_unregister().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pci/remove.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index cc875e6..a831880 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -50,9 +50,6 @@ void pci_remove_bus(struct pci_bus *bus)
 	list_del(&bus->node);
 	pci_bus_release_busn_res(bus);
 	up_write(&pci_bus_sem);
-	if (!bus->is_added)
-		return;
-
 	pci_remove_legacy_files(bus);
 	device_unregister(&bus->dev);
 }
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab3A3QMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 11:12:17 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:45008 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab3A3QMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 11:12:15 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yijing Wang <wangyijing@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH 1/2] acpiphp: create companion ACPI devices before creating PCI devices
Date: Thu, 31 Jan 2013 00:10:09 +0800
Message-Id: <1359562210-26536-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

With commit 4f535093cf8f6da8c "PCI: Put pci_dev in device tree as
early as possible", companion ACPI devices should be created before
creating correspoding PCI devices, otherwise it will break the ACPI
PCI binding logic.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
Hi Bjorn,
	This patch set applies to your pci/yinghai-root-bus branch.
There are still other potential bugs in the acpiphp driver under
investigation. So I will send out these two first to catch up with
the 3.9 merging window.
	Thanks!
	Gerry
---
 drivers/pci/hotplug/acpiphp_glue.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index bd784ff..acb7af2 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -839,6 +839,9 @@ static int __ref enable_device(struct acpiphp_slot *slot)
 	if (slot->flags & SLOT_ENABLED)
 		goto err_exit;
 
+	list_for_each_entry(func, &slot->funcs, sibling)
+		acpiphp_bus_add(func);
+
 	num = pci_scan_slot(bus, PCI_DEVFN(slot->device, 0));
 	if (num == 0) {
 		/* Maybe only part of funcs are added. */
@@ -862,9 +865,6 @@ static int __ref enable_device(struct acpiphp_slot *slot)
 		}
 	}
 
-	list_for_each_entry(func, &slot->funcs, sibling)
-		acpiphp_bus_add(func);
-
 	pci_bus_assign_resources(bus);
 	acpiphp_sanitize_bus(bus);
 	acpiphp_set_hpp_values(bus);
-- 
1.7.9.5


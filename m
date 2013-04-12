Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab3DLPqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 11:46:38 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:63944 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931Ab3DLPqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 11:46:34 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v9 04/16] PCI/acpiphp: don't rely on function 0 in disable_device()
Date: Fri, 12 Apr 2013 23:44:18 +0800
Message-Id: <1365781470-32379-5-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365781470-32379-1-git-send-email-jiang.liu@huawei.com>
References: <1365781470-32379-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently function disable_device() detects slot state by checking
existence of PCI device for function 0. It's unreliable because PCI
device for function 0 may be removed through sysfs interface. If that
happens, it will cause powering off a hotplug slot without destroying
all PCI devices.

On the other hand, it won't hurt us except wasting some computation
power if the check is removed, because all code of disable_device()
is self-protected. So remove the check.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pci/hotplug/acpiphp_glue.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 7948bc9..a1c8dd6 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -914,13 +914,6 @@ static int disable_device(struct acpiphp_slot *slot)
 	struct pci_dev *pdev;
 	struct pci_bus *bus = slot->bridge->pci_bus;
 
-	/* The slot will be enabled when func 0 is added, so check
-	   func 0 before disable the slot. */
-	pdev = pci_get_slot(bus, PCI_DEVFN(slot->device, 0));
-	if (!pdev)
-		goto err_exit;
-	pci_dev_put(pdev);
-
 	list_for_each_entry(func, &slot->funcs, sibling) {
 		if (func->bridge) {
 			/* cleanup p2p bridges under this P2P bridge */
-- 
1.7.9.5


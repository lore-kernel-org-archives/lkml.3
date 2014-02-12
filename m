Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbaBLCz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 21:55:56 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:21463 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbaBLCxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 21:53:25 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>,
        Oliver Neukum <oneukum@suse.de>, Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: [PATCH part1 v6 7/7] PCI: pciehp: Don't enable/disable slot on resume unless status changed
Date: Wed, 12 Feb 2014 10:52:53 +0800
Message-ID: <1392173573-59844-8-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
In-Reply-To: <1392173573-59844-1-git-send-email-wangyijing@huawei.com>
References: <1392173573-59844-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently pciehp_resume() always enables the slot if it is occupied.  But
often the slot was already occupied before the suspend, so we complain like
this:

    pciehp 0000:00:1c.1:pcie04: Device 0000:03:00.0 already exists at 0000:03:00, cannot hot-add
    pciehp 0000:00:1c.1:pcie04: Cannot add device at 0000:03:00

This patch only enables the slot if it was empty before the suspend and is
now occupied, i.e., a card was inserted while suspended.

Similarly, we only disable the slot if a card was removed while suspended.
If it was already empty before the suspend, we don't need to do anything.

[bhelgaas: changelog]
Tested-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Oliver Neukum <oneukum@suse.de>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 drivers/pci/hotplug/pciehp_core.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 53b58de..551137f 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -317,6 +317,7 @@ static int pciehp_resume (struct pcie_device *dev)
 {
 	struct controller *ctrl;
 	struct slot *slot;
+	struct pci_bus *pbus = dev->port->subordinate;
 	u8 status;
 
 	ctrl = get_service_data(dev);
@@ -328,10 +329,13 @@ static int pciehp_resume (struct pcie_device *dev)
 
 	/* Check if slot is occupied */
 	pciehp_get_adapter_status(slot, &status);
-	if (status)
-		pciehp_enable_slot(slot);
-	else
+	if (status) {
+		if (list_empty(&pbus->devices))
+			pciehp_enable_slot(slot);
+	} else if (!list_empty(&pbus->devices)) {
 		pciehp_disable_slot(slot);
+	}
+
 	return 0;
 }
 #endif /* PM */
-- 
1.7.1



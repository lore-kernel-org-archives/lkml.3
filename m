Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab3A1KAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 05:00:55 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:59721 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751390Ab3A1KAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 05:00:54 -0500
Message-ID: <1359367251.883.13.camel@x61.thuisdomein>
Subject: [PATCH] PCI: pciehp: hide ENTRY messages behind ctrl_dbg()
From: Paul Bolle <pebolle@tiscali.nl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 28 Jan 2013 11:00:51 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2013 10:00:52.0017 (UTC) FILETIME=[5B007A10:01CDFD3E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In each suspend and resume cycle my laptop prints these messages at
KERN_INFO level:
    pciehp 0000:00:1c.1:pcie04: pciehp_suspend ENTRY
    pciehp 0000:00:1c.0:pcie04: pciehp_suspend ENTRY

and
    pciehp 0000:00:1c.0:pcie04: pciehp_resume ENTRY
    pciehp 0000:00:1c.1:pcie04: pciehp_resume ENTRY

Messages like these are probably only useful while debugging pciehp, so
let's hide them behind the ctrl_dbg() macro.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Compile tested only!

1) Perhaps a better solution is to drop these messages entirely.

 drivers/pci/hotplug/pciehp_core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 939bd1d..ed1702d 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -293,7 +293,8 @@ static void pciehp_remove(struct pcie_device *dev)
 #ifdef CONFIG_PM
 static int pciehp_suspend (struct pcie_device *dev)
 {
-	dev_info(&dev->device, "%s ENTRY\n", __func__);
+	struct controller *ctrl = get_service_data(dev);
+	ctrl_dbg(ctrl, "%s ENTRY\n", __func__);
 	return 0;
 }
 
@@ -303,8 +304,8 @@ static int pciehp_resume (struct pcie_device *dev)
 	struct slot *slot;
 	u8 status;
 
-	dev_info(&dev->device, "%s ENTRY\n", __func__);
 	ctrl = get_service_data(dev);
+	ctrl_dbg(ctrl, "%s ENTRY\n", __func__);
 
 	/* reinitialize the chipset's event detection logic */
 	pcie_enable_notification(ctrl);
-- 
1.7.11.7


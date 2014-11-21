Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaKUWSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 17:18:38 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:19983 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbaKUWSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 17:18:03 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, bhelgaas@google.com, linux@eikelenboom.it
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v4 3/7] xen/pciback: Include the domain id if removing the device whilst still in use
Date: Fri, 21 Nov 2014 17:17:47 -0500
Message-Id: <1416608271-18931-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416608271-18931-1-git-send-email-konrad.wilk@oracle.com>
References: <1416608271-18931-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the function a bit - also include the id of the
domain that is using the device.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
---
 drivers/xen/xen-pciback/pci_stub.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index 8b77089..e5ff09d 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -553,12 +553,14 @@ static void pcistub_remove(struct pci_dev *dev)
 	spin_unlock_irqrestore(&pcistub_devices_lock, flags);
 
 	if (found_psdev) {
-		dev_dbg(&dev->dev, "found device to remove - in use? %p\n",
-			found_psdev->pdev);
+		dev_dbg(&dev->dev, "found device to remove %s\n",
+			found_psdev->pdev ? "- in-use" : "");
 
 		if (found_psdev->pdev) {
-			pr_warn("****** removing device %s while still in-use! ******\n",
-			       pci_name(found_psdev->dev));
+			int domid = xen_find_device_domain_owner(dev);
+
+			pr_warn("****** removing device %s while still in-use by domain %d! ******\n",
+			       pci_name(found_psdev->dev), domid);
 			pr_warn("****** driver domain may still access this device's i/o resources!\n");
 			pr_warn("****** shutdown driver domain before binding device\n");
 			pr_warn("****** to other drivers or domains\n");
-- 
1.9.3


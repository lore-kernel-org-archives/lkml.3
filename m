Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbaGHR5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 13:57:45 -0400
Received: from mail.kernel.org ([198.145.19.201]:54875 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755345AbaGHR5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 13:57:07 -0400
From: konrad@kernel.org
To: xen-devel@lists.xenproject.org, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v3 5/7] xen/pciback: Include the domain id if removing the device whilst still in use
Date: Tue,  8 Jul 2014 14:58:27 -0400
Message-Id: <1404845909-13563-6-git-send-email-konrad@kernel.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1404845909-13563-1-git-send-email-konrad@kernel.org>
References: <1404845909-13563-1-git-send-email-konrad@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Cleanup the function a bit - also include the id of the
domain that is using the device.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-pciback/pci_stub.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index 6bb6be8..df485ec 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -615,12 +615,14 @@ static void pcistub_remove(struct pci_dev *dev)
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
1.7.7.6


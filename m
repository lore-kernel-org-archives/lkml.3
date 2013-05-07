Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852Ab3EGX3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 19:29:44 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:48429 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab3EGX3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 19:29:42 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Doug Thompson <dougthompson@xmission.com>
Cc: linux-pci@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] PCI, EDAC: fix ordering assign resource and bus_add
Date: Tue,  7 May 2013 16:29:31 -0700
Message-Id: <1367969371-27414-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should assign unassigned resource before pci_bus_add_device.

as late one will enable driver and create sysfs file that will need
pci io resources from assign unassigned code.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/edac/i82875p_edac.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/edac/i82875p_edac.c
===================================================================
--- linux-2.6.orig/drivers/edac/i82875p_edac.c
+++ linux-2.6/drivers/edac/i82875p_edac.c
@@ -293,13 +293,14 @@ static int i82875p_setup_overfl_dev(stru
 		if (dev == NULL)
 			return 1;
 
+		pci_bus_assign_resources(dev->bus);
+
 		err = pci_bus_add_device(dev);
 		if (err) {
 			i82875p_printk(KERN_ERR,
 				"%s(): pci_bus_add_device() Failed\n",
 				__func__);
 		}
-		pci_bus_assign_resources(dev->bus);
 	}
 
 	*ovrfl_pdev = dev;

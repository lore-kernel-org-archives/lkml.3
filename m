Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298AbaKGBSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 20:18:44 -0500
Received: from exprod5og121.obsmtp.com ([64.18.0.139]:56901 "HELO
	exprod5og121.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750998AbaKGBSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 20:18:41 -0500
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Nov 2014 20:18:41 EST
From: Duc Dang <dhdang@apm.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Liviu Dudau <liviu.dudau@arm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, patches@apm.com,
        jcm@redhat.com, Duc Dang <dhdang@apm.com>,
        Tanmay Inamdar <tinamdar@apm.com>
Subject: [PATCH 1/1] PCI: X-Gene: assign resource to bus before adding new devices
Date: Thu,  6 Nov 2014 17:14:18 -0800
Message-Id: <1415322858-4318-1-git-send-email-dhdang@apm.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

X-Gene PCIE driver currently depends on Liviu Dudau's patch
https://lkml.org/lkml/2014/9/30/166 in order to assign resource
to root bus and endpoint devices. The patch was dropped because
it will break x86, powerpc and probably others. So X-Gene PCIE
host functionality is currently broken.

This patch adds function calls to create and scan root_bus as well
as assign unassigned bus resource (similar to Liviu Dudau's patch
above). This will help resolve the dependency to Liviu Dudau's patch
and make X-Gene PCIE work in latest open-source kernel.

Signed-off-by: Duc Dang <dhdang@apm.com>
Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
---
 drivers/pci/host/pci-xgene.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/host/pci-xgene.c b/drivers/pci/host/pci-xgene.c
index 9ecabfa..2988fe1 100644
--- a/drivers/pci/host/pci-xgene.c
+++ b/drivers/pci/host/pci-xgene.c
@@ -631,10 +631,15 @@ static int xgene_pcie_probe_bridge(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	bus = pci_scan_root_bus(&pdev->dev, 0, &xgene_pcie_ops, port, &res);
+	bus = pci_create_root_bus(&pdev->dev, 0,
+					&xgene_pcie_ops, port, &res);
 	if (!bus)
 		return -ENOMEM;
 
+	pci_scan_child_bus(bus);
+	pci_assign_unassigned_bus_resources(bus);
+	pci_bus_add_devices(bus);
+
 	platform_set_drvdata(pdev, port);
 	return 0;
 }
-- 
1.8.2.1


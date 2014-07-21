Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaGTXoG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 19:44:06 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63334 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751301AbaGTXoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 19:44:04 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH] PCI / PM: Drop unused runtime PM support code for PCIe ports
Date: Mon, 21 Jul 2014 02:02:23 +0200
Message-ID: <1722733.TI67PLqUAC@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Since commit de7d5f729c72 (PCI/PM: Disable runtime PM of PCIe ports)
the runtime PM support code for PCIe ports in portdrv_pci.c has never
been used, so drop it entirely.

If we are to support runtime PM of PCIe ports, it will have to be
done in a different way most likely anyway.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/pcie/portdrv_pci.c |   74 -----------------------------------------
 1 file changed, 74 deletions(-)

Index: linux-pm/drivers/pci/pcie/portdrv_pci.c
===================================================================
--- linux-pm.orig/drivers/pci/pcie/portdrv_pci.c
+++ linux-pm/drivers/pci/pcie/portdrv_pci.c
@@ -93,77 +93,6 @@ static int pcie_port_resume_noirq(struct
 	return 0;
 }
 
-#ifdef CONFIG_PM_RUNTIME
-struct d3cold_info {
-	bool no_d3cold;
-	unsigned int d3cold_delay;
-};
-
-static int pci_dev_d3cold_info(struct pci_dev *pdev, void *data)
-{
-	struct d3cold_info *info = data;
-
-	info->d3cold_delay = max_t(unsigned int, pdev->d3cold_delay,
-				   info->d3cold_delay);
-	if (pdev->no_d3cold)
-		info->no_d3cold = true;
-	return 0;
-}
-
-static int pcie_port_runtime_suspend(struct device *dev)
-{
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct d3cold_info d3cold_info = {
-		.no_d3cold	= false,
-		.d3cold_delay	= PCI_PM_D3_WAIT,
-	};
-
-	/*
-	 * If any subordinate device disable D3cold, we should not put
-	 * the port into D3cold.  The D3cold delay of port should be
-	 * the max of that of all subordinate devices.
-	 */
-	pci_walk_bus(pdev->subordinate, pci_dev_d3cold_info, &d3cold_info);
-	pdev->no_d3cold = d3cold_info.no_d3cold;
-	pdev->d3cold_delay = d3cold_info.d3cold_delay;
-	return 0;
-}
-
-static int pcie_port_runtime_resume(struct device *dev)
-{
-	return 0;
-}
-
-static int pci_dev_pme_poll(struct pci_dev *pdev, void *data)
-{
-	bool *pme_poll = data;
-
-	if (pdev->pme_poll)
-		*pme_poll = true;
-	return 0;
-}
-
-static int pcie_port_runtime_idle(struct device *dev)
-{
-	struct pci_dev *pdev = to_pci_dev(dev);
-	bool pme_poll = false;
-
-	/*
-	 * If any subordinate device needs pme poll, we should keep
-	 * the port in D0, because we need port in D0 to poll it.
-	 */
-	pci_walk_bus(pdev->subordinate, pci_dev_pme_poll, &pme_poll);
-	/* Delay for a short while to prevent too frequent suspend/resume */
-	if (!pme_poll)
-		pm_schedule_suspend(dev, 10);
-	return -EBUSY;
-}
-#else
-#define pcie_port_runtime_suspend	NULL
-#define pcie_port_runtime_resume	NULL
-#define pcie_port_runtime_idle		NULL
-#endif
-
 static const struct dev_pm_ops pcie_portdrv_pm_ops = {
 	.suspend	= pcie_port_device_suspend,
 	.resume		= pcie_port_device_resume,
@@ -172,9 +101,6 @@ static const struct dev_pm_ops pcie_port
 	.poweroff	= pcie_port_device_suspend,
 	.restore	= pcie_port_device_resume,
 	.resume_noirq	= pcie_port_resume_noirq,
-	.runtime_suspend = pcie_port_runtime_suspend,
-	.runtime_resume = pcie_port_runtime_resume,
-	.runtime_idle	= pcie_port_runtime_idle,
 };
 
 #define PCIE_PORTDRV_PM_OPS	(&pcie_portdrv_pm_ops)


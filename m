Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab3C3Wad (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 18:30:33 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:48096 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951Ab3C3Wab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 18:30:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: [Update][PATCH] PCI / PM: Disable runtime PM of PCIe ports
Date: Sat, 30 Mar 2013 23:38:02 +0100
Message-ID: <1378320.ernsY1JWPv@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <2990024.LMTIBUbM3d@vostro.rjw.lan>
References: <2282655.IicBMMa6jN@vostro.rjw.lan> <51548C9E.9090703@fold.natur.cuni.cz> <2990024.LMTIBUbM3d@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The runtime PM of PCIe ports turns out to be quite fragile, as in
some cases things work while in some other cases they don't and we
don't seem to have a good way to determine whether or not they are
going to work in advance.

For this reason, avoid enabling runtime PM for PCIe ports by
keeping their runtime PM reference counters always above 0 for the
time being.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

This version also removes the no longer necessary (and empty anyway)
port_runtime_pm_black_list[] table.

Thanks,
Rafael

---
 drivers/pci/pcie/portdrv_pci.c |   13 -------------
 1 file changed, 13 deletions(-)

Index: linux-pm/drivers/pci/pcie/portdrv_pci.c
===================================================================
--- linux-pm.orig/drivers/pci/pcie/portdrv_pci.c
+++ linux-pm/drivers/pci/pcie/portdrv_pci.c
@@ -185,14 +185,6 @@ static const struct dev_pm_ops pcie_port
 #endif /* !PM */
 
 /*
- * PCIe port runtime suspend is broken for some chipsets, so use a
- * black list to disable runtime PM for these chipsets.
- */
-static const struct pci_device_id port_runtime_pm_black_list[] = {
-	{ /* end: all zeroes */ }
-};
-
-/*
  * pcie_portdrv_probe - Probe PCI-Express port devices
  * @dev: PCI-Express port device being probed
  *
@@ -225,16 +217,11 @@ static int pcie_portdrv_probe(struct pci
 	 * it by default.
 	 */
 	dev->d3cold_allowed = false;
-	if (!pci_match_id(port_runtime_pm_black_list, dev))
-		pm_runtime_put_noidle(&dev->dev);
-
 	return 0;
 }
 
 static void pcie_portdrv_remove(struct pci_dev *dev)
 {
-	if (!pci_match_id(port_runtime_pm_black_list, dev))
-		pm_runtime_get_noresume(&dev->dev);
 	pcie_port_device_remove(dev);
 	pci_disable_device(dev);
 }


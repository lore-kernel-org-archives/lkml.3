Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879Ab3EGEHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:07:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28906 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933013Ab3EGD6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:49 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=oOatHhGTwy0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=vfaDjNAdsaAA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=Y6XfvEXCWxnrHKSuoGMA:9 a=dGJ0OcVc7YAA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035843.606433436@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [016/126] PCI/PM: Disable runtime PM of PCIe ports
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0016-PCI-PM-Disable-runtime-PM-of-PCIe-ports.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit de7d5f729c72638f41d7c17487bccb1c570ff144 ]

The runtime PM of PCIe ports turns out to be quite fragile, as in
some cases things work while in some other cases they don't and we
don't seem to have a good way to determine whether or not they are
going to work in advance.

For this reason, avoid enabling runtime PM for PCIe ports by
keeping their runtime PM reference counters always above 0 for the
time being.

When a PCIe port is suspended, it can no longer report events like
hotplug, so hotplug below the port may not work, as in the bug
report below.

[bhelgaas: changelog, stable]
Reference: https://bugzilla.kernel.org/show_bug.cgi?id=53811
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: stable@vger.kernel.org	# v3.6+
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/pci/pcie/portdrv_pci.c |   13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index e76b447..8bae295 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -174,14 +174,6 @@ static const struct dev_pm_ops pcie_portdrv_pm_ops = {
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
@@ -214,16 +206,11 @@ static int __devinit pcie_portdrv_probe(struct pci_dev *dev,
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
-- 
1.7.10.4



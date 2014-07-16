Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbaGPKEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:04:41 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:43786 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756613AbaGPKEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:04:37 -0400
From: Vidya Sagar <sagar.tv@gmail.com>
X-Google-Original-From: Vidya Sagar <vidyas@nvidia.com>
To: bhelgaas@google.com, matthew.garrett@nebula.com, rjw@rjwysocki.net,
        nchumbalkar@lenovo.com, thierry.reding@gmail.com, swarren@nvidia.com,
        linux-pci@vger.kernel.org
Cc: kthota@nvidia.com, linux-kernel@vger.kernel.org, vidyas@nvidia.com,
        Vidya Sagar <sagar.tv@gmail.com>
Subject: [PATCH v3] PCI: enable ASPM configuration in PCIE POWERSAVE mode
Date: Wed, 16 Jul 2014 15:33:42 +0530
Message-Id: <1405505022-7593-1-git-send-email-vidyas@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vidya Sagar <sagar.tv@gmail.com>

Commit 1a680b7c3258 ("PCI: PCIe links may not get configured for ASPM
 under POWERSAVE mode") moved pcie_aspm_powersave_config_link() out of
pci_raw_set_power_state() to pci_set_power_state() which would enable
ASPM. But, with Commit db288c9c5f9d ("PCI / PM: restore the original
 behavior of pci_set_power_state()"), which re-introduced the following check
./drivers/pci/pci.c: pci_set_power_state()

+	/* Check if we're already there */
+	if (dev->current_state == state)
+	   return 0;

in pci_set_power_state(), call to pcie_aspm_powersave_config_link() is never
made leaving ASPM broken.
Fix it by configuring links for ASPM in do_pci_enable_device() instead of
pci_set_power_state()

Suggested-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Vidya Sagar <sagar.tv@gmail.com>
---
v3:
* Modified commit message
    removed single quotes around commit messages
    added Suggested-by line

v2:
* Calling ASPM config code is moved from pci_set_power_state() to
* do_pci_enable_device()

 drivers/pci/pci.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 1c8592b..81d49d3 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -839,12 +839,6 @@ int pci_set_power_state(struct pci_dev *dev, pci_power_t state)
 
 	if (!__pci_complete_power_transition(dev, state))
 		error = 0;
-	/*
-	 * When aspm_policy is "powersave" this call ensures
-	 * that ASPM is configured.
-	 */
-	if (!error && dev->bus->self)
-		pcie_aspm_powersave_config_link(dev->bus->self);
 
 	return error;
 }
@@ -1195,12 +1189,18 @@ int __weak pcibios_enable_device(struct pci_dev *dev, int bars)
 static int do_pci_enable_device(struct pci_dev *dev, int bars)
 {
 	int err;
+	struct pci_dev *bridge;
 	u16 cmd;
 	u8 pin;
 
 	err = pci_set_power_state(dev, PCI_D0);
 	if (err < 0 && err != -EIO)
 		return err;
+
+	bridge = pci_upstream_bridge(dev);
+	if (bridge)
+		pcie_aspm_powersave_config_link(bridge);
+
 	err = pcibios_enable_device(dev, bars);
 	if (err < 0)
 		return err;
-- 
1.8.1.5


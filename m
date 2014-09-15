Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344AbaIOWvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:51:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51023 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758011AbaIOWRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:17:19 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vidya Sagar <sagar.tv@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 079/187] PCI: Configure ASPM when enabling device
Date: Mon, 15 Sep 2014 15:08:09 -0700
Message-Id: <1410818997-9432-80-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vidya Sagar <sagar.tv@gmail.com>

commit 1f6ae47ecff7f23da73417e068018b311f3b5583 upstream.

We can't do ASPM configuration at enumeration-time because enabling it
makes some defective hardware unresponsive, even if ASPM is disabled later
(see 41cd766b0659 ("PCI: Don't enable aspm before drivers have had a chance
to veto it").  Therefore, we have to do it after a driver claims the
device.

We previously configured ASPM in pci_set_power_state(), but that's not a
very good place because it's not really related to setting the PCI device
power state, and doing it there means:

  - We incorrectly skipped ASPM config when setting a device that's
    already in D0 to D0.

  - We unnecessarily configured ASPM when setting a device to a low-power
    state (the ASPM feature only applies when the device is in D0).

  - We unnecessarily configured ASPM when called from a .resume() method
    (ASPM configuration needs to be restored during resume, but
    pci_restore_pcie_state() should already do this).

Move ASPM configuration from pci_set_power_state() to
do_pci_enable_device() so we do it when a driver enables a device.

[bhelgaas: changelog]
Link: https://bugzilla.kernel.org/show_bug.cgi?id=79621
Fixes: db288c9c5f9d ("PCI / PM: restore the original behavior of pci_set_power_state()")
Suggested-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Vidya Sagar <sagar.tv@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/pci/pci.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 1a8a4fd..49ca284 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -782,12 +782,6 @@ int pci_set_power_state(struct pci_dev *dev, pci_power_t state)
 
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
@@ -1120,12 +1114,18 @@ EXPORT_SYMBOL_GPL(pci_load_and_free_saved_state);
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
1.9.1


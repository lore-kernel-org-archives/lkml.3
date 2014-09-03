Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304AbaICJ5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:57:48 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57429 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932285AbaICJ5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:57:46 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vidya Sagar <sagar.tv@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 51/56] PCI: Configure ASPM when enabling device
Date: Wed,  3 Sep 2014 11:27:10 +0200
Message-Id: <314db2642ade1eb728b661abfcc1c14fc51fa814.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vidya Sagar <sagar.tv@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/pci/pci.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 4108166ffdf4..2d163544fa51 100644
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
2.1.0


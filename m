Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbaKLWrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 17:47:36 -0500
Received: from ns.gsystem.sk ([62.176.172.50]:36638 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195AbaKLWrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 17:47:35 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: e1000-devel@lists.sourceforge.net
Cc: netdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH] e100: Don't enable WoL by default on Toshiba devices
Date: Wed, 12 Nov 2014 23:47:25 +0100
Message-Id: <1415832445-9524-1-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabling WoL on some Toshiba laptops (such as Portege R100) causes battery
drain after shutdown (WoL is active even on battery). These laptops have the
WoL bit set in EEPROM ID, causing e100 driver to enable WoL by default.

Check subsystem vendor ID and if it's Toshiba, don't enable WoL by default
from EEPROM settings.

Fixes https://bugs.launchpad.net/ubuntu/+source/linux/+bug/110784

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/net/ethernet/intel/e100.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 781065e..daf8fcc 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -2949,9 +2949,12 @@ static int e100_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		}
 	}
 
-	/* Wol magic packet can be enabled from eeprom */
-	if ((nic->mac >= mac_82558_D101_A4) &&
-	   (nic->eeprom[eeprom_id] & eeprom_id_wol)) {
+	/* Wol magic packet can be enabled from eeprom
+	 * Don't enable WoL by default on Toshiba laptops as it causes battery
+	 * drain after shutdown */
+	if ((pdev->subsystem_vendor != PCI_VENDOR_ID_TOSHIBA) &&
+	    (nic->mac >= mac_82558_D101_A4) &&
+	    (nic->eeprom[eeprom_id] & eeprom_id_wol)) {
 		nic->flags |= wol_magic;
 		device_set_wakeup_enable(&pdev->dev, true);
 	}
-- 
Ondrej Zary


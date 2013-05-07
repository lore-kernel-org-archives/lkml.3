Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428Ab3EGNmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:42:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42496 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933286Ab3EGNmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:42:03 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 088/118] PCI/PM: Fix fallback to PCI_D0 in pci_platform_power_transition()
Date: Tue,  7 May 2013 14:38:54 +0100
Message-Id: <1367933964-1564-89-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit 769ba7212f2059ca9fe0c73371e3d415c8c1c529 upstream.

Commit b51306c (PCI: Set device power state to PCI_D0 for device
without native PM support) modified pci_platform_power_transition()
by adding code causing dev->current_state for devices that don't
support native PCI PM but are power-manageable by the platform to be
changed to PCI_D0 regardless of the value returned by the preceding
platform_pci_set_power_state().  In particular, that also is done
if the platform_pci_set_power_state() has been successful, which
causes the correct power state of the device set by
pci_update_current_state() in that case to be overwritten by PCI_D0.

Fix that mistake by making the fallback to PCI_D0 only happen if
the platform_pci_set_power_state() has returned an error.

[bhelgaas: folded in Yinghai's simplification, added URL & stable info]
Reference: http://lkml.kernel.org/r/27806FC4E5928A408B78E88BBC67A2306F466BBA@ORSMSX101.amr.corp.intel.com
Reported-by: Chris J. Benenati <chris.j.benenati@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/pci/pci.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 447e834..fa7c0f0 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -674,15 +674,11 @@ static int pci_platform_power_transition(struct pci_dev *dev, pci_power_t state)
 		error = platform_pci_set_power_state(dev, state);
 		if (!error)
 			pci_update_current_state(dev, state);
-		/* Fall back to PCI_D0 if native PM is not supported */
-		if (!dev->pm_cap)
-			dev->current_state = PCI_D0;
-	} else {
+	} else
 		error = -ENODEV;
-		/* Fall back to PCI_D0 if native PM is not supported */
-		if (!dev->pm_cap)
-			dev->current_state = PCI_D0;
-	}
+
+	if (error && !dev->pm_cap) /* Fall back to PCI_D0 */
+		dev->current_state = PCI_D0;
 
 	return error;
 }
-- 
1.8.1.2


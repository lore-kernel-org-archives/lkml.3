Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177AbaCEOZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:25:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40881 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114AbaCEOZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:25:17 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 038/131] powerpc/powernv: Rework EEH reset
Date: Wed,  5 Mar 2014 14:22:42 +0000
Message-Id: <1394029455-23128-39-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gavin Shan <shangw@linux.vnet.ibm.com>

commit 5b2e198e50f6ba57081586b853163ea1bb95f1a8 upstream.

When doing reset in order to recover the affected PE, we issue
hot reset on PE primary bus if it's not root bus. Otherwise, we
issue hot or fundamental reset on root port or PHB accordingly.
For the later case, we didn't cover the situation where PE only
includes root port and it potentially causes kernel crash upon
EEH error to the PE.

The patch reworks the logic of EEH reset to improve the code
readability and also avoid the kernel crash.

Reported-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/platforms/powernv/eeh-ioda.c | 29 ++++-------------------------
 1 file changed, 4 insertions(+), 25 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/eeh-ioda.c b/arch/powerpc/platforms/powernv/eeh-ioda.c
index 0cd1c4a..d972157 100644
--- a/arch/powerpc/platforms/powernv/eeh-ioda.c
+++ b/arch/powerpc/platforms/powernv/eeh-ioda.c
@@ -470,8 +470,7 @@ static int ioda_eeh_bridge_reset(struct pci_controller *hose,
 static int ioda_eeh_reset(struct eeh_pe *pe, int option)
 {
 	struct pci_controller *hose = pe->phb;
-	struct eeh_dev *edev;
-	struct pci_dev *dev;
+	struct pci_bus *bus;
 	int ret;
 
 	/*
@@ -500,31 +499,11 @@ static int ioda_eeh_reset(struct eeh_pe *pe, int option)
 	if (pe->type & EEH_PE_PHB) {
 		ret = ioda_eeh_phb_reset(hose, option);
 	} else {
-		if (pe->type & EEH_PE_DEVICE) {
-			/*
-			 * If it's device PE, we didn't refer to the parent
-			 * PCI bus yet. So we have to figure it out indirectly.
-			 */
-			edev = list_first_entry(&pe->edevs,
-					struct eeh_dev, list);
-			dev = eeh_dev_to_pci_dev(edev);
-			dev = dev->bus->self;
-		} else {
-			/*
-			 * If it's bus PE, the parent PCI bus is already there
-			 * and just pick it up.
-			 */
-			dev = pe->bus->self;
-		}
-
-		/*
-		 * Do reset based on the fact that the direct upstream bridge
-		 * is root bridge (port) or not.
-		 */
-		if (dev->bus->number == 0)
+		bus = eeh_pe_bus_get(pe);
+		if (pci_is_root_bus(bus))
 			ret = ioda_eeh_root_reset(hose, option);
 		else
-			ret = ioda_eeh_bridge_reset(hose, dev, option);
+			ret = ioda_eeh_bridge_reset(hose, bus->self, option);
 	}
 
 	return ret;
-- 
1.9.0


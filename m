Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932824AbaCDVfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:35:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40821 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715AbaCDUC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:02:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.13 025/172] powerpc/powernv: Rework EEH reset
Date: Tue,  4 Mar 2014 12:01:49 -0800
Message-Id: <20140304200300.533147254@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/powernv/eeh-ioda.c |   29 ++++-------------------------
 1 file changed, 4 insertions(+), 25 deletions(-)

--- a/arch/powerpc/platforms/powernv/eeh-ioda.c
+++ b/arch/powerpc/platforms/powernv/eeh-ioda.c
@@ -490,8 +490,7 @@ static int ioda_eeh_bridge_reset(struct
 static int ioda_eeh_reset(struct eeh_pe *pe, int option)
 {
 	struct pci_controller *hose = pe->phb;
-	struct eeh_dev *edev;
-	struct pci_dev *dev;
+	struct pci_bus *bus;
 	int ret;
 
 	/*
@@ -520,31 +519,11 @@ static int ioda_eeh_reset(struct eeh_pe
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



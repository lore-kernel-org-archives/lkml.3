Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682Ab3DQGxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 02:53:33 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:42668 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644Ab3DQGxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 02:53:32 -0400
From: Mike Qiu <qiudayu@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, benh@kernel.crashing.org,
        Mike Qiu <qiudayu@linux.vnet.ibm.com>
Subject: [PATCH] PowerNV/PCI: Fix NULL PCI controller
Date: Wed, 17 Apr 2013 14:53:14 +0800
Message-Id: <1366181594-3391-1-git-send-email-qiudayu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041706-8878-0000-0000-000006BB8EE0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In pnv_pci_read_config() or pnv_pci_write_config(), we never check if
the PCI controller is valid before converting that into platform
dependent one, this is very dangerous. 

To avoid this potential risks, the patch check PCI controller first
before use it.

Signed-off-by: Mike Qiu <qiudayu@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/powernv/pci.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
index b8b8e0b..e7b7f1a 100644
--- a/arch/powerpc/platforms/powernv/pci.c
+++ b/arch/powerpc/platforms/powernv/pci.c
@@ -286,11 +286,11 @@ static int pnv_pci_read_config(struct pci_bus *bus,
 			       int where, int size, u32 *val)
 {
 	struct pci_controller *hose = pci_bus_to_host(bus);
-	struct pnv_phb *phb = hose->private_data;
+	struct pnv_phb *phb = hose ? hose->private_data : NULL;
 	u32 bdfn = (((uint64_t)bus->number) << 8) | devfn;
 	s64 rc;
 
-	if (hose == NULL)
+	if (!phb)
 		return PCIBIOS_DEVICE_NOT_FOUND;
 
 	switch (size) {
@@ -330,10 +330,10 @@ static int pnv_pci_write_config(struct pci_bus *bus,
 				int where, int size, u32 val)
 {
 	struct pci_controller *hose = pci_bus_to_host(bus);
-	struct pnv_phb *phb = hose->private_data;
+	struct pnv_phb *phb = hose ? hose->private_data : NULL;
 	u32 bdfn = (((uint64_t)bus->number) << 8) | devfn;
 
-	if (hose == NULL)
+	if (!phb)
 		return PCIBIOS_DEVICE_NOT_FOUND;
 
 	cfg_dbg("pnv_pci_write_config bus: %x devfn: %x +%x/%x -> %08x\n",
-- 
1.7.10.1


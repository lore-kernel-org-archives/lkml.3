Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbaAGA4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:56:31 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:59799 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757838AbaAGA40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 19:56:26 -0500
Subject: [PATCH v7 10/15] agp/intel: Use pci_bus_address() to get GTTADR bus
 address
To: linux-pci@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: David Airlie <airlied@linux.ie>, Yinghai Lu <yinghai@kernel.org>,
        Guo Chao <yan@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Date: Mon, 06 Jan 2014 17:56:24 -0700
Message-ID: <20140107005624.10786.67196.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140107005003.10786.85164.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140107005003.10786.85164.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per the Intel 915G/915GV/... Chipset spec (document number 301467-005),
GTTADR is a standard PCI BAR.

The PCI core reads GTTADR at enumeration-time.  Use pci_bus_address()
instead of reading it again in the driver.  This works correctly for both
32-bit and 64-bit BARs.  The spec above only mentions 32-bit GTTADR, but we
should still use the standard interface.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/char/agp/intel-agp.h |    2 +-
 drivers/char/agp/intel-gtt.c |    7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/char/agp/intel-agp.h b/drivers/char/agp/intel-agp.h
index 18bbaafb8509..fda073dcd967 100644
--- a/drivers/char/agp/intel-agp.h
+++ b/drivers/char/agp/intel-agp.h
@@ -115,7 +115,7 @@
 /* intel 915G registers */
 #define I915_GMADR_BAR	2
 #define I915_MMADR_BAR	0
-#define I915_PTEADDR	0x1C
+#define I915_PTE_BAR	3
 #define I915_GMCH_GMS_STOLEN_48M	(0x6 << 4)
 #define I915_GMCH_GMS_STOLEN_64M	(0x7 << 4)
 #define G33_GMCH_GMS_STOLEN_128M	(0x8 << 4)
diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index 58916f32c0f3..dd8b66a617dc 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -1102,7 +1102,7 @@ static void i965_write_entry(dma_addr_t addr,
 
 static int i9xx_setup(void)
 {
-	u32 reg_addr, gtt_addr;
+	u32 reg_addr;
 	int size = KB(512);
 
 	reg_addr = pci_bus_address(intel_private.pcidev, I915_MMADR_BAR);
@@ -1113,9 +1113,8 @@ static int i9xx_setup(void)
 
 	switch (INTEL_GTT_GEN) {
 	case 3:
-		pci_read_config_dword(intel_private.pcidev,
-				      I915_PTEADDR, &gtt_addr);
-		intel_private.gtt_phys_addr = gtt_addr;
+		intel_private.gtt_phys_addr =
+			pci_bus_address(intel_private.pcidev, I915_PTE_BAR);
 		break;
 	case 5:
 		intel_private.gtt_phys_addr = reg_addr + MB(2);


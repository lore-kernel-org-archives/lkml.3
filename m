Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861AbaAGA4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:56:25 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:63781 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757838AbaAGA4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 19:56:19 -0500
Subject: [PATCH v7 09/15] agp/intel: Use pci_bus_address() to get MMADR bus
 address
To: linux-pci@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: David Airlie <airlied@linux.ie>, Yinghai Lu <yinghai@kernel.org>,
        Guo Chao <yan@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Date: Mon, 06 Jan 2014 17:56:17 -0700
Message-ID: <20140107005617.10786.81226.stgit@bhelgaas-glaptop.roam.corp.google.com>
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
MMADR is a standard PCI BAR.

The PCI core reads MMADR at enumeration-time.  Use pci_bus_address()
instead of reading it again in the driver.  This works correctly for both
32-bit and 64-bit BARs.  The spec above only mentions 32-bit MMADR, but we
should still use the standard interface.

Also, stop clearing the low 19 bits of the bus address because it's invalid
to use addresses outside the region defined by the BAR.  The spec claims
MMADR is 512KB; if that's the case, those bits will be zero anyway.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/char/agp/intel-agp.h |    4 ++--
 drivers/char/agp/intel-gtt.c |   10 +++-------
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/char/agp/intel-agp.h b/drivers/char/agp/intel-agp.h
index 0bf5590fd0f9..18bbaafb8509 100644
--- a/drivers/char/agp/intel-agp.h
+++ b/drivers/char/agp/intel-agp.h
@@ -56,7 +56,7 @@
 
 /* Intel i810 registers */
 #define I810_GMADR_BAR		0
-#define I810_MMADDR		0x14
+#define I810_MMADR_BAR		1
 #define I810_PTE_BASE		0x10000
 #define I810_PTE_MAIN_UNCACHED	0x00000000
 #define I810_PTE_LOCAL		0x00000002
@@ -114,7 +114,7 @@
 
 /* intel 915G registers */
 #define I915_GMADR_BAR	2
-#define I915_MMADDR	0x10
+#define I915_MMADR_BAR	0
 #define I915_PTEADDR	0x1C
 #define I915_GMCH_GMS_STOLEN_48M	(0x6 << 4)
 #define I915_GMCH_GMS_STOLEN_64M	(0x7 << 4)
diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index 560f66bffebb..58916f32c0f3 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -181,8 +181,7 @@ static int i810_setup(void)
 		return -ENOMEM;
 	intel_private.i81x_gtt_table = gtt_table;
 
-	pci_read_config_dword(intel_private.pcidev, I810_MMADDR, &reg_addr);
-	reg_addr &= 0xfff80000;
+	reg_addr = pci_bus_address(intel_private.pcidev, I810_MMADR_BAR);
 
 	intel_private.registers = ioremap(reg_addr, KB(64));
 	if (!intel_private.registers)
@@ -785,8 +784,7 @@ static int i830_setup(void)
 {
 	u32 reg_addr;
 
-	pci_read_config_dword(intel_private.pcidev, I810_MMADDR, &reg_addr);
-	reg_addr &= 0xfff80000;
+	reg_addr = pci_bus_address(intel_private.pcidev, I810_MMADR_BAR);
 
 	intel_private.registers = ioremap(reg_addr, KB(64));
 	if (!intel_private.registers)
@@ -1107,9 +1105,7 @@ static int i9xx_setup(void)
 	u32 reg_addr, gtt_addr;
 	int size = KB(512);
 
-	pci_read_config_dword(intel_private.pcidev, I915_MMADDR, &reg_addr);
-
-	reg_addr &= 0xfff80000;
+	reg_addr = pci_bus_address(intel_private.pcidev, I915_MMADR_BAR);
 
 	intel_private.registers = ioremap(reg_addr, size);
 	if (!intel_private.registers)


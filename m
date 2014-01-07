Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836AbaAGA4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:56:18 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:38077 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757816AbaAGA4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 19:56:12 -0500
Subject: [PATCH v7 08/15] agp/intel: Support 64-bit GMADR
To: linux-pci@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: David Airlie <airlied@linux.ie>, Yinghai Lu <yinghai@kernel.org>,
        Guo Chao <yan@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Date: Mon, 06 Jan 2014 17:56:09 -0700
Message-ID: <20140107005609.10786.29922.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140107005003.10786.85164.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140107005003.10786.85164.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

Per the Intel 915G/915GV/... Chipset spec (document number 301467-005),
GMADR is a standard PCI BAR.

The PCI core reads GMADR at enumeration-time.  Use pci_bus_address()
instead of reading it again in the driver.  This works correctly for both
32-bit and 64-bit BARs.  The spec above only mentions 32-bit GMADR, but
Yinghai's patch (link below) indicates some devices have a 64-bit GMADR.

[bhelgaas: reworked starting from http://lkml.kernel.org/r/1385851238-21085-13-git-send-email-yinghai@kernel.org]
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/char/agp/intel-agp.h |    4 ++--
 drivers/char/agp/intel-gtt.c |   12 ++++--------
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/char/agp/intel-agp.h b/drivers/char/agp/intel-agp.h
index 1042c1b90376..0bf5590fd0f9 100644
--- a/drivers/char/agp/intel-agp.h
+++ b/drivers/char/agp/intel-agp.h
@@ -55,7 +55,7 @@
 #define INTEL_I860_ERRSTS	0xc8
 
 /* Intel i810 registers */
-#define I810_GMADDR		0x10
+#define I810_GMADR_BAR		0
 #define I810_MMADDR		0x14
 #define I810_PTE_BASE		0x10000
 #define I810_PTE_MAIN_UNCACHED	0x00000000
@@ -113,7 +113,7 @@
 #define INTEL_I850_ERRSTS	0xc8
 
 /* intel 915G registers */
-#define I915_GMADDR	0x18
+#define I915_GMADR_BAR	2
 #define I915_MMADDR	0x10
 #define I915_PTEADDR	0x1C
 #define I915_GMCH_GMS_STOLEN_48M	(0x6 << 4)
diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index 54202ffcf467..560f66bffebb 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -608,9 +608,8 @@ static bool intel_gtt_can_wc(void)
 
 static int intel_gtt_init(void)
 {
-	u32 gma_addr;
 	u32 gtt_map_size;
-	int ret;
+	int ret, bar;
 
 	ret = intel_private.driver->setup();
 	if (ret != 0)
@@ -660,14 +659,11 @@ static int intel_gtt_init(void)
 	}
 
 	if (INTEL_GTT_GEN <= 2)
-		pci_read_config_dword(intel_private.pcidev, I810_GMADDR,
-				      &gma_addr);
+		bar = I810_GMADR_BAR;
 	else
-		pci_read_config_dword(intel_private.pcidev, I915_GMADDR,
-				      &gma_addr);
-
-	intel_private.gma_bus_addr = (gma_addr & PCI_BASE_ADDRESS_MEM_MASK);
+		bar = I915_GMADR_BAR;
 
+	intel_private.gma_bus_addr = pci_bus_address(intel_private.pcidev, bar);
 	return 0;
 }
 


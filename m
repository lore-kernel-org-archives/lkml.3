Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab3JDViG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 17:38:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:18822 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab3JDViE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 17:38:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1035,1371106800"; 
   d="scan'208";a="414188442"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Andi Kleen <ak@linux.intel.com>, bp@suse.de
Subject: [PATCH] x86: Don't make AMD_GART depend on EXPERT and default y
Date: Fri,  4 Oct 2013 14:37:56 -0700
Message-Id: <1380922676-23007-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The AMD_GART driver was made EXPERT/EMBEDDED a long time
ago to avoid unbootable 64bit systems with 32bit only devices.

This was before swiotlb was there, which does the job
of this fallback today. SWIOTLB is always on, so systems
should always boot.

The drawback is that every system has to compile that
driver in (it cannot be a module).

Also:
- Newer AMD CPUs (the APUs) don't seem to have AMD_GART support
at all anymore.
- Newer AMD platforms have a much better real IOMMU
- The AMD GART driver was never very good (lots of overhead, e.g.
in flushing due to some workarounds) and it's doubtful it's really
better than SWIOTLB.
- On older K8 systems it didn't even work with all chipsets.
- The 32bit device bounce buffer case should be rare/
non performance critical these days anyways.
- On non AMD systems it is not needed at all.

So drop the EXPERT dependency on AMD_GART and remove the
default y. The driver can be still compiled in, just
it's an explicit decision now, and people who don't want
it can unselect it.

I also clarified the description a bit.

This allows to save ~8K text on most modern x86-64 systems.

Cc: bp@suse.de
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/Kconfig | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ee2fb9d..c9d2b81 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -756,17 +756,16 @@ config DMI
 	  BIOS code.
 
 config GART_IOMMU
-	bool "GART IOMMU support" if EXPERT
-	default y
+	bool "Old AMD GART IOMMU support"
 	select SWIOTLB
 	depends on X86_64 && PCI && AMD_NB
 	---help---
 	  Support for full DMA access of devices with 32bit memory access only
 	  on systems with more than 3GB. This is usually needed for USB,
 	  sound, many IDE/SATA chipsets and some other devices.
-	  Provides a driver for the AMD Athlon64/Opteron/Turion/Sempron GART
-	  based hardware IOMMU and a software bounce buffer based IOMMU used
-	  on Intel systems and as fallback.
+	  Provides a driver for the older AMD Athlon64/Opteron/Turion/Sempron GART
+	  based hardware IOMMU.
+	  Newer systems typically have a better AMD IOMMU.
 	  The code is only active when needed (enough memory and limited
 	  device) unless CONFIG_IOMMU_DEBUG or iommu=force is specified
 	  too.
-- 
1.8.3.1


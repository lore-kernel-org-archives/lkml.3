Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab3FYTmN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:42:13 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:44063 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab3FYTmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 15:42:11 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sam Creasey <sammy@sammy.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/2] m68k/sun3: Dynamically allocate the table to track IOMMU use
Date: Tue, 25 Jun 2013 21:42:06 +0200
Message-Id: <1372189326-12230-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372189326-12230-1-git-send-email-geert@linux-m68k.org>
References: <1372189326-12230-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Sun 3 kernels cannot be multi-platform due to the different Sun 3 MMU
type, it made sense to statically allocate the table to track IOMMU use.

However, Sun 3x kernels can be multi-platform. Furthermore, Sun 3x uses
a larger table than Sun 3 (8192 bytes instead of 512 bytes).

Hence switch to dynamic allocation of this table to avoid wasting 8192
bytes when not running on a Sun 3x.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Untested due to lack of hardware

 arch/m68k/sun3/sun3dvma.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/m68k/sun3/sun3dvma.c b/arch/m68k/sun3/sun3dvma.c
index ca57966..e0a3d36 100644
--- a/arch/m68k/sun3/sun3dvma.c
+++ b/arch/m68k/sun3/sun3dvma.c
@@ -6,6 +6,7 @@
  * Contains common routines for sun3/sun3x DVMA management.
  */
 
+#include <linux/bootmem.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -31,7 +32,7 @@ static inline void dvma_unmap_iommu(unsigned long a, int b)
 extern void sun3_dvma_init(void);
 #endif
 
-static unsigned long iommu_use[IOMMU_TOTAL_ENTRIES];
+static unsigned long *iommu_use;
 
 #define dvma_index(baddr) ((baddr - DVMA_START) >> DVMA_PAGE_SHIFT)
 
@@ -266,6 +267,7 @@ void __init dvma_init(void)
 
 	list_add(&(hole->list), &hole_list);
 
+	iommu_use = alloc_bootmem(IOMMU_TOTAL_ENTRIES * sizeof(unsigned long));
 	memset(iommu_use, 0, sizeof(iommu_use));
 
 	dvma_unmap_iommu(DVMA_START, DVMA_SIZE);
-- 
1.7.9.5


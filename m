Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669Ab3DYR3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:29:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63707 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290Ab3DYR3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:29:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 13/21] iommu: tegra: print dma_addr_t using %lld
Date: Thu, 25 Apr 2013 19:28:56 +0200
Message-Id: <1366910944-3033663-14-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:V8qJVYpzOmjVFYNDUjj8i5uNE8H+bDOcOg/cuKH8KXK
 Li8oCX3psn8tb72cZSUDao8e+G7eluKAfDd9R4iNU8d2ntCPWV
 keyxt0C3eeNk2S7WrZ2nOV5cfzHwWAGKKhR2g4sIrhW3MPGDLM
 jCGL+2kR3Pi5jm+oaZF4/qr6+In54pw1hueew0xsVEoP47rjJD
 fu8RoAS2e418wluheANfu0v688todIakXxgRVuRMNupF41K0CB
 CcQIJ0dWAn/5sZhxyboghAyIG2Wn4lH6pr99g4t2zqQmnS+wa9
 9nXFqKGPCq3NiNcBZnDJEz/Q2wPnbkeB4ElNEvosC2NTPHdzmt
 xfOiCHlpilDqa75Lih2gXHQMd8LWuPSFvUkJE1Vd3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code was recently changed to work for builds with a 64 bit
dma_addr_t, but the printk unconditionally uses a format
string for an "long" variable, which is always wrong as
the dma_add_t is now either 'unsigned int' or 'unsigned long long'
depending on configuration.

The easiest solution is to cast the variable to u64 and print
it as a 64 bit value.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Varun Sethi <Varun.Sethi@freescale.com>
Cc: Joerg Roedel <joro@8bytes.org>
---
 drivers/iommu/tegra-gart.c | 3 ++-
 drivers/iommu/tegra-smmu.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/tegra-gart.c b/drivers/iommu/tegra-gart.c
index 4aec8be..ebbdd82 100644
--- a/drivers/iommu/tegra-gart.c
+++ b/drivers/iommu/tegra-gart.c
@@ -295,7 +295,8 @@ static phys_addr_t gart_iommu_iova_to_phys(struct iommu_domain *domain,
 
 	pa = (pte & GART_PAGE_MASK);
 	if (!pfn_valid(__phys_to_pfn(pa))) {
-		dev_err(gart->dev, "No entry for %08lx:%08x\n", iova, pa);
+		dev_err(gart->dev, "No entry for %08llx:%pa\n",
+				(u64)iova, &pa);
 		gart_dump_table(gart);
 		return -EINVAL;
 	}
diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index bc9b599..ef2a120 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -772,7 +772,7 @@ static phys_addr_t smmu_iommu_iova_to_phys(struct iommu_domain *domain,
 	pfn = *pte & SMMU_PFN_MASK;
 	WARN_ON(!pfn_valid(pfn));
 	dev_dbg(as->smmu->dev,
-		"iova:%08lx pfn:%08lx asid:%d\n", iova, pfn, as->asid);
+		"iova:%08llx pfn:%08lx asid:%d\n", (u64)iova, pfn, as->asid);
 
 	spin_unlock_irqrestore(&as->lock, flags);
 	return PFN_PHYS(pfn);
-- 
1.8.1.2


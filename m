Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbaHEKwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:52:47 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:52894 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970AbaHEKtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:49:05 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-cf-53e0b69fc7a6
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: iommu@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Cho KyongHo <pullip.cho@samsung.com>, Joerg Roedel <joro@8bytes.org>,
        Thierry Reding <treding@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Inki Dae <inki.dae@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 17/29] iommu: exynos: don't read version register on every tlb
 operation
Date: Tue, 05 Aug 2014 12:47:45 +0200
Message-id: <1407235677-26324-18-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t/xq7rztz0INljSY2Txd9IxdovmxevZ
	LCbdn8BisWC/tUXn7A3sFr0LrrJZnG16w27ROXEJu8WXKw+ZLDY9vsZqcXnXHDaLGef3MVms
	PXKX3eLU9c9sFv96DzJanDl9idXi/54d7BaH37SzWhx5uJvdYtWuP4wWt3/zOYh6PDk4j8nj
	969JjB47Z91l95jdMZPVY9OqTjaP/XPXsHtsXlLvcfvfY2aPyTeWM3pcOdHE6tHb/I7NY8vV
	dhaPvi2rGD0+b5IL4IvisklJzcksSy3St0vgyth7ZyJTwVuhip9rvrE2MB7k72Lk5JAQMJFY
	1LWECcIWk7hwbz1bFyMXh5DAUkaJcw+Ws0A4fUwSn9cdAqtiEzCU6HrbBVYlItDLKNHf9IMJ
	xGEWWMcqsb/3OgtIlbBAlMTtfw1gHSwCqhIPZ+8Bs3kFPCV+nv7CDLFPTuL/yxVgcU6g+OGb
	B1hBbCEBD4mfG9awT2DkXcDIsIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJHa+7GBcfMzq
	EKMAB6MSD6/B6bvBQqyJZcWVuYcYJTiYlUR4JdY8CBbiTUmsrEotyo8vKs1JLT7EyMTBKdXA
	6LzgrnBT3XMh9YCuuPL+1gvcO9pPWltrm6hk/nm/OrCGcdpr6SXdU37KKykvFlaZ/02Gb4Ll
	q/2LC5Y8vpkeqHXS5s/xh0o2l2rauSLcn//6sjbQ9Ci3sZ+QjuzC1e9ygpcvEf3d3O9rHlzQ
	firu3aKs6bVTqmvnB1/Suj611FBqi4OWgiq3EktxRqKhFnNRcSIA+jJAZXsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes reading of REG_MMU_VERSION register on every tlb
operation and caches SYSMMU version in driver's internal data.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/iommu/exynos-iommu.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 64b3bc8..8927923 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -213,6 +213,7 @@ struct sysmmu_drvdata {
 	spinlock_t lock;
 	struct iommu_domain *domain;
 	phys_addr_t pgtable;
+	int version;
 };
 
 static bool set_sysmmu_active(struct sysmmu_drvdata *data)
@@ -239,11 +240,6 @@ static void sysmmu_unblock(void __iomem *sfrbase)
 	__raw_writel(CTRL_ENABLE, sfrbase + REG_MMU_CTRL);
 }
 
-static unsigned int __raw_sysmmu_version(struct sysmmu_drvdata *data)
-{
-	return MMU_RAW_VER(__raw_readl(data->sfrbase + REG_MMU_VERSION));
-}
-
 static bool sysmmu_block(void __iomem *sfrbase)
 {
 	int i = 120;
@@ -403,7 +399,7 @@ static void __sysmmu_init_config(struct sysmmu_drvdata *data)
 	unsigned int cfg = CFG_LRU | CFG_QOS(15);
 	unsigned int ver;
 
-	ver = __raw_sysmmu_version(data);
+	ver = MMU_RAW_VER(__raw_readl(data->sfrbase + REG_MMU_VERSION));
 	if (MMU_MAJ_VER(ver) == 3) {
 		if (MMU_MIN_VER(ver) >= 2) {
 			cfg |= CFG_FLPDCACHE;
@@ -417,6 +413,7 @@ static void __sysmmu_init_config(struct sysmmu_drvdata *data)
 	}
 
 	__raw_writel(cfg, data->sfrbase + REG_MMU_CFG);
+	data->version = ver;
 }
 
 static void __sysmmu_enable_nocount(struct sysmmu_drvdata *data)
@@ -526,7 +523,7 @@ static bool exynos_sysmmu_disable(struct device *dev)
 static void __sysmmu_tlb_invalidate_flpdcache(struct sysmmu_drvdata *data,
 					      sysmmu_iova_t iova)
 {
-	if (__raw_sysmmu_version(data) == MAKE_MMU_VER(3, 3))
+	if (data->version == MAKE_MMU_VER(3, 3))
 		__raw_writel(iova | 0x1, data->sfrbase + REG_MMU_FLUSH_ENTRY);
 }
 
@@ -575,7 +572,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, sysmmu_iova_t iova,
 		 * 1MB page can be cached in one of all sets.
 		 * 64KB page can be one of 16 consecutive sets.
 		 */
-		if (MMU_MAJ_VER(__raw_sysmmu_version(data)) == 2)
+		if (MMU_MAJ_VER(data->version) == 2)
 			num_inv = min_t(unsigned int, size / PAGE_SIZE, 64);
 
 		if (sysmmu_block(data->sfrbase)) {
-- 
1.9.2


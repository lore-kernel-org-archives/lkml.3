Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbaHEKvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:51:50 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:18343 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037AbaHEKtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:49:09 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-df-53e0b6a4a571
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
Subject: [PATCH 22/29] iommu: exynos: add support for binding more than one
 sysmmu to master device
Date: Tue, 05 Aug 2014 12:47:50 +0200
Message-id: <1407235677-26324-23-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsVy+t/xq7pLtj0INvj3gd3i76Rj7BbNi9ez
	WUy6P4HFYsF+a4vO2RvYLXoXXGWzONv0ht2ic+ISdosvVx4yWWx6fI3V4vKuOWwWM87vY7JY
	e+Quu8Wp65/ZLP71HmS0OHP6EqvF/z072C0Ov2lntTjycDe7xapdfxgtbv/mcxD1eHJwHpPH
	71+TGD12zrrL7jG7Yyarx6ZVnWwe++euYffYvKTe4/a/x8wek28sZ/S4cqKJ1aO3+R2bx5ar
	7SwefVtWMXp83iQXwBfFZZOSmpNZllqkb5fAldG0/j1jwSfBirf9PawNjNf4uhg5OSQETCT+
	/b/CDGGLSVy4t56ti5GLQ0hgKaPE+11nWUASQgJ9TBJTPmaA2GwChhJdb7vAikQEehkl+pt+
	MIE4zALrWCX2914H6xAWSJXY1LwQzGYRUJVYur2dHcTmFfCUmHu3lxVinZzE/5crmEBsTqD4
	4ZsHWCG2eUj83LCGfQIj7wJGhlWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsYIZHzZQfj4mNW
	hxgFOBiVeHgNTt8NFmJNLCuuzD3EKMHBrCTCK7HmQbAQb0piZVVqUX58UWlOavEhRiYOTqkG
	xhlu83WcuiUjEjQql2rVmRh1f2c8cOSq1zreadceMU5xq1J7ssaMx3jVy4PpL91sd++491zp
	8CSF98yzWT2/efo+eeR8z95y1q2H/kZzDr/jO16u97bH5FGVga35808ra1493dtQk/8lxMDh
	1WFGiQnT3DfmfEqwn9FrYvavxNvZcwbXS8cV1UosxRmJhlrMRcWJACi7Orp6AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for assigning more than one SYSMMU controller to
the master device. This has been achieved simply by chaning the struct
device pointer in struct exynos_iommu_owner into the list of struct
sysmmu_drvdata of all controllers assigned to the given master device.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/iommu/exynos-iommu.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 674d1fb..46e0edc 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -187,7 +187,7 @@ static char *sysmmu_fault_name[SYSMMU_FAULTS_NUM] = {
 
 /* attached to dev.archdata.iommu of the master device */
 struct exynos_iommu_owner {
-	struct device *sysmmu;
+	struct list_head clients;
 };
 
 struct exynos_iommu_domain {
@@ -208,6 +208,7 @@ struct sysmmu_drvdata {
 	spinlock_t lock;
 	struct iommu_domain *domain;
 	struct list_head domain_node;
+	struct list_head owner_node;
 	phys_addr_t pgtable;
 	int version;
 };
@@ -695,8 +696,7 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
 	if (!has_sysmmu(dev))
 		return -ENODEV;
 
-	data = dev_get_drvdata(owner->sysmmu);
-	if (data) {
+	list_for_each_entry(data, &owner->clients, owner_node) {
 		ret = __sysmmu_enable(data, pagetable, domain);
 		if (ret >= 0) {
 			data->master = dev;
@@ -724,7 +724,7 @@ static void exynos_iommu_detach_device(struct iommu_domain *domain,
 {
 	struct exynos_iommu_domain *priv = domain->priv;
 	phys_addr_t pagetable = virt_to_phys(priv->pgtable);
-	struct sysmmu_drvdata *data;
+	struct sysmmu_drvdata *data, *next;
 	unsigned long flags;
 	int found = 0;
 
@@ -732,14 +732,13 @@ static void exynos_iommu_detach_device(struct iommu_domain *domain,
 		return;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	list_for_each_entry(data, &priv->clients, domain_node) {
+	list_for_each_entry_safe(data, next, &priv->clients, domain_node) {
 		if (data->master == dev) {
 			if (__sysmmu_disable(data)) {
 				data->master = NULL;
 				list_del_init(&data->domain_node);
 			}
 			found = true;
-			break;
 		}
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
-- 
1.9.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbaHEKtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:49:14 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44612 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015AbaHEKtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:49:07 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-d7-53e0b6a1ec77
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
Subject: [PATCH 19/29] iommu: exynos: remove useless spinlock
Date: Tue, 05 Aug 2014 12:47:47 +0200
Message-id: <1407235677-26324-20-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsVy+t/xq7oLtz0INtg7VcHi76Rj7BbNi9ez
	WUy6P4HFYsF+a4vO2RvYLXoXXGWzONv0ht2ic+ISdosvVx4yWWx6fI3V4vKuOWwWM87vY7JY
	e+Quu8Wp65/ZLP71HmS0OHP6EqvF/z072C0Ov2lntTjycDe7xapdfxgtbv/mcxD1eHJwHpPH
	71+TGD12zrrL7jG7Yyarx6ZVnWwe++euYffYvKTe4/a/x8wek28sZ/S4cqKJ1aO3+R2bx5ar
	7SwefVtWMXp83iQXwBfFZZOSmpNZllqkb5fAlbH/80PGgsO8FV+u3GRpYPzP1cXIySEhYCJx
	6ekGRghbTOLCvfVsXYxcHEICSxklFjx6CeX0MUksnniVFaSKTcBQouttF1hCRKCXUaK/6QcT
	iMMssI5VYn/vdRaQKmEBW4nfl3+DzWURUJX4uRxkBwcHr4CnxMbdghDr5CT+v1zBBGJzAoUP
	3zwAtkBIwEPi54Y17BMYeRcwMqxiFE0tTS4oTkrPNdQrTswtLs1L10vOz93ECImcLzsYFx+z
	OsQowMGoxMNrcPpusBBrYllxZe4hRgkOZiURXok1D4KFeFMSK6tSi/Lji0pzUosPMTJxcEo1
	MHoceviVreiNcSlfcGhXrcqT7zfdeNfOT9n9v8ftsPqvO3eSAh43lQh5s064XOHu6Cr3rDST
	4dX/mtLa91LM/JkPnKMOm+sKt9ibz/5uOlGqSzCsyXnF5GdH5px3ehK0fXPxsXcx53LkZ2ft
	mt94mqumjonr853Nhp36rJE2lje/x2ww1JWbrMRSnJFoqMVcVJwIAPlFa2R6AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes useless spinlocks and other unused members from
struct exynos_iommu_owner. There is no point is protecting this
structure by spinlock because content of this structure doesn't change
and other structures have their own spinlocks.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/iommu/exynos-iommu.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index ec3c882..ed8c518 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -190,9 +190,6 @@ struct exynos_iommu_owner {
 	struct list_head client; /* entry of exynos_iommu_domain.clients */
 	struct device *dev;
 	struct device *sysmmu;
-	struct iommu_domain *domain;
-	void *vmm_data;         /* IO virtual memory manager's data */
-	spinlock_t lock;        /* Lock to preserve consistency of System MMU */
 };
 
 struct exynos_iommu_domain {
@@ -478,16 +475,12 @@ static int __exynos_sysmmu_enable(struct device *dev, phys_addr_t pgtable,
 
 	BUG_ON(!has_sysmmu(dev));
 
-	spin_lock_irqsave(&owner->lock, flags);
-
 	data = dev_get_drvdata(owner->sysmmu);
 
 	ret = __sysmmu_enable(data, pgtable, domain);
 	if (ret >= 0)
 		data->master = dev;
 
-	spin_unlock_irqrestore(&owner->lock, flags);
-
 	return ret;
 }
 
@@ -500,16 +493,12 @@ static bool exynos_sysmmu_disable(struct device *dev)
 
 	BUG_ON(!has_sysmmu(dev));
 
-	spin_lock_irqsave(&owner->lock, flags);
-
 	data = dev_get_drvdata(owner->sysmmu);
 
 	disabled = __sysmmu_disable(data);
 	if (disabled)
 		data->master = NULL;
 
-	spin_unlock_irqrestore(&owner->lock, flags);
-
 	return disabled;
 }
 
-- 
1.9.2


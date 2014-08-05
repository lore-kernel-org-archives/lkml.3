Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbaHEKup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:50:45 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9371 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964AbaHEKtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:49:12 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-e8-53e0b6a6e7db
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
Subject: [PATCH 25/29] iommu: exynos: add support for runtime_pm
Date: Tue, 05 Aug 2014 12:47:53 +0200
Message-id: <1407235677-26324-26-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t/xq7rLtj0INphzVcvi76Rj7BbNi9ez
	WUy6P4HFYsF+a4vO2RvYLXoXXGWzONv0ht2ic+ISdosvVx4yWWx6fI3V4vKuOWwWM87vY7JY
	e+Quu8Wp65/ZLP71HmS0OHP6EqvF/z072C0Ov2lntTjycDe7xapdfxgtbv/mcxD1eHJwHpPH
	71+TGD12zrrL7jG7Yyarx6ZVnWwe++euYffYvKTe4/a/x8wek28sZ/S4cqKJ1aO3+R2bx5ar
	7SwefVtWMXp83iQXwBfFZZOSmpNZllqkb5fAlfHw1nLWgsNKFXsXHWZsYDwh08XIySEhYCJx
	vPk2C4QtJnHh3nq2LkYuDiGBpYwSpzbdYIJw+pgk3q7ewApSxSZgKNH1tgusSkSgl1Giv+kH
	WBWzwDpWif2918FmCQs4SDxZt5sRxGYRUJVoe/mVDcTmFfCUWHJhAivEPjmJ/y9XMIHYnEDx
	wzcPgMWFBDwkfm5Ywz6BkXcBI8MqRtHU0uSC4qT0XEO94sTc4tK8dL3k/NxNjJDY+bKDcfEx
	q0OMAhyMSjy8BqfvBguxJpYVV+YeYpTgYFYS4ZVY8yBYiDclsbIqtSg/vqg0J7X4ECMTB6dU
	A2Pj6gvX5f5kzPgmoXtm58+srkVKNm9esf7Y+PblYw7Z851Hbsaff35p/6k7RZNdjWZNjFNb
	tfnai6Wi0r7hq1hNF9RdfNu+OZ5pYeKUK5euur96eHDiR19RWYGeVbuy2Oa+PlWVUHrGz6P6
	bK/A9p4roQtSrKp19aWty2uvVq+vElWI5gjdc6pUiaU4I9FQi7moOBEAL9euwnsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables support for runtime pm for SYSMMU controllers. State
of each controller is saved before master's device power domain is
turned off and restored after it has been turned on.

exynos_iommu_attach_device() function might be called anytime, even when
power domain for master's device has been turned off, so to let SYSMMU
controllers to access its registers, a call to pm_runtime_get_sync() has
to be done, which turns on the power domain, which SYSMMU belongs to.
Later, once SYSMMU has been enabled, a call to pm_runtime_put() lets
runtime pm to turn off the power domain if there are no other devices
enabled. This way, the SYSMMU drivers get a genpd pm event and save its
state with sysmmu_save_state() function.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/iommu/exynos-iommu.c | 54 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 53 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 336b2f8..5cd91b11 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -28,6 +28,7 @@
 #include <linux/list.h>
 #include <linux/memblock.h>
 #include <linux/export.h>
+#include <linux/pm_domain.h>
 
 #include <asm/cacheflush.h>
 #include <asm/dma-iommu.h>
@@ -208,6 +209,7 @@ struct sysmmu_drvdata {
 	struct clk *clk;
 	struct clk *clk_master;
 	int activations;
+	int suspended;
 	spinlock_t lock;
 	struct iommu_domain *domain;
 	struct list_head domain_node;
@@ -217,6 +219,7 @@ struct sysmmu_drvdata {
 	const char *name;
 	dma_addr_t base;
 	size_t size;
+	struct notifier_block pm_notifier;
 };
 
 static bool set_sysmmu_active(struct sysmmu_drvdata *data)
@@ -235,7 +238,7 @@ static bool set_sysmmu_inactive(struct sysmmu_drvdata *data)
 
 static bool is_sysmmu_active(struct sysmmu_drvdata *data)
 {
-	return data->activations > 0;
+	return (!data->suspended && data->activations > 0);
 }
 
 static void sysmmu_unblock(void __iomem *sfrbase)
@@ -528,6 +531,51 @@ static void sysmmu_tlb_invalidate_entry(struct sysmmu_drvdata *data,
 	spin_unlock_irqrestore(&data->lock, flags);
 }
 
+static void sysmmu_restore_state(struct sysmmu_drvdata *data)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&data->lock, flags);
+	if (data->activations > 0) {
+		data->suspended = false;
+		__sysmmu_enable_nocount(data);
+		dev_dbg(data->sysmmu, "restored state\n");
+	}
+	spin_unlock_irqrestore(&data->lock, flags);
+}
+
+static void sysmmu_save_state(struct sysmmu_drvdata *data)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&data->lock, flags);
+	if (data->activations > 0) {
+		__sysmmu_disable_nocount(data);
+		data->suspended = true;
+		dev_dbg(data->sysmmu, "saved state\n");
+	}
+	spin_unlock_irqrestore(&data->lock, flags);
+}
+
+static int sysmmu_runtime_genpd_event(struct notifier_block *this,
+				unsigned long event, void *ptr)
+{
+	struct sysmmu_drvdata *data;
+
+	data = container_of(this, struct sysmmu_drvdata, pm_notifier);
+
+	switch (event) {
+	case PM_GENPD_POST_POWER_ON:
+		sysmmu_restore_state(data);
+		break;
+	case PM_GENPD_POWER_OFF_PREPARE:
+		sysmmu_save_state(data);
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
 static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 {
 	int irq, ret;
@@ -580,6 +628,7 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 	}
 
 	data->sysmmu = dev;
+	data->pm_notifier.notifier_call = sysmmu_runtime_genpd_event;
 
 	/* default io address space parameters */
 	data->base = SZ_1G;
@@ -708,6 +757,7 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
 		return -ENODEV;
 
 	list_for_each_entry(data, &owner->clients, owner_node) {
+		pm_runtime_get_sync(data->sysmmu);
 		ret = __sysmmu_enable(data, pagetable, domain);
 		if (ret >= 0) {
 			data->master = dev;
@@ -716,6 +766,7 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
 			list_add_tail(&data->domain_node, &priv->clients);
 			spin_unlock_irqrestore(&priv->lock, flags);
 		}
+		pm_runtime_put(data->sysmmu);
 	}
 
 	if (ret < 0) {
@@ -1156,6 +1207,7 @@ static int __init_master_sysmmu(struct device *dev)
 		}
 
 		list_add_tail(&data->owner_node, &owner->clients);
+		pm_genpd_register_notifier(dev, &data->pm_notifier);
 
 		i++;
 	}
-- 
1.9.2


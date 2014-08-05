Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbaHEKvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:51:00 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:52908 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077AbaHEKtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:49:11 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-ba-53e0b6a57051
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
Subject: [PATCH 24/29] iommu: exynos: create default iommu-based dma-mapping
 for master devices
Date: Tue, 05 Aug 2014 12:47:52 +0200
Message-id: <1407235677-26324-25-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t/xq7pLtz0INvhx1Mji76Rj7BbNi9ez
	WUy6P4HFYsF+a4vO2RvYLXoXXGWzONv0ht2ic+ISdosvVx4yWWx6fI3V4vKuOWwWM87vY7JY
	e+Quu8Wp65/ZLP71HmS0OHP6EqvF/z072C0Ov2lntTjycDe7xapdfxgtbv/mcxD1eHJwHpPH
	71+TGD12zrrL7jG7Yyarx6ZVnWwe++euYffYvKTe4/a/x8wek28sZ/S4cqKJ1aO3+R2bx5ar
	7SwefVtWMXp83iQXwBfFZZOSmpNZllqkb5fAlXH49w3GgvOiFb/2dDA2MP4S7GLk5JAQMJFY
	dnAXM4QtJnHh3nq2LkYuDiGBpYwSr4/tYoJw+pgkWibvZQWpYhMwlOh62wVWJSLQyyjR3/QD
	rIpZYB2rxP7e6ywgVcICiRIbJrYygtgsAqoSP3ZuYQOxeQU8Jd53P2OC2Ccn8f/lCjCbEyh+
	+OYBsA1CAh4SPzesYZ/AyLuAkWEVo2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkjsfN3BuPSY
	1SFGAQ5GJR5ehb13g4VYE8uKK3MPMUpwMCuJ8EqseRAsxJuSWFmVWpQfX1Sak1p8iJGJg1Oq
	gVH26gGumhvi1Zs3lq/9dv7dW82aGdsn5O6MeebW9su6s+lTZOn6pp/Prm24dr9cx4NVum3Z
	ZLGHuRtt/U5OXux34Nmb2QEHHLb4Wj7ZfHC5DldvnoMOq1HRLCaJcxlf5WJvbeSoDgnf+k2S
	nVfBwVfk4tQ47h97gjT2LVgWzzR19sM+phnviz4psRRnJBpqMRcVJwIAZXTVTHsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds code to create default per-device iommu-based
dma-mapping instance for all master devices, whose driver didn't set
DRIVER_HAS_OWN_IOMMU_MANAGER flag.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/iommu/exynos-iommu.c | 49 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 845f547..336b2f8 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -12,6 +12,7 @@
 #define DEBUG
 #endif
 
+#include <linux/dma-mapping.h>
 #include <linux/io.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
@@ -29,6 +30,7 @@
 #include <linux/export.h>
 
 #include <asm/cacheflush.h>
+#include <asm/dma-iommu.h>
 #include <asm/pgtable.h>
 
 typedef u32 sysmmu_iova_t;
@@ -1064,6 +1066,43 @@ static phys_addr_t exynos_iommu_iova_to_phys(struct iommu_domain *domain,
 	return phys;
 }
 
+static int sysmmu_master_device_event(struct notifier_block *nb,
+				      unsigned long val, void *p)
+{
+	struct device *dev = p;
+	struct exynos_iommu_owner *owner = dev->archdata.iommu;
+	struct sysmmu_drvdata *data;
+
+	if (!owner)
+		return 0;
+
+	data = list_first_entry(&owner->clients, struct sysmmu_drvdata,
+				owner_node);
+	if (!data)
+		return 0;
+
+	switch (val) {
+
+	case IOMMU_GROUP_NOTIFY_BIND_DRIVER:
+		if (!(dev->driver->flags & DRIVER_HAS_OWN_IOMMU_MANAGER))
+			arm_iommu_create_default_mapping(dev, data->base,
+							 data->size);
+		break;
+
+	case IOMMU_GROUP_NOTIFY_UNBOUND_DRIVER:
+	case IOMMU_GROUP_NOTIFY_DRVBIND_FAILED:
+		if (!(dev->driver->flags & DRIVER_HAS_OWN_IOMMU_MANAGER))
+			arm_iommu_release_default_mapping(dev);
+		break;
+	}
+
+	return 0;
+}
+
+static struct notifier_block sysmmu_master_device_notifier = {
+	.notifier_call = sysmmu_master_device_event,
+};
+
 static void __free_owner_struct(struct exynos_iommu_owner *owner,
 				struct device *dev)
 {
@@ -1202,6 +1241,7 @@ static int exynos_iommu_add_device(struct device *dev)
 	if (ret != 0)
 		goto err;
 
+	iommu_group_register_notifier(group, &sysmmu_master_device_notifier);
 	iommu_group_put(group);
 
 	return 0;
@@ -1213,8 +1253,15 @@ err:
 static void exynos_iommu_remove_device(struct device *dev)
 {
 	struct exynos_iommu_owner *owner = dev->archdata.iommu;
+	struct iommu_group *group = iommu_group_get(dev);
+
+	if (group) {
+		iommu_group_unregister_notifier(group,
+						&sysmmu_master_device_notifier);
+		iommu_group_remove_device(dev);
+		iommu_group_put(group);
+	}
 
-	iommu_group_remove_device(dev);
 	if (owner)
 		__free_owner_struct(owner, dev);
 }
-- 
1.9.2


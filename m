Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933376AbaHEK5L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:57:11 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:52871 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795AbaHEKs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:48:58 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-b2-53e0b697f7a0
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
Subject: [PATCH 08/29] ARM: dma-mapping: add helpers for managing default
 per-device dma mappings
Date: Tue, 05 Aug 2014 12:47:36 +0200
Message-id: <1407235677-26324-9-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsVy+t/xq7rTtz0INnixy9zi76Rj7BbNi9ez
	WUy6P4HFYsF+a4vO2RvYLXoXXGWzONv0ht2ic+ISdosvVx4yWWx6fI3V4vKuOWwWM87vY7JY
	e+Quu8Wp65/ZLP71HmS0OHP6EqvF/z072C0Ov2lntTjycDe7xapdfxgtbv/mcxD1eHJwHpPH
	71+TGD12zrrL7jG7Yyarx6ZVnWwe++euYffYvKTe4/a/x8wek28sZ/S4cqKJ1aO3+R2bx5ar
	7SwefVtWMXp83iQXwBfFZZOSmpNZllqkb5fAldG4XKhgsmBFz+4LbA2MZ/i6GDk5JARMJO6t
	XcACYYtJXLi3nq2LkYtDSGApo8SU6/OYIJw+JolzDQtZQarYBAwlut52gVWJCPQySvQ3/QCr
	YhZYxyqxv/c62CxhgWSJiWd3s4PYLAKqEncWPWACsXkFPCRebTjPDLFPTuL/yxVgcU4BT4nD
	Nw+AbRACqvm5YQ37BEbeBYwMqxhFU0uTC4qT0nMN9YoTc4tL89L1kvNzNzFCIufLDsbFx6wO
	MQpwMCrx8BqcvhssxJpYVlyZe4hRgoNZSYRXYs2DYCHelMTKqtSi/Pii0pzU4kOMTBycUg2M
	+uqvTNunTrh0wlzv6U0n2/vMM3inJR5S9yt+wZxmycxp6p6xK/OA3EPxZ0y3Tc9U/b9Y4Pb/
	bsW3dqXbHs0SV1fPvyYxo37m2W3/dG4sfZ7IPnsKq3jLHvl11SHOr9mizW4w9W6wWZN+a+Kx
	C6zNSp3p7KeVH9pfO/clZPpP+T1uuyv8CpInKrEUZyQaajEXFScCAJzxRH16AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds 2 helpers: arm_iommu_create_default_mapping and
arm_iommu_release_default_mapping for managing default iommu-based
dma-mapping address space, created for exlusive use only by the given
device. Those helpers are convenient for setting up iommu-based
dma-mapping for most typical devices in the system.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/include/asm/dma-iommu.h |  5 +++++
 arch/arm/mm/dma-mapping.c        | 31 +++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/arch/arm/include/asm/dma-iommu.h b/arch/arm/include/asm/dma-iommu.h
index 8e3fcb9..ae3dac0 100644
--- a/arch/arm/include/asm/dma-iommu.h
+++ b/arch/arm/include/asm/dma-iommu.h
@@ -33,5 +33,10 @@ int arm_iommu_attach_device(struct device *dev,
 					struct dma_iommu_mapping *mapping);
 void arm_iommu_detach_device(struct device *dev);
 
+int arm_iommu_create_default_mapping(struct device *dev, dma_addr_t base,
+				     size_t size);
+
+void arm_iommu_release_default_mapping(struct device *dev);
+
 #endif /* __KERNEL__ */
 #endif
diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 8161102..233a8cf 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -2106,4 +2106,35 @@ void arm_iommu_detach_device(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(arm_iommu_detach_device);
 
+int arm_iommu_create_default_mapping(struct device *dev, dma_addr_t base,
+				     size_t size)
+{
+	struct dma_iommu_mapping *mapping;
+	int ret;
+
+	mapping = arm_iommu_create_mapping(dev->bus, base, size);
+	if (IS_ERR(mapping))
+		return PTR_ERR(mapping);
+
+	ret = arm_iommu_attach_device(dev, mapping);
+	if (ret) {
+		arm_iommu_release_mapping(mapping);
+		return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(arm_iommu_create_default_mapping);
+
+void arm_iommu_release_default_mapping(struct device *dev)
+{
+	struct dma_iommu_mapping *mapping = to_dma_iommu_mapping(dev);
+	if (!mapping)
+		return;
+
+	arm_iommu_detach_device(dev);
+	arm_iommu_release_mapping(mapping);
+}
+EXPORT_SYMBOL_GPL(arm_iommu_release_default_mapping);
+
 #endif
-- 
1.9.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358AbaHEK5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:57:08 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:18304 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826AbaHEKs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:48:58 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-af-53e0b6963628
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
Subject: [PATCH 07/29] ARM: dma-mapping: arm_iommu_attach_device: automatically
 set max_seg_size
Date: Tue, 05 Aug 2014 12:47:35 +0200
Message-id: <1407235677-26324-8-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t/xq7rTtj0INnj50dLi76Rj7BbNi9ez
	WUy6P4HFYsF+a4vO2RvYLXoXXGWzONv0ht2ic+ISdosvVx4yWWx6fI3V4vKuOWwWM87vY7JY
	e+Quu8Wp65/ZLP71HmS0OHP6EqvF/z072C0Ov2lntTjycDe7xapdfxgtbv/mcxD1eHJwHpPH
	71+TGD12zrrL7jG7Yyarx6ZVnWwe++euYffYvKTe4/a/x8wek28sZ/S4cqKJ1aO3+R2bx5ar
	7SwefVtWMXp83iQXwBfFZZOSmpNZllqkb5fAlXHz5Ay2gjccFYcevmBtYJzG3sXIySEhYCJx
	+vRDNghbTOLCvfVANheHkMBSRom9B5cwQzh9TBI/mm4yg1SxCRhKdL3tAqsSEehllOhv+sEE
	4jALrGOV2N97nQWkSlggSeLI7idgNouAqsTetf/BunkFPCQevvjCBLFPTuL/yxVgNqeAp8Th
	mwdYQWwhoJqfG9awT2DkXcDIsIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJHa+7GBcfMzq
	EKMAB6MSD6/B6bvBQqyJZcWVuYcYJTiYlUR4JdY8CBbiTUmsrEotyo8vKs1JLT7EyMTBKdXA
	aDypM31C2hwh10U/Aq+o9Ah0Njqs61zkyB0grS4qflOg2aJkyftNUp93S3/8OfMC78ITGpIL
	Lvxx+3q3iP1eUgSj3r6GnP2xuUVRi6pqAp7s73CQfqo0L7dfI7b0cSSz1Y6SjJ44qzTRxys8
	/V0uV/mwLNWe6L740Od3D1+1T2w9O/vDlb1LlViKMxINtZiLihMBmZQDYHsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If device has no max_seg_size set, we assume that there is no limit and
force it to DMA_BIT_MASK(32) to always use contiguous mappings in DMA
address space.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/mm/dma-mapping.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 7a996aa..8161102 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -2051,6 +2051,22 @@ int arm_iommu_attach_device(struct device *dev,
 {
 	int err;
 
+	/*
+	 * if device has no max_seg_size set, we assume that there is no limit
+	 * and force it to DMA_BIT_MASK(32) to always use contiguous mappings
+	 * in DMA address space
+	 */
+	if (!dev->dma_parms) {
+		dev->dma_parms = kzalloc(sizeof(*dev->dma_parms), GFP_KERNEL);
+		if (!dev->dma_parms)
+			return -ENOMEM;
+	}
+	if (!dev->dma_parms->max_segment_size) {
+		err = dma_set_max_seg_size(dev, DMA_BIT_MASK(32));
+		if (err)
+			return err;
+	}
+
 	err = iommu_attach_device(mapping->domain, dev);
 	if (err)
 		return err;
-- 
1.9.2


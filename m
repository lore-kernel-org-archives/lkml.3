Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbbAWWds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 17:33:48 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:48424 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbbAWWdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 17:33:42 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>
CC: Murali Karicheri <m-karicheri2@ti.com>, Joerg Roedel <joro@8bytes.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH v4 3/6] of: fix size when dma-range is not used
Date: Fri, 23 Jan 2015 17:32:36 -0500
Message-ID: <1422052359-12384-4-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422052359-12384-1-git-send-email-m-karicheri2@ti.com>
References: <1422052359-12384-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the dma-range size when the DT attribute is missing. i.e  set size to
dev->coherent_dma_mask + 1 instead of dev->coherent_dma_mask. To detect
overflow when mask is set to max of u64, add a check, log error and return.
Some platform use mask format for size in DTS. So add a work around to
catch this and fix.

Cc: Joerg Roedel <joro@8bytes.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 drivers/of/device.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/of/device.c b/drivers/of/device.c
index 2de320d..0a5ff54 100644
--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -105,12 +105,24 @@ void of_dma_configure(struct device *dev, struct device_node *np)
 	ret = of_dma_get_range(np, &dma_addr, &paddr, &size);
 	if (ret < 0) {
 		dma_addr = offset = 0;
-		size = dev->coherent_dma_mask;
+		size = dev->coherent_dma_mask + 1;
 	} else {
 		offset = PFN_DOWN(paddr - dma_addr);
+		/*
+		 * Add a work around to treat the size as mask + 1 in case
+		 * it is defined in DT as a mask.
+		 */
+		if (size & 1)
+			size = size + 1;
 		dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", offset);
 	}
 
+	/* if size is 0, we have an overflow of u64 */
+	if (!size) {
+		dev_err(dev, "invalid size\n");
+		return;
+	}
+
 	dev->dma_pfn_offset = offset;
 
 	coherent = of_dma_is_coherent(np);
-- 
1.7.9.5


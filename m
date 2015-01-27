Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759756AbbA0VBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 16:01:13 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47403 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbbA0VBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 16:01:06 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>, <devicetree@vger.kernel.org>,
        <linux-pci@vger.kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>, Joerg Roedel <joro@8bytes.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH v5 3/8] of: fix size when dma-range is not used
Date: Tue, 27 Jan 2015 16:00:00 -0500
Message-ID: <1422392405-32196-4-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422392405-32196-1-git-send-email-m-karicheri2@ti.com>
References: <1422392405-32196-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the dma-range size when the DT attribute is missing. i.e  set size to
dev->coherent_dma_mask + 1 instead of dev->coherent_dma_mask. Also add
code to check invalid values of size configured in DT and log error.

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
 drivers/of/device.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/of/device.c b/drivers/of/device.c
index 2de320d..17504f4 100644
--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -105,12 +105,19 @@ void of_dma_configure(struct device *dev, struct device_node *np)
 	ret = of_dma_get_range(np, &dma_addr, &paddr, &size);
 	if (ret < 0) {
 		dma_addr = offset = 0;
-		size = dev->coherent_dma_mask;
+		size = dev->coherent_dma_mask + 1;
 	} else {
 		offset = PFN_DOWN(paddr - dma_addr);
 		dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", offset);
 	}
 
+	if (is_power_of_2(size + 1))
+		size = size + 1;
+	else if (!is_power_of_2(size)) {
+		dev_err(dev, "invalid size\n");
+		return;
+	}
+
 	dev->dma_pfn_offset = offset;
 
 	coherent = of_dma_is_coherent(np);
-- 
1.7.9.5


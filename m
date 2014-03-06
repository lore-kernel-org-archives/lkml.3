Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaCFJVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:21:21 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:46226 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbaCFJVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:21:16 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH 5/7] of: Add set_arch_dma_coherent_ops() and setup coherent dma_ops
Date: Thu, 6 Mar 2014 17:19:56 +0800
Message-ID: <1394097598-17622-6-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394097598-17622-1-git-send-email-santosh.shilimkar@ti.com>
References: <1394097598-17622-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add set_arch_dma_coherent_ops() for architectures to setup coherent dma_ops.
Update dt_dma_configure() to look for a "dma-coherent" property in the
device's node, and its ancestors If this property is found, we call
set_arch_dma_coherent_ops() per device to apply coherent DMA configuartion.

The set_arch_dma_coherent_ops() is declared as __weak and it's expected
that the arch's needing it will imlepment it.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 drivers/of/platform.c       |    5 +++++
 include/linux/dma-mapping.h |    7 +++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 53bb12f..272e390 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -255,6 +255,11 @@ static void dt_dma_configure(struct device *dev)
 		dev_err(dev, "failed to set coherent DMA mask %pad\n",
 			&dma_mask);
 	}
+
+	if (of_dma_is_coherent(dev->of_node)) {
+		set_arch_dma_coherent_ops(dev);
+		dev_dbg(dev, "device is dma coherent\n");
+	}
 }
 
 /**
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index fd4aee2..c7d9b1b 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -123,6 +123,13 @@ static inline int dma_coerce_mask_and_coherent(struct device *dev, u64 mask)
 
 extern u64 dma_get_required_mask(struct device *dev);
 
+#ifndef set_arch_dma_coherent_ops
+static inline int set_arch_dma_coherent_ops(struct device *dev)
+{
+	return 0;
+}
+#endif
+
 static inline unsigned int dma_get_max_seg_size(struct device *dev)
 {
 	return dev->dma_parms ? dev->dma_parms->max_segment_size : 65536;
-- 
1.7.9.5


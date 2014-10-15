Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342AbaJOUcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 16:32:53 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33869 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbaJOUcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 16:32:52 -0400
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@linaro.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] base: dma-coherent: fix device_init initialization
Date: Wed, 15 Oct 2014 15:32:20 -0500
Message-ID: <1413405140-17777-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.1.0.GIT
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 7bfa5ab (drivers: dma-coherent: add initialization
from device tree) added support for dma coherent pool for
DeviceTree. Unfortunately that commit introduced a new
build warning because of a wrong type on the definition
of ->device_init(). This patch fixes it.

Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Josh Cartwright <joshc@codeaurora.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Fixes: 7bfa5ab6 (drivers: dma-coherent: add initialization
	from device tree)
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/base/dma-coherent.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/base/dma-coherent.c b/drivers/base/dma-coherent.c
index 55b8398..d3695a8 100644
--- a/drivers/base/dma-coherent.c
+++ b/drivers/base/dma-coherent.c
@@ -276,7 +276,7 @@ EXPORT_SYMBOL(dma_mmap_from_coherent);
 #include <linux/of_fdt.h>
 #include <linux/of_reserved_mem.h>
 
-static int rmem_dma_device_init(struct reserved_mem *rmem, struct device *dev)
+static void rmem_dma_device_init(struct reserved_mem *rmem, struct device *dev)
 {
 	struct dma_coherent_mem *mem = rmem->priv;
 
@@ -286,11 +286,10 @@ static int rmem_dma_device_init(struct reserved_mem *rmem, struct device *dev)
 				     &mem) != DMA_MEMORY_MAP) {
 		pr_err("Reserved memory: failed to init DMA memory pool at %pa, size %ld MiB\n",
 			&rmem->base, (unsigned long)rmem->size / SZ_1M);
-		return -ENODEV;
+		return;
 	}
 	rmem->priv = mem;
 	dma_assign_coherent_memory(dev, mem);
-	return 0;
 }
 
 static void rmem_dma_device_release(struct reserved_mem *rmem,
-- 
2.1.0.GIT


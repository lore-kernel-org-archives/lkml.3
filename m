Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbaESHLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 03:11:37 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:19766 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbaESHLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 03:11:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 19 May 2014 00:06:42 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Lucas Stach <dev@lynxeye.de>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 4/4] drm/nouveau: introduce CPU cache flushing macro
Date: Mon, 19 May 2014 16:10:58 +0900
Message-ID: <1400483458-9648-5-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400483458-9648-1-git-send-email-acourbot@nvidia.com>
References: <1400483458-9648-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some architectures (e.g. ARM) need the CPU buffers to be explicitely
flushed for a memory write to take effect. Not doing so results in
synchronization issues, especially after writing to BOs.

This patch introduces a macro that flushes the caches on ARM and
translates to a no-op on other architectures, and uses it when
writing to in-memory BOs. It will also be useful for implementations of
instmem that access shared memory directly instead of going through
PRAMIN.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/core/os.h    | 17 +++++++++++++++++
 drivers/gpu/drm/nouveau/nouveau_bo.c |  8 ++++++--
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/os.h b/drivers/gpu/drm/nouveau/core/os.h
index d0ced94ca54c..274b4460bb03 100644
--- a/drivers/gpu/drm/nouveau/core/os.h
+++ b/drivers/gpu/drm/nouveau/core/os.h
@@ -38,4 +38,21 @@
 #endif /* def __BIG_ENDIAN else */
 #endif /* !ioread32_native */
 
+#if defined(__arm__)
+
+#define nv_cpu_cache_flush_area(va, size)	\
+do {						\
+	phys_addr_t pa = virt_to_phys(va);	\
+	__cpuc_flush_dcache_area(va, size);	\
+	outer_flush_range(pa, pa + size);	\
+} while (0)
+
+#else
+
+#define nv_cpu_cache_flush_area(va, size)	\
+do {						\
+} while (0)
+
+#endif /* defined(__arm__) */
+
 #endif
diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index 0886f47e5244..b9c9729c5733 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -437,8 +437,10 @@ nouveau_bo_wr16(struct nouveau_bo *nvbo, unsigned index, u16 val)
 	mem = &mem[index];
 	if (is_iomem)
 		iowrite16_native(val, (void __force __iomem *)mem);
-	else
+	else {
 		*mem = val;
+		nv_cpu_cache_flush_area(mem, 2);
+	}
 }
 
 u32
@@ -461,8 +463,10 @@ nouveau_bo_wr32(struct nouveau_bo *nvbo, unsigned index, u32 val)
 	mem = &mem[index];
 	if (is_iomem)
 		iowrite32_native(val, (void __force __iomem *)mem);
-	else
+	else {
 		*mem = val;
+		nv_cpu_cache_flush_area(mem, 4);
+	}
 }
 
 static struct ttm_tt *
-- 
1.9.2


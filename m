Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab3KALgb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 07:36:31 -0400
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:29663
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755993Ab3KALg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 07:36:27 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6h1082kz70kz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h1155h)
From: Nicolin Chen <b42378@freescale.com>
To: <akpm@linux-foundation.org>, <joe@perches.com>, <nsekhar@ti.com>,
        <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <dan.j.williams@intel.com>, <vinod.koul@intel.com>,
        <m.chehab@samsung.com>, <hjk@hansjkoch.de>,
        <gregkh@linuxfoundation.org>, <perex@perex.cz>, <tiwai@suse.de>,
        <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <rmk+kernel@arm.linux.org.uk>, <eric.y.miao@gmail.com>,
        <haojian.zhuang@gmail.com>
CC: <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <dmaengine@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <alsa-devel@alsa-project.org>
Subject: [PATCH 1/8] lib/genalloc: add a helper function for DMA buffer allocation
Date: Fri, 1 Nov 2013 19:35:59 +0800
Message-ID: <554196b707b88047dce4e300848b81cc2677578d.1383303752.git.b42378@freescale.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1383303752.git.b42378@freescale.com>
References: <cover.1383303752.git.b42378@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using pool space for DMA buffer, there might be duplicated calling
of gen_pool_alloc() and gen_pool_virt_to_phys() in each implementation.

Thus it's better to add a simple helper function, a compatible one to
the common dma_alloc_coherent(), to save some code.

Signed-off-by: Nicolin Chen <b42378@freescale.com>
---
 include/linux/genalloc.h |  2 ++
 lib/genalloc.c           | 28 ++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/include/linux/genalloc.h b/include/linux/genalloc.h
index f8d41cb..1eda33d 100644
--- a/include/linux/genalloc.h
+++ b/include/linux/genalloc.h
@@ -94,6 +94,8 @@ static inline int gen_pool_add(struct gen_pool *pool, unsigned long addr,
 }
 extern void gen_pool_destroy(struct gen_pool *);
 extern unsigned long gen_pool_alloc(struct gen_pool *, size_t);
+extern void *gen_pool_dma_alloc(struct gen_pool *pool, size_t size,
+		dma_addr_t *dma);
 extern void gen_pool_free(struct gen_pool *, unsigned long, size_t);
 extern void gen_pool_for_each_chunk(struct gen_pool *,
 	void (*)(struct gen_pool *, struct gen_pool_chunk *, void *), void *);
diff --git a/lib/genalloc.c b/lib/genalloc.c
index 26cf20b..dda3116 100644
--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -313,6 +313,34 @@ retry:
 EXPORT_SYMBOL(gen_pool_alloc);
 
 /**
+ * gen_pool_dma_alloc - allocate special memory from the pool for DMA usage
+ * @pool: pool to allocate from
+ * @size: number of bytes to allocate from the pool
+ * @dma: dma-view physical address
+ *
+ * Allocate the requested number of bytes from the specified pool.
+ * Uses the pool allocation function (with first-fit algorithm by default).
+ * Can not be used in NMI handler on architectures without
+ * NMI-safe cmpxchg implementation.
+ */
+void *gen_pool_dma_alloc(struct gen_pool *pool, size_t size, dma_addr_t *dma)
+{
+	unsigned long vaddr;
+
+	if (!pool)
+		return NULL;
+
+	vaddr = gen_pool_alloc(pool, size);
+	if (!vaddr)
+		return NULL;
+
+	*dma = gen_pool_virt_to_phys(pool, vaddr);
+
+	return (void *)vaddr;
+}
+EXPORT_SYMBOL(gen_pool_dma_alloc);
+
+/**
  * gen_pool_free - free allocated special memory back to the pool
  * @pool: pool to free to
  * @addr: starting address of memory to free back to pool
-- 
1.8.4



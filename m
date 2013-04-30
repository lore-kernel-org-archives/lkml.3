Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759380Ab3D3DCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 23:02:23 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:52449 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759002Ab3D3DCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 23:02:22 -0400
From: Damian Hobson-Garcia <dhobsong@igel.co.jp>
To: linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com, will.deacon@arm.com,
        linux-arm-kernel@lists.infradead.org,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>
Subject: [PATCH v2 1/4] arm64: Provide default implementation for dma_{alloc,free}_attrs
Date: Tue, 30 Apr 2013 12:02:13 +0900
Message-Id: <1367290933-10453-1-git-send-email-dhobsong@igel.co.jp>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most architectures that define CONFIG_HAVE_DMA, have implementations for
both dma_alloc_attrs() and dma_free_attrs().  All achitectures that do
not define CONFIG_HAVE_DMA also have both of these definitions provided by
dma-mapping-broken.h.

Add default implementations for these functions on arm64.

Signed-off-by: Damian Hobson-Garcia <dhobsong@igel.co.jp>
---
 arch/arm64/include/asm/dma-mapping.h |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/dma-mapping.h b/arch/arm64/include/asm/dma-mapping.h
index 9947768..6ff7b8d 100644
--- a/arch/arm64/include/asm/dma-mapping.h
+++ b/arch/arm64/include/asm/dma-mapping.h
@@ -81,8 +81,12 @@ static inline void dma_mark_clean(void *addr, size_t size)
 {
 }
 
-static inline void *dma_alloc_coherent(struct device *dev, size_t size,
-				       dma_addr_t *dma_handle, gfp_t flags)
+#define dma_alloc_coherent(d, s, h, f) dma_alloc_attrs(d, s, h, f, NULL)
+#define dma_free_coherent(d, s, h, f) dma_free_attrs(d, s, h, f, NULL)
+
+static inline void *dma_alloc_attrs(struct device *dev, size_t size,
+				       dma_addr_t *dma_handle, gfp_t flags,
+				       struct dma_attrs *attrs)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 	void *vaddr;
@@ -90,13 +94,14 @@ static inline void *dma_alloc_coherent(struct device *dev, size_t size,
 	if (dma_alloc_from_coherent(dev, size, dma_handle, &vaddr))
 		return vaddr;
 
-	vaddr = ops->alloc(dev, size, dma_handle, flags, NULL);
+	vaddr = ops->alloc(dev, size, dma_handle, flags, attrs);
 	debug_dma_alloc_coherent(dev, size, *dma_handle, vaddr);
 	return vaddr;
 }
 
-static inline void dma_free_coherent(struct device *dev, size_t size,
-				     void *vaddr, dma_addr_t dev_addr)
+static inline void dma_free_attrs(struct device *dev, size_t size,
+				     void *vaddr, dma_addr_t dev_addr,
+				     struct dma_attrs *attrs)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 
@@ -104,7 +109,7 @@ static inline void dma_free_coherent(struct device *dev, size_t size,
 		return;
 
 	debug_dma_free_coherent(dev, size, vaddr, dev_addr);
-	ops->free(dev, size, vaddr, dev_addr, NULL);
+	ops->free(dev, size, vaddr, dev_addr, attrs);
 }
 
 /*
-- 
1.7.5.4


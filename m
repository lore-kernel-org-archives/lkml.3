Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582Ab3E1BiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 21:38:06 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:51152 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758529Ab3E1BiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 21:38:04 -0400
From: Damian Hobson-Garcia <dhobsong@igel.co.jp>
To: linux-kernel@vger.kernel.org
Cc: linux-s390@vger.kernel.org, Damian Hobson-Garcia <dhobsong@igel.co.jp>
Subject: [PATCH v3 3/3] s390: Provide default implementation for dma_{alloc,free}_attrs
Date: Tue, 28 May 2013 10:37:53 +0900
Message-Id: <1369705073-16427-1-git-send-email-dhobsong@igel.co.jp>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most architectures that define CONFIG_HAS_DMA, have implementations for
both dma_alloc_attrs() and dma_free_attrs().  All achitectures that do
not define CONFIG_HAS_DMA also have both of these definitions provided by
dma-mapping-broken.h.

Add default implementations for these functions on s390.

Signed-off-by: Damian Hobson-Garcia <dhobsong@igel.co.jp>
---
 arch/s390/include/asm/dma-mapping.h |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/s390/include/asm/dma-mapping.h b/arch/s390/include/asm/dma-mapping.h
index 9411db65..3a549b6 100644
--- a/arch/s390/include/asm/dma-mapping.h
+++ b/arch/s390/include/asm/dma-mapping.h
@@ -55,23 +55,28 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 	return (dma_addr == 0UL);
 }
 
-static inline void *dma_alloc_coherent(struct device *dev, size_t size,
-				       dma_addr_t *dma_handle, gfp_t flag)
+#define dma_alloc_coherent(d, s, h, f) dma_alloc_attrs(d, s, h, f, NULL)
+#define dma_free_coherent(d, s, h, f) dma_free_attrs(d, s, h, f, NULL)
+
+static inline void *dma_alloc_attrs(struct device *dev, size_t size,
+				       dma_addr_t *dma_handle, gfp_t flag,
+				       struct dma_attrs *attrs)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 	void *ret;
 
-	ret = ops->alloc(dev, size, dma_handle, flag, NULL);
+	ret = ops->alloc(dev, size, dma_handle, flag, attrs);
 	debug_dma_alloc_coherent(dev, size, *dma_handle, ret);
 	return ret;
 }
 
-static inline void dma_free_coherent(struct device *dev, size_t size,
-				     void *cpu_addr, dma_addr_t dma_handle)
+static inline void dma_free_attrs(struct device *dev, size_t size,
+				     void *cpu_addr, dma_addr_t dma_handle,
+				     struct dma_attrs *attrs)
 {
 	struct dma_map_ops *dma_ops = get_dma_ops(dev);
 
-	dma_ops->free(dev, size, cpu_addr, dma_handle, NULL);
+	dma_ops->free(dev, size, cpu_addr, dma_handle, attrs);
 	debug_dma_free_coherent(dev, size, cpu_addr, dma_handle);
 }
 
-- 
1.7.5.4


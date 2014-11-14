Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935142AbaKNEbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 23:31:13 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:51397 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935104AbaKNEbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 23:31:10 -0500
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: dan.j.williams@intel.com, akpm@linux-foundation.org, jkosina@suse.cz,
        horia.geanta@freescale.com, computersforpeace@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 1/2] dma-debug: introduce dma_debug_disabled
Date: Thu, 13 Nov 2014 20:31:01 -0800
Message-Id: <1415939462-28174-2-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415939462-28174-1-git-send-email-f.fainelli@gmail.com>
References: <1415939462-28174-1-git-send-email-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a helper function which returns whether the DMA debugging API is
disabled, right now we only check for global_disable, but in order to
accomodate early callers of the DMA-API, we will check for more
initialization flags in the future.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 lib/dma-debug.c | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index add80cc02dbe..1ac35dbaf8e0 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -102,6 +102,11 @@ static DEFINE_SPINLOCK(free_entries_lock);
 /* Global disable flag - will be set in case of an error */
 static u32 global_disable __read_mostly;
 
+static inline bool dma_debug_disabled(void)
+{
+	return global_disable;
+}
+
 /* Global error count */
 static u32 error_count;
 
@@ -945,7 +950,7 @@ static int dma_debug_device_change(struct notifier_block *nb, unsigned long acti
 	struct dma_debug_entry *uninitialized_var(entry);
 	int count;
 
-	if (global_disable)
+	if (dma_debug_disabled())
 		return 0;
 
 	switch (action) {
@@ -973,7 +978,7 @@ void dma_debug_add_bus(struct bus_type *bus)
 {
 	struct notifier_block *nb;
 
-	if (global_disable)
+	if (dma_debug_disabled())
 		return;
 
 	nb = kzalloc(sizeof(struct notifier_block), GFP_KERNEL);
@@ -994,7 +999,7 @@ void dma_debug_init(u32 num_entries)
 {
 	int i;
 
-	if (global_disable)
+	if (dma_debug_disabled())
 		return;
 
 	for (i = 0; i < HASH_SIZE; ++i) {
@@ -1243,7 +1248,7 @@ void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
 {
 	struct dma_debug_entry *entry;
 
-	if (unlikely(global_disable))
+	if (unlikely(dma_debug_disabled()))
 		return;
 
 	if (dma_mapping_error(dev, dma_addr))
@@ -1283,7 +1288,7 @@ void debug_dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 	struct hash_bucket *bucket;
 	unsigned long flags;
 
-	if (unlikely(global_disable))
+	if (unlikely(dma_debug_disabled()))
 		return;
 
 	ref.dev = dev;
@@ -1325,7 +1330,7 @@ void debug_dma_unmap_page(struct device *dev, dma_addr_t addr,
 		.direction      = direction,
 	};
 
-	if (unlikely(global_disable))
+	if (unlikely(dma_debug_disabled()))
 		return;
 
 	if (map_single)
@@ -1342,7 +1347,7 @@ void debug_dma_map_sg(struct device *dev, struct scatterlist *sg,
 	struct scatterlist *s;
 	int i;
 
-	if (unlikely(global_disable))
+	if (unlikely(dma_debug_disabled()))
 		return;
 
 	for_each_sg(sg, s, mapped_ents, i) {
@@ -1395,7 +1400,7 @@ void debug_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
 	struct scatterlist *s;
 	int mapped_ents = 0, i;
 
-	if (unlikely(global_disable))
+	if (unlikely(dma_debug_disabled()))
 		return;
 
 	for_each_sg(sglist, s, nelems, i) {
@@ -1427,7 +1432,7 @@ void debug_dma_alloc_coherent(struct device *dev, size_t size,
 {
 	struct dma_debug_entry *entry;
 
-	if (unlikely(global_disable))
+	if (unlikely(dma_debug_disabled()))
 		return;
 
 	if (unlikely(virt == NULL))
@@ -1462,7 +1467,7 @@ void debug_dma_free_coherent(struct device *dev, size_t size,
 		.direction      = DMA_BIDIRECTIONAL,
 	};
 
-	if (unlikely(global_disable))
+	if (unlikely(dma_debug_disabled()))
 		return;
 
 	check_unmap(&ref);
@@ -1474,7 +1479,7 @@ void debug_dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
 {
 	struct dma_debug_entry ref;
 
-	if (unlikely(global_disable))
+	if (unlikely(dma_debug_disabled()))
 		return;
 
 	ref.type         = dma_debug_single;
@@ -1494,7 +1499,7 @@ void debug_dma_sync_single_for_device(struct device *dev,
 {
 	struct dma_debug_entry ref;
 
-	if (unlikely(global_disable))
+	if (unlikely(dma_debug_disabled()))
 		return;
 
 	ref.type         = dma_debug_single;
@@ -1515,7 +1520,7 @@ void debug_dma_sync_single_range_for_cpu(struct device *dev,
 {
 	struct dma_debug_entry ref;
 
-	if (unlikely(global_disable))
+	if (unlikely(dma_debug_disabled()))
 		return;
 
 	ref.type         = dma_debug_single;
@@ -1536,7 +1541,7 @@ void debug_dma_sync_single_range_for_device(struct device *dev,
 {
 	struct dma_debug_entry ref;
 
-	if (unlikely(global_disable))
+	if (unlikely(dma_debug_disabled()))
 		return;
 
 	ref.type         = dma_debug_single;
@@ -1556,7 +1561,7 @@ void debug_dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
 	struct scatterlist *s;
 	int mapped_ents = 0, i;
 
-	if (unlikely(global_disable))
+	if (unlikely(dma_debug_disabled()))
 		return;
 
 	for_each_sg(sg, s, nelems, i) {
@@ -1589,7 +1594,7 @@ void debug_dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 	struct scatterlist *s;
 	int mapped_ents = 0, i;
 
-	if (unlikely(global_disable))
+	if (unlikely(dma_debug_disabled()))
 		return;
 
 	for_each_sg(sg, s, nelems, i) {
-- 
1.9.1


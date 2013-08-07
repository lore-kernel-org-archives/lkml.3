Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab3HGF0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 01:26:20 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:42366 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab3HGF0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 01:26:19 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-35-5201da79759a
From: Joonyoung Shim <jy0922.shim@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH] genalloc: fix overflow of ending address of memory chunk
Date: Wed, 07 Aug 2013 14:26:18 +0900
Message-id: <1375853178-12046-1-git-send-email-jy0922.shim@samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsWyRsSkULfyFmOQwcJ2HYs569ewWVzeNYfN
	gcnjxIzfLB6fN8kFMEVx2aSk5mSWpRbp2yVwZcxe9omt4LxUxYQfS9gbGO+KdjFycEgImEh0
	Hi/sYuQEMsUkLtxbz9bFyMUhJLCUUWJ933NGiISJxOpnK1kgEosYJX4fbWSFcFqZJBb/aQer
	YhPQk7iz7TgTiC0ioCCxufcZK4jNLCArcePGTDBbWMBTYtb7JywgNouAqsS/OTfB4rwC7hKz
	73+C2qYg8fPyCbAzJASOsEn8+v+OCaJBQOLb5EMsEGfLSmw6wAxRLylxcMUNlgmMggsYGVYx
	iqYWJBcUJ6UXmegVJ+YWl+al6yXn525iBIbZ6X/PJuxgvHfA+hBjMtC4icxSosn5wDDNK4k3
	NDYzsjA1MTU2Mrc0I01YSZxXvcU6UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAMjz+Plylsz
	F5aZxF16rL373JErdVF6Mt82Wt3RNwuf5d8+X4SnVPlzvqp3wP15jd3M3b/XGzhekM1NMmo+
	XBn1p+rqYe0lUtN9Iqe8EZJYnWZxMMLpasqUpX3CEeUfuZ9Pf630yfU/X0Tjpl25Lzp97QS5
	l7AI6M471uysNTm8Y8+kmSFWJc1KLMUZiYZazEXFiQDg9t9NSQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsVy+t9jAd3KW4xBBo83qFjMWb+GzeLyrjls
	DkweJ2b8ZvH4vEkugCmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB2i+kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjFj9rJP
	bAXnpSom/FjC3sB4V7SLkZNDQsBEYvWzlSwQtpjEhXvr2boYuTiEBBYxSvw+2sgK4bQySSz+
	084IUsUmoCdxZ9txJhBbREBBYnPvM1YQm1lAVuLGjZlgtrCAp8Ss90/AprIIqEr8m3MTLM4r
	4C4x+/4nRohtChI/L59gm8DIvYCRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcBg/k97B
	uKrB4hCjAAejEg9vhRhjkBBrYllxZe4hRgkOZiURXq05QCHelMTKqtSi/Pii0pzU4kOMyUDb
	JzJLiSbnA2MsryTe0NjEzMjSyNzQwsjYnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoY
	nb4VmB6bd0A34nFhUMBG1+nSU7+eLmzTSjx5teJFiOXD6DWuQV+OXmjzDu+cZdgjemlXwo41
	DMmyy9X1Dkr+nnXpXFHIQwaFbgbW9kdql2NbYoIeP/5icM2Qk4vp15KWqKsvpE1vR301v6n7
	xDRhW+0fu8BJ4q/lo/dc2fah6dEuvgdXTT7PVmIpzkg01GIuKk4EAEc6ZSqnAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In struct gen_pool_chunk, end_addr means ending address of memory chunk,
but actually it is starting address + size of memory chunk in codes, so
it points the address increased one instead of correct ending address.

The ending address of memory chunk increased one will cause overflow on
the case to use memory chunk including last address of memory map, e.g.
when starting address is 0xFFF00000 and size is 0x100000 on 32bit
machine, ending address will be 0x100000000.

Use correct ending address like starting address + size - 1.

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 lib/genalloc.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/lib/genalloc.c b/lib/genalloc.c
index b35cfa9..2a39bf6 100644
--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -37,6 +37,11 @@
 #include <linux/of_address.h>
 #include <linux/of_device.h>
 
+static inline size_t chunk_size(const struct gen_pool_chunk *chunk)
+{
+	return chunk->end_addr - chunk->start_addr + 1;
+}
+
 static int set_bits_ll(unsigned long *addr, unsigned long mask_to_set)
 {
 	unsigned long val, nval;
@@ -188,7 +193,7 @@ int gen_pool_add_virt(struct gen_pool *pool, unsigned long virt, phys_addr_t phy
 
 	chunk->phys_addr = phys;
 	chunk->start_addr = virt;
-	chunk->end_addr = virt + size;
+	chunk->end_addr = virt + size - 1;
 	atomic_set(&chunk->avail, size);
 
 	spin_lock(&pool->lock);
@@ -213,7 +218,7 @@ phys_addr_t gen_pool_virt_to_phys(struct gen_pool *pool, unsigned long addr)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(chunk, &pool->chunks, next_chunk) {
-		if (addr >= chunk->start_addr && addr < chunk->end_addr) {
+		if (addr >= chunk->start_addr && addr <= chunk->end_addr) {
 			paddr = chunk->phys_addr + (addr - chunk->start_addr);
 			break;
 		}
@@ -242,7 +247,7 @@ void gen_pool_destroy(struct gen_pool *pool)
 		chunk = list_entry(_chunk, struct gen_pool_chunk, next_chunk);
 		list_del(&chunk->next_chunk);
 
-		end_bit = (chunk->end_addr - chunk->start_addr) >> order;
+		end_bit = chunk_size(chunk) >> order;
 		bit = find_next_bit(chunk->bits, end_bit, 0);
 		BUG_ON(bit < end_bit);
 
@@ -283,7 +288,7 @@ unsigned long gen_pool_alloc(struct gen_pool *pool, size_t size)
 		if (size > atomic_read(&chunk->avail))
 			continue;
 
-		end_bit = (chunk->end_addr - chunk->start_addr) >> order;
+		end_bit = chunk_size(chunk) >> order;
 retry:
 		start_bit = pool->algo(chunk->bits, end_bit, start_bit, nbits,
 				pool->data);
@@ -330,8 +335,8 @@ void gen_pool_free(struct gen_pool *pool, unsigned long addr, size_t size)
 	nbits = (size + (1UL << order) - 1) >> order;
 	rcu_read_lock();
 	list_for_each_entry_rcu(chunk, &pool->chunks, next_chunk) {
-		if (addr >= chunk->start_addr && addr < chunk->end_addr) {
-			BUG_ON(addr + size > chunk->end_addr);
+		if (addr >= chunk->start_addr && addr <= chunk->end_addr) {
+			BUG_ON(addr + size - 1 > chunk->end_addr);
 			start_bit = (addr - chunk->start_addr) >> order;
 			remain = bitmap_clear_ll(chunk->bits, start_bit, nbits);
 			BUG_ON(remain);
@@ -400,7 +405,7 @@ size_t gen_pool_size(struct gen_pool *pool)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(chunk, &pool->chunks, next_chunk)
-		size += chunk->end_addr - chunk->start_addr;
+		size += chunk_size(chunk);
 	rcu_read_unlock();
 	return size;
 }
-- 
1.8.1.2


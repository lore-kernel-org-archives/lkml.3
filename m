Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab3LJIX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:23:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58791 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab3LJIBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:01:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [PATCH 3.10 40/52] lib/genalloc.c: fix overflow of ending address of memory chunk
Date: Tue, 10 Dec 2013 00:01:13 -0800
Message-Id: <20131210075957.014306168@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210075954.196229872@linuxfoundation.org>
References: <20131210075954.196229872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joonyoung Shim <jy0922.shim@samsung.com>

commit 674470d97958a0ec72f72caf7f6451da40159cc7 upstream.

In struct gen_pool_chunk, end_addr means the end address of memory chunk
(inclusive), but in the implementation it is treated as address + size of
memory chunk (exclusive), so it points to the address plus one instead of
correct ending address.

The ending address of memory chunk plus one will cause overflow on the
memory chunk including the last address of memory map, e.g.  when starting
address is 0xFFF00000 and size is 0x100000 on 32bit machine, ending
address will be 0x100000000.

Use correct ending address like starting address + size - 1.

[akpm@linux-foundation.org: add comment to struct gen_pool_chunk:end_addr]
Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/genalloc.h |    4 ++--
 lib/genalloc.c           |   19 ++++++++++++-------
 2 files changed, 14 insertions(+), 9 deletions(-)

--- a/include/linux/genalloc.h
+++ b/include/linux/genalloc.h
@@ -66,8 +66,8 @@ struct gen_pool_chunk {
 	struct list_head next_chunk;	/* next chunk in pool */
 	atomic_t avail;
 	phys_addr_t phys_addr;		/* physical starting address of memory chunk */
-	unsigned long start_addr;	/* starting address of memory chunk */
-	unsigned long end_addr;		/* ending address of memory chunk */
+	unsigned long start_addr;	/* start address of memory chunk */
+	unsigned long end_addr;		/* end address of memory chunk (inclusive) */
 	unsigned long bits[0];		/* bitmap for allocating memory chunk */
 };
 
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
@@ -188,7 +193,7 @@ int gen_pool_add_virt(struct gen_pool *p
 
 	chunk->phys_addr = phys;
 	chunk->start_addr = virt;
-	chunk->end_addr = virt + size;
+	chunk->end_addr = virt + size - 1;
 	atomic_set(&chunk->avail, size);
 
 	spin_lock(&pool->lock);
@@ -213,7 +218,7 @@ phys_addr_t gen_pool_virt_to_phys(struct
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(chunk, &pool->chunks, next_chunk) {
-		if (addr >= chunk->start_addr && addr < chunk->end_addr) {
+		if (addr >= chunk->start_addr && addr <= chunk->end_addr) {
 			paddr = chunk->phys_addr + (addr - chunk->start_addr);
 			break;
 		}
@@ -242,7 +247,7 @@ void gen_pool_destroy(struct gen_pool *p
 		chunk = list_entry(_chunk, struct gen_pool_chunk, next_chunk);
 		list_del(&chunk->next_chunk);
 
-		end_bit = (chunk->end_addr - chunk->start_addr) >> order;
+		end_bit = chunk_size(chunk) >> order;
 		bit = find_next_bit(chunk->bits, end_bit, 0);
 		BUG_ON(bit < end_bit);
 
@@ -283,7 +288,7 @@ unsigned long gen_pool_alloc(struct gen_
 		if (size > atomic_read(&chunk->avail))
 			continue;
 
-		end_bit = (chunk->end_addr - chunk->start_addr) >> order;
+		end_bit = chunk_size(chunk) >> order;
 retry:
 		start_bit = pool->algo(chunk->bits, end_bit, start_bit, nbits,
 				pool->data);
@@ -330,8 +335,8 @@ void gen_pool_free(struct gen_pool *pool
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
@@ -400,7 +405,7 @@ size_t gen_pool_size(struct gen_pool *po
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(chunk, &pool->chunks, next_chunk)
-		size += chunk->end_addr - chunk->start_addr;
+		size += chunk_size(chunk);
 	rcu_read_unlock();
 	return size;
 }



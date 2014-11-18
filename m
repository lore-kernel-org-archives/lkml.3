Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487AbaKRQxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:53:30 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:54385 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425AbaKRQx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:53:27 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-42-546b79853b3d
Subject: [PATCH RFC 3/3] ARM: reduce size of page table directory for short mode
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 18 Nov 2014 19:53:25 +0400
Message-id: <20141118165325.9958.84370.stgit@buzz>
In-reply-to: <20141118165313.9958.1242.stgit@buzz>
References: <20141118165313.9958.1242.stgit@buzz>
User-Agent: StGit/0.17.1-dirty
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFLMWRmVeSWpSXmKPExsVy+t/xq7qtldkhBtvPW1v82NnLarHp8TVW
	i8u75rBZ3L7M68Di0dLcw+axeUm9R9+WVYwenzfJBbBEcdmkpOZklqUW6dslcGX8aJvLWvBZ
	tOLvq1vMDYxzhLoYOTkkBEwkNkzdyA5hi0lcuLeerYuRi0NIYCmjxPqOM4wQTiOTxIZJl8Cq
	hAUCJD59WsEGYrMJmEls23ebEcQWEciX+HpgD1icRUBVYunju8wgNq+AkcTrGxD1nED2jcN9
	YHOEBAwlllz+AGaLCshJrLzcwgpRLyjxY/I9li5GDg5mAXWJKVNyQcLMAvISm9e8ZZ7AyD8L
	SdUshKpZSKoWMDKvYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/dxAgJz687GJceszrEKMDBqMTD
	27AxK0SINbGsuDL3EKMEB7OSCO+5bqAQb0piZVVqUX58UWlOavEhRiYOTqkGxr1KX7fl6WW4
	bdp48q1sZIdxjE/E5OSDuh2dO4uL3jesqntmcNT8qKOt4glJjRAt08WZb6ui7H5uetV0oVh8
	1v+/98Iurd9q73Lj9m/BX15//4a1iMmlsD07ty2At9T4kOqqJfN2nW+Imy2tdeyV5TRmy/qJ
	4coek1r1meZ7Zguf/XjSVUFaSYmlOCPRUIu5qDgRAKhqjqItAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Virtual memory above PAGE_OFFSET is covered by TTBR1 which always points
to swapper_pg_dir, thus size of the rest pgd tables might be reduced.
Of course idmap_pgd must be full 16k because it's used without split.
It seems nobody accesses pgd entries above PAGE_OFFSET via pgd_offset(),
all access is done via pgd_offset_k() which refers directly to init_mm.

This patch saves 8k per process for 2G/2G split (12k for 1G/3G split)
and kills source of frequent order-2 allocations. Unfortunately most
commonly used 3G/1G mode isn't supported, because first part must be
power of two. LPAE supports this mode, but it's pgd is already tiny.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
---
 arch/arm/mm/idmap.c |    6 ++++++
 arch/arm/mm/pgd.c   |   14 +++++++++-----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mm/idmap.c b/arch/arm/mm/idmap.c
index cc51b40..cea7ee1 100644
--- a/arch/arm/mm/idmap.c
+++ b/arch/arm/mm/idmap.c
@@ -100,7 +100,13 @@ extern char  __idmap_text_start[], __idmap_text_end[];
 
 static int __init init_static_idmap(void)
 {
+#ifdef CONFIG_ARM_LPAE
 	idmap_pgd = pgd_alloc(&init_mm);
+#else
+	idmap_pgd = (pgd_t *)__get_free_pages(GFP_KERNEL, 2);
+	if (idmap_pgd)
+		memcpy(idmap_pgd, swapper_pg_dir, PTRS_PER_PGD * sizeof(pgd_t));
+#endif
 	if (!idmap_pgd)
 		return -ENOMEM;
 
diff --git a/arch/arm/mm/pgd.c b/arch/arm/mm/pgd.c
index 2493795..3fbcb5a 100644
--- a/arch/arm/mm/pgd.c
+++ b/arch/arm/mm/pgd.c
@@ -20,15 +20,19 @@
 #include "mm.h"
 
 #ifdef CONFIG_ARM_LPAE
+#define TTBR0_PTRS_PER_PGD	PTRS_PER_PGD
 #define __pgd_alloc()	kmalloc(PTRS_PER_PGD * sizeof(pgd_t), GFP_KERNEL)
 #define __pgd_free(pgd)	kfree(pgd)
 #else
-#define __pgd_alloc()	(pgd_t *)__get_free_pages(GFP_KERNEL | __GFP_REPEAT, 2)
-#define __pgd_free(pgd)	free_pages((unsigned long)pgd, 2)
+#define TTBR0_PTRS_PER_PGD	(PTRS_PER_PGD >> TTBR1_SIZE)
+#define __pgd_alloc()	(pgd_t *)__get_free_pages(GFP_KERNEL | __GFP_REPEAT, \
+							2 - TTBR1_SIZE)
+#define __pgd_free(pgd)	free_pages((unsigned long)pgd, 2 - TTBR1_SIZE)
 #endif
 
 /*
- * need to get a 16k page for level 1
+ * We need 4k/8k/16k for pgd in short mode for CONFIG_VMSPLIT_1G/2G/3G
+ * or only 64 bytes if LPAE is enabled.
  */
 pgd_t *pgd_alloc(struct mm_struct *mm)
 {
@@ -48,9 +52,9 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 	 */
 	init_pgd = pgd_offset_k(0);
 	memcpy(new_pgd + USER_PTRS_PER_PGD, init_pgd + USER_PTRS_PER_PGD,
-		       (PTRS_PER_PGD - USER_PTRS_PER_PGD) * sizeof(pgd_t));
+		(TTBR0_PTRS_PER_PGD - USER_PTRS_PER_PGD) * sizeof(pgd_t));
 
-	clean_dcache_area(new_pgd, PTRS_PER_PGD * sizeof(pgd_t));
+	clean_dcache_area(new_pgd, TTBR0_PTRS_PER_PGD * sizeof(pgd_t));
 
 #ifdef CONFIG_ARM_LPAE
 	/*


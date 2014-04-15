Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbaDOLOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:14:46 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:23303 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbaDOLOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:14:42 -0400
From: Liu Hua <sdu.liu@huawei.com>
To: <nicolas.pitre@linaro.org>, <linux@arm.linux.org.uk>
CC: <will.deacon@arm.com>, <vitalya@ti.com>, <cyril@ti.com>,
        <santosh.shilimkar@ti.com>, <lauraa@codeaurora.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <wangnan0@huawei.com>, <peifeiyue@huawei.com>, <liusdu@126.co>,
        Liu Hua <sdu.liu@huawei.com>
Subject: [PATCH v3 1/2] ARM : fixmap : remove FIX_KMAP_BEGIN and FIX_KMAP_END
Date: Tue, 15 Apr 2014 19:06:06 +0800
Message-ID: <1397559967-26050-2-git-send-email-sdu.liu@huawei.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1397559967-26050-1-git-send-email-sdu.liu@huawei.com>
References: <1397559967-26050-1-git-send-email-sdu.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that these two macros are not used by non
architecture specific code. And on ARM FIX_KMAP_BEGIN
equals zero.

This patch removes these two macros. Instead, using
FIX_KMAP_NR_PTES to tell the pte number belonged to
fixmap mapping region. The code will become clearer
when I introduce a bugfix on fixmap mapping region.

Reviewed-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Liu Hua <sdu.liu@huawei.com>
---
 arch/arm/include/asm/fixmap.h | 5 ++---
 arch/arm/mm/highmem.c         | 6 +++---
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/fixmap.h b/arch/arm/include/asm/fixmap.h
index bbae919..be55ebc 100644
--- a/arch/arm/include/asm/fixmap.h
+++ b/arch/arm/include/asm/fixmap.h
@@ -17,8 +17,7 @@
 #define FIXADDR_TOP		0xfffe0000UL
 #define FIXADDR_SIZE		(FIXADDR_TOP - FIXADDR_START)
 
-#define FIX_KMAP_BEGIN		0
-#define FIX_KMAP_END		(FIXADDR_SIZE >> PAGE_SHIFT)
+#define FIX_KMAP_NR_PTES	(FIXADDR_SIZE >> PAGE_SHIFT)
 
 #define __fix_to_virt(x)	(FIXADDR_START + ((x) << PAGE_SHIFT))
 #define __virt_to_fix(x)	(((x) - FIXADDR_START) >> PAGE_SHIFT)
@@ -27,7 +26,7 @@ extern void __this_fixmap_does_not_exist(void);
 
 static inline unsigned long fix_to_virt(const unsigned int idx)
 {
-	if (idx >= FIX_KMAP_END)
+	if (idx >= FIX_KMAP_NR_PTES)
 		__this_fixmap_does_not_exist();
 	return __fix_to_virt(idx);
 }
diff --git a/arch/arm/mm/highmem.c b/arch/arm/mm/highmem.c
index 21b9e1b..e05e8ad 100644
--- a/arch/arm/mm/highmem.c
+++ b/arch/arm/mm/highmem.c
@@ -63,7 +63,7 @@ void *kmap_atomic(struct page *page)
 	type = kmap_atomic_idx_push();
 
 	idx = type + KM_TYPE_NR * smp_processor_id();
-	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
+	vaddr = __fix_to_virt(idx);
 #ifdef CONFIG_DEBUG_HIGHMEM
 	/*
 	 * With debugging enabled, kunmap_atomic forces that entry to 0.
@@ -94,7 +94,7 @@ void __kunmap_atomic(void *kvaddr)
 		if (cache_is_vivt())
 			__cpuc_flush_dcache_area((void *)vaddr, PAGE_SIZE);
 #ifdef CONFIG_DEBUG_HIGHMEM
-		BUG_ON(vaddr != __fix_to_virt(FIX_KMAP_BEGIN + idx));
+		BUG_ON(vaddr != __fix_to_virt(idx));
 		set_top_pte(vaddr, __pte(0));
 #else
 		(void) idx;  /* to kill a warning */
@@ -117,7 +117,7 @@ void *kmap_atomic_pfn(unsigned long pfn)
 
 	type = kmap_atomic_idx_push();
 	idx = type + KM_TYPE_NR * smp_processor_id();
-	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
+	vaddr = __fix_to_virt(idx);
 #ifdef CONFIG_DEBUG_HIGHMEM
 	BUG_ON(!pte_none(get_top_pte(vaddr)));
 #endif
-- 
1.9.0


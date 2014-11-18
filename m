Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353AbaKRQsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:48:32 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:52608 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509AbaKRQsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:48:30 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-66-546b785c599e
Subject: [PATCH] ARM: fix overflow of vmalloc_limit in sanity_check_meminfo
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 18 Nov 2014 19:48:27 +0400
Message-id: <20141118164827.9686.68369.stgit@buzz>
User-Agent: StGit/0.17.1-dirty
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpiluLIzCtJLcpLzFFi42I5/e/4Vd2YiuwQg555whY/dvayWmx6fI3V
	4vKuOWwWty/zOrB4tDT3sHlsXlLv0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBnze/vZC/5x
	VFyeeIC9gXE3excjJ4eEgInEhiu7WCBsMYkL99azdTFycQgJLGWUOLP8NCuE08gkcXfPebAq
	YQFviW1zz7GC2GwCZhLb9t1mBLFFBPIlvh7YwwZiswioSnzd+ReshlfASGLpu7lgcVEBOYmV
	l1ug4oISPybfA5rJwcEsoC4xZUouSJhZQF5i85q3zBMYeWchqZqFUDULSdUCRuZVjKKppckF
	xUnpuUZ6xYm5xaV56XrJ+bmbGCHh9nUH49JjVocYBTgYlXh4GzZmhQixJpYVV+YeYpTgYFYS
	4T3XDRTiTUmsrEotyo8vKs1JLT7EyMTBKdXAeLH17IzYVzIlEh3GS3b/+eWl8GDLRuNekU3n
	P9h1iqat4LRO3ri/1tQvMiZBtoXp051yab+aap0tFaHTO5Ik6xmeWdzuu9hcKmqq//3dxRUn
	D8aGbrn0a0bxuT+Pe87vMn1U3z/Z+1hO5p+wl3/U20IF91Sk/dvblPtv39ScWC53r40V6/Nv
	K7EUZyQaajEXFScCAH29y0oVAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vmalloc_limit easily overflows if CONFIG_VMSPLIT_1G=y and CONFIG_ARM_LPAE=n,
in this case whole memory turns into "highmem" and system cannot boot.
For example if PHYS_OFFSET=0x80000000 and PAGE_OFFSET=0x40000000 then
vmalloc_limit should be 0x1_2F800000, but value does not fit into variable.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
---
 arch/arm/mm/mmu.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 9f98cec..9d2cdda 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1075,10 +1075,14 @@ phys_addr_t arm_lowmem_limit __initdata = 0;
 void __init sanity_check_meminfo(void)
 {
 	phys_addr_t memblock_limit = 0;
+	phys_addr_t vmalloc_limit = -1;
 	int highmem = 0;
-	phys_addr_t vmalloc_limit = __pa(vmalloc_min - 1) + 1;
 	struct memblock_region *reg;
 
+	if ((unsigned long)vmalloc_min - PAGE_OFFSET <
+			vmalloc_limit - PHYS_OFFSET)
+		vmalloc_limit = __pa(vmalloc_min - 1) + 1;
+
 	for_each_memblock(memory, reg) {
 		phys_addr_t block_start = reg->base;
 		phys_addr_t block_end = reg->base + reg->size;


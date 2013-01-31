Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab3AaV76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 16:59:58 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:44506 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756063Ab3AaV7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 16:59:06 -0500
From: Cyril Chemparathy <cyril@ti.com>
To: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <sboyd@codeaurora.org>, <will.deacon@arm.com>,
        <paulmck@linux.vnet.ibm.com>, <nico@linaro.org>,
        <catalin.marinas@arm.com>, <marc.zyngier@arm.com>,
        <linus.walleij@linaro.org>, Cyril Chemparathy <cyril@ti.com>,
        Vitaly Andrianov <vitalya@ti.com>
Subject: [PATCH v4 10/13] ARM: mm: use physical addresses in highmem sanity checks
Date: Thu, 31 Jan 2013 16:58:29 -0500
Message-ID: <1359669512-31276-11-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359669512-31276-1-git-send-email-cyril@ti.com>
References: <1359669512-31276-1-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the highmem sanity checking code to use physical addresses
instead.  This change eliminates the wrap-around problems associated with the
original virtual address based checks, and this simplifies the code a bit.

The one constraint imposed here is that low physical memory must be mapped in
a monotonically increasing fashion if there are multiple banks of memory,
i.e., x < y must => pa(x) < pa(y).

Signed-off-by: Cyril Chemparathy <cyril@ti.com>
Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
Acked-by: Nicolas Pitre <nico@linaro.org>
---
 arch/arm/mm/mmu.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index ef43689..e8875cb 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -929,6 +929,7 @@ phys_addr_t arm_lowmem_limit __initdata = 0;
 void __init sanity_check_meminfo(void)
 {
 	int i, j, highmem = 0;
+	phys_addr_t vmalloc_limit = __pa(vmalloc_min - 1) + 1;
 
 	for (i = 0, j = 0; i < meminfo.nr_banks; i++) {
 		struct membank *bank = &meminfo.bank[j];
@@ -938,8 +939,7 @@ void __init sanity_check_meminfo(void)
 			highmem = 1;
 
 #ifdef CONFIG_HIGHMEM
-		if (__va(bank->start) >= vmalloc_min ||
-		    __va(bank->start) < (void *)PAGE_OFFSET)
+		if (bank->start >= vmalloc_limit)
 			highmem = 1;
 
 		bank->highmem = highmem;
@@ -948,8 +948,8 @@ void __init sanity_check_meminfo(void)
 		 * Split those memory banks which are partially overlapping
 		 * the vmalloc area greatly simplifying things later.
 		 */
-		if (!highmem && __va(bank->start) < vmalloc_min &&
-		    bank->size > vmalloc_min - __va(bank->start)) {
+		if (!highmem && bank->start < vmalloc_limit &&
+		    bank->size > vmalloc_limit - bank->start) {
 			if (meminfo.nr_banks >= NR_BANKS) {
 				printk(KERN_CRIT "NR_BANKS too low, "
 						 "ignoring high memory\n");
@@ -958,12 +958,12 @@ void __init sanity_check_meminfo(void)
 					(meminfo.nr_banks - i) * sizeof(*bank));
 				meminfo.nr_banks++;
 				i++;
-				bank[1].size -= vmalloc_min - __va(bank->start);
-				bank[1].start = __pa(vmalloc_min - 1) + 1;
+				bank[1].size -= vmalloc_limit - bank->start;
+				bank[1].start = vmalloc_limit;
 				bank[1].highmem = highmem = 1;
 				j++;
 			}
-			bank->size = vmalloc_min - __va(bank->start);
+			bank->size = vmalloc_limit - bank->start;
 		}
 #else
 		bank->highmem = highmem;
@@ -983,8 +983,7 @@ void __init sanity_check_meminfo(void)
 		 * Check whether this memory bank would entirely overlap
 		 * the vmalloc area.
 		 */
-		if (__va(bank->start) >= vmalloc_min ||
-		    __va(bank->start) < (void *)PAGE_OFFSET) {
+		if (bank->start >= vmalloc_limit) {
 			printk(KERN_NOTICE "Ignoring RAM at %.8llx-%.8llx "
 			       "(vmalloc region overlap).\n",
 			       (unsigned long long)bank->start,
@@ -996,9 +995,8 @@ void __init sanity_check_meminfo(void)
 		 * Check whether this memory bank would partially overlap
 		 * the vmalloc area.
 		 */
-		if (__va(bank->start + bank->size - 1) >= vmalloc_min ||
-		    __va(bank->start + bank->size - 1) <= __va(bank->start)) {
-			unsigned long newsize = vmalloc_min - __va(bank->start);
+		if (bank->start + bank->size > vmalloc_limit)
+			unsigned long newsize = vmalloc_limit - bank->start;
 			printk(KERN_NOTICE "Truncating RAM at %.8llx-%.8llx "
 			       "to -%.8llx (vmalloc region overlap).\n",
 			       (unsigned long long)bank->start,
-- 
1.7.9.5


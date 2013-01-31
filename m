Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab3AaWCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:02:33 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:44500 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755954Ab3AaV7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 16:59:02 -0500
From: Cyril Chemparathy <cyril@ti.com>
To: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <sboyd@codeaurora.org>, <will.deacon@arm.com>,
        <paulmck@linux.vnet.ibm.com>, <nico@linaro.org>,
        <catalin.marinas@arm.com>, <marc.zyngier@arm.com>,
        <linus.walleij@linaro.org>, Cyril Chemparathy <cyril@ti.com>,
        Vitaly Andrianov <vitalya@ti.com>
Subject: [PATCH v4 12/13] ARM: mm: clean up membank size limit checks
Date: Thu, 31 Jan 2013 16:58:31 -0500
Message-ID: <1359669512-31276-13-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359669512-31276-1-git-send-email-cyril@ti.com>
References: <1359669512-31276-1-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up the highmem sanity check code by simplifying the range
checks with a pre-calculated size_limit.  This patch should otherwise have no
functional impact on behavior.

This patch also removes a redundant (bank->start < vmalloc_limit) check, since
this is already covered by the !highmem condition.

Signed-off-by: Cyril Chemparathy <cyril@ti.com>
Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
Acked-by: Nicolas Pitre <nico@linaro.org>
---
 arch/arm/mm/mmu.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 85ed732..2a02ff0 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -933,10 +933,15 @@ void __init sanity_check_meminfo(void)
 
 	for (i = 0, j = 0; i < meminfo.nr_banks; i++) {
 		struct membank *bank = &meminfo.bank[j];
+		phys_addr_t size_limit;
+
 		*bank = meminfo.bank[i];
+		size_limit = bank->size;
 
 		if (bank->start >= vmalloc_limit)
 			highmem = 1;
+		else
+			size_limit = vmalloc_limit - bank->start;
 
 		bank->highmem = highmem;
 
@@ -945,8 +950,7 @@ void __init sanity_check_meminfo(void)
 		 * Split those memory banks which are partially overlapping
 		 * the vmalloc area greatly simplifying things later.
 		 */
-		if (!highmem && bank->start < vmalloc_limit &&
-		    bank->size > vmalloc_limit - bank->start) {
+		if (!highmem && bank->size > size_limit) {
 			if (meminfo.nr_banks >= NR_BANKS) {
 				printk(KERN_CRIT "NR_BANKS too low, "
 						 "ignoring high memory\n");
@@ -955,12 +959,12 @@ void __init sanity_check_meminfo(void)
 					(meminfo.nr_banks - i) * sizeof(*bank));
 				meminfo.nr_banks++;
 				i++;
-				bank[1].size -= vmalloc_limit - bank->start;
+				bank[1].size -= size_limit;
 				bank[1].start = vmalloc_limit;
 				bank[1].highmem = highmem = 1;
 				j++;
 			}
-			bank->size = vmalloc_limit - bank->start;
+			bank->size = size_limit;
 		}
 #else
 		/*
@@ -978,14 +982,13 @@ void __init sanity_check_meminfo(void)
 		 * Check whether this memory bank would partially overlap
 		 * the vmalloc area.
 		 */
-		if (bank->start + bank->size > vmalloc_limit)
-			unsigned long newsize = vmalloc_limit - bank->start;
+		if (bank->size > size_limit) {
 			printk(KERN_NOTICE "Truncating RAM at %.8llx-%.8llx "
 			       "to -%.8llx (vmalloc region overlap).\n",
 			       (unsigned long long)bank->start,
 			       (unsigned long long)bank->start + bank->size - 1,
-			       (unsigned long long)bank->start + newsize - 1);
-			bank->size = newsize;
+			       (unsigned long long)bank->start + size_limit - 1);
+			bank->size = size_limit;
 		}
 #endif
 		if (!bank->highmem && bank->start + bank->size > arm_lowmem_limit)
-- 
1.7.9.5


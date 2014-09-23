Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbaIWChE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:37:04 -0400
Received: from mail.kernel.org ([198.145.19.201]:37858 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbaIWChB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:37:01 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 16/45] xtensa: fix TLBTEMP_BASE_2 region handling in fast_second_level_miss
Date: Tue, 23 Sep 2014 10:31:18 +0800
Message-Id: <1411439507-30391-16-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Max Filippov <jcmvbkbc@gmail.com>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

commit 7128039fe2dd3d59da9e4ffa036f3aaa3ba87b9f upstream.

Current definition of TLBTEMP_BASE_2 is always 32K above the
TLBTEMP_BASE_1, whereas fast_second_level_miss handler for the TLBTEMP
region analyzes virtual address bit (PAGE_SHIFT + DCACHE_ALIAS_ORDER)
to determine TLBTEMP region where the fault happened. The size of the
TLBTEMP region is also checked incorrectly: not 64K, but twice data
cache way size (whicht may as well be less than the instruction cache
way size).

Fix TLBTEMP_BASE_2 to be TLBTEMP_BASE_1 + data cache way size.
Provide TLBTEMP_SIZE that is a greater of doubled data cache way size or
the instruction cache way size, and use it to determine if the second
level TLB miss occured in the TLBTEMP region.

Practical occurence of page faults in the TLBTEMP area is extremely
rare, this code can be tested by deletion of all w[di]tlb instructions
in the tlbtemp_mapping region.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 arch/xtensa/include/asm/pgtable.h |    7 ++++++-
 arch/xtensa/kernel/entry.S        |    2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/xtensa/include/asm/pgtable.h b/arch/xtensa/include/asm/pgtable.h
index b03c043..7eeaf22 100644
--- a/arch/xtensa/include/asm/pgtable.h
+++ b/arch/xtensa/include/asm/pgtable.h
@@ -68,7 +68,12 @@
 #define VMALLOC_START		0xC0000000
 #define VMALLOC_END		0xC7FEFFFF
 #define TLBTEMP_BASE_1		0xC7FF0000
-#define TLBTEMP_BASE_2		0xC7FF8000
+#define TLBTEMP_BASE_2		(TLBTEMP_BASE_1 + DCACHE_WAY_SIZE)
+#if 2 * DCACHE_WAY_SIZE > ICACHE_WAY_SIZE
+#define TLBTEMP_SIZE		(2 * DCACHE_WAY_SIZE)
+#else
+#define TLBTEMP_SIZE		ICACHE_WAY_SIZE
+#endif
 
 /*
  * Xtensa Linux config PTE layout (when present):
diff --git a/arch/xtensa/kernel/entry.S b/arch/xtensa/kernel/entry.S
index 6223f33..bc9f78e 100644
--- a/arch/xtensa/kernel/entry.S
+++ b/arch/xtensa/kernel/entry.S
@@ -1629,7 +1629,7 @@ ENTRY(fast_second_level_miss)
 	rsr	a0, EXCVADDR
 	bltu	a0, a3, 2f
 
-	addi	a1, a0, -(2 << (DCACHE_ALIAS_ORDER + PAGE_SHIFT))
+	addi	a1, a0, -TLBTEMP_SIZE
 	bgeu	a1, a3, 2f
 
 	/* Check if we have to restore an ITLB mapping. */
-- 
1.7.9.5


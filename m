Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbaI3Vik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:38:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32841 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbaI3Vih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:38:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Max Filippov <jcmvbkbc@gmail.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 042/103] xtensa: fix TLBTEMP_BASE_2 region handling in fast_second_level_miss
Date: Tue, 30 Sep 2014 14:30:47 -0700
Message-Id: <1412112708-27356-43-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Filippov <jcmvbkbc@gmail.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/xtensa/include/asm/pgtable.h | 7 ++++++-
 arch/xtensa/kernel/entry.S        | 2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/xtensa/include/asm/pgtable.h b/arch/xtensa/include/asm/pgtable.h
index 2164462..51230ba 100644
--- a/arch/xtensa/include/asm/pgtable.h
+++ b/arch/xtensa/include/asm/pgtable.h
@@ -67,7 +67,12 @@
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
  * For the Xtensa architecture, the PTE layout is as follows:
diff --git a/arch/xtensa/kernel/entry.S b/arch/xtensa/kernel/entry.S
index b1444f9..6ac5055 100644
--- a/arch/xtensa/kernel/entry.S
+++ b/arch/xtensa/kernel/entry.S
@@ -1600,7 +1600,7 @@ ENTRY(fast_second_level_miss)
 	rsr	a0, excvaddr
 	bltu	a0, a3, 2f
 
-	addi	a1, a0, -(2 << (DCACHE_ALIAS_ORDER + PAGE_SHIFT))
+	addi	a1, a0, -TLBTEMP_SIZE
 	bgeu	a1, a3, 2f
 
 	/* Check if we have to restore an ITLB mapping. */
-- 
1.9.1


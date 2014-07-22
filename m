Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbaGVTDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 15:03:32 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:56379 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbaGVTB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 15:01:28 -0400
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-xtensa@linux-xtensa.org
Cc: Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        linux-kernel@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH 3/8] xtensa: fix TLBTEMP_BASE_2 region handling in fast_second_level_miss
Date: Tue, 22 Jul 2014 23:01:08 +0400
Message-Id: <1406055673-10100-4-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1406055673-10100-1-git-send-email-jcmvbkbc@gmail.com>
References: <1406055673-10100-1-git-send-email-jcmvbkbc@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Cc: stable@vger.kernel.org
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 arch/xtensa/include/asm/pgtable.h | 7 ++++++-
 arch/xtensa/kernel/entry.S        | 2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/xtensa/include/asm/pgtable.h b/arch/xtensa/include/asm/pgtable.h
index 4b0ca35..b2173e5 100644
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
index ef7f499..a5c586d 100644
--- a/arch/xtensa/kernel/entry.S
+++ b/arch/xtensa/kernel/entry.S
@@ -1565,7 +1565,7 @@ ENTRY(fast_second_level_miss)
 	rsr	a0, excvaddr
 	bltu	a0, a3, 2f
 
-	addi	a1, a0, -(2 << (DCACHE_ALIAS_ORDER + PAGE_SHIFT))
+	addi	a1, a0, -TLBTEMP_SIZE
 	bgeu	a1, a3, 2f
 
 	/* Check if we have to restore an ITLB mapping. */
-- 
1.8.1.4


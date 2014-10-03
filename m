Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341AbaJCW6y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:58:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47282 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576AbaJCWX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:23:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 3.10 037/143] xtensa: fix TLBTEMP_BASE_2 region handling in fast_second_level_miss
Date: Fri,  3 Oct 2014 14:33:52 -0700
Message-Id: <20141003213315.602656669@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/xtensa/include/asm/pgtable.h |    7 ++++++-
 arch/xtensa/kernel/entry.S        |    2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

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
--- a/arch/xtensa/kernel/entry.S
+++ b/arch/xtensa/kernel/entry.S
@@ -1703,7 +1703,7 @@ ENTRY(fast_second_level_miss)
 	rsr	a0, excvaddr
 	bltu	a0, a3, 2f
 
-	addi	a1, a0, -(2 << (DCACHE_ALIAS_ORDER + PAGE_SHIFT))
+	addi	a1, a0, -TLBTEMP_SIZE
 	bgeu	a1, a3, 2f
 
 	/* Check if we have to restore an ITLB mapping. */



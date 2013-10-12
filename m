Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab3JLWAP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 18:00:15 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49548 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448Ab3JLV75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 17:59:57 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <tj@kernel.org>, <yinghai@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <grygorii.strashko@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [RFC 07/23] mm/memblock: debug: correct displaying of upper memory boundary
Date: Sat, 12 Oct 2013 17:58:50 -0400
Message-ID: <1381615146-20342-8-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381615146-20342-1-git-send-email-santosh.shilimkar@ti.com>
References: <1381615146-20342-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

When debugging is enabled (cmdline has "memblock=debug") the memblock
will display upper memory boundary per each allocated/freed memory range
wrongly. For example:
 memblock_reserve: [0x0000009e7e8000-0x0000009e7ed000] _memblock_early_alloc_try_nid_nopanic+0xfc/0x12c

The 0x0000009e7ed000 is displayed instead of 0x0000009e7ecfff

Hence, correct this by changing formula used to calculate upper memory
boundary to (u64)base + size - 1 instead of  (u64)base + size everywhere
in the debug messages.

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 mm/memblock.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index c67f4bb..d903138 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -547,7 +547,7 @@ int __init_memblock memblock_free(phys_addr_t base, phys_addr_t size)
 {
 	memblock_dbg("   memblock_free: [%#016llx-%#016llx] %pF\n",
 		     (unsigned long long)base,
-		     (unsigned long long)base + size,
+		     (unsigned long long)base + size - 1,
 		     (void *)_RET_IP_);
 
 	return __memblock_remove(&memblock.reserved, base, size);
@@ -559,7 +559,7 @@ int __init_memblock memblock_reserve(phys_addr_t base, phys_addr_t size)
 
 	memblock_dbg("memblock_reserve: [%#016llx-%#016llx] %pF\n",
 		     (unsigned long long)base,
-		     (unsigned long long)base + size,
+		     (unsigned long long)base + size - 1,
 		     (void *)_RET_IP_);
 
 	return memblock_add_region(_rgn, base, size, MAX_NUMNODES);
@@ -914,7 +914,7 @@ void * __init memblock_early_alloc_try_nid(int nid,
 void __init __memblock_free_early(phys_addr_t base, phys_addr_t size)
 {
 	memblock_dbg("%s: [%#016llx-%#016llx] %pF\n",
-			__func__, (u64)base, (u64)base + size,
+			__func__, (u64)base, (u64)base + size - 1,
 			(void *)_RET_IP_);
 	kmemleak_free_part(__va(base), size);
 	__memblock_remove(&memblock.reserved, base, size);
@@ -925,7 +925,7 @@ void __init __memblock_free_late(phys_addr_t base, phys_addr_t size)
 	u64 cursor, end;
 
 	memblock_dbg("%s: [%#016llx-%#016llx] %pF\n",
-			__func__, (u64)base, (u64)base + size,
+			__func__, (u64)base, (u64)base + size - 1,
 			(void *)_RET_IP_);
 	kmemleak_free_part(__va(base), size);
 	cursor = PFN_UP(base);
-- 
1.7.9.5


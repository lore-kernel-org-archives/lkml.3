Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaANOO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 09:14:29 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53502 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbaANOOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 09:14:25 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>, Don Dutile <ddutile@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, iommu@lists.linux-foundation.org
Subject: [PATCH v2 4/5] memblock: introduce memblock_alloc_range()
Date: Tue, 14 Jan 2014 23:13:49 +0900
Message-Id: <1389708830-5841-5-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389708830-5841-1-git-send-email-akinobu.mita@gmail.com>
References: <1389708830-5841-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This introduces memblock_alloc_range() which allocates memblock from
the specified range of physical address.  I would like to use this
function to specify the location of CMA.

Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org
Cc: iommu@lists.linux-foundation.org
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
New patch from this version

 include/linux/memblock.h |  2 ++
 mm/memblock.c            | 27 ++++++++++++++++++++-------
 2 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 77c60e5..95e0cfa 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -176,6 +176,8 @@ static inline bool memblock_bottom_up(void) { return false; }
 #define MEMBLOCK_ALLOC_ANYWHERE	(~(phys_addr_t)0)
 #define MEMBLOCK_ALLOC_ACCESSIBLE	0
 
+phys_addr_t __init memblock_alloc_range(phys_addr_t size, phys_addr_t align,
+					phys_addr_t start, phys_addr_t end);
 phys_addr_t memblock_alloc_base(phys_addr_t size, phys_addr_t align,
 				phys_addr_t max_addr);
 phys_addr_t __memblock_alloc_base(phys_addr_t size, phys_addr_t align,
diff --git a/mm/memblock.c b/mm/memblock.c
index 53e477b..83b0542 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -864,25 +864,38 @@ int __init_memblock memblock_set_node(phys_addr_t base, phys_addr_t size,
 }
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
-static phys_addr_t __init memblock_alloc_base_nid(phys_addr_t size,
-					phys_addr_t align, phys_addr_t max_addr,
-					int nid)
+static phys_addr_t __init memblock_alloc_range_nid(phys_addr_t size,
+					phys_addr_t align, phys_addr_t start,
+					phys_addr_t end, int nid)
 {
 	phys_addr_t found;
 
 	if (WARN_ON(!align))
 		align = __alignof__(long long);
 
-	/* align @size to avoid excessive fragmentation on reserved array */
-	size = round_up(size, align);
-
-	found = memblock_find_in_range_node(0, max_addr, size, align, nid);
+	found = memblock_find_in_range_node(start, end, size, align, nid);
 	if (found && !memblock_reserve(found, size))
 		return found;
 
 	return 0;
 }
 
+phys_addr_t __init memblock_alloc_range(phys_addr_t size, phys_addr_t align,
+					phys_addr_t start, phys_addr_t end)
+{
+	return memblock_alloc_range_nid(size, align, start, end, MAX_NUMNODES);
+}
+
+static phys_addr_t __init memblock_alloc_base_nid(phys_addr_t size,
+					phys_addr_t align, phys_addr_t max_addr,
+					int nid)
+{
+	/* align @size to avoid excessive fragmentation on reserved array */
+	size = round_up(size, align);
+
+	return memblock_alloc_range_nid(size, align, 0, max_addr, nid);
+}
+
 phys_addr_t __init memblock_alloc_nid(phys_addr_t size, phys_addr_t align, int nid)
 {
 	return memblock_alloc_base_nid(size, align, MEMBLOCK_ALLOC_ACCESSIBLE, nid);
-- 
1.8.3.2


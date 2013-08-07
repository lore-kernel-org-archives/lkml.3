Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933346Ab3HGUlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:41:12 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:60715 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933232Ab3HGUlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:41:09 -0400
Message-ID: <201308072041.r77Kf8YG016132@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 7 Aug 2013 15:42:34 -0400
Subject: [PATCH] tile: avoid struct vm_struct leak
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If ioreamp_prot() fails in ioremap_page_range() due to kernel memory
exhaustion, we previously would leak a struct vm_struct.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/mm/pgtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/tile/mm/pgtable.c b/arch/tile/mm/pgtable.c
index dfd63ce..2bd572b 100644
--- a/arch/tile/mm/pgtable.c
+++ b/arch/tile/mm/pgtable.c
@@ -568,7 +568,7 @@ void __iomem *ioremap_prot(resource_size_t phys_addr, unsigned long size,
 	addr = area->addr;
 	if (ioremap_page_range((unsigned long)addr, (unsigned long)addr + size,
 			       phys_addr, pgprot)) {
-		remove_vm_area((void *)(PAGE_MASK & (unsigned long) addr));
+		free_vm_area(area);
 		return NULL;
 	}
 	return (__force void __iomem *) (offset + (char *)addr);
-- 
1.8.3.1


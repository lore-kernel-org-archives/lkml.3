Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab3HEUmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:42:39 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:50969 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab3HEUmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:42:37 -0400
Message-ID: <e616aa52bf39517b14dd2000d65ace7a0ac54d97.1375733180.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1375733180.git.cmetcalf@tilera.com>
References: <cover.1375733180.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 5 Aug 2013 16:06:20 -0400
Subject: [PATCH 02/20] tile PCI RC: tilepro conflict with PCI and RAM addresses
To: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a bug in the tilepro PCI resource allocation code that could make
the bootmem allocator unhappy if 4GB is installed on mshim 0.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/setup.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index 68b5426..676e155 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -614,11 +614,12 @@ static void __init setup_bootmem_allocator_node(int i)
 	/*
 	 * Throw away any memory aliased by the PCI region.
 	 */
-	if (pci_reserve_start_pfn < end && pci_reserve_end_pfn > start)
-		reserve_bootmem(PFN_PHYS(pci_reserve_start_pfn),
-				PFN_PHYS(pci_reserve_end_pfn -
-					 pci_reserve_start_pfn),
+	if (pci_reserve_start_pfn < end && pci_reserve_end_pfn > start) {
+		start = max(pci_reserve_start_pfn, start);
+		end = min(pci_reserve_end_pfn, end);
+		reserve_bootmem(PFN_PHYS(start), PFN_PHYS(end - start),
 				BOOTMEM_EXCLUSIVE);
+	}
 #endif
 }
 
-- 
1.8.3.1


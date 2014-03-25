Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbaCYKCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 06:02:50 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:56483
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751448AbaCYKCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 06:02:49 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchd2iz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh1155h)
From: Emil Medve <Emilian.Medve@Freescale.com>
To: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>, <torvalds@linux-foundation.org>
CC: Emil Medve <Emilian.Medve@Freescale.com>
Subject: [PATCH 2/3] memblock: Use for_each_memblock()
Date: Tue, 25 Mar 2014 04:31:04 -0500
Message-ID: <1395739864-19276-1-git-send-email-Emilian.Medve@Freescale.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Emil Medve <Emilian.Medve@Freescale.com>
---

This is a small cleanup

 mm/memblock.c   | 24 +++++++++++-------------
 mm/page_alloc.c | 10 +++++-----
 2 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 39a31e7..2b2aaf8 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1271,16 +1271,14 @@ phys_addr_t __init_memblock memblock_end_of_DRAM(void)
 
 void __init memblock_enforce_memory_limit(phys_addr_t limit)
 {
-	unsigned long i;
 	phys_addr_t max_addr = (phys_addr_t)ULLONG_MAX;
+	struct memblock_region *r;
 
 	if (!limit)
 		return;
 
 	/* find out max address */
-	for (i = 0; i < memblock.memory.cnt; i++) {
-		struct memblock_region *r = &memblock.memory.regions[i];
-
+	for_each_memblock(memory, r) {
 		if (limit <= r->size) {
 			max_addr = r->base + limit;
 			break;
@@ -1379,13 +1377,12 @@ int __init_memblock memblock_is_region_reserved(phys_addr_t base, phys_addr_t si
 
 void __init_memblock memblock_trim_memory(phys_addr_t align)
 {
-	int i;
 	phys_addr_t start, end, orig_start, orig_end;
-	struct memblock_type *mem = &memblock.memory;
+	struct memblock_region *r;
 
-	for (i = 0; i < mem->cnt; i++) {
-		orig_start = mem->regions[i].base;
-		orig_end = mem->regions[i].base + mem->regions[i].size;
+	for_each_memblock(memory, r) {
+		orig_start = r->base;
+		orig_end = r->base + r->size;
 		start = round_up(orig_start, align);
 		end = round_down(orig_end, align);
 
@@ -1393,11 +1390,12 @@ void __init_memblock memblock_trim_memory(phys_addr_t align)
 			continue;
 
 		if (start < end) {
-			mem->regions[i].base = start;
-			mem->regions[i].size = end - start;
+			r->base = start;
+			r->size = end - start;
 		} else {
-			memblock_remove_region(mem, i);
-			i--;
+			memblock_remove_region(&memblock.memory,
+					       r - memblock.memory.regions);
+			r--;
 		}
 	}
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e3758a0..b3727ef 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5050,7 +5050,7 @@ static void __init find_zone_movable_pfns_for_nodes(void)
 	nodemask_t saved_node_state = node_states[N_MEMORY];
 	unsigned long totalpages = early_calculate_totalpages();
 	int usable_nodes = nodes_weight(node_states[N_MEMORY]);
-	struct memblock_type *type = &memblock.memory;
+	struct memblock_region *r;
 
 	/* Need to find movable_zone earlier when movable_node is specified. */
 	find_usable_zone_for_movable();
@@ -5060,13 +5060,13 @@ static void __init find_zone_movable_pfns_for_nodes(void)
 	 * options.
 	 */
 	if (movable_node_is_enabled()) {
-		for (i = 0; i < type->cnt; i++) {
-			if (!memblock_is_hotpluggable(&type->regions[i]))
+		for_each_memblock(memory, r) {
+			if (!memblock_is_hotpluggable(r))
 				continue;
 
-			nid = type->regions[i].nid;
+			nid = r->nid;
 
-			usable_startpfn = PFN_DOWN(type->regions[i].base);
+			usable_startpfn = PFN_DOWN(r->base);
 			zone_movable_pfn[nid] = zone_movable_pfn[nid] ?
 				min(usable_startpfn, zone_movable_pfn[nid]) :
 				usable_startpfn;
-- 
1.9.1



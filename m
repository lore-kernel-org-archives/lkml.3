Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab3LFEi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 23:38:56 -0500
Received: from mail1.windriver.com ([147.11.146.13]:39908 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab3LFEix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 23:38:53 -0500
From: Lans Zhang <jia.zhang@windriver.com>
To: <andi@firstfloor.org>, <mingo@kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/mm/numa: fix becoming single node on numa machine with 32-bit kernel.
Date: Fri, 6 Dec 2013 12:18:30 +0800
Message-ID: <1386303510-18574-1-git-send-email-jia.zhang@windriver.com>
X-Mailer: git-send-email 1.7.8.110.g4cb5d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On numa machine, if a 32-bit kernel runs over it, node data cannot
be allocated from local node if the account of memory for node 0
covers the low memory space entirely:

[    0.000000] Initmem setup node 0 [mem 0x00000000-0x83fffffff]
[    0.000000]   NODE_DATA [mem 0x367ed000-0x367edfff]
[    0.000000] Initmem setup node 1 [mem 0x840000000-0xfffffffff]
[    0.000000] Cannot find 4096 bytes in node 1
[    0.000000] 64664MB HIGHMEM available.
[    0.000000] 871MB LOWMEM available.

To fix this issue, node data is allowed to be allocated from other
nodes if the memory of local node is still not mapped. The expected
result looks like this:

[    0.000000] Initmem setup node 0 [mem 0x00000000-0x83fffffff]
[    0.000000]   NODE_DATA [mem 0x367ed000-0x367edfff]
[    0.000000] Initmem setup node 1 [mem 0x840000000-0xfffffffff]
[    0.000000]   NODE_DATA [mem 0x367ec000-0x367ecfff]
[    0.000000]     NODE_DATA(1) on node 0
[    0.000000] 64664MB HIGHMEM available.
[    0.000000] 871MB LOWMEM available.

Signed-off-by: Lans Zhang <jia.zhang@windriver.com>
---
 arch/x86/mm/numa.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 24aec58..c85da7b 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -211,9 +211,13 @@ static void __init setup_node_data(int nid, u64 start, u64 end)
 	 */
 	nd_pa = memblock_alloc_nid(nd_size, SMP_CACHE_BYTES, nid);
 	if (!nd_pa) {
-		pr_err("Cannot find %zu bytes in node %d\n",
-		       nd_size, nid);
-		return;
+		nd_pa = __memblock_alloc_base(nd_size, SMP_CACHE_BYTES,
+					      MEMBLOCK_ALLOC_ACCESSIBLE);
+		if (!nd_pa) {
+			pr_err("Cannot find %zu bytes in node %d\n",
+			       nd_size, nid);
+			return;
+		}
 	}
 	nd = __va(nd_pa);
 
-- 
1.7.8.110.g4cb5d


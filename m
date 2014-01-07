Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbaAGPRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:17:10 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:36501 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaAGPRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:17:06 -0500
From: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
To: akpm@linux-foundation.org, jiang.liu@huawei.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, iamjoonsoo.kim@lge.com,
        hannes@cmpxchg.org, tangchen@cn.fujitsu.com, tj@kernel.org,
        toshi.kani@hp.com, Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Subject: [PATCH 1/2] mm, nobootmem: Add return value check in __alloc_memory_core_early()
Date: Tue,  7 Jan 2014 16:16:13 +0100
Message-Id: <1389107774-54978-2-git-send-email-phacht@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1389107774-54978-1-git-send-email-phacht@linux.vnet.ibm.com>
References: <1389107774-54978-1-git-send-email-phacht@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010715-0542-0000-0000-00000795F931
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When memblock_reserve() fails because memblock.reserved.regions cannot
be resized, the caller (e.g. alloc_bootmem()) is not informed of the
failed allocation. Therefore alloc_bootmem() silently returns the same
pointer again and again.
This patch adds a check for the return value of memblock_reserve() in
__alloc_memory_core().

Signed-off-by: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
---
 mm/nobootmem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index 2c254d3..3a7e14d 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -45,7 +45,9 @@ static void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
 	if (!addr)
 		return NULL;
 
-	memblock_reserve(addr, size);
+	if (memblock_reserve(addr, size))
+		return NULL;
+
 	ptr = phys_to_virt(addr);
 	memset(ptr, 0, size);
 	/*
-- 
1.8.4.5


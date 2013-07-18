Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934611Ab3GRWn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 18:43:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:22415 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933668Ab3GRWnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 18:43:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,697,1367996400"; 
   d="scan'208";a="372640283"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        h.mitake@gmail.com, kirill.shutemov@linux.intel.com
Subject: [PATCH] perf, tools, bench: Fix memcpy benchmark for large sizes v2
Date: Thu, 18 Jul 2013 15:43:18 -0700
Message-Id: <1374187398-14234-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

glibc calloc() has an optimization to not explicitely memset()
very large calloc allocations that just came from mmap(),
because they are known to be zero.

This could result in the perf memcpy benchmark reading only from
the zero page, which gives unrealistic results.

Always call memset explicitly on the source area to avoid this problem.

Cc: h.mitake@gmail.com
Cc: kirill.shutemov@linux.intel.com
v2: Actually memset the right area and also fix the NULL check before.
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/bench/mem-memcpy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index 93c83e3..0887b46 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -115,8 +115,10 @@ static void alloc_mem(void **dst, void **src, size_t length)
 		die("memory allocation failed - maybe length is too large?\n");
 
 	*src = zalloc(length);
-	if (!src)
+	if (!*src)
 		die("memory allocation failed - maybe length is too large?\n");
+	/* Make sure to always replace the zero pages even if MMAP_THRESH is crossed */
+	memset(*src, 0, length);
 }
 
 static u64 do_memcpy_cycle(memcpy_t fn, size_t len, bool prefault)
-- 
1.8.1.4


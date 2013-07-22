Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397Ab3GVUWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 16:22:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52072 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933339Ab3GVUWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 16:22:49 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Hitoshi Mitake <h.mitake@gmail.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/11] perf bench: Fix memcpy benchmark for large sizes
Date: Mon, 22 Jul 2013 17:22:31 -0300
Message-Id: <1374524559-9839-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374524559-9839-1-git-send-email-acme@infradead.org>
References: <1374524559-9839-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The glibc calloc() function has an optimization to not explicitely
memset() very large calloc allocations that just came from mmap(),
because they are known to be zero.

This could result in the perf memcpy benchmark reading only from
the zero page, which gives unrealistic results.

Always call memset explicitly on the source area to avoid this problem.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Hitoshi Mitake <h.mitake@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Link: http://lkml.kernel.org/n/tip-pzz2qrdq9eymxda0y8yxdn33@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bench/mem-memcpy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index 25fd3f1..8cdca43 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -117,6 +117,8 @@ static void alloc_mem(void **dst, void **src, size_t length)
 	*src = zalloc(length);
 	if (!*src)
 		die("memory allocation failed - maybe length is too large?\n");
+	/* Make sure to always replace the zero pages even if MMAP_THRESH is crossed */
+	memset(*src, 0, length);
 }
 
 static u64 do_memcpy_cycle(memcpy_t fn, size_t len, bool prefault)
-- 
1.8.1.4


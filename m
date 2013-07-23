Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab3GWHrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 03:47:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56197 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab3GWHrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 03:47:18 -0400
Date: Tue, 23 Jul 2013 00:47:00 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-pzz2qrdq9eymxda0y8yxdn33@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, kirill.shutemov@linux.intel.com, h.mitake@gmail.com,
        ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, kirill.shutemov@linux.intel.com, h.mitake@gmail.com,
        ak@linux.intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf bench: Fix memcpy benchmark for large sizes
Git-Commit-ID: a198996c7afae0097c67a61851f19863e59697b2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 23 Jul 2013 00:47:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a198996c7afae0097c67a61851f19863e59697b2
Gitweb:     http://git.kernel.org/tip/a198996c7afae0097c67a61851f19863e59697b2
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Thu, 18 Jul 2013 15:33:46 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 22 Jul 2013 12:41:56 -0300

perf bench: Fix memcpy benchmark for large sizes

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

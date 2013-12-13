Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab3LMIxo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 03:53:44 -0500
Received: from mga11.intel.com ([192.55.52.93]:54371 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab3LMIxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 03:53:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,477,1384329600"; 
   d="scan'208";a="449437419"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/2] perf tools: Fix next_pow2_l()
Date: Fri, 13 Dec 2013 10:53:35 +0200
Message-Id: <1386924816-24402-2-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386924816-24402-1-git-send-email-adrian.hunter@intel.com>
References: <1386924816-24402-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My implementation of next_pow2_l() was incorrect.
e.g.

  perf record -m4296015872 uname
  rounding mmap pages size to 17592186044416 bytes (4294967296 pages)
  Invalid argument for --mmap_pages/-m

Notice that the next power-of-2 value 4294967296 is
less than the option value 4296015872.

Change to using  __builtin_clzl() and prevent the
shift being equal to the width of the operand.
Also __builtin_clzl(x) is undefined if x is 0,
so adjust the condition to preclude that
possibility.  Now:

  perf record -m4296015872 uname
  rounding mmap pages size to 35184372088832 bytes (8589934592 pages)
  Invalid argument for --mmap_pages/-m

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/util.h | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index a1eea3e..ae609fe 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -284,13 +284,14 @@ static inline unsigned next_pow2(unsigned x)
 
 static inline unsigned long next_pow2_l(unsigned long x)
 {
-#if BITS_PER_LONG == 64
-	if (x <= (1UL << 31))
-		return next_pow2(x);
-	return (unsigned long)next_pow2(x >> 32) << 32;
-#else
-	return next_pow2(x);
-#endif
+	int leading_zeros;
+
+	if (x < 2)
+		return 1;
+	leading_zeros = __builtin_clzl(x - 1);
+	if (!leading_zeros)
+		return 0;
+	return 1UL << (BITS_PER_LONG - leading_zeros);
 }
 
 size_t hex_width(u64 v);
-- 
1.7.11.7


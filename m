Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbaGVN3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:29:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:45434 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020AbaGVNUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:20:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,710,1400050800"; 
   d="scan'208";a="576985815"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 23/52] perf tools: Move rdtsc() function
Date: Tue, 22 Jul 2014 16:17:32 +0300
Message-Id: <1406035081-14301-24-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the rdtsc() function so it can
be reusued.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/arch/x86/util/tsc.c      | 9 +++++++++
 tools/perf/tests/perf-time-to-tsc.c | 9 ---------
 tools/perf/util/tsc.c               | 5 +++++
 tools/perf/util/tsc.h               | 1 +
 4 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/tools/perf/arch/x86/util/tsc.c b/tools/perf/arch/x86/util/tsc.c
index 3655f24..fd28684 100644
--- a/tools/perf/arch/x86/util/tsc.c
+++ b/tools/perf/arch/x86/util/tsc.c
@@ -37,3 +37,12 @@ int perf_read_tsc_conversion(const struct perf_event_mmap_page *pc,
 
 	return 0;
 }
+
+u64 rdtsc(void)
+{
+	unsigned int low, high;
+
+	asm volatile("rdtsc" : "=a" (low), "=d" (high));
+
+	return low | ((u64)high) << 32;
+}
diff --git a/tools/perf/tests/perf-time-to-tsc.c b/tools/perf/tests/perf-time-to-tsc.c
index 0372f6e..f238442 100644
--- a/tools/perf/tests/perf-time-to-tsc.c
+++ b/tools/perf/tests/perf-time-to-tsc.c
@@ -25,15 +25,6 @@
 	}					\
 }
 
-static u64 rdtsc(void)
-{
-	unsigned int low, high;
-
-	asm volatile("rdtsc" : "=a" (low), "=d" (high));
-
-	return low | ((u64)high) << 32;
-}
-
 /**
  * test__perf_time_to_tsc - test converting perf time to TSC.
  *
diff --git a/tools/perf/util/tsc.c b/tools/perf/util/tsc.c
index ef4749836..4d4210d 100644
--- a/tools/perf/util/tsc.c
+++ b/tools/perf/util/tsc.c
@@ -23,3 +23,8 @@ u64 tsc_to_perf_time(u64 cyc, struct perf_tsc_conversion *tc)
 	return tc->time_zero + quot * tc->time_mult +
 	       ((rem * tc->time_mult) >> tc->time_shift);
 }
+
+u64 __weak rdtsc(void)
+{
+	return 0;
+}
diff --git a/tools/perf/util/tsc.h b/tools/perf/util/tsc.h
index 4eca848..a8b78f1 100644
--- a/tools/perf/util/tsc.h
+++ b/tools/perf/util/tsc.h
@@ -7,5 +7,6 @@
 
 u64 perf_time_to_tsc(u64 ns, struct perf_tsc_conversion *tc);
 u64 tsc_to_perf_time(u64 cyc, struct perf_tsc_conversion *tc);
+u64 rdtsc(void);
 
 #endif
-- 
1.8.3.2


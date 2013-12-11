Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab3LKMv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:51:58 -0500
Received: from mga01.intel.com ([192.55.52.88]:42533 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401Ab3LKMkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:40:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="448280701"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v0 33/71] perf tools: Move rdtsc() function
Date: Wed, 11 Dec 2013 14:36:45 +0200
Message-Id: <1386765443-26966-34-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

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
index 831b6ed..e478f28 100644
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
index 9ba7d38..a5aebf9 100644
--- a/tools/perf/tests/perf-time-to-tsc.c
+++ b/tools/perf/tests/perf-time-to-tsc.c
@@ -26,15 +26,6 @@
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
index bc69d86..617debb 100644
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
index 5083766..181f778 100644
--- a/tools/perf/util/tsc.h
+++ b/tools/perf/util/tsc.h
@@ -7,5 +7,6 @@
 
 u64 perf_time_to_tsc(u64 ns, struct perf_tsc_conversion *tc);
 u64 tsc_to_perf_time(u64 cyc, struct perf_tsc_conversion *tc);
+u64 rdtsc(void);
 
 #endif
-- 
1.8.5.1


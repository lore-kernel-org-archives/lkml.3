Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760968AbaGYPiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:38:07 -0400
Received: from mail.kernel.org ([198.145.19.201]:35003 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbaGYPiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:38:00 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/27] perf tools: Move rdtsc() function
Date: Fri, 25 Jul 2014 12:36:52 -0300
Message-Id: <1406302629-11790-11-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406302629-11790-1-git-send-email-acme@kernel.org>
References: <1406302629-11790-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Move the rdtsc() function so it can be reusued.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406035081-14301-24-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/arch/x86/util/tsc.c      | 9 +++++++++
 tools/perf/tests/perf-time-to-tsc.c | 9 ---------
 tools/perf/util/tsc.c               | 5 +++++
 tools/perf/util/tsc.h               | 1 +
 4 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/tools/perf/arch/x86/util/tsc.c b/tools/perf/arch/x86/util/tsc.c
index 3655f24c3170..fd2868490d00 100644
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
index 0372f6edca20..f238442b238a 100644
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
index ef4749836ce9..4d4210d4e13d 100644
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
index 4eca84887c8a..a8b78f1b3243 100644
--- a/tools/perf/util/tsc.h
+++ b/tools/perf/util/tsc.h
@@ -7,5 +7,6 @@
 
 u64 perf_time_to_tsc(u64 ns, struct perf_tsc_conversion *tc);
 u64 tsc_to_perf_time(u64 cyc, struct perf_tsc_conversion *tc);
+u64 rdtsc(void);
 
 #endif
-- 
1.9.3


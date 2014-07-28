Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaG1IZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:25:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42529 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbaG1IZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:25:16 -0400
Date: Mon, 28 Jul 2014 01:23:56 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-a6a69db4b686e51045771945669bba6578af67c1@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1406035081-14301-24-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-24-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Move rdtsc() function
Git-Commit-ID: a6a69db4b686e51045771945669bba6578af67c1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a6a69db4b686e51045771945669bba6578af67c1
Gitweb:     http://git.kernel.org/tip/a6a69db4b686e51045771945669bba6578af67c1
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 22 Jul 2014 16:17:32 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Jul 2014 11:48:11 -0300

perf tools: Move rdtsc() function

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

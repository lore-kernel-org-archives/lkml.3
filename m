Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbaLHGvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 01:51:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34728 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbaLHGvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 01:51:07 -0500
Date: Sun, 7 Dec 2014 22:50:46 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-011dccbdd93b7022c5c67e7c55fa8b5030b5e03d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        namhyung@kernel.org, cjashfor@linux.vnet.ibm.com, dsahern@gmail.com,
        jolsa@kernel.org, fweisbec@gmail.com, mingo@kernel.org,
        ak@linux.intel.com, acme@redhat.com, paulus@samba.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, matt.fleming@intel.com
Reply-To: matt.fleming@intel.com, tglx@linutronix.de, a.p.zijlstra@chello.nl,
        acme@redhat.com, paulus@samba.org, ak@linux.intel.com,
        mingo@kernel.org, fweisbec@gmail.com, jolsa@kernel.org,
        dsahern@gmail.com, cjashfor@linux.vnet.ibm.com, hpa@zytor.com,
        namhyung@kernel.org, eranian@google.com, linux-kernel@vger.kernel.org
In-Reply-To: <1416562275-12404-4-git-send-email-jolsa@kernel.org>
References: <1416562275-12404-4-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel:
  Introduce perf_evsel__read_cb function
Git-Commit-ID: 011dccbdd93b7022c5c67e7c55fa8b5030b5e03d
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

Commit-ID:  011dccbdd93b7022c5c67e7c55fa8b5030b5e03d
Gitweb:     http://git.kernel.org/tip/011dccbdd93b7022c5c67e7c55fa8b5030b5e03d
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Fri, 21 Nov 2014 10:31:07 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Nov 2014 18:03:50 -0300

perf evsel: Introduce perf_evsel__read_cb function

Adding perf_evsel__read_cb read function that retuns count values via
callback. It will be used later in stat command as single way to
retrieve counter values.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1416562275-12404-4-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 16 ++++++++++++++++
 tools/perf/util/evsel.h |  7 +++++++
 2 files changed, 23 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 6dc7a67..2d26b7a 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -917,6 +917,22 @@ void perf_counts_values__scale(struct perf_counts_values *count,
 		*pscaled = scaled;
 }
 
+int perf_evsel__read_cb(struct perf_evsel *evsel, int cpu, int thread,
+			perf_evsel__read_cb_t cb)
+{
+	struct perf_counts_values count;
+
+	memset(&count, 0, sizeof(count));
+
+	if (FD(evsel, cpu, thread) < 0)
+		return -EINVAL;
+
+	if (readn(FD(evsel, cpu, thread), &count, sizeof(count)) < 0)
+		return -errno;
+
+	return cb(evsel, cpu, thread, &count);
+}
+
 int __perf_evsel__read_on_cpu(struct perf_evsel *evsel,
 			      int cpu, int thread, bool scale)
 {
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 7af0377..5c93bed 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -233,6 +233,13 @@ static inline bool perf_evsel__match2(struct perf_evsel *e1,
 	 (a)->attr.type == (b)->attr.type &&	\
 	 (a)->attr.config == (b)->attr.config)
 
+typedef int (perf_evsel__read_cb_t)(struct perf_evsel *evsel,
+				    int cpu, int thread,
+				    struct perf_counts_values *count);
+
+int perf_evsel__read_cb(struct perf_evsel *evsel, int cpu, int thread,
+			perf_evsel__read_cb_t cb);
+
 int __perf_evsel__read_on_cpu(struct perf_evsel *evsel,
 			      int cpu, int thread, bool scale);
 

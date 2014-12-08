Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbaLHGwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 01:52:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34803 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbaLHGwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 01:52:07 -0500
Date: Sun, 7 Dec 2014 22:51:47 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-9bf1a52914c7e810091f7726790fc42242a2dafe@git.kernel.org>
Cc: jolsa@kernel.org, acme@redhat.com, namhyung@kernel.org, hpa@zytor.com,
        paulus@samba.org, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, matt.fleming@intel.com,
        dsahern@gmail.com, fweisbec@gmail.com, eranian@google.com,
        cjashfor@linux.vnet.ibm.com, mingo@kernel.org
Reply-To: tglx@linutronix.de, a.p.zijlstra@chello.nl, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        namhyung@kernel.org, acme@redhat.com, jolsa@kernel.org,
        mingo@kernel.org, cjashfor@linux.vnet.ibm.com, eranian@google.com,
        fweisbec@gmail.com, dsahern@gmail.com, matt.fleming@intel.com
In-Reply-To: <1416562275-12404-6-git-send-email-jolsa@kernel.org>
References: <1416562275-12404-6-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat:
  Make read_counter work over the thread dimension
Git-Commit-ID: 9bf1a52914c7e810091f7726790fc42242a2dafe
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

Commit-ID:  9bf1a52914c7e810091f7726790fc42242a2dafe
Gitweb:     http://git.kernel.org/tip/9bf1a52914c7e810091f7726790fc42242a2dafe
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Fri, 21 Nov 2014 10:31:09 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 1 Dec 2014 20:00:30 -0300

perf stat: Make read_counter work over the thread dimension

The read function will be used later for both aggr and cpu counters, so
we need to make it work over threads as well.

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
Link: http://lkml.kernel.org/r/1416562275-12404-6-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 9cc0db1..2511d3a 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -444,11 +444,18 @@ static int read_counter_aggr(struct perf_evsel *counter)
  */
 static int read_counter(struct perf_evsel *counter)
 {
-	int cpu;
+	int nthreads = thread_map__nr(evsel_list->threads);
+	int ncpus = perf_evsel__nr_cpus(counter);
+	int cpu, thread;
 
-	for (cpu = 0; cpu < perf_evsel__nr_cpus(counter); cpu++) {
-		if (perf_evsel__read_cb(counter, cpu, 0, read_cb))
-			return -1;
+	if (counter->system_wide)
+		nthreads = 1;
+
+	for (thread = 0; thread < nthreads; thread++) {
+		for (cpu = 0; cpu < ncpus; cpu++) {
+			if (perf_evsel__read_cb(counter, cpu, thread, read_cb))
+				return -1;
+		}
 	}
 
 	return 0;

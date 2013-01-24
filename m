Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab3AXTEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 14:04:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33171 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab3AXTEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:04:39 -0500
Date: Thu, 24 Jan 2013 11:04:10 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-1z4xcmbud30lamklfe80oopu@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel:
  Introduce method to request IDs be used
Git-Commit-ID: 7a5a5ca5fe3df8636c96b49591c23baf7c415dd4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 11:04:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7a5a5ca5fe3df8636c96b49591c23baf7c415dd4
Gitweb:     http://git.kernel.org/tip/7a5a5ca5fe3df8636c96b49591c23baf7c415dd4
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 10 Dec 2012 15:21:30 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 10 Dec 2012 15:21:30 -0300

perf evsel: Introduce method to request IDs be used

When mmaping multiple events we need to find the right evsel that
matches an event in the ring buffer.

For that we need to set the PERF_FORMAT_ID bit in
perf_event_attr.read_format so that when we read the event fds we get
that id to then hash it and be able later to use perf_evlist__id2evsel
to find the right evsel.

We also need to set the PERF_SAMPLE_ID bit in
perf_event_attr.sample_type to ask for that id to be stashed in each
sample, so that we can demux it.

So add a perf_evsel__set_sample_id() method to do those two things in
one operation.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-1z4xcmbud30lamklfe80oopu@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c      | 6 ++----
 tools/perf/tests/mmap-basic.c | 3 +--
 tools/perf/util/evsel.c       | 6 ++++++
 tools/perf/util/evsel.h       | 2 ++
 4 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 31a7c51..a306474 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -910,10 +910,8 @@ static void perf_top__start_counters(struct perf_top *top)
 			attr->sample_freq = top->freq;
 		}
 
-		if (evlist->nr_entries > 1) {
-			perf_evsel__set_sample_bit(counter, ID);
-			attr->read_format |= PERF_FORMAT_ID;
-		}
+		if (evlist->nr_entries > 1)
+			perf_evsel__set_sample_id(counter);
 
 		if (perf_target__has_cpu(&top->target))
 			perf_evsel__set_sample_bit(counter, CPU);
diff --git a/tools/perf/tests/mmap-basic.c b/tools/perf/tests/mmap-basic.c
index 4743b6d..cdd5075 100644
--- a/tools/perf/tests/mmap-basic.c
+++ b/tools/perf/tests/mmap-basic.c
@@ -70,8 +70,7 @@ int test__basic_mmap(void)
 		}
 
 		evsels[i]->attr.wakeup_events = 1;
-		evsels[i]->attr.read_format |= PERF_FORMAT_ID;
-		perf_evsel__set_sample_bit(evsels[i], ID);
+		perf_evsel__set_sample_id(evsels[i]);
 
 		perf_evlist__add(evlist, evsels[i]);
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index fc80f5a..9dde7e9 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -68,6 +68,12 @@ void __perf_evsel__reset_sample_bit(struct perf_evsel *evsel,
 	}
 }
 
+void perf_evsel__set_sample_id(struct perf_evsel *evsel)
+{
+	perf_evsel__set_sample_bit(evsel, ID);
+	evsel->attr.read_format |= PERF_FORMAT_ID;
+}
+
 void perf_evsel__init(struct perf_evsel *evsel,
 		      struct perf_event_attr *attr, int idx)
 {
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 7398539..5c08977 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -129,6 +129,8 @@ void __perf_evsel__reset_sample_bit(struct perf_evsel *evsel,
 #define perf_evsel__reset_sample_bit(evsel, bit) \
 	__perf_evsel__reset_sample_bit(evsel, PERF_SAMPLE_##bit)
 
+void perf_evsel__set_sample_id(struct perf_evsel *evsel);
+
 int perf_evsel__set_filter(struct perf_evsel *evsel, int ncpus, int nthreads,
 			   const char *filter);
 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab3LMPNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:13:21 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45297 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab3LMPMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:12:24 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/20] perf evlist: Add perf_evlist__to_front()
Date: Fri, 13 Dec 2013 12:11:53 -0300
Message-Id: <1386947526-7118-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386947526-7118-1-git-send-email-acme@infradead.org>
References: <1386947526-7118-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add a function to move a selected event to the
front of the list.

This is needed because it is not possible
to use the PERF_EVENT_IOC_SET_OUTPUT IOCTL
from an Instruction Tracing event to a
non-Instruction Tracing event.  Thus the
Instruction Tracing event must come first.

Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1386765443-26966-24-git-send-email-alexander.shishkin@linux.intel.com
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 17 +++++++++++++++++
 tools/perf/util/evlist.h |  3 +++
 2 files changed, 20 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 2eb7378e4c40..0b31cee34874 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1212,3 +1212,20 @@ int perf_evlist__strerror_open(struct perf_evlist *evlist __maybe_unused,
 
 	return 0;
 }
+
+void perf_evlist__to_front(struct perf_evlist *evlist,
+			   struct perf_evsel *move_evsel)
+{
+	struct perf_evsel *evsel, *n;
+	LIST_HEAD(move);
+
+	if (move_evsel == perf_evlist__first(evlist))
+		return;
+
+	list_for_each_entry_safe(evsel, n, &evlist->entries, node) {
+		if (evsel->leader == move_evsel->leader)
+			list_move_tail(&evsel->node, &move);
+	}
+
+	list_splice(&move, &evlist->entries);
+}
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 8a04aae95a18..9f64ede3ecbd 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -194,5 +194,8 @@ static inline void perf_mmap__write_tail(struct perf_mmap *md,
 }
 
 bool perf_evlist__can_select_event(struct perf_evlist *evlist, const char *str);
+void perf_evlist__to_front(struct perf_evlist *evlist,
+			   struct perf_evsel *move_evsel);
+
 
 #endif /* __PERF_EVLIST_H */
-- 
1.8.1.4


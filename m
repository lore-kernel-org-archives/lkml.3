Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073Ab3KLUsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 15:48:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41952 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125Ab3KLUqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 15:46:38 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/13] perf trace: Separate tp syscall field caching into init routine to be reused
Date: Tue, 12 Nov 2013 17:46:07 -0300
Message-Id: <1384289178-31374-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384289178-31374-1-git-send-email-acme@infradead.org>
References: <1384289178-31374-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

We need to set this in evsels coming out of a perf.data file header, not
just for new ones created for live sessions.

So separate the code that caches the syscall entry/exit tracepoint
format fields into a new function that will be used in the next
changeset.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/20131112115700.GC4053@ghostprotocols.net
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index aeb6296a76bd..3fa1dce6d43e 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -149,20 +149,32 @@ static void perf_evsel__delete_priv(struct perf_evsel *evsel)
 	perf_evsel__delete(evsel);
 }
 
+static int perf_evsel__init_syscall_tp(struct perf_evsel *evsel, void *handler)
+{
+	evsel->priv = malloc(sizeof(struct syscall_tp));
+	if (evsel->priv != NULL) {
+		if (perf_evsel__init_sc_tp_uint_field(evsel, id))
+			goto out_delete;
+
+		evsel->handler = handler;
+		return 0;
+	}
+
+	return -ENOMEM;
+
+out_delete:
+	free(evsel->priv);
+	evsel->priv = NULL;
+	return -ENOENT;
+}
+
 static struct perf_evsel *perf_evsel__syscall_newtp(const char *direction, void *handler)
 {
 	struct perf_evsel *evsel = perf_evsel__newtp("raw_syscalls", direction);
 
 	if (evsel) {
-		evsel->priv = malloc(sizeof(struct syscall_tp));
-
-		if (evsel->priv == NULL)
+		if (perf_evsel__init_syscall_tp(evsel, handler))
 			goto out_delete;
-
-		if (perf_evsel__init_sc_tp_uint_field(evsel, id))
-			goto out_delete;
-
-		evsel->handler = handler;
 	}
 
 	return evsel;
-- 
1.8.1.4


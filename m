Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab3IJSM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 14:12:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53805 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab3IJSMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 14:12:19 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/5] perf trace: Handle perf.data files with no tracepoints
Date: Tue, 10 Sep 2013 15:11:58 -0300
Message-Id: <1378836722-31326-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378836722-31326-1-git-send-email-acme@infradead.org>
References: <1378836722-31326-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Before:

  perf trace -i perf.data
  Segmentation fault (core dumped)
  #

After:

 # perf trace -i perf.data
 Data file does not have raw_syscalls:sys_enter events
 #

When there are no tracepoints in a perf.data file the struct pevent
that contains the list of tracepoints that will be used to lookup the
tracepoint id by name will not be populated, causing a NULL deref.

And we don't need to do all that dance to look at pevents for an entry
with a slighly different name to then lookup the tracepoint by its id on
the evlist, just use the perf_evlist__find_tracepoint_by_name() routine,
that will find the tracepoint, if present.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-egcm21k1e6gcyxpcgjxtmsq3@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 40 +++++++---------------------------------
 1 file changed, 7 insertions(+), 33 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 476caa1..0308d9e 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1620,52 +1620,26 @@ int __perf_session__set_tracepoints_handlers(struct perf_session *session,
 					     const struct perf_evsel_str_handler *assocs,
 					     size_t nr_assocs)
 {
-	struct perf_evlist *evlist = session->evlist;
-	struct event_format *format;
 	struct perf_evsel *evsel;
-	char *tracepoint, *name;
 	size_t i;
 	int err;
 
 	for (i = 0; i < nr_assocs; i++) {
-		err = -ENOMEM;
-		tracepoint = strdup(assocs[i].name);
-		if (tracepoint == NULL)
-			goto out;
-
-		err = -ENOENT;
-		name = strchr(tracepoint, ':');
-		if (name == NULL)
-			goto out_free;
-
-		*name++ = '\0';
-		format = pevent_find_event_by_name(session->pevent,
-						   tracepoint, name);
-		if (format == NULL) {
-			/*
-			 * Adding a handler for an event not in the session,
-			 * just ignore it.
-			 */
-			goto next;
-		}
-
-		evsel = perf_evlist__find_tracepoint_by_id(evlist, format->id);
+		/*
+		 * Adding a handler for an event not in the session,
+		 * just ignore it.
+		 */
+		evsel = perf_evlist__find_tracepoint_by_name(session->evlist, assocs[i].name);
 		if (evsel == NULL)
-			goto next;
+			continue;
 
 		err = -EEXIST;
 		if (evsel->handler.func != NULL)
-			goto out_free;
+			goto out;
 		evsel->handler.func = assocs[i].handler;
-next:
-		free(tracepoint);
 	}
 
 	err = 0;
 out:
 	return err;
-
-out_free:
-	free(tracepoint);
-	goto out;
 }
-- 
1.8.1.4


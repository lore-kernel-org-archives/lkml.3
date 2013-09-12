Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab3ILLLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 07:11:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34414 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab3ILLLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 07:11:21 -0400
Date: Thu, 12 Sep 2013 04:10:25 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-egcm21k1e6gcyxpcgjxtmsq3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf trace:
  Handle perf.data files with no tracepoints
Git-Commit-ID: ccf53eac2097fb47bc40875ffb22c2d10fa8c46c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 12 Sep 2013 04:10:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ccf53eac2097fb47bc40875ffb22c2d10fa8c46c
Gitweb:     http://git.kernel.org/tip/ccf53eac2097fb47bc40875ffb22c2d10fa8c46c
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 6 Sep 2013 15:19:01 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 9 Sep 2013 15:50:44 -0300

perf trace: Handle perf.data files with no tracepoints

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

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab3AXUKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:10:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50168 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906Ab3AXUIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:45 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 19/74] perf session: There is no need for a per session hists instance
Date: Thu, 24 Jan 2013 17:07:28 -0300
Message-Id: <1359058103-31645-20-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

It was being used just for its stats member, so ditch session->hists and
use just what is needed, session->stats.

This completes the move support multiple events in the hists layer, the
last user of session->hists was 'perf diff' but Jiri Olsa has fixed that
some time ago.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-pimk92kek8kcp4dmb1jakoro@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-sched.c |  6 +++---
 tools/perf/builtin-top.c   |  4 ++--
 tools/perf/util/hist.c     |  9 +++++++--
 tools/perf/util/hist.h     |  1 +
 tools/perf/util/session.c  | 41 ++++++++++++++++++++---------------------
 tools/perf/util/session.h  |  6 +-----
 6 files changed, 34 insertions(+), 33 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index cc28b85..1382294 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1475,9 +1475,9 @@ static int perf_sched__read_events(struct perf_sched *sched, bool destroy,
 			goto out_delete;
 		}
 
-		sched->nr_events      = session->hists.stats.nr_events[0];
-		sched->nr_lost_events = session->hists.stats.total_lost;
-		sched->nr_lost_chunks = session->hists.stats.nr_events[PERF_RECORD_LOST];
+		sched->nr_events      = session->stats.nr_events[0];
+		sched->nr_lost_events = session->stats.total_lost;
+		sched->nr_lost_chunks = session->stats.nr_events[PERF_RECORD_LOST];
 	}
 
 	if (destroy)
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index f5fd260..996b10c 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -728,7 +728,7 @@ static void perf_event__process_sample(struct perf_tool *tool,
 
 	if (!machine) {
 		pr_err("%u unprocessable samples recorded.\n",
-		       top->session->hists.stats.nr_unprocessable_samples++);
+		       top->session->stats.nr_unprocessable_samples++);
 		return;
 	}
 
@@ -878,7 +878,7 @@ static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
 			hists__inc_nr_events(&evsel->hists, event->header.type);
 			machine__process_event(machine, event);
 		} else
-			++session->hists.stats.nr_unknown_events;
+			++session->stats.nr_unknown_events;
 	}
 }
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 37179af..965ebf9 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -717,10 +717,15 @@ int hist_entry__annotate(struct hist_entry *he, size_t privsize)
 	return symbol__annotate(he->ms.sym, he->ms.map, privsize);
 }
 
+void events_stats__inc(struct events_stats *stats, u32 type)
+{
+	++stats->nr_events[0];
+	++stats->nr_events[type];
+}
+
 void hists__inc_nr_events(struct hists *hists, u32 type)
 {
-	++hists->stats.nr_events[0];
-	++hists->stats.nr_events[type];
+	events_stats__inc(&hists->stats, type);
 }
 
 static struct hist_entry *hists__add_dummy_entry(struct hists *hists,
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index cb6533b..3862468 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -98,6 +98,7 @@ void hists__output_recalc_col_len(struct hists *hists, int max_rows);
 
 void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h);
 void hists__inc_nr_events(struct hists *self, u32 type);
+void events_stats__inc(struct events_stats *stats, u32 type);
 size_t events_stats__fprintf(struct events_stats *stats, FILE *fp);
 
 size_t hists__fprintf(struct hists *self, bool show_header, int max_rows,
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 6e8dd2a..b0bcc32 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -133,7 +133,6 @@ struct perf_session *perf_session__new(const char *filename, int mode,
 	INIT_LIST_HEAD(&self->ordered_samples.sample_cache);
 	INIT_LIST_HEAD(&self->ordered_samples.to_free);
 	machine__init(&self->host_machine, "", HOST_KERNEL_ID);
-	hists__init(&self->hists);
 
 	if (mode == O_RDONLY) {
 		if (perf_session__open(self, force) < 0)
@@ -863,11 +862,11 @@ static int perf_session_deliver_event(struct perf_session *session,
 	case PERF_RECORD_SAMPLE:
 		dump_sample(evsel, event, sample);
 		if (evsel == NULL) {
-			++session->hists.stats.nr_unknown_id;
+			++session->stats.nr_unknown_id;
 			return 0;
 		}
 		if (machine == NULL) {
-			++session->hists.stats.nr_unprocessable_samples;
+			++session->stats.nr_unprocessable_samples;
 			return 0;
 		}
 		return tool->sample(tool, event, sample, evsel, machine);
@@ -881,7 +880,7 @@ static int perf_session_deliver_event(struct perf_session *session,
 		return tool->exit(tool, event, sample, machine);
 	case PERF_RECORD_LOST:
 		if (tool->lost == perf_event__process_lost)
-			session->hists.stats.total_lost += event->lost.lost;
+			session->stats.total_lost += event->lost.lost;
 		return tool->lost(tool, event, sample, machine);
 	case PERF_RECORD_READ:
 		return tool->read(tool, event, sample, evsel, machine);
@@ -890,7 +889,7 @@ static int perf_session_deliver_event(struct perf_session *session,
 	case PERF_RECORD_UNTHROTTLE:
 		return tool->unthrottle(tool, event, sample, machine);
 	default:
-		++session->hists.stats.nr_unknown_events;
+		++session->stats.nr_unknown_events;
 		return -1;
 	}
 }
@@ -904,8 +903,8 @@ static int perf_session__preprocess_sample(struct perf_session *session,
 
 	if (!ip_callchain__valid(sample->callchain, event)) {
 		pr_debug("call-chain problem with event, skipping it.\n");
-		++session->hists.stats.nr_invalid_chains;
-		session->hists.stats.total_invalid_chains += sample->period;
+		++session->stats.nr_invalid_chains;
+		session->stats.total_invalid_chains += sample->period;
 		return -EINVAL;
 	}
 	return 0;
@@ -963,7 +962,7 @@ static int perf_session__process_event(struct perf_session *session,
 	if (event->header.type >= PERF_RECORD_HEADER_MAX)
 		return -EINVAL;
 
-	hists__inc_nr_events(&session->hists, event->header.type);
+	events_stats__inc(&session->stats, event->header.type);
 
 	if (event->header.type >= PERF_RECORD_USER_TYPE_START)
 		return perf_session__process_user_event(session, event, tool, file_offset);
@@ -1018,39 +1017,39 @@ static void perf_session__warn_about_errors(const struct perf_session *session,
 					    const struct perf_tool *tool)
 {
 	if (tool->lost == perf_event__process_lost &&
-	    session->hists.stats.nr_events[PERF_RECORD_LOST] != 0) {
+	    session->stats.nr_events[PERF_RECORD_LOST] != 0) {
 		ui__warning("Processed %d events and lost %d chunks!\n\n"
 			    "Check IO/CPU overload!\n\n",
-			    session->hists.stats.nr_events[0],
-			    session->hists.stats.nr_events[PERF_RECORD_LOST]);
+			    session->stats.nr_events[0],
+			    session->stats.nr_events[PERF_RECORD_LOST]);
 	}
 
-	if (session->hists.stats.nr_unknown_events != 0) {
+	if (session->stats.nr_unknown_events != 0) {
 		ui__warning("Found %u unknown events!\n\n"
 			    "Is this an older tool processing a perf.data "
 			    "file generated by a more recent tool?\n\n"
 			    "If that is not the case, consider "
 			    "reporting to linux-kernel@vger.kernel.org.\n\n",
-			    session->hists.stats.nr_unknown_events);
+			    session->stats.nr_unknown_events);
 	}
 
-	if (session->hists.stats.nr_unknown_id != 0) {
+	if (session->stats.nr_unknown_id != 0) {
 		ui__warning("%u samples with id not present in the header\n",
-			    session->hists.stats.nr_unknown_id);
+			    session->stats.nr_unknown_id);
 	}
 
- 	if (session->hists.stats.nr_invalid_chains != 0) {
+ 	if (session->stats.nr_invalid_chains != 0) {
  		ui__warning("Found invalid callchains!\n\n"
  			    "%u out of %u events were discarded for this reason.\n\n"
  			    "Consider reporting to linux-kernel@vger.kernel.org.\n\n",
- 			    session->hists.stats.nr_invalid_chains,
- 			    session->hists.stats.nr_events[PERF_RECORD_SAMPLE]);
+ 			    session->stats.nr_invalid_chains,
+ 			    session->stats.nr_events[PERF_RECORD_SAMPLE]);
  	}
 
-	if (session->hists.stats.nr_unprocessable_samples != 0) {
+	if (session->stats.nr_unprocessable_samples != 0) {
 		ui__warning("%u unprocessable samples recorded.\n"
 			    "Do you have a KVM guest running and not using 'perf kvm'?\n",
-			    session->hists.stats.nr_unprocessable_samples);
+			    session->stats.nr_unprocessable_samples);
 	}
 }
 
@@ -1353,7 +1352,7 @@ size_t perf_session__fprintf_nr_events(struct perf_session *session, FILE *fp)
 	struct perf_evsel *pos;
 	size_t ret = fprintf(fp, "Aggregated stats:\n");
 
-	ret += events_stats__fprintf(&session->hists.stats, fp);
+	ret += events_stats__fprintf(&session->stats, fp);
 
 	list_for_each_entry(pos, &session->evlist->entries, node) {
 		ret += fprintf(fp, "%s stats:\n", perf_evsel__name(pos));
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 426ca0c..57066cb 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -34,11 +34,7 @@ struct perf_session {
 	struct rb_root		machines;
 	struct perf_evlist	*evlist;
 	struct pevent		*pevent;
-	/*
-	 * FIXME: Need to split this up further, we need global
-	 *	  stats + per event stats.
-	 */
-	struct hists		hists;
+	struct events_stats	stats;
 	int			fd;
 	bool			fd_pipe;
 	bool			repipe;
-- 
1.8.1.1.361.gec3ae6e


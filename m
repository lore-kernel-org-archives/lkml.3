Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbaLXHPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 02:15:46 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:40181 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbaLXHPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 02:15:40 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 24/37] perf session: Pass struct events stats to event processing functions
Date: Wed, 24 Dec 2014 16:15:20 +0900
Message-Id: <1419405333-27952-25-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass stats structure so that it can point separate object when used in
multi-thread environment.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/ordered-events.c |  4 +-
 tools/perf/util/session.c        | 87 +++++++++++++++++++++++-----------------
 tools/perf/util/session.h        |  1 +
 3 files changed, 54 insertions(+), 38 deletions(-)

diff --git a/tools/perf/util/ordered-events.c b/tools/perf/util/ordered-events.c
index fd4be94125fb..e933c51d7090 100644
--- a/tools/perf/util/ordered-events.c
+++ b/tools/perf/util/ordered-events.c
@@ -183,7 +183,9 @@ static int __ordered_events__flush(struct perf_session *s,
 		if (ret)
 			pr_err("Can't parse sample, err = %d\n", ret);
 		else {
-			ret = perf_session__deliver_event(s, iter->event, &sample, tool,
+			ret = perf_session__deliver_event(s, &s->stats,
+							  iter->event,
+							  &sample, tool,
 							  iter->file_offset);
 			if (ret)
 				return ret;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 4f0fcd2d3901..af2608e782ae 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -779,6 +779,7 @@ static struct machine *
 }
 
 static int deliver_sample_value(struct perf_session *session,
+				struct events_stats *stats,
 				struct perf_tool *tool,
 				union perf_event *event,
 				struct perf_sample *sample,
@@ -795,7 +796,7 @@ static int deliver_sample_value(struct perf_session *session,
 	}
 
 	if (!sid || sid->evsel == NULL) {
-		++session->stats.nr_unknown_id;
+		++stats->nr_unknown_id;
 		return 0;
 	}
 
@@ -803,6 +804,7 @@ static int deliver_sample_value(struct perf_session *session,
 }
 
 static int deliver_sample_group(struct perf_session *session,
+				struct events_stats *stats,
 				struct perf_tool *tool,
 				union  perf_event *event,
 				struct perf_sample *sample,
@@ -812,7 +814,7 @@ static int deliver_sample_group(struct perf_session *session,
 	u64 i;
 
 	for (i = 0; i < sample->read.group.nr; i++) {
-		ret = deliver_sample_value(session, tool, event, sample,
+		ret = deliver_sample_value(session, stats, tool, event, sample,
 					   &sample->read.group.values[i],
 					   machine);
 		if (ret)
@@ -824,6 +826,7 @@ static int deliver_sample_group(struct perf_session *session,
 
 static int
 perf_session__deliver_sample(struct perf_session *session,
+			     struct events_stats *stats,
 			     struct perf_tool *tool,
 			     union  perf_event *event,
 			     struct perf_sample *sample,
@@ -840,14 +843,15 @@ perf_session__deliver_sample(struct perf_session *session,
 
 	/* For PERF_SAMPLE_READ we have either single or group mode. */
 	if (read_format & PERF_FORMAT_GROUP)
-		return deliver_sample_group(session, tool, event, sample,
+		return deliver_sample_group(session, stats, tool, event, sample,
 					    machine);
 	else
-		return deliver_sample_value(session, tool, event, sample,
+		return deliver_sample_value(session, stats, tool, event, sample,
 					    &sample->read.one, machine);
 }
 
 int perf_session__deliver_event(struct perf_session *session,
+				struct events_stats *stats,
 				union perf_event *event,
 				struct perf_sample *sample,
 				struct perf_tool *tool, u64 file_offset)
@@ -866,14 +870,14 @@ int perf_session__deliver_event(struct perf_session *session,
 	case PERF_RECORD_SAMPLE:
 		dump_sample(evsel, event, sample);
 		if (evsel == NULL) {
-			++session->stats.nr_unknown_id;
+			++stats->nr_unknown_id;
 			return 0;
 		}
 		if (machine == NULL) {
-			++session->stats.nr_unprocessable_samples;
+			++stats->nr_unprocessable_samples;
 			return 0;
 		}
-		return perf_session__deliver_sample(session, tool, event,
+		return perf_session__deliver_sample(session, stats, tool, event,
 						    sample, evsel, machine);
 	case PERF_RECORD_MMAP:
 		return tool->mmap(tool, event, sample, machine);
@@ -887,7 +891,7 @@ int perf_session__deliver_event(struct perf_session *session,
 		return tool->exit(tool, event, sample, machine);
 	case PERF_RECORD_LOST:
 		if (tool->lost == perf_event__process_lost)
-			session->stats.total_lost += event->lost.lost;
+			stats->total_lost += event->lost.lost;
 		return tool->lost(tool, event, sample, machine);
 	case PERF_RECORD_READ:
 		return tool->read(tool, event, sample, evsel, machine);
@@ -896,7 +900,7 @@ int perf_session__deliver_event(struct perf_session *session,
 	case PERF_RECORD_UNTHROTTLE:
 		return tool->unthrottle(tool, event, sample, machine);
 	default:
-		++session->stats.nr_unknown_events;
+		++stats->nr_unknown_events;
 		return -1;
 	}
 }
@@ -951,7 +955,8 @@ int perf_session__deliver_synth_event(struct perf_session *session,
 	if (event->header.type >= PERF_RECORD_USER_TYPE_START)
 		return perf_session__process_user_event(session, event, tool, 0);
 
-	return perf_session__deliver_event(session, event, sample, tool, 0);
+	return perf_session__deliver_event(session, &session->stats,
+					   event, sample, tool, 0);
 }
 
 static void event_swap(union perf_event *event, bool sample_id_all)
@@ -1019,6 +1024,7 @@ int perf_session__peek_event(struct perf_session *session, off_t file_offset,
 }
 
 static s64 perf_session__process_event(struct perf_session *session,
+				       struct events_stats *stats,
 				       union perf_event *event,
 				       struct perf_tool *tool,
 				       u64 file_offset)
@@ -1032,7 +1038,7 @@ static s64 perf_session__process_event(struct perf_session *session,
 	if (event->header.type >= PERF_RECORD_HEADER_MAX)
 		return -EINVAL;
 
-	events_stats__inc(&session->stats, event->header.type);
+	events_stats__inc(stats, event->header.type);
 
 	if (event->header.type >= PERF_RECORD_USER_TYPE_START)
 		return perf_session__process_user_event(session, event, tool, file_offset);
@@ -1051,8 +1057,8 @@ static s64 perf_session__process_event(struct perf_session *session,
 			return ret;
 	}
 
-	return perf_session__deliver_event(session, event, &sample, tool,
-					   file_offset);
+	return perf_session__deliver_event(session, stats, event, &sample,
+					   tool, file_offset);
 }
 
 void perf_event_header__bswap(struct perf_event_header *hdr)
@@ -1080,43 +1086,43 @@ static struct thread *perf_session__register_idle_thread(struct perf_session *se
 	return thread;
 }
 
-static void perf_session__warn_about_errors(const struct perf_session *session,
+static void events_stats__warn_about_errors(const struct events_stats *stats,
 					    const struct perf_tool *tool)
 {
 	if (tool->lost == perf_event__process_lost &&
-	    session->stats.nr_events[PERF_RECORD_LOST] != 0) {
+	    stats->nr_events[PERF_RECORD_LOST] != 0) {
 		ui__warning("Processed %d events and lost %d chunks!\n\n"
 			    "Check IO/CPU overload!\n\n",
-			    session->stats.nr_events[0],
-			    session->stats.nr_events[PERF_RECORD_LOST]);
+			    stats->nr_events[0],
+			    stats->nr_events[PERF_RECORD_LOST]);
 	}
 
-	if (session->stats.nr_unknown_events != 0) {
+	if (stats->nr_unknown_events != 0) {
 		ui__warning("Found %u unknown events!\n\n"
 			    "Is this an older tool processing a perf.data "
 			    "file generated by a more recent tool?\n\n"
 			    "If that is not the case, consider "
 			    "reporting to linux-kernel@vger.kernel.org.\n\n",
-			    session->stats.nr_unknown_events);
+			    stats->nr_unknown_events);
 	}
 
-	if (session->stats.nr_unknown_id != 0) {
+	if (stats->nr_unknown_id != 0) {
 		ui__warning("%u samples with id not present in the header\n",
-			    session->stats.nr_unknown_id);
+			    stats->nr_unknown_id);
 	}
 
- 	if (session->stats.nr_invalid_chains != 0) {
+	if (stats->nr_invalid_chains != 0) {
  		ui__warning("Found invalid callchains!\n\n"
  			    "%u out of %u events were discarded for this reason.\n\n"
  			    "Consider reporting to linux-kernel@vger.kernel.org.\n\n",
- 			    session->stats.nr_invalid_chains,
- 			    session->stats.nr_events[PERF_RECORD_SAMPLE]);
+			    stats->nr_invalid_chains,
+			    stats->nr_events[PERF_RECORD_SAMPLE]);
  	}
 
-	if (session->stats.nr_unprocessable_samples != 0) {
+	if (stats->nr_unprocessable_samples != 0) {
 		ui__warning("%u unprocessable samples recorded.\n"
 			    "Do you have a KVM guest running and not using 'perf kvm'?\n",
-			    session->stats.nr_unprocessable_samples);
+			    stats->nr_unprocessable_samples);
 	}
 }
 
@@ -1188,7 +1194,8 @@ static int __perf_session__process_pipe_events(struct perf_session *session,
 		}
 	}
 
-	if ((skip = perf_session__process_event(session, event, tool, head)) < 0) {
+	if ((skip = perf_session__process_event(session, &session->stats,
+						event, tool, head)) < 0) {
 		pr_err("%#" PRIx64 " [%#x]: failed to process type: %d\n",
 		       head, event->header.size, event->header.type);
 		err = -EINVAL;
@@ -1207,7 +1214,7 @@ static int __perf_session__process_pipe_events(struct perf_session *session,
 	err = ordered_events__flush(session, tool, OE_FLUSH__FINAL);
 out_err:
 	free(buf);
-	perf_session__warn_about_errors(session, tool);
+	events_stats__warn_about_errors(&session->stats, tool);
 	ordered_events__free(&session->ordered_events);
 	return err;
 }
@@ -1252,7 +1259,8 @@ fetch_mmaped_event(struct perf_session *session,
 #define NUM_MMAPS 128
 #endif
 
-static int __perf_session__process_events(struct perf_session *session, int fd,
+static int __perf_session__process_events(struct perf_session *session,
+					  struct events_stats *stats, int fd,
 					  u64 data_offset, u64 data_size,
 					  u64 file_size, struct perf_tool *tool)
 {
@@ -1278,7 +1286,9 @@ static int __perf_session__process_events(struct perf_session *session, int fd,
 	mmap_size = MMAP_SIZE;
 	if (mmap_size > file_size) {
 		mmap_size = file_size;
-		session->one_mmap = true;
+
+		if (!session->file->is_multi)
+			session->one_mmap = true;
 	}
 
 	memset(mmaps, 0, sizeof(mmaps));
@@ -1323,8 +1333,8 @@ static int __perf_session__process_events(struct perf_session *session, int fd,
 	size = event->header.size;
 
 	if (size < sizeof(struct perf_event_header) ||
-	    (skip = perf_session__process_event(session, event, tool, file_pos))
-									< 0) {
+	    (skip = perf_session__process_event(session, stats, event,
+						tool, file_pos)) < 0) {
 		pr_err("%#" PRIx64 " [%#x]: failed to process type: %d\n",
 		       file_offset + head, event->header.size,
 		       event->header.type);
@@ -1351,7 +1361,6 @@ static int __perf_session__process_events(struct perf_session *session, int fd,
 	err = ordered_events__flush(session, tool, OE_FLUSH__FINAL);
 out_err:
 	ui_progress__finish();
-	perf_session__warn_about_errors(session, tool);
 	ordered_events__free(&session->ordered_events);
 	session->one_mmap = false;
 	return err;
@@ -1369,13 +1378,16 @@ int perf_session__process_events(struct perf_session *session,
 	if (perf_data_file__is_pipe(session->file))
 		return __perf_session__process_pipe_events(session, tool);
 
-	err = __perf_session__process_events(session,
+	err = __perf_session__process_events(session, &session->stats,
 					     perf_data_file__fd(session->file),
 					     session->header.data_offset,
 					     session->header.data_size,
 					     size, tool);
-	if (!session->file->is_multi || err)
+
+	if (!session->file->is_multi || err) {
+		events_stats__warn_about_errors(&session->stats, tool);
 		return err;
+	}
 
 	/*
 	 * For multi-file data storage, events are processed for each
@@ -1390,12 +1402,13 @@ int perf_session__process_events(struct perf_session *session,
 		if (size == 0)
 			continue;
 
-		err = __perf_session__process_events(session, fd,
-						     0, size, size, tool);
+		err = __perf_session__process_events(session, &session->stats,
+						     fd, 0, size, size, tool);
 		if (err < 0)
 			break;
 	}
 
+	events_stats__warn_about_errors(&session->stats, tool);
 	return err;
 }
 
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 6d663dc76404..8fc067d931cd 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -59,6 +59,7 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 void perf_tool__fill_defaults(struct perf_tool *tool);
 
 int perf_session__deliver_event(struct perf_session *session,
+				struct events_stats *stats,
 				union perf_event *event,
 				struct perf_sample *sample,
 				struct perf_tool *tool, u64 file_offset);
-- 
2.1.3


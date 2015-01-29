Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbbA2IMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:12:48 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51594 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbbA2IKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:10:20 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 35/42] perf record: Synthesize COMM event for a command line workload
Date: Thu, 29 Jan 2015 17:07:16 +0900
Message-Id: <1422518843-25818-36-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
References: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When perf creates a new child to profile, the events are enabled on
exec().  And in this case, it doesn't synthesize any event for the
child since they'll be generated during exec().  But there's an window
between the enabling and the event generation.

It used to be overcome since samples are only in kernel (so we always
have the map) and the comm is overridden by a later COMM event.
However it won't work anymore since those samples will go to a missing
thread now but the COMM event will create a (current) thread.  This
leads to those early samples (like native_write_msr_safe) not having a
comm but pid (like ':15328').

So it needs to synthesize COMM event for the child explicitly before
enabling so that it can have a correct comm.  But at this time, the
comm will be "perf" since it's not exec-ed yet.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-record.c | 18 +++++++++++++++++-
 tools/perf/util/event.c     |  8 ++++----
 tools/perf/util/event.h     |  5 +++++
 3 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 0db47c97446b..9500e350ca95 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -607,8 +607,24 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 	/*
 	 * Let the child rip
 	 */
-	if (forks)
+	if (forks) {
+		union perf_event *comm_event;
+
+		comm_event = malloc(sizeof(*comm_event) + machine->id_hdr_size);
+		if (comm_event == NULL)
+			goto out_child;
+
+		err = perf_event__synthesize_comm(tool, comm_event,
+						  rec->evlist->threads->map[0],
+						  process_synthesized_event,
+						  machine);
+		free(comm_event);
+
+		if (err < 0)
+			goto out_child;
+
 		perf_evlist__start_workload(rec->evlist);
+	}
 
 	if (opts->initial_delay) {
 		usleep(opts->initial_delay * 1000);
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index e7152a6e3043..49452852b103 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -96,10 +96,10 @@ static pid_t perf_event__get_comm_tgid(pid_t pid, char *comm, size_t len)
 	return tgid;
 }
 
-static pid_t perf_event__synthesize_comm(struct perf_tool *tool,
-					 union perf_event *event, pid_t pid,
-					 perf_event__handler_t process,
-					 struct machine *machine)
+pid_t perf_event__synthesize_comm(struct perf_tool *tool,
+				  union perf_event *event, pid_t pid,
+				  perf_event__handler_t process,
+				  struct machine *machine)
 {
 	size_t size;
 	pid_t tgid;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 1f86c279520e..6df23199fea0 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -386,6 +386,11 @@ int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 				       struct machine *machine,
 				       bool mmap_data);
 
+pid_t perf_event__synthesize_comm(struct perf_tool *tool,
+				  union perf_event *event, pid_t pid,
+				  perf_event__handler_t process,
+				  struct machine *machine);
+
 size_t perf_event__fprintf_comm(union perf_event *event, FILE *fp);
 size_t perf_event__fprintf_mmap(union perf_event *event, FILE *fp);
 size_t perf_event__fprintf_mmap2(union perf_event *event, FILE *fp);
-- 
2.2.2


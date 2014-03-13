Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbaCMVQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 17:16:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999AbaCMVQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 17:16:42 -0400
From: Don Zickus <dzickus@redhat.com>
To: acme@redhat.com
Cc: jolsa@redhat.com, jmario@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH] perf: Speed up thread map generation
Date: Thu, 13 Mar 2014 17:16:37 -0400
Message-Id: <1394745397-96149-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When trying to capture perf data on a system running spejbb2013,
perf hung for about 15 minutes.  This is because it took that
long to gather about 10,000 thread maps and process them.

I don't think a user wants to wait that long.

Instead, recognize that thread maps are roughly equivalent to
pid maps and just quickly copy those instead.

To do this, I synthesize 'fork' events, this eventually calls
thread__fork() and copies the maps over.

The overhead goes from 15 minutes down to about a few seconds.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/util/event.c |   39 ++++++++++++++++++++++++++++++++++++---
 1 files changed, 36 insertions(+), 3 deletions(-)

---
Based on perf/core: 1c075d114d0f3be

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 55eebe9..95e5649 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -129,6 +129,28 @@ out:
 	return tgid;
 }
 
+static int perf_event__synthesize_fork(struct perf_tool *tool,
+				       union perf_event *event, pid_t pid,
+				       pid_t tgid, perf_event__handler_t process,
+				       struct machine *machine)
+{
+	memset(&event->fork, 0, sizeof(event->fork) + machine->id_hdr_size);
+
+	/* this is really a clone event but we use fork to synthesize it */
+	event->fork.ppid = tgid;
+	event->fork.ptid = tgid;
+	event->fork.pid  = tgid;
+	event->fork.tid  = pid;
+	event->fork.header.type = PERF_RECORD_FORK;
+
+	event->fork.header.size = (sizeof(event->fork) + machine->id_hdr_size);
+
+	if (process(tool, event, &synth_sample, machine) != 0)
+		return -1;
+
+	return 0;
+}
+
 int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 				       union perf_event *event,
 				       pid_t pid, pid_t tgid,
@@ -287,6 +309,11 @@ static int __event__synthesize_thread(union perf_event *comm_event,
 	DIR *tasks;
 	struct dirent dirent, *next;
 	pid_t tgid;
+	union perf_event *fork_event;
+
+	fork_event = malloc(sizeof(fork_event->fork) + machine->id_hdr_size);
+	if (fork_event == NULL)
+		return -1;
 
 	/* special case: only send one comm event using passed in pid */
 	if (!full) {
@@ -326,9 +353,15 @@ static int __event__synthesize_thread(union perf_event *comm_event,
 		if (tgid == -1)
 			return -1;
 
-		/* process the thread's maps too */
-		rc = perf_event__synthesize_mmap_events(tool, mmap_event, _pid, tgid,
-							process, machine, mmap_data);
+		if (_pid == pid) {
+			/* process the parent's maps too */
+			rc = perf_event__synthesize_mmap_events(tool, mmap_event, pid, tgid,
+						process, machine, mmap_data);
+		} else {
+			/* only fork the tid's map, to save time */
+			rc = perf_event__synthesize_fork(tool, fork_event, _pid, tgid,
+						 process, machine);
+		}
 
 		if (rc)
 			return rc;
-- 
1.7.1


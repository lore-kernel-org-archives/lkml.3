Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbaBZQQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 11:16:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbaBZQQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:16:46 -0500
From: Don Zickus <dzickus@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: acme@ghostprotocols.net, jolsa@redhat.com, eranian@google.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 1/2] perf: fix synthesizing mmaps for threads
Date: Wed, 26 Feb 2014 10:45:26 -0500
Message-Id: <1393429527-167840-2-git-send-email-dzickus@redhat.com>
In-Reply-To: <1393429527-167840-1-git-send-email-dzickus@redhat.com>
References: <1393429527-167840-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently if a process creates a bunch of threads using pthread_create
and then perf is run in system_wide mode, the mmaps for those threads
are not captured with a synthesized mmap event.

The reason is those threads are not visible when walking the /proc/
directory looking for /proc/<pid>/maps files.  Instead they are discovered
using the /proc/<pid>/tasks file (which the synthesized comm event uses).

This causes problems when a program is trying to map a data address to a
tid.  Because the tid has no maps, the event is dropped.  Changing the program
to look up using the pid instead of the tid, finds the correct maps but creates
ugly hacks in the program to carry the correct tid around.

Fix this by moving the walking of the /proc/<pid>/tasks up a level (out of the
comm function) based on Arnaldo's suggestion.

Tweaked things a bit to special case the 'full' bit and 'guest' check.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/util/event.c | 111 ++++++++++++++++++++++++------------------------
 1 file changed, 56 insertions(+), 55 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 086c7c8..82fb890 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -94,14 +94,10 @@ static pid_t perf_event__get_comm_tgid(pid_t pid, char *comm, size_t len)
 
 static pid_t perf_event__synthesize_comm(struct perf_tool *tool,
 					 union perf_event *event, pid_t pid,
-					 int full,
 					 perf_event__handler_t process,
 					 struct machine *machine)
 {
-	char filename[PATH_MAX];
 	size_t size;
-	DIR *tasks;
-	struct dirent dirent, *next;
 	pid_t tgid;
 
 	memset(&event->comm, 0, sizeof(event->comm));
@@ -124,53 +120,11 @@ static pid_t perf_event__synthesize_comm(struct perf_tool *tool,
 	event->comm.header.size = (sizeof(event->comm) -
 				(sizeof(event->comm.comm) - size) +
 				machine->id_hdr_size);
-	if (!full) {
-		event->comm.tid = pid;
-
-		if (process(tool, event, &synth_sample, machine) != 0)
-			return -1;
+	event->comm.tid = pid;
 
-		goto out;
-	}
-
-	if (machine__is_default_guest(machine))
-		return 0;
-
-	snprintf(filename, sizeof(filename), "%s/proc/%d/task",
-		 machine->root_dir, pid);
-
-	tasks = opendir(filename);
-	if (tasks == NULL) {
-		pr_debug("couldn't open %s\n", filename);
-		return 0;
-	}
-
-	while (!readdir_r(tasks, &dirent, &next) && next) {
-		char *end;
-		pid = strtol(dirent.d_name, &end, 10);
-		if (*end)
-			continue;
-
-		/* already have tgid; jut want to update the comm */
-		(void) perf_event__get_comm_tgid(pid, event->comm.comm,
-					 sizeof(event->comm.comm));
-
-		size = strlen(event->comm.comm) + 1;
-		size = PERF_ALIGN(size, sizeof(u64));
-		memset(event->comm.comm + size, 0, machine->id_hdr_size);
-		event->comm.header.size = (sizeof(event->comm) -
-					  (sizeof(event->comm.comm) - size) +
-					  machine->id_hdr_size);
-
-		event->comm.tid = pid;
-
-		if (process(tool, event, &synth_sample, machine) != 0) {
-			tgid = -1;
-			break;
-		}
-	}
+	if (process(tool, event, &synth_sample, machine) != 0)
+		return -1;
 
-	closedir(tasks);
 out:
 	return tgid;
 }
@@ -331,12 +285,59 @@ static int __event__synthesize_thread(union perf_event *comm_event,
 				      struct perf_tool *tool,
 				      struct machine *machine, bool mmap_data)
 {
-	pid_t tgid = perf_event__synthesize_comm(tool, comm_event, pid, full,
-						 process, machine);
-	if (tgid == -1)
-		return -1;
-	return perf_event__synthesize_mmap_events(tool, mmap_event, pid, tgid,
-						  process, machine, mmap_data);
+	char filename[PATH_MAX];
+	DIR *tasks;
+	struct dirent dirent, *next;
+	pid_t tgid;
+
+	/* special case: only send one comm event using passed in pid */
+	if (!full) {
+		tgid = perf_event__synthesize_comm(tool, comm_event, pid,
+						   process, machine);
+
+		if (tgid == -1)
+			return -1;
+
+		return perf_event__synthesize_mmap_events(tool, mmap_event, pid, tgid,
+							  process, machine, mmap_data);
+	}
+
+	if (machine__is_default_guest(machine))
+		return 0;
+
+	snprintf(filename, sizeof(filename), "%s/proc/%d/task",
+		 machine->root_dir, pid);
+
+	tasks = opendir(filename);
+	if (tasks == NULL) {
+		pr_debug("couldn't open %s\n", filename);
+		return 0;
+	}
+
+	while (!readdir_r(tasks, &dirent, &next) && next) {
+		char *end;
+		int rc = 0;
+		pid_t _pid;
+
+		_pid = strtol(dirent.d_name, &end, 10);
+		if (*end)
+			continue;
+
+		tgid = perf_event__synthesize_comm(tool, comm_event, _pid,
+						   process, machine);
+		if (tgid == -1)
+			return -1;
+
+		/* process the thread's maps too */
+		rc = perf_event__synthesize_mmap_events(tool, mmap_event, _pid, tgid,
+							process, machine, mmap_data);
+
+		if (rc)
+			return rc;
+	}
+
+	closedir(tasks);
+	return 0;
 }
 
 int perf_event__synthesize_thread_map(struct perf_tool *tool,
-- 
1.7.11.7


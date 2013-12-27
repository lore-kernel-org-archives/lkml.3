Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab3L0Ur3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 15:47:29 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35682 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800Ab3L0UrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 15:47:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 37/49] perf tools: Find the proc info under machine->root_dir.
Date: Fri, 27 Dec 2013 17:46:53 -0300
Message-Id: <1388177225-17349-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1388177225-17349-1-git-send-email-acme@infradead.org>
References: <1388177225-17349-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

When we synthesize the threads, we are looking for the infomation under
/proc. But it is only for host.

This patch look for the path of proc under machine->root_dir, then
XXX__synthesize_threads() functions can support guest machines.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Link: http://lkml.kernel.org/r/927b937da9177a079abafe4532fa9c9b60b5c4b7.1387572416.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 484e99464a00..a61726ea01a9 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -129,7 +129,8 @@ static pid_t perf_event__synthesize_comm(struct perf_tool *tool,
 		goto out;
 	}
 
-	snprintf(filename, sizeof(filename), "/proc/%d/task", pid);
+	snprintf(filename, sizeof(filename), "%s/proc/%d/task",
+		 machine->root_dir, pid);
 
 	tasks = opendir(filename);
 	if (tasks == NULL) {
@@ -178,7 +179,8 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 	FILE *fp;
 	int rc = 0;
 
-	snprintf(filename, sizeof(filename), "/proc/%d/maps", pid);
+	snprintf(filename, sizeof(filename), "%s/proc/%d/maps",
+		 machine->root_dir, pid);
 
 	fp = fopen(filename, "r");
 	if (fp == NULL) {
@@ -387,6 +389,7 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
 				   struct machine *machine, bool mmap_data)
 {
 	DIR *proc;
+	char proc_path[PATH_MAX];
 	struct dirent dirent, *next;
 	union perf_event *comm_event, *mmap_event;
 	int err = -1;
@@ -399,7 +402,9 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
 	if (mmap_event == NULL)
 		goto out_free_comm;
 
-	proc = opendir("/proc");
+	snprintf(proc_path, sizeof(proc_path), "%s/proc", machine->root_dir);
+	proc = opendir(proc_path);
+
 	if (proc == NULL)
 		goto out_free_mmap;
 
-- 
1.8.1.4


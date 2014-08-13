Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbaHMWtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:49:35 -0400
Received: from mail.kernel.org ([198.145.19.201]:55024 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639AbaHMWtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:49:31 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/41] perf tools: Fix probing the kernel API with cpu-wide events
Date: Wed, 13 Aug 2014 19:47:58 -0300
Message-Id: <1407970107-24540-13-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407970107-24540-1-git-send-email-acme@kernel.org>
References: <1407970107-24540-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Fall back to probing with the current pid if cpu-wide probing fails.
This primarily affects the setting of comm_exec flag when the user is
un-privileged and /proc/sys/kernel/perf_event_paranoid > 0.

The change to comm_exec can be observed by using -vv with perf record
and a kernel that supports comm_exec.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1407855871-15024-4-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/record.c | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
index 58267a85705f..e778afda0fb9 100644
--- a/tools/perf/util/record.c
+++ b/tools/perf/util/record.c
@@ -14,6 +14,7 @@ static int perf_do_probe_api(setup_probe_fn_t fn, int cpu, const char *str)
 	struct perf_evsel *evsel;
 	unsigned long flags = perf_event_open_cloexec_flag();
 	int err = -EAGAIN, fd;
+	static pid_t pid = -1;
 
 	evlist = perf_evlist__new();
 	if (!evlist)
@@ -24,14 +25,22 @@ static int perf_do_probe_api(setup_probe_fn_t fn, int cpu, const char *str)
 
 	evsel = perf_evlist__first(evlist);
 
-	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1, flags);
-	if (fd < 0)
-		goto out_delete;
+	while (1) {
+		fd = sys_perf_event_open(&evsel->attr, pid, cpu, -1, flags);
+		if (fd < 0) {
+			if (pid == -1 && errno == EACCES) {
+				pid = 0;
+				continue;
+			}
+			goto out_delete;
+		}
+		break;
+	}
 	close(fd);
 
 	fn(evsel);
 
-	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1, flags);
+	fd = sys_perf_event_open(&evsel->attr, pid, cpu, -1, flags);
 	if (fd < 0) {
 		if (errno == EINVAL)
 			err = -EINVAL;
@@ -201,6 +210,7 @@ bool perf_evlist__can_select_event(struct perf_evlist *evlist, const char *str)
 	struct perf_evsel *evsel;
 	int err, fd, cpu;
 	bool ret = false;
+	pid_t pid = -1;
 
 	temp_evlist = perf_evlist__new();
 	if (!temp_evlist)
@@ -221,12 +231,20 @@ bool perf_evlist__can_select_event(struct perf_evlist *evlist, const char *str)
 		cpu = evlist->cpus->map[0];
 	}
 
-	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1,
-				 perf_event_open_cloexec_flag());
-	if (fd >= 0) {
-		close(fd);
-		ret = true;
+	while (1) {
+		fd = sys_perf_event_open(&evsel->attr, pid, cpu, -1,
+					 perf_event_open_cloexec_flag());
+		if (fd < 0) {
+			if (pid == -1 && errno == EACCES) {
+				pid = 0;
+				continue;
+			}
+			goto out_delete;
+		}
+		break;
 	}
+	close(fd);
+	ret = true;
 
 out_delete:
 	perf_evlist__delete(temp_evlist);
-- 
1.9.3


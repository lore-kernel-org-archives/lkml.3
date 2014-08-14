Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbaHNIqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:46:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36329 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbaHNIqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:46:02 -0400
Date: Thu, 14 Aug 2014 01:45:10 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-46ec69add5df60310147ce3ce01a662053d82a1e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        jolsa@kernel.org, peterz@infradead.org, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1407855871-15024-4-git-send-email-adrian.hunter@intel.com>
References: <1407855871-15024-4-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix probing the kernel API with cpu-wide events
Git-Commit-ID: 46ec69add5df60310147ce3ce01a662053d82a1e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  46ec69add5df60310147ce3ce01a662053d82a1e
Gitweb:     http://git.kernel.org/tip/46ec69add5df60310147ce3ce01a662053d82a1e
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 12 Aug 2014 18:04:30 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Aug 2014 16:22:06 -0300

perf tools: Fix probing the kernel API with cpu-wide events

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
index 58267a8..e778afd 100644
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

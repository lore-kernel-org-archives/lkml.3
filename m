Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaAQPAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:00:34 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36316 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbaAQO5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:57:42 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "David A. Long" <dave.long@linaro.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        yrl.pp-manager.tt@hitachi.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 14/19] perf probe: Release allocated probe_trace_event if failed
Date: Fri, 17 Jan 2014 11:57:20 -0300
Message-Id: <1389970645-12075-15-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389970645-12075-1-git-send-email-acme@infradead.org>
References: <1389970645-12075-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

To fix a memory leak, release all allocated probe_trace_event on the
error path of try_to_find_probe_trace_events.

Reported-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "David A. Long" <dave.long@linaro.org>
Cc: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20140116093944.24403.30228.stgit@kbuild-fedora.novalocal
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index a4ee6b4a840f..579b655c0f93 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -72,6 +72,7 @@ static int e_snprintf(char *str, size_t size, const char *format, ...)
 static char *synthesize_perf_probe_point(struct perf_probe_point *pp);
 static int convert_name_to_addr(struct perf_probe_event *pev,
 				const char *exec);
+static void clear_probe_trace_event(struct probe_trace_event *tev);
 static struct machine machine;
 
 /* Initialize symbol maps and path of vmlinux/modules */
@@ -407,6 +408,14 @@ static int add_module_to_probe_trace_events(struct probe_trace_event *tevs,
 	return ret;
 }
 
+static void clear_probe_trace_events(struct probe_trace_event *tevs, int ntevs)
+{
+	int i;
+
+	for (i = 0; i < ntevs; i++)
+		clear_probe_trace_event(tevs + i);
+}
+
 /* Try to find perf_probe_event with debuginfo */
 static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
 					  struct probe_trace_event **tevs,
@@ -442,6 +451,10 @@ static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
 				ret = add_module_to_probe_trace_events(*tevs,
 						 ntevs, target);
 		}
+		if (ret < 0) {
+			clear_probe_trace_events(*tevs, ntevs);
+			zfree(tevs);
+		}
 		return ret < 0 ? ret : ntevs;
 	}
 
-- 
1.8.1.4


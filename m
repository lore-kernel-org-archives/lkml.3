Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbaAPJlH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 04:41:07 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:51340 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaAPJjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 04:39:48 -0500
Subject: [PATCH -tip 1/3] [BUGFIX] perf-probe: Release allocated
 probe_trace_event if failed
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, yrl.pp-manager.tt@hitachi.com,
        Namhyung Kim <namhyung@kernel.org>
Date: Thu, 16 Jan 2014 09:39:44 +0000
Message-ID: <20140116093944.24403.30228.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140116093942.24403.50992.stgit@kbuild-fedora.novalocal>
References: <20140116093942.24403.50992.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To fix a memory leak, release all allocated probe_trace_event
on the error path of try_to_find_probe_trace_events.

Reported-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
---
 tools/perf/util/probe-event.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index a4ee6b4..579b655 100644
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
 



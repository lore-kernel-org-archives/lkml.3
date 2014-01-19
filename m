Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbaASMZF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 07:25:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55915 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbaASMZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 07:25:00 -0500
Date: Sun, 19 Jan 2014 04:24:39 -0800
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-981d05adf2e2acc328abb929a6ed3536c0d41c5f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        dave.long@linaro.org, hpa@zytor.com, mingo@kernel.org,
        namhyung@kernel.org, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, srikar@linux.vnet.ibm.com, dsahern@gmail.com,
        oleg@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, dave.long@linaro.org,
        mingo@redhat.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        namhyung@kernel.org, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, srikar@linux.vnet.ibm.com, dsahern@gmail.com,
        tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20140116093944.24403.30228.stgit@kbuild-fedora.novalocal>
References: <20140116093944.24403.30228.stgit@kbuild-fedora.novalocal>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe:
  Release allocated probe_trace_event if failed
Git-Commit-ID: 981d05adf2e2acc328abb929a6ed3536c0d41c5f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 19 Jan 2014 04:24:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  981d05adf2e2acc328abb929a6ed3536c0d41c5f
Gitweb:     http://git.kernel.org/tip/981d05adf2e2acc328abb929a6ed3536c0d41c5f
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 16 Jan 2014 09:39:44 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 16 Jan 2014 16:26:50 -0300

perf probe: Release allocated probe_trace_event if failed

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
 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbaBRVO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:14:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35710 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbaBRVJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:09:10 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Ahern <dsahern@gmail.com>,
        "David A. Long" <dave.long@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, yrl.pp-manager.tt@hitachi.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 26/32] perf probe: Show in what binaries/modules probes are set
Date: Tue, 18 Feb 2014 18:08:45 -0300
Message-Id: <1392757731-32619-27-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1392757731-32619-1-git-send-email-acme@infradead.org>
References: <1392757731-32619-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Show the name of binary file or modules in which the probes are set with
--list option.

Without this change;

  # ./perf probe -m drm drm_av_sync_delay
  # ./perf probe -x perf dso__load_vmlinux

  # ./perf probe -l
    probe:drm_av_sync_delay (on drm_av_sync_delay)
    probe_perf:dso__load_vmlinux (on 0x000000000006d110)

With this change;

  # ./perf probe -l
    probe:drm_av_sync_delay (on drm_av_sync_delay in drm)
    probe_perf:dso__load_vmlinux (on 0x000000000006d110 in /kbuild/ksrc/linux-3/tools/perf/perf)

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: "David A. Long" <dave.long@linaro.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20140206053213.29635.69948.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index ace3ba37c880..de9fe906f3be 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1728,7 +1728,8 @@ static struct strlist *get_probe_trace_command_rawlist(int fd)
 }
 
 /* Show an event */
-static int show_perf_probe_event(struct perf_probe_event *pev)
+static int show_perf_probe_event(struct perf_probe_event *pev,
+				 const char *module)
 {
 	int i, ret;
 	char buf[128];
@@ -1744,6 +1745,8 @@ static int show_perf_probe_event(struct perf_probe_event *pev)
 		return ret;
 
 	printf("  %-20s (on %s", buf, place);
+	if (module)
+		printf(" in %s", module);
 
 	if (pev->nargs > 0) {
 		printf(" with");
@@ -1781,7 +1784,8 @@ static int __show_perf_probe_events(int fd, bool is_kprobe)
 			ret = convert_to_perf_probe_event(&tev, &pev,
 								is_kprobe);
 			if (ret >= 0)
-				ret = show_perf_probe_event(&pev);
+				ret = show_perf_probe_event(&pev,
+							    tev.point.module);
 		}
 		clear_perf_probe_event(&pev);
 		clear_probe_trace_event(&tev);
@@ -1980,7 +1984,7 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
 		group = pev->group;
 		pev->event = tev->event;
 		pev->group = tev->group;
-		show_perf_probe_event(pev);
+		show_perf_probe_event(pev, tev->point.module);
 		/* Trick here - restore current event/group */
 		pev->event = (char *)event;
 		pev->group = (char *)group;
-- 
1.8.1.4


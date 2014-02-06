Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbaBFFcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 00:32:23 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:44315 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbaBFFcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 00:32:17 -0500
Subject: [PATCH -tip v3 05/11] perf-probe: Show in what binaries/modules
 probes are set
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, yrl.pp-manager.tt@hitachi.com,
        Namhyung Kim <namhyung@kernel.org>
Date: Thu, 06 Feb 2014 05:32:13 +0000
Message-ID: <20140206053213.29635.69948.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
In-Reply-To: <20140206053201.29635.99095.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
References: <20140206053201.29635.99095.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Show the name of binary file or modules in which the probes
are set with --list option.

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
---
 tools/perf/util/probe-event.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index ace3ba3..de9fe90 100644
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



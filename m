Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbaBVSBA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 13:01:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41167 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbaBVSA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 13:00:57 -0500
Date: Sat, 22 Feb 2014 10:00:36 -0800
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-fb226ccd2a6f77be13009edc196da2077800066b@git.kernel.org>
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
In-Reply-To: <20140206053213.29635.69948.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
References: <20140206053213.29635.69948.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Show in what binaries/
 modules probes are set
Git-Commit-ID: fb226ccd2a6f77be13009edc196da2077800066b
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

Commit-ID:  fb226ccd2a6f77be13009edc196da2077800066b
Gitweb:     http://git.kernel.org/tip/fb226ccd2a6f77be13009edc196da2077800066b
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 6 Feb 2014 05:32:13 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Feb 2014 09:34:50 -0300

perf probe: Show in what binaries/modules probes are set

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

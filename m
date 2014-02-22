Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaBVR42 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 12:56:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40761 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbaBVR40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 12:56:26 -0500
Date: Sat, 22 Feb 2014 09:55:44 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-tmct07y7mka54allj82trlnx@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report: Use al->cpumode where applicable
Git-Commit-ID: 17f22a3fbc9d81c1d8f9f853dd23d0e5e8f4c994
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

Commit-ID:  17f22a3fbc9d81c1d8f9f853dd23d0e5e8f4c994
Gitweb:     http://git.kernel.org/tip/17f22a3fbc9d81c1d8f9f853dd23d0e5e8f4c994
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 22 Jan 2014 12:55:32 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Feb 2014 09:34:46 -0300

perf report: Use al->cpumode where applicable

We don't need to recalculate cpumode from the perf_event->header field,
as this is already available in the struct addr_location->cpumode field.

Remove the function signature of functions that receive both perf_event
and addr_location parameters but use perf_event just to extract the
cpumode.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-tmct07y7mka54allj82trlnx@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 3c53ec2..8f9d6ed 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -76,12 +76,10 @@ static int report__config(const char *var, const char *value, void *cb)
 }
 
 static int report__add_mem_hist_entry(struct perf_tool *tool, struct addr_location *al,
-				      struct perf_sample *sample, struct perf_evsel *evsel,
-				      union perf_event *event)
+				      struct perf_sample *sample, struct perf_evsel *evsel)
 {
 	struct report *rep = container_of(tool, struct report, tool);
 	struct symbol *parent = NULL;
-	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 	struct hist_entry *he;
 	struct mem_info *mi, *mx;
 	uint64_t cost;
@@ -90,7 +88,7 @@ static int report__add_mem_hist_entry(struct perf_tool *tool, struct addr_locati
 	if (err)
 		return err;
 
-	mi = machine__resolve_mem(al->machine, al->thread, sample, cpumode);
+	mi = machine__resolve_mem(al->machine, al->thread, sample, al->cpumode);
 	if (!mi)
 		return -ENOMEM;
 
@@ -240,7 +238,7 @@ static int process_sample_event(struct perf_tool *tool,
 		if (ret < 0)
 			pr_debug("problem adding lbr entry, skipping event\n");
 	} else if (rep->mem_mode == 1) {
-		ret = report__add_mem_hist_entry(tool, &al, sample, evsel, event);
+		ret = report__add_mem_hist_entry(tool, &al, sample, evsel);
 		if (ret < 0)
 			pr_debug("problem adding mem entry, skipping event\n");
 	} else {

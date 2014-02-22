Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaBVR4g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 12:56:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40767 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbaBVR4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 12:56:32 -0500
Date: Sat, 22 Feb 2014 09:55:55 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-3f5otpssefh9l5hi1t259h8n@git.kernel.org>
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
Subject: [tip:perf/core] perf tools:
  Shorten sample symbol resolving function signature
Git-Commit-ID: e80faac0460f178a5be576b4260897f997109e73
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

Commit-ID:  e80faac0460f178a5be576b4260897f997109e73
Gitweb:     http://git.kernel.org/tip/e80faac0460f178a5be576b4260897f997109e73
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 22 Jan 2014 13:05:06 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Feb 2014 09:34:46 -0300

perf tools: Shorten sample symbol resolving function signature

Since three of the parameters come from the same 'struct addr_location',
rename machine__resolve_mem() to sample__resolve_mem() and pass the
that addr_location instead.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-3f5otpssefh9l5hi1t259h8n@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |  2 +-
 tools/perf/util/hist.c      |  2 +-
 tools/perf/util/machine.c   | 11 +++++------
 tools/perf/util/machine.h   |  5 ++---
 4 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 8f9d6ed..0d381dc 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -88,7 +88,7 @@ static int report__add_mem_hist_entry(struct perf_tool *tool, struct addr_locati
 	if (err)
 		return err;
 
-	mi = machine__resolve_mem(al->machine, al->thread, sample, al->cpumode);
+	mi = sample__resolve_mem(sample, al);
 	if (!mi)
 		return -ENOMEM;
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index e4e6249..6240ca4 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -369,7 +369,7 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 			he_stat__add_period(&he->stat, period, weight);
 
 			/*
-			 * This mem info was allocated from machine__resolve_mem
+			 * This mem info was allocated from sample__resolve_mem
 			 * and will not be used anymore.
 			 */
 			zfree(&entry->mem_info);
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index c872991..0d304d8 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1238,18 +1238,17 @@ static void ip__resolve_data(struct machine *machine, struct thread *thread,
 	ams->map = al.map;
 }
 
-struct mem_info *machine__resolve_mem(struct machine *machine,
-				      struct thread *thr,
-				      struct perf_sample *sample,
-				      u8 cpumode)
+struct mem_info *sample__resolve_mem(struct perf_sample *sample,
+				     struct addr_location *al)
 {
 	struct mem_info *mi = zalloc(sizeof(*mi));
 
 	if (!mi)
 		return NULL;
 
-	ip__resolve_ams(machine, thr, &mi->iaddr, sample->ip);
-	ip__resolve_data(machine, thr, cpumode, &mi->daddr, sample->addr);
+	ip__resolve_ams(al->machine, al->thread, &mi->iaddr, sample->ip);
+	ip__resolve_data(al->machine, al->thread, al->cpumode,
+			 &mi->daddr, sample->addr);
 	mi->data_src.val = sample->data_src;
 
 	return mi;
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index f77e91e..9ddacd9 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -94,9 +94,8 @@ void machine__delete(struct machine *machine);
 struct branch_info *machine__resolve_bstack(struct machine *machine,
 					    struct thread *thread,
 					    struct branch_stack *bs);
-struct mem_info *machine__resolve_mem(struct machine *machine,
-				      struct thread *thread,
-				      struct perf_sample *sample, u8 cpumode);
+struct mem_info *sample__resolve_mem(struct perf_sample *sample,
+				     struct addr_location *al);
 int machine__resolve_callchain(struct machine *machine,
 			       struct perf_evsel *evsel,
 			       struct thread *thread,

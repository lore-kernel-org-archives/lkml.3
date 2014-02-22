Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbaBVR4n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 12:56:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40784 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbaBVR4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 12:56:41 -0500
Date: Sat, 22 Feb 2014 09:56:06 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-99ecqt8jiyyksiyx3se7l5ia@git.kernel.org>
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
Git-Commit-ID: 644f2df29faf66f408fea2e50f16d3b5302403da
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

Commit-ID:  644f2df29faf66f408fea2e50f16d3b5302403da
Gitweb:     http://git.kernel.org/tip/644f2df29faf66f408fea2e50f16d3b5302403da
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 22 Jan 2014 13:15:36 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Feb 2014 09:34:46 -0300

perf tools: Shorten sample symbol resolving function signature

Since two of the parameters come from the same 'struct
addr_location', rename machine__resolve_bstack() to sample__resolve_bstack()
and pass the that addr_location instead.

This is also for consistency with the same change that resulted in the
sample__resolve_mem() function.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-99ecqt8jiyyksiyx3se7l5ia@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |  3 +--
 tools/perf/util/hist.c      |  2 +-
 tools/perf/util/machine.c   | 13 ++++++-------
 tools/perf/util/machine.h   |  5 ++---
 4 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 0d381dc..6b7a0a0 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -140,8 +140,7 @@ static int report__add_branch_hist_entry(struct perf_tool *tool, struct addr_loc
 	if (err)
 		return err;
 
-	bi = machine__resolve_bstack(al->machine, al->thread,
-				     sample->branch_stack);
+	bi = sample__resolve_bstack(sample, al);
 	if (!bi)
 		return -ENOMEM;
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 6240ca4..0466efa 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -290,7 +290,7 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 		if (he->branch_info) {
 			/*
 			 * This branch info is (a part of) allocated from
-			 * machine__resolve_bstack() and will be freed after
+			 * sample__resolve_bstack() and will be freed after
 			 * adding new entries.  So we need to save a copy.
 			 */
 			he->branch_info = malloc(sizeof(*he->branch_info));
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 0d304d8..6c08ab0 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1254,20 +1254,19 @@ struct mem_info *sample__resolve_mem(struct perf_sample *sample,
 	return mi;
 }
 
-struct branch_info *machine__resolve_bstack(struct machine *machine,
-					    struct thread *thr,
-					    struct branch_stack *bs)
+struct branch_info *sample__resolve_bstack(struct perf_sample *sample,
+					   struct addr_location *al)
 {
-	struct branch_info *bi;
 	unsigned int i;
+	const struct branch_stack *bs = sample->branch_stack;
+	struct branch_info *bi = calloc(bs->nr, sizeof(struct branch_info));
 
-	bi = calloc(bs->nr, sizeof(struct branch_info));
 	if (!bi)
 		return NULL;
 
 	for (i = 0; i < bs->nr; i++) {
-		ip__resolve_ams(machine, thr, &bi[i].to, bs->entries[i].to);
-		ip__resolve_ams(machine, thr, &bi[i].from, bs->entries[i].from);
+		ip__resolve_ams(al->machine, al->thread, &bi[i].to, bs->entries[i].to);
+		ip__resolve_ams(al->machine, al->thread, &bi[i].from, bs->entries[i].from);
 		bi[i].flags = bs->entries[i].flags;
 	}
 	return bi;
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 9ddacd9..2e6c248 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -91,9 +91,8 @@ void machine__delete_dead_threads(struct machine *machine);
 void machine__delete_threads(struct machine *machine);
 void machine__delete(struct machine *machine);
 
-struct branch_info *machine__resolve_bstack(struct machine *machine,
-					    struct thread *thread,
-					    struct branch_stack *bs);
+struct branch_info *sample__resolve_bstack(struct perf_sample *sample,
+					   struct addr_location *al);
 struct mem_info *sample__resolve_mem(struct perf_sample *sample,
 				     struct addr_location *al);
 int machine__resolve_callchain(struct machine *machine,

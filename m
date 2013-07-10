Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab3GJTVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 15:21:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56885 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935Ab3GJTUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 15:20:02 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Waiman Long <Waiman.Long@hp.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 18/23] perf symbols: Fix vdso list searching
Date: Wed, 10 Jul 2013 16:19:18 -0300
Message-Id: <1373483963-19277-19-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373483963-19277-1-git-send-email-acme@infradead.org>
References: <1373483963-19277-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Waiman Long <Waiman.Long@hp.com>

When "perf record" was used on a large machine with a lot of CPUs, the
perf post-processing time (the time after the workload was done until
the perf command itself exited) could take a lot of minutes and even
hours depending on how large the resulting perf.data file was.

While running AIM7 1500-user high_systime workload on a 80-core x86-64
system with a 3.9 kernel (with only the -s -a options used), the
workload itself took about 2 minutes to run and the perf.data file had a
size of 1108.746 MB. However, the post-processing step took more than 10
minutes.

With a gprof-profiled perf binary, the time spent by perf was as
follows:

  %   cumulative   self              self     total
 time   seconds   seconds    calls   s/call   s/call  name
 96.90    822.10   822.10   192156     0.00     0.00  dsos__find
  0.81    828.96     6.86 172089958     0.00     0.00  rb_next
  0.41    832.44     3.48 48539289     0.00     0.00  rb_erase

So 97% (822 seconds) of the time was spent in a single dsos_find()
function. After analyzing the call-graph data below:

 -----------------------------------------------
                 0.00  822.12  192156/192156      map__new [6]
 [7]     96.9    0.00  822.12  192156         vdso__dso_findnew [7]
               822.10    0.00  192156/192156      dsos__find [8]
                 0.01    0.00  192156/192156      dsos__add [62]
                 0.01    0.00  192156/192366      dso__new [61]
                 0.00    0.00       1/45282525     memdup [31]
                 0.00    0.00  192156/192230      dso__set_long_name [91]
 -----------------------------------------------
               822.10    0.00  192156/192156      vdso__dso_findnew [7]
 [8]     96.9  822.10    0.00  192156         dsos__find [8]
 -----------------------------------------------

It was found that the vdso__dso_findnew() function failed to locate
VDSO__MAP_NAME ("[vdso]") in the dso list and have to insert a new
entry at the end for 192156 times. This problem is due to the fact that
there are 2 types of name in the dso entry - short name and long name.
The initial dso__new() adds "[vdso]" to both the short and long names.
After that, vdso__dso_findnew() modifies the long name to something
like /tmp/perf-vdso.so-NoXkDj. The dsos__find() function only compares
the long name. As a result, the same vdso entry is duplicated many
time in the dso list. This bug increases memory consumption as well
as slows the symbol processing time to a crawl.

To resolve this problem, the dsos__find() function interface was
modified to enable searching either the long name or the short
name. The vdso__dso_findnew() will now search only the short name
while the other call sites search for the long name as before.

With this change, the cpu time of perf was reduced from 848.38s to
15.77s and dsos__find() only accounted for 0.06% of the total time.

  0.06     15.73     0.01   192151     0.00     0.00  dsos__find

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: "Chandramouleeswaran, Aswin" <aswin@hp.com>
Cc: "Norton, Scott J" <scott.norton@hp.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1368110568-64714-1-git-send-email-Waiman.Long@hp.com
[ replaced TRUE/FALSE with stdbool.h equivalents, fixing builds where
  those macros are not present (NO_LIBPYTHON=1 NO_LIBPERL=1), fix from Jiri Olsa ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c  | 10 ++++++++--
 tools/perf/util/dso.h  |  3 ++-
 tools/perf/util/vdso.c |  2 +-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 6f7d5a9..c4374f0 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -513,10 +513,16 @@ void dsos__add(struct list_head *head, struct dso *dso)
 	list_add_tail(&dso->node, head);
 }
 
-struct dso *dsos__find(struct list_head *head, const char *name)
+struct dso *dsos__find(struct list_head *head, const char *name, bool cmp_short)
 {
 	struct dso *pos;
 
+	if (cmp_short) {
+		list_for_each_entry(pos, head, node)
+			if (strcmp(pos->short_name, name) == 0)
+				return pos;
+		return NULL;
+	}
 	list_for_each_entry(pos, head, node)
 		if (strcmp(pos->long_name, name) == 0)
 			return pos;
@@ -525,7 +531,7 @@ struct dso *dsos__find(struct list_head *head, const char *name)
 
 struct dso *__dsos__findnew(struct list_head *head, const char *name)
 {
-	struct dso *dso = dsos__find(head, name);
+	struct dso *dso = dsos__find(head, name, false);
 
 	if (!dso) {
 		dso = dso__new(name);
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 450199a..d51aaf2 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -133,7 +133,8 @@ struct dso *dso__kernel_findnew(struct machine *machine, const char *name,
 				const char *short_name, int dso_type);
 
 void dsos__add(struct list_head *head, struct dso *dso);
-struct dso *dsos__find(struct list_head *head, const char *name);
+struct dso *dsos__find(struct list_head *head, const char *name,
+		       bool cmp_short);
 struct dso *__dsos__findnew(struct list_head *head, const char *name);
 bool __dsos__read_build_ids(struct list_head *head, bool with_hits);
 
diff --git a/tools/perf/util/vdso.c b/tools/perf/util/vdso.c
index e60951f..3915982 100644
--- a/tools/perf/util/vdso.c
+++ b/tools/perf/util/vdso.c
@@ -91,7 +91,7 @@ void vdso__exit(void)
 
 struct dso *vdso__dso_findnew(struct list_head *head)
 {
-	struct dso *dso = dsos__find(head, VDSO__MAP_NAME);
+	struct dso *dso = dsos__find(head, VDSO__MAP_NAME, true);
 
 	if (!dso) {
 		char *file;
-- 
1.8.1.4


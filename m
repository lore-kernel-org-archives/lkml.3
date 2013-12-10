Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab3LJUbq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:31:46 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34343 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab3LJUbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:31:44 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 25/34] perf symbols: Remove open coded management of  short_name_allocated member
Date: Tue, 10 Dec 2013 17:31:07 -0300
Message-Id: <1386707476-12370-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386707476-12370-1-git-send-email-acme@infradead.org>
References: <1386707476-12370-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Instead of expecting callers to set this member accodingly so that later
at dso destruction it can, if needed, be correctly free()d, make it a
requirement by passing it as a parameter to dso__set_short_name.

Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Link: http://lkml.kernel.org/r/52A707A2.5020802@intel.com
[ Renamed the 'allocated' parameter to clearly indicate to which variable it refers to. ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c     | 17 +++++++++++------
 tools/perf/util/dso.h     |  2 +-
 tools/perf/util/machine.c |  3 +--
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 55c983586b05..f8c849767c4d 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -379,7 +379,7 @@ struct dso *dso__kernel_findnew(struct machine *machine, const char *name,
 	 * processing we had no idea this was the kernel dso.
 	 */
 	if (dso != NULL) {
-		dso__set_short_name(dso, short_name);
+		dso__set_short_name(dso, short_name, false);
 		dso->kernel = dso_type;
 	}
 
@@ -394,17 +394,22 @@ void dso__set_long_name(struct dso *dso, char *name)
 	dso->long_name_len = strlen(name);
 }
 
-void dso__set_short_name(struct dso *dso, const char *name)
+void dso__set_short_name(struct dso *dso, const char *name, bool name_allocated)
 {
 	if (name == NULL)
 		return;
-	dso->short_name = name;
-	dso->short_name_len = strlen(name);
+
+	if (dso->short_name_allocated)
+		free((char *)dso->short_name);
+
+	dso->short_name		  = name;
+	dso->short_name_len	  = strlen(name);
+	dso->short_name_allocated = name_allocated;
 }
 
 static void dso__set_basename(struct dso *dso)
 {
-	dso__set_short_name(dso, basename(dso->long_name));
+	dso__set_short_name(dso, basename(dso->long_name), false);
 }
 
 int dso__name_len(const struct dso *dso)
@@ -440,7 +445,7 @@ struct dso *dso__new(const char *name)
 		int i;
 		strcpy(dso->name, name);
 		dso__set_long_name(dso, dso->name);
-		dso__set_short_name(dso, dso->name);
+		dso__set_short_name(dso, dso->name, false);
 		for (i = 0; i < MAP__NR_TYPES; ++i)
 			dso->symbols[i] = dso->symbol_names[i] = RB_ROOT;
 		dso->cache = RB_ROOT;
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 00a232d89607..8eceab78088f 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -110,7 +110,7 @@ static inline void dso__set_loaded(struct dso *dso, enum map_type type)
 struct dso *dso__new(const char *name);
 void dso__delete(struct dso *dso);
 
-void dso__set_short_name(struct dso *dso, const char *name);
+void dso__set_short_name(struct dso *dso, const char *name, bool name_allocated);
 void dso__set_long_name(struct dso *dso, char *name);
 
 int dso__name_len(const struct dso *dso);
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index f85da9a9a5d9..09d5c66d4087 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -935,8 +935,7 @@ static int machine__process_kernel_mmap_event(struct machine *machine,
 		if (name == NULL)
 			goto out_problem;
 
-		dso__set_short_name(map->dso, name);
-		map->dso->short_name_allocated = 1;
+		dso__set_short_name(map->dso, name, true);
 		map->end = map->start + event->mmap.len;
 	} else if (is_kernel_mmap) {
 		const char *symbol_name = (event->mmap.filename +
-- 
1.8.1.4


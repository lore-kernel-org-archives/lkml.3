Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab3LKLNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:13:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60549 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab3LKLNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:13:20 -0500
Date: Wed, 11 Dec 2013 03:07:21 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-58a98c9cc583435784a93f23754128363b4cca94@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, namhyung.kim@lge.com,
        jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        ak@linux.intel.com, dsahern@gmail.com, tglx@linutronix.de,
        yangds.fnst@cn.fujitsu.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, adrian.hunter@intel.com
Reply-To: mingo@kernel.org, eranian@google.com, acme@redhat.com, efault@gmx.de,
        peterz@infradead.org, namhyung.kim@lge.com, jolsa@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, dsahern@gmail.com,
        ak@linux.intel.com, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com,
        hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com
In-Reply-To: <52A707A2.5020802@intel.com>
References: <52A707A2.5020802@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols:
  Remove open coded management of  short_name_allocated member
Git-Commit-ID: 58a98c9cc583435784a93f23754128363b4cca94
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 11 Dec 2013 03:07:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  58a98c9cc583435784a93f23754128363b4cca94
Gitweb:     http://git.kernel.org/tip/58a98c9cc583435784a93f23754128363b4cca94
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 10 Dec 2013 11:11:46 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 10 Dec 2013 16:51:08 -0300

perf symbols: Remove open coded management of  short_name_allocated member

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
index 55c9835..f8c8497 100644
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
index 00a232d..8eceab7 100644
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
index f85da9a..09d5c66 100644
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

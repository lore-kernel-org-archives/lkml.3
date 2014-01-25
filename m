Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbaAYHal (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 02:30:41 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:37613 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaAYHaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 02:30:39 -0500
Date: Sat, 25 Jan 2014 08:30:34 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20140125073034.GA9143@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   # HEAD: 993e5ee67a90c7b6a5dbb61b9c31df2955afff46 Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent

A handful of tooling fixes.

 Thanks,

	Ingo

------------------>
Alan Cox (1):
      perf tools: Ensure sscanf does not overrun the "mem" field

Baruch Siach (1):
      perf tools: Add support for the xtensa architecture

Josh Boyer (1):
      perf tools: Fix traceevent plugin path definitions

Masami Hiramatsu (1):
      perf symbols: Load map before using map->map_ip()

Namhyung Kim (1):
      perf symbols: Fix JIT symbol resolution on heap

Stanislav Fomichev (2):
      perf timechart: Fix wrong SVG height
      perf session: Free cpu_map in perf_session__cpu_bitmap

Stephane Eranian (3):
      perf stat: fix NULL pointer reference bug with event unit
      perf evsel: Remove duplicate member zeroing after free
      perf stat: Fix memory corruption of xyarray when cpumask is used


 tools/lib/traceevent/Makefile  |  2 +-
 tools/perf/builtin-timechart.c |  3 +++
 tools/perf/config/Makefile     |  2 +-
 tools/perf/perf.h              |  7 +++++++
 tools/perf/util/evlist.c       |  7 +++++--
 tools/perf/util/evsel.c        |  1 -
 tools/perf/util/header.c       |  2 +-
 tools/perf/util/map.c          |  7 ++++---
 tools/perf/util/parse-events.c |  2 +-
 tools/perf/util/pmu.c          | 24 ++++++++++++++++++++----
 tools/perf/util/pmu.h          |  2 +-
 tools/perf/util/session.c      | 10 +++++++---
 12 files changed, 51 insertions(+), 18 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 56d52a3..005c9cc 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -63,7 +63,7 @@ endif
 endif
 
 ifeq ($(set_plugin_dir),1)
-PLUGIN_DIR = -DPLUGIN_DIR="$(DESTDIR)/$(plugin_dir)"
+PLUGIN_DIR = -DPLUGIN_DIR="$(plugin_dir)"
 PLUGIN_DIR_SQ = '$(subst ','\'',$(PLUGIN_DIR))'
 endif
 
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 652af0b..25526d6 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1045,6 +1045,9 @@ static void write_svg_file(struct timechart *tchart, const char *filename)
 		thresh /= 10;
 	} while (!process_filter && thresh && count < tchart->proc_num);
 
+	if (!tchart->proc_num)
+		count = 0;
+
 	open_svg(filename, tchart->numcpus, count, tchart->first_time, tchart->last_time);
 
 	svg_time_grid();
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index d604e50..c48d449 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -600,5 +600,5 @@ perfexec_instdir_SQ = $(subst ','\'',$(perfexec_instdir))
 # Otherwise we install plugins into the global $(libdir).
 ifdef DESTDIR
 plugindir=$(libdir)/traceevent/plugins
-plugindir_SQ= $(subst ','\'',$(prefix)/$(plugindir))
+plugindir_SQ= $(subst ','\'',$(plugindir))
 endif
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 3c2f213..7daa806 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -132,6 +132,13 @@
 #define CPUINFO_PROC	"CPU"
 #endif
 
+#ifdef __xtensa__
+#define mb()		asm volatile("memw" ::: "memory")
+#define wmb()		asm volatile("memw" ::: "memory")
+#define rmb()		asm volatile("" ::: "memory")
+#define CPUINFO_PROC	"core ID"
+#endif
+
 #define barrier() asm volatile ("" ::: "memory")
 
 #ifndef cpu_relax
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 40bd2c0..59ef280 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1003,9 +1003,12 @@ void perf_evlist__close(struct perf_evlist *evlist)
 	struct perf_evsel *evsel;
 	int ncpus = cpu_map__nr(evlist->cpus);
 	int nthreads = thread_map__nr(evlist->threads);
+	int n;
 
-	evlist__for_each_reverse(evlist, evsel)
-		perf_evsel__close(evsel, ncpus, nthreads);
+	evlist__for_each_reverse(evlist, evsel) {
+		n = evsel->cpus ? evsel->cpus->nr : ncpus;
+		perf_evsel__close(evsel, n, nthreads);
+	}
 }
 
 int perf_evlist__open(struct perf_evlist *evlist)
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 22e18a2..55407c5 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1081,7 +1081,6 @@ void perf_evsel__close(struct perf_evsel *evsel, int ncpus, int nthreads)
 
 	perf_evsel__close_fd(evsel, ncpus, nthreads);
 	perf_evsel__free_fd(evsel);
-	evsel->fd = NULL;
 }
 
 static struct {
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index bb3e0ed..893f8e2 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -930,7 +930,7 @@ static int write_topo_node(int fd, int node)
 		/* skip over invalid lines */
 		if (!strchr(buf, ':'))
 			continue;
-		if (sscanf(buf, "%*s %*d %s %"PRIu64, field, &mem) != 2)
+		if (sscanf(buf, "%*s %*d %31s %"PRIu64, field, &mem) != 2)
 			goto done;
 		if (!strcmp(field, "MemTotal:"))
 			mem_total = mem;
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 9b9bd71..3b97513 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -69,7 +69,7 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 		map->ino = ino;
 		map->ino_generation = ino_gen;
 
-		if (anon) {
+		if ((anon || no_dso) && type == MAP__FUNCTION) {
 			snprintf(newfilename, sizeof(newfilename), "/tmp/perf-%d.map", pid);
 			filename = newfilename;
 		}
@@ -93,7 +93,7 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 			 * functions still return NULL, and we avoid the
 			 * unnecessary map__load warning.
 			 */
-			if (no_dso)
+			if (type != MAP__FUNCTION)
 				dso__set_loaded(dso, map->type);
 		}
 	}
@@ -386,7 +386,8 @@ struct symbol *map_groups__find_symbol(struct map_groups *mg,
 {
 	struct map *map = map_groups__find(mg, type, addr);
 
-	if (map != NULL) {
+	/* Ensure map is loaded before using map->map_ip */
+	if (map != NULL && map__load(map, filter) >= 0) {
 		if (mapp != NULL)
 			*mapp = map;
 		return map__find_symbol(map, map->map_ip(map, addr), filter);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index a7f1b6a..d248fca 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -635,7 +635,7 @@ int parse_events_add_pmu(struct list_head *list, int *idx,
 	struct perf_event_attr attr;
 	struct perf_pmu *pmu;
 	struct perf_evsel *evsel;
-	char *unit;
+	const char *unit;
 	double scale;
 
 	pmu = perf_pmu__find(name);
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index d9cab4d..b752ecb 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -105,7 +105,7 @@ static int perf_pmu__parse_scale(struct perf_pmu_alias *alias, char *dir, char *
 	char scale[128];
 	int fd, ret = -1;
 	char path[PATH_MAX];
-	char *lc;
+	const char *lc;
 
 	snprintf(path, PATH_MAX, "%s/%s.scale", dir, name);
 
@@ -609,7 +609,7 @@ static struct perf_pmu_alias *pmu_find_alias(struct perf_pmu *pmu,
 
 
 static int check_unit_scale(struct perf_pmu_alias *alias,
-			    char **unit, double *scale)
+			    const char **unit, double *scale)
 {
 	/*
 	 * Only one term in event definition can
@@ -634,14 +634,18 @@ static int check_unit_scale(struct perf_pmu_alias *alias,
  * defined for the alias
  */
 int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms,
-			  char **unit, double *scale)
+			  const char **unit, double *scale)
 {
 	struct parse_events_term *term, *h;
 	struct perf_pmu_alias *alias;
 	int ret;
 
+	/*
+	 * Mark unit and scale as not set
+	 * (different from default values, see below)
+	 */
 	*unit   = NULL;
-	*scale  = 0;
+	*scale  = 0.0;
 
 	list_for_each_entry_safe(term, h, head_terms, list) {
 		alias = pmu_find_alias(pmu, term);
@@ -658,6 +662,18 @@ int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms,
 		list_del(&term->list);
 		free(term);
 	}
+
+	/*
+	 * if no unit or scale foundin aliases, then
+	 * set defaults as for evsel
+	 * unit cannot left to NULL
+	 */
+	if (*unit == NULL)
+		*unit   = "";
+
+	if (*scale == 0.0)
+		*scale  = 1.0;
+
 	return 0;
 }
 
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 9183380..8b64125 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -29,7 +29,7 @@ int perf_pmu__config_terms(struct list_head *formats,
 			   struct perf_event_attr *attr,
 			   struct list_head *head_terms);
 int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms,
-			  char **unit, double *scale);
+			  const char **unit, double *scale);
 struct list_head *perf_pmu__alias(struct perf_pmu *pmu,
 				  struct list_head *head_terms);
 int perf_pmu_wrap(void);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 7acc03e..0b39a48 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1573,7 +1573,7 @@ next:
 int perf_session__cpu_bitmap(struct perf_session *session,
 			     const char *cpu_list, unsigned long *cpu_bitmap)
 {
-	int i;
+	int i, err = -1;
 	struct cpu_map *map;
 
 	for (i = 0; i < PERF_TYPE_MAX; ++i) {
@@ -1602,13 +1602,17 @@ int perf_session__cpu_bitmap(struct perf_session *session,
 		if (cpu >= MAX_NR_CPUS) {
 			pr_err("Requested CPU %d too large. "
 			       "Consider raising MAX_NR_CPUS\n", cpu);
-			return -1;
+			goto out_delete_map;
 		}
 
 		set_bit(cpu, cpu_bitmap);
 	}
 
-	return 0;
+	err = 0;
+
+out_delete_map:
+	cpu_map__delete(map);
+	return err;
 }
 
 void perf_session__fprintf_info(struct perf_session *session, FILE *fp,

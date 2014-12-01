Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbaLATHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:07:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754253AbaLATHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:07:06 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 4/8] perf buildid-cache: Add clean command
Date: Mon,  1 Dec 2014 20:06:25 +0100
Message-Id: <1417460789-13874-5-git-send-email-jolsa@kernel.org>
In-Reply-To: <1417460789-13874-1-git-send-email-jolsa@kernel.org>
References: <1417460789-13874-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'perf buildid-cache clean' command provides means to clean the cache
directory. Unless the '-r' option is specified it displays the contents
(with size) of the cache. You can also specify time or size limit as
a cache filer (see CLEAN LIMIT section).

User can specify size or time limit as a filter to display cache files.
The syntax of the limit is, time:
  $ perf buildid-cache clean 1d  # displays files older than 1 day
  $ perf buildid-cache clean 4w  # displays files older than 4 weeks
  $ perf buildid-cache clean 2m  # displays files older than 2 months
  $ perf buildid-cache clean 1y  # displays files older than 1 year

or size:
  $ perf buildid-cache clean 100B  # displays files with size >= 100 B
  $ perf buildid-cache clean 4K    # displays files with size >= 4 KB
  $ perf buildid-cache clean 2M    # displays files with size >= 2 MB
  $ perf buildid-cache clean 1G    # displays files with size >= 1 GB

Few examples:

Display cache files older than 3 days and sort them by time:
  $ perf buildid-cache clean --time 3d

Total cache removal:
  $ perf buildid-cache clean -r

Remove items older than 2 weeks
  $ perf buildid-cache clean -r 2w

Remove and display items bigger than 200M
  $ perf buildid-cache clean -r -a 200M

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/Documentation/perf-buildid-cache.txt |  59 +++
 tools/perf/builtin-buildid-cache.c              | 454 +++++++++++++++++++++++-
 2 files changed, 512 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-buildid-cache.txt b/tools/perf/Documentation/perf-buildid-cache.txt
index fd77d81ea748..dc605d4ee9e7 100644
--- a/tools/perf/Documentation/perf-buildid-cache.txt
+++ b/tools/perf/Documentation/perf-buildid-cache.txt
@@ -9,6 +9,7 @@ SYNOPSIS
 --------
 [verse]
 'perf buildid-cache <options>'
+'perf buildid-cache <options> clean [<options>] [limit]
 
 DESCRIPTION
 -----------
@@ -16,6 +17,11 @@ This command manages the build-id cache. It can add and remove files to/from
 the cache. In the future it should as well purge older entries, set upper
 limits for the space used by the cache, etc.
 
+The 'perf buildid-cache clean' command provides means to clean the cache
+directory. Unless the '-r' option is specified it displays the contents
+(with size) of the cache. You can also specify time or size limit as
+a cache filer (see CLEAN LIMIT section).
+
 OPTIONS
 -------
 -a::
@@ -48,6 +54,59 @@ OPTIONS
 --verbose::
 	Be more verbose.
 
+
+CLEAN OPTIONS
+-------------
+-a::
+--all::
+	Display each cache file separately.
+
+-r::
+--remove::
+	Remove all files displayed.
+
+--size::
+	Sort files by size (default).
+
+--time::
+	Sort files by time.
+
+-v::
+--verbose::
+	Be more verbose.
+
+
+CLEAN LIMIT
+-----------
+User can specify size or time limit as a filter to display cache files.
+The syntax of the limit is, time:
+  $ perf buildid-cache clean 1d  # displays files older than 1 day
+  $ perf buildid-cache clean 4w  # displays files older than 4 weeks
+  $ perf buildid-cache clean 2m  # displays files older than 2 months
+  $ perf buildid-cache clean 1y  # displays files older than 1 year
+
+or size:
+  $ perf buildid-cache clean 100B # displays files with size >= 100 B
+  $ perf buildid-cache clean 4K   # displays files with size >= 4 KB
+  $ perf buildid-cache clean 2M   # displays files with size >= 2 MB
+  $ perf buildid-cache clean 1G   # displays files with size >= 1 GB
+
+
+EXAMPLES
+--------
+Display cache files older than 3 days and sort them by time:
+$ perf buildid-cache clean --time 3d
+
+Total cache removal:
+$ perf buildid-cache clean -r
+
+Remove items older than 2 weeks
+$ perf buildid-cache clean -r 2w
+
+Remove and display items bigger than 200M
+$ perf buildid-cache clean -r -a 200M
+
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-report[1], linkperf:perf-buildid-list[1]
diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index 29f24c071bc6..184955ec8a83 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -8,9 +8,13 @@
  */
 #include <sys/types.h>
 #include <sys/time.h>
+#include <asm/bug.h>
+#include <linux/rbtree.h>
 #include <time.h>
 #include <dirent.h>
 #include <unistd.h>
+#include <ftw.h>
+#include <time.h>
 #include "builtin.h"
 #include "perf.h"
 #include "util/cache.h"
@@ -278,6 +282,450 @@ static int build_id_cache__update_file(const char *filename,
 	return err;
 }
 
+enum cache_sort {
+	CACHE_SORT__NONE,
+	CACHE_SORT__SIZE,
+	CACHE_SORT__TIME,
+};
+
+enum cache_disp {
+	CACHE_DISP__NONE,
+	CACHE_DISP__ALL,
+};
+
+enum cache_limit {
+	CACHE_LIMIT__NONE,
+	CACHE_LIMIT__SIZE,
+	CACHE_LIMIT__TIME,
+};
+
+enum cache_remove {
+	CACHE_REMOVE__NONE,
+	CACHE_REMOVE__SINGLE,
+	CACHE_REMOVE__TOTAL,
+};
+
+struct cache_file {
+	char		*path;
+	u64		 size;
+	time_t		 time;
+	struct rb_node	 rb_node;
+};
+
+static struct rb_root cache_files;
+static struct cache_file *cache_total;
+
+static enum cache_sort cache_sort     = CACHE_SORT__NONE;
+static enum cache_disp cache_disp     = CACHE_DISP__NONE;
+static enum cache_limit cache_limit   = CACHE_LIMIT__NONE;
+static enum cache_remove cache_remove = CACHE_REMOVE__NONE;
+
+static time_t cache_limit__time;
+static u64    cache_limit__size;
+
+static struct cache_file*
+cache_file__alloc(const char *path, const struct stat *st)
+{
+	struct cache_file *file = zalloc(sizeof(*file));
+
+	if (file) {
+		file->path = strdup(path);
+		file->size = st ? st->st_size : 0;
+		file->time = st ? st->st_atime : 0;
+		RB_CLEAR_NODE(&file->rb_node);
+	}
+	return file;
+}
+
+static void cache_file__release(struct cache_file *file)
+{
+	free(file->path);
+	free(file);
+}
+
+static int cmp_u64(u64 a, u64 b)
+{
+	return a > b ? -1 : a == b ? 0 : 1;
+}
+
+static int cache_file__cmp(struct cache_file *a, struct cache_file *b)
+{
+	switch (cache_sort) {
+	case CACHE_SORT__SIZE:
+		return cmp_u64(a->size, b->size);
+	case CACHE_SORT__TIME:
+		return cmp_u64((u64) a->time, (u64) b->time);
+	case CACHE_SORT__NONE:
+	default:
+		pr_err("internal cache_sort bug\n");
+	}
+	return 0;
+}
+
+static void cache_files__add(struct cache_file *file)
+{
+	struct rb_node **p = &cache_files.rb_node;
+	struct rb_node *parent = NULL;
+	struct cache_file *n;
+
+	while (*p != NULL) {
+		parent = *p;
+		n = rb_entry(parent, struct cache_file, rb_node);
+		if (cache_file__cmp(n, file) >= 0)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	rb_link_node(&file->rb_node, parent, p);
+	rb_insert_color(&file->rb_node, &cache_files);
+}
+
+typedef int (walk_cb_t)(struct cache_file *file, void *data);
+
+static int cache_files__walk(walk_cb_t cb, void *data)
+{
+	struct rb_node *nd;
+	int ret = 0;
+
+	for (nd = rb_first(&cache_files); !ret && nd; nd = rb_next(nd)) {
+		struct cache_file *n;
+
+		n = rb_entry(nd, struct cache_file, rb_node);
+		ret = cb(n, data);
+	}
+
+	return ret;
+}
+
+static int size_snprintf(u64 size, char *buf, int sz)
+{
+	struct {
+		int div;
+		const char *str;
+	} suffix[] = {
+		{ .str = "B", .div = 1 },
+		{ .str = "K", .div = 1024 },
+		{ .str = "M", .div = 1024*1024 },
+		{ .str = "G", .div = 1024*1024*1024 },
+	};
+	unsigned i;
+
+	for (i = 0; i < ARRAY_SIZE(suffix); i++) {
+		if (size / suffix[i].div < 1)
+			break;
+	}
+
+	i--;
+	return scnprintf(buf, sz, "%.1f%s",
+			 (double) (size / suffix[i].div), suffix[i].str);
+}
+
+static int date_snprintf(time_t t, char *buf, int sz)
+{
+	struct tm tm;
+
+	localtime_r(&t, &tm);
+	return strftime(buf, sz, "%b %d", &tm);
+}
+
+static int cache_file__fprintf(FILE *out, struct cache_file *file)
+{
+	char size_buf[100];
+	char date_buf[100];
+	int ret = 0;
+
+	if (cache_remove != CACHE_REMOVE__NONE)
+		ret += fprintf(out, "Removed ");
+
+	size_snprintf(file->size, size_buf, 100);
+	date_snprintf(file->time, date_buf, 100);
+	return ret + fprintf(out, "%10s  %6s  %s\n", size_buf, date_buf, file->path);
+}
+
+static int cache_file__process(struct cache_file *file, void *data)
+{
+	FILE *out = data;
+	int ret = 0;
+
+	if (cache_remove != CACHE_REMOVE__NONE)
+		ret = build_id_cache__remove_file(file->path, buildid_dir);
+
+	if (cache_disp == CACHE_DISP__ALL)
+		cache_file__fprintf(out, file);
+
+	return ret;
+}
+
+/*
+ * We want to go through each file only if we remove or
+ * display single files.
+ */
+static bool want_post_process(void)
+{
+	return (cache_remove == CACHE_REMOVE__SINGLE) ||
+	       (cache_disp == CACHE_DISP__ALL);
+}
+
+static int cache_files__process(FILE *out)
+{
+	int ret = 0;
+
+	/* Display total as first file/line. */
+	cache_file__fprintf(out, cache_total);
+
+	if (want_post_process())
+		ret = cache_files__walk(cache_file__process, out);
+
+	return ret;
+}
+
+static bool is_in_limit(const struct stat *st)
+{
+	bool in_limit = true;
+
+	switch (cache_limit) {
+	case CACHE_LIMIT__TIME:
+		in_limit = st->st_atime <= cache_limit__time;
+		break;
+	case CACHE_LIMIT__SIZE:
+		in_limit = (u64) st->st_size >= cache_limit__size;
+		break;
+	case CACHE_LIMIT__NONE:
+	default:
+		break;
+	};
+
+	return in_limit;
+}
+
+static int remove_file(const char *fpath, const struct stat *st)
+{
+	int ret;
+
+	if (S_ISDIR(st->st_mode))
+		ret = rmdir(fpath);
+	else
+		ret = unlink(fpath);
+
+	if (ret)
+		perror("failed to remove cache file");
+
+	return ret;
+}
+
+static int nftw_cb(const char *fpath, const struct stat *st,
+		   int typeflag __maybe_unused, struct FTW *ftwbuf)
+{
+	/* Do not touch the '.debug' directory itself. */
+	if (!ftwbuf->level)
+		return 0;
+
+	/*
+	 * Total cache wipe out handled right here. We try
+	 * to remove everything despite the possible removal
+	 * failures.
+	 */
+	if (cache_remove == CACHE_REMOVE__TOTAL) {
+		cache_total->size += st->st_size;
+
+		/* Ignore failure, remove as much as we can. */
+		remove_file(fpath, st);
+		return 0;
+	}
+
+	if (!is_in_limit(st))
+		return 0;
+
+	/* Sorting only regular files. */
+	if (want_post_process() && S_ISREG(st->st_mode)) {
+		struct cache_file *file;
+
+		file = cache_file__alloc(fpath, st);
+		if (!file)
+			return -1;
+
+		cache_files__add(file);
+	}
+
+	cache_total->size += st->st_size;
+	return 0;
+}
+
+static int cache_files__alloc(void)
+{
+	int flags = FTW_PHYS;
+	struct stat st;
+
+	if (stat(buildid_dir, &st)) {
+		pr_err("Failed to stat buildid directory %s.", buildid_dir);
+		return -1;
+	}
+
+	cache_total = cache_file__alloc(buildid_dir, &st);
+	if (!cache_total)
+		return -1;
+
+	/*
+	 * If we're going to remove all the files, switch the walk
+	 * files order to get inner directories/files first.  This
+	 * way we can remove them immediately.
+	 */
+	if (cache_remove == CACHE_REMOVE__TOTAL)
+		flags |= FTW_DEPTH;
+
+	return nftw(buildid_dir, nftw_cb, 0, flags);
+}
+
+static int cache_file__remove(struct cache_file *file,
+			      void *data __maybe_unused)
+{
+	rb_erase(&file->rb_node, &cache_files);
+	cache_file__release(file);
+	return 0;
+}
+
+static void cache_files__release(void)
+{
+	cache_files__walk(cache_file__remove, NULL);
+	cache_file__release(cache_total);
+}
+
+static int setup_limit(char *limit)
+{
+	struct suffix {
+		char s;
+		long m;
+	};
+	struct suffix suffix_time[] = {
+		{ .s = 'd', .m =   1*24*60*60 },
+		{ .s = 'w', .m =   7*24*60*60 },
+		{ .s = 'm', .m =  30*24*60*60 },
+		{ .s = 'y', .m = 365*24*60*60 },
+	};
+	struct suffix suffix_size[] = {
+		{ .s = 'B', .m = 1 },
+		{ .s = 'K', .m = 1*1024 },
+		{ .s = 'M', .m = 1*1024*1024 },
+		{ .s = 'G', .m = 1*1024*1024*1024 },
+	};
+	char *suffix;
+	long val;
+	unsigned i;
+
+	if (strlen(limit) < 2)
+		return -1;
+
+	val = strtol(limit, &suffix, 10);
+	if (!suffix)
+		return -1;
+
+	if (strlen(suffix) != 1)
+		return -1;
+
+	for (i = 0; i < ARRAY_SIZE(suffix_time); i++) {
+		char buf[100];
+
+		if (suffix_time[i].s != suffix[0])
+			continue;
+
+		val *= -1 * suffix_time[i].m;
+		val += time(0);
+		cache_limit__time = val;
+		cache_limit = CACHE_LIMIT__TIME;
+
+		date_snprintf(cache_limit__time, buf, sizeof(buf));
+		pr_debug("time limit: %s\n", buf);
+		return 0;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(suffix_size); i++) {
+		char buf[100];
+
+		if (suffix_size[i].s != suffix[0])
+			continue;
+
+		val *= suffix_size[i].m;
+		cache_limit__size = val;
+		cache_limit = CACHE_LIMIT__SIZE;
+
+		size_snprintf(cache_limit__size, buf, sizeof(buf));
+		pr_debug("size limit: %s\n", buf);
+		return 0;
+	}
+
+	return -1;
+}
+
+static int cmd_buildid_cache_clean(int argc, const char **argv)
+{
+	const struct option buildid_cache_clean_options[] = {
+	OPT_SET_UINT(0, "size", &cache_sort, "sort by size", CACHE_SORT__SIZE),
+	OPT_SET_UINT(0, "time", &cache_sort, "sort by time", CACHE_SORT__TIME),
+	OPT_SET_UINT('a', "all", &cache_disp, "display all files",
+		     CACHE_DISP__ALL),
+	OPT_SET_UINT('r', "remove", &cache_remove, "display all files",
+		     CACHE_REMOVE__SINGLE),
+	OPT_INCR('v', "verbose", &verbose, "be more verbose"),
+	OPT_END(),
+	};
+	const char * const buildid_cache_clean_usage[] = {
+		"perf buildid-cache clean [<options>]",
+		NULL,
+	};
+	int ret;
+
+	argc = parse_options(argc, argv, buildid_cache_clean_options,
+			     buildid_cache_clean_usage, 0);
+
+	/* Check if user specified a limit. */
+	if (argc) {
+		char *limit = (char *) argv[0];
+
+		if (argc != 1 || setup_limit(limit)) {
+			pr_err("Failed: unsupported limit '%s'\n", limit);
+			return -1;
+		}
+	}
+
+	/* Full removal is handled separately. */
+	if ((cache_remove == CACHE_REMOVE__SINGLE) &&
+	    (cache_limit  == CACHE_LIMIT__NONE)    &&
+	    (cache_disp   == CACHE_DISP__NONE)  &&
+	    (cache_sort   == CACHE_SORT__NONE))
+		cache_remove = CACHE_REMOVE__TOTAL;
+
+	/*
+	 * Sort by size by default and display all entries in case
+	 * --size or --time option is specified.
+	 */
+	if (cache_sort == CACHE_SORT__NONE)
+		cache_sort = CACHE_SORT__SIZE;
+	else
+		cache_disp = CACHE_DISP__ALL;
+
+	if (cache_remove == CACHE_REMOVE__NONE)
+		pr_warning("(mock mode, run with '-r' to actually remove data)\n");
+
+	ret = cache_files__alloc();
+	if (!ret)
+		cache_files__process(stderr);
+
+	cache_files__release();
+	return ret;
+}
+
+static int process_subcmd(int argc, const char **argv)
+{
+	const char *cmd = argv[0];
+
+	if (!strcmp(cmd, "clean"))
+		return cmd_buildid_cache_clean(argc, argv);
+
+	pr_err("Failed: unknown sub command '%s'\n", cmd);
+	return -EINVAL;
+}
+
 int cmd_buildid_cache(int argc, const char **argv,
 		      const char *prefix __maybe_unused)
 {
@@ -318,7 +766,8 @@ int cmd_buildid_cache(int argc, const char **argv,
 	};
 
 	argc = parse_options(argc, argv, buildid_cache_options,
-			     buildid_cache_usage, 0);
+			     buildid_cache_usage,
+			     PARSE_OPT_STOP_AT_NON_OPTION);
 
 	if (missing_filename) {
 		file.path = missing_filename;
@@ -399,5 +848,8 @@ out:
 	if (session)
 		perf_session__delete(session);
 
+	if (!ret && argc)
+		ret = process_subcmd(argc, argv);
+
 	return ret;
 }
-- 
1.9.3


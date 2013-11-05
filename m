Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab3KEULA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 15:11:00 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38838 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590Ab3KEUKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 15:10:18 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 07/10] perf fs: Rename NAME_find_mountpoint() to NAME__mountpoint()
Date: Tue,  5 Nov 2013 17:09:58 -0300
Message-Id: <1383682201-19399-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383682201-19399-1-git-send-email-acme@infradead.org>
References: <1383682201-19399-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Shorten it, "finding" it is an implementation detail, what callers want
is the pathname, not to ask for it to _always_ do the lookup.

And the existing implementation already caches it, i.e. it doesn't
"finds" it on every call.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-r24wa4bvtccg7mnkessrbbdj@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/parse-events.c |  4 ++--
 tools/perf/util/cpumap.c        |  4 ++--
 tools/perf/util/fs.c            | 12 ++++++------
 tools/perf/util/fs.h            |  2 +-
 tools/perf/util/pmu.c           | 15 +++++----------
 5 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index f47bf459c3f5..ef671cd41bb3 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -1456,7 +1456,7 @@ static int test_pmu(void)
 	int ret;
 
 	snprintf(path, PATH_MAX, "%s/bus/event_source/devices/cpu/format/",
-		 sysfs_find_mountpoint());
+		 sysfs__mountpoint());
 
 	ret = stat(path, &st);
 	if (ret)
@@ -1473,7 +1473,7 @@ static int test_pmu_events(void)
 	int ret;
 
 	snprintf(path, PATH_MAX, "%s/bus/event_source/devices/cpu/events/",
-		 sysfs_find_mountpoint());
+		 sysfs__mountpoint());
 
 	ret = stat(path, &st);
 	if (ret) {
diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index 4af5a23b2423..a9b48c42e81e 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -216,7 +216,7 @@ int cpu_map__get_socket(struct cpu_map *map, int idx)
 
 	cpu = map->map[idx];
 
-	mnt = sysfs_find_mountpoint();
+	mnt = sysfs__mountpoint();
 	if (!mnt)
 		return -1;
 
@@ -279,7 +279,7 @@ int cpu_map__get_core(struct cpu_map *map, int idx)
 
 	cpu = map->map[idx];
 
-	mnt = sysfs_find_mountpoint();
+	mnt = sysfs__mountpoint();
 	if (!mnt)
 		return -1;
 
diff --git a/tools/perf/util/fs.c b/tools/perf/util/fs.c
index a2413e842a02..77bac4e4c115 100644
--- a/tools/perf/util/fs.c
+++ b/tools/perf/util/fs.c
@@ -88,7 +88,7 @@ static const char *fs__get_mountpoint(struct fs *fs)
 	return fs__read_mounts(fs) ? fs->path : NULL;
 }
 
-static const char *fs__find_mountpoint(int idx)
+static const char *fs__mountpoint(int idx)
 {
 	struct fs *fs = &fs__entries[idx];
 
@@ -98,10 +98,10 @@ static const char *fs__find_mountpoint(int idx)
 	return fs__get_mountpoint(fs);
 }
 
-#define FIND_MOUNTPOINT(name, idx)		\
-const char *name##_find_mountpoint(void)	\
-{						\
-	return fs__find_mountpoint(idx);	\
+#define FS__MOUNTPOINT(name, idx)	\
+const char *name##__mountpoint(void)	\
+{					\
+	return fs__mountpoint(idx);	\
 }
 
-FIND_MOUNTPOINT(sysfs, FS__SYSFS);
+FS__MOUNTPOINT(sysfs, FS__SYSFS);
diff --git a/tools/perf/util/fs.h b/tools/perf/util/fs.h
index 082edbd2159b..a7561c83c33c 100644
--- a/tools/perf/util/fs.h
+++ b/tools/perf/util/fs.h
@@ -1,6 +1,6 @@
 #ifndef __PERF_FS
 #define __PERF_FS
 
-const char *sysfs_find_mountpoint(void);
+const char *sysfs__mountpoint(void);
 
 #endif /* __PERF_FS */
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 45b42dffcd70..c232d8dd410b 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -77,9 +77,8 @@ static int pmu_format(const char *name, struct list_head *format)
 {
 	struct stat st;
 	char path[PATH_MAX];
-	const char *sysfs;
+	const char *sysfs = sysfs__mountpoint();
 
-	sysfs = sysfs_find_mountpoint();
 	if (!sysfs)
 		return -1;
 
@@ -166,9 +165,8 @@ static int pmu_aliases(const char *name, struct list_head *head)
 {
 	struct stat st;
 	char path[PATH_MAX];
-	const char *sysfs;
+	const char *sysfs = sysfs__mountpoint();
 
-	sysfs = sysfs_find_mountpoint();
 	if (!sysfs)
 		return -1;
 
@@ -212,11 +210,10 @@ static int pmu_type(const char *name, __u32 *type)
 {
 	struct stat st;
 	char path[PATH_MAX];
-	const char *sysfs;
 	FILE *file;
 	int ret = 0;
+	const char *sysfs = sysfs__mountpoint();
 
-	sysfs = sysfs_find_mountpoint();
 	if (!sysfs)
 		return -1;
 
@@ -241,11 +238,10 @@ static int pmu_type(const char *name, __u32 *type)
 static void pmu_read_sysfs(void)
 {
 	char path[PATH_MAX];
-	const char *sysfs;
 	DIR *dir;
 	struct dirent *dent;
+	const char *sysfs = sysfs__mountpoint();
 
-	sysfs = sysfs_find_mountpoint();
 	if (!sysfs)
 		return;
 
@@ -270,11 +266,10 @@ static struct cpu_map *pmu_cpumask(const char *name)
 {
 	struct stat st;
 	char path[PATH_MAX];
-	const char *sysfs;
 	FILE *file;
 	struct cpu_map *cpus;
+	const char *sysfs = sysfs__mountpoint();
 
-	sysfs = sysfs_find_mountpoint();
 	if (!sysfs)
 		return NULL;
 
-- 
1.8.1.4


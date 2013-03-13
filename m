Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab3CMJnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 05:43:03 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:61357 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489Ab3CMJm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 05:42:59 -0400
From: chenggang <chenggang.qin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: chenggang <chenggang.qcg@taobao.com>, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v3 7/8]Perf: changed the method to traverse mmap list
Date: Wed, 13 Mar 2013 17:42:13 +0800
Message-Id: <1363167740-27735-2-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363167740-27735-1-git-send-email-chenggang.qin@gmail.com>
References: <1363167740-27735-1-git-send-email-chenggang.qin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: chenggang <chenggang.qcg@taobao.com>

Changed the method to traverse the evlist->mmap list. The evlist->mmap
list is traversed very frequently. So we need to be more efficient to do
it.

Cc: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Yanmin Zhang <yanmin.zhang@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chenggang Qin <chenggang.qcg@taobao.com>

---
 tools/perf/builtin-top.c                  |   11 ++++++-----
 tools/perf/tests/mmap-basic.c             |    4 +++-
 tools/perf/tests/open-syscall-tp-fields.c |    7 ++++---
 tools/perf/tests/perf-record.c            |    7 ++++---
 tools/perf/util/evlist.c                  |    4 ++--
 tools/perf/util/evlist.h                  |    3 ++-
 tools/perf/util/python.c                  |    4 +++-
 7 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 72f6eb7..cff58e5 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -800,7 +800,7 @@ static void perf_event__process_sample(struct perf_tool *tool,
 	return;
 }
 
-static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
+static void perf_top__mmap_read_idx(struct perf_top *top, struct perf_mmap *md)
 {
 	struct perf_sample sample;
 	struct perf_evsel *evsel;
@@ -810,7 +810,7 @@ static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
 	u8 origin;
 	int ret;
 
-	while ((event = perf_evlist__mmap_read(top->evlist, idx)) != NULL) {
+	while ((event = perf_evlist__mmap_read(top->evlist, md)) != NULL) {
 		ret = perf_evlist__parse_sample(top->evlist, event, &sample);
 		if (ret) {
 			pr_err("Can't parse sample, err = %d\n", ret);
@@ -867,10 +867,11 @@ static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
 
 static void perf_top__mmap_read(struct perf_top *top)
 {
-	int i;
+	struct perf_mmap *md;
 
-	for (i = 0; i < top->evlist->nr_mmaps; i++)
-		perf_top__mmap_read_idx(top, i);
+	for_each_mmap(md, top->evlist) {
+		perf_top__mmap_read_idx(top, md);
+	}
 }
 
 static int perf_top__start_counters(struct perf_top *top)
diff --git a/tools/perf/tests/mmap-basic.c b/tools/perf/tests/mmap-basic.c
index cdd5075..93639a8 100644
--- a/tools/perf/tests/mmap-basic.c
+++ b/tools/perf/tests/mmap-basic.c
@@ -19,6 +19,7 @@ int test__basic_mmap(void)
 {
 	int err = -1;
 	union perf_event *event;
+	struct perf_mmap *md;
 	struct thread_map *threads;
 	struct cpu_map *cpus;
 	struct perf_evlist *evlist;
@@ -97,7 +98,8 @@ int test__basic_mmap(void)
 			++foo;
 		}
 
-	while ((event = perf_evlist__mmap_read(evlist, 0)) != NULL) {
+	md = perf_evlist__get_mmap(evlist, 0);
+	while ((event = perf_evlist__mmap_read(evlist, md)) != NULL) {
 		struct perf_sample sample;
 
 		if (event->header.type != PERF_RECORD_SAMPLE) {
diff --git a/tools/perf/tests/open-syscall-tp-fields.c b/tools/perf/tests/open-syscall-tp-fields.c
index 39eb770..cb12e82 100644
--- a/tools/perf/tests/open-syscall-tp-fields.c
+++ b/tools/perf/tests/open-syscall-tp-fields.c
@@ -20,7 +20,7 @@ int test__syscall_open_tp_fields(void)
 	int flags = O_RDONLY | O_DIRECTORY;
 	struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
 	struct perf_evsel *evsel;
-	int err = -1, i, nr_events = 0, nr_polls = 0;
+	int err = -1, nr_events = 0, nr_polls = 0;
 
 	if (evlist == NULL) {
 		pr_debug("%s: perf_evlist__new\n", __func__);
@@ -66,11 +66,12 @@ int test__syscall_open_tp_fields(void)
 
 	while (1) {
 		int before = nr_events;
+		struct perf_mmap *md;
 
-		for (i = 0; i < evlist->nr_mmaps; i++) {
+		for_each_mmap(md, evlist) {
 			union perf_event *event;
 
-			while ((event = perf_evlist__mmap_read(evlist, i)) != NULL) {
+			while ((event = perf_evlist__mmap_read(evlist, md)) != NULL) {
 				const u32 type = event->header.type;
 				int tp_flags;
 				struct perf_sample sample;
diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
index 1e8e512..8aef6d2 100644
--- a/tools/perf/tests/perf-record.c
+++ b/tools/perf/tests/perf-record.c
@@ -56,7 +56,7 @@ int test__PERF_RECORD(void)
 	     found_libc_mmap = false,
 	     found_vdso_mmap = false,
 	     found_ld_mmap = false;
-	int err = -1, errs = 0, i, wakeups = 0;
+	int err = -1, errs = 0, wakeups = 0;
 	u32 cpu;
 	int total_events = 0, nr_events[PERF_RECORD_MAX] = { 0, };
 
@@ -158,11 +158,12 @@ int test__PERF_RECORD(void)
 
 	while (1) {
 		int before = total_events;
+		struct perf_mmap *md;
 
-		for (i = 0; i < evlist->nr_mmaps; i++) {
+		for_each_mmap(md, evlist) {
 			union perf_event *event;
 
-			while ((event = perf_evlist__mmap_read(evlist, i)) != NULL) {
+			while ((event = perf_evlist__mmap_read(evlist, md)) != NULL) {
 				const u32 type = event->header.type;
 				const char *name = perf_event__name(type);
 
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 74af9bb..25c3cb9 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -362,9 +362,9 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id)
 	return NULL;
 }
 
-union perf_event *perf_evlist__mmap_read(struct perf_evlist *evlist, int idx)
+union perf_event *perf_evlist__mmap_read(struct perf_evlist *evlist,
+					 struct perf_mmap *md)
 {
-	struct perf_mmap *md = perf_evlist__get_mmap(evlist, idx);
 	unsigned int head = perf_mmap__read_head(md);
 	unsigned int old = md->prev;
 	unsigned char *data = md->base + page_size;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 8693c11..1c74fa0 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -80,7 +80,8 @@ void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd);
 
 struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id);
 
-union perf_event *perf_evlist__mmap_read(struct perf_evlist *self, int idx);
+union perf_event *perf_evlist__mmap_read(struct perf_evlist *self,
+					 struct perf_mmap *md);
 
 int perf_evlist__open(struct perf_evlist *evlist);
 
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index e3f3f1b..91b00e8 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -789,6 +789,7 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 {
 	struct perf_evlist *evlist = &pevlist->evlist;
 	union perf_event *event;
+	struct perf_mmap *md;
 	int sample_id_all = 1, cpu;
 	static char *kwlist[] = { "cpu", "sample_id_all", NULL };
 	int err;
@@ -797,7 +798,8 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 					 &cpu, &sample_id_all))
 		return NULL;
 
-	event = perf_evlist__mmap_read(evlist, cpu);
+	md = perf_evlist__get_mmap(evlist, cpu);
+	event = perf_evlist__mmap_read(evlist, md);
 	if (event != NULL) {
 		PyObject *pyevent = pyrf_event__new(event);
 		struct pyrf_event *pevent = (struct pyrf_event *)pyevent;
-- 
1.7.9.5


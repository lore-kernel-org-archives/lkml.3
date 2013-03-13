Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab3CMJnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 05:43:45 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:64904 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506Ab3CMJnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 05:43:43 -0400
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
Subject: [PATCH v3 4/8]perf: Transform evsel->id to xyarray
Date: Wed, 13 Mar 2013 17:42:16 +0800
Message-Id: <1363167740-27735-5-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363167740-27735-1-git-send-email-chenggang.qin@gmail.com>
References: <1363167740-27735-1-git-send-email-chenggang.qin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: chenggang <chenggang.qcg@taobao.com>

Transform evsel->id to xyarray, so it is transformed to a linked list
instead an array.

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
 tools/perf/util/evlist.c |    4 +++-
 tools/perf/util/evsel.c  |   19 +++++++++++++++++--
 tools/perf/util/evsel.h  |    5 ++++-
 tools/perf/util/header.c |   28 ++++++++++++++++++----------
 tools/perf/util/header.h |    3 ++-
 5 files changed, 44 insertions(+), 15 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 7515651..c1cd8f9 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -287,8 +287,10 @@ static void perf_evlist__id_hash(struct perf_evlist *evlist,
 void perf_evlist__id_add(struct perf_evlist *evlist, struct perf_evsel *evsel,
 			 int cpu, int thread, u64 id)
 {
+	u64* idp = perf_evsel__get_id(evsel, -1);
 	perf_evlist__id_hash(evlist, evsel, cpu, thread, id);
-	evsel->id[evsel->ids++] = id;
+	*idp = id;
+	evsel->ids++;
 }
 
 static int perf_evlist__id_add_fd(struct perf_evlist *evlist,
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 57c569d..015321f 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -623,7 +623,7 @@ int perf_evsel__alloc_id(struct perf_evsel *evsel, int ncpus, int nthreads)
 	if (evsel->sample_id == NULL)
 		return -ENOMEM;
 
-	evsel->id = zalloc(ncpus * nthreads * sizeof(u64));
+	evsel->id = xyarray__new(1, ncpus * nthreads, sizeof(u64));
 	if (evsel->id == NULL) {
 		xyarray__delete(evsel->sample_id);
 		evsel->sample_id = NULL;
@@ -633,6 +633,21 @@ int perf_evsel__alloc_id(struct perf_evsel *evsel, int ncpus, int nthreads)
 	return 0;
 }
 
+void perf_evsel__id_new(struct perf_evsel *evsel, int nr)
+{
+	if (evsel->id)
+		xyarray__delete(evsel->id);
+
+	evsel->id = NULL;
+
+	evsel->id = xyarray__new(1, nr, sizeof(u64));
+}
+
+u64 *perf_evsel__get_id(struct perf_evsel *evsel, int idx)
+{
+	return (u64 *)xyarray__entry(evsel->id, 0, idx);
+}
+
 int perf_evsel__alloc_counts(struct perf_evsel *evsel, int ncpus)
 {
 	evsel->counts = zalloc((sizeof(*evsel->counts) +
@@ -650,7 +665,7 @@ void perf_evsel__free_id(struct perf_evsel *evsel)
 {
 	xyarray__delete(evsel->sample_id);
 	evsel->sample_id = NULL;
-	free(evsel->id);
+	xyarray__delete(evsel->id);
 	evsel->id = NULL;
 }
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 52021c3..7adb116 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -51,7 +51,7 @@ struct perf_evsel {
 	char			*filter;
 	struct xyarray		*fd;
 	struct xyarray		*sample_id;
-	u64			*id;
+	struct xyarray		*id;
 	struct perf_counts	*counts;
 	struct perf_counts	*prev_raw_counts;
 	int			idx;
@@ -125,6 +125,9 @@ void perf_evsel__free_id(struct perf_evsel *evsel);
 void perf_evsel__free_counts(struct perf_evsel *evsel);
 void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 
+void perf_evsel__id_new(struct perf_evsel *evsel, int nr);
+u64 *perf_evsel__get_id(struct perf_evsel *evsel, int idx);
+
 void __perf_evsel__set_sample_bit(struct perf_evsel *evsel,
 				  enum perf_event_sample_format bit);
 void __perf_evsel__reset_sample_bit(struct perf_evsel *evsel,
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index f4bfd79..d344e61 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1325,19 +1325,18 @@ read_event_desc(struct perf_header *ph, int fd)
 		if (!nr)
 			continue;
 
-		id = calloc(nr, sizeof(*id));
-		if (!id)
-			goto error;
 		evsel->ids = nr;
-		evsel->id = id;
+		perf_evsel__id_new(evsel, nr);
+		if (!evsel->id)
+			goto error;
 
 		for (j = 0 ; j < nr; j++) {
+			id = perf_evsel__get_id(evsel, j);
 			ret = readn(fd, id, sizeof(*id));
 			if (ret != (ssize_t)sizeof(*id))
 				goto error;
 			if (ph->needs_swap)
 				*id = bswap_64(*id);
-			id++;
 		}
 	}
 out:
@@ -1384,7 +1383,8 @@ static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
 
 		if (evsel->ids) {
 			fprintf(fp, ", id = {");
-			for (j = 0, id = evsel->id; j < evsel->ids; j++, id++) {
+			for (j = 0; j < evsel->ids; j++) {
+				id = perf_evsel__get_id(evsel, j);
 				if (j)
 					fputc(',', fp);
 				fprintf(fp, " %"PRIu64, *id);
@@ -2880,12 +2880,15 @@ out_delete_evlist:
 }
 
 int perf_event__synthesize_attr(struct perf_tool *tool,
-				struct perf_event_attr *attr, u32 ids, u64 *id,
+				struct perf_event_attr *attr,
+				struct perf_evsel *evsel,
 				perf_event__handler_t process)
 {
 	union perf_event *ev;
 	size_t size;
 	int err;
+	u32 ids = evsel->ids;
+	u32 i;
 
 	size = sizeof(struct perf_event_attr);
 	size = PERF_ALIGN(size, sizeof(u64));
@@ -2898,7 +2901,12 @@ int perf_event__synthesize_attr(struct perf_tool *tool,
 		return -ENOMEM;
 
 	ev->attr.attr = *attr;
-	memcpy(ev->attr.id, id, ids * sizeof(u64));
+	for (i = 0; i < ids; i++) {
+		u64 *id;
+
+		id = perf_evsel__get_id(evsel, i);
+		ev->attr.id[i] = *id;
+        }
 
 	ev->attr.header.type = PERF_RECORD_HEADER_ATTR;
 	ev->attr.header.size = (u16)size;
@@ -2921,8 +2929,8 @@ int perf_event__synthesize_attrs(struct perf_tool *tool,
 	int err = 0;
 
 	list_for_each_entry(evsel, &session->evlist->entries, node) {
-		err = perf_event__synthesize_attr(tool, &evsel->attr, evsel->ids,
-						  evsel->id, process);
+		err = perf_event__synthesize_attr(tool, &evsel->attr,
+						  evsel, process);
 		if (err) {
 			pr_debug("failed to create perf header attribute\n");
 			return err;
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index c9fc55c..60f85ca 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -126,7 +126,8 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir);
 
 int perf_event__synthesize_attr(struct perf_tool *tool,
-				struct perf_event_attr *attr, u32 ids, u64 *id,
+				struct perf_event_attr *attr,
+				struct perf_evsel *evsel,
 				perf_event__handler_t process);
 int perf_event__synthesize_attrs(struct perf_tool *tool,
 				 struct perf_session *session,
-- 
1.7.9.5


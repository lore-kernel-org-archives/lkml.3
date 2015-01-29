Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbbA2ITV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:19:21 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51144 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbbA2IKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:10:05 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 12/42] perf tools: Add HEADER_DATA_INDEX feature
Date: Thu, 29 Jan 2015 17:06:53 +0900
Message-Id: <1422518843-25818-13-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
References: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The HEADER_DATA_INDEX feature is to record index table for sample data
so that they can be processed by multiple thread concurrently.  Each
item is a struct perf_file_section which consists of an offset and size.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-data.c   |  0
 tools/perf/builtin-record.c |  2 ++
 tools/perf/util/header.c    | 61 +++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/header.h    |  3 +++
 4 files changed, 66 insertions(+)
 create mode 100644 tools/perf/builtin-data.c

diff --git a/tools/perf/builtin-data.c b/tools/perf/builtin-data.c
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 56118d8cf74a..b057e2caa5f1 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -312,6 +312,8 @@ static void record__init_features(struct record *rec)
 
 	if (!rec->opts.branch_stack)
 		perf_header__clear_feat(&session->header, HEADER_BRANCH_STACK);
+
+	perf_header__clear_feat(&session->header, HEADER_DATA_INDEX);
 }
 
 static volatile int workload_exec_errno;
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 1f407f7352a7..77206a6cbf65 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -869,6 +869,24 @@ static int write_branch_stack(int fd __maybe_unused,
 	return 0;
 }
 
+static int write_data_index(int fd, struct perf_header *h,
+			    struct perf_evlist *evlist __maybe_unused)
+{
+	int ret;
+	unsigned i;
+
+	ret = do_write(fd, &h->nr_index, sizeof(h->nr_index));
+	if (ret < 0)
+		return ret;
+
+	for (i = 0; i < h->nr_index; i++) {
+		ret = do_write(fd, &h->index[i], sizeof(*h->index));
+		if (ret < 0)
+			return ret;
+	}
+	return 0;
+}
+
 static void print_hostname(struct perf_header *ph, int fd __maybe_unused,
 			   FILE *fp)
 {
@@ -1225,6 +1243,12 @@ static void print_group_desc(struct perf_header *ph, int fd __maybe_unused,
 	}
 }
 
+static void print_data_index(struct perf_header *ph __maybe_unused,
+			     int fd __maybe_unused, FILE *fp)
+{
+	fprintf(fp, "# contains data index for parallel processing\n");
+}
+
 static int __event_process_build_id(struct build_id_event *bev,
 				    char *filename,
 				    struct perf_session *session)
@@ -1833,6 +1857,42 @@ static int process_group_desc(struct perf_file_section *section __maybe_unused,
 	return ret;
 }
 
+static int process_data_index(struct perf_file_section *section __maybe_unused,
+			      struct perf_header *ph, int fd,
+			      void *data __maybe_unused)
+{
+	ssize_t ret;
+	u64 nr_index;
+	unsigned i;
+	struct perf_file_section *index;
+
+	ret = readn(fd, &nr_index, sizeof(nr_index));
+	if (ret != sizeof(nr_index))
+		return -1;
+
+	if (ph->needs_swap)
+		nr_index = bswap_64(nr_index);
+
+	index = calloc(nr_index, sizeof(*index));
+	if (index == NULL)
+		return -1;
+
+	for (i = 0; i < nr_index; i++) {
+		ret = readn(fd, &index[i], sizeof(*index));
+		if (ret != sizeof(*index))
+			return ret;
+
+		if (ph->needs_swap) {
+			index[i].offset = bswap_64(index[i].offset);
+			index[i].size   = bswap_64(index[i].size);
+		}
+	}
+
+	ph->index = index;
+	ph->nr_index = nr_index;
+	return 0;
+}
+
 struct feature_ops {
 	int (*write)(int fd, struct perf_header *h, struct perf_evlist *evlist);
 	void (*print)(struct perf_header *h, int fd, FILE *fp);
@@ -1873,6 +1933,7 @@ static const struct feature_ops feat_ops[HEADER_LAST_FEATURE] = {
 	FEAT_OPA(HEADER_BRANCH_STACK,	branch_stack),
 	FEAT_OPP(HEADER_PMU_MAPPINGS,	pmu_mappings),
 	FEAT_OPP(HEADER_GROUP_DESC,	group_desc),
+	FEAT_OPP(HEADER_DATA_INDEX,	data_index),
 };
 
 struct header_print_data {
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 3bb90ac172a1..e5594f0d6dcd 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -30,6 +30,7 @@ enum {
 	HEADER_BRANCH_STACK,
 	HEADER_PMU_MAPPINGS,
 	HEADER_GROUP_DESC,
+	HEADER_DATA_INDEX,
 	HEADER_LAST_FEATURE,
 	HEADER_FEAT_BITS	= 256,
 };
@@ -94,6 +95,8 @@ struct perf_header {
 	bool				needs_swap;
 	u64				data_offset;
 	u64				data_size;
+	struct perf_file_section	*index;
+	u64				nr_index;
 	u64				feat_offset;
 	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
 	struct perf_session_env 	env;
-- 
2.2.2


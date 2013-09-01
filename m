Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab3IAKil (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 06:38:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755781Ab3IAKij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 06:38:39 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 17/25] perf tools: Add perf.data version 3 header write
Date: Sun,  1 Sep 2013 12:36:28 +0200
Message-Id: <1378031796-17892-18-git-send-email-jolsa@redhat.com>
In-Reply-To: <1378031796-17892-1-git-send-email-jolsa@redhat.com>
References: <1378031796-17892-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding perf data version 3 header write code and
switch perf tool storing to version 3.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/Documentation/perf-data-file-v2.txt |  5 +-
 tools/perf/builtin-inject.c                    |  3 +-
 tools/perf/builtin-record.c                    |  5 +-
 tools/perf/tests/session-simple.c              |  4 +-
 tools/perf/util/header.c                       | 70 ++++++++------------------
 tools/perf/util/header.h                       |  6 ++-
 6 files changed, 36 insertions(+), 57 deletions(-)

diff --git a/tools/perf/Documentation/perf-data-file-v2.txt b/tools/perf/Documentation/perf-data-file-v2.txt
index f5c1d5b8..0d29753 100644
--- a/tools/perf/Documentation/perf-data-file-v2.txt
+++ b/tools/perf/Documentation/perf-data-file-v2.txt
@@ -8,8 +8,9 @@ perf-data-file-v2 - The perf tool file format version 2
 
 DESCRIPTION
 -----------
-Following text describes version 2 of the perf data file format,
-which is version that is currently used by perf tool.
+Following text describes version 2 of the perf data file format.
+The perf tool supports this format for reading, but for writing
+it uses version 3 format perf-data-file-v3(1).
 
 The perf data file format is composed of several sections
 describing monitored events and the data itself.
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 9b336fd..6dd8ed1 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -376,7 +376,8 @@ static int __cmd_inject(struct perf_inject *inject)
 
 	if (!inject->pipe_output) {
 		session->header.data_size = inject->bytes_written;
-		perf_session__write_header(session, session->evlist, inject->output, true);
+		perf_session__write_header(session, session->evlist,
+					   inject->output);
 	}
 
 	perf_session__delete(session);
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 351ede3..fdbcd51 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -273,7 +273,7 @@ static void perf_record__exit(int status, void *arg)
 		if (!rec->no_buildid)
 			process_buildids(rec);
 		perf_session__write_header(rec->session, rec->evlist,
-					   rec->output, true);
+					   rec->output);
 		perf_session__delete(rec->session);
 		perf_evlist__delete(rec->evlist);
 		symbol__exit();
@@ -444,8 +444,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		if (err < 0)
 			goto out_delete_session;
 	} else {
-		err = perf_session__write_header(session, evsel_list,
-						 output, false);
+		err = perf_session__prepare_header(output);
 		if (err < 0)
 			goto out_delete_session;
 	}
diff --git a/tools/perf/tests/session-simple.c b/tools/perf/tests/session-simple.c
index 4f58c0f..215b6dc 100644
--- a/tools/perf/tests/session-simple.c
+++ b/tools/perf/tests/session-simple.c
@@ -480,7 +480,7 @@ static int session_write(char *file)
 	perf_header__clear_feat(&session->header, HEADER_BRANCH_STACK);
 
 	TEST_ASSERT_VAL("failed to write header",
-		!perf_session__write_header(session, evlist, fd, false));
+		!perf_session__prepare_header(fd));
 
 #define STORE_EVENTS(str, func, cnt)				\
 do {								\
@@ -520,7 +520,7 @@ do {								\
 	session->header.data_size += size;
 
 	TEST_ASSERT_VAL("failed to write header",
-		!perf_session__write_header(session, evlist, fd, true));
+		!perf_session__write_header(session, evlist, fd));
 
 	perf_session__delete(session);
 	perf_evlist__delete(evlist);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 0bf0164..36206b5 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -44,7 +44,7 @@ static const u64 __perf_magic2_sw = 0x50455246494c4532ULL;
 static const u64 __perf_magic3    = 0x33454c4946524550ULL;
 static const u64 __perf_magic3_sw = 0x50455246494c4533ULL;
 
-#define PERF_MAGIC	__perf_magic2
+#define PERF_MAGIC	__perf_magic3
 
 struct perf_file_attr {
 	struct perf_event_attr	attr;
@@ -2240,6 +2240,7 @@ static int perf_header__adds_write(struct perf_header *header,
 			perf_header__clear_feat(header, feat);
 	}
 
+	header->feat_size = lseek(fd, 0, SEEK_CUR) - sec_start;
 	lseek(fd, sec_start, SEEK_SET);
 	/*
 	 * may write more than needed due to dropped feature, but
@@ -2271,72 +2272,45 @@ int perf_header__write_pipe(int fd)
 	return 0;
 }
 
+int perf_session__prepare_header(int fd)
+{
+	off_t off = lseek(fd, PERF_FILE_HEADER__DATA_OFFSET, SEEK_SET);
+	return off == PERF_FILE_HEADER__DATA_OFFSET ? 0 : -1;
+}
+
 int perf_session__write_header(struct perf_session *session,
 			       struct perf_evlist *evlist,
-			       int fd, bool at_exit)
+			       int fd)
 {
 	struct perf_file_header f_header;
 	struct perf_file_attr   f_attr;
 	struct perf_header *header = &session->header;
-	struct perf_evsel *evsel;
-	u64 attr_offset;
 	int err;
 
-	lseek(fd, sizeof(f_header), SEEK_SET);
-
-	list_for_each_entry(evsel, &evlist->entries, node) {
-		evsel->id_offset = lseek(fd, 0, SEEK_CUR);
-		err = do_write(fd, evsel->id, evsel->ids * sizeof(u64));
-		if (err < 0) {
-			pr_debug("failed to write perf header\n");
-			return err;
-		}
-	}
-
-	attr_offset = lseek(fd, 0, SEEK_CUR);
-
-	list_for_each_entry(evsel, &evlist->entries, node) {
-		f_attr = (struct perf_file_attr){
-			.attr = evsel->attr,
-			.ids  = {
-				.offset = evsel->id_offset,
-				.size   = evsel->ids * sizeof(u64),
-			}
-		};
-		err = do_write(fd, &f_attr, sizeof(f_attr));
-		if (err < 0) {
-			pr_debug("failed to write perf header attribute\n");
-			return err;
-		}
-	}
-
-	header->data_offset = lseek(fd, 0, SEEK_CUR);
-	header->feat_offset = header->data_offset + header->data_size;
+	header->feat_offset = PERF_FILE_HEADER__DATA_OFFSET +
+			      header->data_size;
 
-	if (at_exit) {
-		err = perf_header__adds_write(header, evlist, fd);
-		if (err < 0)
-			return err;
-	}
+	err = perf_header__adds_write(header, evlist, fd);
+	if (err < 0)
+		return err;
 
 	f_header = (struct perf_file_header){
 		.magic	   = PERF_MAGIC,
 		.size	   = sizeof(f_header),
 		.attr_size = sizeof(f_attr),
-		.v2        = {
-			.attrs = {
-				.offset = attr_offset,
-				.size   = evlist->nr_entries * sizeof(f_attr),
-			},
+		.v3        = {
 			.data = {
-				.offset = header->data_offset,
+				.offset = PERF_FILE_HEADER__DATA_OFFSET,
 				.size	= header->data_size,
 			},
-		/* event_types is ignored, store zeros */
+			.features = {
+				.offset = header->feat_offset,
+				.size   = header->feat_size,
+			},
 		},
 	};
 
-	memcpy(&f_header.v2.adds_features, &header->adds_features,
+	memcpy(&f_header.v3.adds_features, &header->adds_features,
 	       sizeof(header->adds_features));
 
 	lseek(fd, 0, SEEK_SET);
@@ -2345,7 +2319,6 @@ int perf_session__write_header(struct perf_session *session,
 		pr_debug("failed to write perf header\n");
 		return err;
 	}
-	lseek(fd, header->data_offset + header->data_size, SEEK_SET);
 
 	return 0;
 }
@@ -2880,6 +2853,7 @@ static int perf_session__read_header_v3(struct perf_session *session,
 	ph->data_offset  = v3->data.offset;
 	ph->data_size	 = v3->data.size;
 	ph->feat_offset  = v3->features.offset;
+	ph->feat_size    = v3->features.size;
 
 	perf_header__process_sections(ph, session->fd, &session->pevent,
 				      perf_file_section__process);
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index bcd3e64..4982e04 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -53,6 +53,8 @@ struct perf_file_header_v2 {
 	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
 };
 
+#define PERF_FILE_HEADER__DATA_OFFSET (sizeof(struct perf_file_header))
+
 struct perf_file_header_v3 {
 	struct perf_file_section	data;
 	struct perf_file_section	features;
@@ -111,6 +113,7 @@ struct perf_header {
 	u64				data_offset;
 	u64				data_size;
 	u64				feat_offset;
+	u64				feat_size;
 	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
 	struct perf_session_env 	env;
 };
@@ -119,9 +122,10 @@ struct perf_evlist;
 struct perf_session;
 
 int perf_session__read_header(struct perf_session *session);
+int perf_session__prepare_header(int fd);
 int perf_session__write_header(struct perf_session *session,
 			       struct perf_evlist *evlist,
-			       int fd, bool at_exit);
+			       int fd);
 int perf_header__write_pipe(int fd);
 
 void perf_header__set_feat(struct perf_header *header, int feat);
-- 
1.7.11.7


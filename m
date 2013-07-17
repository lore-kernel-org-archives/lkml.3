Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934073Ab3GQRu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:50:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933394Ab3GQRuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:50:55 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 11/23] perf tools: Separate version 2 specific perf data header bits
Date: Wed, 17 Jul 2013 19:49:51 +0200
Message-Id: <1374083403-14591-12-git-send-email-jolsa@redhat.com>
In-Reply-To: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separating version 2 specific perf data header bits,
so the code could be extented with new format version.

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
 tools/perf/util/header.c | 120 ++++++++++++++++++++++++++++++-----------------
 tools/perf/util/header.h |  16 +++++--
 2 files changed, 90 insertions(+), 46 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index eb50de8..17084a1 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2316,18 +2316,20 @@ int perf_session__write_header(struct perf_session *session,
 		.magic	   = PERF_MAGIC,
 		.size	   = sizeof(f_header),
 		.attr_size = sizeof(f_attr),
-		.attrs = {
-			.offset = attr_offset,
-			.size   = evlist->nr_entries * sizeof(f_attr),
-		},
-		.data = {
-			.offset = header->data_offset,
-			.size	= header->data_size,
-		},
+		.v2        = {
+			.attrs = {
+				.offset = attr_offset,
+				.size   = evlist->nr_entries * sizeof(f_attr),
+			},
+			.data = {
+				.offset = header->data_offset,
+				.size	= header->data_size,
+			},
 		/* event_types is ignored, store zeros */
+		},
 	};
 
-	memcpy(&f_header.adds_features, &header->adds_features, sizeof(header->adds_features));
+	memcpy(&f_header.v2.adds_features, &header->adds_features, sizeof(header->adds_features));
 
 	lseek(fd, 0, SEEK_SET);
 	err = do_write(fd, &f_header, sizeof(f_header));
@@ -2545,22 +2547,34 @@ static void swap_features(unsigned long *adds_features)
 	}
 }
 
-static int swap_header(struct perf_file_header *header)
+static int swap_header_v2(struct perf_file_header *header)
 {
-	mem_bswap_64(header, offsetof(struct perf_file_header, adds_features));
+	struct perf_file_header_v2 *v2 = &header->v2;
+
+	mem_bswap_64(v2, offsetof(struct perf_file_header_v2,
+		     adds_features));
 
 	if (header->size != sizeof(*header)) {
 		/* Support the previous format */
-		if (header->size == offsetof(typeof(*header), adds_features))
-			bitmap_zero(header->adds_features, HEADER_FEAT_BITS);
+		if (header->size == offsetof(typeof(*header), v2.adds_features))
+			bitmap_zero(v2->adds_features, HEADER_FEAT_BITS);
 		else
 			return -1;
 	} else
-		swap_features(header->adds_features);
+		swap_features(v2->adds_features);
 
 	return 0;
 }
 
+static int swap_header(struct perf_file_header *header)
+{
+	/* swap the generic part */
+	mem_bswap_64(header, offsetof(struct perf_file_header, v2));
+
+	/* version specific swap */
+	return swap_header_v2(header);
+}
+
 int perf_file_header__read(struct perf_file_header *header,
 			   struct perf_header *ph, int fd)
 {
@@ -2578,16 +2592,7 @@ int perf_file_header__read(struct perf_file_header *header,
 		return -1;
 	}
 
-	if (ph->needs_swap && swap_header(header))
-		return -1;
-
-	memcpy(&ph->adds_features, &header->adds_features,
-	       sizeof(ph->adds_features));
-
-	ph->data_offset  = header->data.offset;
-	ph->data_size	 = header->data.size;
-	ph->feat_offset  = header->data.offset + header->data.size;
-	return 0;
+	return ph->needs_swap ? swap_header(header) : 0;
 }
 
 static int perf_file_section__process(struct perf_file_section *section,
@@ -2739,12 +2744,13 @@ static int perf_evlist__prepare_tracepoint_events(struct perf_evlist *evlist,
 	return 0;
 }
 
-int perf_session__read_header(struct perf_session *session)
+static int __perf_session__read_header_v2(struct perf_session *session,
+					  struct perf_file_header *header)
 {
-	struct perf_header *header = &session->header;
-	struct perf_file_header	f_header;
-	struct perf_file_attr	f_attr;
-	u64			f_id;
+	struct perf_header		*ph = &session->header;
+	struct perf_file_header_v2	*v2 = &header->v2;
+	struct perf_file_attr		f_attr;
+	u64				f_id;
 	int nr_attrs, nr_ids, i, j;
 	int fd = session->fd;
 
@@ -2752,23 +2758,17 @@ int perf_session__read_header(struct perf_session *session)
 	if (session->evlist == NULL)
 		return -ENOMEM;
 
-	if (session->fd_pipe)
-		return perf_header__read_pipe(session);
-
-	if (perf_file_header__read(&f_header, header, fd) < 0)
-		return -EINVAL;
-
-	nr_attrs = f_header.attrs.size / f_header.attr_size;
-	lseek(fd, f_header.attrs.offset, SEEK_SET);
+	nr_attrs = v2->attrs.size / header->attr_size;
+	lseek(fd, v2->attrs.offset, SEEK_SET);
 
 	for (i = 0; i < nr_attrs; i++) {
 		struct perf_evsel *evsel;
 		off_t tmp;
 
-		if (read_attr(fd, header, &f_attr) < 0)
+		if (read_attr(fd, ph, &f_attr) < 0)
 			goto out_errno;
 
-		if (header->needs_swap)
+		if (ph->needs_swap)
 			perf_event__attr_swap(&f_attr.attr);
 
 		tmp = lseek(fd, 0, SEEK_CUR);
@@ -2777,7 +2777,7 @@ int perf_session__read_header(struct perf_session *session)
 		if (evsel == NULL)
 			goto out_delete_evlist;
 
-		evsel->needs_swap = header->needs_swap;
+		evsel->needs_swap = ph->needs_swap;
 		/*
 		 * Do it before so that if perf_evsel__alloc_id fails, this
 		 * entry gets purged too at perf_evlist__delete().
@@ -2796,7 +2796,7 @@ int perf_session__read_header(struct perf_session *session)
 		lseek(fd, f_attr.ids.offset, SEEK_SET);
 
 		for (j = 0; j < nr_ids; j++) {
-			if (perf_header__getbuffer64(header, fd, &f_id, sizeof(f_id)))
+			if (perf_header__getbuffer64(ph, fd, &f_id, sizeof(f_id)))
 				goto out_errno;
 
 			perf_evlist__id_add(session->evlist, evsel, 0, j, f_id);
@@ -2807,7 +2807,7 @@ int perf_session__read_header(struct perf_session *session)
 
 	symbol_conf.nr_events = nr_attrs;
 
-	perf_header__process_sections(header, fd, &session->pevent,
+	perf_header__process_sections(ph, fd, &session->pevent,
 				      perf_file_section__process);
 
 	if (perf_evlist__prepare_tracepoint_events(session->evlist,
@@ -2824,6 +2824,42 @@ out_delete_evlist:
 	return -ENOMEM;
 }
 
+
+static int perf_session__read_header_v2(struct perf_session *session,
+					struct perf_file_header *header)
+{
+	struct perf_header *ph = &session->header;
+	struct perf_file_header_v2 *v2 = &header->v2;
+
+	memcpy(&ph->adds_features, &v2->adds_features,
+	       sizeof(ph->adds_features));
+
+	ph->data_offset  = v2->data.offset;
+	ph->data_size	 = v2->data.size;
+	ph->feat_offset  = v2->data.offset + v2->data.size;
+
+	return __perf_session__read_header_v2(session, header);
+}
+
+static int perf_header_read_file(struct perf_session *session)
+{
+	struct perf_file_header header;
+
+	if (perf_file_header__read(&header, &session->header, session->fd))
+		return -1;
+
+	/* read v2 specific data */
+	return perf_session__read_header_v2(session, &header);
+}
+
+int perf_session__read_header(struct perf_session *session)
+{
+	if (session->fd_pipe)
+		return perf_header__read_pipe(session);
+
+	return perf_header_read_file(session) < 0 ? -EINVAL : 0;
+}
+
 int perf_event__synthesize_attr(struct perf_tool *tool,
 				struct perf_event_attr *attr, u32 ids, u64 *id,
 				perf_event__handler_t process)
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 307c9ae..c6ea4603 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -44,10 +44,7 @@ struct perf_file_section {
 	u64 size;
 };
 
-struct perf_file_header {
-	u64				magic;
-	u64				size;
-	u64				attr_size;
+struct perf_file_header_v2 {
 	struct perf_file_section	attrs;
 	struct perf_file_section	data;
 	/* event_types is ignored */
@@ -55,6 +52,17 @@ struct perf_file_header {
 	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
 };
 
+struct perf_file_header {
+	u64	magic;
+	u64	size;
+	u64	attr_size;
+
+	/* version specific data */
+	union {
+		struct perf_file_header_v2 v2;
+	};
+};
+
 struct perf_pipe_file_header {
 	u64				magic;
 	u64				size;
-- 
1.7.11.7


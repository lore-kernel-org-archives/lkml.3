Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964855Ab3GQRx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:53:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934010Ab3GQRvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:51:13 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 15/23] perf tools: Add perf data version 3 header read
Date: Wed, 17 Jul 2013 19:49:55 +0200
Message-Id: <1374083403-14591-16-git-send-email-jolsa@redhat.com>
In-Reply-To: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding perf data version 3 header read code to load
data for v3 format.

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
 tools/perf/util/header.c | 48 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 41 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 5df73da..50f0d9a 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1777,17 +1777,28 @@ process_event_desc(struct perf_file_section *section __maybe_unused,
 	struct perf_session *session;
 	struct perf_evlist *evlist;
 	struct perf_evsel *evsel;
+	struct perf_header *ph;
+
+	session = container_of(header, struct perf_session, header);
+	if (session->evlist)
+		return 0;
 
 	evlist = read_event_desc(header, fd);
 	if (!evlist)
-		return 0;
+		return -1;
 
-	session = container_of(header, struct perf_session, header);
+	ph = &session->header;
 
-	list_for_each_entry(evsel, &evlist->entries, node)
-		perf_evlist__set_event_name(session->evlist, evsel);
+	if (ph->version <= PERF_HEADER_VERSION_2) {
+		list_for_each_entry(evsel, &evlist->entries, node)
+			perf_evlist__set_event_name(session->evlist, evsel);
+
+		perf_evlist__delete(evlist);
+	} else {
+		session->evlist = evlist;
+		symbol_conf.nr_events = evlist->nr_entries;
+	}
 
-	perf_evlist__delete(evlist);
 	return 0;
 }
 
@@ -2854,15 +2865,38 @@ static int perf_session__read_header_v2(struct perf_session *session,
 	return __perf_session__read_header_v2(session, header);
 }
 
+static int perf_session__read_header_v3(struct perf_session *session,
+					struct perf_file_header *header)
+{
+	struct perf_header *ph = &session->header;
+	struct perf_file_header_v3 *v3 = &header->v3;
+
+	memcpy(&ph->adds_features, &v3->adds_features,
+	       sizeof(ph->adds_features));
+
+	ph->data_offset  = v3->data.offset;
+	ph->data_size	 = v3->data.size;
+	ph->feat_offset  = v3->features.offset;
+
+	perf_header__process_sections(ph, session->fd, &session->pevent,
+				      perf_file_section__process);
+
+	return 0;
+}
+
 static int perf_header_read_file(struct perf_session *session)
 {
 	struct perf_file_header header;
+	struct perf_header *ph = &session->header;
 
 	if (perf_file_header__read(&header, &session->header, session->fd))
 		return -1;
 
-	/* read v2 specific data */
-	return perf_session__read_header_v2(session, &header);
+	/* read version specific data */
+	if (ph->version <= PERF_HEADER_VERSION_2)
+		return perf_session__read_header_v2(session, &header);
+
+	return perf_session__read_header_v3(session, &header);
 }
 
 int perf_session__read_header(struct perf_session *session)
-- 
1.7.11.7


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab3JBNrF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 09:47:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837Ab3JBNrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 09:47:01 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] perf tools: Fix perf_evlist__mmap_read event overflow
Date: Wed,  2 Oct 2013 15:46:39 +0200
Message-Id: <1380721599-24285-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf_evlist__mmap_read used 'union perf_event'
as a placeholder for event crossing the mmap boundary.

This is ok for sample shorter than ~PATH_MAX. However
we could grow up to the maximum sample size which is
16 bits max.

I hit this overflow issue when using 'perf top -G dwarf'
which produces sample with the size around 8192 bytes.
We could configure any valid sample size here using:
'-G dwarf,size'.

Using array with sample max size instead for the event
placeholder. Also adding another safe check for the
dynamic size of the user stack.

TODO: The 'struct perf_mmap' is quite big now, maybe we
could use some lazy allocation for event_copy size.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/util/event.h  | 3 +++
 tools/perf/util/evlist.c | 4 ++--
 tools/perf/util/evlist.h | 2 +-
 tools/perf/util/evsel.c  | 3 +++
 4 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 9f50f88..2b8032a 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -75,6 +75,9 @@ struct throttle_event {
 	 PERF_SAMPLE_CPU | PERF_SAMPLE_PERIOD |		\
 	 PERF_SAMPLE_IDENTIFIER)
 
+/* perf sample has 16 bits size limit */
+#define PERF_SAMPLE_MAX_SIZE (1 << 16)
+
 struct sample_event {
 	struct perf_event_header        header;
 	u64 array[];
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index f0d71a9..cb9523f 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -540,7 +540,7 @@ union perf_event *perf_evlist__mmap_read(struct perf_evlist *evlist, int idx)
 		if ((old & md->mask) + size != ((old + size) & md->mask)) {
 			unsigned int offset = old;
 			unsigned int len = min(sizeof(*event), size), cpy;
-			void *dst = &md->event_copy;
+			void *dst = md->event_copy;
 
 			do {
 				cpy = min(md->mask + 1 - (offset & md->mask), len);
@@ -550,7 +550,7 @@ union perf_event *perf_evlist__mmap_read(struct perf_evlist *evlist, int idx)
 				len -= cpy;
 			} while (len);
 
-			event = &md->event_copy;
+			event = (union perf_event *) md->event_copy;
 		}
 
 		old += size;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 871b55a..722618f 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -21,7 +21,7 @@ struct perf_mmap {
 	void		 *base;
 	int		 mask;
 	unsigned int	 prev;
-	union perf_event event_copy;
+	char		 event_copy[PERF_SAMPLE_MAX_SIZE];
 };
 
 struct perf_evlist {
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 0ce9feb..aa20ee2 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1453,6 +1453,9 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 			array = (void *)array + sz;
 			OVERFLOW_CHECK_u64(array);
 			data->user_stack.size = *array++;
+			if (WARN_ONCE(data->user_stack.size > sz,
+				      "user stack dump failure\n"))
+				return -EFAULT;
 		}
 	}
 
-- 
1.7.11.7


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758442Ab3JNUOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:14:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39101 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757760Ab3JNUDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:08 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 119/161] perf evlist: Fix perf_evlist__mmap_read event overflow
Date: Mon, 14 Oct 2013 17:01:48 -0300
Message-Id: <1381780950-25642-120-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

The perf_evlist__mmap_read used 'union perf_event' as a placeholder for
event crossing the mmap boundary.

This is ok for sample shorter than ~PATH_MAX. However we could grow up
to the maximum sample size which is 16 bits max.

I hit this overflow issue when using 'perf top -G dwarf' which produces
sample with the size around 8192 bytes.  We could configure any valid
sample size here using: '-G dwarf,size'.

Using array with sample max size instead for the event placeholder. Also
adding another safe check for the dynamic size of the user stack.

TODO: The 'struct perf_mmap' is quite big now, maybe we could use some
lazy allocation for event_copy size.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1380721599-24285-1-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.h  | 3 +++
 tools/perf/util/evlist.c | 4 ++--
 tools/perf/util/evlist.h | 2 +-
 tools/perf/util/evsel.c  | 3 +++
 4 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 9b7d4d333111..752709ccfb00 100644
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
index f0d71a9d49f4..cb9523f50a37 100644
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
index 871b55ab5dee..722618f84c53 100644
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
index abe69af58b62..bfebc1ea3c51 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1456,6 +1456,9 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 			array = (void *)array + sz;
 			OVERFLOW_CHECK_u64(array);
 			data->user_stack.size = *array++;
+			if (WARN_ONCE(data->user_stack.size > sz,
+				      "user stack dump failure\n"))
+				return -EFAULT;
 		}
 	}
 
-- 
1.8.1.4


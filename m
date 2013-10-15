Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831Ab3JOFaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:30:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33498 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab3JOFaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:30:22 -0400
Date: Mon, 14 Oct 2013 22:29:51 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-a65cb4b9f8a777a715371c63c0525408048cea3e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
In-Reply-To: <1380721599-24285-1-git-send-email-jolsa@redhat.com>
References: <1380721599-24285-1-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist:
  Fix perf_evlist__mmap_read event overflow
Git-Commit-ID: a65cb4b9f8a777a715371c63c0525408048cea3e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:29:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a65cb4b9f8a777a715371c63c0525408048cea3e
Gitweb:     http://git.kernel.org/tip/a65cb4b9f8a777a715371c63c0525408048cea3e
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 2 Oct 2013 15:46:39 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 11 Oct 2013 12:17:40 -0300

perf evlist: Fix perf_evlist__mmap_read event overflow

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
index 9b7d4d3..752709c 100644
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
index abe69af..bfebc1e 100644
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
 

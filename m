Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab3K2LqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 06:46:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545Ab3K2Lp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 06:45:57 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 1/6] perf tools: Add perf_evlist error string interface
Date: Fri, 29 Nov 2013 12:45:05 +0100
Message-Id: <1385725510-20118-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1385725510-20118-1-git-send-email-jolsa@redhat.com>
References: <1385725510-20118-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding perf_evlist__strerror function that returns
static string of the last error occured during
'struct perf_evlist' handling:

  char *perf_evlist__strerror(struct perf_evlist *evlist);

After each 'struct perf_evlist' operation that supports
internal error handling, this function returns proper
error string for output.

The point is to have internal error handling so we could
print our propper error message, eg. when 'perf_evlist__mmap'
fails, we have no idea if it was for the mmap failure or ioctl
(event ID retrieval).

NOTE We can add thread safe '_r' variant in the
future, currently it's not needed.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
---
 tools/perf/util/evlist.c | 34 ++++++++++++++++++++++++++++++++++
 tools/perf/util/evlist.h | 13 +++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 76fa764..dfb72d4 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -28,6 +28,11 @@
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
 #define SID(e, x, y) xyarray__entry(e->sample_id, x, y)
 
+#define SET_ERR(_err) ({				\
+	evlist->err      = PERF_EVLIST__ERRNO_##_err;	\
+	evlist->err_libc = errno;			\
+})
+
 void perf_evlist__init(struct perf_evlist *evlist, struct cpu_map *cpus,
 		       struct thread_map *threads)
 {
@@ -600,6 +605,34 @@ static int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
 	return evlist->mmap != NULL ? 0 : -ENOMEM;
 }
 
+static void __perf_evlist__strerror(struct perf_evlist *evlist,
+				    char *buf, size_t size)
+{
+	int err_libc = evlist->err_libc;
+	int err      = evlist->err;
+
+	switch (err) {
+	case PERF_EVLIST__ERRNO_SUCCESS:
+		break;
+	default:
+		scnprintf(buf, size, "Unknown error\n");
+		return;
+	}
+
+	if (!err_libc)
+		scnprintf(buf, size, "Success.");
+	else
+		scnprintf(buf, size, "Failed with %d (%s)\n",
+			  err_libc, strerror(err_libc));
+}
+
+char *perf_evlist__strerror(struct perf_evlist *evlist)
+{
+	static char str[BUFSIZ];
+	__perf_evlist__strerror(evlist, str, BUFSIZ);
+	return str;
+}
+
 static int __perf_evlist__mmap(struct perf_evlist *evlist,
 			       int idx, int prot, int mask, int fd)
 {
@@ -607,6 +640,7 @@ static int __perf_evlist__mmap(struct perf_evlist *evlist,
 	evlist->mmap[idx].mask = mask;
 	evlist->mmap[idx].base = mmap(NULL, evlist->mmap_len, prot,
 				      MAP_SHARED, fd, 0);
+
 	if (evlist->mmap[idx].base == MAP_FAILED) {
 		pr_debug2("failed to mmap perf event ring buffer, error %d\n",
 			  errno);
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 649d6ea..9832fbd 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -17,6 +17,10 @@ struct perf_record_opts;
 #define PERF_EVLIST__HLIST_BITS 8
 #define PERF_EVLIST__HLIST_SIZE (1 << PERF_EVLIST__HLIST_BITS)
 
+enum {
+	PERF_EVLIST__ERRNO_SUCCESS		= 0,
+};
+
 struct perf_mmap {
 	void		 *base;
 	int		 mask;
@@ -45,6 +49,14 @@ struct perf_evlist {
 	struct thread_map *threads;
 	struct cpu_map	  *cpus;
 	struct perf_evsel *selected;
+
+	/*
+	 * Internal error handling:
+	 *   err      - internal error value of last operation (
+	 *   err_libc - adjacent libc errno value
+	 */
+	int		 err;
+	int		 err_libc;
 };
 
 struct perf_evsel_str_handler {
@@ -172,6 +184,7 @@ size_t perf_evlist__fprintf(struct perf_evlist *evlist, FILE *fp);
 
 int perf_evlist__strerror_tp(struct perf_evlist *evlist, int err, char *buf, size_t size);
 int perf_evlist__strerror_open(struct perf_evlist *evlist, int err, char *buf, size_t size);
+char *perf_evlist__strerror(struct perf_evlist *evlist);
 
 static inline unsigned int perf_mmap__read_head(struct perf_mmap *mm)
 {
-- 
1.8.3.1


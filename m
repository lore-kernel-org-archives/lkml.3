Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab3CRQ3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:29:52 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49419
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752960Ab3CRQ0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:26:00 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 46/54] perf evlist: Introduce perf_evlist__close()
Date: Mon, 18 Mar 2013 13:25:31 -0300
Message-Id: <1363623939-10748-47-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1363623939-10748-1-git-send-email-acme@infradead.org>
References: <1363623939-10748-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It's a pair of perf_evlist__open().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1363326533-3310-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c |   19 ++++++++++++-------
 tools/perf/util/evlist.h |    1 +
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 5b012b8..1344fbd 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -721,10 +721,20 @@ void perf_evlist__set_selected(struct perf_evlist *evlist,
 	evlist->selected = evsel;
 }
 
+void perf_evlist__close(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+	int ncpus = cpu_map__nr(evlist->cpus);
+	int nthreads = thread_map__nr(evlist->threads);
+
+	list_for_each_entry_reverse(evsel, &evlist->entries, node)
+		perf_evsel__close(evsel, ncpus, nthreads);
+}
+
 int perf_evlist__open(struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel;
-	int err, ncpus, nthreads;
+	int err;
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		err = perf_evsel__open(evsel, evlist->cpus, evlist->threads);
@@ -734,12 +744,7 @@ int perf_evlist__open(struct perf_evlist *evlist)
 
 	return 0;
 out_err:
-	ncpus = cpu_map__nr(evlist->cpus);
-	nthreads = thread_map__nr(evlist->threads);
-
-	list_for_each_entry_reverse(evsel, &evlist->entries, node)
-		perf_evsel__close(evsel, ncpus, nthreads);
-
+	perf_evlist__close(evlist);
 	errno = -err;
 	return err;
 }
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index c096da7..0583d36 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -81,6 +81,7 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id);
 union perf_event *perf_evlist__mmap_read(struct perf_evlist *self, int idx);
 
 int perf_evlist__open(struct perf_evlist *evlist);
+void perf_evlist__close(struct perf_evlist *evlist);
 
 void perf_evlist__config(struct perf_evlist *evlist,
 			 struct perf_record_opts *opts);
-- 
1.7.1


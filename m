Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991Ab3CULn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:43:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56873 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab3CULnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:43:24 -0400
Date: Thu, 21 Mar 2013 04:41:48 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-a74b4b66cc027110272a18cd50cc6ee93483e78d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1363326533-3310-1-git-send-email-namhyung@kernel.org>
References: <1363326533-3310-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist: Introduce perf_evlist__close()
Git-Commit-ID: a74b4b66cc027110272a18cd50cc6ee93483e78d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 04:41:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a74b4b66cc027110272a18cd50cc6ee93483e78d
Gitweb:     http://git.kernel.org/tip/a74b4b66cc027110272a18cd50cc6ee93483e78d
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 15 Mar 2013 14:48:48 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:06:10 -0300

perf evlist: Introduce perf_evlist__close()

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
 tools/perf/util/evlist.c | 19 ++++++++++++-------
 tools/perf/util/evlist.h |  1 +
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

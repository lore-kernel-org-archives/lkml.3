Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab3HLKRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:17:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47706 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756156Ab3HLKRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:17:46 -0400
Date: Mon, 12 Aug 2013 03:17:23 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-twmlgsbyim97p7cyohjwb1df@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist:
  Add perf_evlist__id2sid method to get event ID related data
Git-Commit-ID: 932a35940a3f03613796ab4855ecbb214dbdc0c2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:17:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  932a35940a3f03613796ab4855ecbb214dbdc0c2
Gitweb:     http://git.kernel.org/tip/932a35940a3f03613796ab4855ecbb214dbdc0c2
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 11 Oct 2012 14:10:35 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:21 -0300

perf evlist: Add perf_evlist__id2sid method to get event ID related data

This will be helpful for PERF_FORMAT_GROUP samples where we need to
store ID related period value for each event.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-twmlgsbyim97p7cyohjwb1df@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 21 ++++++++++++++++-----
 tools/perf/util/evlist.h |  2 ++
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 10fcc03..da2dd92 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -337,21 +337,32 @@ static int perf_evlist__id_add_fd(struct perf_evlist *evlist,
 	return 0;
 }
 
-struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id)
+struct perf_sample_id *perf_evlist__id2sid(struct perf_evlist *evlist, u64 id)
 {
 	struct hlist_head *head;
 	struct perf_sample_id *sid;
 	int hash;
 
-	if (evlist->nr_entries == 1)
-		return perf_evlist__first(evlist);
-
 	hash = hash_64(id, PERF_EVLIST__HLIST_BITS);
 	head = &evlist->heads[hash];
 
 	hlist_for_each_entry(sid, head, node)
 		if (sid->id == id)
-			return sid->evsel;
+			return sid;
+
+	return NULL;
+}
+
+struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id)
+{
+	struct perf_sample_id *sid;
+
+	if (evlist->nr_entries == 1)
+		return perf_evlist__first(evlist);
+
+	sid = perf_evlist__id2sid(evlist, id);
+	if (sid)
+		return sid->evsel;
 
 	if (!perf_evlist__sample_id_all(evlist))
 		return perf_evlist__first(evlist);
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index c7178b7..327abab 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -78,6 +78,8 @@ void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd);
 
 struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id);
 
+struct perf_sample_id *perf_evlist__id2sid(struct perf_evlist *evlist, u64 id);
+
 union perf_event *perf_evlist__mmap_read(struct perf_evlist *self, int idx);
 
 int perf_evlist__open(struct perf_evlist *evlist);

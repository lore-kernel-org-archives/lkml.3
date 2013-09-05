Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994Ab3IETnB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 15:43:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59282 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756375Ab3IETmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 15:42:55 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/6] perf evlist: Fix parsing with no sample_id_all bit set
Date: Thu,  5 Sep 2013 16:42:40 -0300
Message-Id: <1378410163-2606-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378410163-2606-1-git-send-email-acme@infradead.org>
References: <1378410163-2606-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

The perf_evlist__event2evsel() is changed to handle non-sample events
(such as mmap events) that have no id sample appended i.e. when
sample_id_all is not set.

Note that such events have a fixed format, so that the selected event
(evsel) they are associated with is immaterial.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: David Ahern <dsahern@gmail.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1378325897-3840-3-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index b8727ae..7101283 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -446,20 +446,25 @@ static int perf_evlist__event2id(struct perf_evlist *evlist,
 static struct perf_evsel *perf_evlist__event2evsel(struct perf_evlist *evlist,
 						   union perf_event *event)
 {
+	struct perf_evsel *first = perf_evlist__first(evlist);
 	struct hlist_head *head;
 	struct perf_sample_id *sid;
 	int hash;
 	u64 id;
 
 	if (evlist->nr_entries == 1)
-		return perf_evlist__first(evlist);
+		return first;
+
+	if (!first->attr.sample_id_all &&
+	    event->header.type != PERF_RECORD_SAMPLE)
+		return first;
 
 	if (perf_evlist__event2id(evlist, event, &id))
 		return NULL;
 
 	/* Synthesized events have an id of zero */
 	if (!id)
-		return perf_evlist__first(evlist);
+		return first;
 
 	hash = hash_64(id, PERF_EVLIST__HLIST_BITS);
 	head = &evlist->heads[hash];
-- 
1.8.1.4


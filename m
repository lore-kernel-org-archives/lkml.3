Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761338Ab3IDUL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 16:11:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:55344 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761162Ab3IDULy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 16:11:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1023,1367996400"; 
   d="scan'208";a="391145050"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/2] perf tools: fix parsing with no sample_id_all bit set
Date: Wed,  4 Sep 2013 23:18:17 +0300
Message-Id: <1378325897-3840-3-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1378325897-3840-1-git-send-email-adrian.hunter@intel.com>
References: <1378325897-3840-1-git-send-email-adrian.hunter@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf_evlist__event2evsel() is changed to handle
non-sample events (such as mmap events) that have no
id sample appended i.e. when sample_id_all is not set.

Note that such events have a fixed format, so that
the selected event (evsel) they are associated with
is immaterial.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
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
1.7.11.7


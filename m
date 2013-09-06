Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab3IFTdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 15:33:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:26624 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966Ab3IFTdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 15:33:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,856,1371106800"; 
   d="scan'208";a="392153017"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V2 1/2] perf tools: fix id pos in perf_evlist__open()
Date: Fri,  6 Sep 2013 22:40:11 +0300
Message-Id: <1378496412-2424-2-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1378496412-2424-1-git-send-email-adrian.hunter@intel.com>
References: <1378496412-2424-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure the id_pos is correct when perf_evlist__open()
is used.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/evlist.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index b8727ae..005c0eb 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -64,6 +64,16 @@ void perf_evlist__set_id_pos(struct perf_evlist *evlist)
 	evlist->is_pos = first->is_pos;
 }
 
+static void perf_evlist__update_id_pos(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+
+	list_for_each_entry(evsel, &evlist->entries, node)
+		perf_evsel__calc_id_pos(evsel);
+
+	perf_evlist__set_id_pos(evlist);
+}
+
 static void perf_evlist__purge(struct perf_evlist *evlist)
 {
 	struct perf_evsel *pos, *n;
@@ -915,6 +925,8 @@ int perf_evlist__open(struct perf_evlist *evlist)
 	struct perf_evsel *evsel;
 	int err;
 
+	perf_evlist__update_id_pos(evlist);
+
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		err = perf_evsel__open(evsel, evlist->cpus, evlist->threads);
 		if (err < 0)
-- 
1.7.11.7


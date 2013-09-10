Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab3IJSM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 14:12:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53806 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab3IJSMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 14:12:19 -0400
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
Subject: [PATCH 2/5] perf evlist: Fix id pos in perf_evlist__open()
Date: Tue, 10 Sep 2013 15:11:59 -0300
Message-Id: <1378836722-31326-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378836722-31326-1-git-send-email-acme@infradead.org>
References: <1378836722-31326-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Ensure the id_pos is correct when perf_evlist__open() is used.

This fixes a problem introduced in 7556257 that broke 'perf kvm stat
live' in that this tool wasn't updated to use the sample_type bits
setting helpers.

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
Link: http://lkml.kernel.org/r/1378496412-2424-2-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 7101283..f9f77be 100644
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
@@ -920,6 +930,8 @@ int perf_evlist__open(struct perf_evlist *evlist)
 	struct perf_evsel *evsel;
 	int err;
 
+	perf_evlist__update_id_pos(evlist);
+
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		err = perf_evsel__open(evsel, evlist->cpus, evlist->threads);
 		if (err < 0)
-- 
1.8.1.4


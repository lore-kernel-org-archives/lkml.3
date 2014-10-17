Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbaJQTt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 15:49:58 -0400
Received: from mail.kernel.org ([198.145.19.201]:41588 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892AbaJQTt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 15:49:56 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/5] perf evsel: Move exit stuff from __delete to __exit
Date: Fri, 17 Oct 2014 16:49:29 -0300
Message-Id: <1413575373-10787-2-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413575373-10787-1-git-send-email-acme@kernel.org>
References: <1413575373-10787-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that when an evsel is embedded into other struct it can free up
resources calling perf_evsel__exit().

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-n1w68pfe9m2vkhm4sqs8y1en@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index d1ecde0fd56c..786ea557af26 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -850,17 +850,17 @@ void perf_evsel__exit(struct perf_evsel *evsel)
 	assert(list_empty(&evsel->node));
 	perf_evsel__free_fd(evsel);
 	perf_evsel__free_id(evsel);
+	close_cgroup(evsel->cgrp);
+	zfree(&evsel->group_name);
+	if (evsel->tp_format)
+		pevent_free_format(evsel->tp_format);
+	zfree(&evsel->name);
 	perf_evsel__object.fini(evsel);
 }
 
 void perf_evsel__delete(struct perf_evsel *evsel)
 {
 	perf_evsel__exit(evsel);
-	close_cgroup(evsel->cgrp);
-	zfree(&evsel->group_name);
-	if (evsel->tp_format)
-		pevent_free_format(evsel->tp_format);
-	zfree(&evsel->name);
 	free(evsel);
 }
 
-- 
1.9.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbaJNVFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 17:05:07 -0400
Received: from mail.kernel.org ([198.145.19.201]:44503 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755729AbaJNVFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 17:05:04 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Milian Wolff <mail@milianw.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/24] perf callchain: Move callchain_param to util object in to fix python test
Date: Tue, 14 Oct 2014 18:04:13 -0300
Message-Id: <1413320673-5784-5-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413320673-5784-1-git-send-email-acme@kernel.org>
References: <1413320673-5784-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

In following commit we changed the location of callchains data:

  72a128aa083a7f4cc4f800718aaae05d9c698e26
  perf tools: Move callchain config from record_opts to callchain_param

Now all callchains stuff stays in callchain_param struct, which adds its
dependency for evsel.c object and breaks python perf.so usage
(unresolved callchain_param).

Moving callchain_param into callchain.c and adding it into
python-ext-sources unleash just another dependency hell, so I ended up
adding callchain_param into util.c for now.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Milian Wolff <mail@milianw.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1412179229-19466-2-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c | 7 -------
 tools/perf/util/util.c | 8 ++++++++
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 86569fa3651d..b47595697140 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -14,13 +14,6 @@ static bool hists__filter_entry_by_thread(struct hists *hists,
 static bool hists__filter_entry_by_symbol(struct hists *hists,
 					  struct hist_entry *he);
 
-struct callchain_param	callchain_param = {
-	.mode	= CHAIN_GRAPH_REL,
-	.min_percent = 0.5,
-	.order  = ORDER_CALLEE,
-	.key	= CCKEY_FUNCTION
-};
-
 u16 hists__col_len(struct hists *hists, enum hist_column col)
 {
 	return hists->col_len[col];
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 24e8d871b74e..d5eab3f3323f 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -14,6 +14,14 @@
 #include <byteswap.h>
 #include <linux/kernel.h>
 #include <unistd.h>
+#include "callchain.h"
+
+struct callchain_param	callchain_param = {
+	.mode	= CHAIN_GRAPH_REL,
+	.min_percent = 0.5,
+	.order  = ORDER_CALLEE,
+	.key	= CCKEY_FUNCTION
+};
 
 /*
  * XXX We need to find a better place for these things...
-- 
1.9.3


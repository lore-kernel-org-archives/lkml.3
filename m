Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab3FXNKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 09:10:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:25371 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917Ab3FXNKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 09:10:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,928,1363158000"; 
   d="scan'208";a="321686509"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 06/15] perf tools: fix parse_events_terms() freeing local variable on error path
Date: Mon, 24 Jun 2013 16:16:03 +0300
Message-Id: <1372079772-20803-7-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372079772-20803-1-git-send-email-adrian.hunter@intel.com>
References: <1372079772-20803-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The list_head is on the stack, so just free the rest of the list.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/pmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 4c6f9c4..def64d4 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -194,7 +194,8 @@ static int pmu_alias_terms(struct perf_pmu_alias *alias,
 	list_for_each_entry(term, &alias->terms, list) {
 		ret = parse_events_term__clone(&clone, term);
 		if (ret) {
-			parse_events__free_terms(&list);
+			list_for_each_entry_safe(term, clone, &list, list)
+				free(term);
 			return ret;
 		}
 		list_add_tail(&clone->list, &list);
-- 
1.7.11.7


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933417AbaCRV0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:26:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44454 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933131AbaCRV0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:26:23 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Andi Kleen <andi@firstfloor.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/13] perf symbols: Apply all filters to an addr_location
Date: Tue, 18 Mar 2014 18:25:56 -0300
Message-Id: <1395177965-8879-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1395177965-8879-1-git-send-email-acme@infradead.org>
References: <1395177965-8879-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Instead of bailing out as soon as we find a filter that applies, go on
checking all of them so that we can zoom in/out filters.

We also need to make sure we only update al->filtered after
thread__find_addr_map(), because there is where al->filtered gets
initialized to zero.

This will increase the cost of processing when all we don't need this
toggling, but will provide flexibility for the TUI and GTK+ interfaces,
that will incur in creating the hist_entries just once.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-fhv9lhzdjxgp9w3w3668lsfw@git.kernel.org
[ yanked this out of a previous patch ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 0da09db5f9f6..ebb48a623407 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -793,11 +793,6 @@ int perf_event__preprocess_sample(const union perf_event *event,
 	if (thread == NULL)
 		return -1;
 
-	if (thread__is_filtered(thread)) {
-		al->filtered |= (1 << HIST_FILTER__THREAD);
-		goto out_filtered;
-	}
-
 	dump_printf(" ... thread: %s:%d\n", thread__comm_str(thread), thread->tid);
 	/*
 	 * Have we already created the kernel maps for this machine?
@@ -815,6 +810,10 @@ int perf_event__preprocess_sample(const union perf_event *event,
 	dump_printf(" ...... dso: %s\n",
 		    al->map ? al->map->dso->long_name :
 			al->level == 'H' ? "[hypervisor]" : "<not found>");
+
+	if (thread__is_filtered(thread))
+		al->filtered |= (1 << HIST_FILTER__THREAD);
+
 	al->sym = NULL;
 	al->cpu = sample->cpu;
 
@@ -828,7 +827,6 @@ int perf_event__preprocess_sample(const union perf_event *event,
 				strlist__has_entry(symbol_conf.dso_list,
 						   dso->long_name))))) {
 			al->filtered |= (1 << HIST_FILTER__DSO);
-			goto out_filtered;
 		}
 
 		al->sym = map__find_symbol(al->map, al->addr,
@@ -839,11 +837,7 @@ int perf_event__preprocess_sample(const union perf_event *event,
 		(!al->sym || !strlist__has_entry(symbol_conf.sym_list,
 						al->sym->name))) {
 		al->filtered |= (1 << HIST_FILTER__SYMBOL);
-		goto out_filtered;
 	}
 
 	return 0;
-
-out_filtered:
-	return 0;
 }
-- 
1.8.1.4


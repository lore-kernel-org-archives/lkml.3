Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934030AbaCSNHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:07:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34198 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933771AbaCSNHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:07:39 -0400
Date: Wed, 19 Mar 2014 06:07:02 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-fhv9lhzdjxgp9w3w3668lsfw@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols:
  Apply all filters to an addr_location
Git-Commit-ID: 466fa7647413665dcba46c4f7f2b4a9808426989
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  466fa7647413665dcba46c4f7f2b4a9808426989
Gitweb:     http://git.kernel.org/tip/466fa7647413665dcba46c4f7f2b4a9808426989
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 17 Mar 2014 17:12:27 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Mar 2014 18:16:58 -0300

perf symbols: Apply all filters to an addr_location

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
index 0da09db..ebb48a6 100644
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

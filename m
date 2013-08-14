Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016Ab3HNS0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:26:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34401 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760289Ab3HNSZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:25:37 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 17/21] perf tools: Remove filter parameter of thread__find_addr_location()
Date: Wed, 14 Aug 2013 15:25:11 -0300
Message-Id: <1376504715-28107-18-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376504715-28107-1-git-send-email-acme@infradead.org>
References: <1376504715-28107-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Now that the symbol filter is recorded on the machine there is no need
to pass it to thread__find_addr_location().  So remove it.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1375961547-30267-8-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c   | 9 +++++----
 tools/perf/util/machine.c | 8 ++++----
 tools/perf/util/thread.h  | 3 +--
 tools/perf/util/unwind.c  | 2 +-
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index f3cf771..9d301c9 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -670,12 +670,13 @@ try_again:
 
 void thread__find_addr_location(struct thread *thread, struct machine *machine,
 				u8 cpumode, enum map_type type, u64 addr,
-				struct addr_location *al,
-				symbol_filter_t filter)
+				struct addr_location *al)
 {
-	thread__find_addr_map(thread, machine, cpumode, type, addr, al, filter);
+	thread__find_addr_map(thread, machine, cpumode, type, addr, al,
+			      machine->symbol_filter);
 	if (al->map != NULL)
-		al->sym = map__find_symbol(al->map, al->addr, filter);
+		al->sym = map__find_symbol(al->map, al->addr,
+					   machine->symbol_filter);
 	else
 		al->sym = NULL;
 }
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 4c7e0a28..4514e7e 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1130,7 +1130,7 @@ static void ip__resolve_ams(struct machine *machine, struct thread *thread,
 		 * or else, the symbol is unknown
 		 */
 		thread__find_addr_location(thread, machine, m, MAP__FUNCTION,
-				ip, &al, NULL);
+				ip, &al);
 		if (al.sym)
 			goto found;
 	}
@@ -1148,8 +1148,8 @@ static void ip__resolve_data(struct machine *machine, struct thread *thread,
 
 	memset(&al, 0, sizeof(al));
 
-	thread__find_addr_location(thread, machine, m, MAP__VARIABLE, addr, &al,
-				   NULL);
+	thread__find_addr_location(thread, machine, m, MAP__VARIABLE, addr,
+				   &al);
 	ams->addr = addr;
 	ams->al_addr = al.addr;
 	ams->sym = al.sym;
@@ -1244,7 +1244,7 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 
 		al.filtered = false;
 		thread__find_addr_location(thread, machine, cpumode,
-					   MAP__FUNCTION, ip, &al, NULL);
+					   MAP__FUNCTION, ip, &al);
 		if (al.sym != NULL) {
 			if (sort__has_parent && !*parent &&
 			    symbol__match_regex(al.sym, &parent_regex))
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index f98d1d9..0ab47d8 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -45,8 +45,7 @@ void thread__find_addr_map(struct thread *thread, struct machine *machine,
 
 void thread__find_addr_location(struct thread *thread, struct machine *machine,
 				u8 cpumode, enum map_type type, u64 addr,
-				struct addr_location *al,
-				symbol_filter_t filter);
+				struct addr_location *al);
 
 static inline void *thread__priv(struct thread *thread)
 {
diff --git a/tools/perf/util/unwind.c b/tools/perf/util/unwind.c
index 5bbd494..abac3f9 100644
--- a/tools/perf/util/unwind.c
+++ b/tools/perf/util/unwind.c
@@ -473,7 +473,7 @@ static int entry(u64 ip, struct thread *thread, struct machine *machine,
 
 	thread__find_addr_location(thread, machine,
 				   PERF_RECORD_MISC_USER,
-				   MAP__FUNCTION, ip, &al, NULL);
+				   MAP__FUNCTION, ip, &al);
 
 	e.ip = ip;
 	e.map = al.map;
-- 
1.8.1.4


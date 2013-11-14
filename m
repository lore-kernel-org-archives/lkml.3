Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab3KNU0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 15:26:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36325 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757168Ab3KNUZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 15:25:38 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH 07/10] perf symbols: Limit max callchain using max_stack on DWARF unwinding too
Date: Thu, 14 Nov 2013 17:25:12 -0300
Message-Id: <1384460715-23198-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384460715-23198-1-git-send-email-acme@infradead.org>
References: <1384460715-23198-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

It was affecting only frame-pointer (fp) based callchain processing.

Usage example:

  perf top --call-graph dwarf,1024 --max-stack 2

Works for any tool that does callchain resolving and provides a
--max-stack option.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Waiman Long <Waiman.Long@hp.com>
Link: http://lkml.kernel.org/n/tip-eu45v8s3tq9ruay8tpfyon79@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 2 +-
 tools/perf/util/unwind.c  | 9 +++++----
 tools/perf/util/unwind.h  | 5 +++--
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 0393912d8033..84cdb072ac83 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1368,7 +1368,7 @@ int machine__resolve_callchain(struct machine *machine,
 
 	return unwind__get_entries(unwind_entry, &callchain_cursor, machine,
 				   thread, evsel->attr.sample_regs_user,
-				   sample);
+				   sample, max_stack);
 
 }
 
diff --git a/tools/perf/util/unwind.c b/tools/perf/util/unwind.c
index 5390d0b8862a..0efd5393de85 100644
--- a/tools/perf/util/unwind.c
+++ b/tools/perf/util/unwind.c
@@ -559,7 +559,7 @@ static unw_accessors_t accessors = {
 };
 
 static int get_entries(struct unwind_info *ui, unwind_entry_cb_t cb,
-		       void *arg)
+		       void *arg, int max_stack)
 {
 	unw_addr_space_t addr_space;
 	unw_cursor_t c;
@@ -575,7 +575,7 @@ static int get_entries(struct unwind_info *ui, unwind_entry_cb_t cb,
 	if (ret)
 		display_error(ret);
 
-	while (!ret && (unw_step(&c) > 0)) {
+	while (!ret && (unw_step(&c) > 0) && max_stack--) {
 		unw_word_t ip;
 
 		unw_get_reg(&c, UNW_REG_IP, &ip);
@@ -588,7 +588,8 @@ static int get_entries(struct unwind_info *ui, unwind_entry_cb_t cb,
 
 int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 			struct machine *machine, struct thread *thread,
-			u64 sample_uregs, struct perf_sample *data)
+			u64 sample_uregs, struct perf_sample *data,
+			int max_stack)
 {
 	unw_word_t ip;
 	struct unwind_info ui = {
@@ -610,5 +611,5 @@ int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 	if (ret)
 		return -ENOMEM;
 
-	return get_entries(&ui, cb, arg);
+	return get_entries(&ui, cb, arg, max_stack);
 }
diff --git a/tools/perf/util/unwind.h b/tools/perf/util/unwind.h
index ec0c71a2ca2e..d5966f49e22c 100644
--- a/tools/perf/util/unwind.h
+++ b/tools/perf/util/unwind.h
@@ -18,7 +18,7 @@ int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 			struct machine *machine,
 			struct thread *thread,
 			u64 sample_uregs,
-			struct perf_sample *data);
+			struct perf_sample *data, int max_stack);
 int unwind__arch_reg_id(int regnum);
 #else
 static inline int
@@ -27,7 +27,8 @@ unwind__get_entries(unwind_entry_cb_t cb __maybe_unused,
 		    struct machine *machine __maybe_unused,
 		    struct thread *thread __maybe_unused,
 		    u64 sample_uregs __maybe_unused,
-		    struct perf_sample *data __maybe_unused)
+		    struct perf_sample *data __maybe_unused,
+		    int max_stack __maybe_unused)
 {
 	return 0;
 }
-- 
1.8.1.4


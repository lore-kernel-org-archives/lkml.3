Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab3KOH0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 02:26:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50394 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590Ab3KOH0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 02:26:16 -0500
Date: Thu, 14 Nov 2013 23:25:27 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-eu45v8s3tq9ruay8tpfyon79@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        Waiman.Long@hp.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, Waiman.Long@hp.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf symbols:
  Limit max callchain using max_stack on DWARF unwinding too
Git-Commit-ID: 37676af15c8d5a9689c9d1220d2a27d510cbe238
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 14 Nov 2013 23:25:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  37676af15c8d5a9689c9d1220d2a27d510cbe238
Gitweb:     http://git.kernel.org/tip/37676af15c8d5a9689c9d1220d2a27d510cbe238
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 13 Nov 2013 17:40:36 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 14 Nov 2013 16:00:23 -0300

perf symbols: Limit max callchain using max_stack on DWARF unwinding too

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
index 0393912..84cdb07 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1368,7 +1368,7 @@ int machine__resolve_callchain(struct machine *machine,
 
 	return unwind__get_entries(unwind_entry, &callchain_cursor, machine,
 				   thread, evsel->attr.sample_regs_user,
-				   sample);
+				   sample, max_stack);
 
 }
 
diff --git a/tools/perf/util/unwind.c b/tools/perf/util/unwind.c
index 5390d0b..0efd539 100644
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
index ec0c71a..d5966f49 100644
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

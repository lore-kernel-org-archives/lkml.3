Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933429AbaJ2OH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:07:27 -0400
Received: from mail.kernel.org ([198.145.19.201]:41037 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933056AbaJ2OHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:07:22 -0400
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
Subject: [PATCH 05/25] perf callchains: Use thread->mg->machine
Date: Wed, 29 Oct 2014 12:06:17 -0200
Message-Id: <1414591597-2763-6-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1414591597-2763-1-git-send-email-acme@kernel.org>
References: <1414591597-2763-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The unwind__get_entries() already receives the thread parameter, from where it can
obtain the matching machine structure, shorten the signature.

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
Link: http://lkml.kernel.org/n/tip-isjc6bm8mv4612mhi6af64go@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/dwarf-unwind.c    | 18 +++++++++---------
 tools/perf/util/machine.c          |  2 +-
 tools/perf/util/unwind-libdw.c     |  4 ++--
 tools/perf/util/unwind-libunwind.c |  4 ++--
 tools/perf/util/unwind.h           |  2 --
 5 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/tools/perf/tests/dwarf-unwind.c b/tools/perf/tests/dwarf-unwind.c
index fc25e57f4a5d..ab28cca2cb97 100644
--- a/tools/perf/tests/dwarf-unwind.c
+++ b/tools/perf/tests/dwarf-unwind.c
@@ -59,7 +59,7 @@ static int unwind_entry(struct unwind_entry *entry, void *arg)
 }
 
 __attribute__ ((noinline))
-static int unwind_thread(struct thread *thread, struct machine *machine)
+static int unwind_thread(struct thread *thread)
 {
 	struct perf_sample sample;
 	unsigned long cnt = 0;
@@ -72,7 +72,7 @@ static int unwind_thread(struct thread *thread, struct machine *machine)
 		goto out;
 	}
 
-	err = unwind__get_entries(unwind_entry, &cnt, machine, thread,
+	err = unwind__get_entries(unwind_entry, &cnt, thread,
 				  &sample, MAX_STACK);
 	if (err)
 		pr_debug("unwind failed\n");
@@ -89,21 +89,21 @@ static int unwind_thread(struct thread *thread, struct machine *machine)
 }
 
 __attribute__ ((noinline))
-static int krava_3(struct thread *thread, struct machine *machine)
+static int krava_3(struct thread *thread)
 {
-	return unwind_thread(thread, machine);
+	return unwind_thread(thread);
 }
 
 __attribute__ ((noinline))
-static int krava_2(struct thread *thread, struct machine *machine)
+static int krava_2(struct thread *thread)
 {
-	return krava_3(thread, machine);
+	return krava_3(thread);
 }
 
 __attribute__ ((noinline))
-static int krava_1(struct thread *thread, struct machine *machine)
+static int krava_1(struct thread *thread)
 {
-	return krava_2(thread, machine);
+	return krava_2(thread);
 }
 
 int test__dwarf_unwind(void)
@@ -137,7 +137,7 @@ int test__dwarf_unwind(void)
 		goto out;
 	}
 
-	err = krava_1(thread, machine);
+	err = krava_1(thread);
 
  out:
 	machine__delete_threads(machine);
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index fd192e4885cc..51a630301afa 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1486,7 +1486,7 @@ int thread__resolve_callchain(struct thread *thread,
 	    (!sample->user_stack.size))
 		return 0;
 
-	return unwind__get_entries(unwind_entry, &callchain_cursor, thread->mg->machine,
+	return unwind__get_entries(unwind_entry, &callchain_cursor,
 				   thread, sample, max_stack);
 
 }
diff --git a/tools/perf/util/unwind-libdw.c b/tools/perf/util/unwind-libdw.c
index f24b350ab192..2dcfe9a7c8d0 100644
--- a/tools/perf/util/unwind-libdw.c
+++ b/tools/perf/util/unwind-libdw.c
@@ -164,14 +164,14 @@ frame_callback(Dwfl_Frame *state, void *arg)
 }
 
 int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
-			struct machine *machine, struct thread *thread,
+			struct thread *thread,
 			struct perf_sample *data,
 			int max_stack)
 {
 	struct unwind_info ui = {
 		.sample		= data,
 		.thread		= thread,
-		.machine	= machine,
+		.machine	= thread->mg->machine,
 		.cb		= cb,
 		.arg		= arg,
 		.max_stack	= max_stack,
diff --git a/tools/perf/util/unwind-libunwind.c b/tools/perf/util/unwind-libunwind.c
index 29acc8cccb56..371219a6daf1 100644
--- a/tools/perf/util/unwind-libunwind.c
+++ b/tools/perf/util/unwind-libunwind.c
@@ -592,14 +592,14 @@ static int get_entries(struct unwind_info *ui, unwind_entry_cb_t cb,
 }
 
 int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
-			struct machine *machine, struct thread *thread,
+			struct thread *thread,
 			struct perf_sample *data, int max_stack)
 {
 	u64 ip;
 	struct unwind_info ui = {
 		.sample       = data,
 		.thread       = thread,
-		.machine      = machine,
+		.machine      = thread->mg->machine,
 	};
 	int ret;
 
diff --git a/tools/perf/util/unwind.h b/tools/perf/util/unwind.h
index f50b737235eb..12790cf94618 100644
--- a/tools/perf/util/unwind.h
+++ b/tools/perf/util/unwind.h
@@ -16,7 +16,6 @@ typedef int (*unwind_entry_cb_t)(struct unwind_entry *entry, void *arg);
 
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
 int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
-			struct machine *machine,
 			struct thread *thread,
 			struct perf_sample *data, int max_stack);
 /* libunwind specific */
@@ -38,7 +37,6 @@ static inline void unwind__finish_access(struct thread *thread __maybe_unused) {
 static inline int
 unwind__get_entries(unwind_entry_cb_t cb __maybe_unused,
 		    void *arg __maybe_unused,
-		    struct machine *machine __maybe_unused,
 		    struct thread *thread __maybe_unused,
 		    struct perf_sample *data __maybe_unused,
 		    int max_stack __maybe_unused)
-- 
1.9.3


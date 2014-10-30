Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413AbaJ3GoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:44:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37975 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231AbaJ3GoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:44:15 -0400
Date: Wed, 29 Oct 2014 23:43:11 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-isjc6bm8mv4612mhi6af64go@git.kernel.org>
Cc: adrian.hunter@intel.com, peterz@infradead.org, eranian@google.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, fweisbec@gmail.com,
        dsahern@gmail.com, acme@redhat.com, dzickus@redhat.com, efault@gmx.de,
        bp@suse.de, jean.pihet@linaro.org, mingo@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de, paulus@samba.org, namhyung@kernel.org
Reply-To: dsahern@gmail.com, acme@redhat.com, peterz@infradead.org,
        adrian.hunter@intel.com, fweisbec@gmail.com, eranian@google.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, namhyung@kernel.org,
        paulus@samba.org, tglx@linutronix.de, dzickus@redhat.com,
        efault@gmx.de, jolsa@redhat.com, mingo@kernel.org,
        jean.pihet@linaro.org, bp@suse.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf callchains: Use thread->mg->machine
Git-Commit-ID: dd8c17a5fe80148aab8844e8774cf341212a4eb1
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

Commit-ID:  dd8c17a5fe80148aab8844e8774cf341212a4eb1
Gitweb:     http://git.kernel.org/tip/dd8c17a5fe80148aab8844e8774cf341212a4eb1
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 23 Oct 2014 16:42:19 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 Oct 2014 10:32:46 -0200

perf callchains: Use thread->mg->machine

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
index fc25e57..ab28cca 100644
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
index fd192e4..51a6303 100644
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
index f24b350..2dcfe9a 100644
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
index 29acc8c..371219a 100644
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
index f50b737..12790cf 100644
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

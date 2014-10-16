Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbaJPFYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 01:24:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33548 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbaJPFYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 01:24:19 -0400
Date: Wed, 15 Oct 2014 22:23:56 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-66f066d8994bd146304bab72fa09c1e644c4b3ff@git.kernel.org>
Cc: jolsa@kernel.org, namhyung@kernel.org, jean.pihet@linaro.org,
        acme@redhat.com, fweisbec@gmail.com, paulus@samba.org, hpa@zytor.com,
        asharma@fb.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        dsahern@gmail.com, namhyung.kim@lge.com, tglx@linutronix.de,
        jolsa@redhat.com, linux-kernel@vger.kernel.org
Reply-To: jolsa@redhat.com, linux-kernel@vger.kernel.org, namhyung.kim@lge.com,
        tglx@linutronix.de, asharma@fb.com, dsahern@gmail.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        hpa@zytor.com, fweisbec@gmail.com, namhyung@kernel.org,
        jean.pihet@linaro.org, acme@redhat.com, jolsa@kernel.org
In-Reply-To: <1412556363-26229-3-git-send-email-namhyung@kernel.org>
References: <1412556363-26229-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf callchain:
  Create an address space per thread
Git-Commit-ID: 66f066d8994bd146304bab72fa09c1e644c4b3ff
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

Commit-ID:  66f066d8994bd146304bab72fa09c1e644c4b3ff
Gitweb:     http://git.kernel.org/tip/66f066d8994bd146304bab72fa09c1e644c4b3ff
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 6 Oct 2014 09:46:00 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 15 Oct 2014 17:38:23 -0300

perf callchain: Create an address space per thread

The unw_addr_space_t in libunwind represents an address space to be used
for stack unwinding.  It doesn't need to be create/destory everytime to
unwind callchain (as in get_entries) and can have a same lifetime as
thread (unless exec called).

So move the address space construction/destruction logic to the thread
lifetime handling functions.  This is a preparation to enable caching in
the unwind library.

Note that it saves unw_addr_space_t object using thread__set_priv().  It
seems currently only used by perf trace and perf kvm stat commands which
don't use callchain.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jean Pihet <jean.pihet@linaro.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Arun Sharma <asharma@fb.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1412556363-26229-3-git-send-email-namhyung@kernel.org
[ Fixup unwind-libunwind.c missing CALLCHAIN_DWARF definition, added
  missing __maybe_unused on unused parameters in stubs at util/unwind.h ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/thread.c           |  6 ++++++
 tools/perf/util/unwind-libunwind.c | 37 ++++++++++++++++++++++++++++++++-----
 tools/perf/util/unwind.h           | 17 +++++++++++++++++
 3 files changed, 55 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index a9df7f2..2b7b2d9 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -7,6 +7,7 @@
 #include "util.h"
 #include "debug.h"
 #include "comm.h"
+#include "unwind.h"
 
 int thread__init_map_groups(struct thread *thread, struct machine *machine)
 {
@@ -37,6 +38,9 @@ struct thread *thread__new(pid_t pid, pid_t tid)
 		thread->cpu = -1;
 		INIT_LIST_HEAD(&thread->comm_list);
 
+		if (unwind__prepare_access(thread) < 0)
+			goto err_thread;
+
 		comm_str = malloc(32);
 		if (!comm_str)
 			goto err_thread;
@@ -48,6 +52,7 @@ struct thread *thread__new(pid_t pid, pid_t tid)
 			goto err_thread;
 
 		list_add(&comm->list, &thread->comm_list);
+
 	}
 
 	return thread;
@@ -69,6 +74,7 @@ void thread__delete(struct thread *thread)
 		list_del(&comm->list);
 		comm__free(comm);
 	}
+	unwind__finish_access(thread);
 
 	free(thread);
 }
diff --git a/tools/perf/util/unwind-libunwind.c b/tools/perf/util/unwind-libunwind.c
index 92b56db..e060386 100644
--- a/tools/perf/util/unwind-libunwind.c
+++ b/tools/perf/util/unwind-libunwind.c
@@ -24,6 +24,7 @@
 #include <linux/list.h>
 #include <libunwind.h>
 #include <libunwind-ptrace.h>
+#include "callchain.h"
 #include "thread.h"
 #include "session.h"
 #include "perf_regs.h"
@@ -525,12 +526,12 @@ static unw_accessors_t accessors = {
 	.get_proc_name		= get_proc_name,
 };
 
-static int get_entries(struct unwind_info *ui, unwind_entry_cb_t cb,
-		       void *arg, int max_stack)
+int unwind__prepare_access(struct thread *thread)
 {
 	unw_addr_space_t addr_space;
-	unw_cursor_t c;
-	int ret;
+
+	if (callchain_param.record_mode != CALLCHAIN_DWARF)
+		return 0;
 
 	addr_space = unw_create_addr_space(&accessors, 0);
 	if (!addr_space) {
@@ -538,6 +539,33 @@ static int get_entries(struct unwind_info *ui, unwind_entry_cb_t cb,
 		return -ENOMEM;
 	}
 
+	thread__set_priv(thread, addr_space);
+
+	return 0;
+}
+
+void unwind__finish_access(struct thread *thread)
+{
+	unw_addr_space_t addr_space;
+
+	if (callchain_param.record_mode != CALLCHAIN_DWARF)
+		return;
+
+	addr_space = thread__priv(thread);
+	unw_destroy_addr_space(addr_space);
+}
+
+static int get_entries(struct unwind_info *ui, unwind_entry_cb_t cb,
+		       void *arg, int max_stack)
+{
+	unw_addr_space_t addr_space;
+	unw_cursor_t c;
+	int ret;
+
+	addr_space = thread__priv(ui->thread);
+	if (addr_space == NULL)
+		return -1;
+
 	ret = unw_init_remote(&c, addr_space, ui);
 	if (ret)
 		display_error(ret);
@@ -549,7 +577,6 @@ static int get_entries(struct unwind_info *ui, unwind_entry_cb_t cb,
 		ret = ip ? entry(ip, ui->thread, ui->machine, cb, arg) : 0;
 	}
 
-	unw_destroy_addr_space(addr_space);
 	return ret;
 }
 
diff --git a/tools/perf/util/unwind.h b/tools/perf/util/unwind.h
index f030612..c17c485 100644
--- a/tools/perf/util/unwind.h
+++ b/tools/perf/util/unwind.h
@@ -4,6 +4,7 @@
 #include <linux/types.h>
 #include "event.h"
 #include "symbol.h"
+#include "thread.h"
 
 struct unwind_entry {
 	struct map	*map;
@@ -21,6 +22,15 @@ int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 /* libunwind specific */
 #ifdef HAVE_LIBUNWIND_SUPPORT
 int libunwind__arch_reg_id(int regnum);
+int unwind__prepare_access(struct thread *thread);
+void unwind__finish_access(struct thread *thread);
+#else
+static inline int unwind__prepare_access(struct thread *thread __maybe_unused)
+{
+	return 0;
+}
+
+static inline void unwind__finish_access(struct thread *thread __maybe_unused) {}
 #endif
 #else
 static inline int
@@ -33,5 +43,12 @@ unwind__get_entries(unwind_entry_cb_t cb __maybe_unused,
 {
 	return 0;
 }
+
+static inline int unwind__prepare_access(struct thread *thread __maybe_unused)
+{
+	return 0;
+}
+
+static inline void unwind__finish_access(struct thread *thread __maybe_unused) {}
 #endif /* HAVE_DWARF_UNWIND_SUPPORT */
 #endif /* __UNWIND_H */

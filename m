Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaIWGak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 02:30:40 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:55703 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbaIWGaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 02:30:39 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Jean Pihet <jean.pihet@linaro.org>, Arun Sharma <asharma@fb.com>
Subject: [PATCH 1/2] perf callchain: Create an address space per thread
Date: Tue, 23 Sep 2014 15:30:27 +0900
Message-Id: <1411453828-14832-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The unw_addr_space_t in libunwind represents an address space to be
used for stack unwinding.  It doesn't need to be create/destory
everytime to unwind callchain (as in get_entries) and can have a same
lifetime as thread (unless exec called).

So move the address space construction/destruction logic to the thread
lifetime handling functions.  This is a preparation to enable caching
in the unwind library.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Arun Sharma <asharma@fb.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/thread.c           |  8 ++++++++
 tools/perf/util/unwind-libunwind.c | 30 +++++++++++++++++++++++++-----
 tools/perf/util/unwind.h           | 17 +++++++++++++++++
 3 files changed, 50 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index a9df7f2c6dc9..c1fa4a3597ea 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -7,6 +7,7 @@
 #include "util.h"
 #include "debug.h"
 #include "comm.h"
+#include "unwind.h"
 
 int thread__init_map_groups(struct thread *thread, struct machine *machine)
 {
@@ -48,6 +49,12 @@ struct thread *thread__new(pid_t pid, pid_t tid)
 			goto err_thread;
 
 		list_add(&comm->list, &thread->comm_list);
+
+		if (unwind__prepare_access(thread) < 0) {
+			list_del(&comm->list);
+			free(comm);
+			goto err_thread;
+		}
 	}
 
 	return thread;
@@ -69,6 +76,7 @@ void thread__delete(struct thread *thread)
 		list_del(&comm->list);
 		comm__free(comm);
 	}
+	unwind__finish_access(thread);
 
 	free(thread);
 }
diff --git a/tools/perf/util/unwind-libunwind.c b/tools/perf/util/unwind-libunwind.c
index 92b56db52471..76ec25663c95 100644
--- a/tools/perf/util/unwind-libunwind.c
+++ b/tools/perf/util/unwind-libunwind.c
@@ -525,12 +525,9 @@ static unw_accessors_t accessors = {
 	.get_proc_name		= get_proc_name,
 };
 
-static int get_entries(struct unwind_info *ui, unwind_entry_cb_t cb,
-		       void *arg, int max_stack)
+int unwind__prepare_access(struct thread *thread)
 {
 	unw_addr_space_t addr_space;
-	unw_cursor_t c;
-	int ret;
 
 	addr_space = unw_create_addr_space(&accessors, 0);
 	if (!addr_space) {
@@ -538,6 +535,30 @@ static int get_entries(struct unwind_info *ui, unwind_entry_cb_t cb,
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
@@ -549,7 +570,6 @@ static int get_entries(struct unwind_info *ui, unwind_entry_cb_t cb,
 		ret = ip ? entry(ip, ui->thread, ui->machine, cb, arg) : 0;
 	}
 
-	unw_destroy_addr_space(addr_space);
 	return ret;
 }
 
diff --git a/tools/perf/util/unwind.h b/tools/perf/util/unwind.h
index f03061260b4e..4b99c6280c2a 100644
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
+static inline int unwind__prepare_access(struct thread *thread)
+{
+	return 0;
+}
+
+static inline void unwind__finish_access(struct thread *thread) {}
 #endif
 #else
 static inline int
@@ -33,5 +43,12 @@ unwind__get_entries(unwind_entry_cb_t cb __maybe_unused,
 {
 	return 0;
 }
+
+static inline int unwind__prepare_access(struct thread *thread)
+{
+	return 0;
+}
+
+static inline void unwind__finish_access(struct thread *thread) {}
 #endif /* HAVE_DWARF_UNWIND_SUPPORT */
 #endif /* __UNWIND_H */
-- 
2.1.0


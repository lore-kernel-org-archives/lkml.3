Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbaI2E6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 00:58:18 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:45502 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaI2E6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 00:58:15 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arun Sharma <asharma@fb.com>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH v2 2/2] perf callchain: Use global caching provided by libunwind
Date: Mon, 29 Sep 2014 13:58:12 +0900
Message-Id: <1411966692-26648-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411966692-26648-1-git-send-email-namhyung@kernel.org>
References: <1411966692-26648-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The libunwind provides two caching policy which are global and
per-thread.  As perf unwinds callchains in a single thread, it'd
sufficient to use global caching.

This speeds up my perf report from 14s to 7s on a ~260MB data file.
Although the output sometimes contains a slight difference (~0.01% in
terms of number of lines printed) on callchains which were not
resolved.

Acked-by: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arun Sharma <asharma@fb.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/thread.c           | 3 +++
 tools/perf/util/unwind-libunwind.c | 9 +++++++++
 tools/perf/util/unwind.h           | 3 +++
 3 files changed, 15 insertions(+)

diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 2b7b2d91c016..c41411726c7a 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -117,6 +117,9 @@ int __thread__set_comm(struct thread *thread, const char *str, u64 timestamp,
 		if (!new)
 			return -ENOMEM;
 		list_add(&new->list, &thread->comm_list);
+
+		if (exec)
+			unwind__flush_access(thread);
 	}
 
 	thread->comm_set = true;
diff --git a/tools/perf/util/unwind-libunwind.c b/tools/perf/util/unwind-libunwind.c
index 76ec25663c95..6df06f0cd177 100644
--- a/tools/perf/util/unwind-libunwind.c
+++ b/tools/perf/util/unwind-libunwind.c
@@ -535,11 +535,20 @@ int unwind__prepare_access(struct thread *thread)
 		return -ENOMEM;
 	}
 
+	unw_set_caching_policy(addr_space, UNW_CACHE_GLOBAL);
 	thread__set_priv(thread, addr_space);
 
 	return 0;
 }
 
+void unwind__flush_access(struct thread *thread)
+{
+	unw_addr_space_t addr_space;
+
+	addr_space = thread__priv(thread);
+	unw_flush_cache(addr_space, 0, 0);
+}
+
 void unwind__finish_access(struct thread *thread)
 {
 	unw_addr_space_t addr_space;
diff --git a/tools/perf/util/unwind.h b/tools/perf/util/unwind.h
index 4b99c6280c2a..d68f24d4f01b 100644
--- a/tools/perf/util/unwind.h
+++ b/tools/perf/util/unwind.h
@@ -23,6 +23,7 @@ int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 #ifdef HAVE_LIBUNWIND_SUPPORT
 int libunwind__arch_reg_id(int regnum);
 int unwind__prepare_access(struct thread *thread);
+void unwind__flush_access(struct thread *thread);
 void unwind__finish_access(struct thread *thread);
 #else
 static inline int unwind__prepare_access(struct thread *thread)
@@ -30,6 +31,7 @@ static inline int unwind__prepare_access(struct thread *thread)
 	return 0;
 }
 
+static inline void unwind__flush_access(struct thread *thread) {}
 static inline void unwind__finish_access(struct thread *thread) {}
 #endif
 #else
@@ -49,6 +51,7 @@ static inline int unwind__prepare_access(struct thread *thread)
 	return 0;
 }
 
+static inline void unwind__flush_access(struct thread *thread) {}
 static inline void unwind__finish_access(struct thread *thread) {}
 #endif /* HAVE_DWARF_UNWIND_SUPPORT */
 #endif /* __UNWIND_H */
-- 
2.1.0


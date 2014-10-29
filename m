Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933444AbaJ2M4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 08:56:38 -0400
Received: from mail.kernel.org ([198.145.19.201]:36819 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932773AbaJ2M4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:56:35 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Arun Sharma <asharma@fb.com>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/10] perf callchain: Use global caching provided by libunwind
Date: Wed, 29 Oct 2014 10:56:08 -0200
Message-Id: <1414587377-25077-2-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1414587377-25077-1-git-send-email-acme@kernel.org>
References: <1414587377-25077-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The libunwind provides two caching policy which are global and
per-thread.  As perf unwinds callchains in a single thread, it'd
sufficient to use global caching.

This speeds up my perf report from 14s to 7s on a ~260MB data file.
Although the output sometimes contains a slight difference (~0.01% in
terms of number of lines printed) on callchains which were not resolved.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jean Pihet <jean.pihet@linaro.org>
Cc: Arun Sharma <asharma@fb.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1412556363-26229-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/thread.c           |  3 +++
 tools/perf/util/unwind-libunwind.c | 12 ++++++++++++
 tools/perf/util/unwind.h           |  3 +++
 3 files changed, 18 insertions(+)

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
index e060386165c5..4d45c0dfe343 100644
--- a/tools/perf/util/unwind-libunwind.c
+++ b/tools/perf/util/unwind-libunwind.c
@@ -539,11 +539,23 @@ int unwind__prepare_access(struct thread *thread)
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
+	if (callchain_param.record_mode != CALLCHAIN_DWARF)
+		return;
+
+	addr_space = thread__priv(thread);
+	unw_flush_cache(addr_space, 0, 0);
+}
+
 void unwind__finish_access(struct thread *thread)
 {
 	unw_addr_space_t addr_space;
diff --git a/tools/perf/util/unwind.h b/tools/perf/util/unwind.h
index c17c4855bdbc..f50b737235eb 100644
--- a/tools/perf/util/unwind.h
+++ b/tools/perf/util/unwind.h
@@ -23,6 +23,7 @@ int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 #ifdef HAVE_LIBUNWIND_SUPPORT
 int libunwind__arch_reg_id(int regnum);
 int unwind__prepare_access(struct thread *thread);
+void unwind__flush_access(struct thread *thread);
 void unwind__finish_access(struct thread *thread);
 #else
 static inline int unwind__prepare_access(struct thread *thread __maybe_unused)
@@ -30,6 +31,7 @@ static inline int unwind__prepare_access(struct thread *thread __maybe_unused)
 	return 0;
 }
 
+static inline void unwind__flush_access(struct thread *thread __maybe_unused) {}
 static inline void unwind__finish_access(struct thread *thread __maybe_unused) {}
 #endif
 #else
@@ -49,6 +51,7 @@ static inline int unwind__prepare_access(struct thread *thread __maybe_unused)
 	return 0;
 }
 
+static inline void unwind__flush_access(struct thread *thread __maybe_unused) {}
 static inline void unwind__finish_access(struct thread *thread __maybe_unused) {}
 #endif /* HAVE_DWARF_UNWIND_SUPPORT */
 #endif /* __UNWIND_H */
-- 
1.9.3


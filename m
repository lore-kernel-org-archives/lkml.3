Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402AbaJ3Gkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:40:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37766 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758347AbaJ3Gka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:40:30 -0400
Date: Wed, 29 Oct 2014 23:39:39 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-380b5143ab76de71572c7a30e68c8e22b94bee52@git.kernel.org>
Cc: asharma@fb.com, namhyung.kim@lge.com, jolsa@redhat.com,
        jean.pihet@linaro.org, a.p.zijlstra@chello.nl, acme@redhat.com,
        hpa@zytor.com, namhyung@kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@kernel.org, paulus@samba.org,
        tglx@linutronix.de, dsahern@gmail.com
Reply-To: hpa@zytor.com, acme@redhat.com, jean.pihet@linaro.org,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, asharma@fb.com,
        namhyung.kim@lge.com, dsahern@gmail.com, tglx@linutronix.de,
        paulus@samba.org, mingo@kernel.org, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, namhyung@kernel.org
In-Reply-To: <1412556363-26229-4-git-send-email-namhyung@kernel.org>
References: <1412556363-26229-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf callchain:
  Use global caching provided by libunwind
Git-Commit-ID: 380b5143ab76de71572c7a30e68c8e22b94bee52
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

Commit-ID:  380b5143ab76de71572c7a30e68c8e22b94bee52
Gitweb:     http://git.kernel.org/tip/380b5143ab76de71572c7a30e68c8e22b94bee52
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 6 Oct 2014 09:46:01 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 Oct 2014 10:25:22 -0200

perf callchain: Use global caching provided by libunwind

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
index 2b7b2d9..c414117 100644
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
index e060386..4d45c0d 100644
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
index c17c485..f50b737 100644
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

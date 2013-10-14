Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250Ab3JNUMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:12:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39121 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757521Ab3JNUDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:09 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 129/161] perf trace: Allow specifying index offset in strarrays
Date: Mon, 14 Oct 2013 17:01:58 -0300
Message-Id: <1381780950-25642-130-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that the index passed doesn't have to start at zero, being
decremented from an offset specified when declaring the strarray before
being used as the real array index.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-k1ce6uqyt4qar9edrj3mevod@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index addc3e11f999..7424298b87e3 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -44,6 +44,7 @@ struct syscall_arg {
 };
 
 struct strarray {
+	int	    offset;
 	int	    nr_entries;
 	const char **entries;
 };
@@ -53,14 +54,20 @@ struct strarray {
 	.entries = array, \
 }
 
+#define DEFINE_STRARRAY_OFFSET(array, off) struct strarray strarray__##array = { \
+	.offset	    = off, \
+	.nr_entries = ARRAY_SIZE(array), \
+	.entries = array, \
+}
+
 static size_t syscall_arg__scnprintf_strarray(char *bf, size_t size,
 					      struct syscall_arg *arg)
 {
-	int idx = arg->val;
 	struct strarray *sa = arg->parm;
+	int idx = arg->val - sa->offset;
 
 	if (idx < 0 || idx >= sa->nr_entries)
-		return scnprintf(bf, size, "%d", idx);
+		return scnprintf(bf, size, "%d", arg->val);
 
 	return scnprintf(bf, size, "%s", sa->entries[idx]);
 }
@@ -288,8 +295,8 @@ static size_t syscall_arg__scnprintf_futex_op(char *bf, size_t size, struct sysc
 
 #define SCA_FUTEX_OP  syscall_arg__scnprintf_futex_op
 
-static const char *epoll_ctl_ops[] = { [1] = "ADD", "DEL", "MOD", };
-static DEFINE_STRARRAY(epoll_ctl_ops);
+static const char *epoll_ctl_ops[] = { "ADD", "DEL", "MOD", };
+static DEFINE_STRARRAY_OFFSET(epoll_ctl_ops, 1);
 
 static const char *itimers[] = { "REAL", "VIRTUAL", "PROF", };
 static DEFINE_STRARRAY(itimers);
-- 
1.8.1.4


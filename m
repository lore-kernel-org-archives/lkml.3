Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266Ab3JNUMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:12:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39118 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757778Ab3JNUDJ (ORCPT
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
Subject: [PATCH 130/161] perf trace: Prepare the strarray scnprintf method for reuse
Date: Mon, 14 Oct 2013 17:01:59 -0300
Message-Id: <1381780950-25642-131-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Right now when an index passed to that method has no string associated
it'll print the index as a decimal number, prepare it so that we can use
it to print it in hex as well, for ioctls, for instance.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-nsvy06sqj64qvnkmzvwxsx2v@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 7424298b87e3..0d4af1d7e55c 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -60,18 +60,25 @@ struct strarray {
 	.entries = array, \
 }
 
-static size_t syscall_arg__scnprintf_strarray(char *bf, size_t size,
-					      struct syscall_arg *arg)
+static size_t __syscall_arg__scnprintf_strarray(char *bf, size_t size,
+						const char *intfmt,
+					        struct syscall_arg *arg)
 {
 	struct strarray *sa = arg->parm;
 	int idx = arg->val - sa->offset;
 
 	if (idx < 0 || idx >= sa->nr_entries)
-		return scnprintf(bf, size, "%d", arg->val);
+		return scnprintf(bf, size, intfmt, arg->val);
 
 	return scnprintf(bf, size, "%s", sa->entries[idx]);
 }
 
+static size_t syscall_arg__scnprintf_strarray(char *bf, size_t size,
+					      struct syscall_arg *arg)
+{
+	return __syscall_arg__scnprintf_strarray(bf, size, "%d", arg);
+}
+
 #define SCA_STRARRAY syscall_arg__scnprintf_strarray
 
 static size_t syscall_arg__scnprintf_fd(char *bf, size_t size,
-- 
1.8.1.4


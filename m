Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933137Ab3JNUdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:33:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38884 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757640Ab3JNUDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 062/161] perf trace: Beautify access 'mode' arg
Date: Mon, 14 Oct 2013 17:00:51 -0300
Message-Id: <1381780950-25642-63-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Removing the _OK suffix and using RWX when all three bits are set, for
instance.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ypaz9k43lyqy94679feqnv8x@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 2b19aef7d3b5..7aa6bcacd51f 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -312,6 +312,33 @@ static size_t syscall_arg__scnprintf_socket_type(char *bf, size_t size,
 
 #define SCA_SK_TYPE syscall_arg__scnprintf_socket_type
 
+static size_t syscall_arg__scnprintf_access_mode(char *bf, size_t size,
+						 struct syscall_arg *arg)
+{
+	size_t printed = 0;
+	int mode = arg->val;
+
+	if (mode == F_OK) /* 0 */
+		return scnprintf(bf, size, "F");
+#define	P_MODE(n) \
+	if (mode & n##_OK) { \
+		printed += scnprintf(bf + printed, size - printed, "%s", #n); \
+		mode &= ~n##_OK; \
+	}
+
+	P_MODE(R);
+	P_MODE(W);
+	P_MODE(X);
+#undef P_MODE
+
+	if (mode)
+		printed += scnprintf(bf + printed, size - printed, "|%#x", mode);
+
+	return printed;
+}
+
+#define SCA_ACCMODE syscall_arg__scnprintf_access_mode
+
 static size_t syscall_arg__scnprintf_open_flags(char *bf, size_t size,
 					       struct syscall_arg *arg)
 {
@@ -422,7 +449,8 @@ static struct syscall_fmt {
 	bool	   timeout;
 	bool	   hexret;
 } syscall_fmts[] = {
-	{ .name	    = "access",	    .errmsg = true, },
+	{ .name	    = "access",	    .errmsg = true,
+	  .arg_scnprintf = { [1] = SCA_ACCMODE, /* mode */ }, },
 	{ .name	    = "arch_prctl", .errmsg = true, .alias = "prctl", },
 	{ .name	    = "brk",	    .hexret = true,
 	  .arg_scnprintf = { [0] = SCA_HEX, /* brk */ }, },
-- 
1.8.1.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab3JNURG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:17:06 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39073 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757742Ab3JNUDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:08 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 105/161] perf trace: Beautify pipe2 'flags' arg
Date: Mon, 14 Oct 2013 17:01:34 -0300
Message-Id: <1381780950-25642-106-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

 4.234 (0.005 ms): fetchmail/3224 pipe2(fildes: 0x7fffc72bcee0, flags: CLOEXEC) = 0

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-9e1jz78i6q6e0xr9fsitqbpe@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index bf74217be22c..76d9427b4b91 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -517,6 +517,29 @@ static size_t syscall_arg__scnprintf_eventfd_flags(char *bf, size_t size,
 
 #define SCA_EFD_FLAGS syscall_arg__scnprintf_eventfd_flags
 
+static size_t syscall_arg__scnprintf_pipe_flags(char *bf, size_t size,
+						struct syscall_arg *arg)
+{
+	int printed = 0, flags = arg->val;
+
+#define	P_FLAG(n) \
+	if (flags & O_##n) { \
+		printed += scnprintf(bf + printed, size - printed, "%s%s", printed ? "|" : "", #n); \
+		flags &= ~O_##n; \
+	}
+
+	P_FLAG(CLOEXEC);
+	P_FLAG(NONBLOCK);
+#undef P_FLAG
+
+	if (flags)
+		printed += scnprintf(bf + printed, size - printed, "%s%#x", printed ? "|" : "", flags);
+
+	return printed;
+}
+
+#define SCA_PIPE_FLAGS syscall_arg__scnprintf_pipe_flags
+
 static size_t syscall_arg__scnprintf_signum(char *bf, size_t size, struct syscall_arg *arg)
 {
 	int sig = arg->val;
@@ -620,6 +643,8 @@ static struct syscall_fmt {
 	  .arg_scnprintf = { [2] = SCA_OPEN_FLAGS, /* flags */ }, },
 	{ .name	    = "openat",	    .errmsg = true,
 	  .arg_scnprintf = { [2] = SCA_OPEN_FLAGS, /* flags */ }, },
+	{ .name	    = "pipe2",	    .errmsg = true,
+	  .arg_scnprintf = { [1] = SCA_PIPE_FLAGS, /* flags */ }, },
 	{ .name	    = "poll",	    .errmsg = true, .timeout = true, },
 	{ .name	    = "ppoll",	    .errmsg = true, .timeout = true, },
 	{ .name	    = "pread",	    .errmsg = true, .alias = "pread64", },
-- 
1.8.1.4


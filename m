Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351Ab3JNUOF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:14:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39107 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757771Ab3JNUDI (ORCPT
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
Subject: [PATCH 102/161] perf trace: Add helper for syscalls with a single strarray arg
Date: Mon, 14 Oct 2013 17:01:31 -0300
Message-Id: <1381780950-25642-103-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

In such cases just stating the (arg, name, array) is enough, reducing
the size of the syscall formatters table.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-3k53p6dv2sh4ydsc5k5otoia@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 40 +++++++++++++---------------------------
 1 file changed, 13 insertions(+), 27 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 2007c8c2c52b..8855207deae8 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -562,6 +562,10 @@ static size_t syscall_arg__scnprintf_signum(char *bf, size_t size, struct syscal
 
 #define SCA_SIGNUM syscall_arg__scnprintf_signum
 
+#define STRARRAY(arg, name, array) \
+	  .arg_scnprintf = { [arg] = SCA_STRARRAY, }, \
+	  .arg_parm	 = { [arg] = &strarray__##array, }
+
 static struct syscall_fmt {
 	const char *name;
 	const char *alias;
@@ -577,33 +581,23 @@ static struct syscall_fmt {
 	{ .name	    = "brk",	    .hexret = true,
 	  .arg_scnprintf = { [0] = SCA_HEX, /* brk */ }, },
 	{ .name	    = "connect",    .errmsg = true, },
-	{ .name	    = "epoll_ctl",  .errmsg = true,
-	  .arg_scnprintf = { [1] = SCA_STRARRAY, /* op */ },
-	  .arg_parm	 = { [1] = &strarray__epoll_ctl_ops, /* op */ }, },
+	{ .name	    = "epoll_ctl",  .errmsg = true, STRARRAY(1, op, epoll_ctl_ops), },
 	{ .name	    = "eventfd2",   .errmsg = true,
 	  .arg_scnprintf = { [1] = SCA_EFD_FLAGS, /* flags */ }, },
-	{ .name	    = "fcntl",	    .errmsg = true,
-	  .arg_scnprintf = { [1] = SCA_STRARRAY, /* cmd */ },
-	  .arg_parm	 = { [1] = &strarray__fcntl_cmds, /* cmd */ }, },
+	{ .name	    = "fcntl",	    .errmsg = true, STRARRAY(1, cmd, fcntl_cmds), },
 	{ .name	    = "flock",	    .errmsg = true,
 	  .arg_scnprintf = { [1] = SCA_FLOCK, /* cmd */ }, },
 	{ .name	    = "fstat",	    .errmsg = true, .alias = "newfstat", },
 	{ .name	    = "fstatat",    .errmsg = true, .alias = "newfstatat", },
 	{ .name	    = "futex",	    .errmsg = true,
 	  .arg_scnprintf = { [1] = SCA_FUTEX_OP, /* op */ }, },
-	{ .name	    = "getitimer",  .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_STRARRAY, /* which */ },
-	  .arg_parm	 = { [0] = &strarray__itimers, /* which */ }, },
-	{ .name	    = "getrlimit",  .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_STRARRAY, /* resource */ },
-	  .arg_parm	 = { [0] = &strarray__rlimit_resources, /* resource */ }, },
+	{ .name	    = "getitimer",  .errmsg = true, STRARRAY(0, which, itimers), },
+	{ .name	    = "getrlimit",  .errmsg = true, STRARRAY(0, resource, rlimit_resources), },
 	{ .name	    = "ioctl",	    .errmsg = true,
 	  .arg_scnprintf = { [2] = SCA_HEX, /* arg */ }, },
 	{ .name	    = "kill",	    .errmsg = true,
 	  .arg_scnprintf = { [1] = SCA_SIGNUM, /* sig */ }, },
-	{ .name	    = "lseek",	    .errmsg = true,
-	  .arg_scnprintf = { [2] = SCA_STRARRAY, /* whence */ },
-	  .arg_parm	 = { [2] = &strarray__whences, /* whence */ }, },
+	{ .name	    = "lseek",	    .errmsg = true, STRARRAY(2, whence, whences), },
 	{ .name	    = "lstat",	    .errmsg = true, .alias = "newlstat", },
 	{ .name     = "madvise",    .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_HEX,	 /* start */
@@ -629,9 +623,7 @@ static struct syscall_fmt {
 	{ .name	    = "poll",	    .errmsg = true, .timeout = true, },
 	{ .name	    = "ppoll",	    .errmsg = true, .timeout = true, },
 	{ .name	    = "pread",	    .errmsg = true, .alias = "pread64", },
-	{ .name	    = "prlimit64",  .errmsg = true,
-	  .arg_scnprintf = { [1] = SCA_STRARRAY, /* resource */ },
-	  .arg_parm	 = { [1] = &strarray__rlimit_resources, /* resource */ }, },
+	{ .name	    = "prlimit64",  .errmsg = true, STRARRAY(1, resource, rlimit_resources), },
 	{ .name	    = "pwrite",	    .errmsg = true, .alias = "pwrite64", },
 	{ .name	    = "read",	    .errmsg = true, },
 	{ .name	    = "recvfrom",   .errmsg = true,
@@ -642,9 +634,7 @@ static struct syscall_fmt {
 	  .arg_scnprintf = { [2] = SCA_MSG_FLAGS, /* flags */ }, },
 	{ .name	    = "rt_sigaction", .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_SIGNUM, /* sig */ }, },
-	{ .name	    = "rt_sigprocmask", .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_STRARRAY, /* how */ },
-	  .arg_parm	 = { [0] = &strarray__sighow, /* how */ }, },
+	{ .name	    = "rt_sigprocmask",  .errmsg = true, STRARRAY(0, how, sighow), },
 	{ .name	    = "rt_sigqueueinfo", .errmsg = true,
 	  .arg_scnprintf = { [1] = SCA_SIGNUM, /* sig */ }, },
 	{ .name	    = "rt_tgsigqueueinfo", .errmsg = true,
@@ -656,12 +646,8 @@ static struct syscall_fmt {
 	  .arg_scnprintf = { [2] = SCA_MSG_FLAGS, /* flags */ }, },
 	{ .name	    = "sendto",	    .errmsg = true,
 	  .arg_scnprintf = { [3] = SCA_MSG_FLAGS, /* flags */ }, },
-	{ .name	    = "setitimer",  .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_STRARRAY, /* which */ },
-	  .arg_parm	 = { [0] = &strarray__itimers, /* which */ }, },
-	{ .name	    = "setrlimit",  .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_STRARRAY, /* resource */ },
-	  .arg_parm	 = { [0] = &strarray__rlimit_resources, /* resource */ }, },
+	{ .name	    = "setitimer",  .errmsg = true, STRARRAY(0, which, itimers), },
+	{ .name	    = "setrlimit",  .errmsg = true, STRARRAY(0, resource, rlimit_resources), },
 	{ .name	    = "socket",	    .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_STRARRAY, /* family */
 			     [1] = SCA_SK_TYPE, /* type */ },
-- 
1.8.1.4


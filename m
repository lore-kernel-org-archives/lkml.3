Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740Ab3JOF2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:28:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33288 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab3JOF2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:28:00 -0400
Date: Mon, 14 Oct 2013 22:27:24 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-3k53p6dv2sh4ydsc5k5otoia@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace:
  Add helper for syscalls with a single strarray arg
Git-Commit-ID: 453350dd0f0245b91b1e43310f5966fb1c51e7bd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:27:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  453350dd0f0245b91b1e43310f5966fb1c51e7bd
Gitweb:     http://git.kernel.org/tip/453350dd0f0245b91b1e43310f5966fb1c51e7bd
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 20 Sep 2013 12:13:37 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 17:40:44 -0300

perf trace: Add helper for syscalls with a single strarray arg

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
index 2007c8c..8855207 100644
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

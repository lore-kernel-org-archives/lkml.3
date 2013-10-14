Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842Ab3JNU0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:26:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38926 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757664Ab3JNUDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:04 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 059/161] perf trace: Beautify signal number arg in several syscalls
Date: Mon, 14 Oct 2013 17:00:48 -0300
Message-Id: <1381780950-25642-60-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ek8w714ramabyl5jqqvjlbyb@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index ecc83ce99bfe..eb0bbff52b42 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -311,6 +311,51 @@ static size_t syscall_arg__scnprintf_open_flags(char *bf, size_t size,
 
 #define SCA_OPEN_FLAGS syscall_arg__scnprintf_open_flags
 
+static size_t syscall_arg__scnprintf_signum(char *bf, size_t size, struct syscall_arg *arg)
+{
+	int sig = arg->val;
+
+	switch (sig) {
+#define	P_SIGNUM(n) case SIG##n: return scnprintf(bf, size, #n)
+	P_SIGNUM(HUP);
+	P_SIGNUM(INT);
+	P_SIGNUM(QUIT);
+	P_SIGNUM(ILL);
+	P_SIGNUM(TRAP);
+	P_SIGNUM(ABRT);
+	P_SIGNUM(BUS);
+	P_SIGNUM(FPE);
+	P_SIGNUM(KILL);
+	P_SIGNUM(USR1);
+	P_SIGNUM(SEGV);
+	P_SIGNUM(USR2);
+	P_SIGNUM(PIPE);
+	P_SIGNUM(ALRM);
+	P_SIGNUM(TERM);
+	P_SIGNUM(STKFLT);
+	P_SIGNUM(CHLD);
+	P_SIGNUM(CONT);
+	P_SIGNUM(STOP);
+	P_SIGNUM(TSTP);
+	P_SIGNUM(TTIN);
+	P_SIGNUM(TTOU);
+	P_SIGNUM(URG);
+	P_SIGNUM(XCPU);
+	P_SIGNUM(XFSZ);
+	P_SIGNUM(VTALRM);
+	P_SIGNUM(PROF);
+	P_SIGNUM(WINCH);
+	P_SIGNUM(IO);
+	P_SIGNUM(PWR);
+	P_SIGNUM(SYS);
+	default: break;
+	}
+
+	return scnprintf(bf, size, "%#x", sig);
+}
+
+#define SCA_SIGNUM syscall_arg__scnprintf_signum
+
 static struct syscall_fmt {
 	const char *name;
 	const char *alias;
@@ -338,6 +383,8 @@ static struct syscall_fmt {
 	  .arg_parm	 = { [0] = &strarray__itimers, /* which */ }, },
 	{ .name	    = "ioctl",	    .errmsg = true,
 	  .arg_scnprintf = { [2] = SCA_HEX, /* arg */ }, },
+	{ .name	    = "kill",	    .errmsg = true,
+	  .arg_scnprintf = { [1] = SCA_SIGNUM, /* sig */ }, },
 	{ .name	    = "lseek",	    .errmsg = true,
 	  .arg_scnprintf = { [2] = SCA_STRARRAY, /* whence */ },
 	  .arg_parm	 = { [2] = &strarray__whences, /* whence */ }, },
@@ -369,15 +416,25 @@ static struct syscall_fmt {
 	{ .name	    = "pwrite",	    .errmsg = true, .alias = "pwrite64", },
 	{ .name	    = "read",	    .errmsg = true, },
 	{ .name	    = "recvfrom",   .errmsg = true, },
+	{ .name	    = "rt_sigaction", .errmsg = true,
+	  .arg_scnprintf = { [0] = SCA_SIGNUM, /* sig */ }, },
 	{ .name	    = "rt_sigprocmask", .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_STRARRAY, /* how */ },
 	  .arg_parm	 = { [0] = &strarray__sighow, /* how */ }, },
+	{ .name	    = "rt_sigqueueinfo", .errmsg = true,
+	  .arg_scnprintf = { [1] = SCA_SIGNUM, /* sig */ }, },
+	{ .name	    = "rt_tgsigqueueinfo", .errmsg = true,
+	  .arg_scnprintf = { [2] = SCA_SIGNUM, /* sig */ }, },
 	{ .name	    = "select",	    .errmsg = true, .timeout = true, },
 	{ .name	    = "setitimer",  .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_STRARRAY, /* which */ },
 	  .arg_parm	 = { [0] = &strarray__itimers, /* which */ }, },
 	{ .name	    = "socket",	    .errmsg = true, },
 	{ .name	    = "stat",	    .errmsg = true, .alias = "newstat", },
+	{ .name	    = "tgkill",	    .errmsg = true,
+	  .arg_scnprintf = { [2] = SCA_SIGNUM, /* sig */ }, },
+	{ .name	    = "tkill",	    .errmsg = true,
+	  .arg_scnprintf = { [1] = SCA_SIGNUM, /* sig */ }, },
 	{ .name	    = "uname",	    .errmsg = true, .alias = "newuname", },
 };
 
-- 
1.8.1.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466Ab3JOFWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:22:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60981 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758365Ab3JOFVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:21:44 -0400
Date: Mon, 14 Oct 2013 22:21:07 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-ek8w714ramabyl5jqqvjlbyb@git.kernel.org>
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
  Beautify signal number arg in several syscalls
Git-Commit-ID: 8bad5b0abfdbd0866c2b0445fdee8a8c2c38865b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:21:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8bad5b0abfdbd0866c2b0445fdee8a8c2c38865b
Gitweb:     http://git.kernel.org/tip/8bad5b0abfdbd0866c2b0445fdee8a8c2c38865b
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 3 Sep 2013 17:17:15 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 11:10:14 -0300

perf trace: Beautify signal number arg in several syscalls

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
index ecc83ce..eb0bbff 100644
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
 

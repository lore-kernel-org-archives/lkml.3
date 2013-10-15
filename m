Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719Ab3JOF1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:27:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33273 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab3JOF1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:27:50 -0400
Date: Mon, 14 Oct 2013 22:27:15 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-amh3y88kh1nmclpwezqlarl8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Beautify flock 'cmd' arg
Git-Commit-ID: 5cea6ff265e6979226b751f5ebfdda4594322523
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:27:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5cea6ff265e6979226b751f5ebfdda4594322523
Gitweb:     http://git.kernel.org/tip/5cea6ff265e6979226b751f5ebfdda4594322523
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 20 Sep 2013 11:49:50 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 17:37:50 -0300

perf trace: Beautify flock 'cmd' arg

  4735.638 ( 0.003 ms): man/19881 flock(fd: 3, cmd: SH|NB) = 0
  4735.832 ( 0.002 ms): man/19881 flock(fd: 3, cmd: UN   ) = 0

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-amh3y88kh1nmclpwezqlarl8@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 807e542..2007c8c 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -189,6 +189,37 @@ static size_t syscall_arg__scnprintf_madvise_behavior(char *bf, size_t size,
 
 #define SCA_MADV_BHV syscall_arg__scnprintf_madvise_behavior
 
+static size_t syscall_arg__scnprintf_flock(char *bf, size_t size,
+					   struct syscall_arg *arg)
+{
+	int printed = 0, op = arg->val;
+
+	if (op == 0)
+		return scnprintf(bf, size, "NONE");
+#define	P_CMD(cmd) \
+	if ((op & LOCK_##cmd) == LOCK_##cmd) { \
+		printed += scnprintf(bf + printed, size - printed, "%s%s", printed ? "|" : "", #cmd); \
+		op &= ~LOCK_##cmd; \
+	}
+
+	P_CMD(SH);
+	P_CMD(EX);
+	P_CMD(NB);
+	P_CMD(UN);
+	P_CMD(MAND);
+	P_CMD(RW);
+	P_CMD(READ);
+	P_CMD(WRITE);
+#undef P_OP
+
+	if (op)
+		printed += scnprintf(bf + printed, size - printed, "%s%#x", printed ? "|" : "", op);
+
+	return printed;
+}
+
+#define SCA_FLOCK syscall_arg__scnprintf_flock
+
 static size_t syscall_arg__scnprintf_futex_op(char *bf, size_t size, struct syscall_arg *arg)
 {
 	enum syscall_futex_args {
@@ -554,6 +585,8 @@ static struct syscall_fmt {
 	{ .name	    = "fcntl",	    .errmsg = true,
 	  .arg_scnprintf = { [1] = SCA_STRARRAY, /* cmd */ },
 	  .arg_parm	 = { [1] = &strarray__fcntl_cmds, /* cmd */ }, },
+	{ .name	    = "flock",	    .errmsg = true,
+	  .arg_scnprintf = { [1] = SCA_FLOCK, /* cmd */ }, },
 	{ .name	    = "fstat",	    .errmsg = true, .alias = "newfstat", },
 	{ .name	    = "fstatat",    .errmsg = true, .alias = "newfstatat", },
 	{ .name	    = "futex",	    .errmsg = true,

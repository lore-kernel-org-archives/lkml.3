Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab3JNU0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:26:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38948 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757679Ab3JNUDE (ORCPT
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
Subject: [PATCH 101/161] perf trace: Beautify flock 'cmd' arg
Date: Mon, 14 Oct 2013 17:01:30 -0300
Message-Id: <1381780950-25642-102-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
index 807e542da623..2007c8c2c52b 100644
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
-- 
1.8.1.4


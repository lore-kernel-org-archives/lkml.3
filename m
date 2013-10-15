Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823Ab3JOF2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:28:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33329 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758798Ab3JOF2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:28:30 -0400
Date: Mon, 14 Oct 2013 22:27:50 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-9e1jz78i6q6e0xr9fsitqbpe@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Beautify pipe2 'flags' arg
Git-Commit-ID: 46cce19ba8cc8231d3c949c128e4bdaf420228a2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:27:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  46cce19ba8cc8231d3c949c128e4bdaf420228a2
Gitweb:     http://git.kernel.org/tip/46cce19ba8cc8231d3c949c128e4bdaf420228a2
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 23 Sep 2013 12:52:04 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 17:41:24 -0300

perf trace: Beautify pipe2 'flags' arg

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
index bf74217..76d9427 100644
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

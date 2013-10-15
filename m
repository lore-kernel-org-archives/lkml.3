Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962Ab3JOFs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:48:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32851 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758598Ab3JOFW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:22:59 -0400
Date: Mon, 14 Oct 2013 22:22:25 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-3hg8eajdzil077501c8f5jkw@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Beautify eventfd2 'flags' arg
Git-Commit-ID: 49af9e93adfa11d50435aa079299a765843532fc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:22:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  49af9e93adfa11d50435aa079299a765843532fc
Gitweb:     http://git.kernel.org/tip/49af9e93adfa11d50435aa079299a765843532fc
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 12 Sep 2013 12:18:56 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 11:11:21 -0300

perf trace: Beautify eventfd2 'flags' arg

 61.168 ( 0.004 ms): 24267 eventfd2(flags: CLOEXEC|NONBLOCK) = 9

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-3hg8eajdzil077501c8f5jkw@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index c400fbe..8a09ba3 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -13,6 +13,7 @@
 
 #include <libaudit.h>
 #include <stdlib.h>
+#include <sys/eventfd.h>
 #include <sys/mman.h>
 #include <linux/futex.h>
 
@@ -456,6 +457,32 @@ static size_t syscall_arg__scnprintf_open_flags(char *bf, size_t size,
 
 #define SCA_OPEN_FLAGS syscall_arg__scnprintf_open_flags
 
+static size_t syscall_arg__scnprintf_eventfd_flags(char *bf, size_t size,
+						   struct syscall_arg *arg)
+{
+	int printed = 0, flags = arg->val;
+
+	if (flags == 0)
+		return scnprintf(bf, size, "NONE");
+#define	P_FLAG(n) \
+	if (flags & EFD_##n) { \
+		printed += scnprintf(bf + printed, size - printed, "%s%s", printed ? "|" : "", #n); \
+		flags &= ~EFD_##n; \
+	}
+
+	P_FLAG(SEMAPHORE);
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
+#define SCA_EFD_FLAGS syscall_arg__scnprintf_eventfd_flags
+
 static size_t syscall_arg__scnprintf_signum(char *bf, size_t size, struct syscall_arg *arg)
 {
 	int sig = arg->val;
@@ -516,6 +543,8 @@ static struct syscall_fmt {
 	{ .name	    = "brk",	    .hexret = true,
 	  .arg_scnprintf = { [0] = SCA_HEX, /* brk */ }, },
 	{ .name	    = "connect",    .errmsg = true, },
+	{ .name	    = "eventfd2",   .errmsg = true,
+	  .arg_scnprintf = { [1] = SCA_EFD_FLAGS, /* flags */ }, },
 	{ .name	    = "fcntl",	    .errmsg = true,
 	  .arg_scnprintf = { [1] = SCA_STRARRAY, /* cmd */ },
 	  .arg_parm	 = { [1] = &strarray__fcntl_cmds, /* cmd */ }, },

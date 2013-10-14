Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306Ab3JNUfD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:35:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38826 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757624Ab3JNUDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:02 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 068/161] perf trace: Beautify eventfd2 'flags' arg
Date: Mon, 14 Oct 2013 17:00:57 -0300
Message-Id: <1381780950-25642-69-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
index c400fbee1fc7..8a09ba3dcd97 100644
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
-- 
1.8.1.4


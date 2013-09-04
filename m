Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759789Ab3IDSiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 14:38:12 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:61356 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759459Ab3IDSh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 14:37:57 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/3] perf trace: Add beautifier for clock_gettime's clk_id argument
Date: Wed,  4 Sep 2013 12:37:45 -0600
Message-Id: <1378319865-55695-3-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1378319865-55695-1-git-send-email-dsahern@gmail.com>
References: <1378319865-55695-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before:
0.030 ( 0.002 ms): 2571 clock_gettime(which_clock: 1, tp: 0x7f3b45729cd0 ) = 0

After:
0.030 ( 0.002 ms): 2571 clock_gettime(which_clock: MONOTONIC, tp: 0x7f3b45729cd0 ) = 0

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-trace.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index b245102..f943960 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -428,6 +428,37 @@ static size_t syscall_arg__scnprintf_signum(char *bf, size_t size, struct syscal
 
 #define SCA_SIGNUM syscall_arg__scnprintf_signum
 
+static size_t
+syscall_arg__scnprintf_clk_gettime(char *bf, size_t size,
+				   struct syscall_arg *arg)
+{
+	size_t printed = 0;
+	clockid_t clk_id = arg->val;
+
+	switch (clk_id) {
+#define	P_CLOCK_ID(n) case CLOCK_##n: printed = scnprintf(bf, size, #n);
+	P_CLOCK_ID(REALTIME);		break;
+#ifdef CLOCK_REALTIME_COARSE
+	P_CLOCK_ID(REALTIME_COARSE);	break;
+#endif
+	P_CLOCK_ID(MONOTONIC);		break;
+#ifdef CLOCK_MONOTONIC_RAW
+	P_CLOCK_ID(MONOTONIC_RAW);	break;
+#endif
+#ifdef CLOCK_MONOTONIC_COARSE
+	P_CLOCK_ID(MONOTONIC_COARSE);	break;
+#endif
+	P_CLOCK_ID(PROCESS_CPUTIME_ID);	break;
+	P_CLOCK_ID(THREAD_CPUTIME_ID);	break;
+#undef P_CLOCK_ID
+	default: printed = scnprintf(bf, size, "%#x", arg); break;
+	}
+
+	return printed;
+}
+
+#define SCA_CLOCK_ID syscall_arg__scnprintf_clk_gettime
+
 static struct syscall_fmt {
 	const char *name;
 	const char *alias;
@@ -442,6 +473,8 @@ static struct syscall_fmt {
 	{ .name	    = "arch_prctl", .errmsg = true, .alias = "prctl", },
 	{ .name	    = "brk",	    .hexret = true,
 	  .arg_scnprintf = { [0] = SCA_HEX, /* brk */ }, },
+	{ .name	    = "clock_gettime", .errmsg = true,
+	  .arg_scnprintf = { [0] = SCA_CLOCK_ID, /* clk_id */ }, },
 	{ .name	    = "connect",    .errmsg = true, },
 	{ .name	    = "fcntl",	    .errmsg = true,
 	  .arg_scnprintf = { [1] = SCA_STRARRAY, /* cmd */ },
-- 
1.7.10.1


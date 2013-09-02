Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759097Ab3IBU5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 16:57:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48881 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759059Ab3IBU46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 16:56:58 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 09/10] perf trace: Add beautifier for open's flags arg
Date: Mon,  2 Sep 2013 17:56:32 -0300
Message-Id: <1378155393-7993-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378155393-7993-1-git-send-email-acme@infradead.org>
References: <1378155393-7993-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Suppressing the mode when O_CREAT not present, needs improvements on the
arg masking mechanism to be reused in openat, open_by_handle_at,
mq_open:

[root@zoo ~]# perf trace -a -e open | grep -v 'flags: RDONLY' | head -5
   147.541 ( 0.028 ms): 1188 open(filename: 0x33c17782fb, flags: CLOEXEC   ) = 23
   229.898 ( 0.020 ms): 2071 open(filename: 0x3d93c80, flags: NOATIME      ) = -1 EPERM Operation not permitted

[root@zoo ~]# perf trace -a -e open | grep CREAT
  1406.697 ( 0.024 ms): 616 open(filename: 0x7fffc3a0f910, flags: CREAT|TRUNC|WRONLY, mode: 438 ) = -1 ENOENT No such file or directory
  2032.770 ( 0.804 ms): 4354 open(filename: 0x7f33ac814368, flags: CREAT|EXCL|RDWR, mode: 384   ) = 115
^C[root@zoo ~]#

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-c7vm6klaf995qw1vqdih5t7q@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 59 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 58 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 02aaea6..5b6b287 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -206,6 +206,62 @@ static size_t syscall_arg__scnprintf_futex_op(char *bf, size_t size, unsigned lo
 
 #define SCA_FUTEX_OP  syscall_arg__scnprintf_futex_op
 
+static size_t syscall_arg__scnprintf_open_flags(char *bf, size_t size,
+					       unsigned long arg, u8 *arg_mask)
+{
+	int printed = 0, flags = arg;
+
+	if (!(flags & O_CREAT))
+		*arg_mask |= 1 << 2; /* Mask the mode parm */
+
+	if (flags == 0)
+		return scnprintf(bf, size, "RDONLY");
+#define	P_FLAG(n) \
+	if (flags & O_##n) { \
+		printed += scnprintf(bf + printed, size - printed, "%s%s", printed ? "|" : "", #n); \
+		flags &= ~O_##n; \
+	}
+
+	P_FLAG(APPEND);
+	P_FLAG(ASYNC);
+	P_FLAG(CLOEXEC);
+	P_FLAG(CREAT);
+	P_FLAG(DIRECT);
+	P_FLAG(DIRECTORY);
+	P_FLAG(EXCL);
+	P_FLAG(LARGEFILE);
+	P_FLAG(NOATIME);
+	P_FLAG(NOCTTY);
+#ifdef O_NONBLOCK
+	P_FLAG(NONBLOCK);
+#elif O_NDELAY
+	P_FLAG(NDELAY);
+#endif
+#ifdef O_PATH
+	P_FLAG(PATH);
+#endif
+	P_FLAG(RDWR);
+#ifdef O_DSYNC
+	if ((flags & O_SYNC) == O_SYNC)
+		printed += scnprintf(bf + printed, size - printed, "%s%s", printed ? "|" : "", "SYNC");
+	else {
+		P_FLAG(DSYNC);
+	}
+#else
+	P_FLAG(SYNC);
+#endif
+	P_FLAG(TRUNC);
+	P_FLAG(WRONLY);
+#undef P_FLAG
+
+	if (flags)
+		printed += scnprintf(bf + printed, size - printed, "%s%#x", printed ? "|" : "", flags);
+
+	return printed;
+}
+
+#define SCA_OPEN_FLAGS syscall_arg__scnprintf_open_flags
+
 static struct syscall_fmt {
 	const char *name;
 	const char *alias;
@@ -244,7 +300,8 @@ static struct syscall_fmt {
 			     [4] = SCA_HEX, /* new_addr */ }, },
 	{ .name	    = "munmap",	    .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_HEX, /* addr */ }, },
-	{ .name	    = "open",	    .errmsg = true, },
+	{ .name	    = "open",	    .errmsg = true,
+	  .arg_scnprintf = { [1] = SCA_OPEN_FLAGS, /* flags */ }, },
 	{ .name	    = "poll",	    .errmsg = true, .timeout = true, },
 	{ .name	    = "ppoll",	    .errmsg = true, .timeout = true, },
 	{ .name	    = "pread",	    .errmsg = true, .alias = "pread64", },
-- 
1.8.1.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759054Ab3IBU4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 16:56:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48844 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758990Ab3IBU4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 16:56:49 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 02/10] perf trace: Add beautifier for futex 'operation' parm
Date: Mon,  2 Sep 2013 17:56:25 -0300
Message-Id: <1378155393-7993-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378155393-7993-1-git-send-email-acme@infradead.org>
References: <1378155393-7993-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

That uses the arg mask mechanism just introduced to suppress ignored
arguments according to the futex operation.

Based on an initial patch from David Ahern that showed the need for some
way to allow args to tell how many further args should be shown.

Initial-patch-by: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-0k30it46r4hv5eanefbdmj5t@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 47 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index c29692a..1a6cb74 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -14,6 +14,7 @@
 #include <libaudit.h>
 #include <stdlib.h>
 #include <sys/mman.h>
+#include <linux/futex.h>
 
 static size_t syscall_arg__scnprintf_hex(char *bf, size_t size,
 					 unsigned long arg, u8 *arg_mask __maybe_unused)
@@ -137,6 +138,49 @@ static size_t syscall_arg__scnprintf_madvise_behavior(char *bf, size_t size,
 
 #define SCA_MADV_BHV syscall_arg__scnprintf_madvise_behavior
 
+static size_t syscall_arg__scnprintf_futex_op(char *bf, size_t size, unsigned long arg, u8 *arg_mask)
+{
+	enum syscall_futex_args {
+		SCF_UADDR   = (1 << 0),
+		SCF_OP	    = (1 << 1),
+		SCF_VAL	    = (1 << 2),
+		SCF_TIMEOUT = (1 << 3),
+		SCF_UADDR2  = (1 << 4),
+		SCF_VAL3    = (1 << 5),
+	};
+	int op = arg;
+	int cmd = op & FUTEX_CMD_MASK;
+	size_t printed = 0;
+
+	switch (cmd) {
+#define	P_FUTEX_OP(n) case FUTEX_##n: printed = scnprintf(bf, size, #n);
+	P_FUTEX_OP(WAIT);	    *arg_mask |= SCF_VAL3|SCF_UADDR2;		  break;
+	P_FUTEX_OP(WAKE);	    *arg_mask |= SCF_VAL3|SCF_UADDR2|SCF_TIMEOUT; break;
+	P_FUTEX_OP(FD);		    *arg_mask |= SCF_VAL3|SCF_UADDR2|SCF_TIMEOUT; break;
+	P_FUTEX_OP(REQUEUE);	    *arg_mask |= SCF_VAL3|SCF_TIMEOUT;	          break;
+	P_FUTEX_OP(CMP_REQUEUE);    *arg_mask |= SCF_TIMEOUT;			  break;
+	P_FUTEX_OP(CMP_REQUEUE_PI); *arg_mask |= SCF_TIMEOUT;			  break;
+	P_FUTEX_OP(WAKE_OP);							  break;
+	P_FUTEX_OP(LOCK_PI);	    *arg_mask |= SCF_VAL3|SCF_UADDR2|SCF_TIMEOUT; break;
+	P_FUTEX_OP(UNLOCK_PI);	    *arg_mask |= SCF_VAL3|SCF_UADDR2|SCF_TIMEOUT; break;
+	P_FUTEX_OP(TRYLOCK_PI);	    *arg_mask |= SCF_VAL3|SCF_UADDR2;		  break;
+	P_FUTEX_OP(WAIT_BITSET);    *arg_mask |= SCF_UADDR2;			  break;
+	P_FUTEX_OP(WAKE_BITSET);    *arg_mask |= SCF_UADDR2;			  break;
+	P_FUTEX_OP(WAIT_REQUEUE_PI);						  break;
+	default: printed = scnprintf(bf, size, "%#x", cmd);			  break;
+	}
+
+	if (op & FUTEX_PRIVATE_FLAG)
+		printed += scnprintf(bf + printed, size - printed, "|PRIV");
+
+	if (op & FUTEX_CLOCK_REALTIME)
+		printed += scnprintf(bf + printed, size - printed, "|CLKRT");
+
+	return printed;
+}
+
+#define SCA_FUTEX_OP  syscall_arg__scnprintf_futex_op
+
 static struct syscall_fmt {
 	const char *name;
 	const char *alias;
@@ -153,7 +197,8 @@ static struct syscall_fmt {
 	{ .name	    = "connect",    .errmsg = true, },
 	{ .name	    = "fstat",	    .errmsg = true, .alias = "newfstat", },
 	{ .name	    = "fstatat",    .errmsg = true, .alias = "newfstatat", },
-	{ .name	    = "futex",	    .errmsg = true, },
+	{ .name	    = "futex",	    .errmsg = true,
+	  .arg_scnprintf = { [1] = SCA_FUTEX_OP, /* op */ }, },
 	{ .name	    = "ioctl",	    .errmsg = true,
 	  .arg_scnprintf = { [2] = SCA_HEX, /* arg */ }, },
 	{ .name	    = "lstat",	    .errmsg = true, .alias = "newlstat", },
-- 
1.8.1.4


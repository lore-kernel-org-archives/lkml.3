Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759632Ab3ICHQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 03:16:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36029 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759611Ab3ICHQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 03:16:11 -0400
Date: Tue, 3 Sep 2013 00:15:06 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-0k30it46r4hv5eanefbdmj5t@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Add beautifier for futex 'operation'
  parm
Git-Commit-ID: f9da0b0c74af25a68b9ac43a2c81f2eea970de5a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 03 Sep 2013 00:15:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f9da0b0c74af25a68b9ac43a2c81f2eea970de5a
Gitweb:     http://git.kernel.org/tip/f9da0b0c74af25a68b9ac43a2c81f2eea970de5a
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 2 Sep 2013 13:46:44 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 2 Sep 2013 14:58:19 -0300

perf trace: Add beautifier for futex 'operation' parm

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

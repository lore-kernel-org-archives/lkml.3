Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab3H2KKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 06:10:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35205 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756574Ab3H2KKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 06:10:37 -0400
Date: Thu, 29 Aug 2013 03:09:56 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-q1ubhdd9wigxneam616ggdsn@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Add beautifier for mmap prot parm
Git-Commit-ID: ae685380b9a1ffe5e1935852ec11f0aa38b1d77b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 29 Aug 2013 03:10:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ae685380b9a1ffe5e1935852ec11f0aa38b1d77b
Gitweb:     http://git.kernel.org/tip/ae685380b9a1ffe5e1935852ec11f0aa38b1d77b
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 20 Aug 2013 17:44:42 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 26 Aug 2013 17:26:00 -0300

perf trace: Add beautifier for mmap prot parm

[root@zoo ~]# perf trace -e mmap,mprotect sleep 1
     0.984 ( 0.015 ms): mmap(addr: 0, len: 4096, prot: READ|WRITE, flags: 34, fd: 4294967295, off: 0) = 0xd62ae000
     1.114 ( 0.016 ms): mmap(addr: 0, len: 125100, prot: READ, flags: 2, fd: 3, off: 0        ) = 0xd628f000
     1.252 ( 0.020 ms): mmap(addr: 0x33c1600000, len: 3896312, prot: EXEC|READ, flags: 2050, fd: 3, off: 0) = 0xc1600000
     1.282 ( 0.024 ms): mprotect(start: 0x33c17ad000, len: 2097152, prot: NONE                ) = 0
     1.315 ( 0.026 ms): mmap(addr: 0x33c19ad000, len: 24576, prot: READ|WRITE, flags: 2066, fd: 3, off: 1757184) = 0xc19ad000
     1.352 ( 0.017 ms): mmap(addr: 0x33c19b3000, len: 17400, prot: READ|WRITE, flags: 50, fd: 4294967295, off: 0) = 0xc19b3000
     1.415 ( 0.011 ms): mmap(addr: 0, len: 4096, prot: READ|WRITE, flags: 34, fd: 4294967295, off: 0) = 0xd628e000
     1.440 ( 0.011 ms): mmap(addr: 0, len: 8192, prot: READ|WRITE, flags: 34, fd: 4294967295, off: 0) = 0xd628c000
     1.569 ( 0.019 ms): mprotect(start: 0x606000, len: 4096, prot: READ                       ) = 0
     1.591 ( 0.017 ms): mprotect(start: 0x33c19ad000, len: 16384, prot: READ                  ) = 0
     1.616 ( 0.016 ms): mprotect(start: 0x33c1420000, len: 4096, prot: READ                   ) = 0
     2.105 ( 0.018 ms): mmap(addr: 0, len: 104789808, prot: READ, flags: 2, fd: 3, off: 0     ) = 0xcfe9c000
[root@zoo ~]#

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-q1ubhdd9wigxneam616ggdsn@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 41 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 60ee811..81c20a6 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -11,6 +11,7 @@
 
 #include <libaudit.h>
 #include <stdlib.h>
+#include <sys/mman.h>
 
 static size_t syscall_arg__scnprintf_hex(char *bf, size_t size, unsigned long arg)
 {
@@ -19,6 +20,36 @@ static size_t syscall_arg__scnprintf_hex(char *bf, size_t size, unsigned long ar
 
 #define SCA_HEX syscall_arg__scnprintf_hex
 
+static size_t syscall_arg__scnprintf_mmap_prot(char *bf, size_t size, unsigned long arg)
+{
+	int printed = 0, prot = arg;
+
+	if (prot == PROT_NONE)
+		return scnprintf(bf, size, "NONE");
+#define	P_MMAP_PROT(n) \
+	if (prot & PROT_##n) { \
+		printed += scnprintf(bf + printed, size - printed, "%s%s", printed ? "|" : "", #n); \
+		prot &= ~PROT_##n; \
+	}
+
+	P_MMAP_PROT(EXEC);
+	P_MMAP_PROT(READ);
+	P_MMAP_PROT(WRITE);
+#ifdef PROT_SEM
+	P_MMAP_PROT(SEM);
+#endif
+	P_MMAP_PROT(GROWSDOWN);
+	P_MMAP_PROT(GROWSUP);
+#undef P_MMAP_PROT
+
+	if (prot)
+		printed += scnprintf(bf + printed, size - printed, "%s%#x", printed ? "|" : "", prot);
+
+	return printed;
+}
+
+#define SCA_MMAP_PROT syscall_arg__scnprintf_mmap_prot
+
 static struct syscall_fmt {
 	const char *name;
 	const char *alias;
@@ -40,10 +71,14 @@ static struct syscall_fmt {
 	  .arg_scnprintf = { [2] = SCA_HEX, /* arg */ }, },
 	{ .name	    = "lstat",	    .errmsg = true, .alias = "newlstat", },
 	{ .name	    = "mmap",	    .hexret = true,
-	  .arg_scnprintf = { [0] = SCA_HEX, /* addr */ }, },
+	  .arg_scnprintf = { [0] = SCA_HEX,	  /* addr */
+			     [2] = SCA_MMAP_PROT, /* prot */ }, },
 	{ .name	    = "mprotect",   .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_HEX, /* addr */ }, },
-	{ .name	    = "mremap",	    .hexret = true, },
+	  .arg_scnprintf = { [0] = SCA_HEX, /* start */
+			     [2] = SCA_MMAP_PROT, /* prot */ }, },
+	{ .name	    = "mremap",	    .hexret = true,
+	  .arg_scnprintf = { [0] = SCA_HEX, /* addr */
+			     [4] = SCA_HEX, /* new_addr */ }, },
 	{ .name	    = "munmap",	    .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_HEX, /* addr */ }, },
 	{ .name	    = "open",	    .errmsg = true, },
